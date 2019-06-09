## mdires-new.R

## 1.
library(ebimetagenomics)
ps = getProjectSummary("SRP108566")
samples = projectSamples(ps)
otu = lapply(1:4,function(i) {getSampleOtu(ps,samples[i])})

## 2.
lapply(otu,plotOtu)

## 3.
lapply(otu,function(o){dim(o)[1]})

## 4.
lapply(otu,function(o){sum(o$Count)})

## 5.
lapply(otu,function(o){estimateR(o$Count)})
lapply(otu,function(o){breakaway(convertOtuTad(o))})
lapply(otu,function(o){breakaway_nof1(convertOtuTad(o)[-1,])})
divEst=lapply(otu,function(o){analyseOtu(o)})
divEst

## 6.

models = lapply(otu,function(o){
  lapply(c("lnorm","poilog","ls","mzsm"),function(m){
    fitsad(o$Count,m)
  })
})
models

Map(function(ml){Map(function(m){m@min},ml)},models)
## "poilog" consistently best

## 7.

lapply(divEst,function(d){d["N.95"]/d["N.obs"]})
## thousands of times more sampling required!

## 8.

## sig values for the 4 samples for the poilog model all similar...


## eof

