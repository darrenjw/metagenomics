# MGnify data from R

## Introduction and installation

MGnify (https://www.ebi.ac.uk/metagenomics/) is a rich source of a range of metagenomics data, including data on taxa abundance, which often (but not always) comes from 16S profiling.

It is perfectly possible to use the [web portal](https://www.ebi.ac.uk/metagenomics/) to search and browse for data of interest, then download required data in CSV or tab-delimited format. This can then be loaded into R from the local file system. Although this is possible, it quickly becomes slow, cumbersome and error-prone (though the [bulk download facility](https://github.com/ProteinsWebTeam/ebi-metagenomics/wiki/Downloading-results-programmatically) makes it much less so). For many purposes it is better to be able to query the data directly from an R session, and this enables automated data retrieval and analysis workflows. 

I have written a small R package called [ebimetagenomics](http://r-forge.r-project.org/projects/ebimetagenomics/) for querying EBI Metagenomics data using the [MGnify API](https://emg-docs.readthedocs.io/en/latest/api.html). It should be possible to install this directly from [CRAN](https://cran.r-project.org/web/packages/ebimetagenomics/) with `install.packages("ebimetagenomics")`. However, this package is currently undergoing rapid development, so it is probably better to install the latest version directly from [R-Forge](https://r-forge.r-project.org/) with `install.packages("ebimetagenomics", repos="http://r-forge.r-project.org")` and update it regularly. Note that if you are installing from R-Forge, you may need to manually install some dependencies from CRAN (if you installing from CRAN, dependencies should be automatically pulled in).

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

```
## 
## gtPrjL> ## No test: 
## gtPrjL> ##D pl = getProjectsList()
## gtPrjL> ##D str(pl)
## gtPrjL> ##D 
## gtPrjL> ##D # Find big projects
## gtPrjL> ##D biggies = pl$accession[pl$samples_count >= 100]
## gtPrjL> ##D ps = getProjectSummary(biggies[3])
## gtPrjL> ##D 
## gtPrjL> ##D # Find some 16S projects
## gtPrjL> ##D pl$accession[agrep("16S",pl$study_name)]
## gtPrjL> ##D 
## gtPrjL> ##D # Look up primary accession using secondary accession
## gtPrjL> ##D pl$accession[pl$secondary_accession=="SRP047083"]
## gtPrjL> ## End(No test)
## gtPrjL> 
## gtPrjL>
```

## A walk-through of the package for querying and downloading taxa abundance data

### Working with the projects list

If you already know the accession ID of the study you are interested in, you can skip this section. The projects list allows high-level exploration of the projects contained in [MGnify](https://www.ebi.ac.uk/metagenomics/). We typically begin by obtaining the latest version of the list:


```r
pl = getProjectsList()
```

The function returns a data frame containing the full list of projects, one row per project. The structure of the frame can be probed with:


```r
str(pl)
```

```
## 'data.frame':	2849 obs. of  18 variables:
##  $ url                : chr  "https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00004729?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00004728?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00004726?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00004725?format=csv" ...
##  $ samples            : logi  NA NA NA NA NA NA ...
##  $ biomes             : chr  "[OrderedDict([('type', 'biomes'), ('id', 'root:Host-associated:Human:Respiratory system:Nasopharyngeal'), ('lin"| __truncated__ "[OrderedDict([('type', 'biomes'), ('id', 'root:Host-associated:Human:Digestive system:Large intestine:Fecal'), "| __truncated__ "[OrderedDict([('type', 'biomes'), ('id', 'root:Engineered:Lab enrichment:Defined media'), ('links', {'self': 'h"| __truncated__ "[OrderedDict([('type', 'biomes'), ('id', 'root:Engineered:Lab enrichment:Defined media'), ('links', {'self': 'h"| __truncated__ ...
##  $ geocoordinates     : logi  NA NA NA NA NA NA ...
##  $ accession          : chr  "MGYS00004729" "MGYS00004728" "MGYS00004726" "MGYS00004725" ...
##  $ publications       : logi  NA NA NA NA NA NA ...
##  $ analyses           : logi  NA NA NA NA NA NA ...
##  $ samples_count      : int  720 369 1 1 1 1 1 1 1 1 ...
##  $ bioproject         : chr  "PRJEB18650" "" "PRJEB32056" "PRJEB32055" ...
##  $ downloads          : logi  NA NA NA NA NA NA ...
##  $ secondary_accession: chr  "ERP020597" "SRP057027" "ERP114682" "ERP114681" ...
##  $ centre_name        : chr  "SC" "UPENNBL" "Veer Narmad South Gujarat University" "Veer Narmad South Gujarat University" ...
##  $ is_public          : chr  "True" "True" "True" "True" ...
##  $ public_release_date: chr  "" "" "" "" ...
##  $ study_abstract     : chr  "A longitudinal study was undertaken for 21 infants living in the Maela refugee camp on the Thailand-Burma borde"| __truncated__ "Dysbiosis in the human intestines, an alteration in the normal composition of the microbiota, characterizes a w"| __truncated__ "The Winogradsky column is a simple device for culturing a large diversity of microorganisms." "The Winogradsky column is a simple device for culturing a large diversity of microorganisms." ...
##  $ study_name         : chr  "Nasopharyngeal_microbiota_in_Maela_Thailand" "Inflammation, Antibiotics, and Diet as Concurrent Environmental Stressors of the Gut Microbiome in Pediatric Crohn's Disease" "WINOGRADSKY PLASTIC LOWER LEVEL" "WINOGRADSKY PLASTIC UPPER LEVEL" ...
##  $ data_origination   : chr  "SUBMITTED" "HARVESTED" "SUBMITTED" "SUBMITTED" ...
##  $ last_update        : chr  "2019-06-05T15:05:40" "2019-05-14T09:59:32" "2019-05-13T16:45:16" "2019-05-13T16:44:21" ...
```

```r
dim(pl)
```

```
## [1] 2849   18
```

At the time of writing there are nearly three thousand studies, and important fields include `accession` (which corresponds to the `accession` required for the function `getProjectSummary()` in this package), `study_name` and `samples_count`. These can be used to find the ID of a study of interest. For example, a list of *all* study IDs can be obtained with


```r
pl$accession
```

or


```r
rownames(pl)
```

A list of studies containing at least 200 samples can be obtained with:


```r
pl$accession[pl$samples_count >= 200]
```

```
##   [1] "MGYS00004729" "MGYS00004728" "MGYS00004712" "MGYS00004694"
##   [5] "MGYS00003973" "MGYS00003962" "MGYS00003961" "MGYS00003937"
##   [9] "MGYS00003925" "MGYS00003924" "MGYS00003922" "MGYS00003895"
##  [13] "MGYS00003871" "MGYS00003868" "MGYS00003858" "MGYS00003853"
##  [17] "MGYS00003811" "MGYS00003809" "MGYS00003748" "MGYS00003733"
##  [21] "MGYS00003715" "MGYS00003708" "MGYS00003707" "MGYS00003706"
##  [25] "MGYS00003705" "MGYS00003687" "MGYS00003677" "MGYS00003673"
##  [29] "MGYS00003670" "MGYS00003666" "MGYS00003659" "MGYS00003619"
##  [33] "MGYS00003509" "MGYS00003505" "MGYS00003504" "MGYS00003488"
##  [37] "MGYS00003481" "MGYS00003476" "MGYS00003469" "MGYS00003468"
##  [41] "MGYS00003194" "MGYS00002722" "MGYS00002713" "MGYS00002706"
##  [45] "MGYS00002684" "MGYS00002672" "MGYS00002671" "MGYS00002670"
##  [49] "MGYS00002586" "MGYS00002554" "MGYS00002550" "MGYS00002534"
##  [53] "MGYS00002481" "MGYS00002439" "MGYS00002437" "MGYS00002425"
##  [57] "MGYS00002404" "MGYS00002401" "MGYS00002392" "MGYS00002363"
##  [61] "MGYS00002360" "MGYS00002357" "MGYS00002355" "MGYS00002342"
##  [65] "MGYS00002338" "MGYS00002301" "MGYS00002243" "MGYS00002234"
##  [69] "MGYS00002222" "MGYS00002211" "MGYS00002187" "MGYS00002184"
##  [73] "MGYS00002173" "MGYS00002154" "MGYS00002072" "MGYS00002065"
##  [77] "MGYS00002019" "MGYS00002017" "MGYS00001988" "MGYS00001980"
##  [81] "MGYS00001928" "MGYS00001884" "MGYS00001864" "MGYS00001835"
##  [85] "MGYS00001818" "MGYS00001809" "MGYS00001805" "MGYS00001799"
##  [89] "MGYS00001767" "MGYS00001748" "MGYS00001745" "MGYS00001705"
##  [93] "MGYS00001704" "MGYS00001701" "MGYS00001679" "MGYS00001675"
##  [97] "MGYS00001669" "MGYS00001645" "MGYS00001607" "MGYS00001528"
## [101] "MGYS00001506" "MGYS00001502" "MGYS00001457" "MGYS00001444"
## [105] "MGYS00001368" "MGYS00001362" "MGYS00001357" "MGYS00001348"
## [109] "MGYS00001347" "MGYS00001341" "MGYS00001339" "MGYS00001329"
## [113] "MGYS00001306" "MGYS00001278" "MGYS00001257" "MGYS00001255"
## [117] "MGYS00001251" "MGYS00001248" "MGYS00001231" "MGYS00001225"
## [121] "MGYS00001222" "MGYS00001220" "MGYS00001194" "MGYS00001189"
## [125] "MGYS00001107" "MGYS00001075" "MGYS00001073" "MGYS00001072"
## [129] "MGYS00001070" "MGYS00001069" "MGYS00001068" "MGYS00001064"
## [133] "MGYS00001056" "MGYS00001031" "MGYS00000992" "MGYS00000991"
## [137] "MGYS00000988" "MGYS00000974" "MGYS00000983" "MGYS00000868"
## [141] "MGYS00000850" "MGYS00000793" "MGYS00000737"
```

A list of studies with name containing particular text can be obtained with commands like:


```r
pl$accession[grep("16S", pl$study_name)]
```

```
##   [1] "MGYS00004662" "MGYS00004661" "MGYS00004633" "MGYS00004584"
##   [5] "MGYS00004529" "MGYS00004510" "MGYS00004502" "MGYS00004478"
##   [9] "MGYS00004462" "MGYS00004455" "MGYS00004428" "MGYS00004416"
##  [13] "MGYS00004377" "MGYS00004332" "MGYS00004331" "MGYS00004320"
##  [17] "MGYS00004237" "MGYS00004206" "MGYS00004205" "MGYS00004181"
##  [21] "MGYS00004158" "MGYS00004150" "MGYS00004139" "MGYS00004108"
##  [25] "MGYS00004044" "MGYS00004024" "MGYS00004015" "MGYS00003998"
##  [29] "MGYS00003997" "MGYS00003993" "MGYS00003986" "MGYS00003985"
##  [33] "MGYS00003957" "MGYS00003908" "MGYS00003851" "MGYS00003754"
##  [37] "MGYS00003724" "MGYS00003722" "MGYS00003716" "MGYS00003170"
##  [41] "MGYS00003168" "MGYS00003081" "MGYS00003067" "MGYS00003066"
##  [45] "MGYS00002953" "MGYS00002936" "MGYS00002781" "MGYS00002776"
##  [49] "MGYS00002725" "MGYS00002669" "MGYS00002665" "MGYS00002605"
##  [53] "MGYS00002541" "MGYS00002527" "MGYS00002523" "MGYS00002501"
##  [57] "MGYS00002490" "MGYS00002452" "MGYS00002451" "MGYS00002444"
##  [61] "MGYS00002441" "MGYS00002404" "MGYS00002400" "MGYS00002396"
##  [65] "MGYS00002371" "MGYS00002356" "MGYS00002282" "MGYS00002253"
##  [69] "MGYS00002243" "MGYS00002242" "MGYS00002240" "MGYS00002235"
##  [73] "MGYS00002234" "MGYS00002209" "MGYS00002193" "MGYS00002146"
##  [77] "MGYS00002074" "MGYS00002064" "MGYS00002018" "MGYS00001996"
##  [81] "MGYS00001972" "MGYS00001960" "MGYS00001901" "MGYS00001893"
##  [85] "MGYS00001878" "MGYS00001855" "MGYS00001854" "MGYS00001850"
##  [89] "MGYS00001826" "MGYS00001780" "MGYS00001757" "MGYS00001755"
##  [93] "MGYS00001750" "MGYS00001731" "MGYS00001729" "MGYS00001724"
##  [97] "MGYS00001719" "MGYS00001717" "MGYS00001682" "MGYS00001675"
## [101] "MGYS00001626" "MGYS00001620" "MGYS00001592" "MGYS00001576"
## [105] "MGYS00001574" "MGYS00001565" "MGYS00001508" "MGYS00001489"
## [109] "MGYS00001416" "MGYS00001412" "MGYS00001386" "MGYS00001348"
## [113] "MGYS00001347" "MGYS00001313" "MGYS00001308" "MGYS00001300"
## [117] "MGYS00001261" "MGYS00001240" "MGYS00001229" "MGYS00001228"
## [121] "MGYS00001202" "MGYS00001191" "MGYS00001125" "MGYS00001075"
## [125] "MGYS00001071" "MGYS00001051" "MGYS00001037" "MGYS00001036"
## [129] "MGYS00001028" "MGYS00000824" "MGYS00000970" "MGYS00000944"
## [133] "MGYS00000937" "MGYS00000918" "MGYS00000889" "MGYS00000836"
## [137] "MGYS00000833" "MGYS00000821" "MGYS00000781" "MGYS00000758"
## [141] "MGYS00000615" "MGYS00000708" "MGYS00000703"
```

```r
pl$accession[grep("sludge", pl$study_name)]
```

```
##  [1] "MGYS00003649" "MGYS00003646" "MGYS00003623" "MGYS00003621"
##  [5] "MGYS00003532" "MGYS00003528" "MGYS00003521" "MGYS00003520"
##  [9] "MGYS00003512" "MGYS00003490" "MGYS00003470" "MGYS00003467"
## [13] "MGYS00003416" "MGYS00003413" "MGYS00003410" "MGYS00003395"
## [17] "MGYS00003380" "MGYS00003379" "MGYS00002319" "MGYS00002316"
## [21] "MGYS00002311" "MGYS00002310" "MGYS00002058" "MGYS00001910"
## [25] "MGYS00001835" "MGYS00001823" "MGYS00001806" "MGYS00001764"
## [29] "MGYS00001670" "MGYS00001668" "MGYS00001561" "MGYS00001391"
## [33] "MGYS00001277" "MGYS00001276" "MGYS00001238" "MGYS00001166"
## [37] "MGYS00001064" "MGYS00000777"
```

```r
pl$accession[grep("Tara ", pl$study_name)]
```

```
## [1] "MGYS00002392" "MGYS00002008" "MGYS00001918" "MGYS00001811"
## [5] "MGYS00001789" "MGYS00001482"
```

```r
pl$accession[agrep("human gut", pl$study_name)]
```

```
##  [1] "MGYS00003733" "MGYS00003653" "MGYS00003619" "MGYS00003592"
##  [5] "MGYS00003581" "MGYS00003577" "MGYS00003575" "MGYS00003536"
##  [9] "MGYS00003505" "MGYS00003481" "MGYS00003478" "MGYS00003477"
## [13] "MGYS00003476" "MGYS00003469" "MGYS00003367" "MGYS00003346"
## [17] "MGYS00003240" "MGYS00003191" "MGYS00002961" "MGYS00002690"
## [21] "MGYS00002687" "MGYS00002677" "MGYS00002436" "MGYS00002419"
## [25] "MGYS00002417" "MGYS00002411" "MGYS00002334" "MGYS00002301"
## [29] "MGYS00002061" "MGYS00002060" "MGYS00002057" "MGYS00002056"
## [33] "MGYS00002052" "MGYS00002050" "MGYS00002045" "MGYS00002027"
## [37] "MGYS00002021" "MGYS00002020" "MGYS00002014" "MGYS00002007"
## [41] "MGYS00001987" "MGYS00001986" "MGYS00001985" "MGYS00001983"
## [45] "MGYS00001981" "MGYS00001748" "MGYS00001647" "MGYS00001248"
## [49] "MGYS00001220" "MGYS00001211" "MGYS00001194" "MGYS00001175"
## [53] "MGYS00001107"
```

More sophisticated searches are also possible:

```r
soil = pl$accession[grep("soil", pl$biomes, ignore.case=TRUE)]
pl$accession[grep("human.*fecal", pl$biomes, ignore.case=TRUE)]
```

```
##   [1] "MGYS00004728" "MGYS00003894" "MGYS00003733" "MGYS00003715"
##   [5] "MGYS00003712" "MGYS00003619" "MGYS00003577" "MGYS00003576"
##   [9] "MGYS00003575" "MGYS00003536" "MGYS00003511" "MGYS00003481"
##  [13] "MGYS00003480" "MGYS00003479" "MGYS00003478" "MGYS00003475"
##  [17] "MGYS00003469" "MGYS00003468" "MGYS00003441" "MGYS00003367"
##  [21] "MGYS00003346" "MGYS00003199" "MGYS00003191" "MGYS00003147"
##  [25] "MGYS00003135" "MGYS00002961" "MGYS00002690" "MGYS00002687"
##  [29] "MGYS00002685" "MGYS00002677" "MGYS00002480" "MGYS00002436"
##  [33] "MGYS00002431" "MGYS00002430" "MGYS00002425" "MGYS00002419"
##  [37] "MGYS00002418" "MGYS00002417" "MGYS00002415" "MGYS00002411"
##  [41] "MGYS00002339" "MGYS00002338" "MGYS00002334" "MGYS00002331"
##  [45] "MGYS00002309" "MGYS00002216" "MGYS00002207" "MGYS00002184"
##  [49] "MGYS00002177" "MGYS00002143" "MGYS00002139" "MGYS00002138"
##  [53] "MGYS00002081" "MGYS00002064" "MGYS00002061" "MGYS00002060"
##  [57] "MGYS00002057" "MGYS00002056" "MGYS00002052" "MGYS00002050"
##  [61] "MGYS00002046" "MGYS00002038" "MGYS00002027" "MGYS00002024"
##  [65] "MGYS00002021" "MGYS00002020" "MGYS00002019" "MGYS00002012"
##  [69] "MGYS00002007" "MGYS00002006" "MGYS00001991" "MGYS00001988"
##  [73] "MGYS00001984" "MGYS00001983" "MGYS00001981" "MGYS00001960"
##  [77] "MGYS00001901" "MGYS00001897" "MGYS00001893" "MGYS00001892"
##  [81] "MGYS00001887" "MGYS00001886" "MGYS00001884" "MGYS00001868"
##  [85] "MGYS00001859" "MGYS00001809" "MGYS00001803" "MGYS00001799"
##  [89] "MGYS00001748" "MGYS00001705" "MGYS00001679" "MGYS00001650"
##  [93] "MGYS00001647" "MGYS00001626" "MGYS00001623" "MGYS00001581"
##  [97] "MGYS00001556" "MGYS00001541" "MGYS00001537" "MGYS00001493"
## [101] "MGYS00001444" "MGYS00001442" "MGYS00001420" "MGYS00001342"
## [105] "MGYS00001313" "MGYS00001308" "MGYS00001280" "MGYS00001279"
## [109] "MGYS00001278" "MGYS00001258" "MGYS00001257" "MGYS00001256"
## [113] "MGYS00001255" "MGYS00001252" "MGYS00001251" "MGYS00001250"
## [117] "MGYS00001249" "MGYS00001220" "MGYS00001215" "MGYS00001213"
## [121] "MGYS00001212" "MGYS00001211" "MGYS00001210" "MGYS00001208"
## [125] "MGYS00001194" "MGYS00001190" "MGYS00001189" "MGYS00001186"
## [129] "MGYS00001184" "MGYS00001175" "MGYS00001099" "MGYS00001071"
## [133] "MGYS00000489"
```

The information relating to one particular study can be extracted with, eg.


```r
pl[soil[1],]
```

```
##                                                                                    url
## MGYS00004688 https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00004688?format=csv
##              samples
## MGYS00004688      NA
##                                                                                                                                                                                                                                                              biomes
## MGYS00004688 [OrderedDict([('type', 'biomes'), ('id', 'root:Environmental:Terrestrial:Soil:Uranium contaminated'), ('links', {'self': 'https://www.ebi.ac.uk/metagenomics/api/v1/biomes/root:Environmental:Terrestrial:Soil:Uranium%20contaminated?format=csv'})])]
##              geocoordinates    accession publications analyses
## MGYS00004688             NA MGYS00004688           NA       NA
##              samples_count  bioproject downloads secondary_accession
## MGYS00004688             1 PRJNA284836        NA           SRP058675
##              centre_name is_public public_release_date
## MGYS00004688  BioProject      True                    
##                                                                                                                                                                                          study_abstract
## MGYS00004688 SJP- Uranium polluted sediment sample collected from Cauvery bank of Kokarayanpettai, Erode District. SJUP- Unpolluted sample collected from agriculture field of Bhavani, Erode District.
##                           study_name data_origination         last_update
## MGYS00004688 SJP and SJUP Metagenome        HARVESTED 2019-04-16T13:10:20
```

### Working with a project summary

Once a study of interest has been identified, a more detailed project summary can be downloaded into a data frame with, eg.


```r
ps = getProjectSummary("SRP047083")
```

This data frame lists all *runs* associated with the project, one row per run. Note that there can be multiple runs per sample. The structure of the frame can be probed with:


```r
str(ps)
```

```
## 'data.frame':	2116 obs. of  22 variables:
##  $ url                 : chr  "https://www.ebi.ac.uk/metagenomics/api/v1/analyses/MGYA00035043?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/analyses/MGYA00035044?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/analyses/MGYA00035045?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/analyses/MGYA00035046?format=csv" ...
##  $ experiment_type     : chr  "amplicon" "amplicon" "amplicon" "amplicon" ...
##  $ assembly            : logi  NA NA NA NA NA NA ...
##  $ study               : chr  "https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00000646?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00000646?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00000646?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00000646?format=csv" ...
##  $ interpro_identifiers: logi  NA NA NA NA NA NA ...
##  $ pipeline_version    : num  2 2 2 2 2 2 2 2 2 2 ...
##  $ taxonomy_ssu        : logi  NA NA NA NA NA NA ...
##  $ go_slim             : logi  NA NA NA NA NA NA ...
##  $ run                 : chr  "https://www.ebi.ac.uk/metagenomics/api/v1/runs/SRR1590371?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/runs/SRR1590376?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/runs/SRR1590377?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/runs/SRR1590374?format=csv" ...
##  $ analysis_status     : chr  "completed" "completed" "completed" "completed" ...
##  $ taxonomy            : logi  NA NA NA NA NA NA ...
##  $ downloads           : logi  NA NA NA NA NA NA ...
##  $ taxonomy_lsu        : logi  NA NA NA NA NA NA ...
##  $ analysis_summary    : chr  "[{'key': 'Submitted nucleotide sequences', 'value': '29024'}, {'key': 'Nucleotide sequences after format-specif"| __truncated__ "[{'key': 'Submitted nucleotide sequences', 'value': '18346'}, {'key': 'Nucleotide sequences after format-specif"| __truncated__ "[{'key': 'Submitted nucleotide sequences', 'value': '15'}, {'key': 'Nucleotide sequences after format-specific "| __truncated__ "[{'key': 'Submitted nucleotide sequences', 'value': '7262'}, {'key': 'Nucleotide sequences after format-specifi"| __truncated__ ...
##  $ go_terms            : logi  NA NA NA NA NA NA ...
##  $ sample              : chr  "https://www.ebi.ac.uk/metagenomics/api/v1/samples/SRS711896?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/samples/SRS711896?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/samples/SRS711896?format=csv" "https://www.ebi.ac.uk/metagenomics/api/v1/samples/SRS711896?format=csv" ...
##  $ accession           : chr  "MGYA00035043" "MGYA00035044" "MGYA00035045" "MGYA00035046" ...
##  $ complete_time       : chr  "2016-03-30T00:00:00" "2016-03-30T00:00:00" "2016-03-30T00:00:00" "2016-03-30T00:00:00" ...
##  $ instrument_platform : chr  "ILLUMINA" "ILLUMINA" "ILLUMINA" "ILLUMINA" ...
##  $ instrument_model    : chr  "Illumina MiSeq" "Illumina MiSeq" "Illumina MiSeq" "Illumina MiSeq" ...
##  $ run_id              : chr  "SRR1590371" "SRR1590376" "SRR1590377" "SRR1590374" ...
##  $ sample_id           : chr  "SRS711896" "SRS711896" "SRS711896" "SRS711896" ...
##  - attr(*, "project.id")= chr "SRP047083"
```

```r
dim(ps)
```

```
## [1] 2116   22
```

Important fields include `sample_id` and `run_id`. A list of all runs associated with the project can be obtained in several different ways, eg.


```r
ps$run_id
rownames(ps)
projectRuns(ps)
```

If a particular run ID is known and of interest, the information associated with that particular run can be extracted with, eg.


```r
ps["SRR1589726",]
```

```
##                                                                                   url
## SRR1589726 https://www.ebi.ac.uk/metagenomics/api/v1/analyses/MGYA00036503?format=csv
##            experiment_type assembly
## SRR1589726        amplicon       NA
##                                                                                study
## SRR1589726 https://www.ebi.ac.uk/metagenomics/api/v1/studies/MGYS00000646?format=csv
##            interpro_identifiers pipeline_version taxonomy_ssu go_slim
## SRR1589726                   NA                2           NA      NA
##                                                                             run
## SRR1589726 https://www.ebi.ac.uk/metagenomics/api/v1/runs/SRR1589726?format=csv
##            analysis_status taxonomy downloads taxonomy_lsu
## SRR1589726       completed       NA        NA           NA
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      analysis_summary
## SRR1589726 [{'key': 'Submitted nucleotide sequences', 'value': '78247'}, {'key': 'Nucleotide sequences after format-specific filtering', 'value': '78247'}, {'key': 'Nucleotide sequences after length filtering', 'value': '76839'}, {'key': 'Nucleotide sequences after undetermined bases filtering', 'value': '76839'}, {'key': 'Nucleotide sequences with predicted CDS', 'value': '1256'}, {'key': 'Nucleotide sequences with InterProScan match', 'value': '989'}, {'key': 'Predicted CDS', 'value': '1261'}, {'key': 'Predicted CDS with InterProScan match', 'value': '990'}, {'key': 'Total InterProScan matches', 'value': '1502'}, {'key': 'Nucleotide sequences with predicted rRNA', 'value': '75518'}]
##            go_terms
## SRR1589726       NA
##                                                                            sample
## SRR1589726 https://www.ebi.ac.uk/metagenomics/api/v1/samples/SRS711891?format=csv
##               accession       complete_time instrument_platform
## SRR1589726 MGYA00036503 2016-03-30T00:00:00            ILLUMINA
##            instrument_model     run_id sample_id
## SRR1589726   Illumina MiSeq SRR1589726 SRS711891
```

A table of the number of runs associated with each sample in the project can be obtained with:


```r
table(ps$sample_id)
```

```
## 
## SRS711891 SRS711892 SRS711893 SRS711894 SRS711895 SRS711896 SRS711897 
##        44       118       113       137       137       109        85 
## SRS711898 SRS711899 SRS711900 SRS711901 SRS711902 SRS711903 SRS711904 
##        89        45       113        42       113       114       115 
## SRS711905 SRS711906 SRS711907 SRS711908 SRS711909 SRS711910 SRS711911 
##        46       110        89        91       113        91       112 
## SRS711912 
##        90
```

Similarly, a list of sample IDs associated with the project can be obtained with:


```r
projectSamples(ps)
```

```
##  [1] "SRS711891" "SRS711892" "SRS711893" "SRS711894" "SRS711895"
##  [6] "SRS711896" "SRS711897" "SRS711898" "SRS711899" "SRS711900"
## [11] "SRS711901" "SRS711902" "SRS711903" "SRS711904" "SRS711905"
## [16] "SRS711906" "SRS711907" "SRS711908" "SRS711909" "SRS711910"
## [21] "SRS711911" "SRS711912"
```

**Note** the *convention used in this package* that functions beginning with `get` involve a query over the *internet* to the EBI servers, and functions which do not begin with `get` do not.

Given a particular sample ID, a list of runs associated with that sample ID can be obtained with, eg.:


```r
runsBySample(ps,"SRS711891")
```

```
##  [1] "SRR1589768" "SRR1589738" "SRR1589739" "SRR1589734" "SRR1589735"
##  [6] "SRR1589736" "SRR1589737" "SRR1589731" "SRR1589732" "SRR1589733"
## [11] "SRR1589727" "SRR1589726" "SRR1589729" "SRR1589728" "SRR1589756"
## [16] "SRR1589757" "SRR1589754" "SRR1589755" "SRR1589752" "SRR1589753"
## [21] "SRR1589750" "SRR1589751" "SRR1589758" "SRR1589759" "SRR1589730"
## [26] "SRR1589745" "SRR1589744" "SRR1589747" "SRR1589746" "SRR1589741"
## [31] "SRR1589740" "SRR1589743" "SRR1589742" "SRR1589749" "SRR1589748"
## [36] "SRR1589769" "SRR1589763" "SRR1589762" "SRR1589767" "SRR1589766"
## [41] "SRR1589765" "SRR1589764" "SRR1589761" "SRR1589760"
```

### Working with taxa abundance data

Currently this package only has functions for querying [OTU](https://en.wikipedia.org/wiki/Operational_taxonomic_unit) data. OTU data associated with a particular run can be downloaded into a data frame with, eg.


```r
run = getRunOtu("SRR1589726")
```

This data frame contains information on all OTUs encountered in the run, one row per OTU. The structure of the frame can be probed with:


```r
str(run)
```

```
## 'data.frame':	1613 obs. of  3 variables:
##  $ OTU  : chr  "556126" "589277" "364926" "708680" ...
##  $ Count: num  5619 3769 3759 2353 2206 ...
##  $ Tax  : chr  "k__Bacteria; p__Bacteroidetes; c__Bacteroidia; o__Bacteroidales; f__Bacteroidaceae; g__Bacteroides; s__" "k__Bacteria; p__Bacteroidetes; c__Bacteroidia; o__Bacteroidales; f__Bacteroidaceae; g__Bacteroides; s__" "k__Bacteria; p__Bacteroidetes; c__Bacteroidia; o__Bacteroidales; f__Bacteroidaceae; g__Bacteroides; s__" "k__Bacteria; p__Firmicutes; c__Clostridia; o__Clostridiales; f__Lachnospiraceae; g__; s__" ...
```

```r
dim(run)
```

```
## [1] 1613    3
```

The data frame contains three variables: `OTU`, corresponding to the OTU ID, `Count`, representing the number of times the OTU was encountered in the run, and `Tax`, a string containing a taxonomic classification associated with the OTU. 

Note that the function `getRunOtu` contains two optional Boolean arguments, `verb` and `plot.preston`, both of which default to `FALSE`. The former simply echos the run ID to the console, and the latter displays a [Preston plot](https://en.wikipedia.org/wiki/Relative_species_abundance) for the OTU data. This can be useful to get a quick visual understanding of the nature of the run. After downloading, a plot can be constructed manually with:


```r
plot(octav(run$Count),main="Preston plot")
```

![plot of chunk em-21](figure/em-21-1.png)

The function `mergeOtu` can be used to merge together two OTU data frames to produce a new OTU data frame.


```r
run2 = getRunOtu("SRR1589727")
runMerged = mergeOtu(run,run2)
plot(octav(runMerged$Count),main="Preston plot for merged runs")
```

![plot of chunk em-22](figure/em-22-1.png)

More than two OTU data frames can be merged in this way. See the `?mergeOtu` example for how to merge a list of OTU data frames. It is often desirable to download all of the runs associated with a particular sample and to merge the run OTU data frames together to give an overall OTU data frame for the sample. The function `getSampleOtu` automates this process.

It can be run in its simplest form as `run=getSampleOtu(ps,"SRS711891")` but it too has optional Boolean arguments `verb` and `plot.preston`. Here `verb` defaults to `TRUE`, since it is usually useful to have a progress update, and the `plot.preston` argument is often worth using to "see" the data as it is being downloaded.


```r
run=getSampleOtu(ps,"SRS711891",plot.preston=TRUE)
```


```
## SRR1589768, SRR1589738, SRR1589739, SRR1589734, SRR1589735, SRR1589736, SRR1589737, SRR1589731, SRR1589732, SRR1589733, SRR1589727, SRR1589726, SRR1589729, SRR1589728, SRR1589756, SRR1589757, SRR1589754, SRR1589755, SRR1589752, SRR1589753, SRR1589750, SRR1589751, SRR1589758, SRR1589759, SRR1589730, SRR1589745, SRR1589744, SRR1589747, SRR1589746, SRR1589741, SRR1589740, SRR1589743, SRR1589742, SRR1589749, SRR1589748, SRR1589769, SRR1589763, SRR1589762, SRR1589767, SRR1589766, SRR1589765, SRR1589764, SRR1589761, SRR1589760, END.
```


```r
plot(octav(run$Count),main="Preston plot for sample SRS711891")
```

![plot of chunk em-23c](figure/em-23c-1.png)

```r
dim(run)
```

```
## [1] 7168    3
```

The taxa abundance count data now downloaded into the R session can be utilised in the same way as any other species abundance data in R.

Note that the package includes the function `convertOtuTad()` which re-tabulates OTU counts as a taxa abundance distribution (TAD), and `plotOtu()`, which does a selection of 4 plots for a given set of OTU counts.


```r
head(convertOtuTad(run))
```

```
##   abund Freq
## 1     1 2194
## 2     2  918
## 3     3  536
## 4     4  359
## 5     5  249
## 6     6  236
```

```r
plotOtu(run)
```

![plot of chunk em-24](figure/em-24-1.png)

Commonly required stats associated with OTU counts can be computed with the function `analyseOtu()`.


```r
analyseOtu(run)
```

![plot of chunk em-25](figure/em-25-1.png)

```
##         S.obs         N.obs Shannon.index  Fisher.alpha       S.chao1 
##  7.168000e+03  1.921997e+06  4.379728e+00  9.402906e+02  9.785760e+03 
##      se.chao1         S.ACE        se.ACE       S.break      se.break 
##  1.502180e+02  9.664716e+03  5.132660e+01  7.171886e+03  4.870321e+00 
##         S.vln         S.pln          N.75          N.90          N.95 
##  1.643350e+04  2.173068e+04  1.257778e+08  1.197866e+09  4.590360e+09 
##          N.99 
##  5.654416e+10
```

As well as computing various different estimates of the total number of taxa in the community that was sampled, it also computes estimates (assuming a Poisson-log-normal TAD) of the number of sequences required in order to observe a given fraction of the total species present. This can be useful for estimating required sequencing effort. 
Several of the fields should be familiar from the `vegan` function `estimateR`. The `breakaway` estimate has also been included. `S.vln` is Preston's veiled log-normal method and `S.pln` is an estimate from a Poisson-log-Normal SAD fit. Under the same assumption of an underlying Poisson-log-Normal species abundance distribution (and using the same fit), `N.75`, `N.90`, `N.95` and `N.99` are estimates of the `N.obs` required in order to obtain 75%, 90%, 95% and 99% species coverage in a future sample.

### Fitting TADs

If we are interested in assessing whether a Poisson-log-Normal assumption is reasonable, we could try fitting some different TADs for comparison.

```r
models = lapply(c("lnorm","poilog","ls","mzsm"), function(m){fitsad(run$Count,m)})
```

```
## Warning in optimize(function(par) fn(par, ...)/con$fnscale, lower =
## lower, : NA/Inf replaced by maximum positive value

## Warning in optimize(function(par) fn(par, ...)/con$fnscale, lower =
## lower, : NA/Inf replaced by maximum positive value
```

```r
models
```

```
## [[1]]
## Maximum likelihood estimation
## Type: continuous  species abundance distribution
## Species: 7168 individuals: 1921997 
## 
## Call:
## mle2(minuslogl = function (meanlog, sdlog) 
## -sum(dlnorm(x, meanlog, sdlog, log = TRUE)), start = list(meanlog = 1.73294524769214, 
##     sdlog = 1.87728425455293), data = list(x = list(361637, 145554, 
##     127613, 89195, 72535, "etc")))
## 
## Coefficients:
##  meanlog    sdlog 
## 1.732945 1.877114 
## 
## Log-likelihood: -27106.8 
## 
## [[2]]
## Maximum likelihood estimation
## Type: discrete  species abundance distribution
## Species: 7168 individuals: 1921997 
## 
## Call:
## mle2(minuslogl = function (mu, sig) 
## -sum(dtrunc("poilog", x = x, coef = list(mu = mu, sig = sig), 
##     trunc = trunc, log = TRUE)), start = list(mu = -2.21224742827161, 
##     sig = 3.53818966221839), data = list(x = list(361637, 145554, 
##     127613, 89195, 72535, "etc")))
## 
## Coefficients:
##        mu       sig 
## -2.212247  3.538190 
## 
## Truncation point: 0 
## 
## Log-likelihood: -25385.76 
## 
## [[3]]
## Maximum likelihood estimation
## Type: discrete  species abundance distribution
## Species: 7168 individuals: 1921997 
## 
## Call:
## mle2(minuslogl = function (N, alpha) 
## -sum(dls(x, N, alpha, log = TRUE)), start = list(alpha = 940.290568940603), 
##     method = "Brent", fixed = list(N = 1921997), data = list(
##         x = list(361637, 145554, 127613, 89195, 72535, "etc")), 
##     lower = 0, upper = 7168L)
## 
## Coefficients:
##            N        alpha 
## 1921997.0000     940.2905 
## 
## Log-likelihood: -27921.4 
## 
## [[4]]
## Maximum likelihood estimation
## Type: discrete  species abundance distribution
## Species: 7168 individuals: 1921997 
## 
## Call:
## mle2(minuslogl = function (J, theta) 
## -sum(dmzsm(x, J = J, theta = theta, log = TRUE)), start = list(
##     theta = 7168L), method = "Brent", fixed = list(J = 1921997), 
##     data = list(x = list(361637, 145554, 127613, 89195, 72535, 
##         "etc")), lower = 0.001, upper = 7168L)
## 
## Coefficients:
##            J        theta 
## 1921997.0000     909.4143 
## 
## Log-likelihood: -27948.36
```

```r
lapply(models, function(x){x@min})
```

```
## [[1]]
## [1] 27106.8
## 
## [[2]]
## [1] 25385.76
## 
## [[3]]
## [1] 27921.4
## 
## [[4]]
## [1] 27948.36
```
Note that `poilog` has (by far) the largest fitted log-likelihood (or equivalently, smallest negative log-likelihood), suggesting a better fit to the data. This isn't a formal test of model adequacy, but suggests that this model is at least better than other commonly used alternatives. This is confirmed by looking at diagnostic plots. For example,

```r
op=par(mfrow=c(2,2))
plot(models[[1]])
```

![plot of chunk em-27](figure/em-27-1.png)

```r
par(op)
```
shows a poor fit for "lnorm". Repeating for `[[3]]` and `[[4]]` shows even worse fits for "ls" and "mzsm". Repeating for `[[2]]` shows a very good fit, if the plot function doesn't crash, which it sometimes does. This illustrates an important issue: although population ecologists have been thinking about species abundance for decades, they haven't always been thinking about the sample sizes and diversity associated with some metagenomic samples, and so some of the available tools sometimes struggle to scale up to metagenomic data sets.



#### (C) 2016-19 Darren J Wilkinson


