#!/bin/bash

#SBATCH -p general
#SBATCH -C 'epyc128'
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=rb
#SBATCH -o rb-%a.out
#SBATCH -e rb-%a.err
#SBATCH --mem=20G

LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib"
export TIMEFORMAT="user-seconds %3U"

TARGET_DIR=$(sed -n "${SLURM_ARRAY_TASK_ID}p" dir_list.txt)

if [ -d "$TARGET_DIR" ]; then
	echo "Processing: $TARGET_DIR"
	cd "$TARGET_DIR"

	rb132 mcmc_CEFBDP_Specimens.Rev
fi
