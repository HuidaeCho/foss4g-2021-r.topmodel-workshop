#!/usr/bin/env Rscript
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

source("config_random.R")
source("../scripts/ispso.R")
source("../scripts/read_write_rtopmodel.R")
source("../scripts/run_rtopmodel.R")

obs_c <- read.table(path_c$obs)[[1]]
sim_c_fmt <- sprintf("%s/sim_c_%%0%dd.txt", path_c$sim, floor(log10(nruns))+1)

obj <- c()
run <- 0

for(run in 1:nruns){
	x <- runif(par.dim)
	sim_c <- run_rtopmodel_x(x, path_c, TRUE)

	write.table(sim_c, sprintf(sim_c_fmt, run), row.names=FALSE, col.names=FALSE)

	obj[run] <- calc_obj(obs_c, sim_c, skip_c)
	sink(sprintf("%s/obj.txt", path_c$sim), append=TRUE)
	cat(obj[run], "\n")
	sink()
	printf("%d: %f\n", run, obj[run])
}
