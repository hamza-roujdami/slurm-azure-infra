# Megatron-LM MoE Setup

This directory contains setup scripts and configurations for running NVIDIA's Megatron-LM Mixture of Experts (MoE) on our Azure HPC infrastructure.

## Pre-installed Components

Our Azure HPC VM image (microsoft-dsvm:ubuntu-hpc:2204) comes with:

### GPU and CUDA
- NVIDIA GPU Driver 535.161.08
- CUDA 12.4
- NVIDIA Peer Memory (GPU Direct RDMA)
- NVIDIA Fabric Manager

### Communication Libraries
- NCCL 2.21.5-1
- NCCL RDMA Sharp Plugin
- OpenMPI 5.0.2 with PMIx-4
- Mellanox OFED 24.01-0.3.3.1

### Performance Tools
- GDRCopy 2.3
- Data Center GPU Manager 3.3.3
- Azure HPC Diagnostics Tool

## Additional Setup Required

1. Clone Megatron-LM:
```bash
git clone https://github.com/NVIDIA/Megatron-LM.git
cd Megatron-LM
pip install -e .
```

2. Install PyTorch dependencies:
```bash
pip install torch torchvision torchaudio
```

3. Set up environment modules:
```bash
module load mpi/openmpi-5.0.2
module load cuda/12.4
```

## Running MoE Models

The infrastructure provides:
- 16x A100 80GB GPUs (8 per node, 2 nodes)
- 48TB Lustre filesystem for datasets and checkpoints
- High-speed InfiniBand interconnect

### Example MoE Configuration
```bash
python pretrain_gpt.py \
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
    --vocab-file gpt2-vocab.json \
    --merge-file gpt2-merges.txt \
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
    --moe-top-k 2 