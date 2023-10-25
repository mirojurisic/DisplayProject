
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
