# diffusion4sim-benchmark

Reproducible setup recipe for benchmarking [ROOT's `RDataLoader`](https://root.cern.ch/doc/master/group__Py__ML.html) against the original HDF5-based data pipeline used by [`diffusion4sim`](https://gitlab.cern.ch/staider/diffusion4sim), a calorimeter shower generation model (CaloDiT-2, EDM diffusion).

This repository contains a setup script that creates an isolated Conda environment, clones `diffusion4sim` at a pinned branch, downloads the public benchmark dataset from the [ROOT website](https://root.cern/files/), and runs training end to end with logs captured to disk.

## Requirements

- Conda available
- Roughly 5 GB of free disk space for the environment, dependencies, and dataset

## Versions

- Python: 3.10
- ROOT: 6.40


## Usage

```bash
git clone https://github.com/siliataider/diffusion4sim-benchmark.git
cd diffusion4sim-benchmark
bash setup_and_run.sh
```

You can check the outputs at:

- Logs: `diffusion4sim_run/outputs/out.log`
- Checkpoints: `diffusion4sim_run/outputs/experiments`
