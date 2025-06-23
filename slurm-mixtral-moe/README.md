# Distributed Mixtral/MoE Training on Slurm

This guide shows how to run a distributed Mixtral 8x7B (or similar MoE) training job using Slurm on the Azure HPC infrastructure provisioned by this repository.

## Prerequisites

- The Azure HPC cluster is deployed using the Terraform configuration in this repo (see `terraform/` folder).
- Compute nodes are running the Ubuntu HPC image (`microsoft-dsvm:ubuntu-hpc:2204`) with A100 GPUs.
- Megatron-LM and its dependencies are set up on all compute nodes (see `megatron-lm-moe/` for setup script).
- Your training data and checkpoints are available on the Lustre filesystem (e.g., `/lustre/datasets`, `/lustre/checkpoints`).
- SSH key-based authentication is configured for user access.

## Step 1: Prepare the Environment

1. SSH into the Slurm controller or login node:
   ```bash
   ssh azureuser@<controller-or-login-node-public-ip>
   ```
2. Load required modules and activate your Python environment:
   ```bash
   module load mpi/openmpi-5.0.2
   module load cuda/12.4
   source ~/megatron-env/bin/activate
   ```

## Step 2: Create the Slurm Job Script

Below is an example Slurm job script (`mixtral_moe_train.slurm`) for distributed training:

```bash
#!/bin/bash
#SBATCH --job-name=mixtral-moe
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --gpus-per-node=8
#SBATCH --cpus-per-task=8
#SBATCH --mem=0
#SBATCH --time=48:00:00
#SBATCH --output=slurm-%j.out

# Load modules and activate environment
module load mpi/openmpi-5.0.2
module load cuda/12.4
source ~/megatron-env/bin/activate

# Set NCCL and CUDA environment variables for performance
export NCCL_DEBUG=INFO
export NCCL_IB_HCA=mlx5
export NCCL_IB_TC=106
export NCCL_IB_SL=3
export NCCL_NET_GDR_READ=1
export CUDA_DEVICE_MAX_CONNECTIONS=1

# Set paths
CHECKPOINT_PATH=/lustre/checkpoints/mixtral
DATA_PATH=/lustre/datasets/my_corpus
VOCAB_FILE=./gpt2-vocab.json
MERGE_FILE=./gpt2-merges.txt

# Run distributed training
srun python pretrain_gpt.py \
    --tensor-model-parallel-size 4 \
    --pipeline-model-parallel-size 2 \
    --num-layers 24 \
    --hidden-size 2048 \
    --num-attention-heads 16 \
    --micro-batch-size 4 \
    --global-batch-size 16 \
    --seq-length 2048 \
    --max-position-embeddings 2048 \
    --train-iters 500000 \
    --lr-decay-iters 320000 \
    --save $CHECKPOINT_PATH \
    --load $CHECKPOINT_PATH \
    --data-path $DATA_PATH \
    --vocab-file $VOCAB_FILE \
    --merge-file $MERGE_FILE \
    --data-impl mmap \
    --split 949,50,1 \
    --distributed-backend nccl \
    --lr 0.00015 \
    --lr-decay-style cosine \
    --min-lr 1.0e-5 \
    --weight-decay 1e-2 \
    --clip-grad 1.0 \
    --lr-warmup-fraction .01 \
    --activations-checkpoint-method uniform \
    --save-interval 1000 \
    --eval-interval 100 \
    --eval-iters 10 \
    --moe-num-experts 8 \
    --moe-top-k 2 \
    --bf16
```

## Step 3: Submit the Job

1. Copy the job script to your home directory on the cluster:
   ```bash
   cp mixtral_moe_train.slurm ~/
   ```
2. Submit the job to Slurm:
   ```bash
   sbatch ~/mixtral_moe_train.slurm
   ```
3. Monitor the job status:
   ```bash
   squeue -u $USER
   tail -f slurm-<jobid>.out
   ```

## Notes & Tips
- Adjust `--nodes`, `--ntasks-per-node`, and other Slurm parameters to match your cluster size.
- Make sure your data and checkpoint paths are correct and accessible from all compute nodes.
- For more details on MoE and Mixtral training, see the [Megatron-LM MoE README](https://github.com/NVIDIA/Megatron-LM/blob/main/megatron/core/transformer/moe/README.md).
- The infrastructure provisioned in the `terraform/` folder is designed to support this workflow out of the box.

---

**Happy training!** 