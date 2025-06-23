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