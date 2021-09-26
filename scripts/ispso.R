################################################################################
# Isolated-Speciation-based Particle Swarm Optimization (ISPSO) extends
# Species-based PSO (SPSO) for finding multiple global and local minima.
#
# Author: Huidae Cho, Ph.D. <grass4u@gmail.com>, Texas A&M University
#
# Requires: R <http://r-project.org> and R packages: fOptions, plotrix
#
# Available at: https://idea.isnew.info/ispso.html
#
# Cite this software as:
#   Cho, H., Kim, D., Olivera, F., Guikema, S. D., 2011. Enhanced Speciation in
#   Particle Swarm Optimization for Multi-Modal Problems. European Journal of
#   Operational Research 213 (1), 15-23.
#
# Isolated-Speciation-based Particle Swarm Optimization (ISPSO)
# Copyright (C) 2008, Huidae Cho <https://idea.isnew.info>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

library("fOptions") # runif.sobol
library("plotrix") # draw.arc

printf <- function(...) cat(sprintf(...))
diagonal <- function(s) sqrt(sum((s$xmax-s$xmin)^2))

ispso <- function(s, pop=c(), nest=c()){
################################################################################
# SUBROUTINES
################################################################################

mytryCatch <- function(expr, error) tryCatch(expr, error=function(e) error)
plotswarm <- function(s)
	s$.plot_method != "" &&
	s$.plot_method != "profile" &&
	s$.plot_method != "diversity" &&
	s$.plot_method != "mean_diversity" &&
	1
plotmethod <- function(s, method)
	any(unlist(strsplit(s$.plot_method, ","))==method)
mydist <- function(s, ...) as.matrix(dist(if(s$D == 1) c(...) else rbind(...)))
mydist2 <- function(...) sqrt(sum((...)^2))
mynrow <- function(x) if(is.null(x)) 0 else if(is.vector(x)) 1 else nrow(x)
myncol <- function(x)
	if(is.null(x)) 0 else if(is.vector(x)) length(x) else ncol(x)
colmax <- function(x, ...){
	ret <- c()
	for(i in 1:myncol(x)) ret[i] <- max(x[,i], ...)
	ret
}
colmin <- function(x, ...){
	ret <- c()
	for(i in 1:myncol(x)) ret[i] <- min(x[,i], ...)
	ret
}
myround <- function(x, digits=0) floor(x*10^digits+0.5)/10^digits

################################################################################
# Evaluate function values.
################################################################################
evaluate_f <- function(){
#-DEBUG-------------------------------------------------------------------------
if(plotswarm(s)){
if(s$D == 1){
.f <- c()
for(.x in x) .f <- c(.f, s$f(.x))
if(plotmethod(s, "movement"))
	plot(x, .f, col=1:s$S, xlim=c(s$xmin[1], s$xmax[1]),
		ylim=c(min(.F), max(.F)), xlab="x1", ylab="f(x1)")
#{DEBUG: We don't know true solutions in real problems.
if(.have_sols){
	.x <- s$f(x[1,], TRUE)
	.fnest <- c()
	for(.x1 in .x) .fnest <- c(.fnest, s$f(.x1))
	points(.x, .fnest, pch=3, cex=2, lwd=2, col="red")
	draw.arc(.x, .fnest, .plot_rsol, 0, 2*pi, col="gray", lty="dotted")
}
#}
if(!is.null(nest)){
	.fnest <- c()
	for(.x in nest[,1:s$D]) .fnest <- c(.fnest, s$f(.x))
	points(nest[,1:s$D], .fnest, pch=4, cex=2, lwd=2)
	draw.arc(nest[,1:s$D], .fnest,
		s$rnest, 0, 2*pi, col="black", lty="dotted")
}
if(plotmethod(s, "density")) points(x, .f, col=1:s$S)
}else
#-------------------------------------------------------------------------------
if(s$D >= 2){
if(plotmethod(s, "movement")){
	plot(x[,s$.plot_x], col=1:s$S,
		xlim=c(s$xmin[s$.plot_x[1]], s$xmax[s$.plot_x[1]]),
		ylim=c(s$xmin[s$.plot_x[2]], s$xmax[s$.plot_x[2]]),
		xlab=sprintf("x%d", s$.plot_x[1]),
		ylab=sprintf("x%d", s$.plot_x[2]))
	if(!is.null(prev_x))
		arrows(prev_x[,s$.plot_x[1]], prev_x[,s$.plot_x[2]],
			x[,s$.plot_x[1]], x[,s$.plot_x[2]],
			length=.1, col=1:s$S)
}
#{DEBUG: We don't know true solutions in real problems.
if(.have_sols){
	.x <- s$f(x[1,], TRUE)
	points(matrix(.x[,s$.plot_x], nrow(.x), 2),
		pch=3, cex=2, lwd=2, col="red")
	draw.arc(.x[,s$.plot_x[1]], .x[,s$.plot_x[2]],
		.plot_rsol, 0, 2*pi, col="gray", lty="dotted")
}
#}
if(!is.null(nest)){
	points(matrix(nest[,s$.plot_x], nrow(nest), 2), pch=4, cex=2, lwd=2)
	draw.arc(nest[,s$.plot_x[1]], nest[,s$.plot_x[2]],
		s$rnest, 0, 2*pi, col="black", lty="dotted")
}
if(plotmethod(s, "density")) points(x[,s$.plot_x], col=1:s$S)

prev_x <<- x
prev_f <<- f
}
}
#-------------------------------------------------------------------------------
	f <<- c()
	for(i in 1:s$S){
		f[i] <<- s$f(x[i,])
		if(f[i] < pbest[i, s$D+1] ||
			(f[i] == Inf && pbest[i, s$D+1] == Inf)){
			pbest[i,] <<- c(x[i,], f[i])
			if(f[i] < gbest[s$D+1] ||
				(f[i] == Inf && gbest[s$D+1] == Inf)){
				gbest <<- c(x[i,], f[i])
				gb <<- i
			}
		}
	}
	evals <<- evals + s$S
	age <<- age + 1
#-DEBUG-------------------------------------------------------------------------

if(s$D == 1){
if(plotmethod(s, "movement")){
	if(!is.null(prev_f))
		arrows(prev_x[,1], prev_f, x[,1], f, length=.1, col=1:s$S)

	prev_x <<- x
	prev_f <<- f
}
}
#-------------------------------------------------------------------------------
}

################################################################################
# Update particle velocities. (SPSO, Li, 2004)
################################################################################
update_v <- function(){
	########################################################################
	# SPSO
	lbest <- matrix(nrow=s$S, ncol=s$D)
	l <- order(f)
	species <<- c()
	seed <<- c()
	isolated <- rep(1, s$S)
	for(i in 1:s$S){
		if(is.null(seed)){
			lbest[l[i],] <- x[l[i],]
			seed <<- l[i]
			species[seed] <<- seed
			next
		}
		n <- length(seed)
		found <- FALSE
		for(j in 1:n){
			if(mydist2(x[seed[j],]-x[l[i],]) <= s$rspecies){
				found <- TRUE
				isolated[c(l[i], seed[j])] <- 0
				species[l[i]] <<- seed[j]
				lbest[l[i],] <- x[seed[j],]
				break
			}
		}
		if(found)
			next
		n <- n + 1
		seed[n] <<- l[i]
		species[seed[n]] <<- seed[n]
		lbest[l[i],] <- x[l[i],]

		fseed <- f[l[i]]

		#{SPSO_NEIGHBOURING_SPECIES
		# A new species seed searches for superior particles within its
		# speciation radius that failed to form their own species, but
		# happened to belong to seeds with better fitness values.  This
		# behaviour allows superior particles to share their
		# information with neighbouring species having relatively poor
		# fitness values.
		for(j in (1:s$S)[-l[i]]){
			if(f[j] < fseed &&
				mydist2(x[j,]-x[l[i],]) <= s$rspecies){
				lbest[l[i],] <- x[j,]
				fseed <- f[j]
			}
		}
		# End of SPSO_NEIGHBOURING_SPECIES}

		#{SPSO_NEIGHBOURING_PBESTS
		# A new species seed searches for superior pbests within its
		# speciation radius. This behaviour allows superior pbests to
		# share their information with neighbouring species having
		# relatively poor fitness values.
		for(j in (1:s$S)[-l[i]]){
			if(pbest[j, s$D+1] < fseed &&
			mydist2(pbest[j, 1:s$D]-x[l[i],]) <= s$rspecies){
				lbest[l[i],] <- pbest[j, 1:s$D]
				fseed <- pbest[j, s$D+1]
			}
		}
		# End of SPSO_NEIGHBOURING_PBESTS}
	}

	#{SPSO_ISOLATED_SPECIES
	# Isolated particles form one species.
	if(any(isolated==1)){
		# Ignore isolated seeds
		seed <<- seed[isolated[seed]==0]
		age[isolated==1] <<- 1
		n <- length(seed) + 1
		tmp <- cbind(1:s$S, isolated, f)
		tmp <- tmp[order(tmp[,3]),]
		seed[n] <<- tmp[tmp[,2]==1,1][1]
		species[seed[n]] <<- -seed[n]
		for(i in which(isolated==1)){
			lbest[i,] <- x[seed[n],]
			species[i] <<- -seed[n]
		}
	}
	# End of SPSO_ISOLATED_SPECIES}
#-DEBUG-------------------------------------------------------------------------
if(plotswarm(s)){
if(s$D == 1){
	.f <- c()
	for(.x in x[seed,])
		.f <- c(.f, s$f(.x))
	points(x[seed,], .f, col=seed, pch=20)
	if(plotmethod(s, "species"))
		draw.arc(x[seed,], .f, s$rspecies, 0, 2*pi, col=seed)
}else
if(s$D >= 2){
	if(length(seed) == 1)
		points(x[seed, s$.plot_x[1]], x[seed, s$.plot_x[2]],
			col=seed, pch=20)
	else
		points(x[seed, s$.plot_x], col=seed, pch=20)
	if(plotmethod(s, "species"))
		draw.arc(x[seed, s$.plot_x[1]], x[seed, s$.plot_x[2]],
			s$rspecies, 0, 2*pi, col=seed)
}
}
#-------------------------------------------------------------------------------
	# Constriction PSO (Clerc and Kennedy, 2000)
	v <<- s$w*(v +
		s$c1*t(runif(s$D)*t(pbest[,1:s$D]-x)) +
		s$c2*t(runif(s$D)*t(lbest[,1:s$D]-x)))
	#{CHECK_NESTS
	# Check existing nests before flying to new points.
	if(!is.null(nest)){
		for(i in seed){
			if(any(mydist(s, x[i,]+v[i,], nest[,1:s$D])[1,
				2:(nrow(nest)+1)] < 2*s$rnest)){
				num_exclusions <<- num_exclusions + 1
				# turbulence area: 2*rnest
				v[i,] <<- v[i,] + s$rspecies*runif(s$D)
			}
		}
	}
	# End of CHECK_NESTS}

	v <<- t(pmax(t(v), -s$vmax))
	v <<- t(pmin(t(v), s$vmax))

	#{Confinement: random forth
	for(i in 1:s$S){
		j <- which(x[i,]+v[i,]<s$xmin)
		k <- length(j)
		if(k)
			v[i, j] <<- (x[i, j]-s$xmin[j])*runif(k)
		j <- which(x[i,]+v[i,]>s$xmax)
		k <- length(j)
		if(k)
			v[i, j] <<- (s$xmax[j]-x[i, j])*runif(k)
	}
	# End of confinement}

	V <<- sqrt(rowSums(v^2))
	pop <<- rbind(pop, cbind(x, f, v=V, age))
}

#-------------------------------------------------------------------------------
fly_away_and_substitute <- function(neighbours){
	n <- sum(neighbours)
	x[neighbours,] <<- new_x(n)
	v[neighbours,] <<- new_v(n)
	age[neighbours] <<- 0
}
#-------------------------------------------------------------------------------

################################################################################
# Convergence check for SPSO
################################################################################
check_for_convergence <- function(){
	#{NEST_BY_AGE
	# Nesting criteria using particles' ages.
	for(i in seed){
		if(age[i] < s$age)
			next

		halflife <- pop[s$S*(iter-1:halflife.age)+i,]

		if(exp(mean(log((
			colmax(if(s$D == 1) t(halflife[,1:s$D])
				else halflife[,1:s$D])-
			colmin(if(s$D == 1) t(halflife[,1:s$D])
				else halflife[,1:s$D]))/
			(s$xmax-s$xmin)))) <= s$xeps
			&& sd(halflife[,"f"]) <= s$feps){
			run <- evals - s$S + i
			nest <<- rbind(nest, c(x[i,], f[i], V[i],
				age[i], run, evals), deparse.level=0)
			num_exclusions_per_nest[nrow(nest)] <<- num_exclusions
			num_exclusions <<- 0
			fly_away_and_substitute(
				mydist(s, x[,1:s$D])[i,] <= s$rspecies)
printf("\b\b\b\bf(x[%d,])=%g added at iter=%d, run=%d, evals=%d, nest=%d\n", i, f[i], iter, run, evals, nrow(nest))
		}
	}

	if(!is.null(nest) && !is.null(s$exclusion_factor) && num_exclusions){
		delta_sol_iters <- (nest[, s$D+4]-
			c(0, nest[-nrow(nest), s$D+4]))/s$S
		average_delta_sol_iter <- mean(delta_sol_iters)
		delta_curr_iter <- delta_sol_iters[nrow(nest)]

		func_difficulty <- max(delta_sol_iters)/average_delta_sol_iter

printf("\b\b\b\b%d%%", min(100, myround(
	100*(num_exclusions/s$S)/(s$exclusion_factor*func_difficulty))))

		if(!s$dont_stop &&
			num_exclusions/s$S > s$exclusion_factor*func_difficulty)
			return(TRUE)
	}

	if(!s$dont_stop){
		if(s$.stop_after_solutions > 0)
			return(s$.stop_after_solutions == mynrow(nest))

		if(s$.stop_after_solutions < 0 && .have_sols &&
			!is.null(nest) && nrow(nest) == length(found))
			return(TRUE)
	}

	return(FALSE)
	# End of NEST_BY_AGE}
}

################################################################################
# Update particle positions.
################################################################################
update_x <- function(){
	x <<- x + v

	#{PREY
	# Inferior particles are preyed by superior ones in neighbours. Note
	# that x and f do not correspond because x has been updated since f was
	# evaluated. Therefore, information sharing is based on the past
	# experiences (pbest and the previous position's f value)
	d <- mydist(s, x)
	n <- nrow(d)
	preyed <- rep(0, s$S)
	for(i in 1:(n-1)){
		for(j in (i+1):n){
			if(preyed[j] || d[i, j] > s$rprey)
				next
			preyed[j] <- 1
			# share pbest infos
			if(pbest[i, s$D+1] > pbest[j, s$D+1])
				pbest[i,] <<- pbest[j,]
			# share infos about the previous positions
			if(f[i] > f[j]){
				x[i,] <<- x[j,]
				v[i,] <<- v[j,]
			}
			# new particles from Sobol' sequences
			x[j,] <<- new_x()
			v[j,] <<- new_v()
			pbest[j,] <- c(x[j,], BEST)
			age[j] <<- 0
		}
	}
	# End of PREY}

	#{CHECK_NESTS
	# Check existing nests before flying to new points.
	if(!is.null(nest)){
		d <- mydist(s, nest[,1:s$D], x)
		n <- nrow(nest)
		for(i in 1:n){
			rnst <- s$rnest
			for(j in which(d[i, n+1:s$S]<=rnst)){
				if(j == gb){
					gb <<- order(pbest[,s$D+1])[2]
					gbest <<- pbest[gb,]
				}
				num_exclusions <<- num_exclusions + 1
				x[j,] <<- new_x()
				v[j,] <<- new_v()
				pbest[j,] <<- c(x[j,], BEST)
				age[j] <<- 0
			}
		}
	}
	# End of CHECK_NESTS}
}

################################################################################
# New particles' positions
################################################################################
new_x <- function(n=1, seed=-1){
	r <- if(seed >= 0) runif.sobol(n, s$D, TRUE, 3, seed)
		else runif.sobol(n, s$D, FALSE, 3)
	t(s$xmin+(s$xmax-s$xmin)*t(r))
}

################################################################################
# New particles' velocities
################################################################################
new_v <- function(n=1){
	v <- c()
	for(i in 1:n){
		r <- runif(s$D)
		v <- rbind(v, s$vmax0 / sqrt(sum(r^2)) * r)
	}
	v
}

.runif.sobol <- function(n, dimension, init=TRUE, scrambling=0, seed=4711)
	matrix(runif(n*dimension), n, dimension)

################################################################################
# VARIABLES
################################################################################

	#-----------------------------------------------------------------------
	# default values for debugging variables
	# Deterministic run?
	if(is.null(s$.deterministic))
		s$.deterministic <- FALSE
	# Stop if all the solutions are found! This is only for writing a
	# paper, not for real problems because the number of actual solutions
	# is not known in most cases.
	if(is.null(s$.stop_after_solutions))
		s$.stop_after_solutions <- 0
	# (0, 1]: Fraction of the diagonal span of the search space.
	if(is.null(s$.plot_distance_to_solution))
		s$.plot_distance_to_solution <- 0.05
	# default plotting method for 1 and 2 dimensional problems: movement
	if(is.null(s$.plot_method))
		s$.plot_method <- "movement"
	# default 2-d plot
	if(is.null(s$.plot_x))
		s$.plot_x <- 1:2
	# no delay between plots
	if(is.null(s$.plot_delay))
		s$.plot_delay <- 0
	# don't save plots
	if(is.null(s$.plot_save_prefix))
		s$.plot_save_prefix <- ""
	#-----------------------------------------------------------------------
	# Does the user provide the real solutions to s$f?
	if(any(mytryCatch(s$f(rep(0, s$D), TRUE), "no_sols") == "no_sols"))
		.have_sols <- FALSE
	else
		.have_sols <- TRUE
	.plot_rsol <- diagonal(s)*s$.plot_distance_to_solution

	if(s$S < 2)
		stop("Swarm size (s$S) must be greater than 1.")

	if(s$.plot_save_prefix == "")
		.plot_save_format <- ""
	else
		.plot_save_format <- sprintf("%s%%0%dd.png",
					     s$.plot_save_prefix,
					     floor(log10(s$maxiter)+1))

	# Don't stop the algorithm until s$maxiter? FALSE by default
	if(is.null(s$dont_stop))
		s$dont_stop <- FALSE

	# Constriction PSO (Clerc and Kennedy, 2000)
	if(is.null(s$c1))
		s$c1 <- 2.05
	if(is.null(s$c2))
		s$c2 <- 2.05
	if(is.null(s$w))
		s$w <- 2/abs(2-s$c1-s$c2-sqrt((s$c1+s$c2)^2-4*(s$c1+s$c2)))

	BEST <- Inf
	WORST <- -BEST

	# PSO
	if(s$.deterministic){
		if(!exists("seed.sobol"))
			seed.sobol <<- 4711
		if(exists("seed.random"))
			.Random.seed <<- seed.random
		else{
			set.seed(0)
			seed.random <<- .Random.seed
		}
	}else{
		seed.sobol <<- as.integer(runif(1)*100000)
		seed.random <<- .Random.seed
	}

	x <- if(is.null(pop)) new_x(s$S, seed.sobol)
		else pop[order(-pop[,"f"])[1:s$S],1:s$D]
	v <- new_v(s$S)

	pbest <- matrix(nrow=s$S, ncol=s$D+1)
	gbest <- c()
	gb <- 0
	pbest[,s$D+1] <- gbest[s$D+1] <- BEST
	prev_gbestf <- WORST
	f <- c()
	age <- rep(0, s$S)
	V <- c()
	halflife.age <- myround(0.5*s$age)

	seed <- c()
	species <- c()
	#{DEBUG: We don't know true solutions in real problems.
	if(.have_sols)
		found <- rep(0, nrow(s$f(x[1,], TRUE)))
	#}

#-DEBUG-------------------------------------------------------------------------
if(plotswarm(s)){
	palette(rainbow(s$S))
	prev_x <- prev_f <- c()
if(s$D == 1){
	.X1 <- seq(s$xmin[1], s$xmax[1], (s$xmax[1]-s$xmin[1])/100)
	.F <- c()
	for(.x in .X1) .F <- c(.F, s$f(.x))
	plot(.X1, .F, xlim=c(s$xmin[1], s$xmax[1]), type="l", col="lightgrey",
		xlab="x1", ylab="f(x1)")
}else
if(s$D >= 2){
	plot(2*s$xmax[s$.plot_x[1]], 2*s$xmax[s$.plot_x[1]],
		xlim=c(s$xmin[s$.plot_x[1]], s$xmax[s$.plot_x[1]]),
		ylim=c(s$xmin[s$.plot_x[2]], s$xmax[s$.plot_x[2]]),
		xlab=sprintf("x%d", s$.plot_x[1]),
		ylab=sprintf("x%d", s$.plot_x[2]))
}
}
#-------------------------------------------------------------------------------

################################################################################
# START HERE!
################################################################################
	diversity <- mean_diversity <- c()
	evals <- iter <- 0
	num_exclusions_per_nest <- c()
	num_exclusions <- 0
	repeat{
		iter <- iter + 1
		diversity[iter] <- mean(sqrt(rowSums(t(t(x)-colMeans(x))^2)))
		mean_diversity[iter] <- mean(diversity[1:iter])
if(plotmethod(s, "mean_diversity")){
		plot(1:iter, mean_diversity, type="b", pch=20,
			xlab="iters", ylab="mean diversity")
}else
if(plotmethod(s, "diversity")){
		plot(1:iter, diversity, type="b", pch=20,
			xlab="iters", ylab="diversity")
}
		evaluate_f()
		update_v()
		if(check_for_convergence() || (s$maxiter && iter == s$maxiter))
			break
		update_x()
#-DEBUG-------------------------------------------------------------------------
if(plotmethod(s, "profile")){
		if(!is.null(nest)){
			.n <- mynrow(nest)
			.evals <- c(0, nest[,s$D+4], evals)
			.sols <- c(0:.n, .n)
		}else{
			.evals <- c(0, evals)
			.sols <- c(0, 0)
		}
		plot(.evals, .sols, type="b", pch=20, xlab="evals", ylab="sols")
}
if(.plot_save_format != ""){
		if(!exists(".plots"))
			.plots <- 0
		.plots <- .plots + 1
		savePlot(sprintf(.plot_save_format, .plots))
}
if(s$.plot_method != "" && s$.plot_delay > 0)
		Sys.sleep(s$.plot_delay)
#-------------------------------------------------------------------------------
	}

#-DEBUG-------------------------------------------------------------------------
if(plotmethod(s, "profile")){
	if(!is.null(nest)){
		.n <- mynrow(nest)
		.evals <- c(0, nest[,s$D+4], evals)
		.sols <- c(0:.n, .n)
	}else{
		.evals <- c(0, evals)
		.sols <- c(0, 0)
	}
	plot(.evals, .sols, type="b", pch=20, xlab="evals", ylab="sols")
}
if(plotswarm(s)){
if(s$D == 1){
	lines(.X1, .F, col="lightgrey")
	if(!is.null(nest)){
		.fnest <- c()
		for(.x1 in nest[,1:s$D]) .fnest <- c(.fnest, s$f(.x1))
		points(nest[,1:s$D], .fnest, pch=4, cex=2, lwd=2)
	}
}else
if(s$D == 2){
	.X1 <- seq(s$xmin[1], s$xmax[1], (s$xmax[1]-s$xmin[1])/50)
	.X2 <- seq(s$xmin[2], s$xmax[2], (s$xmax[2]-s$xmin[2])/50)
	.f <- c()
	for(.x2 in .X2) for(.x1 in .X1) .f <- c(.f, s$f(c(.x1, .x2)))
	.F <- matrix(.f, length(.X1), length(.X2))
	contour(.X1, .X2, .F, xlim=c(s$xmin[1], s$xmax[1]), ylim=c(s$xmin[2],
		s$xmax[2]), col="lightgrey", add=TRUE, nlevels=50)
	if(!is.null(nest))
		points(matrix(nest[,1:s$D], nrow(nest), s$D), pch=4, cex=2,
			lwd=2)
}
}
if(.plot_save_format != ""){
		if(!exists(".plots"))
			.plots <- 0
		.plots <- .plots + 1
		savePlot(sprintf(.plot_save_format, .plots))
}
#-------------------------------------------------------------------------------

	if(!is.null(nest))
		colnames(nest) <- c(paste(sep="", "x", 1:s$D), "f", "v", "age",
			"run", "evals")
	colnames(pop) <- c(paste(sep="", "x", 1:s$D), "f", "v", "age")

	invisible(list(
		iter=iter,
		evals=evals,
		nest=nest,
		pop=pop))
}
