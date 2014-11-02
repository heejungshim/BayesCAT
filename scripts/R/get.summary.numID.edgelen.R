#!/usr/bin/env Rscript

## Aim : This is script to read MCMC samples of number of indels and edge length for each split and
## provide a posterior probability for each split and posterior means of the number of indel events
## and the edge length given occurrence of each split.
##
## Rscript script input.numI.file input.numD.file input.edgeLen.file output.file numSeq
## [Input arguments]
## input.numI.file : filename that contains MCMC samples of the number of insertion event for each split
## input.numD.file : filename that contains MCMC samples of the number of deletion event for each split
## input.edgeLen.file : filename that contains MCMC samples of the edge length for each split
## output.file : filename where output will be written.
## numSeq : number of sequence that will be used to generate split name. 
## [Output]
## output file contains four columns: the first column indicates split identifier; the second column is a posterior probability for each split;
## the third and fourth columns are posterior means of the number of indel events and the edge length given occurrence of each split.
##
## example:
## Rscript get.summary.numID.edgelen.R RESmnumIinAlle RESmnumDinAlle RESmedgeLene numID.sum 5
## 
## Copyright (C) 2014 Heejung Shim
##
## License: GPL3+

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
print(args)

input.numI.file = args[1]
input.numD.file = args[2]
input.edgeLen.file = args[3]
output.file = args[4]
numSeq = as.numeric(args[5])


## read MCMC samples of number of indel events and edge length for each split
numI = read.table(input.numI.file)
numD = read.table(input.numD.file)
edgeLen = read.table(input.edgeLen.file)

numSplits = dim(numI)[2]
numSam = dim(numI)[1]

## provide a posterior probability for each split (numS.PP) and posterior means of the number of indel events
## and the edge length given occurrence of each split (numID.PP and edgelen.PP).
edgelen.PP = rep(NA,numSplits)
numID.PP = rep(NA,numSplits)
numS.PP = rep(NA,numSplits)

for(i in 1:numSplits){
  wh = which(edgeLen[,i] > 0)
  len = length(wh)
  numID.PP[i] = (sum(numI[wh,i]) + sum(numD[wh,i]))/len
  edgelen.PP[i] = sum(edgeLen[wh,i])/len
  numS.PP[i] = len/numSam
}


## Make a list of split names
name.Split = matrix(data=0, nr = numSplits, nc = numSeq)
st.ix = 1
for(i in 1:floor(numSeq/2)){
  comL = combn(1:numSeq, i)
  for(j in 1:dim(comL)[2]){
    name.Split[st.ix,t(comL[,j])] = 1 
    st.ix = st.ix + 1
  }
}

name.Split.final = apply(name.Split,1,paste0, collapse='')

out = data.frame(split = name.Split.final, numS.PP = numS.PP, numID.PP = numID.PP, edgelen.PP = edgelen.PP)
write.table(out, file=output.file, quote=FALSE, row.names=FALSE)


