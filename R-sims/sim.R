 library(paleobuddy)
library(ape)

set.seed(1)

for (i in 1:15) {
	dirname = paste("rep", i, sep="")
	setwd(dirname)
	print(dirname)

	lambda <- 1.0
	mu <- 0.2
#	lambda <- rexp(n = 1, rate = 1)
#	mu <- rexp(n = 1, rate = 1)
	psi <- runif(1, min = 0.1, max = 1.0)
#	rho <- runif(1, min=0.1, max=1.0)
	rho <- 1.0
	tMax <- 5.0

	sim <- bd.sim(n0 = 1, lambda = lambda, mu = mu, tMax = tMax, nExtant = c(10, 10))
	phy <- make.phylo(sim)
	fossils <- sample.clade(sim, rho, tMax)

	if (length(fossils$Species) == 0) {
		fbdPhy <- make.phylo(sim, fossils = NULL)
	} else {
		fbdPhy <- make.phylo(sim, fossils)
	}

	ape::write.tree(fbdPhy, file="fbd.tre")
	setwd("..")
}
