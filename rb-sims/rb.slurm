#!/bin/bash

#SBATCH -p general
#SBATCH -C 'epyc128'
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --array=1-50%50

#SBATCH --job-name=rb
#SBATCH -o rb-%a.out
#SBATCH -e rb-%a.err
#SBATCH --mem=20G

LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib"
export TIMEFORMAT="user-seconds %3U"
cd output${SLURM_ARRAY_TASK_ID}/sample
rb132 mcmc_CEFBDP_Specimens.Rev
