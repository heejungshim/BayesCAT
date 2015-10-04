#!/usr/bin/env Rscript

## Aim : This is script to read MCMC samples and provide mean/median/thresh.CI% CI. 
##
## Rscript script input.file output.file thresh.CI
## [Input arguments]
## input.file : filename that contains MCMC samples.
## output.file : filename where output be written.
## thresh.CI : this script will compute thresh.CI% CI.
## numParas : number of parameters in input.file
## [Output]
## output file contains numParam number of rows, and each row contains four numbers - each column sample mean, median, thresh.CI% CI
##
## example:
## Rscript get.summary.param.R RESmLambda RESmLambda.sum 95 numParam
## 
## Copyright (C) 2014 Heejung Shim
##
## License: GPL3+

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
print(args)

input.file = args[1]
output.file = args[2]
thresh.CI = as.numeric(args[3])
numParam = as.numeric(args[4])


lower.bound = (100-thresh.CI)/2/100
upper.bound = 1- (100-thresh.CI)/2/100


if(numParam == 1){
  MCMCsamples = scan(input.file, what = double())
  mean.out = mean(MCMCsamples)
  quantile.sum = quantile(MCMCsamples, probs=c(lower.bound, 0.5, upper.bound))
  out = c(mean.out, as.numeric(quantile.sum[2]), as.numeric(quantile.sum[1]), as.numeric(quantile.sum[3]))
  cat(out, file = output.file)
}else{
  MCMCsamples = read.table(input.file)
  mean.out = apply(MCMCsamples, 2, mean)
  quantile.sum = apply(MCMCsamples, 2, quantile, probs = c(0.5, lower.bound, upper.bound))
  out = matrix(data=NA, nc = 4, nr = numParam)
  out[,1] = t(mean.out)
  out[,2:4] = t(quantile.sum)
  write.table(out, file=output.file,quote=FALSE,row.names = FALSE, col.names = FALSE)
}









