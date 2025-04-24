output "s3_bucket_name" {
  value = aws_s3_bucket.logs_backups.bucket
}
output "logs_backups_arn" {
  value = aws_s3_bucket.logs_backups.arn
}