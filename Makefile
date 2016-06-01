.PHONY: all clean implode
AUXDIRS=_minted-markdown
DTXARCHIVE=markdown.dtx
INSTALLER=markdown.ins
MANUAL=markdown.pdf
INSTALLABLES=markdown.lua markdown.tex markdown.sty
MAKEABLES=$(MANUAL) $(INSTALLABLES)

# This is the default pseudo-target.
all: $(MAKEABLES) clean

# This target extracts the source files out of the DTX archive.
$(INSTALLABLES): $(INSTALLER) $(DTXARCHIVE)
	xetex $<

# This target typesets the technical documentation.
%.pdf: %.dtx
	latexmk -pdf $<

# This pseudo-target removes any existing auxiliary files.
clean:
	latexmk -c
	rm -rf ${AUXDIRS}

# This pseudo-target removes any makeable files.
implode: clean
	rm -f $(MAKEABLES)
