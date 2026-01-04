variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "default"
}

variable "bucket_name" {
  description = "Name of the S3 Bucket"
  type        = string
  default     = "aws-terraform-web-db-stack-007"
}

variable "db_identifier" {
  description = "RDS Database identifier"
  default     = "rds-mysql"
}

variable "db_username" {
  description = "RDS DB Username"
  default     = "admin"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into EC2 (set to your IP/CIDR, e.g. 203.0.113.4/32)"
  type        = string
  default     = "0.0.0.0/0"
} 