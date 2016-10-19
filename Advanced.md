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

[BDES](http://userweb.eng.gla.ac.uk/christopher.quince/Software/BDES.html) --- Bayesian Diversity Estimation Software (Google search: `Quince BDES`) --- proof-of-concept academic software associated with the paper:

Quince, Curtis, Sloan (2008) [The rational exploration of microbial diversity](http://www.nature.com/ismej/journal/v2/n10/full/ismej200869a.html), *ISME*, **2**, 997--1006.

* Collection of C programs, each for a particular parametric form of the TAD
* Build from source code on Linux (library dependence on the GSL)
* Command-line
* Not particularly well documented or user-friendly
* Not very robust, especially for TADs arising from large metagenomic samples
* But still a useful set of tools for people with good scientific computing skills

### Software under development

* Using the same basic ideas and algorithms from BDES, but re-written from scratch in Scala to run on the JVM
* One program to analyse all models (simultaneously)
* Proper model comparison
* Robust analysis for large samples
* Well documented, and hosted in a public Git repo
* User-friendly interface (GUI and **wrapper R package**, in addition to command-line)
* Distributed as both easy-to-build source and ready-to-run platform-independent ``assembly jar"

Currently in development --- experimental (command-line) release for demo purposes...

Eventually hope to include in EBI Metagenomics analysis pipeline...

#### Demo

* Repo at: https://bitbucket.org/ncl_metagenomics/emp-dev-scala - open this up in another tab, and have a quick skim through the readme
* Pop up a command shell of some kind (not an R session) ready to work with this software, and `cd` into an appropriate directory
* If you are a git person, you can clone this repo in the usual way. eg. `git clone git@bitbucket.org:ncl_metagenomics/emp-dev-scala.git` if you have certs on [bitbucket](https://bitbucket.org/), or using https if you don't.
* For non-git users, just go to the [downloads page](https://bitbucket.org/ncl_metagenomics/emp-dev-scala/downloads) and download the latest version of repository, and move the zip file to your directory and unpack with something like:
```bash
unzip ncl_metagenomics-emp-dev-scala-83bdd3d8d8fe.zip
cd ncl_metagenomics-emp-dev-scala-83bdd3d8d8fe
```
Note that the hash may be different for you, so adapt appropriately.
* This is a [scala](http://www.scala-lang.org/) project, built using [sbt](http://www.scala-sbt.org/). Like all scala sbt projects, it should be completely trivial to build, test and run from source on any system with a recent version of Java installed. So if `java -version` returns something sensible - eg. a version number beginning 1.8, then you should be able to build this project with
```bash
./sbt fat:assembly
```
or `.\sbt fat:assembly` on Windows. Note that the first time you run sbt it will take a long time and download a lot of stuff - it's possibly not a great idea to do this in the middle of a training session with lots of people...
* The result of the compilation should be a file called `emp_dev_scala-assembly-1.0-fat.jar` in `target/scala-2.11/`
* As an alternative to building, I have a recent version of the assembly available for download. If you are on Linux or a unix-alike, you can probably download it into the current directory with a command like
```bash
wget http://www.mas.ncl.ac.uk/~ndjw1/files/emp_dev_scala-assembly-1.0-fat.jar
```
If you are on Windows, you may just need to use this [download link]( http://www.mas.ncl.ac.uk/~ndjw1/files/emp_dev_scala-assembly-1.0-fat.jar), and then move the file somewhere appropriate.



## Summary

* Tools from population ecology are useful for understanding the biodiversity represented by metagenomic samples
* The R statistical language has many packages which make it easy to do a range of exploratory data analysis tasks associated with species abundance data
* Bayesian hierarchical modelling properly models and propagates the uncertainties inherent in the analysis of sample species abundance data
* Software for Bayesian modelling of species diversity exists now, but more complete and robust software is under development...

## Acknowledgements

This is joint work with [Tom Curtis](http://www.ncl.ac.uk/ceg/role/profile/tomcurtis.html) and Peter Sutovsky, funded jointly with the EBI by the BBSRC BBR grant: [EBI Metagenomics Portal](http://www.bbsrc.ac.uk/research/grants-search/AwardDetails/?FundingReference=BB/M011453/1) led by [Rob Finn](http://www.ebi.ac.uk/about/people/rob-finn) at the [EBI](http://www.ebi.ac.uk/).



#### (C) 2016 Darren J Wilkinson

