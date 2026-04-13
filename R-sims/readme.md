To run simulations:

`. setup.sh` (simulates data and creates sample scripts)

`sbatch rb.slurm` (run RevBayes)

`sbatch rb-no-fossils.slurm` (run RevBayes without fossil data)

`sbatch rb-all-fossils.slurm` (run RevBayes with all fossil data)

`. submit-some-fossils.sh` (run RevBayes with varying numbers of fossils)

`Rscript summarize.R` (summarize output - number of fossils and width of hpd intervals)

`summary.Rmd` contains template file for visualizing results
