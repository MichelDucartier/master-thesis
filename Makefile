# Makefile for LaTeX Project

###################
# Configuration
###################

# Main document name
THESIS = main

# LaTeX engines options
ENGINES = -pdflatex -xelatex -lualatex
ENGINE ?= -pdflatex  # Default engine

# Check for required programs
REQUIRED_PROGRAMS := latexmk pdflatex
$(foreach prog,$(REQUIRED_PROGRAMS),\
    $(if $(shell which $(prog)),,$(error "$(prog) not found in PATH")))

# Check if engine is valid
ifneq ($(filter all pvc, $(MAKECMDGOALS)), )
    ifeq ($(filter $(ENGINES), $(ENGINE)), )
        $(info Error: Expected $$ENGINE in {$(ENGINES)})
        $(info Setting default $$ENGINE to "-pdflatex")
        ENGINE = -pdflatex
    endif
endif

# LaTeXmk options
LATEXMK_OPTIONS = \
    -quiet \
    -file-line-error \
    -halt-on-error \
    -interaction=nonstopmode \
    -shell-escape \
	-synctex=1 \
    -recorder \
    $(ENGINE)

# Preview continuous mode options
LATEXMK_PVC_OPTIONS = $(LATEXMK_OPTIONS) -pvc

###################
# OS Detection
###################

# Detect OS and set commands accordingly
ifeq ($(OS),Windows_NT)
    RM = del /Q
    RMDIR = rmdir /S /Q
    MKDIR = mkdir
    OPEN = start
else
    RM = rm -f
    RMDIR = rm -rf
    MKDIR = mkdir -p
    ifeq ($(shell uname),Darwin)
        OPEN = open
    else
        OPEN = xdg-open
    endif
endif

###################
# Targets
###################

.PHONY: all pvc view wordcount clean cleanall help FORCE_MAKE

# Default target
all: $(THESIS).pdf

# Force remake
$(THESIS).pdf: $(THESIS).tex FORCE_MAKE
	@echo "Building $(THESIS).pdf with $(ENGINE)..."
	@latexmk $(LATEXMK_OPTIONS) $<

# Preview continuous mode
pvc: $(THESIS).tex
	@echo "Starting preview continuous mode..."
	@latexmk $(LATEXMK_PVC_OPTIONS) $(THESIS)

# View PDF
view: $(THESIS).pdf
	@echo "Opening $(THESIS).pdf..."
	$(OPEN) $<

# Word count
wordcount: $(THESIS).tex
	@echo "Counting words in $(THESIS).tex..."
	@texcount $< -inc -total | grep 'Words in text' | sed 's/+.*//'

# Clean auxiliary files
clean:
	@echo "Cleaning auxiliary files..."
	-@latexmk -c -bibtex -silent $(THESIS).tex 2> /dev/null
	@echo "Clean complete."

# Clean all generated files
cleanall:
	@echo "Cleaning all generated files..."
	-@latexmk -C -bibtex -silent $(THESIS).tex 2> /dev/null
	@echo "Clean complete."

# Help target
help:
	@echo "Available targets:"
	@echo "  all       - Build PDF (default)"
	@echo "  pvc       - Preview continuously"
	@echo "  view      - Open PDF"
	@echo "  wordcount - Count words and characters"
	@echo "  clean     - Remove auxiliary files"
	@echo "  cleanall  - Remove all generated files"
	@echo "  help      - Show this help message"
	@echo ""
	@echo "Available engines (use ENGINE=<option>):"
	@echo "  -pdflatex (default)"
	@echo "  -xelatex"
	@echo "  -lualatex"
	@echo ""
	@echo "Example usage:"
	@echo "  make ENGINE=-xelatex"
	@echo "  make pvc ENGINE=-lualatex"

# Force remake
FORCE_MAKE:
