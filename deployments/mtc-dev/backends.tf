# This is the mtc-control/deployments/mtc-dev/backends.tf file

terraform {
    backend "remote" {
        organization = "course7_terraform_adv_AWS_org"
        # this is my terraform cloud org for this project. This org has several different workspaces in it, and has the 
        # workspace mtc-dev-repo workspace used for communicating with the mtc-dev github repo and has the config designer main.tf
        # that actually deploys the compute and networking modules in the same org.
        
        workspaces {
            name = "mtc-dev-repo"
            # This is the actual workspace that is cxreated when terraform apply in the mtc-control directory of this Cloud9 project workspace
        }
    }
}