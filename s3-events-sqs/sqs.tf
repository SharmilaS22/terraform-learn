resource "aws_sqs_queue" "sh_queue" {
  name = "sh-s3-event-notification-queue"
}

resource "aws_sqs_queue_policy" "sh_sqs_policy" {
  queue_url = aws_sqs_queue.sh_queue.id
  policy    = data.aws_iam_policy_document.sh_queue.json
}
