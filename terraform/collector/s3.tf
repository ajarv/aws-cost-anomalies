resource "aws_s3_bucket" "metrics-data" {
  bucket = local.bucket_name
  tags = {
    "${local.organization}:data" = "prod:operations:metrics"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.metrics-data.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.metrics-data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.metrics-data.id

  rule {
    id = "noncurrent_version_expiration"

    filter {
      prefix = "metrics/"
    }
    # Expire non current versions after 3 days
    noncurrent_version_expiration {
      noncurrent_days = 3
    }
    status = "Enabled"
  }
}

output "metrics-data-bucket-arn" {
  value = aws_s3_bucket.metrics-data.arn
}
