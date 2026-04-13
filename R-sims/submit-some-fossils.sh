NUM_DIRS=$(wc -l < dir_list.txt)

sbatch --array=1-$NUM_DIRS rb-some-fossils.slurm
