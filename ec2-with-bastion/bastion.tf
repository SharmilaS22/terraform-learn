# EC2 instance bastion host
# -----------
resource "aws_instance" "sharmi_instance" {
  ami                         = "ami-00c39f71452c08778"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.sh_sg_for_bastion.id]
  subnet_id                   = aws_subnet.sh_subnet_1a.id
  associate_public_ip_address = true
  key_name                    = "sharmi-kp"
  tags = {
    Name = "Bastion Host_Sh"
  }
}