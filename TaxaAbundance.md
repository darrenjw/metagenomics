# Introduction to taxa abundance data in R

## Introduction

* Using standard tools for processing sequencing data derived from metagenomic samples (such as the QIIME pipeline), it is possible to summarise taxonomic diversity in terms of the taxa present in the samples together with counts representing relative species abundance
* Statistical concepts, models and algorithms from population ecology can be used to try to answer some important questions about the community from which the sample was taken:
  * What was the true diversity of the population sampled, and what distributional form did the true taxa abundance distribution take?
  *Is the distribution consistent with neutral theories of evolution?
  *How much more sequencing would be required in order to sample a given required fraction of the true diversity of the sampled population?

## The R language for statistical computing

* R is a language for statistical computing, modelling, data analysis and visualisation - www.r-project.org
* It is free, open source and cross-platform
* There are thousands for packages for R, managed in a mirrored repository, known as CRAN - cran.r-project.org
* [Bioconductor](https://bioconductor.org/) is another R repository focussing specifically on high-throughput genomic data, containing over one thousand packages - www.bioconductor.org

It is possible to analyse raw sequencing data using Bioconductor packages such as [ShortRead](https://bioconductor.org/packages/release/bioc/html/ShortRead.html), but that is a different subject...

### R packages for analysis of species diversity

There are many R packages in CRAN for modelling and analysis of species diversity and species abundance data - useful for exploratory analysis of metagenomic taxa abundance data

* [sads](https://cran.r-project.org/web/packages/sads/) - simulation of and MLE for SADs (including Poisson-log-normal)
* [vegan](https://cran.r-project.org/web/packages/vegan/) - large package for community ecology - fitting species abundance distributions (SADs), estimating number of unobserved species, etc.
* [untb](https://cran.r-project.org/web/packages/untb/) - unified neutral theory of biodiversity - simulation of ecological drift and estimation of biodiversity parameters
* [BAT](https://cran.r-project.org/web/packages/BAT/) - biodiversity assessment tools
* [BiodiversityR](https://cran.r-project.org/web/packages/BiodiversityR/) - mainly a GUI interface for vegan

The [CRAN Task View](https://cran.r-project.org/web/views/) for [Environmetrics](https://cran.r-project.org/web/views/Environmetrics.html) describes many more relevant packages


### Analysis of species abundance data in R

```r
library(vegan)
library(sads)

comm = rsad(S=1000,frac=1,sad="lnorm",meanlog=5,sdlog=2)
barplot(comm,xlab="Species",ylab="Abundance")
comm = comm[order(-comm)]

tad = as.data.frame(table(comm))
names(tad) = c("Abundance","# taxa")
barplot(tad[,2],names.arg=tad[,1],xlab="Abundance",
                                ylab="# species",main="TAD")
tad$Abundance = as.numeric(as.character(tad$Abundance))

oc = octav(comm)
plot(oc,main="Preston plot")
plot(rad(comm),"Rank abundance")

comm=rsad(S=1000,frac=0.0002,sad="lnorm",
                                meanlog=5,sdlog=2)
barplot(comm,xlab="Species",ylab="Abundance")
comm = comm[order(-comm)]

tad = as.data.frame(table(comm))
names(tad) = c("Abundance","# taxa")
barplot(tad[,2],names.arg=tad[,1],xlab="Abundance",
                          ylab="# species",main="TAD")
tad$Abundance = as.numeric(as.character(tad$Abundance))

oc = octav(comm)
plot(oc,main="Preston plot")
plot(rad(comm),"Rank abundance")
```

### An R session

```r
> print(estimateR(comm))
    S.obs   S.chao1  se.chao1     S.ACE    se.ACE 
114.00000 321.56250  69.70477 356.01381  11.74045 
> mod = fitsad(comm)
> print(mod)
Maximum likelihood estimation
Type: continuous  species abundance distribution
Species: 114 individuals: 196 

Call:
mle2(minuslogl = function (N, S) 
-sum(dbs(x = x, N = N, S = S, log = TRUE)), fixed = list(N = 196L, 
    S = 114L), data = list(x = list(12, 9, 7, 7, 6, "etc")), 
    eval.only = TRUE)

Coefficients:
  N   S 
196 114 

Log-likelihood: -175.77 
> plot(mod)

> mod=fitsad(comm,"poilog")
> print(mod)
Maximum likelihood estimation
Type: discrete  species abundance distribution
Species: 114 individuals: 196 

Call:
mle2(minuslogl = function (mu, sig) 
-sum(dtrunc("poilog", x = x, coef = list(mu = mu, sig = sig), 
    trunc = trunc, log = TRUE)), start = list(mu = -3.53145726216054, 
    sig = 1.90294684566867), data = list(x = list(12, 9, 7, 7, 
    6, "etc")))

Coefficients:
       mu       sig 
-3.531457  1.902947 

Truncation point: 0 

Log-likelihood: -122.64 
> plot(mod)
```

R Script: [`sads-test.R`](https://gist.github.com/darrenjw/b946d9e0d871d03411af)

### Limitations of (much) available software}

* Most packages have been designed with more classical population ecology examples in mind, and not all algorithms scale (well) to the very large number of species often observed in metagenomic samples
* Many algorithms are rather simplistic and produce poor estimates
* Most SAD fitting algorithms fit directly to the *observed* SAD, rather than the unobserved *population* SAD - yet it is typically the population SAD that is of scientific interest
* Despite the large uncertainties present, many algorithms either provide point estimates only, or provide simple interval estimates - they can't easily *propagate uncertainty* to downstream derived parameters, such as an estimate of required sequencing effort

### Bayesian methods

* Bayesian hierarchical models provide an elegant framework for describing all observed and unobserved quantities in a statistical model, incorporating both *model* and *parameter uncertainty*, including
  * uncertainty about the parametric form of the true population SAD
  * the unobserved population SAD, in addition to the observed (sampled) SAD
  * the number of (unobserved) species in the population
* The output from the MCMC algorithm is a (large) sample from the posterior distribution over models and parameters, describing the uncertainty remaining having observed the data
* The MCMC sample can be used to correctly *propagate uncertainty* to derived parameters, such as an estimate of required sequencing effort
}

#### Existing MCMC software

[BDES](http://userweb.eng.gla.ac.uk/christopher.quince/Software/BDES.html) --- Bayesian Diversity Estimation Software (Google search: `Quince BDES`) --- proof-of-concept software associated with:

Quince, Curtis, Sloan (2008) [The rational exploration of microbial diversity](http://www.nature.com/ismej/journal/v2/n10/full/ismej200869a.html), *ISME*, **2**, 997--1006.

* Collection of C programs, each for a particular parametric form of the TAD
* Build from source code on Linux (library dependence on the GSL)
* Command-line
* Not particularly well documented or user-friendly
* Not very robust, especially for TADs arising from large metagenomic samples

#### Software under development

* Using the same basic ideas and algorithms from BDES, but re-written from scratch in Scala to run on the JVM
* One algorithm to analyse all models simultaneously
* Proper model comparison
* Robust analysis for large samples
* Well documented
* User-friendly interface (GUI and/or wrapper R package)
* Distributed as both easy-to-build source and ready-to-run ``assembly jar"

Currently in development --- experimental release for demo purposes...

Eventually hope to include in EBI Metagenomics analysis pipeline...

## Summary

* Tools from population ecology are useful for understanding the biodiversity represented by metagenomic samples
* The R statistical language has many packages which make it easy to do a range of exploratory data analysis tasks associated with species abundance data
* Bayesian hierarchical modelling properly models and propagates the uncertainties inherent in the analysis of sample species abundance data
* Software for Bayesian modelling of species diversity exists now, but more complete and robust software is under development


This is joint work with [Tom Curtis](http://www.ncl.ac.uk/ceg/role/profile/tomcurtis.html) and Peter Sutovsky, funded jointly with the EBI by the BBSRC BBR grant: [EBI Metagenomics Portal](http://www.bbsrc.ac.uk/research/grants-search/AwardDetails/?FundingReference=BB/M011453/1) led by [Rob Finn](http://www.ebi.ac.uk/about/people/rob-finn) at the [EBI](http://www.ebi.ac.uk/).




#### (C) 2016 Darren J Wilkinson



