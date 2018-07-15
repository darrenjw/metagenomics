
install.packages("ebimetagenomics")


install.packages("ebimetagenomics", repos="http://R-Forge.R-project.org")


library(ebimetagenomics)


help(package="ebimetagenomics")


?getProjectsList


example(getProjectsList)


pl = getProjectsList()


str(pl)
dim(pl)


pl$Study.ID


rownames(pl)


pl$Study.ID[pl$Number.Of.Samples >= 100]


pl$Study.ID[grep("16S",pl$Study.Name)]
pl$Study.ID[grep("sludge",pl$Study.Name)]
pl$Study.ID[grep("Tara",pl$Study.Name)]
pl$Study.ID[agrep("human gut",pl$Study.Name)]


pl["ERP001736",]


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


analyseOtu(run)

