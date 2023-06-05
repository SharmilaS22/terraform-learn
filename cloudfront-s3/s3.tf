resource "aws_s3_bucket" "sh_s3_bucket" {
  bucket = "sh-bucket-cloudfront-test"
  tags = {
    Name = "sh-bucket-cloudfront-test"
  }
}

resource "aws_s3_bucket_acl" "sh_acl" {
  bucket = aws_s3_bucket.sh_s3_bucket.id
  acl    = "private"
}

data "aws_iam_policy_document" "sh_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.sh_s3_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "sh_bucket_policy" {
  bucket = aws_s3_bucket.sh_s3_bucket.id
  policy = data.aws_iam_policy_document.sh_s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.sh_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  //ignore_public_acls      = true
  //restrict_public_buckets = true
}