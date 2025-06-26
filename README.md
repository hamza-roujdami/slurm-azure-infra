# Slurm Azure HPC Infrastructure

This repository provides a modular, production-ready setup for deploying a Slurm-based HPC AI cluster on Azure with GPU nodes, using Terraform.

## Repository Structure

- `infra_provisioning/` — Terraform code to provision the core Azure infrastructure (network, compute, controller, login, Lustre)
- `infra_validation/` — Post-provisioning scripts and checks for validating the environment (SLURM, GPU, NCCL, software, etc.)
- `moe_dry_run_test/` — Example/test scripts for running a 2-node, 8-GPU MoE (Mixture of Experts) job as an end-to-end dry run

## Quick Start: Provisioning the Infrastructure

### Prerequisites
- Azure subscription with sufficient quota for GPU VMs
- [Terraform](https://www.terraform.io/downloads.html) installed (v1.1.0+)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated (`az login`)
- SSH key pair for VM access (see below)

### 1. Clone the Repository
```sh
git clone <your-repo-url>
cd slurm-azure-infra
```

### 2. Prepare Your SSH Key
```sh
# If you don't have one:
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
# Default path: ~/.ssh/id_rsa.pub
```

### 3. Configure Terraform Variables
```sh
cd infra_provisioning
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars to set your resource_group_name, admin_username, and ssh_public_key_path
```

### 4. Initialize and Apply Terraform
```sh
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

This will provision:
- Resource Group: `rg-hpc-slurm-infra`
- VNet: `vnet-hpc-slurm-infra`
- Subnets: `subnet-hpc-slurm-control`, `subnet-hpc-slurm-login`, `subnet-hpc-slurm-compute`, `subnet-hpc-slurm-lustre`
- NSG: `nsg-hpc-slurm-compute`
- Compute VMSS: `vmss-hpc-slurm-compute`
- Controller VM: `vm-hpc-slurm-controller`
- Login VMSS: `vmss-hpc-slurm-login`
- Lustre: `fs-hpc-slurm-lustre`

### 5. Clean Up
To destroy all resources:
```sh
terraform destroy -var-file=terraform.tfvars
```

## Security & Best Practices
- **Never commit secrets, credentials, or private SSH keys.**
- `.tfvars`, state files, and SSH keys are git-ignored by default (see `.gitignore`).
- Review all files before pushing to ensure no sensitive data is included.

## Next Steps
- See `infra_validation/` for post-provisioning validation and environment checks.
- See `moe_dry_run_test/` for an example end-to-end MoE job dry run.

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to your branch
5. Open a Pull Request

## License
MIT License. See LICENSE file for details.
