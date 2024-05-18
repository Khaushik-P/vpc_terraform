terraform {
  backend "s3" {
    bucket = "kplabs-terraform-bucket"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}
