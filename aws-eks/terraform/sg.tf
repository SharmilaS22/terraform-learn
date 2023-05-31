resource "aws_security_group" "sh_sg" {
  name   = "sharmi-sg"
  vpc_id = aws_vpc.sh_main.id

  # allow http(80) and https(443)
  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      description      = "Allow all request from anywhere"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # egress = [{}, {}] //define multiple by this
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # create another sg for instance with only ssh

  # 22 - SSH, 80 - HTTP, 443 - HTTPS
  #   ingress {
  #     description      = "Allow https request from anywhere"
  #     protocol         = "tcp"
  #     from_port        = 80 # range of 
  #     to_port          = 80 # port numbers
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = ["::/0"]
  #   }
  # egress {}

}