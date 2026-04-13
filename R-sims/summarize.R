library(coda)
run_numbers <- 1:1
info <- c()
all_fossils <- c()
all_extant <- c()

partial_fossil_percentage <- c() # percentage of fossils included in the analysis
partial_fossil_info <- c() # information for analyses with in between 0 and 100% of the fossils

for (i in run_numbers) {
	# path to log file
	fossil_log_path <- paste0("rep", i, "/sample/output/sim.log")
	no_fossil_log_path <- paste0("rep", i, "/sample-no-fossils/output/sim.log")	
	
	path = paste0("rep", i)
	
	# this is the number of files containing some fossils but not the maximum number
	num_fossil_files <- length(list.files(path = path, pattern = "^fossil"))
	
	trace_fossils <- read.table(fossil_log_path, header=TRUE)
	trace_no_fossils <- read.table(no_fossil_log_path, header=TRUE)	
	
	# convert to mcmc object
	mcmc_chain_fossil <- as.mcmc(trace_fossils[, c("Posterior", "Likelihood", "age_extant_mrca")])
	mcmc_chain_no_fossil <- as.mcmc(trace_no_fossils[, c("Posterior", "Likelihood", "age_extant_mrca")])
	
	# calculate 95% hpd interval with fossils
	interval_fossil <- HPDinterval(mcmc_chain_fossil)
	hpd_fossil <- interval_fossil[6] - interval_fossil[3]
	
	interval_no_fossil <- HPDinterval(mcmc_chain_no_fossil)
	hpd_no_fossil <- interval_no_fossil[6] - interval_no_fossil[3]
	
	rep_info <- (hpd_no_fossil - hpd_fossil) / (hpd_no_fossil)
	info <- append(info, rep_info*100)
	
	fossil_path <- paste0("rep", i, "/sim/fossils.tsv")
	fossils <- read.table(fossil_path, header=TRUE)
	
	n_fossils <- sum(fossils$min_age != 0.0)
	n_extant <- sum(fossils$min_age == 0.0)
	
	all_fossils <- append(all_fossils, n_fossils)
	all_extant <- append(all_extant, n_extant)
	
	for (a in 1:num_fossil_files) {
	  partial_fossil_log_path <- paste0("rep", i, "/fossil_", a, "/output/sim.log")
	  percent_fossils_included <- ((n_fossils -a) / (num_fossil_files + 1)) * 100
	  partial_fossil_percentage <- append(partial_fossil_percentage, percent_fossils_included)
	  
	  # read in partial fossil trace
	  trace_partial_fossils <- read.table(partial_fossil_log_path, header=TRUE)
	  # convert to mcmc object
	  mcmc_chain_partial_fossils <- as.mcmc(trace_partial_fossils[, c("Posterior", "Likelihood", "age_extant_mrca")])
	  
	  # calculate 95% hpd interval with partial fossils
	  partial_interval_fossil <- HPDinterval(mcmc_chain_partial_fossils)
	  partial_hpd_fossil <- partial_interval_fossil[6] - partial_interval_fossil[3]
	  
	  partial_rep_info <- (hpd_no_fossil - partial_hpd_fossil) / (hpd_no_fossil)
	  partial_fossil_info <- append(partial_fossil_info, partial_rep_info*100)
	}
}

paste(all_fossils, collapse = ",")
paste(all_extant, collapse= ",")
paste(info, collapse = ",")

paste(partial_fossil_percentage, collapse = ",")
paste(partial_fossil_info, collapse = ",")

