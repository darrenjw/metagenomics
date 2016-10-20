## EBI Metagenomics Portal data from R
## R code for ebimetagenomics package walkthrough



## Introduction and installation

install.packages("ebimetagenomics", repos="http://R-Forge.R-project.org")

library(ebimetagenomics)

help(package="ebimetagenomics")

?getProjectsList

example(getProjectsList)

### Working with the projects list

pl = getProjectsList()

str(pl)
dim(pl)

pl$Study.ID

rownames(pl)

pl$Study.ID[pl$Number.Of.Samples >= 100]

pl$Study.ID[grep("16S",pl$Project.Name)]
pl$Study.ID[grep("sludge",pl$Project.Name)]
pl$Study.ID[grep("Tara",pl$Project.Name)]
pl$Study.ID[agrep("human gut",pl$Project.Name)]

pl["ERP001736",]

### Working with a project summary

ps = getProjectSummary("SRP047083")

str(ps)
dim(ps)

ps$Run.ID
rownames(ps)
projectRuns(ps)

ps["SRR1589726",]

table(ps$Sample.ID)

projectSamples(ps)

runsBySample(ps,"SRS711891")

### Working with taxa abundance data

run = getRunOtu(ps,"SRR1589726")

str(run)
dim(run)

plot(octav(run$Count),main="Preston plot")

run2 = getRunOtu(ps,"SRR1589727")
runMerged = mergeOtu(run,run2)
plot(octav(runMerged$Count),main="Preston plot for merged runs")

run=getSampleOtu(ps,"SRS711891",plot.preston=TRUE)
plot(octav(run$Count),main="Preston plot for sample SRS711891")
dim(run)

head(convertOtuTad(run))
plotOtu(run)



#### (C) 2016 Darren J Wilkinson

