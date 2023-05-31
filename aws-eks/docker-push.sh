# View push commands - in AWS Console - ECR

# docker login
aws ecr get-login-password --region REGION --profile <PROFILE> | docker login \
--username AWS --password-stdin <ID>.dkr.ecr.<REGION>.amazonaws.com 

docker build -t sh-hello-world .

docker tag app-repo:latest ID.dkr.REGION.amazonaws.com/app-repo:latest 

docker push ID.dkr.REGION.amazonaws.com/app-repo:latest


# update local kubectl config to point to eks
aws eks update-kubeconfig --name <NAME_OF_EKS_CLUSTER> --region <REGION> --profile <PROFILE>


# REpush from scratch
docker build --no-cache -t sh_node_helloworld .
docker tag sh_node_helloworld:latest public.ecr.aws/aaaa/sh_node_helloworld:latest
docker push public.ecr.aws/aaaa/sh_node_helloworld:latest