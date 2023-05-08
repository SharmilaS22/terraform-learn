# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription

# NOTE:
# You cannot unsubscribe to a subscription that is pending confirmation
# erraform will remove the subscription from its state but the subscription will still exist in AWS. 
# However, if you delete an SNS topic, SNS deletes all the subscriptions associated with the topic

resource "aws_sns_topic_subscription" "sns_for_sms" {
  # topic_arn, protocol, endpoint -> are required
  topic_arn = aws_sns_topic.sh_sns.arn
  protocol  = "sms"
  endpoint  = "phonenumber"
}

resource "aws_sns_topic_subscription" "sns_for_email" {
  # topic_arn, protocol, endpoint -> are required
  topic_arn = aws_sns_topic.sh_sns.arn
  protocol  = "email" // have to confirm email
  endpoint  = "abc@example.com"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.sh_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sh_queue.arn
}