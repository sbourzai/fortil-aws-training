resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.env_prefix}-lambda_dynamodb_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  # Attach policies for Lambda to interact with DynamoDB
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ]
}

# resource "aws_iam_role_policy" "dynamodb_read_log_policy" {
#   name   = "lambda-dynamodb-log-policy"
#   role   = aws_iam_role.lambda_execution_role.id
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#         "Action": [ "logs:*" ],
#         "Effect": "Allow",
#         "Resource": [ "arn:aws:logs:*:*:*" ]
#     },
#     {
#         "Action": [ "dynamodb:BatchGetItem",
#                     "dynamodb:GetItem",
#                     "dynamodb:GetRecords",
#                     "dynamodb:Scan",
#                     "dynamodb:Query",
#                     "dynamodb:GetShardIterator",
#                     "dynamodb:DescribeStream",
#                     "dynamodb:ListStreams" ],
#         "Effect": "Allow",
#         "Resource": [
#           "${aws_dynamodb_table.training_table.arn}",
#           "${aws_dynamodb_table.training_table.arn}/*"
#         ]
#     }
#   ]
# }
# EOF
# }