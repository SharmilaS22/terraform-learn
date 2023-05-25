resource "aws_sqs_queue" "sh_queue" {
  name                       = "sh-example-queue"
  delay_seconds              = 10 // delay for msg delivery
  visibility_timeout_seconds = 30
  max_message_size           = 2048
  message_retention_seconds  = 86400 // 1day //life of the msg //max 14 days
  receive_wait_time_seconds  = 2     //long polling concept
  #   redrive_policy = jsonencode({
  #     deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
  #     maxReceiveCount     = 4
  #   })
  sqs_managed_sse_enabled = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy
resource "aws_sqs_queue_policy" "sh_sqs_policy" {
  queue_url = aws_sqs_queue.sh_queue.id
  policy    = data.aws_iam_policy_document.sh_sqs_policy.json
}