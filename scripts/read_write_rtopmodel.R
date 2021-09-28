# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

write_rtopmodel_params <- function(file="params.txt",
				   qs0=NULL, lnTe=NULL, m=NULL, Sr0=NULL,
				   Srmax=NULL, td=NULL, vch=NULL, vr=NULL,
				   infex=NULL, K0=NULL, psi=NULL, dtheta=NULL){
	lines <- readLines(file)
	params <- read_rtopmodel_params_from_lines(lines)

	if(is.null(qs0) && is.null(lnTe) && is.null(m) && is.null(Sr0) &&
	   is.null(Srmax) && is.null(td) && is.null(vch) && is.null(vr) &&
	   is.null(infex) && is.null(K0) && is.null(psi) && is.null(dtheta))
		params$params

	if(!is.null(qs0)){
		params$params$qs0 <- qs0
		lines[params$linenos[1]] <- as.character(qs0)
	}
	if(!is.null(lnTe)){
		params$params$lnTe <- lnTe
		lines[params$linenos[2]] <- as.character(lnTe)
	}
	if(!is.null(m)){
		params$params$m <- m
		lines[params$linenos[3]] <- as.character(m)
	}
	if(!is.null(Sr0)){
		params$params$Sr0 <- Sr0
		lines[params$linenos[4]] <- as.character(Sr0)
	}
	if(!is.null(Srmax)){
		params$params$Srmax <- Srmax
		lines[params$linenos[5]] <- as.character(Srmax)
	}
	if(!is.null(td)){
		params$params$td <- td
		lines[params$linenos[6]] <- as.character(td)
	}
	if(!is.null(vch)){
		params$params$vch <- vch
		lines[params$linenos[7]] <- as.character(vch)
	}
	if(!is.null(vr)){
		params$params$vr <- vr
		lines[params$linenos[8]] <- as.character(vr)
	}
	if(!is.null(infex)){
		params$params$infex <- infex
		lines[params$linenos[9]] <- as.character(infex)
	}
	if(!is.null(K0)){
		params$params$K0 <- K0
		lines[params$linenos[10]] <- as.character(K0)
	}
	if(!is.null(psi)){
		params$params$psi <- psi
		lines[params$linenos[11]] <- as.character(psi)
	}
	if(!is.null(dtheta)){
		params$params$dtheta <- dtheta
		lines[params$linenos[12]] <- as.character(dtheta)
	}
	writeLines(lines, file)

	params$params
}

write_rtopmodel_x <- function(file="params.txt", x){
	if(length(x) != par.dim)
		stop()

	x[x<0] <- 0
	x[x>1] <- 1

	parval <- par.min+(par.max-par.min)*x

	write_text <- sprintf("write_rtopmodel_params(\"%s\"", file)
	for(i in 1:par.dim)
		write_text <- paste(write_text, ",", par.name[i], "=", parval[i], sep="")
	write_text <- paste(write_text, ")", sep="")
	eval(parse(text=write_text))

	parval
}

read_rtopmodel_params <- function(file="params.txt"){
	lines <- readLines(file)
	params <- read_rtopmodel_params_from_lines(lines)

	params$params
}

read_rtopmodel_params_from_lines <- function(lines){
	linenos <- c()
	params <- list()
	l <- 0
	for(i in 1:length(lines)){
		line <- lines[i]
		if(line == "" || substr(line, 1, 1) == "#")
			next
		l <- l + 1
		if(l == 1)
			next

		x <- as.numeric(strsplit(gsub("^[ \t]+|[ \t]+$", "", line),
					 "[ \t]+")[[1]])
		if(l >= 3 && l <= 14 && length(x) >= 1 && !is.na(x[1])){
			linenos[l-2] <- i
			if(l == 3)
				params$qs0 <- x[1]
			else if(l == 4)
				params$lnTe <- x[1]
			else if(l == 5)
				params$m <- x[1]
			else if(l == 6)
				params$Sr0 <- x[1]
			else if(l == 7)
				params$Srmax <- x[1]
			else if(l == 8)
				params$td <- x[1]
			else if(l == 9)
				params$vch <- x[1]
			else if(l == 10)
				params$vr <- x[1]
			else if(l == 11)
				params$infex <- x[1]
			else if(l == 12)
				params$K0 <- x[1]
			else if(l == 13)
				params$psi <- x[1]
			else
				params$dtheta <- x[1]
		}
	}

	list(linenos=linenos, params=params)
}

read_rtopmodel_output <- function(file="output.txt", name="Qt"){
	column <- ifelse(name=="Qt", 12,
		  ifelse(name=="qt", 23,
		  ifelse(name=="qo", 34,
		  ifelse(name=="qs", 45,
		  ifelse(name=="qv", 56,
		  ifelse(name=="S_mean", 67,
		  ifelse(name=="f", 78,
		  ifelse(name=="fex", 89, 12))))))))
	lines <- readLines(file)
	start <- 0
	output <- c()
	for(i in 1:length(lines)){
		line <- lines[i]
		if(substr(line, 1, 10) == "  timestep"){
			start <- i
			next
		}
		if(!start)
			next
		output[i-start] <- as.numeric(substr(line, column, column+9))
	}

	output
}
