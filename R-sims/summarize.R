library(coda)
run_numbers <- 1:11
info <- c()
all_fossils <- c()
all_extant <- c()

for (i in run_numbers) {
	# path to log file
	fossil_log_path <- paste0("rep", i, "/sample/output/sim.log")
	no_fossil_log_path <- paste0("rep", i, "/sample-no-fossils/output/sim.log")	

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
	
	n_fossils <- sum(fossils$min_age == 0.0)
	n_extant <- sum(fossils$min_age != 0.0)
	
	all_fossils <- append(all_fossils, n_fossils)
	all_extant <- append(all_extant, n_extant)
}

paste(all_fossils, collapse = ",")
paste(all_extant, collapse= ",")
paste(info, collapse = ",")
