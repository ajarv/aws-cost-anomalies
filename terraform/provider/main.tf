variable collector_arn {
  type = string
}

module "provider" {
  source = "../modules/cost-metrics-provider"
  collector_arn = var.collector_arn
}