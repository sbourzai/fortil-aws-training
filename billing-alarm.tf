resource "aws_cloudwatch_metric_alarm" "finops_alarm" {
    alarm_name = "myFinopsAlarm"
    alarm_description = "random description"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = "1"

    metric_name = "EstimatedCharges"
    namespace = "AWS/Billing"

    period = "21600"
    statistic = "Maximum"
    threshold = 30

    treat_missing_data = "ignore"

    dimensions = {
      currency = "USD"
    }

    provider = aws.america
      
}

