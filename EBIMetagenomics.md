# EBI Metagenomics Portal data from R

## Introduction and installation

The EBI Metagenomics Portal (https://www.ebi.ac.uk/metagenomics/) is a rich source of a range of metagenomics data, including data on taxa abundance, which often comes from 16S profiling.

It is perfectly possible to use the [web portal](https://www.ebi.ac.uk/metagenomics/) to search and browse for data of interest, then download required data in CSV or tab-delimited format. This can then be loaded into R from the local file system. Although this is possible, it quickly becomes slow, cumbersome and error-prone. For many purposes it is better to be able to query the data directly from an R session, and this enables automated data retrieval and analysis workflows.

I have written a small R package called [ebimetagenomics](http://r-forge.r-project.org/projects/ebimetagenomics/) for this purpose. It should be possible to install this directly from [CRAN](https://cran.r-project.org/) via:

```r
install.packages("ebimetagenomics")
```

However, this package is currently undergoing rapid development, so it is probably better to install it directly from [R-Forge](https://r-forge.r-project.org/) with:

```r
install.packages("ebimetagenomics", repos="http://R-Forge.R-project.org")
```

and update it regularly. Note that if you are installing from R-Forge, you need to make sure that the CRAN [sads](https://cran.r-project.org/web/packages/sads/) package is already installed (if you installing from CRAN, dependencies should be automatically pulled in).

Once installed, it can be loaded with:

```r
library(ebimetagenomics)
```

Help can be obtained with:

```r
help(package="ebimetagenomics")
```

This will list the functions provided by the package, together with very brief descriptions. Further information about each function can be obtained with, eg.

```r
?getProjectsList
```

Note that there are examples illustrating the use of every function. These can be run with, eg.

```r
example(getProjectsList)
```

## A walk-through of the package for querying and downloading taxa abundance data










### (C) 2016 Darren J Wilkinson


