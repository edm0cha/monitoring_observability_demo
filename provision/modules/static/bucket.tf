resource "aws_s3_bucket" "this" {
  bucket = "${var.name}-static-content"
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    sid = "AllowCloudFrontServicePrincipal"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

resource "null_resource" "remove_and_upload_to_s3" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "aws s3 sync ${path.root}/../frontend/dist s3://${aws_s3_bucket.this.id}"
  }
  depends_on = [aws_s3_bucket.this]
}
