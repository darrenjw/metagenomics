# Introduction to taxa abundance data in R

* Using standard tools for processing sequencing data derived from metagenomic samples (such as the [QIIME](http://qiime.org/) pipeline), it is possible to summarise taxonomic diversity in terms of the taxa present in the samples together with counts representing relative species abundance
* Although metagenomics is a relatively new field, ecologists have been studying species abundance and diversity for decades, if not centuries
* Population ecology is a mature discipline, with a huge literature, which makes extensive use of statistical modelling for understanding the effects of sampling on observed data and inferences
* In addition to theory, there are many software tools and libraries that have been produced by ecologist for working with species abundance data
* The main purpose of this session is to make people aware of this connection between metagenomics and population ecology, and to give a *very* brief introduction to some of the useful software tools that are easily and freely available
* Statistical concepts, models and algorithms from population ecology can be used to try to answer some important questions about the community from which the metagenomic sample was taken:
  * What was the true diversity of the population sampled, and what distributional form did the true taxa abundance distribution take?
  * How much more sequencing would be required in order to sample a given required fraction of the true diversity of the sampled population?
  * Is the abundance distribution consistent with neutral theories of evolution?
  * How can I compare species abundance in different metagenomic samples and identify interesting differences that are not simply random sampling effects?
  * Can I test whether a covariate appears to have a significant effect on the abundance distributions observed in my samples?
  * Are the abundance distributions that I observe in my different samples consistent with the notion of a parent "meta-community" from which the samples are derived?

## The R language for statistical computing

* R is a language for statistical computing, modelling, data analysis and visualisation - www.r-project.org
* It is free, open source and cross-platform
* There are good free IDEs, such as [RStudio](https://www.rstudio.com/)
* There are thousands for packages for R, managed in a mirrored repository, known as [CRAN](cran.r-project.org), the comprehensive R archive network
* [Bioconductor](https://bioconductor.org/) is another R repository focusing specifically on high-throughput genomic data, containing over one thousand packages

It is possible to analyse raw sequencing data using Bioconductor packages such as [ShortRead](https://bioconductor.org/packages/release/bioc/html/ShortRead.html), but that is a different subject...

### R packages for analysis of species diversity

R is very popular with ecologists, and so there are many R packages in CRAN for modelling and analysis of species diversity and species abundance data. Although most of this software was not designed with [metagenomic](https://en.wikipedia.org/wiki/Metagenomics) applications in mind, much of it is still very useful for exploratory analysis of metagenomic taxa abundance data.

As there are so many R packages on CRAN it can be a challenge to find the right package for the problem at hand. [CRAN Task Views](https://cran.r-project.org/web/views/) provide an overview of a task or domain, giving a guide to available packages and their functionality. The task view for [Environmetrics](https://cran.r-project.org/web/views/Environmetrics.html) is useful for finding out about packages for ecological applications. A small sample of interesting packages are listed below.

* [vegan](https://cran.r-project.org/web/packages/vegan/) - large package for community ecology - fitting species abundance distributions (SADs), estimating number of unobserved species, etc.
* [sads](https://cran.r-project.org/web/packages/sads/) - simulation of and MLE estimation for species abundance distributions (SADs), including *Poisson-log-normal*
* [breakaway](https://cran.r-project.org/web/packages/breakaway/) - package for diversity estimation
* [untb](https://cran.r-project.org/web/packages/untb/) - unified neutral theory of biodiversity (UNTB) - simulation of ecological drift and estimation of biodiversity parameters
* [BAT](https://cran.r-project.org/web/packages/BAT/) - biodiversity assessment tools (BAT)
* [BiodiversityR](https://cran.r-project.org/web/packages/BiodiversityR/) - mainly a GUI interface for `vegan`

There are a *huge* number of useful software tools relating to population ecology that are potentially valuable for the analysis of metagenomics data, and this can feel a little overwhelming. Everyone at this session is interested in different questions, so it is difficult to give completely generic advice regarding what to invest time and effort into learning. That said, **vegan** is a large, well-regarded and well-documented library that contains a significant number of functions which are likely to be very useful almost irrespective of the scientific questions you are interested in. So, if following this session you are interested in exploring some tools from population ecology but are unsure where to start, my recommendation would be to put some time and effort into working through the available documentation for `vegan`.

In this session we will mainly use `sads` and `vegan`. Assuming that R is installed and running, these can be loaded with:

```r
library(sads)
library(vegan)
```

If they are not installed, then can be installed from CRAN with: `install.packages(c("sads","vegan"))`

### Analysis of species abundance data in R

The `sads` package can be loaded, and information about its use obtained in the usual R ways:

```r
library(sads)
help(package="sads")
?"sads-package"
vignette(package="sads")
vignette("sads_intro",package="sads")
?octav
example(octav)
```

We will start with the analysis of the `bci` dataset in the `sads` package. This is a classical ecological dataset, measuring the abundance of different species of tree in a tropical forest plot. We can find out more about it as follows:

```r
?bci
length(bci)
head(bci)
```

We can do a very simple plot of the abundance of each species as follows:

```r
barplot(bci,xlab="Species",ylab="Abundance")
```

If we prefer, we could first order the species in decreasing order of abundance:

```r
bci2 = bci[order(-bci)]
head(bci2)
barplot(bci2,xlab="Species",ylab="Abundance")
```

This is not dissimilar to a [rank abundance diagram](https://en.wikipedia.org/wiki/Relative_species_abundance) (Whittaker plot), which can be produced with the aid of the `sads` function `rad()`:

```r
plot(rad(bci))
head(rad(bci))
```

However, ecologists often like to think in terms of species abundance distributions (SADs), and for this it can be helpful to think about the number of species having a given abundance. We can re-tabulate our data as a SAD with the help of the following function:

```r
abund2sad <- function(abund) {
  sad = as.data.frame(table(abund))
  names(sad) = c("abund","Freq")
  sad$abund = as.numeric(as.character(sad$abund))
  sad
}
```

We can then convert the `bci` data and plot the SAD as follows:

```r
sad = abund2sad(bci)
head(sad)
barplot(sad$Freq,names.arg=sad$abund,xlab="Abundance",ylab="# species",main="SAD")
```

In fact, this kind of data is typically displayed in the form of a histogram with exponentially increasing bins, known as a *Preston plot*. We can plot these in R with the help of the `octav()` function from the `sads` package.

```r
octav(bci)
plot(octav(bci))
```

The interpretation here is that there are 19 species having an abundance of 1, there are 13 species having an abundance of 2, 14 species having an abundance of 3 or 4, 18 species with an abundance of 5-8, etc.

### Simulating SAD/TAD data

The `sads` package also includes the `rsad()` function for simulating synthetic species/taxa abundance data. This can be very useful for testing analysis workflows and statistical estimation procedures.

One of the key statistical issues in modelling data of this sort is partial observation. Typically one will not actually measure every individual in an ecological community of interest, but instead the individuals in a small fraction of the population, hopefully a random sample. The `bci` dataset is a case in point. Ecologists are not especially interested in the 50 ha plot they studied, but rather in the whole forest, and they hope that they can infer something useful about the forest by extrapolating what they know about the plot they studied. This raises some non-trivial statistical issues. Exactly the same issues arise in the context of metagenomics.

Let's start by generating a synthetic data set corresponding to a fully observed population containing 1000 species having a log-normal TAD.

```r
set.seed(123)
comm = rsad(S=1000,frac=1,sad="lnorm",coef=list(meanlog=5,sdlog=2))
length(comm)
sum(comm)
```

Note that I just set the random seed for reproducibility. Also note that there aren't exactly 1,000 species in the sample (due to the sampling model and species with very low abundance), and that the sample corresponds to the identification of over 1 million individuals. So in the context of metagenomics, this might correspond to over 1 million 16S matches in a sequencing run clustered into roughly 1,000 OTUs. We now know how to plot this kind of data:

```r
op=par(mfrow=c(2,2))
barplot(comm,xlab="Species",ylab="Abundance",main="Taxa abundance")
tad = abund2sad(comm)
barplot(tad[,2],names.arg=tad[,1],xlab="Abundance",
                                ylab="# species",main="TAD")
plot(octav(comm),main="Preston plot")
plot(rad(comm),main="Rank abundance")
par(op)
```

Note that the Preston plot looks very Gaussian, which is as we would expect, due to simulating from a log-normal TAD.

Now let simulate a synthetic sample corresponding to a small fraction (0.05%) of the same population with 1,000 species. 

```r
commFull=comm
comm=rsad(S=1000,frac=0.0005,sad="lnorm",coef=list(meanlog=5,sdlog=2))
length(comm)
sum(comm)
```

Here we have only observed 190 species, corresponding to 407 individuals. We can plot this using exactly the same code as before.

```r
op=par(mfrow=c(2,2))
barplot(comm,xlab="Species",ylab="Abundance",main="Taxa abundance")
tad = abund2sad(comm)
barplot(tad[,2],names.arg=tad[,1],xlab="Abundance",
                                ylab="# species",main="TAD")
plot(octav(comm),main="Preston plot")
plot(rad(comm),main="Rank abundance")
par(op)
```

The key point to notice is that the species abundance distribution for this fractional sample looks very different to the "true" distribution for the fully observed sample, so statistical methods will be required to try and infer something about the true TAD using the observed TAD.

### Statistically fitting species abundance models to data

For our synthetic data problem we have kept both the "full" sample and the fractionally observed sample. As an initial sanity check, we can try fitting a SAD model to our full sample, using the function `fitsad()` in the `sads` package.

```r
mod = fitsad(commFull,"lnorm")
summary(mod)
par(mfrow=c(2,2))
plot(mod)
par(op)
```

We confirm that in this case our fit to a log-normal SAD is excellent, and our estimated coefficients are very close to the "true" values of 5 and 2. Now let's try again with our fractional sample.

```r
mod = fitsad(comm,"lnorm")
summary(mod)
par(mfrow=c(2,2))
plot(mod)
par(op)
```

Here we see that the fit is rather poor, and that the estimated parameters are also far from the true values used to generate the data. However, we know that our sample has been generated from a (Poisson) sampling mechanism from an underlying log-normal population. This is consistent with a Poisson-log-normal model, so we can re-fit using that.

```r
mod = fitsad(comm,"poilog")
summary(mod)
par(mfrow=c(2,2))
plot(mod)
par(op)
```

Here we see that the fit is much better, but the parameter estimates still look poor. However, the distribution theory underpinning the Poisson-log-normal suggests that the sample should have theoretical mean and standard deviation of 5+log(0.0005)=-2.6 and 2, which aren't so far away from the estimates.

See the vignette for the package: `vignette("sads_intro",package="sads")` for a more detailed discussion of model fitting and selection using this package.

### Estimation of diversity

Given the observed sample, and its observed species richness, it is natural to want to estimate the true biodiversity of the population that has been sampled. As previously discussed, this is a non-trivial statistical problem, but there are some well-known estimators implemented in the aforementioned `vegan` package.

We can load up `vegan` and get a list of vignettes with:
```r
library(vegan)
vignette(package="vegan")
```
You will see that there are several useful vignettes giving a tutorial introduction to several different aspects of the package functionality. For the purposes of this session, the `diversity-vegan` vignette is of particular interest.
```r
vignette("diversity-vegan")
```
When you have time (after this session), it would be worth spending some time working through this document carefully.

We can compute some estimates of species diversity from our sample as follows:
```r
estimateR(commFull)
estimateR(comm)
```

We get the Chao estimator and the adjusted Chao estimator (ACE), together with estimates of standard error. For our full sample, the estimators correctly deduce that the vast majority of species are present in our sample. For our fractional sample, the estimators detect that there are a significant number of unobserved species. However, they substantially underestimate the true species richness of the parent population. The Chao estimator is well-known to underestimate true species diversity, but it serves as a useful lower bound. 

#### Breakaway

Note finally that there are other available methods for species richness estimation, and some of these are implemented in other R packages on CRAN. For example, the package `breakaway` implements some methods recently proposed in the literature. If this package is installed (if not, `install.packages("breakaway")`), we can use it as follows.

```r
library(breakaway)
breakaway(abund2sad(commFull))
breakaway(abund2sad(comm))
```

Note that this package requires abundance data in the SAD form, as given by the output of the function `abund2sad()`. Further details are given in the package documentation. In this case the estimate is worse than that of the Chao estimator, but this won't always be so. Diversity estimation is a non-trivial problem!




#### (C) 2016-18 Darren J Wilkinson



