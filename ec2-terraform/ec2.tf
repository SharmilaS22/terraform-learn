# EC2

# resource "aws_instance" "sharmi_instance" {
#   ami           = "ami-00c39f71452c08778"
#   instance_type = "t2.micro"
# }

# ec2, vpc

# ASG with Launch template
resource "aws_launch_template" "sh_ec2_launch_templ" {
  name_prefix   = "sh_ec2_launch_templ"
  image_id      = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  user_data     = filebase64("user_data.sh")
  # user_data = file("user_data.sh")
  key_name = "sharmi-kp"
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sh_sg.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Sharmi-instance"
    }
  }
}

resource "aws_autoscaling_group" "sh_asg" {
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  target_group_arns = [aws_lb_target_group.sh_alb_tg.arn]

  vpc_zone_identifier = [
    aws_subnet.sh_subnet_1.id,
    aws_subnet.sh_subnet_1a.id
  ]

  launch_template {
    id      = aws_launch_template.sh_ec2_launch_templ.id
    version = "$Latest"
  }
}