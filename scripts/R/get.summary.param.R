#!/usr/bin/env Rscript

## Aim : This is script to read MCMC samples and provide mean/median/thresh.CI% CI. 
##
## Rscript script input.file output.file thresh.CI
## [Input arguments]
## input.file : filename that contains MCMC samples.
## output.file : filename where output be written.
## thresh.CI : this script will compute thresh.CI% CI.
## [Output]
## output file contains four numbers - sample mean, median, thresh.CI% CI
##
## example:
## Rscript get.summary.param.R RESmLambda RESmLambda.sum 95
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

MCMCsamples = scan(input.file, what = double())
mean.out = mean(MCMCsamples)
lower.bound = (100-thresh.CI)/2/100
upper.bound = 1- (100-thresh.CI)/2/100
quantile.sum = quantile(MCMCsamples, probs=c(lower.bound, 0.5, upper.bound))
out = c(mean.out, as.numeric(quantile.sum[2]), as.numeric(quantile.sum[1]), as.numeric(quantile.sum[3]))

cat(out, file = output.file)










