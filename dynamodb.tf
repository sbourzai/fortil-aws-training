resource "aws_dynamodb_table" "training_table" {
  name           = "${var.env_prefix}-dynamo-aws-training"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "prod"
    Name        = "ChuckNorrisJokes"
  }
}