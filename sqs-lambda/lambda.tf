data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}

data "archive_file" "sh_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda_code.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "sh_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name = "sh_lambda_with_sqs"
  role          = aws_iam_role.iam_for_lambda.arn

  filename = "lambda_function_payload.zip"
  handler  = "lambda_code.lambda_handler"

  source_code_hash = data.archive_file.sh_lambda_zip.output_base64sha256

  runtime = "python3.9"
}