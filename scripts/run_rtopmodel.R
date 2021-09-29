# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

par.name <- c("qs0", "lnTe", "m", "Sr0", "Srmax", "td", "vr", "K0", "psi", "dtheta")
par.dim <- length(par.name);
par.min <- c(0, -7, 0.001, 0, 0.005, 0.001, 50, 0.0001, 0.01, 0.01)
par.max <- c(0.0001, 10, 0.25, 0.01, 0.08, 40, 2000, 0.2, 0.5, 0.6)

run_rtopmodel_x <- function(x,
			    path=list(params="params.txt",
				      topidxstats="topidxstats.txt",
				      input="input.txt",
				      output="output.txt",
				      sim="sim"),
			    append=FALSE){
	parval <- write_rtopmodel_x(path$params, x)

	if(append){
		sink(sprintf("%s/x.txt", path$sim), append=TRUE)
		cat(x, "\n")
		sink()

		sink(sprintf("%s/parval.txt", path$sim), append=TRUE)
		cat(parval, "\n")
		sink()
	}

	run_rtopmodel(path)
}

run_rtopmodel <- function(path=list(params="params.txt",
				    topidxstats="topidxstats.txt",
				    input="input.txt",
				    output="output.txt")){
	cmd <- function(...) system(sprintf(...))

	cmd("%s --o parameters=%s topidxstats=%s input=%s output=%s",
	    if(.Platform$OS.type == "windows") "r.topmodel.exe"
	    else "GRASS_VERSION=-1 r.topmodel",
	    path$params, path$topidxstats, path$input, path$output)

	read_rtopmodel_output(path$output, "Qt")
}
