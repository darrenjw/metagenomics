# Exercise on taxa abundance data retrieval and analysis

The study on MGnify with secondary accession ID `SRP108566` has four samples (but many runs per sample). The data arises from metagenomic sequencing of human microbiome samples. Your task is to investigate biodiversity in the four samples, following the guidelines below. *Do not use a web browser!* Leave your web browser displaying only these instructions and see if you can accomplish this task completely using only R.

1. Download (and merge) the OTU data for the four samples (separately)
2. Produce plots of the species abundance patterns in each sample
3. How many species were observed in the samples?
4. How many individuals were observed in the samples?
5. Find estimates for the total number of species in the communities corresponding to the four samples. Use some different methods from different packages and compare the results. How consistent are the estimates from the different packages? What fraction of the total species diversity is estimated to have been observed?
6. Fit a selection of SAD models to the two samples. Which distribution fits best? `lnorm`? `poilog`? Something else? Is the same distribution best for all four samples?
7. For each sample, estimate how much more sampling would be required (as a multiple of the amount of sampling already done) in order to observe 95% of the total diversity in the sampled population.
8. Is it plausible that the samples are independent samples from the same meta-community?


#### (C) 2016-19 Darren J Wilkinson

