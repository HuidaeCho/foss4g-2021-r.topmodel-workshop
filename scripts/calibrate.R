#!/usr/bin/env Rscript
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

source("config.R")
source("../scripts/ispso.R")
source("../scripts/read_write_rtopmodel.R")
source("../scripts/run_rtopmodel.R")

obs_c <- read.table(path_c$obs)[[1]]
sim_c_fmt <- sprintf("%s/sim_c_%%0%dd.txt", path_c$sim, floor(log10(nruns))+1)

cmd <- function(...) system(sprintf(...))

obj <- c()
run <- 0

set_parameters <- function(s){
	########################################################################
	# Plot method
	#s$.plot_method <- "density"
	#s$.plot_method <- "movement"
	#s$.plot_method <- sprintf("%s,species", s$.plot_method)
	s$.plot_method <- ""
	s$.plot_delay <- 0
	########################################################################

	# Swarm size
	#s$S <- 10 + floor(2*sqrt(s$D))
	s$S <- 20

	# Maximum particle velocity
	s$vmax <- (s$xmax-s$xmin)*0.1

	# Maximum initial particle velocity
	s$vmax0 <- diagonal(s)*0.001

	# Stopping criteria: Stop if the number of exclusions per particle
	# since the last minimum is greater than exclusion_factor * max sol
	# iter / average sol iter. The more difficult the problem is (i.e.,
	# high max sol iter / average sol iter), the more iterations the
	# algoritm requires to stop.
	s$exclusion_factor <- 3
	# Maximum iteration
	s$maxiter <- nruns/s$S
	# Small positive number close to 0
	s$xeps <- 0.001
	s$feps <- 0.0001

	# Search radius for preys: One particle has two memories (i.e., x and
	# pbest).  When two particles collide with each other within prey, one
	# particle takes more desirable x and pbest from the two particles'
	# memories, and the other particle is replaced with a quasi-random
	# particle using scrambled Sobol' sequences (PREY).
	s$rprey <- diagonal(s)*0.0001

	# Nesting criteria for global and local optima using particles' ages
	# (NEST_BY_AGE).
	s$age <- 10

	# Speciation radius: Li (2004) recommends 0.05*L<=rspecies<=0.1*L.
	s$rspecies <- diagonal(s)*0.2

	# Nesting radius
	s$rnest <- diagonal(s)*0.01

	invisible(s)
}

s <- list()
s$f <- function(x){
	run <<- run + 1
	sim_c <- run_rtopmodel_x(x, path_c, TRUE)

	write.table(sim_c, sprintf(sim_c_fmt, run), row.names=FALSE, col.names=FALSE)

	obj[run] <<- calc_obj(obs_c, sim_c, skip_c)
	sink(sprintf("%s/obj.txt", path_c$sim), append=TRUE)
	cat(obj[run], "\n")
	sink()
	printf("%d: %f\n", run, obj[run])

	return(obj[run])
}
s$D <- par.dim
s$xmin <- rep(0, s$D)
s$xmax <- rep(1, s$D)
s <- set_parameters(s)

ret <- ispso(s)
