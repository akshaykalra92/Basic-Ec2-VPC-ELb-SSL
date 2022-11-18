terraform {
  backend "s3" {
    bucket         = "s3-tf-statefile"
    encrypt        = true
    key            = "aws-elb-ec2-terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}