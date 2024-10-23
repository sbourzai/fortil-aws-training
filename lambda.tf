data "archive_file" "lambda_zip_file" {
  type        = "zip"
  source_dir  = "./lambdaSources"
  output_path = "./target/lambda.zip"
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.env_prefix}-dynamodb-lambda-processor"
  filename         = data.archive_file.lambda_zip_file.output_path
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  handler          = "dynamodb_lambda.lambda_handler"
  role             = aws_iam_role.lambda_execution_role.arn
  timeout          = 60
  runtime          = "python3.9"

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.training_table.name
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lambda_permission" "allow_api_gw_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
}