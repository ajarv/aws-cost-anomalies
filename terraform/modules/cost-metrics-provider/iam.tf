variable "collector_arn" {
  type    = string
  # Metric's collector Role ARN where N1NNNNNNNNNN is ops/management account
  default = "arn:aws:iam::N1NNNNNNNNNN:role/cost-metrics-collector"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = [var.collector_arn]
      type        = "AWS"
    }
  }
}

data "aws_iam_policy_document" "metrics-reader" {
  statement {
    sid = "CostExplorerPermissions"
    effect = "Allow"
    actions = [
      "ce:GetCostCategories",
      "ce:ListCostAllocationTags",
      "ce:GetCostAndUsage",
      "ce:ListCostCategoryDefinitions",
      "ce:GetTags"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "CWMetricsPermissions"
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics"
    ]
    resources = [
      "*"
    ]
  }

}

resource "aws_iam_policy" "metrics-reader" {
  name        = "quicksight-metrics-reader"
  description = "policy to allow  metrics collection"
  policy      = data.aws_iam_policy_document.metrics-reader.json
}

resource "aws_iam_role" "metrics-reader" {
  name               = "quicksight-metrics-reader"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "aws_read_only_policy_attach" {
  role       = aws_iam_role.metrics-reader.name
  policy_arn = aws_iam_policy.metrics-reader.arn
}
