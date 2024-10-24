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


# Secure the POST method with Cognito Authorizer
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.training_api.id
  resource_id   = aws_api_gateway_resource.process.id
  http_method   = "POST"
  # authorization = "NONE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}


resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.training_api.id
  resource_id             = aws_api_gateway_resource.process.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# API Gateway Deployment (updates for the new authorizer)
resource "aws_api_gateway_deployment" "training_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.training_api.id
  stage_name  = "prodv2"

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

output "cognito_login_url" {
  value = "https://${aws_cognito_user_pool_domain.aws_training_user_pool_domain.domain}.auth.${var.aws_region}.amazoncognito.com/login?response_type=token&client_id=${aws_cognito_user_pool_client.training_user_pool_client.id}&redirect_uri=https://example.com"
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.training_api_deployment.invoke_url}/jokes"
}
