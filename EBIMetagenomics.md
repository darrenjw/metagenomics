# EBI Metagenomics Portal data from R

## Introduction and installation

The EBI Metagenomics Portal (https://www.ebi.ac.uk/metagenomics/) is a rich source of a range of metagenomics data, including data on taxa abundance, which often comes from 16S profiling.

It is perfectly possible to use the [web portal](https://www.ebi.ac.uk/metagenomics/) to search and browse for data of interest, then download required data in CSV or tab-delimited format. This can then be loaded into R from the local file system. Although this is possible, it quickly becomes slow, cumbersome and error-prone (though the [bulk download facility](https://github.com/ProteinsWebTeam/ebi-metagenomics/wiki/Downloading-results-programmatically) makes it much less so). For many purposes it is better to be able to query the data directly from an R session, and this enables automated data retrieval and analysis workflows.

I have written a small R package called [ebimetagenomics](http://r-forge.r-project.org/projects/ebimetagenomics/) for this purpose. It should be possible to install this directly from [CRAN](https://cran.r-project.org/web/packages/ebimetagenomics/) via:

```r
install.packages("ebimetagenomics")
```

However, this package is currently undergoing rapid development, so it is probably better to install the latest version directly from [R-Forge](https://r-forge.r-project.org/) with:

```r
install.packages("ebimetagenomics", repos="http://R-Forge.R-project.org")
```

and update it regularly. Note that if you are installing from R-Forge, you may need to manually install some dependencies from CRAN (if you installing from CRAN, dependencies should be automatically pulled in).

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

### Working with the projects list

If you already know the `projectID` of the study you are interested in, you can skip this section. The projects list allows high-level exploration of the projects contained in the [EBI Metagenomics Portal](https://www.ebi.ac.uk/metagenomics/). We typically begin by obtaining the latest version of the list:

```r
pl = getProjectsList()
```

The function returns a data frame containing the full list of projects, one row per project. The structure of the frame can be probed with:

```r
str(pl)
dim(pl)
```

At the time of writing there are over 700 projects, and important fields include `Study.ID` (which corresponds to the `projectID` required for the function `getProjectSummary()` in this package), `Study.Name` and `Number.Of.Samples`. These can be used to find the ID of a study of interest. For example, a list of *all* project IDs can be obtained with

```r
pl$Study.ID
```

or

```r
rownames(pl)
```

A list of studies containing at least 100 samples can be obtained with:

```r
pl$Study.ID[pl$Number.Of.Samples >= 100]
```

A list of studies with name containing particular text can be obtained with commands like:

```r
pl$Study.ID[grep("16S",pl$Study.Name)]
pl$Study.ID[grep("sludge",pl$Study.Name)]
pl$Study.ID[grep("Tara",pl$Study.Name)]
pl$Study.ID[agrep("human gut",pl$Study.Name)]
```

The information relating to one particular study can be extracted with, eg.

```r
pl["ERP001736",]
```

### Working with a project summary

Once a study of interest has been identified, a more detailed project summary can be downloaded into a data frame with, eg.

```r
ps = getProjectSummary("SRP047083")
```

This data frame lists all *runs* associated with the project, one row per run. Note that there can be multiple runs per sample. The structure of the frame can be probed with:

```r
str(ps)
dim(ps)
```

Important fields include `Sample.ID` and `Run.ID`. A list of all runs associated with the project can be obtained in several different ways, eg.

```r
ps$Run.ID
rownames(ps)
projectRuns(ps)
```

If a particular run ID is known and of interest, the information associated with that particular run can be extracted with, eg.

```r
ps["SRR1589726",]
```

A table of the number of runs associated with each sample in the project can be obtained with:

```r
table(ps$Sample.ID)
```

Similarly, a list of sample IDs associated with the project can be obtained with:

```r
projectSamples(ps)
```

**Note** the *convention used in this package* that functions beginning with `get` involve a query over the *internet* to the EBI servers, and functions which do not begin with `get` do not.

Given a particular sample ID, a list of runs associated with that sample ID can be obtained with, eg.:

```r
runsBySample(ps,"SRS711891")
```

### Working with taxa abundance data

The project summary file contains all of the information needed to be able to directly query the EBI servers for run data. In principle this could be used for querying any run data held on the servers, but currently this package only has functions for querying [OTU](https://en.wikipedia.org/wiki/Operational_taxonomic_unit) data. OTU data associated with a particular run can be downloaded into a data frame with, eg.

```r
run = getRunOtu(ps,"SRR1589726")
```

This data frame contains information on all OTUs encountered in the run, one row per OTU. The structure of the frame can be probed with:

```r
str(run)
dim(run)
```

The data frame contains three variables: `OTU`, corresponding to the OTU ID, `Count`, representing the number of times the OTU was encountered in the run, and `Tax`, a string containing a taxonomic classification associated with the OTU. 

Note that the function `getRunOtu` contains two optional Boolean arguments, `verb` and `plot.preston`, both of which default to `FALSE`. The former simply echos the run ID to the console, and the latter displays a [Preston plot](https://en.wikipedia.org/wiki/Relative_species_abundance) for the OTU data. This can be useful to get a quick visual understanding of the nature of the run. After downloading, a plot can be constructed manually with:

```r
plot(octav(run$Count),main="Preston plot")
```

The function `mergeOtu` can be used to merge together two OTU data frames to produce a new OTU data frame.

```r
run2 = getRunOtu(ps,"SRR1589727")
runMerged = mergeOtu(run,run2)
plot(octav(runMerged$Count),main="Preston plot for merged runs")
```

More than two OTU data frames can be merged in this way. See the `?mergeOtu` example for how to merge a list of OTU data frames. It is often desirable to download all of the runs associated with a particular sample and to merge the run OTU data frames together to give an overall OTU data frame for the sample. The function `getSampleOtu` automates this process.

It can be run in its simplest form as `run=getSampleOtu(ps,"SRS711891")` but it too has optional Boolean arguments `verb` and `plot.preston`. Here `verb` defaults to `TRUE`, since it is usually useful to have a progress update, and the `plot.preston` argument is often worth using to "see" the data as it is being downloaded.

```r
run=getSampleOtu(ps,"SRS711891",plot.preston=TRUE)
plot(octav(run$Count),main="Preston plot for sample SRS711891")
dim(run)
```

The taxa abundance count data now downloaded into the R session can be utilised in the same way as any other species abundance data in R.

Note that the package includes the function `convertOtuTad()` which re-tabulates OTU counts as a taxa abundance distribution (TAD), and `plotOtu()`, which does a selection of 4 plots for a given set of OTU counts.

```r
head(convertOtuTad(run))
plotOtu(run)
```

Commonly required stats associated with OTU counts can be computed with the function `analyseOtu()`.

```r
analyseOtu(run)
```

As well as computing various different estimates of the total number of taxa in the community that was sampled, it also computes estimates (assuming a Poission-log-normal TAD) of the number of sequences required in order to observe a given fraction of the total species present. This can be useful for estimating required sequencing effort. 



#### (C) 2017 Darren J Wilkinson


