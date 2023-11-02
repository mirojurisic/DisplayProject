locals {
  path_to_source_file = "./src_lambda/simple.py"
  path_to_artifact    = "./artifacts/simple_hello.zip"
  function_name       = "helloWorld"
  function_handler    = "simple.lambda_handler"
  memory_size         = 128
  timeout             = 30
  runtime             = "python3.7"

  lambda_IAM_policy_name = "lambda_IAM_policy_simple"
  lambda_IAM_policy_file = "./modules/lambda_IAM/lambda_IAM_policy_simple.json"
  lambda_role_name       = "lambda_role_simple"
  lambda_role_file       = "./modules/lambda_IAM/lambda_role_simple.json"

  dynamodb_name = "simple-example-dynamodb-tb"

}
