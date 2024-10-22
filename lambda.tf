
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "./lambdaSources"
  output_path = "./target/lambda.zip"
}


data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_role" {
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
  name               = "${var.env_prefix}-iam-role-lambda-allow-trigger"
}


resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_basic_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.env_prefix}-basic-training-lambda-function"
  description      = "basic-lambda-description"
  filename         = data.archive_file.lambda.output_path
  timeout          = 60
  role             = aws_iam_role.iam_role.arn
  handler          = "basic_lambda.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
}
