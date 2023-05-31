# Private
# resource "aws_ecr_repository" "sh_ecr" {
#   name = "sh_node_helloworld"
#   #   image_tag_mutability = "MUTABLE"

#   #   image_scanning_configuration {
#   #     scan_on_push = true
#   #   }
# }

# -- Push images to this repo using docker commands -- #

#Public
resource "aws_ecrpublic_repository" "sh_ecr" {
  repository_name = "sh_node_helloworld"

# # optional
  # catalog_data {
  #   about_text        = "About Text"
  #   architectures     = ["ARM"]
  #   description       = "Description"
  #   logo_image_blob   = filebase64(image.png)
  #   operating_systems = ["Linux"]
  #   usage_text        = "Usage Text"
  # }

  # tags = {
  #   env = "production"
  # }
}