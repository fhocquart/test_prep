# Create an SNS topic for CloudWatch alerts
resource "aws_sns_topic" "alerts" {
  name = "intech-alerts"
}

# Create a CloudWatch alarm for high CPU usage
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm triggers if CPU usage exceeds 80% for 1 minute"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alerts.arn]
  dimensions = {
    InstanceId = aws_instance.intech_instance.id
  }
}

# Optional: Create an SNS subscription for notifications
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "o.hocquart93@gmail.com"  # Replace with your email address
}
