# Build configuration shared by every collaborator, every editor and CI.
# Run `latexmk` in the repo root; it reads this file automatically.

# Engine: 1 = pdflatex, 4 = lualatex, 5 = xelatex
$pdf_mode = 1;

@default_files = ('main.tex');
$out_dir = 'build';

# Run biber automatically and remove its output on `latexmk -c`
$bibtex_use = 2;

my $flags = '-synctex=1 -interaction=nonstopmode -file-line-error';
$pdflatex = "pdflatex $flags %O %S";
$lualatex = "lualatex $flags %O %S";
$xelatex  = "xelatex $flags %O %S";

# Project-specific .sty/.cls/.bst files live in ./tex
ensure_path('TEXINPUTS', './tex//');
ensure_path('BSTINPUTS', './tex//');

$clean_ext = 'synctex.gz run.xml bbl bcf nav snm vrb tdo';
