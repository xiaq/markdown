.PHONY: all clean implode
AUXFILES=markdown.bbl markdown.cb markdown.cb2 markdown.glo markdown.bbl \
				 markdown.run.xml markdown.bib
AUXDIRS=_minted-markdown
DTXARCHIVE=markdown.dtx
INSTALLER=markdown.ins
MANUAL=markdown.pdf
INSTALLABLES=markdown.lua markdown.tex markdown.sty markdown-context.tex
MAKEABLES=$(MANUAL) $(INSTALLABLES)

# This is the default pseudo-target.
all: $(MAKEABLES) clean

# This target extracts the source files out of the DTX archive.
$(INSTALLABLES): $(INSTALLER) $(DTXARCHIVE)
	xetex $<

# This target typesets the technical documentation.
%.pdf: %.dtx
	latexmk -pdf $<

# This pseudo-target removes any existing auxiliary files and directories.
clean:
	latexmk -c
	rm -f $(AUXFILES)
	rm -rf ${AUXDIRS}

# This pseudo-target removes any makeable files.
implode: clean
	rm -f $(MAKEABLES)
