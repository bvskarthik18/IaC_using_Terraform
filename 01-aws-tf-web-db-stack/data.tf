# Fetch Latest AMI from AWS AMI Catalog
data "aws_ami" "latest_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Discover available availability zones in the selected region
data "aws_availability_zones" "available" {
  state = "available"
} 