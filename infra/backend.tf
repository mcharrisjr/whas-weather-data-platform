terraform {
  backend "s3" {
    bucket  = "mharris-tf-state-597341305438-us-east-1-an"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
