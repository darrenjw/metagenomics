# Makefile

FRAGMENTS=EBIMetagenomics.R TaxaAbundance.R

HTML=README.html EBIMetagenomics.html TaxaAbundance.html Exercise.html

FORCE:
	make fragments

fragments: $(FRAGMENTS)

html: $(HTML)

%.R: %.md
	cat $< | sed -n '/^```r/,/^```/ p' | sed 's/^```.*//g' > $@

%.md: %.Rmd
	Rscript -e "library(knitr); knit('$<')"

%.html: %.md
	pandoc $< -o $@

edit:
	emacs Makefile *.Rmd Exercise.md README.md &

clean:
	rm -f *~ $(FRAGMENTS)



# eof


