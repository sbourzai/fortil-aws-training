# # Event Bridge Scheduler


# // this role will be prefixed by env name
# resource "aws_iam_role" "event_bridge_scheduler_role" {
#   name = "prefix_nch_dev_event_bridge_scheduler_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "scheduler.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# // IAM Policy that will be attached to the schedulder role
# resource "aws_iam_role_policy" "eventbridge_invoke_lambda_policy" {
#   name = "refix_nch_dev_event_bridge_invoke_lambda_policy"
#   role = aws_iam_role.event_bridge_scheduler_role.id
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "AllowEventBridgeToInvokeLambda",
#         "Action" : [
#           "lambda:InvokeFunction"
#         ],
#         "Effect" : "Allow",
#         "Resource" : aws_lambda_function.lambda_function.arn
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "kms_decryption_policy" {
#   name        = "kms_decryption_policy"
#   description = "Policy for allowing decryption using the KMS key"

#   policy = jsonencode({
#     Version   = "2012-10-17"
#     Statement = [{
#       Effect   = "Allow"
#       Action   = ["kms:Decrypt"]
#       Resource = "arn:aws:kms:eu-west-1:372016587628:key/8909c8d2-a157-4bd1-a646-8ae32157ab88"
#     }]
#   })
# }

# # Attach the decryption policy to the IAM role
# resource "aws_iam_role_policy_attachment" "kms_decryption_policy_attachment" {
#   policy_arn = aws_iam_policy.kms_decryption_policy.arn
#   role       = aws_iam_role.event_bridge_scheduler_role.name
# }

# resource "aws_scheduler_schedule" "nch_invoke_lambda_schedule" {
#   name = "nch_invoke_lambda_schedule"
#   flexible_time_window {
#     mode = "OFF"
#   }
#   schedule_expression = "cron(50 23 * * ? *)" # run every 30 minutes
#   schedule_expression_timezone = "Europe/Paris"
#   kms_key_arn = "arn:aws:kms:eu-west-1:372016587628:key/8909c8d2-a157-4bd1-a646-8ae32157ab88"

#   target {
#     arn = aws_lambda_function.lambda_function.arn
#     role_arn = aws_iam_role.event_bridge_scheduler_role.arn
#     input = jsonencode({"input": "This message was sent using EventBridge Scheduler!"})
#     retry_policy {
#       maximum_event_age_in_seconds = 120
#       maximum_retry_attempts       = 2
#     }
#   }
#   state = "ENABLED"
# }
