# Makefile

FRAGMENTS=EBIMetagenomics.R TaxaAbundance.R

FORCE:
	make fragments

fragments: $(FRAGMENTS)

%.R: %.md
	cat $< | sed -n '/^```r/,/^```/ p' | sed 's/^```.*//g' > $@

%.md: %.Rmd
	Rscript -e "library(knitr); knit('$<')"


edit:
	emacs Makefile *.Rmd Exercise.md README.md &

clean:
	rm -f *~ $(FRAGMENTS)



# eof


