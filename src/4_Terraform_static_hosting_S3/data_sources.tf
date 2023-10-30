data "aws_iam_policy_document" "site_origin" {

  # allow policy for CloudFront to access s3 bucket
  statement {
    sid = "1"

    actions = ["s3:GetObject"]
    effect  = "Allow"

    resources = ["arn:aws:s3:::${aws_s3_bucket.static_web.bucket}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    # only distribution created here can access this s3 bucket
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.site_access.arn]
    }
  }
}



