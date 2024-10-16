
# data "archive_file" "lambda" {
#   type        = "zip"
#   source_dir  = "./lambdaSources"
#   output_path = "./target/lambda.zip"
# }


# data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
#   version = "2012-10-17"
#   statement {
#     actions = ["sts:AssumeRole"]
#     effect  = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "iam_role" {
#   assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
#   name               = "sandbox-iam-role-lambda-trigger"
# }


# resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_basic_execution" {
#   role       = aws_iam_role.iam_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
#   role       = aws_iam_role.iam_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
# }

# resource "aws_lambda_function" "lambda_function" {
#   description      = ""
#   filename         = data.archive_file.lambda.output_path
#   function_name    = "sandbox-lambda-function"
#   role             = aws_iam_role.iam_role.arn
#   handler          = "index.handler"
#   runtime          = "nodejs16.x"
#   source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
#   vpc_config {
#     subnet_ids         = [aws_subnet.my-jenkins-server-subnet-1.id]
#     security_group_ids = [aws_default_security_group.default-sg.id]
#   }
# }

