library(coda)
library(phytools)
library(ape)

run_numbers <- 1:25
info <- c()
all_fossils <- c()
all_extant <- c()
all_fossils_mean <- c()
no_fossils_mean <- c()

true_heights <- c()

partial_fossil_percentage <- c() # percentage of fossils included in the analysis
partial_fossil_info <- c() # information for analyses with in between 0 and 100% of the fossils
partial_fossil_mean <- c()

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
	
	fossil_mean <- mean(mcmc_chain_fossil[,3])
	all_fossils_mean <- append(all_fossils_mean, fossil_mean)

        no_fossil_mean <- mean(mcmc_chain_no_fossil[,3])
        no_fossils_mean <- append(no_fossils_mean, no_fossil_mean)

	temp_percent <- c()
	temp_info <- c()
	temp_mean <- c()

	# get true height of crown age
	tree_file = paste0("rep", i, "/fbd.tre")
	tree <- read.tree(tree_file)
	extant_tips <- getExtant(tree)
	mrca_node <- findMRCA(tree, tips = extant_tips)
	crown_height <- nodeheight(tree, mrca_node)
	tree_depth <- max(nodeHeights(tree))
	crown_age <- tree_depth - crown_height
	
	true_heights <- append(true_heights, crown_age)	
	temp_percent <- append(temp_percent, 0.0)
	temp_mean <- append(temp_mean, no_fossil_mean)

	for (a in 1:num_fossil_files) {
	  partial_fossil_log_path <- paste0("rep", i, "/fossil_", a, "/output/sim.log")
	  percent_fossils_included <- ((n_fossils - a) / (n_fossils)) * 100
	  temp_percent <- append(temp_percent, percent_fossils_included)

	  # read in partial fossil trace
	  trace_partial_fossils <- read.table(partial_fossil_log_path, header=TRUE)
	  # convert to mcmc object
	  mcmc_chain_partial_fossils <- as.mcmc(trace_partial_fossils[, c("Posterior", "Likelihood", "age_extant_mrca")])

	  # calculate 95% hpd interval with partial fossils
	  partial_interval_fossil <- HPDinterval(mcmc_chain_partial_fossils)
	  partial_hpd_fossil <- partial_interval_fossil[6] - partial_interval_fossil[3]

	partial_rep_info <- (hpd_no_fossil - partial_hpd_fossil) / (hpd_no_fossil)
	temp_info <- append(temp_info, partial_rep_info*100)

	partial_rep_mean <- mean(mcmc_chain_partial_fossils[,3])
	temp_mean <- append(temp_mean, partial_rep_mean)
	}

	temp_info <- append(temp_info, info)
	temp_mean <- append(temp_mean, fossil_mean)
	temp_percent <- append(temp_percent, 100.0)
	
	partial_fossil_percentage[[i]] <- temp_percent
	partial_fossil_info[[i]] <- temp_info
	partial_fossil_mean[[i]] <- temp_mean
}

cat("number of fossils\n")
paste(all_fossils, collapse = ",")

cat("number of taxa\n")
paste(all_extant, collapse= ",")

cat("information\n")
paste(info, collapse = ",")

cat("mean no fossils\n")
paste(no_fossils_mean, collapse = ",")

cat("mean all fossils\n")
paste(all_fossils_mean, collapse = ",")

cat("true crown group heights\n")
paste(true_heights, collapse = ",")

cat("partial fossil percentages\n")
dput(partial_fossil_percentage)

cat("partial fossil information\n")
dput(partial_fossil_info)

cat("partial fossil mean\n")
dput(partial_fossil_mean)
