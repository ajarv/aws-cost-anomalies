Monitoring your AWS Costs like a pro

Your AWS resources and their metrics are spread across multiple accounts and you want to monitor your Costs and Usage in one place. More than montitoring the costs and spends you WANT to figure out quickly if there are any anomalies in your usage. You hate to pay thousands of dollars for the sevices that you didn't think you consumed !

This post is for you.

You need to collect costs and metrics data from all your AWS accounts to a single location in a format that you can analyse using off the shelf tools like python pandas.

Step 1 - Sharing metrics data cross accounts via Terraform

Run with metrics collector account credenitals
```bash

cd ./terraform/collector

terraform init
terraform apply
# Note the collector role arn in output
```

For each Metrics provider role
Run with provider account credentials

```bash
cd ./terraform/provider
terraform init
TF_VAR_collector_arn=arn:aws:iam::N1NNNNNNNNNN:role/cost-metrics-collector terraform plan

```
