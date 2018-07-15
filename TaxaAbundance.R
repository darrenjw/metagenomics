
library(sads)
library(vegan)


library(sads)
help(package="sads")
?"sads-package"
vignette(package="sads")
vignette("sads_intro",package="sads")
?octav
example(octav)


?bci
length(bci)
head(bci)


barplot(bci,xlab="Species",ylab="Abundance")


bci2 = bci[order(-bci)]
head(bci2)
barplot(bci2,xlab="Species",ylab="Abundance")


plot(rad(bci))
head(rad(bci))


abund2sad <- function(abund) {
  sad = as.data.frame(table(abund))
  names(sad) = c("abund","Freq")
  sad$abund = as.numeric(as.character(sad$abund))
  sad
}


sad = abund2sad(bci)
head(sad)
barplot(sad$Freq,names.arg=sad$abund,xlab="Abundance",ylab="# species",main="SAD")


octav(bci)
plot(octav(bci))


set.seed(123)
comm = rsad(S=1000,frac=1,sad="lnorm",coef=list(meanlog=5,sdlog=2))
length(comm)
sum(comm)


op=par(mfrow=c(2,2))
barplot(comm,xlab="Species",ylab="Abundance",main="Taxa abundance")
tad = abund2sad(comm)
barplot(tad[,2],names.arg=tad[,1],xlab="Abundance",
                                ylab="# species",main="TAD")
plot(octav(comm),main="Preston plot")
plot(rad(comm),main="Rank abundance")
par(op)


commFull=comm
comm=rsad(S=1000,frac=0.0005,sad="lnorm",coef=list(meanlog=5,sdlog=2))
length(comm)
sum(comm)


op=par(mfrow=c(2,2))
barplot(comm,xlab="Species",ylab="Abundance",main="Taxa abundance")
tad = abund2sad(comm)
barplot(tad[,2],names.arg=tad[,1],xlab="Abundance",
                                ylab="# species",main="TAD")
plot(octav(comm),main="Preston plot")
plot(rad(comm),main="Rank abundance")
par(op)


mod = fitsad(commFull,"lnorm")
summary(mod)
par(mfrow=c(2,2))
plot(mod)
par(op)


mod = fitsad(comm,"lnorm")
summary(mod)
par(mfrow=c(2,2))
plot(mod)
par(op)


mod = fitsad(comm,"poilog")
summary(mod)
par(mfrow=c(2,2))
plot(mod)
par(op)


library(vegan)
estimateR(commFull)
estimateR(comm)


library(breakaway)
breakaway(abund2sad(commFull))
breakaway(abund2sad(comm))

