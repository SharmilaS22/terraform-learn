resource "aws_launch_template" "sh_ec2_launch_templ" {
  name_prefix   = "sh_ec2_launch_templ"
  image_id      = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  #   key_name = "sharmi-kp"
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sh_sg.id] //change TODO
  }
  # vpc_security_group_ids = [aws_security_group.sh_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Sharmi-instance"
    }
  }
}
