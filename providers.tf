# This is the /mtc-control/providers.tf file

terraform {
    required_providers {
        github = {
        # github provider
            source = "integrations/github"
        }
        
        tfe = {
        # terraform enterprise provider
            source = "hashicorp/tfe"
        }
    }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs
provider "github" {
    token = var.github_token
    owner = var.github_owner
}

# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs
provider "tfe" {
    token = var.tfe_token
}

