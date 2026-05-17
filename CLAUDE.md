# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of standalone, independent infrastructure and security examples accompanying Medium articles by Andrew Blooman. Each subdirectory is a self-contained project — they share no state, modules, or dependencies with each other.

## Common Commands

### Terraform projects
Each Terraform project is worked on independently from its own directory:

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

No remote backend is configured — all projects use local state. There are no shared modules; all resources are defined inline per project.

### Docker Compose projects

```bash
docker-compose up -d
docker-compose down
docker-compose logs -f
```

Projects that use `.env` files (e.g. `opencti_demo/`, `yeti_cti_platform/`) require those to be populated before starting.

## Project Categories

**Terraform (AWS):** `chatgpt_vs_snyk`, `cloudtrail_siem`, `imdsv2_control`, `oidc_auth_using_jwt`, `permission_boundaries`, `s3_private_buckets_via_cloudfront`, `systems_manager_recording`, `vpc_flow_logs_analysis`

**Docker Compose (threat intel / monitoring stacks):** `elk_stack`, `misp`, `opencti_demo`, `pi_hole_demo`, `yeti_cti_platform`

**Other:** `container_security` (Dockerfile comparison — `secure/` vs `vulnerable/`), `service_control_policies` (raw AWS SCP JSON files)

**Placeholders (empty):** `code_scanning`, `golden_image_pipeline`, `immutable_infrastructure`

## Terraform Conventions

- **File layout:** Resources are split by type for larger projects — `vpc.tf`, `ec2.tf`, `iam.tf`, `kms.tf`, `data.tf` — rather than one monolithic `main.tf`.
- **versions.tf:** Present in every project but intentionally empty — no Terraform or provider version constraints are pinned.
- **providers.tf:** Contains only the AWS provider block with a region variable. No assume-role or other provider settings.
- **outputs.tf:** Usually empty; add outputs as needed during development.
- **State:** Local only. `.terraform/`, `terraform.tfstate*`, and `.terraform.lock.hcl` are gitignored.
- **Default region:** `eu-west-1` or `eu-west-2` for most projects.
- **IAM patterns:** Policy documents use `jsonencode()`. OIDC trust relationships and permission boundaries are recurring patterns.
