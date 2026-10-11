# Project title

[![LaTeX build](https://github.com/SneakyBoson0/Collaborative-Latex-Setup/actions/workflows/build.yml/badge.svg)](../../actions/workflows/build.yml)

**📄 [Read the latest PDF](../../blob/pdf/main.pdf)** · [Finished versions](../../releases) · [Package guide](PACKAGES.md)

This repository holds the LaTeX source of *Project title*. We use it instead of
Overleaf: the text lives here, Git keeps the history, and GitHub compiles the PDF
every time someone uploads changes.

If you only want to read the document, the link above is all you need. The rest
of this page is for people who write or review.

---

## Contents

1. [How it works](#1-how-it-works)
2. [Setup (once)](#2-setup-once)
3. [The daily routine](#3-the-daily-routine)
4. [Writing in this project](#4-writing-in-this-project)
5. [Notes between co-authors](#5-notes-between-co-authors)
6. [Reviewing changes](#6-reviewing-changes)
7. [Where the PDF is](#7-where-the-pdf-is)
8. [Files in this repository](#8-files-in-this-repository)
9. [Problems and questions](#9-problems-and-questions)

---

## 1. How it works

Everyone has a copy of the project on their own computer and edits it with VS Code
(or another editor). Saving a file compiles the PDF instantly on your machine.

When your changes are ready, you upload them to GitHub. You don't write directly
into the official version (the `main` branch): you work on your own **branch** and
open a **pull request**, which is a proposal that co-authors can read and comment
on before it's merged. This way no one overwrites anyone else, and every change
has an author, a date and a reason.

GitHub compiles every upload on its own computers, so the official PDF is always
up to date and you can always check that the document still compiles.

| If you're used to Overleaf | Here |
|---|---|
| Recompile | Save the file (`Ctrl+S`) |
| PDF panel | `Ctrl+Alt+V` |
| Click the PDF to jump to the source | `Ctrl+click` on the PDF |
| Track changes | A marked-up PDF made for every pull request |
| Comments | Comments on lines of a pull request, and `\todo{...}` notes |
| History | Every change is recorded: VS Code's *Timeline*, or *Commits* on GitHub |

---

## 2. Setup (once)

About an hour, mostly waiting for downloads. You need a free
[GitHub account](https://github.com/signup) and an invitation to this repository:
send your username to the project owner and accept the email invitation.

Commands go in **PowerShell** (Windows) or **Terminal** (macOS/Linux).

### Step 1. Install TeX Live

TeX Live is the LaTeX distribution GitHub uses, so it gives the fewest surprises.

1. Download `install-tl-windows.exe` from <https://tug.org/texlive/acquire.html>.
2. Right-click it → *Run as administrator*. If Windows says *Windows protected your
   PC*, click *More info* → *Run anyway* (normal for this installer).
3. Keep the defaults and click *Install*. It takes 30–90 minutes.

<details>
<summary>The installation failed with "checksums differ"</summary>

The download server it picked is out of date. Delete `C:\texlive\2026` if it
exists, then in a PowerShell opened as administrator:

```powershell
cd $HOME\Downloads
Invoke-WebRequest https://mirrors.mit.edu/CTAN/systems/texlive/tlnet/install-tl.zip -OutFile install-tl.zip
Expand-Archive install-tl.zip -DestinationPath install-tl
Set-Location (Get-ChildItem install-tl -Directory | Select-Object -First 1).FullName
.\install-tl-windows.bat -repository https://mirrors.mit.edu/CTAN/systems/texlive/tlnet
```

Afterwards, in a normal PowerShell, run once:
`tlmgr option repository https://mirrors.mit.edu/CTAN/systems/texlive/tlnet`
</details>

<details>
<summary>macOS, Linux, or you already have MiKTeX</summary>

- **macOS:** install MacTeX from <https://tug.org/mactex/> (TeX Live for Mac).
- **Linux:** install TeX Live from <https://tug.org/texlive/quickinstall.html>.
  Avoid your distribution's `texlive-*` packages; they're usually years old.
- **MiKTeX:** it works. Update everything in *MiKTeX Console*, allow automatic
  package installation, and install Perl (`winget install StrawberryPerl.StrawberryPerl`).
  Don't keep MiKTeX and TeX Live installed together.
</details>

### Step 2. Install Git and GitHub's command-line tool

```powershell
winget install Git.Git
winget install GitHub.cli
```

Close and reopen PowerShell, then:

```powershell
git config --global user.name  "Your Name"
git config --global user.email "the-email-of-your-github-account"
git config --global core.autocrlf false
gh auth login
```

For `gh auth login` choose *GitHub.com* → *HTTPS* → *Login with a web browser*.
Git won't ask for a password again.

<details>
<summary>macOS or Linux</summary>

macOS: `xcode-select --install` and `brew install gh`.
Linux: install `git` and `gh` with your package manager.
</details>

### Step 3. Install VS Code and open the project

Install VS Code from <https://code.visualstudio.com> (on Windows, tick *Add to PATH*).
Then download the project and open it:

```powershell
mkdir $HOME\Documents\GitHub -Force
cd $HOME\Documents\GitHub
gh repo clone SneakyBoson0/Collaborative-Latex-Setup
cd Collaborative-Latex-Setup
code .
```

When VS Code opens, click *Yes* if it asks whether you trust the folder, and
*Install* when it offers the recommended extensions (**LaTeX Workshop** to build
and view the PDF, **LTeX+** for spelling and grammar).

Always open the project's top folder in VS Code, not a single file or a parent
folder. That's where the build settings live.

### Step 4. Check it works

Open `sections/01-introduction.tex`, press `Ctrl+S`, then `Ctrl+Alt+V`. If the
PDF appears, you're done.

If not, run `pdflatex --version` in VS Code's terminal (`` Ctrl+` ``). It should
mention TeX Live 2026, the version GitHub uses.

<details>
<summary>Using another editor (TeXstudio, Vim, Emacs...)</summary>

Do steps 1 and 2, clone the project as in step 3 (without `code .`), and build
from the project's top folder with:

```powershell
latexmk          # build once
latexmk -pvc     # rebuild on every save
```

If your editor has a compile button, set it to run `latexmk` from the top folder,
not `pdflatex` directly; otherwise the bibliography and output folder won't match
everyone else's. Each section file starts with `% !TEX root = ../main.tex`, which
TeXstudio and TeXworks understand. For the Git steps in section 3, use the
terminal commands shown there.
</details>

---

## 3. The daily routine

All in VS Code. The branch name is at the **bottom-left** of the window; the
*Source Control* panel opens with `Ctrl+Shift+G`.

1. **Get the latest version.** Click the branch name → choose `main`.
   Then *Source Control* → `...` → *Pull*.
2. **Make your branch.** Click the branch name → *Create new branch...* → a name
   such as `ana/introduction`.
3. **Write.** Every `Ctrl+S` rebuilds the PDF.
4. **Commit** (save a snapshot). In *Source Control*, type a short message, such as
   `introduction: rewrite motivation`, and click **Commit**. Commit as often as
   you like.
5. **Upload.** Click **Publish Branch** (first time) or **Sync Changes**.
6. **Propose it.** On GitHub, click **Compare & pull request** in the yellow
   banner, add a sentence about what you changed, and **Create pull request**.
7. **Merge.** When the check is green ✓ and a co-author has approved, click
   **Merge pull request**. Back in VS Code, switch to `main` and *Pull*.

If co-authors ask for changes, edit the same branch, commit and upload again; the
pull request updates by itself.

<details>
<summary>The same routine in the terminal</summary>

```bash
git switch main
git pull
git switch -c ana/introduction
# ... write ...
git add -A
git commit -m "introduction: rewrite motivation"
git push -u origin ana/introduction
gh pr create --fill
# after it's merged:
git switch main
git pull
```
</details>

---

## 4. Writing in this project

### Rules that keep collaboration painless

1. **Don't reformat text you didn't write.** Reflowing a paragraph turns a
   one-word fix into dozens of changed lines.
2. **New packages and commands go in both preambles** (`preamble-en.tex` and
   `preamble-es.tex`), never inside a section.
3. **New references go at the end of `refs.bib`.**
4. **Figure files**: in `figures/`, lowercase, no spaces or accents.

### Where things go

| To change... | Edit... |
|---|---|
| Title, authors, emails, course name | The *Document data* block in `main.tex` |
| Language (English or Spanish) | The top of `main.tex`: keep `\input{preamble-en}` or `\input{preamble-es}` |
| Show or hide co-author notes | The top of `main.tex` ([section 5](#5-notes-between-co-authors)) |
| The text | `sections/` |
| Code, simulations, data, guide papers | `resources/` ([its own guide](resources/README.md)) |

### Common tasks

**Add a section.** Create `sections/04-results.tex` starting with

```latex
% !TEX root = ../main.tex
\section{Results}
\label{sec:results}
```

and add `\input{sections/04-results}` in `main.tex`.

**Add a figure.** Put the file in `figures/` and write
`\includegraphics[width=0.7\linewidth]{energy-spectrum}` (no folder, no extension).
If a script makes the plot, keep the script next to it with the same name.

**Add code, data or a guide paper.** Put it in `resources/`, which is never
compiled into the PDF. See [resources/README.md](resources/README.md) for how to
organise it and what not to upload.

**Add a reference.** Copy the BibTeX entry (Google Scholar → *Cite* → *BibTeX*),
check it's not already in `refs.bib`, paste it at the end, and set its key to
`firstauthorYEARfirstword`, for example `hawking1975particle`. Cite it with
`\cite{hawking1975particle}`.

**Refer to something.** Label it with a prefix (`sec:`, `eq:`, `fig:`, `tab:`) and
use `\cref{fig:spectrum}`, which writes "Fig. 3" (Spanish: "figura 3").
Use `\Cref` at the start of a sentence.

**Leave a note for co-authors.** `\todo{Check this sign.}` (see [section 5](#5-notes-between-co-authors)).

**Units, derivatives, bra-kets and more** are in the [package guide](PACKAGES.md).

---

## 5. Notes between co-authors

`\todo` leaves a comment inside the document for the other authors: a question,
a reminder, something to check. It appears in the PDF as a colored box, right
where you wrote it, so everyone sees it while reading.

```latex
\todo{Check the sign of this term.}
\todo[author=Ana]{Should this paragraph go in the introduction?}
\todo[author=Luis, color=SkyBlue1!40]{Agreed, I'll move it.}
```

In the PDF, the second and third notes start with the author's name ("Ana: Should
this paragraph...") and the third one is blue instead of orange.

**Good habits**

- **Sign your notes** with `author=` so everyone knows whom to ask.
- **Pick a color** and keep it, so your notes are easy to spot. Light colors keep
  the text readable: `SkyBlue1!40`, `PaleGreen1!40`, `Plum1!40`, `LightPink1!40`
  (the default is orange, `Orange1!40`).
- **Answer a note** with another note right below it, or in the pull request.
- **Delete the note when it's resolved.** Notes are part of the text, so deleting
  one goes into your next commit like any other change.

**Other uses**

- A placeholder for a figure that isn't ready yet:
  `\missingfigure{Plot of the energy spectrum.}` draws a grey box with a warning
  sign and your text.
- A list of every open note, with page numbers: add `\listoftodos` right after
  `\maketitle` in `main.tex`. Remove it again before the final version.
- **Where notes work:** anywhere in normal text, and in captions if written as
  `\protect\todo{...}`. **Not inside equations**: the build fails. Put the note
  just before or after the equation instead.

<details>
<summary>Optional: a shortcut command for each author</summary>

Add one line per person in `main.tex`, below the line that loads todonotes:

```latex
\newcommand{\ana}[1]{\todo[author=Ana, color=SkyBlue1!40]{#1}}
\newcommand{\luis}[1]{\todo[author=Luis, color=PaleGreen1!40]{#1}}
```

Then `\ana{Should this paragraph go in the introduction?}` is enough.
</details>

**Hiding all notes.** Notes also appear in the official PDF on GitHub. To send
the document to someone without them, the project owner changes one line at the
top of `main.tex`:

```latex
\usepackage[disable]{todonotes}   % notes hidden
\usepackage{todonotes}            % notes shown
```

The notes stay in the files, so removing `disable` brings them all back.

---

## 6. Reviewing changes

Open the pull request on GitHub.

- **The marked-up PDF**: *Checks* tab → *LaTeX* → *Artifacts* → `diff-pdf`.
  Additions appear in blue, deletions struck out in red.
- **Comments on the text**: *Files changed* tab → hover over a line → click the
  blue **+**. The ± button in the comment box lets you suggest a rewrite that the
  author accepts with one click.
- **Finish**: *Review changes* → *Approve* or *Request changes*.

---

## 7. Where the PDF is

| What | Where |
|---|---|
| Your own version, while you write | `build/main.pdf` in your folder, or `Ctrl+Alt+V` in VS Code |
| The official version (`main`) | **[Read the latest PDF](../../blob/pdf/main.pdf)**, updated a couple of minutes after each merge |
| Track changes for a pull request | The pull request → *Checks* → *LaTeX* → *Artifacts* → `diff-pdf` |
| Any other branch | *Actions* tab → the run for that branch → *Artifacts* → `pdf` (a zip) |
| Finished versions (`v1.0`, ...) | *Releases*, on the right of the repository page. Empty until the owner publishes one (below) |

**How GitHub builds it.** Every upload starts a run on GitHub's servers, listed in
the [Actions](../../actions) tab. The run downloads the project into a clean
machine with TeX Live, runs `latexmk` exactly as you do, and checks that no
`\cite` or `\cref` points to nothing. A green ✓ next to the commit means it
compiled; a red ✗ means it didn't, and clicking it shows the error. For `main`,
the PDF is then copied to a branch called `pdf`, which is what the link above
opens. Locally an unknown reference only shows as `??`, so GitHub's check is the
reliable one.

**Publishing a finished version** (project owner). When a version is final, for
example the one you send to a journal, give it a name (a *tag*) and upload it:

```powershell
git switch main
git pull
git tag -a v1.0 -m "Version sent to the journal"
git push origin v1.0
```

About two minutes later it appears under *Releases* with its PDF attached, and it
stays there permanently, even as `main` keeps changing. Use `v1.1`, `v2.0` and so
on for later versions.

To get a marked-up PDF comparing the current text with an older version yourself
(for example the one tagged `v1.0`):

```powershell
.\.github\diff.ps1 v1.0        # Windows
bash .github/diff.sh v1.0      # macOS / Linux
```

---

## 8. Files in this repository

**What you edit**

| | |
|---|---|
| `main.tex` | Language, notes on/off, title and authors, the list of sections |
| `sections/` | The text, one file per section |
| `figures/` | Images, plots, and the scripts that make the plots |
| `refs.bib` | The bibliography |
| `resources/` | Code, simulations, data, guide papers and anything else that isn't in the PDF ([guide](resources/README.md)) |
| `preamble-en.tex`, `preamble-es.tex` | Formatting, packages and commands, in English and Spanish. Change both together |

**What you can ignore**

| | |
|---|---|
| `PACKAGES.md` | Guide to the packages, with examples |
| `.latexmkrc` | How the PDF is built; shared by VS Code, the terminal and GitHub |
| `.vscode/` | VS Code settings and the recommended extensions |
| `.github/` | GitHub's automatic build, the diff scripts, the pull-request checklist, maintainer notes |
| `.gitignore`, `.gitattributes` | Which files Git skips; consistent line endings across systems |
| `.devcontainer.json` | Settings for GitHub's online editor; not needed locally |
| `build/` | Created when you compile; never uploaded |

---

## 9. Problems and questions

<details>
<summary>It compiles on my computer, but GitHub shows a red ✗</summary>

Click the ✗ → *Details* to read the error. The usual causes:

- **Capital letters in file names.** Windows ignores them, GitHub doesn't:
  `\includegraphics{Spectrum}` finds `spectrum.pdf` locally but fails on GitHub.
- **An undefined `\cite` or `\cref`.** Search the log for `undefined`.
- **A package MiKTeX installed silently.** If it isn't standard, put its `.sty`
  file next to `main.tex` and commit it.
- **A font from your computer.** GitHub doesn't have it; use fonts that come with
  TeX Live.
</details>

<details>
<summary>Merge conflict</summary>

You and someone else changed the same lines. In *Source Control*, open the file
marked with a conflict → *Resolve in Merge Editor* → choose or combine the
versions → *Complete Merge* → build to check → commit and upload. If unsure, ask
the other author first.
</details>

<details>
<summary>"File 'something.sty' not found"</summary>

TeX Live: `tlmgr install something`. MiKTeX: let it install the package.
</details>

<details>
<summary>Bibliography error mentioning biber and a version</summary>

Your TeX installation is partly out of date. Update everything:
`tlmgr update --self --all` (TeX Live) or *MiKTeX Console → Updates*.
</details>

<details>
<summary>References show as [?] or ??</summary>

Save once more (the bibliography needs several passes). If it stays, the key is
misspelled or missing from `refs.bib`.
</details>

<details>
<summary>I committed to main by mistake</summary>

Before uploading: click the branch name → *Create new branch...*; your commits
move to the new branch. Then `git switch main` and `git reset --hard origin/main`.
</details>

<details>
<summary>Git asks for a password, or whole files show as changed</summary>

Password: run `gh auth login` again.
Whole files changed: `git config --global core.autocrlf false`, then
`git add --renormalize .` and commit.
</details>

<details>
<summary>Do we all need the same LaTeX installation?</summary>

No. GitHub's build is the reference. TeX Live of the current year matches it
best; an up-to-date MiKTeX works fine in practice.
</details>

<details>
<summary>Can we write at the same time, as in Overleaf?</summary>

Usually there's no need: two people can edit different parts of the same file on
separate branches, and Git combines them. For a live session, install VS Code's
*Live Share* extension: one person shares a link, everyone types in the same
files, and the host commits at the end.
</details>
