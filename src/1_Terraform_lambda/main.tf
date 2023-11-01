
module "lambda_IAM" {
  source = "./modules/lambda_IAM"

  lambda_IAM_policy_name = local.lambda_IAM_policy_name
  lambda_IAM_policy_file = local.lambda_IAM_policy_file
  lambda_role_name       = local.lambda_role_name
  lambda_role_file       = local.lambda_role_file
}
module "lambda_function" {
  source              = "./modules/lambda_function"
  lambda_iam_role_arn = module.lambda_IAM.lambda_iam_role_arn
  path_to_source_file = local.path_to_source_file
  path_to_artifact    = local.path_to_artifact
  function_name       = local.function_name
  function_handler    = local.function_handler
  memory_size         = local.memory_size
  timeout             = local.timeout
  runtime             = local.runtime

}
resource "aws_cloudwatch_event_rule" "simple_lambda_event_rule" {
  name                = "simple-lambda-event-rule"
  description         = "retry scheduled every 2 min"
  schedule_expression = "rate(2 minutes)"
}

resource "aws_cloudwatch_event_target" "event_lambda_target" {
  arn  = module.lambda_function.lambda_function_arn
  rule = aws_cloudwatch_event_rule.simple_lambda_event_rule.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_simple_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = local.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.simple_lambda_event_rule.arn
}
