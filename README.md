# Project title

![LaTeX build](https://github.com/OWNER/REPO/actions/workflows/build.yml/badge.svg)

Source of the document *Project title*. Written in LaTeX, versioned with Git,
built automatically by GitHub Actions.

**Just want to read it?** The latest PDF is under
[Actions](../../actions) → latest run → *Artifacts* → `pdf`.
Finished versions are under [Releases](../../releases).

---

## 1. Choose how you want to work

You do **not** need to install exactly what everyone else has. The build is
defined by files in this repo, and GitHub checks every push with a fixed TeX Live
version. Pick whichever option suits you:

| Option | Install | Good for |
|---|---|---|
| **A. Browser (Codespaces)** | Nothing | Occasional edits, reviewers, anyone on a lab PC |
| **B. Local VS Code + TeX Live** | TeX Live, VS Code, Git | Regular authors (recommended) |
| **C. Local dev container** | Docker, VS Code, Git | Getting a build identical to CI, bit for bit |
| **D. Any other editor** | A TeX distribution with `latexmk` | TeXstudio, Vim, Emacs users |

**A. Browser.** On this repo's page: *Code* → *Codespaces* → *Create codespace on
main*. A VS Code window opens in the browser with everything installed. The first
start takes a few minutes; later ones are fast. Free GitHub accounts include a
monthly quota of Codespaces hours. Stop the codespace when you're done.

**B. Local.** Follow [docs/SETUP.md](docs/SETUP.md) once, then:

```bash
git clone https://github.com/OWNER/REPO.git
cd REPO
code .           # VS Code will offer to install the recommended extensions: accept
```

Check your machine with the doctor script:

```powershell
.\scripts\doctor.ps1      # Windows
bash scripts/doctor.sh    # macOS / Linux
```

**C. Dev container.** With Docker running, open the folder in VS Code and choose
*Reopen in Container* when prompted (needs the *Dev Containers* extension).

**D. Other editors.** Anything works as long as you build with `latexmk` from the
repo root; it reads [.latexmkrc](.latexmkrc) and does the rest. Every file under
`sections/` starts with `% !TEX root = ../main.tex`, which TeXstudio, TeXworks and
VS Code all understand.

## 2. Building

| Where | How |
|---|---|
| VS Code | Save the file (`Ctrl+S`) — it builds automatically. Preview: `Ctrl+Alt+V` |
| Terminal | `latexmk` (build), `latexmk -pvc` (rebuild on every save), `latexmk -c` (clean) |

The PDF appears as `build/main.pdf`. The `build/` folder is ignored by Git.

In VS Code, `Ctrl+Alt+J` jumps from the source to the PDF, and `Ctrl+click` on the
PDF jumps back to the source.

## 3. Daily workflow

```bash
git switch main
git pull                              # always start from the latest version
git switch -c ana/intro-rewrite       # your name / what you're doing

# ... edit, build, check the PDF ...

git add -A
git commit -m "intro: rewrite motivation paragraph"
git push -u origin ana/intro-rewrite
```

Then open a **Pull Request** on GitHub. Co-authors comment on specific lines,
GitHub builds a *track changes* PDF of your edits, and once the check is green
and someone approves, it's merged into `main`.

Small fixes (a typo) can go straight to `main` if the project allows it; anything
longer than a few lines goes through a Pull Request.

## 4. Writing rules

These exist so that two people can edit the same file without conflicts.

1. **One sentence per line.** Git compares lines. A whole paragraph on one line
   means any change by anyone conflicts with any other change to that paragraph.
   Line breaks inside a paragraph don't affect the PDF.
2. **Don't reflow or auto-format text you didn't change.** Formatters rewrite
   other people's lines and create conflicts out of nothing.
3. **Packages go in [preamble.tex](preamble.tex) only**, never inside a section.
4. **References go at the end of [refs.bib](refs.bib)**, key format
   `firstauthorYEARfirstword` in lowercase, e.g. `hawking1975particle`.
   Search the file first so the same paper isn't added twice under two keys.
5. **Figures go in `figures/`**, lowercase, no spaces, no accents:
   `energy-spectrum.pdf`, not `Espectro Energía.PDF`. Vector formats (PDF) for
   plots, PNG/JPG for photos.
6. **Labels have a prefix:** `sec:`, `eq:`, `fig:`, `tab:`. Reference them with
   `\cref{fig:spectrum}` (or `\Cref` at the start of a sentence).
7. **Notes to co-authors** use `\todo{...}` (margin) or `\todo[inline]{...}`.
8. **Never commit build files** or the document's PDF. `.gitignore` handles this
   unless you force it.

## 5. Reviewing changes ("track changes")

- **On a Pull Request:** *Checks* → *LaTeX* → *Artifacts* → `diff-pdf`. Insertions
  are underlined in blue, deletions struck out in red.
- **Locally**, against any earlier version:

  ```bash
  bash scripts/diff.sh v1.0          # or: .\scripts\diff.ps1 v1.0
  bash scripts/diff.sh origin/main
  ```

  The result is `build/diff.pdf`.

## 6. Repository layout

```
main.tex            document skeleton: title, \input of sections, bibliography
preamble.tex        all packages and macros
sections/           one file per section
figures/            images and plots
refs.bib            bibliography
tex/                project-specific .sty/.cls/.bst files (found automatically)
.latexmkrc          build settings shared by everyone, every editor and CI
.github/workflows/  automatic build, diff PDF and releases
.devcontainer/      environment for Codespaces / dev containers (same as CI)
scripts/            doctor (checks your setup) and diff (track-changes PDF)
docs/SETUP.md       how to install everything locally
```

## 7. FAQ and troubleshooting

**Does everyone need the same LaTeX distribution?**
No. The reference is the GitHub build, which uses TeX Live (full, current year).
If it compiles there, it's correct. Locally, the closer you are to that, the fewer
surprises: TeX Live of the same year is ideal, an up-to-date MiKTeX works fine in
practice, and Codespaces or the dev container are identical by construction.

**It compiles on my machine but the GitHub check fails.**
Open the failed run and read the log. The usual causes:

- *File name case.* Windows and macOS ignore case, Linux doesn't.
  `\includegraphics{Spectrum}` finds `spectrum.pdf` on your laptop and fails on CI.
- *Undefined reference or citation.* The check fails on purpose when a `\cref` or
  `\cite` points to nothing; your local build only shows `??`.
- *A package your distribution installed silently.* MiKTeX downloads missing
  packages on the fly; if it's a package outside TeX Live, put the `.sty` in `tex/`.
- *A system font.* `fontspec` with a font installed on your computer won't exist on
  CI. Use fonts that ship with TeX Live, or commit the font files to the repo.

**`biber` fails with a message about a control file version mismatch.**
Your `biber` and `biblatex` are from different releases. Update everything:
`tlmgr update --self --all` (TeX Live) or *MiKTeX Console → Updates* (MiKTeX).

**`File 'something.sty' not found`.**
TeX Live: `tlmgr install something`. MiKTeX: allow it to install the package.
If it's not a public package, it belongs in `tex/`.

**I have a merge conflict in a `.tex` file.**
VS Code shows both versions with *Accept Current / Incoming / Both* buttons. Keep
the right sentence, delete the markers, build to check, then `git add` and commit.
With one sentence per line, conflicts usually involve a single sentence.

**Can I keep using Overleaf?**
Only if the project owner links the Overleaf project to this GitHub repository
(an Overleaf premium feature). Otherwise, use Codespaces: it gives the same
"nothing to install" experience.

**Line endings / "the whole file changed".**
The repo forces LF line endings through `.gitattributes`. If Git still shows whole
files as changed, run `git config --global core.autocrlf false` and
`git add --renormalize .`.
