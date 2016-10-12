# Advanced software for diversity and coverage estimation

## Limitations of (much) available software

* Most packages have been designed with more classical population ecology examples in mind, and not all algorithms scale (well) to the very large number of species often observed in metagenomic samples
* Many algorithms are rather simplistic and produce poor estimates
* Most SAD fitting algorithms fit directly to the *observed* SAD, rather than the unobserved *population* SAD - yet it is typically the population SAD that is of scientific interest
* Despite the large uncertainties present, many algorithms either provide point estimates only, or provide simple interval estimates - they can't easily *propagate uncertainty* to downstream derived parameters, such as an estimate of required sequencing effort

## Bayesian methods

* Bayesian hierarchical models provide an elegant framework for describing all observed and unobserved quantities in a statistical model, incorporating both *model* and *parameter uncertainty*, including
  * uncertainty about the parametric form of the true population SAD
  * the unobserved population SAD, in addition to the observed (sampled) SAD
  * the number of (unobserved) species in the population
* The output from the MCMC algorithm is a (large) sample from the posterior distribution over models and parameters, describing the uncertainty remaining having observed the data
* The MCMC sample can be used to correctly *propagate uncertainty* to derived parameters, such as an estimate of required sequencing effort


### Existing MCMC software

[BDES](http://userweb.eng.gla.ac.uk/christopher.quince/Software/BDES.html) --- Bayesian Diversity Estimation Software (Google search: `Quince BDES`) --- proof-of-concept software associated with:

Quince, Curtis, Sloan (2008) [The rational exploration of microbial diversity](http://www.nature.com/ismej/journal/v2/n10/full/ismej200869a.html), *ISME*, **2**, 997--1006.

* Collection of C programs, each for a particular parametric form of the TAD
* Build from source code on Linux (library dependence on the GSL)
* Command-line
* Not particularly well documented or user-friendly
* Not very robust, especially for TADs arising from large metagenomic samples
* But still a useful set of tools for people with good scientific computing skills

### Software under development

* Using the same basic ideas and algorithms from BDES, but re-written from scratch in Scala to run on the JVM
* One algorithm to analyse all models simultaneously
* Proper model comparison
* Robust analysis for large samples
* Well documented
* User-friendly interface (GUI and/or wrapper R package)
* Distributed as both easy-to-build source and ready-to-run ``assembly jar"

Currently in development --- experimental release for demo purposes...

Eventually hope to include in EBI Metagenomics analysis pipeline...

#### Demo

**TODO**


## Summary

* Tools from population ecology are useful for understanding the biodiversity represented by metagenomic samples
* The R statistical language has many packages which make it easy to do a range of exploratory data analysis tasks associated with species abundance data
* Bayesian hierarchical modelling properly models and propagates the uncertainties inherent in the analysis of sample species abundance data
* Software for Bayesian modelling of species diversity exists now, but more complete and robust software is under development


This is joint work with [Tom Curtis](http://www.ncl.ac.uk/ceg/role/profile/tomcurtis.html) and Peter Sutovsky, funded jointly with the EBI by the BBSRC BBR grant: [EBI Metagenomics Portal](http://www.bbsrc.ac.uk/research/grants-search/AwardDetails/?FundingReference=BB/M011453/1) led by [Rob Finn](http://www.ebi.ac.uk/about/people/rob-finn) at the [EBI](http://www.ebi.ac.uk/).



#### (C) 2016 Darren J Wilkinson

