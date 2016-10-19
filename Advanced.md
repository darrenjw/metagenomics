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

### Software Demo

#### Getting started

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
If you are on Windows, you may just need to use this [download link](http://www.mas.ncl.ac.uk/~ndjw1/files/emp_dev_scala-assembly-1.0-fat.jar), and then move the file somewhere appropriate. The assembly is all that is required to run the Bayesian analysis.
* Assuming that the assembly is in its default location, you can run a short test of the software with:
```bash
java -cp target/scala-2.11/emp_dev_scala-assembly-1.0-fat.jar ExperimentScalaRunner --in "data/DemoData/Brazil.sample" -s 100 -c 0.8
```
just to make sure everything seems to work. This will create some (very small) output files in `data/DemoData/`.

#### Analysis of taxa abundance data

* The software takes taxa abundance data as input. This can either be in the form of a `.sample` file, as used by the BDES software, or in the form of a more conventional `.csv` file (containing SAD/TAD data), which we can easily generate from R. The MCMC output files will need to be post-processed using R (or similar) for interpretation.
* Back in R, make sure you have some OTU data from the EMG portal in an object called `otu`. Then, at the R command prompt, use a command like
```r
write.csv(convertOtuTad(otu),"emg-otu-tad.csv",row.names=FALSE)
```
to write out the data in a form readable by the software. Note that it is vital to convert the data to TAD format before writing, and to omit row names from the file output.
* Move the CSV file to the `data/` directory of the software, and then try analysing it with
```r
java -cp target/scala-2.11/emp_dev_scala-assembly-1.0-fat.jar ExperimentScalaRunner --in "data/emg-otu-tad.csv" -s 100 -c 0.9
```
The `-s` argument represents the required number of MCMC iterations. For a "real" analysis, it is likely that you will want this to be `100000`, but this will take a long time - do a preliminary run with `1000` iterations and then multiply up to get a feeling for how long it will take. Above I'm suggesting 100, which is completely useless for any kind of subsequent analysis or interpretation, but should be quick enough to complete in the context of training session. The running time depends on the size of the data, and is a bit unpredictable. The `-c` argument is for the second part of the analysis, which is the desired coverage. eg. specifying a value of 0.9 will cause the software to estimate the sample size required to observe 90% of the true species diversity. Other options are available, such as `-t` to change the thinning interval from the default of 10 (which means store 1 in every 10 MCMC iterations in the output file).
* Output files will be generated in the same directory as the TAD CSV file. The first file of interest will be the one generated by the main MCMC run, which will be of the form `posterior-*.csv`, where `*` will include the name of the input file and a date stamp. This can be read into R with a command like:
```r
out = read.csv("posterior-foo-bar.csv") # use correct filename!
```
where the filename exactly matches that generated by the code. Proper analysis and interpretation of MCMC output is a skilled task in itself. For detailed analysis, you will probably want to use a CRAN package such as [coda](https://cran.r-project.org/package=coda). For a quick look, you could also use the function `mcmcSummary` in my CRAN package [smfsb](https://cran.r-project.org/package=smfsb). This is especially useful for visualising the data to decide how much burn-in to remove and then getting some point estimates and probability intervals for parameters.
```r
library(smfsb)
head(out)
mcmcSummary(out[,2:6]) # omit unwanted columns
mcmcSummary(out[-(1:5),2:6]) # chop off first 5 samples
```
For real runs, it is quite common to remove 100 or 1000 samples as "burn-in". 

The other output file of interest is the "sample size" output, corresponding to the fractional coverage requested at run-time, and this will be of the form `sample_size*.csv`, where `*` will contain additional information about the run. This can be read into R and analysed similarly.
```r
ssout = read.csv("sample_size_foo-bar.csv") # use correct filename!
head(ssout)
mcmcSummary(ssout[,c(1,2,3,5,6)])
mcmcSummary(ssout[-(1:5),c(1,2,3,5)])
```

## Summary

* Tools from population ecology are useful for understanding the biodiversity represented by metagenomic samples
* The R statistical language has many packages which make it easy to do a range of exploratory data analysis tasks associated with species abundance data
* Bayesian hierarchical modelling properly models and propagates the uncertainties inherent in the analysis of sample species abundance data
* Software for Bayesian modelling of species diversity exists now, but more complete and robust software is under development...

## Acknowledgements

This is joint work with [Tom Curtis](http://www.ncl.ac.uk/ceg/role/profile/tomcurtis.html) and Peter Sutovsky, funded jointly with the EBI by the BBSRC BBR grant: [EBI Metagenomics Portal](http://www.bbsrc.ac.uk/research/grants-search/AwardDetails/?FundingReference=BB/M011453/1) led by [Rob Finn](http://www.ebi.ac.uk/about/people/rob-finn) at the [EBI](http://www.ebi.ac.uk/).



#### (C) 2016 Darren J Wilkinson

