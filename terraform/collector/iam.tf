locals {
  organization = "sour-banana"
  role-name    = "cost-metrics-collector"
  bucket_name  = "${local.organization}-metrics-data"
}

data "aws_iam_policy_document" "metrics-data-bucket-rw-policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*Bucket*",
      "s3:*Object*",
      "s3:*Upload*",
    ]
    resources = [
      aws_s3_bucket.metrics-data.arn,
      "${aws_s3_bucket.metrics-data.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "metrics-data-bucket-rw-policy" {
  name        = "${local.bucket_name}-rw"
  description = "Policy allowing rw access to ${local.bucket_name} for metrics collector role"
  policy      = data.aws_iam_policy_document.metrics-data-bucket-rw-policy.json
}

resource "aws_iam_role" "metrics-collector" {
  name               = "costs-metrics-collector"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.metrics-collector.name
  policy_arn = aws_iam_policy.metrics-data-bucket-rw-policy.arn
}

output "metrics-collector-role-arn" {
  value = aws_iam_role.metrics-collector.arn
}