# Sample Comparisons

In this session we have mainly been concerned with the taxa abundance distributions within individual runs and samples. In many cases we will also be interested in comparing samples to find interesting differences between them. 


```r
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
```


```r
kptab = getKP("MGYS00004696")
kptab
```

```
##                                   SRR4428181 SRR4428182 SRR4428183
## Archaea;Candidatus_Bathyarchaeota          3          0          0
## Archaea;Crenarchaeota                      1          0          0
## Archaea;Unassigned                         6          0          2
## Bacteria;Bacteroidetes                     1          5        104
## Bacteria;Chlamydiae                        0          0          0
## Bacteria;Planctomycetes                    0          0          0
## Bacteria;Unassigned                        9          7         18
## Bacteria;Verrucomicrobia                   0          0          0
## Chloroplast;Unassigned                     1          1          0
## Eukaryota;Annelida                        61          4         14
## Eukaryota;Apicomplexa                      9          3          2
## Eukaryota;Arthropoda                     297        108         30
## Eukaryota;Ascomycota                      80        151       1209
## Eukaryota;Bacillariophyta               3084      11998        157
## Eukaryota;Basidiomycota                  234        109        215
## Eukaryota;Blastocladiomycota               1          0          1
## Eukaryota;Brachiopoda                     66          1          1
## Eukaryota;Bryozoa                          4          1          0
## Eukaryota;Chlorophyta                    138        695      18617
## Eukaryota;Chordata                         2         13          1
## Eukaryota;Chromerida                       0          0          0
## Eukaryota;Chytridiomycota                213        218        396
## Eukaryota;Cnidaria                       182         14         85
## Eukaryota;Colponemidia                     0          0          0
## Eukaryota;Cryptomycota                     6          0          3
## Eukaryota;Ctenophora                       0          1          0
## Eukaryota;Echinodermata                    0          0          0
## Eukaryota;Entoprocta                       0          0          0
## Eukaryota;Eustigmatophyceae                0          2          0
## Eukaryota;Gastrotricha                   313         18          0
## Eukaryota;Haplosporidia                    0          0          0
## Eukaryota;Hemichordata                    11          2          0
## Eukaryota;Kinorhyncha                      0         50          0
## Eukaryota;Microsporidia                    0          0          0
## Eukaryota;Mollusca                       165        477          0
## Eukaryota;Mucoromycota                    44         11         27
## Eukaryota;Nematoda                       357         21          0
## Eukaryota;Nemertea                         0          0          0
## Eukaryota;Phaeophyceae                     1         17          1
## Eukaryota;Picozoa                          3          0          0
## Eukaryota;Pinguiophyceae                  21          0          0
## Eukaryota;Platyhelminthes               1144         18         13
## Eukaryota;Porifera                         0         32          0
## Eukaryota;Priapulida                       2          0          0
## Eukaryota;Rotifera                        26         19         27
## Eukaryota;Streptophyta                    29         28         48
## Eukaryota;Tardigrada                       1          0          0
## Eukaryota;Unassigned                   12326      17690       4806
## Eukaryota;Xanthophyceae                    0          1          0
## Eukaryota;Xenacoelomorpha                 90          0          0
## Eukaryota;Zoopagomycota                    1          0          0
## Mitochondria;Unassigned                    0          0          0
## Unassigned;Unassigned                      1          0          0
##                                   SRR4428184 SRR4428185 SRR4428186
## Archaea;Candidatus_Bathyarchaeota          0          0          0
## Archaea;Crenarchaeota                      0          0          0
## Archaea;Unassigned                         0          1          1
## Bacteria;Bacteroidetes                    11         25          1
## Bacteria;Chlamydiae                        0          0          0
## Bacteria;Planctomycetes                    0          0          0
## Bacteria;Unassigned                        0          0          0
## Bacteria;Verrucomicrobia                   1          0          0
## Chloroplast;Unassigned                     0          1          1
## Eukaryota;Annelida                         2         25        479
## Eukaryota;Apicomplexa                     40         10         14
## Eukaryota;Arthropoda                      18        291       1359
## Eukaryota;Ascomycota                     164       8206         93
## Eukaryota;Bacillariophyta                196        447       4486
## Eukaryota;Basidiomycota                   92        294        198
## Eukaryota;Blastocladiomycota               1          0          0
## Eukaryota;Brachiopoda                      0         41          4
## Eukaryota;Bryozoa                          0         14         12
## Eukaryota;Chlorophyta                    280      11437        338
## Eukaryota;Chordata                         4          3         12
## Eukaryota;Chromerida                       0          0          1
## Eukaryota;Chytridiomycota                 25        139        215
## Eukaryota;Cnidaria                        15         22        308
## Eukaryota;Colponemidia                     0          0          0
## Eukaryota;Cryptomycota                     2          1          8
## Eukaryota;Ctenophora                       0          0          0
## Eukaryota;Echinodermata                    0          0          0
## Eukaryota;Entoprocta                       0          0          0
## Eukaryota;Eustigmatophyceae                0          5          0
## Eukaryota;Gastrotricha                     1          1          0
## Eukaryota;Haplosporidia                    0          0          0
## Eukaryota;Hemichordata                     0          0          0
## Eukaryota;Kinorhyncha                      1          6          0
## Eukaryota;Microsporidia                    0          0          0
## Eukaryota;Mollusca                       267         31       1507
## Eukaryota;Mucoromycota                     0         17         37
## Eukaryota;Nematoda                         1         10         95
## Eukaryota;Nemertea                         0          0          0
## Eukaryota;Phaeophyceae                    43       1698          1
## Eukaryota;Picozoa                          0          0          2
## Eukaryota;Pinguiophyceae                   0          0          4
## Eukaryota;Platyhelminthes               5715        119        104
## Eukaryota;Porifera                         1          2         12
## Eukaryota;Priapulida                       0          9         13
## Eukaryota;Rotifera                        23        414        196
## Eukaryota;Streptophyta                    17         93          8
## Eukaryota;Tardigrada                       0          0          0
## Eukaryota;Unassigned                   19758       6901      17650
## Eukaryota;Xanthophyceae                    1          2          0
## Eukaryota;Xenacoelomorpha                  3          0          5
## Eukaryota;Zoopagomycota                    0          0          0
## Mitochondria;Unassigned                    0          1          0
## Unassigned;Unassigned                      0          0          1
##                                   SRR4428187 SRR4428188 SRR4428189
## Archaea;Candidatus_Bathyarchaeota          0          0          0
## Archaea;Crenarchaeota                      0          1          0
## Archaea;Unassigned                         6          9          0
## Bacteria;Bacteroidetes                     3          9          1
## Bacteria;Chlamydiae                        0          0          0
## Bacteria;Planctomycetes                    0          0          0
## Bacteria;Unassigned                        7         10          1
## Bacteria;Verrucomicrobia                   0          0          0
## Chloroplast;Unassigned                     0          1          0
## Eukaryota;Annelida                         1          3         40
## Eukaryota;Apicomplexa                     14         13          5
## Eukaryota;Arthropoda                      97        555         82
## Eukaryota;Ascomycota                     335        240       1192
## Eukaryota;Bacillariophyta               1034       2447        134
## Eukaryota;Basidiomycota                  285        247         95
## Eukaryota;Blastocladiomycota               1          1          0
## Eukaryota;Brachiopoda                      0          0          0
## Eukaryota;Bryozoa                          0          0          3
## Eukaryota;Chlorophyta                   1374       2038       5798
## Eukaryota;Chordata                         1          1          2
## Eukaryota;Chromerida                       2          2          0
## Eukaryota;Chytridiomycota                486        463        123
## Eukaryota;Cnidaria                        30         14         57
## Eukaryota;Colponemidia                     1          0          0
## Eukaryota;Cryptomycota                     1          4          0
## Eukaryota;Ctenophora                       0          1          4
## Eukaryota;Echinodermata                    0          0          1
## Eukaryota;Entoprocta                       6          0          0
## Eukaryota;Eustigmatophyceae               17         13          2
## Eukaryota;Gastrotricha                    19          0          1
## Eukaryota;Haplosporidia                    1          0          0
## Eukaryota;Hemichordata                     0          0          1
## Eukaryota;Kinorhyncha                      0          0          0
## Eukaryota;Microsporidia                    0          0          0
## Eukaryota;Mollusca                         7         91         78
## Eukaryota;Mucoromycota                    23         19         19
## Eukaryota;Nematoda                         5          1          1
## Eukaryota;Nemertea                         0          0          1
## Eukaryota;Phaeophyceae                    11          4          4
## Eukaryota;Picozoa                          0          0          0
## Eukaryota;Pinguiophyceae                   0          0          0
## Eukaryota;Platyhelminthes                 35         14        276
## Eukaryota;Porifera                         2          2          0
## Eukaryota;Priapulida                       0          0          4
## Eukaryota;Rotifera                        51         34         18
## Eukaryota;Streptophyta                  5365        735         72
## Eukaryota;Tardigrada                       0          0          0
## Eukaryota;Unassigned                   11166      19865      14667
## Eukaryota;Xanthophyceae                    0          1          0
## Eukaryota;Xenacoelomorpha                  0          0          0
## Eukaryota;Zoopagomycota                    1          2          0
## Mitochondria;Unassigned                    0          0          0
## Unassigned;Unassigned                      0          1          0
##                                   SRR4428190 SRR4428191 SRR4428192
## Archaea;Candidatus_Bathyarchaeota          0          0          0
## Archaea;Crenarchaeota                      0          0          0
## Archaea;Unassigned                         0          0        113
## Bacteria;Bacteroidetes                    34          0        103
## Bacteria;Chlamydiae                        0          0          0
## Bacteria;Planctomycetes                    0          0          1
## Bacteria;Unassigned                        4          2        221
## Bacteria;Verrucomicrobia                   0          0          0
## Chloroplast;Unassigned                     0          0          7
## Eukaryota;Annelida                         4        101         28
## Eukaryota;Apicomplexa                      2          8         35
## Eukaryota;Arthropoda                      10        817        306
## Eukaryota;Ascomycota                    4682         25       2396
## Eukaryota;Bacillariophyta                 24       8346       3327
## Eukaryota;Basidiomycota                   90        104        827
## Eukaryota;Blastocladiomycota               1          0          3
## Eukaryota;Brachiopoda                      0          4         24
## Eukaryota;Bryozoa                          0          3          3
## Eukaryota;Chlorophyta                  15430        130       7519
## Eukaryota;Chordata                         2          6          3
## Eukaryota;Chromerida                       0          0          0
## Eukaryota;Chytridiomycota                525       1429       1203
## Eukaryota;Cnidaria                        70        157        156
## Eukaryota;Colponemidia                     0          0          0
## Eukaryota;Cryptomycota                     1          6         27
## Eukaryota;Ctenophora                       1          0          0
## Eukaryota;Echinodermata                    0          0          0
## Eukaryota;Entoprocta                       0          0          0
## Eukaryota;Eustigmatophyceae                0          3         10
## Eukaryota;Gastrotricha                     2        475        249
## Eukaryota;Haplosporidia                    0          0          0
## Eukaryota;Hemichordata                     0          0          0
## Eukaryota;Kinorhyncha                      0          0          1
## Eukaryota;Microsporidia                    0          1          0
## Eukaryota;Mollusca                         4        200        120
## Eukaryota;Mucoromycota                     2         23        103
## Eukaryota;Nematoda                         0         49         19
## Eukaryota;Nemertea                         0          0          0
## Eukaryota;Phaeophyceae                     4        152         26
## Eukaryota;Picozoa                          0          0          0
## Eukaryota;Pinguiophyceae                   0         11          2
## Eukaryota;Platyhelminthes                 43         27         10
## Eukaryota;Porifera                         0          0          3
## Eukaryota;Priapulida                       0          7          0
## Eukaryota;Rotifera                       243         34        747
## Eukaryota;Streptophyta                    94         15       7513
## Eukaryota;Tardigrada                       0          0          0
## Eukaryota;Unassigned                    5070      14936      20215
## Eukaryota;Xanthophyceae                    0          2          1
## Eukaryota;Xenacoelomorpha                  0          0          0
## Eukaryota;Zoopagomycota                    1          0          0
## Mitochondria;Unassigned                    0          0          0
## Unassigned;Unassigned                      0          1          7
##                                   SRR4428193 SRR4428194 SRR4428195
## Archaea;Candidatus_Bathyarchaeota          0          0          0
## Archaea;Crenarchaeota                      0          0          0
## Archaea;Unassigned                         0          2          5
## Bacteria;Bacteroidetes                     0          3        737
## Bacteria;Chlamydiae                        0          0          2
## Bacteria;Planctomycetes                    0          0          0
## Bacteria;Unassigned                        3          5        180
## Bacteria;Verrucomicrobia                   0          0          0
## Chloroplast;Unassigned                     0          0          7
## Eukaryota;Annelida                        15          0         33
## Eukaryota;Apicomplexa                     23         25         91
## Eukaryota;Arthropoda                      68         27         95
## Eukaryota;Ascomycota                     206        340       6206
## Eukaryota;Bacillariophyta               2727       3956        299
## Eukaryota;Basidiomycota                  213        216       1648
## Eukaryota;Blastocladiomycota               0          6          0
## Eukaryota;Brachiopoda                      1          1         53
## Eukaryota;Bryozoa                          0          0          0
## Eukaryota;Chlorophyta                   2012       1725       4031
## Eukaryota;Chordata                       140          0          1
## Eukaryota;Chromerida                       0          1          0
## Eukaryota;Chytridiomycota                399        320        950
## Eukaryota;Cnidaria                         9          7         12
## Eukaryota;Colponemidia                     0          0          0
## Eukaryota;Cryptomycota                     2          5         20
## Eukaryota;Ctenophora                       0          0          0
## Eukaryota;Echinodermata                    0          0          0
## Eukaryota;Entoprocta                       1          0          0
## Eukaryota;Eustigmatophyceae                5         27          4
## Eukaryota;Gastrotricha                     3          8         33
## Eukaryota;Haplosporidia                    0          0          0
## Eukaryota;Hemichordata                     0          0          0
## Eukaryota;Kinorhyncha                      1          8          0
## Eukaryota;Microsporidia                    0          2          0
## Eukaryota;Mollusca                        46          5         21
## Eukaryota;Mucoromycota                    23         10         95
## Eukaryota;Nematoda                         5          4          5
## Eukaryota;Nemertea                         0          0          3
## Eukaryota;Phaeophyceae                     2          1         21
## Eukaryota;Picozoa                          1          0          0
## Eukaryota;Pinguiophyceae                   0          0          2
## Eukaryota;Platyhelminthes                880         21         30
## Eukaryota;Porifera                         2          0          0
## Eukaryota;Priapulida                       0          0          1
## Eukaryota;Rotifera                        31         91          3
## Eukaryota;Streptophyta                   249        402        716
## Eukaryota;Tardigrada                       0          0          0
## Eukaryota;Unassigned                    9246      11101      18439
## Eukaryota;Xanthophyceae                    0          1        119
## Eukaryota;Xenacoelomorpha                  1          0          0
## Eukaryota;Zoopagomycota                    1          0          5
## Mitochondria;Unassigned                    0          1          1
## Unassigned;Unassigned                      1          1          1
##                                   SRR4428196
## Archaea;Candidatus_Bathyarchaeota          0
## Archaea;Crenarchaeota                      0
## Archaea;Unassigned                         5
## Bacteria;Bacteroidetes                    19
## Bacteria;Chlamydiae                        0
## Bacteria;Planctomycetes                    0
## Bacteria;Unassigned                       21
## Bacteria;Verrucomicrobia                   0
## Chloroplast;Unassigned                     2
## Eukaryota;Annelida                       345
## Eukaryota;Apicomplexa                     12
## Eukaryota;Arthropoda                     294
## Eukaryota;Ascomycota                    3368
## Eukaryota;Bacillariophyta               5203
## Eukaryota;Basidiomycota                  313
## Eukaryota;Blastocladiomycota               0
## Eukaryota;Brachiopoda                      1
## Eukaryota;Bryozoa                          9
## Eukaryota;Chlorophyta                   7520
## Eukaryota;Chordata                         4
## Eukaryota;Chromerida                       0
## Eukaryota;Chytridiomycota                223
## Eukaryota;Cnidaria                       134
## Eukaryota;Colponemidia                     0
## Eukaryota;Cryptomycota                     4
## Eukaryota;Ctenophora                       0
## Eukaryota;Echinodermata                   10
## Eukaryota;Entoprocta                       0
## Eukaryota;Eustigmatophyceae               13
## Eukaryota;Gastrotricha                   265
## Eukaryota;Haplosporidia                    0
## Eukaryota;Hemichordata                     1
## Eukaryota;Kinorhyncha                      3
## Eukaryota;Microsporidia                    0
## Eukaryota;Mollusca                      2746
## Eukaryota;Mucoromycota                    16
## Eukaryota;Nematoda                        45
## Eukaryota;Nemertea                         0
## Eukaryota;Phaeophyceae                    51
## Eukaryota;Picozoa                          0
## Eukaryota;Pinguiophyceae                   1
## Eukaryota;Platyhelminthes                178
## Eukaryota;Porifera                         5
## Eukaryota;Priapulida                       3
## Eukaryota;Rotifera                       355
## Eukaryota;Streptophyta                   379
## Eukaryota;Tardigrada                       0
## Eukaryota;Unassigned                   11681
## Eukaryota;Xanthophyceae                   20
## Eukaryota;Xenacoelomorpha                  1
## Eukaryota;Zoopagomycota                    0
## Mitochondria;Unassigned                    0
## Unassigned;Unassigned                     14
```


