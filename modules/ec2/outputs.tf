output "public_ec2_id" {
  value = aws_instance.public_ec2.id
}

output "private_ec2_id" {
  value = aws_instance.private_ec2.id
}

output "grafana_url" {
  value       = "http://${aws_instance.public_ec2.public_ip}:3000"
  description = "URL to access Grafana from your browser"
}

output "postgres_host" {
  value = aws_instance.private_ec2.private_ip
}
