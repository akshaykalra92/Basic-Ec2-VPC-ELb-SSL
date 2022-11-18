 resource "aws_key_pair" "generated_key" {
   key_name   = var.key_name
   public_key = tls_private_key.key.public_key_openssh

   provisioner "local-exec" {    # Generate "terraform-key-pair.pem" in current directory
     command = <<-EOT
      echo '${tls_private_key.key.private_key_pem}' > ./'${var.key_name}'.pem
      chmod 400 ./'${var.key_name}'.pem
    EOT
   }
 }

resource "aws_instance" "app-server1" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_ami.id
  vpc_security_group_ids = [aws_security_group.http-sg.id]
  count                  = "${length(var.public_subnets_cidr)}"
  subnet_id              = "${element(aws_subnet.public-1a.*.id, count.index)}"
  key_name               = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp3"
    volume_size = "30"
    tags = {
      Name = "app-server-1"
    }
  }
  ebs_block_device{
    device_name = "/dev/sdf"
    volume_size = 500
    volume_type = "st1"
  }
    tags = {
      Name = "app-server-1"
    }
  user_data = file("user_data/user_data.tpl")
}