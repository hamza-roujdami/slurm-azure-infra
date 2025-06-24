# Azure AI HPC Slurm GPU Cluster Provisioning

## Overview
This folder contains Terraform code to provision a modular, production-grade Azure HPC cluster for AI workloads with Slurm and GPU nodes. The infrastructure is fully modularized for maintainability and scalability.

## Structure
- `modules/` — Contains reusable Terraform modules for each major service:
  - `network`: VNet, subnets, NSGs
  - `compute`: Compute VMSS
  - `controller`: Slurm controller VM
  - `login`: Login node VMSS
  - `lustre`: Azure Managed Lustre filesystem
- `main.tf` — Assembles the modules and passes variables/outputs
- `variables.tf` — All input variables
- `outputs.tf` — Useful outputs for integration and validation

## Naming Conventions
All Azure resources follow a clear, environment-specific naming convention:
- Resource Group: `rg-az-ai-infra`
- VNet: `vnet-az-ai-infra`
- Subnets: `az-ai-infra-subnet-control`, `az-ai-infra-subnet-login`, etc.
- NSG: `nsg-az-ai-infra-compute`
- Compute VMSS: `vmss-az-ai-infra-compute`
- Controller VM: `vm-az-ai-infra-controller`
- Login VMSS: `vmss-az-ai-infra-login`
- Lustre: `fs-az-ai-infra-lustre`

## How to Deploy
1. **Initialize Terraform**
   ```sh
   terraform init
   ```
2. **Review the plan**
   ```sh
   terraform plan
   ```
3. **Apply the plan**
   ```sh
   terraform apply
   ```
   This will provision all resources in Azure using the above naming conventions.

## How to Clean Up
To destroy all resources created by this deployment:
```sh
terraform destroy
```

## Notes
- All modules are reusable and can be parameterized for other environments.
- The default region is `francecentral`, but you can override this in `terraform.tfvars` or via CLI.
- SSH keys, VM sizes, and other parameters can be customized in `variables.tf` or `terraform.tfvars`. 