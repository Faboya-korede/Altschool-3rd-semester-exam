#Terraform backend to store state  files 
terraform {
 backend "s3" {
   region = "us-east-1"
   bucket =  "terrafrom.tfstate2023"
   key    = "terrafform/korede/state.tfstate"
 }
}

