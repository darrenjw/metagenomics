
library(ebimetagenomics)

getKP = function(studyID) {
 burl = ebimetagenomics:::baseURL
 url = paste(burl,"studies",studyID,"downloads?format=csv",sep="/")
 dl = read.csv(url, stringsAsFactors = FALSE)
 purl = dl$url[grep("phylum",dl$id)][1]
 ttab = read.table(purl, stringsAsFactors = FALSE, header = TRUE)
 rownames(ttab) = paste(ttab[,1],ttab[,2],sep=";")
 ttab = ttab[,-(1:2)]
 ttab
}


kptab = getKP("MGYS00004696")
str(kptab)


head(kptab)


colsums = apply(kptab,2,sum)
normtab = sweep(kptab,2,colsums,"/")
head(normtab)


heatmap(as.matrix(normtab))


pca = prcomp(t(normtab))
plot(pca$x[,1],pca$x[,2],pch=19,col=2)
text(pca$x[,1],pca$x[,2],rownames(pca$x),pos=3,cex=0.6)