```r
colsums = apply(kptab,2,sum)
normtab = sweep(kptab,2,colsums,"/")
normtab
```

```
##                                     SRR4428181   SRR4428182   SRR4428183
## Archaea;Candidatus_Bathyarchaeota 1.584535e-04 0.000000e+00 0.000000e+00
## Archaea;Crenarchaeota             5.281783e-05 0.000000e+00 0.000000e+00
## Archaea;Unassigned                3.169070e-04 0.000000e+00 7.758855e-05
## Bacteria;Bacteroidetes            5.281783e-05 1.576541e-04 4.034604e-03
## Bacteria;Chlamydiae               0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Planctomycetes           0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Unassigned               4.753605e-04 2.207157e-04 6.982969e-04
## Bacteria;Verrucomicrobia          0.000000e+00 0.000000e+00 0.000000e+00
## Chloroplast;Unassigned            5.281783e-05 3.153082e-05 0.000000e+00
## Eukaryota;Annelida                3.221888e-03 1.261233e-04 5.431198e-04
## Eukaryota;Apicomplexa             4.753605e-04 9.459246e-05 7.758855e-05
## Eukaryota;Arthropoda              1.568690e-02 3.405329e-03 1.163828e-03
## Eukaryota;Ascomycota              4.225427e-03 4.761154e-03 4.690228e-02
## Eukaryota;Bacillariophyta         1.628902e-01 3.783068e-01 6.090701e-03
## Eukaryota;Basidiomycota           1.235937e-02 3.436860e-03 8.340769e-03
## Eukaryota;Blastocladiomycota      5.281783e-05 0.000000e+00 3.879427e-05
## Eukaryota;Brachiopoda             3.485977e-03 3.153082e-05 3.879427e-05
## Eukaryota;Bryozoa                 2.112713e-04 3.153082e-05 0.000000e+00
## Eukaryota;Chlorophyta             7.288861e-03 2.191392e-02 7.222330e-01
## Eukaryota;Chordata                1.056357e-04 4.099007e-04 3.879427e-05
## Eukaryota;Chromerida              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Chytridiomycota         1.125020e-02 6.873719e-03 1.536253e-02
## Eukaryota;Cnidaria                9.612845e-03 4.414315e-04 3.297513e-03
## Eukaryota;Colponemidia            0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Cryptomycota            3.169070e-04 0.000000e+00 1.163828e-04
## Eukaryota;Ctenophora              0.000000e+00 3.153082e-05 0.000000e+00
## Eukaryota;Echinodermata           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Entoprocta              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Eustigmatophyceae       0.000000e+00 6.306164e-05 0.000000e+00
## Eukaryota;Gastrotricha            1.653198e-02 5.675548e-04 0.000000e+00
## Eukaryota;Haplosporidia           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Hemichordata            5.809961e-04 6.306164e-05 0.000000e+00
## Eukaryota;Kinorhyncha             0.000000e+00 1.576541e-03 0.000000e+00
## Eukaryota;Microsporidia           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Mollusca                8.714942e-03 1.504020e-02 0.000000e+00
## Eukaryota;Mucoromycota            2.323985e-03 3.468390e-04 1.047445e-03
## Eukaryota;Nematoda                1.885597e-02 6.621472e-04 0.000000e+00
## Eukaryota;Nemertea                0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Phaeophyceae            5.281783e-05 5.360240e-04 3.879427e-05
## Eukaryota;Picozoa                 1.584535e-04 0.000000e+00 0.000000e+00
## Eukaryota;Pinguiophyceae          1.109174e-03 0.000000e+00 0.000000e+00
## Eukaryota;Platyhelminthes         6.042360e-02 5.675548e-04 5.043256e-04
## Eukaryota;Porifera                0.000000e+00 1.008986e-03 0.000000e+00
## Eukaryota;Priapulida              1.056357e-04 0.000000e+00 0.000000e+00
## Eukaryota;Rotifera                1.373264e-03 5.990856e-04 1.047445e-03
## Eukaryota;Streptophyta            1.531717e-03 8.828630e-04 1.862125e-03
## Eukaryota;Tardigrada              5.281783e-05 0.000000e+00 0.000000e+00
## Eukaryota;Unassigned              6.510326e-01 5.577802e-01 1.864453e-01
## Eukaryota;Xanthophyceae           0.000000e+00 3.153082e-05 0.000000e+00
## Eukaryota;Xenacoelomorpha         4.753605e-03 0.000000e+00 0.000000e+00
## Eukaryota;Zoopagomycota           5.281783e-05 0.000000e+00 0.000000e+00
## Mitochondria;Unassigned           0.000000e+00 0.000000e+00 0.000000e+00
## Unassigned;Unassigned             5.281783e-05 0.000000e+00 0.000000e+00
##                                     SRR4428184   SRR4428185   SRR4428186
## Archaea;Candidatus_Bathyarchaeota 0.000000e+00 0.000000e+00 0.000000e+00
## Archaea;Crenarchaeota             0.000000e+00 0.000000e+00 0.000000e+00
## Archaea;Unassigned                0.000000e+00 3.304038e-05 3.681207e-05
## Bacteria;Bacteroidetes            4.122629e-04 8.260094e-04 3.681207e-05
## Bacteria;Chlamydiae               0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Planctomycetes           0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Unassigned               0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Verrucomicrobia          3.747845e-05 0.000000e+00 0.000000e+00
## Chloroplast;Unassigned            0.000000e+00 3.304038e-05 3.681207e-05
## Eukaryota;Annelida                7.495690e-05 8.260094e-04 1.763298e-02
## Eukaryota;Apicomplexa             1.499138e-03 3.304038e-04 5.153690e-04
## Eukaryota;Arthropoda              6.746121e-04 9.614749e-03 5.002761e-02
## Eukaryota;Ascomycota              6.146466e-03 2.711293e-01 3.423523e-03
## Eukaryota;Bacillariophyta         7.345776e-03 1.476905e-02 1.651390e-01
## Eukaryota;Basidiomycota           3.448017e-03 9.713870e-03 7.288791e-03
## Eukaryota;Blastocladiomycota      3.747845e-05 0.000000e+00 0.000000e+00
## Eukaryota;Brachiopoda             0.000000e+00 1.354655e-03 1.472483e-04
## Eukaryota;Bryozoa                 0.000000e+00 4.625653e-04 4.417449e-04
## Eukaryota;Chlorophyta             1.049397e-02 3.778828e-01 1.244248e-02
## Eukaryota;Chordata                1.499138e-04 9.912113e-05 4.417449e-04
## Eukaryota;Chromerida              0.000000e+00 0.000000e+00 3.681207e-05
## Eukaryota;Chytridiomycota         9.369612e-04 4.592612e-03 7.914596e-03
## Eukaryota;Cnidaria                5.621767e-04 7.268883e-04 1.133812e-02
## Eukaryota;Colponemidia            0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Cryptomycota            7.495690e-05 3.304038e-05 2.944966e-04
## Eukaryota;Ctenophora              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Echinodermata           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Entoprocta              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Eustigmatophyceae       0.000000e+00 1.652019e-04 0.000000e+00
## Eukaryota;Gastrotricha            3.747845e-05 3.304038e-05 0.000000e+00
## Eukaryota;Haplosporidia           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Hemichordata            0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Kinorhyncha             3.747845e-05 1.982423e-04 0.000000e+00
## Eukaryota;Microsporidia           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Mollusca                1.000675e-02 1.024252e-03 5.547580e-02
## Eukaryota;Mucoromycota            0.000000e+00 5.616864e-04 1.362047e-03
## Eukaryota;Nematoda                3.747845e-05 3.304038e-04 3.497147e-03
## Eukaryota;Nemertea                0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Phaeophyceae            1.611573e-03 5.610256e-02 3.681207e-05
## Eukaryota;Picozoa                 0.000000e+00 0.000000e+00 7.362415e-05
## Eukaryota;Pinguiophyceae          0.000000e+00 0.000000e+00 1.472483e-04
## Eukaryota;Platyhelminthes         2.141893e-01 3.931805e-03 3.828456e-03
## Eukaryota;Porifera                3.747845e-05 6.608075e-05 4.417449e-04
## Eukaryota;Priapulida              0.000000e+00 2.973634e-04 4.785570e-04
## Eukaryota;Rotifera                8.620043e-04 1.367872e-02 7.215167e-03
## Eukaryota;Streptophyta            6.371336e-04 3.072755e-03 2.944966e-04
## Eukaryota;Tardigrada              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Unassigned              7.404992e-01 2.280116e-01 6.497331e-01
## Eukaryota;Xanthophyceae           3.747845e-05 6.608075e-05 0.000000e+00
## Eukaryota;Xenacoelomorpha         1.124353e-04 0.000000e+00 1.840604e-04
## Eukaryota;Zoopagomycota           0.000000e+00 0.000000e+00 0.000000e+00
## Mitochondria;Unassigned           0.000000e+00 3.304038e-05 0.000000e+00
## Unassigned;Unassigned             0.000000e+00 0.000000e+00 3.681207e-05
##                                     SRR4428187   SRR4428188   SRR4428189
## Archaea;Candidatus_Bathyarchaeota 0.000000e+00 0.000000e+00 0.000000e+00
## Archaea;Crenarchaeota             0.000000e+00 3.725644e-05 0.000000e+00
## Archaea;Unassigned                2.943052e-04 3.353079e-04 0.000000e+00
## Bacteria;Bacteroidetes            1.471526e-04 3.353079e-04 4.408782e-05
## Bacteria;Chlamydiae               0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Planctomycetes           0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Unassigned               3.433561e-04 3.725644e-04 4.408782e-05
## Bacteria;Verrucomicrobia          0.000000e+00 0.000000e+00 0.000000e+00
## Chloroplast;Unassigned            0.000000e+00 3.725644e-05 0.000000e+00
## Eukaryota;Annelida                4.905087e-05 1.117693e-04 1.763513e-03
## Eukaryota;Apicomplexa             6.867121e-04 4.843337e-04 2.204391e-04
## Eukaryota;Arthropoda              4.757934e-03 2.067732e-02 3.615201e-03
## Eukaryota;Ascomycota              1.643204e-02 8.941545e-03 5.255268e-02
## Eukaryota;Bacillariophyta         5.071860e-02 9.116650e-02 5.907768e-03
## Eukaryota;Basidiomycota           1.397950e-02 9.202340e-03 4.188343e-03
## Eukaryota;Blastocladiomycota      4.905087e-05 3.725644e-05 0.000000e+00
## Eukaryota;Brachiopoda             0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Bryozoa                 0.000000e+00 0.000000e+00 1.322635e-04
## Eukaryota;Chlorophyta             6.739589e-02 7.592862e-02 2.556212e-01
## Eukaryota;Chordata                4.905087e-05 3.725644e-05 8.817565e-05
## Eukaryota;Chromerida              9.810173e-05 7.451287e-05 0.000000e+00
## Eukaryota;Chytridiomycota         2.383872e-02 1.724973e-02 5.422802e-03
## Eukaryota;Cnidaria                1.471526e-03 5.215901e-04 2.513006e-03
## Eukaryota;Colponemidia            4.905087e-05 0.000000e+00 0.000000e+00
## Eukaryota;Cryptomycota            4.905087e-05 1.490257e-04 0.000000e+00
## Eukaryota;Ctenophora              0.000000e+00 3.725644e-05 1.763513e-04
## Eukaryota;Echinodermata           0.000000e+00 0.000000e+00 4.408782e-05
## Eukaryota;Entoprocta              2.943052e-04 0.000000e+00 0.000000e+00
## Eukaryota;Eustigmatophyceae       8.338647e-04 4.843337e-04 8.817565e-05
## Eukaryota;Gastrotricha            9.319664e-04 0.000000e+00 4.408782e-05
## Eukaryota;Haplosporidia           4.905087e-05 0.000000e+00 0.000000e+00
## Eukaryota;Hemichordata            0.000000e+00 0.000000e+00 4.408782e-05
## Eukaryota;Kinorhyncha             0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Microsporidia           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Mollusca                3.433561e-04 3.390336e-03 3.438850e-03
## Eukaryota;Mucoromycota            1.128170e-03 7.078723e-04 8.376686e-04
## Eukaryota;Nematoda                2.452543e-04 3.725644e-05 4.408782e-05
## Eukaryota;Nemertea                0.000000e+00 0.000000e+00 4.408782e-05
## Eukaryota;Phaeophyceae            5.395595e-04 1.490257e-04 1.763513e-04
## Eukaryota;Picozoa                 0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Pinguiophyceae          0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Platyhelminthes         1.716780e-03 5.215901e-04 1.216824e-02
## Eukaryota;Porifera                9.810173e-05 7.451287e-05 0.000000e+00
## Eukaryota;Priapulida              0.000000e+00 0.000000e+00 1.763513e-04
## Eukaryota;Rotifera                2.501594e-03 1.266719e-03 7.935808e-04
## Eukaryota;Streptophyta            2.631579e-01 2.738348e-02 3.174323e-03
## Eukaryota;Tardigrada              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Unassigned              5.477020e-01 7.400991e-01 6.466361e-01
## Eukaryota;Xanthophyceae           0.000000e+00 3.725644e-05 0.000000e+00
## Eukaryota;Xenacoelomorpha         0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Zoopagomycota           4.905087e-05 7.451287e-05 0.000000e+00
## Mitochondria;Unassigned           0.000000e+00 0.000000e+00 0.000000e+00
## Unassigned;Unassigned             0.000000e+00 3.725644e-05 0.000000e+00
##                                     SRR4428190   SRR4428191   SRR4428192
## Archaea;Candidatus_Bathyarchaeota 0.000000e+00 0.000000e+00 0.000000e+00
## Archaea;Crenarchaeota             0.000000e+00 0.000000e+00 0.000000e+00
## Archaea;Unassigned                0.000000e+00 0.000000e+00 2.492940e-03
## Bacteria;Bacteroidetes            1.290665e-03 0.000000e+00 2.272326e-03
## Bacteria;Chlamydiae               0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Planctomycetes           0.000000e+00 0.000000e+00 2.206142e-05
## Bacteria;Unassigned               1.518430e-04 7.387161e-05 4.875574e-03
## Bacteria;Verrucomicrobia          0.000000e+00 0.000000e+00 0.000000e+00
## Chloroplast;Unassigned            0.000000e+00 0.000000e+00 1.544299e-04
## Eukaryota;Annelida                1.518430e-04 3.730516e-03 6.177197e-04
## Eukaryota;Apicomplexa             7.592150e-05 2.954864e-04 7.721497e-04
## Eukaryota;Arthropoda              3.796075e-04 3.017655e-02 6.750794e-03
## Eukaryota;Ascomycota              1.777322e-01 9.233951e-04 5.285916e-02
## Eukaryota;Bacillariophyta         9.110580e-04 3.082662e-01 7.339834e-02
## Eukaryota;Basidiomycota           3.416467e-03 3.841324e-03 1.824479e-02
## Eukaryota;Blastocladiomycota      3.796075e-05 0.000000e+00 6.618426e-05
## Eukaryota;Brachiopoda             0.000000e+00 1.477432e-04 5.294741e-04
## Eukaryota;Bryozoa                 0.000000e+00 1.108074e-04 6.618426e-05
## Eukaryota;Chlorophyta             5.857344e-01 4.801655e-03 1.658798e-01
## Eukaryota;Chordata                7.592150e-05 2.216148e-04 6.618426e-05
## Eukaryota;Chromerida              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Chytridiomycota         1.992939e-02 5.278127e-02 2.653989e-02
## Eukaryota;Cnidaria                2.657252e-03 5.798921e-03 3.441581e-03
## Eukaryota;Colponemidia            0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Cryptomycota            3.796075e-05 2.216148e-04 5.956583e-04
## Eukaryota;Ctenophora              3.796075e-05 0.000000e+00 0.000000e+00
## Eukaryota;Echinodermata           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Entoprocta              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Eustigmatophyceae       0.000000e+00 1.108074e-04 2.206142e-04
## Eukaryota;Gastrotricha            7.592150e-05 1.754451e-02 5.493293e-03
## Eukaryota;Haplosporidia           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Hemichordata            0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Kinorhyncha             0.000000e+00 0.000000e+00 2.206142e-05
## Eukaryota;Microsporidia           0.000000e+00 3.693581e-05 0.000000e+00
## Eukaryota;Mollusca                1.518430e-04 7.387161e-03 2.647370e-03
## Eukaryota;Mucoromycota            7.592150e-05 8.495235e-04 2.272326e-03
## Eukaryota;Nematoda                0.000000e+00 1.809854e-03 4.191670e-04
## Eukaryota;Nemertea                0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Phaeophyceae            1.518430e-04 5.614242e-03 5.735969e-04
## Eukaryota;Picozoa                 0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Pinguiophyceae          0.000000e+00 4.062939e-04 4.412284e-05
## Eukaryota;Platyhelminthes         1.632312e-03 9.972668e-04 2.206142e-04
## Eukaryota;Porifera                0.000000e+00 0.000000e+00 6.618426e-05
## Eukaryota;Priapulida              0.000000e+00 2.585506e-04 0.000000e+00
## Eukaryota;Rotifera                9.224462e-03 1.255817e-03 1.647988e-02
## Eukaryota;Streptophyta            3.568310e-03 5.540371e-04 1.657474e-01
## Eukaryota;Tardigrada              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Unassigned              1.924610e-01 5.516732e-01 4.459716e-01
## Eukaryota;Xanthophyceae           0.000000e+00 7.387161e-05 2.206142e-05
## Eukaryota;Xenacoelomorpha         0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Zoopagomycota           3.796075e-05 0.000000e+00 0.000000e+00
## Mitochondria;Unassigned           0.000000e+00 0.000000e+00 0.000000e+00
## Unassigned;Unassigned             0.000000e+00 3.693581e-05 1.544299e-04
##                                     SRR4428193   SRR4428194   SRR4428195
## Archaea;Candidatus_Bathyarchaeota 0.000000e+00 0.000000e+00 0.000000e+00
## Archaea;Crenarchaeota             0.000000e+00 0.000000e+00 0.000000e+00
## Archaea;Unassigned                0.000000e+00 1.091584e-04 1.476276e-04
## Bacteria;Bacteroidetes            0.000000e+00 1.637376e-04 2.176031e-02
## Bacteria;Chlamydiae               0.000000e+00 0.000000e+00 5.905105e-05
## Bacteria;Planctomycetes           0.000000e+00 0.000000e+00 0.000000e+00
## Bacteria;Unassigned               1.838686e-04 2.728960e-04 5.314594e-03
## Bacteria;Verrucomicrobia          0.000000e+00 0.000000e+00 0.000000e+00
## Chloroplast;Unassigned            0.000000e+00 0.000000e+00 2.066787e-04
## Eukaryota;Annelida                9.193430e-04 0.000000e+00 9.743423e-04
## Eukaryota;Apicomplexa             1.409659e-03 1.364480e-03 2.686823e-03
## Eukaryota;Arthropoda              4.167688e-03 1.473638e-03 2.804925e-03
## Eukaryota;Ascomycota              1.262564e-02 1.855693e-02 1.832354e-01
## Eukaryota;Bacillariophyta         1.671366e-01 2.159153e-01 8.828132e-03
## Eukaryota;Basidiomycota           1.305467e-02 1.178911e-02 4.865806e-02
## Eukaryota;Blastocladiomycota      0.000000e+00 3.274752e-04 0.000000e+00
## Eukaryota;Brachiopoda             6.128953e-05 5.457919e-05 1.564853e-03
## Eukaryota;Bryozoa                 0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Chlorophyta             1.233145e-01 9.414911e-02 1.190174e-01
## Eukaryota;Chordata                8.580534e-03 0.000000e+00 2.952552e-05
## Eukaryota;Chromerida              0.000000e+00 5.457919e-05 0.000000e+00
## Eukaryota;Chytridiomycota         2.445452e-02 1.746534e-02 2.804925e-02
## Eukaryota;Cnidaria                5.516058e-04 3.820544e-04 3.543063e-04
## Eukaryota;Colponemidia            0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Cryptomycota            1.225791e-04 2.728960e-04 5.905105e-04
## Eukaryota;Ctenophora              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Echinodermata           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Entoprocta              6.128953e-05 0.000000e+00 0.000000e+00
## Eukaryota;Eustigmatophyceae       3.064477e-04 1.473638e-03 1.181021e-04
## Eukaryota;Gastrotricha            1.838686e-04 4.366336e-04 9.743423e-04
## Eukaryota;Haplosporidia           0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Hemichordata            0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Kinorhyncha             6.128953e-05 4.366336e-04 0.000000e+00
## Eukaryota;Microsporidia           0.000000e+00 1.091584e-04 0.000000e+00
## Eukaryota;Mollusca                2.819318e-03 2.728960e-04 6.200360e-04
## Eukaryota;Mucoromycota            1.409659e-03 5.457919e-04 2.804925e-03
## Eukaryota;Nematoda                3.064477e-04 2.183168e-04 1.476276e-04
## Eukaryota;Nemertea                0.000000e+00 0.000000e+00 8.857657e-05
## Eukaryota;Phaeophyceae            1.225791e-04 5.457919e-05 6.200360e-04
## Eukaryota;Picozoa                 6.128953e-05 0.000000e+00 0.000000e+00
## Eukaryota;Pinguiophyceae          0.000000e+00 0.000000e+00 5.905105e-05
## Eukaryota;Platyhelminthes         5.393479e-02 1.146163e-03 8.857657e-04
## Eukaryota;Porifera                1.225791e-04 0.000000e+00 0.000000e+00
## Eukaryota;Priapulida              0.000000e+00 0.000000e+00 2.952552e-05
## Eukaryota;Rotifera                1.899975e-03 4.966707e-03 8.857657e-05
## Eukaryota;Streptophyta            1.526109e-02 2.194084e-02 2.114028e-02
## Eukaryota;Tardigrada              0.000000e+00 0.000000e+00 0.000000e+00
## Eukaryota;Unassigned              5.666830e-01 6.058836e-01 5.444212e-01
## Eukaryota;Xanthophyceae           0.000000e+00 5.457919e-05 3.513537e-03
## Eukaryota;Xenacoelomorpha         6.128953e-05 0.000000e+00 0.000000e+00
## Eukaryota;Zoopagomycota           6.128953e-05 0.000000e+00 1.476276e-04
## Mitochondria;Unassigned           0.000000e+00 5.457919e-05 2.952552e-05
## Unassigned;Unassigned             6.128953e-05 5.457919e-05 2.952552e-05
##                                     SRR4428196
## Archaea;Candidatus_Bathyarchaeota 0.000000e+00
## Archaea;Crenarchaeota             0.000000e+00
## Archaea;Unassigned                1.503127e-04
## Bacteria;Bacteroidetes            5.711881e-04
## Bacteria;Chlamydiae               0.000000e+00
## Bacteria;Planctomycetes           0.000000e+00
## Bacteria;Unassigned               6.313131e-04
## Bacteria;Verrucomicrobia          0.000000e+00
## Chloroplast;Unassigned            6.012506e-05
## Eukaryota;Annelida                1.037157e-02
## Eukaryota;Apicomplexa             3.607504e-04
## Eukaryota;Arthropoda              8.838384e-03
## Eukaryota;Ascomycota              1.012506e-01
## Eukaryota;Bacillariophyta         1.564153e-01
## Eukaryota;Basidiomycota           9.409572e-03
## Eukaryota;Blastocladiomycota      0.000000e+00
## Eukaryota;Brachiopoda             3.006253e-05
## Eukaryota;Bryozoa                 2.705628e-04
## Eukaryota;Chlorophyta             2.260702e-01
## Eukaryota;Chordata                1.202501e-04
## Eukaryota;Chromerida              0.000000e+00
## Eukaryota;Chytridiomycota         6.703944e-03
## Eukaryota;Cnidaria                4.028379e-03
## Eukaryota;Colponemidia            0.000000e+00
## Eukaryota;Cryptomycota            1.202501e-04
## Eukaryota;Ctenophora              0.000000e+00
## Eukaryota;Echinodermata           3.006253e-04
## Eukaryota;Entoprocta              0.000000e+00
## Eukaryota;Eustigmatophyceae       3.908129e-04
## Eukaryota;Gastrotricha            7.966570e-03
## Eukaryota;Haplosporidia           0.000000e+00
## Eukaryota;Hemichordata            3.006253e-05
## Eukaryota;Kinorhyncha             9.018759e-05
## Eukaryota;Microsporidia           0.000000e+00
## Eukaryota;Mollusca                8.255171e-02
## Eukaryota;Mucoromycota            4.810005e-04
## Eukaryota;Nematoda                1.352814e-03
## Eukaryota;Nemertea                0.000000e+00
## Eukaryota;Phaeophyceae            1.533189e-03
## Eukaryota;Picozoa                 0.000000e+00
## Eukaryota;Pinguiophyceae          3.006253e-05
## Eukaryota;Platyhelminthes         5.351130e-03
## Eukaryota;Porifera                1.503127e-04
## Eukaryota;Priapulida              9.018759e-05
## Eukaryota;Rotifera                1.067220e-02
## Eukaryota;Streptophyta            1.139370e-02
## Eukaryota;Tardigrada              0.000000e+00
## Eukaryota;Unassigned              3.511604e-01
## Eukaryota;Xanthophyceae           6.012506e-04
## Eukaryota;Xenacoelomorpha         3.006253e-05
## Eukaryota;Zoopagomycota           0.000000e+00
## Mitochondria;Unassigned           0.000000e+00
## Unassigned;Unassigned             4.208754e-04
```


```r
heatmap(as.matrix(normtab))
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)


```r
pca = prcomp(t(normtab))
plot(pca$x[,1],pca$x[,2],pch=19,col=2)
text(pca$x[,1],pca$x[,2],rownames(pca$x),pos=3,cex=0.6)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

Further analysis can be facilitated by [installing Bioconductor](https://www.bioconductor.org/install/), together with packages such as `DESeq2` and `phyloseq`. However, this is beyond the scope of this session.

