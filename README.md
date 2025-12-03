# LiGHTempLaTeX: A $\LaTeX$ template for LiGHTers

A LaTeX template designed for the [Laboratory for Intelligent Global Health & Humanitarian Response Technologies (LiGHT)](https://light-laboratory.org/) jointly hosted at EPFL, Switzerland, and Harvard University, USA, and Carnegie Mellon University Africa, Rwanda.

## Directory Structure

```
.
├── LICENSE
├── README.md
├── bib                       # Bibliography
│   └── references.bib
├── figures                   # Figures
├── main.tex                  # Main file
├── make.bat                  # Windows makefile
├── Makefile                  # Linux/macOS makefile
├── sections                  # Main sections
│   ├── 00_abstract.tex
│   ├── 01_introduction.tex
│   ├── 02_methods.tex
│   ├── 03_results.tex
│   ├── 04_discussion.tex
│   ├── appendix.tex
│   ├── backmatter.tex
│   └── latex_basics.tex      # A brief introduction to LaTeX
└── style                     # Custom style files
```

## Usage

This template is designed to be used with the `pdflatex` engine. It is recommended to use the `latexmk` tool to build the document. The template is compatible with Overleaf and can be easily imported.

Please start by editing the `main.tex` file and the sections in the `sections` directory. The bibliography is stored in the `bib` directory. A brief introduction to LaTeX is provided in the `sections/latex_basics.tex` file.

### Online Use

#### Using Overleaf

You can access and use our Overleaf template through the following link: [![svg of LiGHTempLaTeX](https://img.shields.io/badge/Overleaf-LiGHTempLaTeX-green)](https://www.overleaf.com/read/hmntqtsvmrrk#93217c). 

Alternatively, you can manually upload the template to Overleaf by following these steps:

1. Download this repository as ZIP
2. Go to [Overleaf](https://www.overleaf.com)
3. Create a new project
4. Upload the ZIP file

### Local Use

#### Prerequisites

1. Install a TeX distribution: We recommend installing TeX Live (Windows, Linux) or MacTeX (macOS) following the [official quick install guide](https://tug.org/texlive/quickinstall.html).

2. For code highlighting (optional):
   - Install Python
   - Install Pygments: `pip install Pygments`
   - Add Python path to `PATH` or configure in `main.tex`:
     ```latex
     \renewcommand{\MintedPython}{/path/to/your/python/with/pygments}
     ```

#### Building the Document

##### Linux/macOS (using makefile)

```bash
make all               # Build with default engine
make ENGINE=-pdflatex  # Build with pdflatex
make clean             # Clean auxiliary files
make cleanall          # Clean all generated files
make wordcount         # Count words
```

##### Windows (using make.bat)

```bash
make.bat                   # Build with default engine
make.bat thesis -pdflatex  # Build with pdflatex
make.bat clean             # Clean auxiliary files
make.bat cleanall          # Clean all generated files
make.bat wordcount         # Count words
```

##### VS Code + LaTeX Workshop

1. Install LaTeX Workshop extension
2. Open project folder
3. Build using Recipe: latexmk (pdflatex)

## License

This project is licensed under the LPPL-1.3c License. See the [LICENSE](LICENSE) file for details.
