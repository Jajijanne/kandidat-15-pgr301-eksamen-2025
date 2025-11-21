terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# SNS topic for varsler
resource "aws_sns_topic" "alerts" {
  name = "sentiment-alerts-${var.student_name}"
}

# E-post-subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ---------------------------
# CloudWatch Dashboard
# ---------------------------
resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      # 1 Bedrock latency
      {
        "type": "metric",
        "x": 0, "y": 0, "width": 12, "height": 6,
        "properties": {
          "title": "Bedrock latency (ms)",
          "view": "timeSeries",
          "region": var.region,
          "metrics": [
            [ var.namespace, "sentiment.bedrock.duration.avg", { "stat": "Average" } ],
            [ ".",           "sentiment.bedrock.duration.max", { "stat": "Maximum" } ]
          ]
        }
      },

      # 2 Analyses per minute (Counter)
      {
        "type": "metric",
        "x": 12, "y": 0, "width": 12, "height": 6,
        "properties": {
          "title": "Analyses per minute",
          "view": "timeSeries",
          "region": var.region,
          "metrics": [
            [ var.namespace, "sentiment.analysis.count.count", { "stat": "Sum" } ]
          ]
        }
      },

      # 3 Companies detected (Gauge)
      {
        "type": "metric",
        "x": 0, "y": 12, "width": 12, "height": 6,
        "properties": {
          "title": "Companies detected (last)",
          "view": "singleValue",
          "region": var.region,
          "metrics": [
            [ var.namespace, "sentiment.companies.last.value", { "stat": "Average" } ]
          ]
        }
      },

      # 4 Confidence (single value)
      {
        "type": "metric",
        "x": 12, "y": 12, "width": 12, "height": 6,
        "properties": {
          "title": "Confidence (avg)",
          "view": "singleValue",
          "region": var.region,
          "metrics": [
            [ var.namespace, "sentiment.confidence.avg", { "stat": "Average" } ]
          ]
        }
      }
    ]
  })
}

# ---------------------------
# CloudWatch Alarm – "no activity"
# ---------------------------
resource "aws_cloudwatch_metric_alarm" "no_activity" {
  alarm_name        = "no-sentiment-activity-${var.student_name}"
  alarm_description = "Triggers if no sentiment analyses run for N minutes"

  namespace  = var.namespace
  metric_name = "sentiment.analysis.count.sum"
  statistic   = "Sum"

  # 1 min per periode * 5 perioder = 5 minutter uten aktivitet
  period             = 60
  evaluation_periods = 5
  threshold          = 0
  comparison_operator = "LessThanOrEqualToThreshold"

  # Hvis det ikke kommer data i det hele tatt, regnes det som brudd
  treat_missing_data = "breaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
}