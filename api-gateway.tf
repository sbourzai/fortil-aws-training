# Create API Gateway
resource "aws_api_gateway_rest_api" "training_api" {
  name        = "${var.env_prefix}-api-training-aws"
  description = "API for AWS Training example"
}


resource "aws_api_gateway_resource" "process" {
  rest_api_id = aws_api_gateway_rest_api.training_api.id
  parent_id   = aws_api_gateway_rest_api.training_api.root_resource_id
  path_part   = "jokes"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.training_api.id
  resource_id   = aws_api_gateway_resource.process.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.training_api.id
  resource_id             = aws_api_gateway_resource.process.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}


resource "aws_api_gateway_deployment" "training_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.training_api.id
  stage_name  = "prod"

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.training_api_deployment.invoke_url}/jokes"
}