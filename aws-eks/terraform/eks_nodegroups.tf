resource "aws_eks_node_group" "sh_eks_node_grp" {

  # Required options
  cluster_name  = aws_eks_cluster.sh_eks.name
  node_role_arn = aws_iam_role.sh_eks_node_grp_role.arn
  subnet_ids = [
    aws_subnet.sh_subnet_1.id,
    aws_subnet.sh_subnet_2.id,
    aws_subnet.sh_subnet_1a.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  # optional
  node_group_name = "sh-node-group-1"
  capacity_type   = "ON_DEMAND"

  launch_template {
    id      = aws_launch_template.sh_ec2_launch_templ.id
    version = "$Latest"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.sh_eks.name}" = "owned"
  }
}
