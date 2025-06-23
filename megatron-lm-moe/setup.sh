#!/bin/bash

# Load required modules
module load mpi/openmpi-5.0.2
module load cuda/12.4

# Create a virtual environment
python3 -m venv ~/megatron-env
source ~/megatron-env/bin/activate

# Install PyTorch and other dependencies
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Clone and install Megatron-LM
cd ~
git clone https://github.com/NVIDIA/Megatron-LM.git
cd Megatron-LM
pip install -e .

# Create directories for data and checkpoints
mkdir -p /lustre/checkpoints
mkdir -p /lustre/datasets

# Set environment variables
echo 'export NCCL_DEBUG=INFO' >> ~/.bashrc
echo 'export NCCL_IB_HCA=mlx5' >> ~/.bashrc
echo 'export NCCL_IB_TC=106' >> ~/.bashrc
echo 'export NCCL_IB_SL=3' >> ~/.bashrc
echo 'export NCCL_NET_GDR_READ=1' >> ~/.bashrc
echo 'export CUDA_DEVICE_MAX_CONNECTIONS=1' >> ~/.bashrc

# Optional: Disable WAAgent during training for CPU-sensitive workloads
echo '# Optionally disable WAAgent before training' >> ~/.bashrc
echo 'function disable_waagent() {' >> ~/.bashrc
echo '    sudo systemctl stop waagent' >> ~/.bashrc
echo '}' >> ~/.bashrc
echo 'function enable_waagent() {' >> ~/.bashrc
echo '    sudo systemctl start waagent' >> ~/.bashrc
echo '}' >> ~/.bashrc 