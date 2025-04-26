output "grafana_url" {
  value       = "http://${aws_instance.public_ec2.public_ip}:3000"
  description = "URL to access Grafana from your browser"
}

output "public_ec2_ip" {
  description = "Grafana Public IP"
  value       = aws_instance.public_ec2.public_ip
}

output "private_ec2_ip" {
  description = "PostgreSQL Private IP"
  value       = aws_instance.private_ec2.private_ip
}

output "public_ec2_id" {
  description = "Grafanda Public ID"
  value       = aws_instance.public_ec2.id
}

output "private_ec2_id" {
  description = "PostgreSQL Private ID"
  value       = aws_instance.private_ec2.id
}

output "postgres_host" {
  value = aws_instance.private_ec2.private_ip
}