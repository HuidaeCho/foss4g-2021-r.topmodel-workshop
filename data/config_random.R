nruns <- 10000
skip_c <- 365
skip_v <- 365
path_c <- list(params="params.txt",
	       topidxstats="topidxstats.txt",
	       input="input_c_pet.txt",
	       output="output_c.txt",
	       sim="sim_random",
	       obs="obs_c.txt")
path_v <- list(params="params.txt",
	       topidxstats="topidxstats.txt",
	       input="input_v_pet.txt",
	       output="output_v.txt",
	       obs="obs_v.txt")

calc_nse <- function(obs, sim, skip=0){
	if(skip > 0){
		obs <- obs[-(1:skip)]
		sim <- sim[-(1:skip)]
	}
	1-sum((sim-obs)^2)/sum((mean(obs)-obs)^2)
}

calc_obj <- function(obs, sim, skip=0){
	1-calc_nse(obs, sim, skip)
}

create_best_rtopmodel <- function(){
	obj <- read.table(sprintf("%s/obj.txt", path_c$sim))[[1]]
	x <- read.table(sprintf("%s/x.txt", path_c$sim))
	best_idx <- which(obj==min(obj))
	best_x <- as.numeric(x[best_idx,])
	write_rtopmodel_x(path_c$params, best_x)
}
