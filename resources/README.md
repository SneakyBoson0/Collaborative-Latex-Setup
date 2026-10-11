# resources/

Everything that supports the work but isn't part of the PDF: code, simulations,
data, the assignment statement, guide papers, notes. Nothing in this folder is
compiled into the document.

## How to organise it

Create subfolders only when you need them. A typical project ends up like this:

| Folder | What goes in it |
|---|---|
| `code/` | Python scripts, simulations, Jupyter notebooks, Mathematica or MATLAB files |
| `data/` | Small input files and results: measurements, CSV tables, parameters |
| `papers/` | Guide papers, the assignment statement, lecture notes, datasheets |

For example:

```
resources/
├── code/
│   ├── requirements.txt
│   ├── simulate-pendulum.py
│   └── fit-spectrum.ipynb
├── data/
│   └── measurements-2026-03-14.csv
└── papers/
    ├── assignment-statement.pdf
    └── griffiths-ch4-notes.pdf
```

**Scripts that make a figure for the document go in `figures/`**, next to the
figure they make (as `figures/damped-oscillator.py` does). A script in
`resources/code/` that produces a plot for the PDF should save the image into
`figures/`, for example:

```python
plt.savefig("../../figures/energy-spectrum.pdf")
```

## Rules

1. **Name files in lowercase, without spaces or accents**: `fit-spectrum.py`,
   not `Fit Spectrum (final).py`. Spaces and accents break commands on some
   systems.
2. **Keep files small.** Git keeps every version of every file forever, so a
   large file makes every clone slower, even after you delete it. GitHub warns
   at 50 MB and rejects files over 100 MB. Commit the script, not the gigabytes
   of output it produces; if a result is expensive to recompute, save a reduced
   version (the few columns you plot, a coarser grid).
3. **Don't overwrite someone else's results.** Give output files a name that says
   what they are (`results-damping-0.1.csv`) rather than reusing `output.csv`.
4. **Check the license before uploading a paper.** If this repository is public,
   anyone can download what's in it. For published papers, a link or DOI in a
   note here, or an entry in `refs.bib`, is usually enough. Your own notes and
   the assignment statement are fine.

## Python

List the packages your code needs in `resources/code/requirements.txt`, one per
line:

```
numpy
scipy
matplotlib
```

so a co-author can install them all at once:

```
pip install -r resources/code/requirements.txt
```

If you use a virtual environment, create it as `.venv` in the project folder;
Git already ignores it.

**Notebooks:** clear the outputs before committing (in VS Code: *Clear All
Outputs* in the notebook toolbar, then save). Saved outputs, especially plots,
make the file large and turn every run into a conflict with your co-authors.
