# Slurm Install & Configuration Guide (Azure AI HPC Cluster)

## 1. Overview
This guide walks you through installing and configuring Slurm on your Azure-provisioned cluster (Ubuntu 22.04, controller, compute, and login nodes).

---

## 2. Prerequisites
- All nodes are running Ubuntu 22.04 (HPC-tuned image)
- Controller, compute, and login nodes are provisioned and accessible via SSH
- Passwordless SSH is set up between controller and compute nodes (for Slurm management)
- All nodes have network connectivity
- You have sudo privileges on all nodes

---

## 3. Install Slurm

### 3.1. On All Nodes (Controller, Compute, Login)
```bash
sudo apt update
sudo apt install -y slurm-wlm munge
```

### 3.2. Install Additional Tools (Optional, but recommended)
```bash
sudo apt install -y slurm-client slurmctld slurmd
```

---

## 4. Configure Slurm

### 4.1. Configure Munge (Authentication)
On all nodes:
```bash
sudo /usr/sbin/create-munge-key
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo systemctl enable --now munge
```
- Copy `/etc/munge/munge.key` from the controller to all compute and login nodes (must be identical on all nodes).

### 4.2. Configure slurm.conf
- Generate a `slurm.conf` using the [Slurm Configurator](https://slurm.schedmd.com/configurator.html) or use a template.
- Place `slurm.conf` in `/etc/slurm-llnl/` on all nodes.
- Example minimal config:
```ini
# /etc/slurm-llnl/slurm.conf
ClusterName=az-ai-infra
ControlMachine=<controller-hostname>
MpiDefault=none
ProctrackType=proctrack/linuxproc
ReturnToService=2
SlurmctldPort=6817
SlurmdPort=6818
SlurmdSpoolDir=/var/spool/slurmd
SlurmUser=slurm
StateSaveLocation=/var/spool/slurmctld
SwitchType=switch/none
TaskPlugin=task/affinity

NodeName=<compute-node-pattern> NodeAddr=<compute-node-ip-pattern> State=UNKNOWN
PartitionName=debug Nodes=<compute-node-pattern> Default=YES MaxTime=INFINITE State=UP
```
- Replace `<controller-hostname>`, `<compute-node-pattern>`, and `<compute-node-ip-pattern>` with your actual hostnames/IPs.

### 4.3. Configure gres.conf (for GPU nodes)
On all compute nodes:
```ini
# /etc/slurm-llnl/gres.conf
NodeName=<compute-node-name> Name=gpu File=/dev/nvidia0
NodeName=<compute-node-name> Name=gpu File=/dev/nvidia1
# ...repeat for all GPUs
```

---

## 5. Start and Enable Slurm Services

### 5.1. On Controller Node
```bash
sudo systemctl enable --now slurmctld
```

### 5.2. On Compute Nodes
```bash
sudo systemctl enable --now slurmd
```

### 5.3. On Login Nodes (optional, for client tools)
```bash
sudo systemctl enable --now slurmctld slurmd
```

---

## 6. Test the Cluster
- On the controller or login node:
```bash
sinfo
scontrol show nodes
```
- Submit a test job:
```bash
srun -N1 -n1 hostname
```

---

## 7. Troubleshooting Tips
- Check Munge status: `systemctl status munge`
- Check Slurm logs: `/var/log/slurmctld.log`, `/var/log/slurmd.log`
- Ensure all nodes have the same `/etc/munge/munge.key` and `/etc/slurm-llnl/slurm.conf`
- Use `journalctl -u slurmctld` and `journalctl -u slurmd` for service logs

---

## 8. References
- [Slurm Quick Start Admin Guide](https://slurm.schedmd.com/quickstart_admin.html)
- [Slurm Configurator](https://slurm.schedmd.com/configurator.html)
- [Slurm GPU Guide](https://slurm.schedmd.com/gres.html) 