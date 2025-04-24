resource "aws_s3_bucket" "logs_backups" {
  bucket = "nightwatch-logs-backups-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name        = "Nightwatch Logs and Backups"
    Environment = "dev"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
