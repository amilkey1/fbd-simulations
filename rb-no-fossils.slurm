#!/bin/bash

#SBATCH -p general
#SBATCH -C 'epyc128'
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --array=1-100%100

#SBATCH --job-name=rbnofossil
#SBATCH -o rbnofossil-%a.out
#SBATCH -e rbnofossil-%a.err
#SBATCH --mem=20G

LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib"
export TIMEFORMAT="user-seconds %3U"
cd output${SLURM_ARRAY_TASK_ID}/sample-no-fossils
rb132 mcmc_CEFBDP_Specimens.Rev
