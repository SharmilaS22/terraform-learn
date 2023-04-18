# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

# resource "aws_elb" "sh_elb" {
#   name = "sharmi-elb-asg"
#   internal           = false

# #   security_groups = ["${aws_security_group.elb.id}"]
# #   availability_zones = ["${data.aws_availability_zones.all.names}"]
# #   health_check {
# #     healthy_threshold = 2
# #     unhealthy_threshold = 2
# #     timeout = 3
# #     interval = 30
# #     target = "HTTP:8080/"
# #   }
# #   listener {
# #     lb_port = 80
# #     lb_protocol = "http"
# #     instance_port = "8080"
# #     instance_protocol = "http"
# #   }
# }

resource "aws_lb" "sh_lb" {
  name               = "sharmi-lb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sh_sg.id]
  subnets            = [aws_subnet.sh_subnet_1.id, aws_subnet.sh_subnet_1a.id]
  depends_on         = [aws_internet_gateway.sh_gw]
}

resource "aws_lb_target_group" "sh_alb_tg" {
  name     = "sh-tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sh_main.id
}

resource "aws_lb_listener" "sh_front_end" {
  load_balancer_arn = aws_lb.sh_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sh_alb_tg.arn
  }
}