# Makefile

FRAGMENTS=EBIMetagenomics.R TaxaAbundance.R

FORCE:
	make fragments

fragments: $(FRAGMENTS)

%.R: %.md
	cat $< | sed -n '/^```r/,/^```/ p' | sed 's/^```.*//g' > $@

clean:
	rm -f *~ $(FRAGMENTS)



# eof


