# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
resource "aws_sns_topic" "sh_sns" {
  name = "sh-email-quotes-topic"
}