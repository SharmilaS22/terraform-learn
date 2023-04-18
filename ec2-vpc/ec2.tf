# Security group
variable "sg_ports" {
  type    = list(number)
  default = [22, 80, 443]
}
resource "aws_security_group" "sh_sg" {
  name   = "sharmi-sg"
  vpc_id = aws_vpc.sh_main.id

  # 22 - SSH, 80 - HTTP, 443 - HTTPS
  # ingress {
  #   description      = "Allow https request from anywhere"
  #   protocol         = "tcp"
  #   from_port        = 443 # range of 
  #   to_port          = 443 # port numbers
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      description      = "Allow https request from anywhere"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2
resource "aws_instance" "sharmi_instance" {
  ami                         = "ami-00c39f71452c08778"
  instance_type               = "t2.micro"
  associate_public_ip_address = true #have to learn
  subnet_id                   = aws_subnet.sh_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.sh_sg.id]
  user_data                   = filebase64("user_data.sh")
  key_name                    = "sharmi-kp"
}
