resource "aws_iam_role" "grafana_ec2_role" {
  name = "grafana-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "grafana_full_policy" {
  name = "grafana-full-policy"
  role = aws_iam_role.grafana_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups",
          "logs:GetLogEvents",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "grafana_profile" {
  name = "grafana-instance-profile"
  role = aws_iam_role.grafana_ec2_role.name
}
