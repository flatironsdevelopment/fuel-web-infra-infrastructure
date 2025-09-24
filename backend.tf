terraform {
  backend "s3" {
    bucket = "fuel-web-infra-infrastructure-tf"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}