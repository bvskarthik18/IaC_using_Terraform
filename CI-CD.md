# CI/CD for aws-tf-web-db-stack

This document explains how the GitHub Actions workflows in this repository run Terraform `plan` and `apply` in an automated, auditable way.

## Overview
- `terraform-plan.yml` runs on Pull Requests and push events that touch `01-aws-tf-web-db-stack/` and produces a plan artifact and a plan summary comment on PRs.
- `terraform-apply.yml` is a **manual workflow** (triggered with `workflow_dispatch`) that requires approval via a protected GitHub **Environment** (e.g., `production`) and performs a safe `terraform apply` using the workspace's configuration.

## Recommended setup
1. Remote state (recommended): Create an S3 bucket and DynamoDB table to hold the Terraform state and locking. Set the following repo secrets (or configure environment variables in your workflow):
   - `TF_BACKEND_BUCKET` – S3 bucket name
   - `TF_BACKEND_DYNAMODB_TABLE` – DynamoDB table for state lock
   - `AWS_REGION` – Region for the backend and actions

2. Authentication (recommended): Use GitHub OIDC and an IAM role
   - Create an IAM role with a trust policy allowing GitHub OIDC to assume the role for your repo or organization.
   - Attach a policy with minimal permissions to manage Terraform resources and access S3/DynamoDB for state.
   - Save the role ARN as `AWS_ROLE_TO_ASSUME` in **Repository Secrets**.

3. Environment and approvals
   - Create a GitHub **Environment** named `production` (or your preferred name).
   - Configure required reviewers for the environment so that `terraform-apply.yml` is gated by manual approvals.

4. Fallback auth (not recommended): If you cannot use OIDC, set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION` as repository secrets. These will be used by the `aws-actions/configure-aws-credentials` action.

## How it works
- Plan: Runs `terraform init` (uses backend config if `TF_BACKEND_BUCKET` is set) and `terraform plan -out=tfplan`. The plan file is uploaded as an artifact and a plan summary is posted to the PR.
- Apply: Manual workflow (`workflow_dispatch`) that requires environment approval; it runs `terraform plan -out=tfplan` followed by `terraform apply tfplan`.

## Notes & Best Practices
- Enforce branch protection rules to require PRs and code review before merging to `main`.
- Configure environment reviewers to require at least one approver for production applies.
- Avoid storing long-lived AWS keys in repo secrets — prefer OIDC.
- Test workflows in a sandbox account first.

If you want, I can create Terraform code to provision the S3 bucket and DynamoDB table for remote state — should I add that to the repo as a separate directory (`infra/backend`) or do you prefer manual creation?