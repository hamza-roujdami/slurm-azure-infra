# Slurm Azure Infrastructure

This repository contains Terraform configurations for deploying a Slurm HPC cluster on Azure. The infrastructure includes compute nodes with A100 GPUs, a controller node, login nodes, and a high-performance Lustre file system.

## Infrastructure Components

- **Compute Nodes**:
  - VM Scale Set with Standard_ND96asr_v4 SKUs (8x A100 80GB GPUs per node)
  - Deployed in availability zones 2 and 3 (France Central)
  - Ubuntu HPC image (microsoft-dsvm:ubuntu-hpc:2204)

- **Controller Node**:
  - Single VM with Standard_D4s_v3 SKU
  - Manages the Slurm cluster

- **Login Nodes**:
  - VM Scale Set with Standard_D4s_v3 SKUs
  - Entry point for users

- **Storage**:
  - 48TB Lustre filesystem (AMLFS-Durable-Premium-40)
  - Deployed across three availability zones
  - Scheduled maintenance: Sundays at 00:00 UTC

- **Networking**:
  - Virtual Network (10.0.0.0/16)
  - Separate subnets for compute, control plane, login, and storage
  - Network security groups with SSH access

## Prerequisites

1. Azure subscription with quota for ND96asr_v4 VMs in France Central
2. Terraform installed (version 1.0.0 or later)
3. Azure CLI installed and configured
4. SSH key pair for authentication:
   ```bash
   # Check if you already have an SSH key
   ls -la ~/.ssh/id_rsa.pub
   
   # If no SSH key exists, generate a new one
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   
   # Verify the key was created
   cat ~/.ssh/id_rsa.pub
   ```

## Getting Started

1. Clone this repository:
   ```bash
   git clone [repository-url]
   cd slurm-azure-infra
   ```

2. Set up your SSH key (if not done in prerequisites):
   ```bash
   # Generate SSH key if you haven't already
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

3. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

4. Create a `terraform.tfvars` file with your configuration:
   ```bash
   # Copy the example file
   cp terraform.tfvars.example terraform.tfvars
   
   # Edit the file with your values, especially:
   # - resource_group_name
   # - admin_username
   # - Verify ssh_public_key_path points to your public key (default: "~/.ssh/id_rsa.pub")
   ```

5. Review and apply the configuration:
   ```bash
   terraform plan    # Review the changes
   terraform apply   # Apply the changes
   ```

## Security Considerations

- All sensitive data (SSH keys, credentials) should be stored securely
- terraform.tfvars file is git-ignored to prevent accidental commit of sensitive data
- Network security groups restrict access to necessary ports only
- System-assigned managed identities are used for VM authentication
- SSH key authentication is required for all VMs
- Never commit private SSH keys to the repository

## Maintenance

- Lustre filesystem maintenance occurs every Sunday at 00:00 UTC
- Regular updates should be applied to all nodes
- Monitor Azure quotas and usage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
