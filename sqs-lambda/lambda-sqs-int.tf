
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.sh_queue.arn
  function_name    = aws_lambda_function.sh_lambda.arn
}

# resource "aws_lambda_event_source_mapping" "event_source_mapping" {
#   event_source_arn = "${var.terraform_queue_arn}"
#   enabled          = true
#   function_name    = "${aws_lambda_function.test_lambda.arn}"
#   batch_size       = 1
# }