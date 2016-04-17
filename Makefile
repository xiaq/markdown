.PHONY: all clean implode
AUXFILES=markdown.aux markdown.log markdown.toc markdown.ind \
	markdown.idx markdown.out markdown.ilg markdown.gls \
	markdown.glo markdown.hd markdown.lot
DTXARCHIVE=markdown.dtx
INSTALLER=markdown.ins
LUAFILE=markdown.lua
TEXFILE=markdown.tex
MANUAL=markdown.pdf
MAKEABLES=$(MANUAL) $(LUAFILE) $(TEXFILE)

# This is the default pseudo-target.
all: $(LUAFILE) $(TEXFILE) $(MANUAL) clean

# This target extracts the source files out of the DTX archive.
$(TEXFILE) $(LUAFILE): $(INSTALLER) $(DTXARCHIVE)
	xetex $<

# This target typesets the technical documentation.
%.pdf: %.dtx
	pdflatex $<
	#pdflatex $<
	#makeindex -s gind.ist                       $(basename $@)
	#makeindex -s gglo.ist -o $(basename $@).gls $(basename $@).glo
	#pdflatex $<
	#pdflatex $<

# This pseudo-target removes any existing auxiliary files.
clean:
	rm -f $(AUXFILES)

# This pseudo-target removes any makeable files.
implode: clean
	rm -f $(MAKEABLES)
