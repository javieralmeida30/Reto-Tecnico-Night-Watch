output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "grafana_url" {
  value = module.ec2.grafana_url
}

output "public_ec2_ip" {
  value = module.ec2.public_ec2_ip
}

output "private_ec2_ip" {
  value = module.ec2.private_ec2_ip
}

output "public_ec2_id" {
  value = module.ec2.public_ec2_id
}

output "private_ec2_id" {
  value = module.ec2.private_ec2_id
}

output "bucket_name" {
  value = module.s3.bucket_name
}
