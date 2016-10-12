# Introduction to taxa abundance data in R

* Using standard tools for processing sequencing data derived from metagenomic samples (such as the [QIIME](http://qiime.org/) pipeline), it is possible to summarise taxonomic diversity in terms of the taxa present in the samples together with counts representing relative species abundance
* Statistical concepts, models and algorithms from population ecology can be used to try to answer some important questions about the community from which the sample was taken:
  * What was the true diversity of the population sampled, and what distributional form did the true taxa abundance distribution take?
  * Is the distribution consistent with neutral theories of evolution?
  * How much more sequencing would be required in order to sample a given required fraction of the true diversity of the sampled population?

## The R language for statistical computing

* R is a language for statistical computing, modelling, data analysis and visualisation - www.r-project.org
* It is free, open source and cross-platform
* There are good free IDEs, such as [RStudio](https://www.rstudio.com/)
* There are thousands for packages for R, managed in a mirrored repository, known as [CRAN](cran.r-project.org), the comprehensive R archive network
* [Bioconductor](https://bioconductor.org/) is another R repository focussing specifically on high-throughput genomic data, containing over one thousand packages

It is possible to analyse raw sequencing data using Bioconductor packages such as [ShortRead](https://bioconductor.org/packages/release/bioc/html/ShortRead.html), but that is a different subject...

### R packages for analysis of species diversity

R is very popular with ecologists, and so there are many R packages in CRAN for modelling and analysis of species diversity and species abundance data. Although most of this software was not designed with [metagenomic](https://en.wikipedia.org/wiki/Metagenomics) applications in mind, much of it is still very useful for exploratory analysis of metagenomic taxa abundance data.

As there are so many R packages on CRAN it can be a challenge to find the right package for the problem at hand. [CRAN Task Views](https://cran.r-project.org/web/views/) provide an overview of a task or domain, giving a guide to available packages and their functionality. The task view for [Environmetrics](https://cran.r-project.org/web/views/Environmetrics.html) is useful for finding out about packages for ecological applications. A small sample of interesting packages are listed below.

* [sads](https://cran.r-project.org/web/packages/sads/) - simulation of and MLE estimation for species abundance distributions (SADs), including *Poisson-log-normal*
* [vegan](https://cran.r-project.org/web/packages/vegan/) - large package for community ecology - fitting species abundance distributions (SADs), estimating number of unobserved species, etc.
* [untb](https://cran.r-project.org/web/packages/untb/) - unified neutral theory of biodiversity (UNTB) - simulation of ecological drift and estimation of biodiversity parameters
* [BAT](https://cran.r-project.org/web/packages/BAT/) - biodiversity assessment tools (BAT)
* [BiodiversityR](https://cran.r-project.org/web/packages/BiodiversityR/) - mainly a GUI interface for `vegan`

In this session we will use `sads` and `vegan`. Assuming that R is installed and running, these can be loaded with:

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


### Estimation of diversity



R Script: [`sads-test.R`](https://gist.github.com/darrenjw/b946d9e0d871d03411af) - **TODO: update to a demo script in this directory** 




#### (C) 2016 Darren J Wilkinson



