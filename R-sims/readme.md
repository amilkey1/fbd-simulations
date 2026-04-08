To run simulations:

`. setup.sh` (simulates data and creates sample scripts)

`sbatch rb.slurm` (run RevBayes)

`sbatch rb-no-fossils.slurm` (run RevBayes without fossil data)

`Rscript summarize.R` (summarize output - number of fossils and width of hpd intervals)

`summary.Rmd` contains template file for visualizing results
