# DNS Setup for Grafana (Optional)
# If a custom domain and Route 53 Hosted Zone are available,
# uncomment the following resources to assign a DNS name to the Grafana server.

# resource "aws_eip" "grafana_eip" {
#   instance = aws_instance.public_ec2.id
#   vpc      = true
# }

# resource "aws_route53_record" "grafana_dns" {
#   zone_id = "Zxxxxxxxxxxxx" # Replace with your Route 53 Hosted Zone ID
#   name    = "grafana-nightwatch.example.com" # Replace with your desired DNS name
#   type    = "A"
#   ttl     = 300
#   records = [aws_eip.grafana_eip.public_ip]
# }
