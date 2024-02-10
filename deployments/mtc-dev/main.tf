# This is  mtc-control/deployments/mtc-dev/main.tf

# The configuration below was created (generated) from the terraform cloud configuration designer as a component of the 
# registry and the compute and networking modules.  This file was auto-created by the configuration designer after adding 
# the compute module and networking module and then supplying the
# required variables.  This file is being added as main.tf in mtc-control/deployments/mtc-dev/ as part of the terraform CI/CD project
# workspace on Cloud9 IDE
# Note the source below: this file will actually be executed on terraform cloud (it will be pushed from Cloud9 IDE to a git deployment repo
# which will have an oAuth link to terraform cloud.). It will be pushed to a deployment workspace on terraform cloud. This deployment workspace
# will execute the networking and compute modules in the terraform cloud (already there) per the terraform code below...


//--------------------------------------------------------------------
// Variables



//--------------------------------------------------------------------
// Modules
module "compute" {
  source  = "app.terraform.io/course7_terraform_adv_AWS_org/compute/aws"
  # the module is in terraform cloud in registry modules for the org above
  
  #version = "1.0.0"
  # change the tag version from 1.0.0 to 1.0.1 to reflect the change in the source code that we did in Cloud9 and the github repo.
  # the tagged chnges have been pushed to the terraform cloud module but we need to change it here so that the confnig designer main.tf
  # deploys the correct compute module version to AWS.
  #version = "1.0.1"
  
  # change the tag version from 1.0.1 to 1.0.2 to refelct change in source code that we did in Cloud9 and github repo tag.
  # The tagged delta has been pushed to terraform cloud module and it needs to be changed here so that config designer main.tf
  # deploys the correct compute module version with instance count of 3 to AWS
  #version = "1.0.2"
  
  # 3 count would need a public subnet added. We only have 2 public subnets so decrease to count of 2
  version = "1.0.4"

  aws_region = "us-east-1"
  
  # the public key below is keyaws2.pub
  #public_key_material = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCMYp+cg+iK2bkYPDSau7F5lCjMwuWNk4VVAtEw2qJGAUC0a9hErMG/dOt1Ct/S+G1jninr9iVfy12vEo8pi3wiusw/+4lVIV5KMrI3psMjRnpQRRB4TxFlzTKQ7bYtftt6f78UyQ9CyvmFnxBFeKTDOcT9mxK0IlvmzOdtEVbDqmm5/DYx6TXT3Il+c+3zMZhZruU6C1b/3/mjKkSbYu4cCflsV07q7v0fz9EmDIi0RtUSPDv32Am8sL0OHfTPzqnWuPgNs4Q/go/tq4Fvq73ijO0Vqu5mF0Z8JYIy3PooyBmlrj9XBDUF+BgJsV3TThD7YRJNqTgfYjKw0ofjJZh3aZSKIW8sPcZFky+dr+3eOQqLLk5Eo292J4Ti5MkRhaFHB+5kiy9gnNILRaOn8kj0R7q1U/OPNpoa6wBbSIx6DLvTWcH3WXcNy5DCEPWK8FGQBTLug31b7ICu7jBiuOVdqckqro4Z2WATad6UuST5THBwwDV542t8N27U0htSuMs= ubuntu@ip-172-31-11-176"
  # the new key below is newkey.pub to run a test
  public_key_material = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpYK+Bfl1s29Eps8vZYKrC0uWM5MKuK4hbkg5KNOK4i/wMDOA2P+ZdUvfI0IMnkZIHH20dKIe67PBDlVSotvLXidlWxDdRvlLPdU5RSv4CRsYsiK//Teot1r34GE2m+hDk1zJ2Vn+KSRmubSw5ULhvRHX/X4T/81j61vq0ENOozV43ef686Gb+daHcI255d3xIjBC1lYQSc44h3qoTdZnAtiLSHyR6O90hCFauHQO+PnECJpAGKYTY8PtTuSKa+5bA26+2WK/9tk4bWDvZXrNCmIj1NgCcui8GS9vk9rdJX+GBpUDI6pto8eOGyh1cHJOLg6u0POz+8jaMTu4ksZjSDHdg5M/byK9NmJ70odQxLTpi+MU/M/vKaoSZ6JPrgXoY+c5UznDcxONqUMRRpPavRw9Fo+SSteG1wyZpBqKtTsw+Fu1k1tUaREJ8FA1GZVeXfgfYVwraPI8P70Wf9aiTiaQxJn0XiCMLdzsbGCQwrrbeukixzGQeSvwNV3ZKEMU= ubuntu@ip-172-31-11-176"
  
  public_sg = "${module.networking.public_sg}"
  # NOTE: when adding these variables in configuration designer in terraform cloud, this is why we used interoplation syntax with ${} 
  # Otherwise the above would have been put directly in quotes.
  public_subnets = "${module.networking.public_subnets}"
}

module "networking" {
  source  = "app.terraform.io/course7_terraform_adv_AWS_org/networking/aws"
  # the module is in terraform cloud in registry modules for the org above
  version = "1.0.0"

  access_ip = "0.0.0.0/0"
  aws_region = "us-east-1"
}