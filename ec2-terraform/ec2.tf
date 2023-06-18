# EC2 instance standalone
# -----------
# resource "aws_instance" "sharmi_instance" {
#   ami           = "ami-00c39f71452c08778"
#   instance_type = "t2.micro"
# }
# -----------

# ASG with Launch template
resource "aws_launch_template" "sh_ec2_launch_templ" {
  name_prefix   = "sh_ec2_launch_templ"
  image_id      = "ami-00c39f71452c08778" #specific for each region
  instance_type = "t2.micro"
  user_data     = filebase64("user_data.sh")
  # key_name = "sharmi-kp"
  network_interfaces {
    security_groups             = [aws_security_group.sh_sg_for_ec2.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Sharmi-instance"
    }
  }
}

resource "aws_autoscaling_group" "sh_asg" {
  # no of instances
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  # source
  target_group_arns = [aws_lb_target_group.sh_alb_tg.arn]

  vpc_zone_identifier = [ # use private subnet
    aws_subnet.sh_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.sh_ec2_launch_templ.id
    version = "$Latest"
  }
}