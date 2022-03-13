resource "aws_cloudwatch_log_subscription_filter" "aclsf" {
  name            = "${var.PROJECT}-${var.ENVIRONMENT}-log-subscription-filter"
  role_arn        = aws_iam_role.subscription-filter-iam-role.arn
  log_group_name  = "/aws/lambda/dod-lambda"
  filter_pattern  = "Duration"
  destination_arn = aws_kinesis_firehose_delivery_stream.akfds.arn
  distribution    = "Random"
}
