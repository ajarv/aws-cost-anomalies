variable "allowed_role_arns" {
  type    = list(string)
  default = [
        # Metric's collector Role ARN where N1NNNNNNNNNN is ops/management account 
        "arn:aws:iam::N1NNNNNNNNNN:role/cost-metrics-collector",
  ]
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = var.allowed_role_arns
      type        = "AWS"
    }
  }
}

data "aws_iam_policy_document" "metrics-collector" {
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

resource "aws_iam_policy" "metrics-collector" {
  name        = "quicksight-metrics-collector"
  description = "policy to allow  metrics collection"
  policy      = data.aws_iam_policy_document.metrics-collector.json
}

resource "aws_iam_role" "metrics-collector" {
  name               = "quicksight-metrics-collector"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "aws_read_only_policy_attach" {
  role       = aws_iam_role.metrics-collector.name
  policy_arn = aws_iam_policy.metrics-collector.arn
}
