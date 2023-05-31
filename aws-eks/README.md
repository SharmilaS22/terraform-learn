# Amazon ECR - Elastic Container Registry

## AWS EKS
 - create a node group with launch configurations

## VPC
 - 1 public subnet
 - 2 private subnets - different AZs


## Gateways
 - Internet gateway - for public subnet
 - create a route table with IG and associate with public subnet

 - NAT Gateway uses Elastic IP (Nat should be in public subnet only)
 - Elastic IP depends on IG
 - create a route table with NAT gateway
 - Associate the route table with private subnets

## K8s
Apply - deployment and service(LB) from command line
Deployment - deploys pod in nodes
Service - creates a classic load balancer - pointing to node groups

## Roles
EKS
- AmazonEKSClusterPolicy
- AmazonEKSVPCResourceController

Node group
- AmazonEKSWorkerNodePolicy
- AmazonEKS_CNI_Policy
- AmazonEC2ContainerRegistryReadOnly

## Security groups
- for lambda - public subnet




