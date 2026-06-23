#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://gitlab.cern.ch/staider/diffusion4sim.git"
BRANCH="rdataloader"
ENV_NAME="diffusion4sim-root"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="$(pwd)/diffusion4sim_run"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# 1- create the conda environment (python 3.10 + ROOT 6.40)
export CONDA_PKGS_DIRS="$WORKDIR/conda_pkgs"
export CONDA_ENVS_PATH="$WORKDIR/conda_envs"
export PIP_CACHE_DIR="$WORKDIR/pip_cache"

if ! conda env list | grep -q "^${ENV_NAME} "; then
    conda env create -f "$SCRIPT_DIR/environment.yml"
fi

eval "$(conda shell.bash hook)"
conda activate "$ENV_NAME"

# 2- clone the repo and checkout the `rdataloader` branch
if [ ! -d "diffusion4sim" ]; then
    git clone --branch "$BRANCH" "$REPO_URL"
fi
cd diffusion4sim
git checkout "$BRANCH"

# 3- install the remaining python dependencies
pip install -r requirements.txt

# 4- set up the results directory
export HF_HOME="$WORKDIR/hf_cache"
export TRANSFORMERS_CACHE="$HF_HOME/hub"
export MPLCONFIGDIR="$WORKDIR/mpl_cache"
mkdir -p "$TRANSFORMERS_CACHE" "$MPLCONFIGDIR"

export RESULTS_DIR="$WORKDIR/outputs"
mkdir -p "$RESULTS_DIR"

# 5- run training and save logs
python scripts/train.py configs/train/edm_allegro_root_benchmark.yaml \
    > "$RESULTS_DIR/out.log" 2>&1

echo "Logs saved to: $RESULTS_DIR/out.log"
echo "Model checkpoints under: $RESULTS_DIR/experiments"