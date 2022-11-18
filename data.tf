data "aws_subnet_ids" "Public" {
  vpc_id = aws_vpc.resource.id
  filter {
    name   = "tag:Name"
    values = ["Application-1-public-1a"]
  }
  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }
}

data "aws_ami" "amazon_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20220606.1-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["amazon"]
}