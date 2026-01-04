# Known Issues and Resolutions

This file documents errors encountered during `terraform apply` and the steps taken to resolve them.

---

## 1) DBSubnetGroupDoesNotCoverEnoughAZs (RDS DB Subnet Group)

**Error (sample):**
```
Error: creating RDS DB Subnet Group (rds_subnet_group): operation error RDS: CreateDBSubnetGroup, https response error StatusCode: 400, RequestID: ..., DBSubnetGroupDoesNotCoverEnoughAZs: The DB subnet group doesn't meet Availability Zone (AZ) coverage requirement. Current AZ coverage: us-east-1a. Add subnets to cover at least 2 AZs.
```

**Cause:**
- The RDS DB subnet group must include subnets in at least two different Availability Zones in the region. The project initially only created a single private subnet (one AZ).

**Resolution steps:**
1. Add at least one additional private subnet in a different AZ (e.g., `private_subnet_2`) in `vpc.tf` using `data.aws_availability_zones.available.names[1]`.
2. Update the RDS subnet group to include both subnets:
   - `subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id]` in `rds.tf`.
3. Re-run `terraform plan` and `terraform apply` to create the subnet and the DB subnet group.

**Why this works:**
- AWS requires DB subnet groups to provide at least two AZs so RDS can place resources across AZs for reliability.

---

## 2) InvalidParameterCombination: DB Instance class does not support encryption at rest

**Error (sample):**
```
Error: creating RDS DB Instance (rds-mysql): operation error RDS: CreateDBInstance, https response error StatusCode: 400, RequestID: ..., api error InvalidParameterCombination: DB Instance class db.t2.micro does not support encryption at rest
```

**Cause:**
- Some older or smaller instance classes (e.g., `db.t2.micro`) do not support storage encryption. The RDS resource in `rds.tf` had `storage_encrypted = true` while using an incompatible instance type.

**Resolution steps:**
1. Make the DB instance class configurable by adding a `db_instance_class` variable to `variables.tf`:
   ```hcl
   variable "db_instance_class" {
     description = "RDS instance class (choose a class that supports storage encryption)"
     type        = string
     default     = "db.t3.micro"
   }
   ```
2. Update `aws_db_instance.rds_mysql_instance` to use `instance_class = var.db_instance_class`.
3. Re-run `terraform plan` and `terraform apply` with an instance class that supports encryption (the default `db.t3.micro` works in most regions).

**Why this works:**
- Newer families such as `db.t3.*` support encryption at rest; making the class configurable avoids hardcoding an unsupported type.

---

## Notes & Best Practices
- Always inspect AWS error messages closely — they usually indicate whether the issue is a missing resource, a configuration mismatch, or a quota/limit.
- Use `data "aws_availability_zones" "available" { state = "available" }` to programmatically select AZs and reduce hardcoding.
- Make resources like instance classes configurable via variables so they can be adapted per region/account constraints.
- After making changes, always run `terraform plan` to validate before applying.

---