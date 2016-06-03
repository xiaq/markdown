.PHONY: all clean
AUXFILES=*.tmp *.tui *.tuo *.mp *.markdown.in *.markdown.out \
				 *.markdown.lua *.log *.aux latex-pdftex.tex \
				 latex-xetex.tex latex-luatex.tex
AUXDIRS=_markdown-*/
OUTPUT=context.pdf latex-pdftex.pdf latex-luatex.pdf latex-xetex.pdf clean

# This is the default pseudo-target.
all: $(OUTPUT) clean

# This target typesets the ConTeXt example.
context.pdf: context.tex
	context context

# This target typesets the LaTeX example using the pdfTeX engine.
latex-pdftex.pdf: latex.tex
	cp latex.tex latex-pdftex.tex
	pdflatex --shell-escape latex-pdftex

# This target typesets the LaTeX example using the XeTeX engine.
latex-xetex.pdf: latex.tex
	cp latex.tex latex-xetex.tex
	xelatex --shell-escape latex-xetex

# This target typesets the LaTeX example using the LuaTeX engine.
latex-luatex.pdf: latex.tex
	cp latex.tex latex-luatex.tex
	lualatex latex-luatex

# This pseudo-target removes any existing auxiliary files and directories.
clean:
	rm -f $(AUXFILES)
	rm -rf $(AUXDIRS)

# This pseudo-target removes any makeable files.
implode: clean
	rm -f $(OUTPUT)
