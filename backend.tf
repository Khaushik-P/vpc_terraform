terraform {
  backend "s3" {
    bucket = "terraform-bucket"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}
