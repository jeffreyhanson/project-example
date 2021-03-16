## variables
# MODE=release# set parameters for inference
MODE=debug# set parameters for debugging code
R=/opt/R/R-4.0.3/bin/R # path to R 4.0.3 installation

## main operations
R:
	$(R) --quiet --no-save

all: install analysis manuscript

clean:
	@rm -rf data/intermediate/*
	@rm -rf data/final/*
	@rm article/* -f
	@touch data/intermediate/.gitkeep
	@touch data/final/.gitkeep
	@touch article/.gitkeep

# commands for updating time-stamps
touch:
	touch data/intermediate/00*.rda
	touch data/intermediate/01*.rda
	touch data/intermediate/02*.rda
	touch data/intermediate/03*.rda

# commands for generating manuscript
manuscript: article si figures

article: article/article.pdf article/article.docx

figures: article/figures.pdf

si: article/supporting-information.pdf

archive: article/surveyroi-manuscript.zip

article/article.pdf: code/rmarkdown/article.Rmd code/rmarkdown/figures.Rmd code/rmarkdown/references.bib code/rmarkdown/preamble.tex code/rmarkdown/reference-style.csl
	$(R) -e "rmarkdown::render('code/rmarkdown/article.Rmd')"
	rm -f code/rmarkdown/article.aux
	rm -f code/rmarkdown/article.out
	rm -f code/rmarkdown/article.md
	rm -f code/rmarkdown/article.log
	mv code/rmarkdown/article.pdf article/
	mv code/rmarkdown/article.tex article/

article/article.docx: code/rmarkdown/article.Rmd code/rmarkdown/references.bib code/rmarkdown/preamble.tex code/rmarkdown/reference-style.csl
	cp code/rmarkdown/article.Rmd code/rmarkdown/article2.Rmd
	sed -ri 's/\\newline/  /g' code/rmarkdown/article2.Rmd
	$(R) --no-save -e "rmarkdown::render('code/rmarkdown/article2.Rmd', output_file='article.tex')"
	rm -f code/rmarkdown/article2.md
	cd code/rmarkdown && pandoc +RTS -K512m -RTS article.tex -o article.docx --highlight-style tango --latex-engine pdflatex --include-in-header preamble.tex --variable graphics=yes --variable 'geometry:margin=1in' --bibliography references.bib --filter /usr/bin/pandoc-citeproc
	rm -f code/rmarkdown/article2.tex
	rm -f code/rmarkdown/article2.log
	rm -f code/rmarkdown/article2.Rmd
	mv code/rmarkdown/article.docx article/

article/supporting-information.pdf: code/rmarkdown/supporting-information.Rmd code/rmarkdown/preamble.tex code/rmarkdown/references.bib code/rmarkdown/reference-style.csl
	$(R) -e "rmarkdown::render('code/rmarkdown/supporting-information.Rmd')"
	mv code/rmarkdown/supporting-information.pdf article/
	rm -f code/rmarkdown/supporting-information.md
	rm -f code/rmarkdown/supporting-information.log
	rm -f code/rmarkdown/supporting-information.aux
	rm -f code/rmarkdown/supporting-information.out

article/figures.pdf: code/rmarkdown/figures.Rmd code/rmarkdown/preamble.tex code/rmarkdown/references.bib code/rmarkdown/reference-style.csl
	$(R) -e "rmarkdown::render('code/rmarkdown/figures.Rmd')"
	mv code/rmarkdown/figures.pdf article/
	rm -f code/rmarkdown/figures.md
	rm -f code/rmarkdown/figures.log
	rm -f code/rmarkdown/figures.aux
	rm -f code/rmarkdown/figures.out

article/spider-menace.zip:
	zip -r article/spider-menace.zip ../spider-menace -x "*.git*" -x "*lib*" -x "*\.directory*"

# commands for running analysis
analysis: data/final/results.rda

data/final/results.rda: data/intermediate/03-*.rda code/R/analysis/04-*.R
	$(R) CMD BATCH --no-restore --no-save code/R/analysis/04-*.R
	mv -f *.Rout data/intermediate/

data/intermediate/03-*.rda: data/intermediate/02-*.rda code/R/analysis/03-*.R code/parameters/jags.toml
	$(R) CMD BATCH --no-restore --no-save code/R/analysis/03-*.R
	mv -f *.Rout data/intermediate/

data/intermediate/02-*.rda: data/intermediate/01-*.rda code/R/analysis/02-*.R
	$(R) CMD BATCH --no-restore --no-save code/R/analysis/02-*.R
	mv -f *.Rout data/intermediate/

data/intermediate/01-*.rda: data/intermediate/00-*.rda code/R/analysis/01-*.R
	$(R) CMD BATCH --no-restore --no-save code/R/analysis/01-*.R
	mv -f *.Rout data/intermediate/

data/intermediate/00-*.rda: code/R/analysis/00-*.R code/parameters/general.toml code/R/functions/misc.R
	$(R) CMD BATCH --no-restore --no-save '--args MODE=$(MODE)' code/R/analysis/00-*.R
	mv -f *.Rout data/intermediate/

# packrat commands
packrat_snapshot:
	$(R) -e "packrat::snapshot(infer = FALSE)"

# command to install dependencies
install:
	$(R) CMD BATCH --no-restore --no-save '--args --bootstrap-packrat' packrat/init.R
	mv -f *.Rout data/intermediate/

.PHONY: install clean all analysis manuscript article figures raw_data
