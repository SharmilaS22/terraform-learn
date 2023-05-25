resource "aws_s3_bucket" "sh_s3_bucket" {
  bucket = "sh-bucket"
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  depends_on = [aws_s3_bucket.sh_s3_bucket, aws_sqs_queue.sh_queue, aws_sqs_queue_policy.sh_sqs_policy]

  bucket = aws_s3_bucket.sh_s3_bucket.id

  queue {
    queue_arn = aws_sqs_queue.sh_queue.arn
    events    = ["s3:ObjectCreated:*"]
    # filter_suffix = ".log"
    # filter_prefix = "logs/"
  }
}