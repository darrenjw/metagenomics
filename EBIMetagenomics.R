
install.packages("ebimetagenomics")


install.packages("ebimetagenomics", repos="http://R-Forge.R-project.org")


library(ebimetagenomics)


help(package="ebimetagenomics")


?getProjectsList


example(getProjectsList)


pl = getProjectsList()


str(pl)
dim(pl)


pl$accession


rownames(pl)


pl$accession[pl$samples_count >= 100]


pl$accession[grep("16S",pl$study_name)]
pl$accession[grep("sludge",pl$study_name)]
pl$accession[grep("Tara",pl$study_name)]
pl$accession[agrep("human gut",pl$study_name)]


pl$accession[pl$secondary_accession=="ERP001736"]
pl["MGYS00000410",]


ps = getProjectSummary("SRP047083")


str(ps)
dim(ps)


ps$run_id
rownames(ps)
projectRuns(ps)


ps["SRR1589726",]


table(ps$sample_id)


projectSamples(ps)


runsBySample(ps,"SRS711891")


run = getRunOtu("SRR1589726")


str(run)
dim(run)


plot(octav(run$Count),main="Preston plot")


run2 = getRunOtu("SRR1589727")
runMerged = mergeOtu(run,run2)
plot(octav(runMerged$Count),main="Preston plot for merged runs")


run=getSampleOtu(ps,"SRS711891",plot.preston=TRUE)
plot(octav(run$Count),main="Preston plot for sample SRS711891")
dim(run)


head(convertOtuTad(run))
plotOtu(run)


analyseOtu(run)


models = lapply(c("lnorm","poilog","ls","mzsm"), function(m){fitsad(run$Count,m)})
models
lapply(models, function(x){x@min})


op=par(mfrow=c(2,2))
plot(models[[1]])
par(op)

