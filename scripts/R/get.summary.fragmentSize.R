#!/usr/bin/env Rscript

## Aim : This is script to read MCMC samples of indel fragment sizes and
## provide a posterior estimate of realized indel fragment size distribution.  
##
## Rscript script input.file.insertion input.file.deletion output.file
## [Input arguments]
## input.file.insertion : filename that contains MCMC samples of insertion fragment size
## input.file.deletion : filename that contains MCMC samples of deletion fragment size
## output.file : filename where output will be written.
## [Output]
## output file contains three rows, and each row contains a posterior estimate of realized indel (insertion, deletion)
## fragment size distribution.
##
## example:
## Rscript get.summary.fragmentSize.R RESIleninAlle RESDleninAlle IDlen.sum
## 
## Copyright (C) 2014 Heejung Shim
##
## License: GPL3+

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
print(args)

input.I.file = args[1]
input.D.file = args[2]
output.file = args[3]


##' 'getIDlen' takes MCMC samples of insertion (deletion) fragment size and
##' return a list of lists. Each list corresponds to each MCMC  sample and contains a vector of insertion (deletion) fragment size for each split.
##' If there is no realized indel event, it has NULL. 
##'
##'
##' @param input.x MCMC samples of insertion (deletion) fragment size  
##' @return a list of lists.
getIDlen <- function(input.x){

  x = as.matrix(input.x)
  res = lapply(x, function(y){ if(is.na(y)){return (NULL)
                                           }else{
                                             if(length(grep(" ", y))==0){
                                               return (as.numeric(y))
                                             }else{
                                               return (as.numeric(unlist(strsplit(y, split=" "))))
                                             }
                                           }
                              })
  return (res)

}


##' 'getIDlenDist' takes a list of lists for insertion and/or deletion fragment sizes and
##' returns a realized insertion and/or deletion fragment size distribution for each MCMC sample.
##'
##' @param index index in MCMC samples
##' @param max.val maximum value for indel fragment size
##' @param len.dat1 a list of lists for insertion or deletion fragment size
##' @param len.dat2 if it is NULL, use only len.dat1. Othewise, combine len.dat1 and len.dat2
##' @return res a realized insertion and/or deletion fragment size distribution for each MCMC sample
getIDlenDist <- function(index, max.val, len.dat1, len.dat2 = NULL){

  res = rep(0, max.val)
  
  if(is.null(len.dat2)){
    len.vec = unlist(len.dat1[[index]])
    len.freq = table(len.vec)
    res[as.numeric(names(len.freq))] = len.freq/length(len.vec)
  }else{
    len.vec = c(unlist(len.dat1[[index]]), unlist(len.dat2[[index]]))
    len.freq = table(len.vec)
    res[as.numeric(names(len.freq))] = len.freq/length(len.vec)
 }

 return (res)

}


## Read MCMC samples and convert them to a list of lists for insertion and/or deletion fragment sizes
dat = read.table(input.I.file, sep=";", as.is=TRUE)
Ilen.dat = apply(dat[,1:(dim(dat)[2]-1)], 1, getIDlen)

dat = read.table(input.D.file, sep=";", as.is=TRUE)
Dlen.dat = apply(dat[,1:(dim(dat)[2]-1)], 1, getIDlen)


## Compute a posterior estimate of realized insertion and/or deletion fragment size distribution
numSam = length(Ilen.dat)

max.all = max(unlist(Ilen.dat), unlist(Dlen.dat))
IDlen.dist = sapply(1:numSam, getIDlenDist, max.val = max.all, len.dat1 = Ilen.dat, len.dat2 = Dlen.dat)
IDlen.dist.PP = apply(IDlen.dist, 1, mean)

max.I = max(unlist(Ilen.dat))
Ilen.dist = sapply(1:numSam, getIDlenDist, max.val = max.I, len.dat1 = Ilen.dat, len.dat2 = NULL)
Ilen.dist.PP = apply(Ilen.dist, 1, mean)

max.D = max(unlist(Dlen.dat))
Dlen.dist = sapply(1:numSam, getIDlenDist, max.val = max.D, len.dat1 = Dlen.dat, len.dat2 = NULL)
Dlen.dist.PP = apply(Dlen.dist, 1, mean)


cat("Indel ", file=output.file)
cat(IDlen.dist.PP, file=output.file, append = TRUE)
cat("\n", file=output.file, append = TRUE)
cat("Insertion ", file=output.file, append = TRUE)
cat(Ilen.dist.PP, file=output.file, append = TRUE)
cat("\n", file=output.file, append = TRUE)
cat("Deletion ", file=output.file, append = TRUE)
cat(Dlen.dist.PP, file=output.file, append = TRUE)
cat("\n", file=output.file, append = TRUE)


   
















