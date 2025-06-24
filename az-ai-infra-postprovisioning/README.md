# Azure AI HPC Cluster Post-Provisioning Guide

## Overview
This folder contains post-provisioning steps, scripts, and documentation to validate and benchmark your Azure AI HPC Slurm cluster after infrastructure deployment.

---

## 1. GPU/Node Health Checks
- [ ] Verify all GPUs are detected per node (`nvidia-smi -L`)
- [ ] Check ECC memory status (`nvidia-smi -q`)
- [ ] Validate NVLink/NVSwitch connectivity (`nvidia-smi topo -m`)
- [ ] Confirm PCIe bus health
- [ ] Run DCGM diagnostics (`dcgmi diag --run 3`)
- [ ] Run gpu-burn for thermal/stability
- [ ] Use Azure NHC (AzNHC) for automated checks

_Scripts/notes: [scripts/gpu_health_check.sh]_ (to be created)

---

## 2. Performance Benchmarking
- [ ] Run CUDA bandwidthTest
- [ ] Confirm memory throughput
- [ ] Test compute performance (GEMM/PyTorch)
- [ ] Validate Host-to-Device PCIe throughput
- [ ] Run DCGM memory bandwidth test
- [ ] Compare against baseline performance

_Scripts/notes: [scripts/perf_benchmark.sh]_ (to be created)

---

## 3. Multi-Node Communication Tests
- [ ] Run InfiniBand checks (`ibstat`, `ibv_devinfo`)
- [ ] Test IB point-to-point bandwidth (`ib_read_bw`)
- [ ] Run multi-node NCCL All-Reduce tests
- [ ] Validate NCCL scaling and bandwidth
- [ ] Tune NCCL environment variables
- [ ] Troubleshoot NCCL/IB/GPUDirect issues

_Scripts/notes: [scripts/comm_test.sh]_ (to be created)

---

## 4. Software Environment Validation
- [ ] Confirm NVIDIA driver version
- [ ] Validate CUDA toolkit and nvcc
- [ ] Check cuDNN, NCCL, MPI versions
- [ ] Confirm Mellanox OFED and nv_peer_mem
- [ ] Validate Slurm GRES config and GPU visibility
- [ ] Test `torch.cuda.is_available()`
- [ ] Build a system info validation script

_Scripts/notes: [scripts/env_validation.sh]_ (to be created)

---

## 5. End-to-End AI Training Simulation
- [ ] Run distributed PyTorch/TensorFlow dummy job
- [ ] Validate multi-GPU/multi-node communication
- [ ] Monitor GPU utilization
- [ ] Test checkpoint saving to Lustre
- [ ] Track training step times and scaling
- [ ] Simulate 2-node and 8-node jobs

_Scripts/notes: [scripts/ai_training_sim.sh]_ (to be created)

---

## 6. Optional Enhancements
- [ ] Automate periodic health checks
- [ ] Build a GPU health dashboard
- [ ] Integrate AzNHC results into logging
- [ ] Set performance/availability alerts

_Scripts/notes: [scripts/automation.sh]_ (to be created)

---

## How to Use
- Work through each checklist section after provisioning.
- Add scripts and documentation in the `scripts/` subfolder.
- Update this README as you automate or validate each step. 