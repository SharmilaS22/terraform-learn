# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "sh_sqs_policy" {
  statement {
    sid    = "shsqsstatement" //statement id
    effect = "Allow"

    # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html
    # principals { // both arguments (type, identifiers) are required
    #   type        = "Service"
    #   identifiers = ["*"]
    # } // types - Service, AWS, Federated
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      aws_sqs_queue.sh_queue.arn
    ]

    # not_actions, not_principals, not_resources
    # ↓→ means -> except this allow all

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.sh_sns.arn]
    }
    # if another condition block is used
    #  -> all conditions should match -> AND logic
  }
}