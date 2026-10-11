# Project title

![LaTeX build](https://github.com/OWNER/REPO/actions/workflows/build.yml/badge.svg)

This repository holds the LaTeX source of *Project title*. We use it instead of
Overleaf: the text lives here, Git keeps the history, and GitHub compiles the PDF
automatically every time someone saves their work to the repository.

If you only want to **read** the document, you don't need any of this guide:

- Current draft: [Actions](../../actions) → newest run with a green ✓ →
  *Artifacts* → `pdf` (a zip containing the PDF).
- Finished versions (sent to a journal, a supervisor, etc.): [Releases](../../releases).

Everything below is for people who will **write** or **review**.

---

## Contents

1. [Coming from Overleaf](#1-coming-from-overleaf)
2. [Before you start](#2-before-you-start)
3. [Setup with VS Code](#3-setup-with-vs-code)
4. [Setup with another editor](#4-setup-with-another-editor)
5. [Your first contribution, step by step](#5-your-first-contribution-step-by-step)
6. [Everyday work](#6-everyday-work)
7. [Reviewing other people's changes](#7-reviewing-other-peoples-changes)
8. [Writing rules](#8-writing-rules)
9. [What each file is for](#9-what-each-file-is-for)
10. [Troubleshooting and FAQ](#10-troubleshooting-and-faq)
11. [Git cheat sheet](#11-git-cheat-sheet)

---

## 1. Coming from Overleaf

Almost everything you did in Overleaf has an equivalent here. The one real
difference is the way people edit at the same time: instead of typing into the
same live document, each person works on their own copy (a *branch*) and proposes
the changes (a *pull request*). Co-authors read the proposal, comment on it, and
merge it. It takes a little getting used to, and in exchange no one ever
overwrites anyone else, and every change has an author, a date and a reason.

| In Overleaf | Here |
|---|---|
| Recompile button | Save the file (`Ctrl+S`); it compiles by itself |
| PDF panel | `Ctrl+Alt+V` in VS Code |
| Double-click the PDF to jump to the source | `Ctrl+click` on the PDF |
| Jump from source to PDF | `Ctrl+Alt+J` |
| Several people typing at once | Each person on a branch, merged by pull request (section 5). For a live session, VS Code Live Share (section 6.9) |
| Track changes | A PDF with insertions in blue and deletions in red, generated for every pull request (section 7) |
| Comments | Comments on specific lines of a pull request, plus `\todo{...}` notes in the text |
| History | Every commit, browsable on GitHub or in VS Code's *Timeline* |
| Labelled versions | Git tags such as `v1.0`, published as Releases |
| Upload a file | Put it in the folder (e.g. `figures/`) and commit it |
| Download PDF | `build/main.pdf` on your computer, or Releases / Artifacts on GitHub |
| Spell check | The LTeX+ extension (grammar and spelling) |
| Share a read-only link | Ask the project owner to add you with *Read* access, or send the Release PDF |

## 2. Before you start

You need:

1. A free [GitHub account](https://github.com/signup).
2. An invitation to this repository. Send your GitHub username to the project
   owner, then accept the invitation that arrives by email (or at
   <https://github.com/notifications>).
3. An editor. This guide uses **VS Code** (section 3), which builds the PDF on
   every save and shows it next to the source. If you prefer TeXstudio, Vim,
   Emacs or another editor, see section 4. Both produce the same document, so
   collaborators can use different editors in the same project.

## 3. Setup with VS Code

This takes about an hour, once. Instructions are for Windows, with macOS and
Linux notes where they differ. Do the steps in order. Commands go in
**PowerShell** on Windows (search for *PowerShell* in the Start menu) or
**Terminal** on macOS/Linux.

### 3.1 Install TeX Live

TeX Live is the LaTeX distribution GitHub uses to build the document, so using it
locally gives the fewest surprises. It already includes everything the project
needs: `latexmk`, `biber`, `latexdiff` and its own Perl.

**Windows**

1. Download `install-tl-windows.exe` from <https://tug.org/texlive/acquire.html>.
2. Right-click it → *Run as administrator*. If Windows shows *Windows protected
   your PC*, click *More info* → *Run anyway*. This warning is normal for this
   installer.
3. Keep the defaults (full scheme, about 8 GB; *Adjust searchpath* ticked) and
   click *Install*. It takes 30–90 minutes depending on your connection.

If the installation fails with `checksums differ`, the server it chose is out of
date (common right after an update; from Colombia it often picks a Brazilian
server). Delete `C:\texlive\2026` if it exists, then run this in a PowerShell
opened as administrator:

```powershell
cd $HOME\Downloads
Invoke-WebRequest https://mirrors.mit.edu/CTAN/systems/texlive/tlnet/install-tl.zip -OutFile install-tl.zip
Expand-Archive install-tl.zip -DestinationPath install-tl
Set-Location (Get-ChildItem install-tl -Directory | Select-Object -First 1).FullName
.\install-tl-windows.bat -repository https://mirrors.mit.edu/CTAN/systems/texlive/tlnet
```

After installing that way, run once (in a normal PowerShell):
`tlmgr option repository https://mirrors.mit.edu/CTAN/systems/texlive/tlnet`.

**macOS**: install MacTeX from <https://tug.org/mactex/>. It is TeX Live with a
Mac installer.

**Linux**: install upstream TeX Live following
<https://tug.org/texlive/quickinstall.html>. The `texlive-*` packages of most
Linux distributions are one or more years old and cause bibliography errors.

**Already have MiKTeX?** You can keep it if you prefer. Open *MiKTeX Console*,
install all updates, and enable automatic installation of missing packages.
MiKTeX also needs Perl for `latexmk`: `winget install StrawberryPerl.StrawberryPerl`.
Don't have MiKTeX and TeX Live installed at the same time.

Check the installation in a **new** PowerShell window:

```powershell
latexmk --version
```

### 3.2 Install Git and the GitHub command-line tool

**Windows**

```powershell
winget install Git.Git
winget install GitHub.cli
```

**macOS**: `xcode-select --install` for Git, `brew install gh` for the GitHub tool.
**Linux**: install `git` and `gh` with your package manager.

Close and reopen the terminal, then configure Git once:

```powershell
git config --global user.name  "Your Name"
git config --global user.email "the-email-of-your-github-account"
git config --global core.autocrlf false
gh auth login
```

For `gh auth login` choose *GitHub.com* → *HTTPS* → *Login with a web browser*,
and follow the instructions. After this, Git will never ask for your password.

### 3.3 Install VS Code

Download it from <https://code.visualstudio.com> and install it. On Windows, tick
*Add "Open with Code" action* and *Add to PATH* during installation.

### 3.4 Download the project

Choose a folder for your projects (this guide uses `Documents\GitHub`) and clone
the repository into it:

```powershell
mkdir $HOME\Documents\GitHub -Force
cd $HOME\Documents\GitHub
gh repo clone OWNER/REPO
cd REPO
code .
```

When VS Code opens:

1. If it asks whether you trust the authors of the folder, click *Yes*.
2. A notification offers to install the **recommended extensions**. Click
   *Install*. There are two: **LaTeX Workshop**, which builds and shows the
   PDF, and **LTeX+**, which checks spelling and grammar.

### 3.5 Check that everything works

In VS Code's terminal (`` Ctrl+` ``):

```powershell
latexmk --version
pdflatex --version
```

Both must answer. The first line of the second one should mention
`TeX Live 2026`, the version GitHub uses to build the document. Another year or
MiKTeX also works, but if the GitHub check fails while your local build passes,
that difference is the first suspect.

Then open `sections/01-introduction.tex`, press `Ctrl+S`, and open the PDF with
`Ctrl+Alt+V`. If you see the document, the setup is complete.

## 4. Setup with another editor

Any editor works, as long as the document is built with `latexmk`.

1. Install TeX Live and Git as in sections 3.1 and 3.2.
2. Download the project:

   ```powershell
   mkdir $HOME\Documents\GitHub -Force
   cd $HOME\Documents\GitHub
   gh repo clone OWNER/REPO
   cd REPO
   ```

3. Build from the project's top folder:

   ```powershell
   latexmk
   ```

   It reads the build settings from `.latexmkrc` and writes the PDF to
   `build/main.pdf`. `latexmk -pvc` keeps rebuilding every time you save.

If your editor has its own compile button, make it run `latexmk` from the top
folder instead of calling `pdflatex` directly. Otherwise the bibliography and the
output folder won't match everyone else's. Each file in `sections/` starts with
`% !TEX root = ../main.tex`, which TeXstudio and TeXworks understand, so compiling
from a section file compiles the whole document.

The step-by-step guide in section 5 uses VS Code's buttons. With another editor,
use the terminal commands in section 11 instead, or your editor's own Git tools.

## 5. Your first contribution, step by step

This walkthrough uses VS Code's buttons. The equivalent terminal commands are in
[section 11](#11-git-cheat-sheet).

The idea: you never write directly on `main` (the official version). You make a
branch, write there, and ask for it to be merged.

**1. Start from the latest version.**
Click the branch name at the bottom-left of the window and choose `main`. Then
open the *Source Control* panel (`Ctrl+Shift+G`) → `...` → *Pull*.

**2. Create your branch.**
Click the branch name at the bottom-left → *Create new branch...* → type a name
like `ana/intro-motivation` (your name / what you're doing) → Enter.

**3. Write.**
Edit the `.tex` files as usual. Every `Ctrl+S` rebuilds the PDF. Check that it
looks right.

**4. Commit (save a snapshot).**
In *Source Control*, the files you changed are listed. Write a short message in the
box at the top describing what you did, e.g. `intro: rewrite motivation`, and click
**Commit**. If VS Code asks whether to stage all changes automatically, choose
*Always*.

A commit is a saved point in the history. Commit whenever you finish a meaningful
piece of work. Many small commits are better than one huge one.

**5. Push (upload your branch).**
Click **Publish Branch** (the first time) or **Sync Changes** (later). Your branch
is now on GitHub, and GitHub starts compiling it.

**6. Open a pull request.**
Go to the repository on GitHub. A yellow banner shows your branch with a
**Compare & pull request** button; click it. Write a title and a sentence about
what you changed, then **Create pull request**.

Within a few minutes the pull request shows:

- a check with ✓ or ✗ telling you whether the document compiles;
- under *Checks* → *LaTeX* → *Artifacts*, a `diff-pdf` with your changes marked.

**7. Respond to comments.**
Co-authors may comment or ask for changes. Make the changes on the same branch,
commit and push again; the pull request updates by itself.

**8. Merge.**
When the check is green and a co-author has approved, click **Merge pull request**.
Then, in VS Code, switch back to `main` and *Pull*. You can delete the branch.

## 6. Everyday work

### 6.1 Building

| Where | How |
|---|---|
| VS Code | Save (`Ctrl+S`). Build manually: `Ctrl+Alt+B`. Preview: `Ctrl+Alt+V` |
| Terminal | `latexmk` (build), `latexmk -pvc` (rebuild on every save), `latexmk -c` (delete auxiliary files) |

The PDF is `build/main.pdf`. The `build/` folder is never uploaded.
If the build fails, VS Code shows the errors in the *Problems* panel
(`Ctrl+Shift+M`); the full log opens with `Ctrl+Alt+L`.

### 6.2 Title, authors, course and emails

All of these are at the top of `main.tex`, in the block marked *Document data*.
The course and assignment names fill the page header. Each author has an id and a
symbol in `\author`, and the same id and symbol in `\authoremails`, which prints
the emails in the first-page footer; clicking the symbol next to a name jumps to
that email. When adding an author, add them in both places with matching id and
symbol.

### 6.3 Adding a section

Create `sections/04-results.tex` starting with these lines:

```latex
% !TEX root = ../main.tex
\section{Results}
\label{sec:results}
```

and add `\input{sections/04-results}` in `main.tex` where it belongs.

### 6.4 Adding a figure

Copy the file into `figures/` with a lowercase name without spaces or accents,
for example `energy-spectrum.pdf`, and use it with
`\includegraphics{energy-spectrum}` (no folder, no extension). Prefer PDF for plots
and PNG/JPG for photos. If a plot comes from a script, put the script in
`figures/` with the same name as the plot, so anyone can regenerate or change it
(see `figures/damped-oscillator.py`). Keep files reasonably small: Git keeps every version of a
file forever, so a 40 MB image committed ten times stays 400 MB in the history.

### 6.5 Adding a reference

Get the BibTeX entry (Google Scholar → *Cite* → *BibTeX*, the journal's page, or
<https://doi2bib.org>). First search `refs.bib` (`Ctrl+F`) to make sure it isn't
already there. Then paste it at the **end** of the file and change its key to
`firstauthorYEARfirstword`, all lowercase: `hawking1975particle`.
Cite it with `\cite{hawking1975particle}`.

### 6.6 Cross-references

Label everything with a prefix (`sec:`, `eq:`, `fig:`, `tab:`) and refer with
`\cref`, which writes the word for you: `\cref{fig:spectrum}` gives "Fig. 3" and
`\cref{eq:energy}` gives "Eq. (2)". At the start of a sentence use `\Cref`, which
writes the full word: "Figure 3".

### 6.7 Notes to co-authors

`\todo{Check this sign.}` puts a colored note box in the text (the margins are
too narrow for margin notes). Before submission the project owner hides them all with one change in
`preamble.tex`.

### 6.8 History

- One file: right-click it → *Open Timeline*, or the *Timeline* section at the
  bottom of the Explorer panel. Click an entry to see what changed.
- One line: click a line and VS Code shows, at the end of the line or in the
  status bar, who last changed it and when.
- The whole project: [Commits](../../commits) on GitHub.

Every pull request already gets a marked-up PDF of its changes (section 7). To
compare the current text with any other version yourself, for example the one
sent to a journal (`v1.0`), a commit, or `origin/main`:

```powershell
.\.github\diff.ps1 v1.0           # Windows
bash .github/diff.sh v1.0         # macOS / Linux
```

The result is `build/diff.pdf`. If Windows refuses to run the script, allow local
scripts once with `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` and try
again.

### 6.9 Writing at the same time as someone else

For most work, separate branches are enough: two people can edit different parts
of the same file at the same time, and Git combines the changes when both are
merged.

When you want to write together live, as in Overleaf (for example during a
meeting), use **VS Code Live Share**: one person installs the *Live Share*
extension, clicks *Live Share* in the status bar and sends the link; the others
join from VS Code or a browser and type in the same files in real time. The host
commits at the end.

### 6.10 Keeping your branch up to date

If `main` changed while you were working on your branch, bring those changes in:
*Source Control* → `...` → *Branch* → *Merge...* → choose `origin/main`. If both
of you edited the same sentence, see *merge conflict* in section 10.

## 7. Reviewing other people's changes

Open the pull request on GitHub.

- **Files changed** tab: the source with removed lines in red and new lines in
  green. Hover over a line and click the blue **+** to comment on that exact line.
  You can also suggest a replacement: in the comment box click the *suggestion*
  icon (±), edit the text, and the author can accept it with one click.
- **The marked-up PDF**: *Checks* → *LaTeX* → *Artifacts* → `diff-pdf`. Insertions
  are underlined in blue and deletions struck through in red, like Overleaf's track
  changes.
- **Finish** with *Review changes* → *Approve* or *Request changes*.

## 8. Writing rules

These are what make collaboration through Git painless. Please follow them.

1. **One sentence per line.** Git compares files line by line. If a paragraph is a
   single long line, any two edits to that paragraph collide. With one sentence
   per line, they only collide if two people change the same sentence. Line breaks
   inside a paragraph don't change the PDF; a blank line starts a new paragraph.
2. **Don't reformat text you didn't change.** No reflowing, re-indenting or
   auto-formatting of other people's paragraphs: it turns your one-word fix into a
   hundred changed lines and causes conflicts.
3. **Packages and macros go in `preamble.tex`**, nowhere else.
4. **References go at the end of `refs.bib`**, with the key convention from 6.5.
5. **Figures go in `figures/`**, lowercase, no spaces, no accents.
6. **Labels have a prefix** and are referenced with `\cref`.
7. **Pull before you start** and **commit and push before you stop**, so others see
   your work and you see theirs.
8. **Never upload build files or the document's PDF.** The repository is set up to
   ignore them; don't force them in.

## 9. What each file is for

You'll mostly touch the first group. The rest is configuration that makes
everyone's setup behave the same; leave it alone unless you know why you're
changing it.

**The document**

| | |
|---|---|
| `main.tex` | Skeleton: title, authors, the list of sections, bibliography |
| `preamble.tex` | All packages and custom commands |
| `sections/` | The text, one file per section |
| `figures/` | Images and plots, and the scripts that generate plots |
| `refs.bib` | Bibliography entries |

**Configuration**

| | |
|---|---|
| `.latexmkrc` | How the document is built (engine, bibliography, output folder). Used by VS Code, the terminal and GitHub alike |
| `.gitignore` | Files Git must never upload (build output, auxiliary files) |
| `.gitattributes` | Makes line endings identical on Windows, macOS and Linux |
| `.vscode/settings.json` | Tells LaTeX Workshop to build with `.latexmkrc` and disables auto-formatting |
| `.vscode/extensions.json` | The extensions VS Code offers to install |
| `.devcontainer.json` | Settings for GitHub's online editor. Not needed for working locally; ignore it |
| `.github/workflows/build.yml` | The automatic build (see below) |
| `.github/pull_request_template.md` | The checklist that appears in every new pull request |
| `.github/diff.sh`, `.github/diff.ps1` | Create a marked-up PDF comparing two versions (section 6.8) |
| `.github/MAINTAINER.md` | Notes for the project owner; collaborators can ignore it |

**The automatic build ("CI").** Every time someone pushes, GitHub compiles the
document on a fresh machine with TeX Live and reports ✓ or ✗. It also fails if any
`\cite` or `\cref` points to nothing, since that only shows as `??` in a local PDF.
For pull requests it produces the marked-up `diff-pdf`, and when the owner tags a
version (`v1.0`) it publishes the PDF as a Release. If it builds there, the
document is correct, whatever is installed on anyone's computer.

## 10. Troubleshooting and FAQ

**Does everyone need the same LaTeX installation?**
No. GitHub's build is the reference. TeX Live of the current year matches it best,
and an up-to-date MiKTeX is fine in practice. `pdflatex --version` tells you which
one you have.

**It compiles on my computer but the check on GitHub is red.**
Click the ✗ → *Details* to read the log. The usual causes:

- *Capital letters in file names.* Windows and macOS ignore them, GitHub's Linux
  machine doesn't: `\includegraphics{Spectrum}` finds `spectrum.pdf` on your laptop
  and fails on GitHub.
- *An undefined reference or citation.* Search the log for `undefined`.
- *A package your computer installed silently* (MiKTeX does this). If it isn't a
  standard package, put its `.sty` file next to `main.tex` and commit it.
- *A font installed on your computer.* It doesn't exist on GitHub. Use fonts that
  come with TeX Live.

**`File 'something.sty' not found`.**
TeX Live: `tlmgr install something`. MiKTeX: let it install the package.

**Bibliography errors mentioning `biber` and a version mismatch.**
Your `biber` and `biblatex` come from different releases. Update everything:
`tlmgr update --self --all` (TeX Live) or *MiKTeX Console → Updates*.

**The references show as `[?]` or `??`.**
Build once more (the bibliography needs several passes; `latexmk` normally handles
this). If it persists, the key is misspelled or missing from `refs.bib`.

**Merge conflict.**
It means you and someone else changed the same lines. VS Code marks the conflicting
files in *Source Control*. Open one, click *Resolve in Merge Editor*, pick the
right version of each conflicting sentence (or combine them), click *Complete
Merge*, build to check, then commit and push. If in doubt, ask the other author
before choosing.

**I committed to `main` by mistake (and haven't pushed).**
Click the branch name → *Create new branch...*: the new branch keeps your commits.
Then ask for help to reset `main`, or run
`git switch main` and `git reset --hard origin/main`.

**Git asks for a password.**
Run `gh auth login` again (section 3.2).

**The whole file appears as changed although I edited one line.**
A line-ending problem. Run `git config --global core.autocrlf false`, then
`git add --renormalize .` and commit.

**Can I keep using Overleaf?**
Only if the project owner links the Overleaf project to this repository (an
Overleaf premium feature).

**Where is the PDF?**
On your computer: `build/main.pdf`. On GitHub: Actions → newest green run →
Artifacts, or Releases for finished versions.

## 11. Git cheat sheet

The same workflow as section 5, in the terminal.

```bash
# start from the latest version
git switch main
git pull

# new branch for your work
git switch -c ana/intro-motivation

# see what you changed
git status
git diff

# save a snapshot
git add -A
git commit -m "intro: rewrite motivation"

# upload (first time for this branch, then just: git push)
git push -u origin ana/intro-motivation

# open a pull request from the terminal
gh pr create --fill

# bring the latest main into your branch
git fetch
git merge origin/main

# after your pull request is merged
git switch main
git pull
git branch -d ana/intro-motivation
```

| Command | What it does |
|---|---|
| `git status` | What changed, what's staged, which branch you're on |
| `git log --oneline` | Short history |
| `git diff` | Changes not yet committed |
| `git restore <file>` | Throw away uncommitted changes to a file |
| `git switch <branch>` | Change branch |
| `gh pr list` / `gh pr checkout <n>` | List pull requests / check one out locally to try it |
| `gh run watch` | Follow GitHub's build of your last push |
