resource "aws_eks_cluster" "sh_eks" {
  name     = "sh_test_eks"
  role_arn = aws_iam_role.sh_eks_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.sh_subnet_2.id, aws_subnet.sh_subnet_1a.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    # aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}


# Outputs
output "endpoint" {
  value = aws_eks_cluster.sh_eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.sh_eks.certificate_authority[0].data
}