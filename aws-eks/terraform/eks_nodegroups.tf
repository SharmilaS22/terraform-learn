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

  # launch_template {
  #   id      = aws_launch_template.sh_ec2_launch_templ.id
  #   version = "$Latest"
  # }

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

resource "aws_internet_gateway" "sh_ig_nat" {
  vpc_id = aws_vpc.sh_main.id
  tags = {
    Name = "sh_IG_NAT"
  }
}

resource "aws_route_table" "sh_rt_public" {
  vpc_id = aws_vpc.sh_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sh_ig_nat.id
  }
}


# associate the route table with public subnet
resource "aws_route_table_association" "sh_rta1" {
  subnet_id      = aws_subnet.sh_subnet_1.id
  route_table_id = aws_route_table.sh_rt_public.id
}

# private subnet configs ----

resource "aws_eip" "sh_eip" {
  depends_on = [aws_internet_gateway.sh_ig_nat]
  vpc        = true
  tags = {
    Name = "sh_EIP_for_NAT"
  }
}

resource "aws_nat_gateway" "sh_nat_for_eks-nodes" {
  allocation_id = aws_eip.sh_eip.id
  subnet_id     = aws_subnet.sh_subnet_1.id // nat should be in public subnet

  tags = {
    Name = "Sh NAT for eks nodes"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.sh_ig_nat]
}

resource "aws_route_table" "sh_rt_private" {
  vpc_id = aws_vpc.sh_main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sh_nat_for_eks-nodes.id
  }
}

resource "aws_route_table_association" "sh_rta2" {
  subnet_id      = aws_subnet.sh_subnet_2.id
  route_table_id = aws_route_table.sh_rt_private.id
}

resource "aws_route_table_association" "sh_rta1a" {
  subnet_id      = aws_subnet.sh_subnet_1a.id
  route_table_id = aws_route_table.sh_rt_private.id
}