TEXINPUTS := \
	.:./config:./common:./deps:./content:./examples:./deps/biblatex-iso690:
export TEXINPUTS
PATH := deps/dot2tex/bin:${PATH}
export PATH

DOC_VERSION_HASH=$(shell git log -1 --pretty=format:"%H")
DOC_VERSION_TIME=$(shell git log -1 --pretty=format:"%ai")
XELATEX_JOB_NAME=document
XELATEX_OUTPUT_DIR=dist
XARG1=\newcommand{\docVersionHash}{${DOC_VERSION_HASH}}
XARG2=\newcommand{\docVersionTime}{${DOC_VERSION_TIME}}
XARG3=\input{$*.tex}
XELATEX_ARGS=-shell-escape \
						 -output-directory=${XELATEX_OUTPUT_DIR} \
						 -jobname=${XELATEX_JOB_NAME} \
						 "${XARG1}${XARG2}${XARG3}"
XELATEX_COMMAND=xelatex ${XELATEX_ARGS}

all: prepare config/main.pdf

CONTENT_DIR_EXISTS := $(wildcard content)

ifeq ($(strip $(CONTENT_DIR_EXISTS)),)
prepare:
	@echo "Ruošiama aplinka."
	mkdir content
	cp examples/bibliography.bib content/bibliography.bib
else
prepare:
	@echo "Aplinka jau paruošta"
endif

%.pdf: %.tex
	@echo "Kompiliuojama."
	@echo ${TEXINPUTS} ${PATH}
	$(XELATEX_COMMAND)
	biber "${XELATEX_OUTPUT_DIR}/${XELATEX_JOB_NAME}"
	$(XELATEX_COMMAND)

show:
	xdg-open "${XELATEX_OUTPUT_DIR}/${XELATEX_JOB_NAME}.pdf" 2> /dev/null

clean:
	rm -f dist/document* dist/*.tmp
