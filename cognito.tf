# Cognito User Pool
resource "aws_cognito_user_pool" "training_user_pool" {
  name = "${var.env_prefix}-aws-training-user-pool"
}


# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "training_user_pool_client" {
  name         = "${var.env_prefix}-aws-training-user-pool-client"
  user_pool_id = aws_cognito_user_pool.training_user_pool.id
  # OAuth 2.0 settings
  allowed_oauth_flows              = ["implicit"]
  allowed_oauth_scopes             = ["email", "openid", "aws.cognito.signin.user.admin"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = [
    "https://example.com" # Change this to your actual callback URL
  ]

  logout_urls = [
    "https://example.com"  # Change this to your actual signout URL
  ]
  # Cognito User Pool Identity Provider
  supported_identity_providers = ["COGNITO"]
}


# API Gateway Authorizer
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "${var.env_prefix}-cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.training_api.id
  identity_source = "method.request.header.Authorization"
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.training_user_pool.arn]
}

# Cognito User Pool Domain (For user login URL)
resource "aws_cognito_user_pool_domain" "aws_training_user_pool_domain" {
  domain       = "${var.env_prefix}-api-auth"
  user_pool_id = aws_cognito_user_pool.training_user_pool.id
}




# TO GET THE TOKEN : CREATE USER THEN LOGIN THEN GET THE IDTOKEN FROM URL
