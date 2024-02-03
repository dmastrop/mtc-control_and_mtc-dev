# This is mtc-control/main.tf.  Terraform has been intialized in this directory and can be run locally in Cloud9 IDE


# add a locals block
locals {
    aws_creds = {
        AWS_ACCESS_KEY_ID = var.aws_access_key_id
        AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
        # note that the CAPS are only used here for the aws_creds.  The local.aws_creds is what is passed to the terraform cloud runners via
        # the tfe provider in providers.tf via the resource "tfe_variable" "aws_creds"  below.
    }
    
    organization = "course7_terraform_adv_AWS_org"
    # my terraform cloud org is the above.
}

# https://registry.terraform.io/providers/integrations/github/latest/docs
# We will use the github provider to create the github deployment repo on github with the /mtc-control/deployments/mtc-dev/main.tf 
# terraform file that will eventually get pushed to a deploymetn workspace on terraform cloud!
# This main.tf will deploy the compute and networking mmodules on terraform cloud to AWS

resource "github_repository" "mtc_repo" {
    name = "mtc-dev-repo"
    description  = "VPC and compute resource deployment repo initiated by terraform"
    auto_init = true
    # it will automatically be initialized on creation
    license_template = "mit"
    
    visibility = "public"
    # I will make mine public.
}

# Next set a default branch
resource "github_branch_default" "default" {
    repository = github_repository.mtc_repo.name
    # this will reference the repo above.
    branch = "main"
}

# Next add the configuration designer main.tf file that was created in terraform cloud. This is in 
# the mtc-control/deployments/mtc-dev/main.tf
resource "github_repository_file" "main_terraform_deployment_file" {
# note cannot use "main.tf" as the name. But that is what this github repo is for, to put main.tf onto it....
    repository = github_repository.mtc_repo.name
    branch = "main"
    file = "main.tf"
    #this is the name of the file as it will be named in the repo and NOT the location of the file
    content = file("./deployments/mtc-dev/main.tf")
    # this main.tf is 2 directories down from the location of this main.tf.  NOTE that this main.tf is to deploy the githhub repo
    # the main.tf that will be placed into this github repo referred to above is the deployment main.tf that will deploy the compute and
    # networking modules from terraform cloud to AWS!!!
    commit_message = "Github deployment repo that is managed by terraform"
    commit_author = "dave mastropolo"
    commit_email = "dave.mastropolo@gmail.com"
    overwrite_on_create = true
    # this will allow overwrites on the main.tf so that we can perform several runs
}


resource "tfe_oauth_client" "mtc_oauth" {
# this oAuth will permit terrafrom cloud to authenticate with github. This is what we did when addubg a VC provider at the org level in 
# terrafrom cloud. We essaentially added authentication between github as the VC provider and terraform cloud
# Here we are doing this strictly through terraform tf file.  This is what permits our deployment workspace on terraform cloud (see next resource below)
# to communicate with github, specifically the deployment github repo that has the composer main.tf which will deploy the compute and networking
# modules that are accessible in the terraform cloud org.
    organization = local.organization
    # this is defined in the locals block at the start of this main.tf file. See above
    api_url = "https://api.github.com"
    http_url = "https://github.com"
    oauth_token = var.github_token
    service_provider = "github"
}

# Next need to attach the github as a client to the terraform cloud workspace (a deployment workspace that will host the main.tf file in 
# mtc-control/deployments/mtc-dev/main.tf)
resource "tfe_workspace" "mtc_workspace" {
    name = github_repository.mtc_repo.name
    # the name create a dependency so that we do not get the terraform cloud workspace being creatd prior to the github repo
    organization = local.organization
    vcs_repo {
        identifier = "${var.github_owner}/${github_repository.mtc_repo.name}"
        # this is basically dmastrop/<the full repo name> = dmastrop/mtc-dev-repo
        oauth_token_id = tfe_oauth_client.mtc_oauth.oauth_token_id
        # this is from the resource right above this
        # we need the _id and not the .id
        # https://registry.terraform.io/providers/hashicorp/tfe/latest/docs
    }
}

# Need env vars so that the terraform cloud runners can authenticate with AWS
resource "tfe_variable" "aws_creds" {
    for_each = local.aws_creds
    # see locals block above
    key = each.key
    value = each.value
    category = "env"
    sensitive = true
    workspace_id = tfe_workspace.mtc_workspace.id
    description = "AWS credentials"
}