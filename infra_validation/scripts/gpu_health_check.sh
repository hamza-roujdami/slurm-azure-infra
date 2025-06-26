#!/bin/bash
set -euo pipefail

# GPU/Node Health Check Script
# Usage: bash gpu_health_check.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

fail=0

header() {
  echo -e "\n${YELLOW}==== $1 ====\n${NC}"
}

# 1. List all GPUs
echo -e "${YELLOW}Checking GPU presence with nvidia-smi -L...${NC}"
if command -v nvidia-smi &>/dev/null; then
  nvidia-smi -L || { echo -e "${RED}No GPUs detected!${NC}"; fail=1; }
else
  echo -e "${RED}nvidia-smi not found!${NC}"; fail=1
fi

# 2. ECC memory status
header "ECC Memory Status"
if command -v nvidia-smi &>/dev/null; then
  nvidia-smi -q | grep -A 5 'ECC Mode' || echo -e "${YELLOW}ECC info not found${NC}"
  ecc_errors=$(nvidia-smi -q | grep 'Uncorr' | grep -v 'N/A' | awk '{s+=$NF} END {print s}')
  if [[ "$ecc_errors" != "" && "$ecc_errors" != "0" ]]; then
    echo -e "${RED}Uncorrected ECC errors detected!${NC}"
    fail=1
  else
    echo -e "${GREEN}No uncorrected ECC errors found.${NC}"
  fi
else
  echo -e "${RED}nvidia-smi not found!${NC}"
fi

# 3. NVLink/NVSwitch connectivity
header "NVLink/NVSwitch Topology"
if command -v nvidia-smi &>/dev/null; then
  nvidia-smi topo -m || echo -e "${YELLOW}NVLink topology not available${NC}"
else
  echo -e "${RED}nvidia-smi not found!${NC}"
fi

# 4. PCIe bus health
header "PCIe Bus Health"
if command -v nvidia-smi &>/dev/null; then
  nvidia-smi -q | grep -A 10 'PCI' || echo -e "${YELLOW}PCI info not found${NC}"
else
  echo -e "${RED}nvidia-smi not found!${NC}"
fi

# 5. DCGM diagnostics
header "DCGM Diagnostics"
if command -v dcgmi &>/dev/null; then
  dcgmi diag --run 3 || { echo -e "${RED}DCGM diagnostics failed!${NC}"; fail=1; }
else
  echo -e "${YELLOW}dcgmi (DCGM) not found, skipping...${NC}"
fi

# 6. gpu-burn
header "GPU-Burn Test"
if command -v gpu-burn &>/dev/null; then
  echo -e "${YELLOW}Running gpu-burn for 60 seconds...${NC}"
  gpu-burn 60 || { echo -e "${RED}gpu-burn failed!${NC}"; fail=1; }
else
  echo -e "${YELLOW}gpu-burn not found, skipping...${NC}"
fi

# 7. AzNHC
header "Azure NHC (AzNHC)"
if command -v aznhc &>/dev/null; then
  aznhc run || { echo -e "${RED}AzNHC check failed!${NC}"; fail=1; }
else
  echo -e "${YELLOW}AzNHC not found, skipping...${NC}"
fi

if [[ $fail -eq 0 ]]; then
  echo -e "\n${GREEN}All GPU/node health checks passed!${NC}"
else
  echo -e "\n${RED}Some checks failed. Please review the output above.${NC}"
  exit 1
fi 