# resource "aws_ecs_cluster" "sh_ec_cluster" {
#   name = "sh-app-cluster"
# }

# TO LEARN --

# resource "aws_ecs_cluster_capacity_providers" "example" {
#   cluster_name = aws_ecs_cluster.example.name

#   capacity_providers = [aws_ecs_capacity_provider.example.name]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = aws_ecs_capacity_provider.example.name
#   }
# }

# resource "aws_ecs_capacity_provider" "example" {
#   name = "example"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn = aws_autoscaling_group.example.arn
#   }
# }