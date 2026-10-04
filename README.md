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
2. [Choose how to work](#2-choose-how-to-work)
3. [Setup in the browser (Codespaces)](#3-setup-in-the-browser-codespaces)
4. [Setup on your computer](#4-setup-on-your-computer)
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
| Several people typing at once | Each person on a branch, merged by pull request (section 5). For a live session, VS Code Live Share (section 6.8) |
| Track changes | A PDF with insertions in blue and deletions in red, generated for every pull request (section 7) |
| Comments | Comments on specific lines of a pull request, plus `\todo{...}` notes in the text |
| History | Every commit, browsable on GitHub or in VS Code's *Timeline* |
| Labelled versions | Git tags such as `v1.0`, published as Releases |
| Upload a file | Put it in the folder (e.g. `figures/`) and commit it |
| Download PDF | `build/main.pdf` on your computer, or Releases / Artifacts on GitHub |
| Spell check | The LTeX+ extension (grammar and spelling, Spanish and English) |
| Share a read-only link | Ask the project owner to add you with *Read* access, or send the Release PDF |

## 2. Choose how to work

You can pick any of these. They all produce the same document and they can be
mixed within one project: one person writes locally, another reviews from the
browser.

| | What you install | Best for |
|---|---|---|
| **A. Browser (Codespaces)** | Nothing | Occasional edits, reviewing, working from a lab or library computer |
| **B. Your computer** | TeX Live, Git, VS Code (about 1 hour, once) | Anyone writing regularly. Fastest, works offline |
| **C. Your computer, inside a container** | Docker, Git, VS Code | Getting a build identical to GitHub's, bit for bit |
| **D. Another editor** | A TeX distribution with `latexmk`, Git | People attached to TeXstudio, Vim, Emacs... |

Whatever you choose, you need:

1. A free [GitHub account](https://github.com/signup).
2. An invitation to this repository. Send your GitHub username to the project
   owner, then accept the invitation that arrives by email (or at
   <https://github.com/notifications>).

## 3. Setup in the browser (Codespaces)

1. Open this repository on GitHub.
2. Click the green **Code** button → **Codespaces** tab → **Create codespace on main**.
3. Wait. The first start takes a few minutes because it installs a complete
   TeX Live. You get VS Code running in your browser, with the project open and
   every extension already installed.
4. Open any file in `sections/` and press `Ctrl+S`. The PDF builds; open it with
   `Ctrl+Alt+V`.

That's all. Now go to [section 5](#5-your-first-contribution-step-by-step).

Things to know about Codespaces:

- Your codespace stays. Next time, go to **Code** → **Codespaces** and click the
  existing one instead of creating a new one. Changes you haven't committed are
  still there.
- It stops by itself after about 30 minutes without activity. Stop it yourself
  when you finish: **Code** → **Codespaces** → `...` → *Stop codespace*.
- Free GitHub accounts include a monthly allowance of Codespaces usage (enough for
  dozens of hours on the default machine). Students can get more through
  [GitHub Education](https://education.github.com/).
- Delete codespaces you no longer use; stored codespaces also count against the
  allowance.

## 4. Setup on your computer

Instructions are for Windows, with macOS and Linux notes where they differ. Do
the steps in order. Commands go in **PowerShell** on Windows (search for
*PowerShell* in the Start menu) or **Terminal** on macOS/Linux.

### 4.1 Install TeX Live

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

### 4.2 Install Git and the GitHub command-line tool

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

### 4.3 Install VS Code

Download it from <https://code.visualstudio.com> and install it. On Windows, tick
*Add "Open with Code" action* and *Add to PATH* during installation.

### 4.4 Download the project

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
   *Install*. The important one is **LaTeX Workshop**; the others add spell
   checking (LTeX+), better Git history (GitLens) and consistent formatting
   (EditorConfig).

### 4.5 Check that everything works

In VS Code's terminal (`` Ctrl+` ``):

```powershell
.\scripts\doctor.ps1      # Windows
bash scripts/doctor.sh    # macOS / Linux
```

Every line should say `OK` (a `WARN` is information, not a problem). If Windows
refuses to run the script, allow local scripts once and try again:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Then open `sections/01-introduction.tex`, press `Ctrl+S`, and open the PDF with
`Ctrl+Alt+V`. If you see the document, the setup is complete.

### 4.6 Option C: inside a container

If you have Docker Desktop running, install the *Dev Containers* extension in
VS Code, open the project, and click *Reopen in Container* when it's offered (or
`Ctrl+Shift+P` → *Dev Containers: Reopen in Container*). You get exactly the same
environment GitHub uses, without installing TeX Live. The first start downloads
several GB.

### 4.7 Option D: another editor

Clone the repository as in 4.4 and build with `latexmk` from the repository's main
folder. It reads the build settings from `.latexmkrc`. Each file in `sections/`
starts with `% !TEX root = ../main.tex`, which TeXstudio and TeXworks understand,
so compiling from a section file compiles the whole document.

## 5. Your first contribution, step by step

This walkthrough uses VS Code's buttons, so it works the same locally and in
Codespaces. The equivalent terminal commands are in
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

### 6.2 Adding a section

Create `sections/03-results.tex` starting with these lines:

```latex
% !TEX root = ../main.tex
\section{Resultados}
\label{sec:results}
```

and add `\input{sections/03-results}` in `main.tex` where it belongs.

### 6.3 Adding a figure

Copy the file into `figures/` with a lowercase name without spaces or accents,
for example `energy-spectrum.pdf`, and use it with
`\includegraphics{energy-spectrum}` (no folder, no extension). Prefer PDF for plots
and PNG/JPG for photos. Keep files reasonably small: Git keeps every version of a
file forever, so a 40 MB image committed ten times stays 400 MB in the history.

### 6.4 Adding a reference

Get the BibTeX entry (Google Scholar → *Cite* → *BibTeX*, the journal's page, or
<https://doi2bib.org>). First search `refs.bib` (`Ctrl+F`) to make sure it isn't
already there. Then paste it at the **end** of the file and change its key to
`firstauthorYEARfirstword`, all lowercase: `hawking1975particle`.
Cite it with `\cite{hawking1975particle}`.

### 6.5 Cross-references

Label everything with a prefix (`sec:`, `eq:`, `fig:`, `tab:`) and refer with
`\cref`, which writes the word for you: `\cref{fig:spectrum}` gives "figura 3".
Use `\Cref` at the start of a sentence.

### 6.6 Notes to co-authors

`\todo{Check this sign.}` puts a note in the margin; `\todo[inline]{...}` puts it
in the text. Before submission the project owner hides them all with one change in
`preamble.tex`.

### 6.7 History

- One file: right-click it → *Open Timeline*, or the *Timeline* section at the
  bottom of the Explorer panel. Click an entry to see what changed.
- One line: GitLens shows who last changed each line and when.
- The whole project: [Commits](../../commits) on GitHub.

To get a PDF comparing the current text with any earlier version:

```powershell
.\scripts\diff.ps1 v1.0           # Windows; or a commit, or origin/main
bash scripts/diff.sh v1.0         # macOS / Linux
```

The result is `build/diff.pdf`.

### 6.8 Writing at the same time as someone else

For most work, separate branches are enough: two people can edit different parts
of the same file at the same time, and Git combines the changes when both are
merged.

When you want to write together live, as in Overleaf (for example during a
meeting), use **VS Code Live Share**: one person installs the *Live Share*
extension, clicks *Live Share* in the status bar and sends the link; the others
join from VS Code or a browser and type in the same files in real time. The host
commits at the end.

### 6.9 Keeping your branch up to date

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
4. **References go at the end of `refs.bib`**, with the key convention from 6.4.
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
| `figures/` | Images and plots |
| `refs.bib` | Bibliography entries |
| `tex/` | Special `.sty`, `.cls`, `.bst` files (e.g. a journal's class). LaTeX finds them automatically |

**Configuration**

| | |
|---|---|
| `.latexmkrc` | How the document is built (engine, bibliography, output folder). Used by VS Code, the terminal and GitHub alike |
| `.gitignore` | Files Git must never upload (build output, auxiliary files) |
| `.gitattributes` | Makes line endings identical on Windows, macOS and Linux |
| `.editorconfig` | Basic editor behaviour: UTF-8, line endings, final newline |
| `.vscode/settings.json` | Tells LaTeX Workshop to build with `.latexmkrc` and disables auto-formatting |
| `.vscode/extensions.json` | The extensions VS Code offers to install |
| `.devcontainer/` | The environment for Codespaces and option C (same as GitHub's) |
| `.github/workflows/build.yml` | The automatic build (see below) |
| `.github/pull_request_template.md` | The checklist that appears in every new pull request |
| `scripts/doctor.*` | Checks your computer's setup |
| `scripts/diff.*` | Creates a marked-up PDF comparing two versions |

**The automatic build ("CI").** Every time someone pushes, GitHub compiles the
document on a fresh machine with TeX Live and reports ✓ or ✗. It also fails if any
`\cite` or `\cref` points to nothing, since that only shows as `??` in a local PDF.
For pull requests it produces the marked-up `diff-pdf`, and when the owner tags a
version (`v1.0`) it publishes the PDF as a Release. If it builds there, the
document is correct, whatever is installed on anyone's computer.

## 10. Troubleshooting and FAQ

**Does everyone need the same LaTeX installation?**
No. GitHub's build is the reference. TeX Live of the current year matches it best,
an up-to-date MiKTeX is fine in practice, and Codespaces is identical by
construction. The doctor script tells you how close you are.

**It compiles on my computer but the check on GitHub is red.**
Click the ✗ → *Details* to read the log. The usual causes:

- *Capital letters in file names.* Windows and macOS ignore them, GitHub's Linux
  machine doesn't: `\includegraphics{Spectrum}` finds `spectrum.pdf` on your laptop
  and fails on GitHub.
- *An undefined reference or citation.* Search the log for `undefined`.
- *A package your computer installed silently* (MiKTeX does this). If it isn't a
  standard package, its `.sty` belongs in `tex/`.
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
Run `gh auth login` again (section 4.2).

**The whole file appears as changed although I edited one line.**
A line-ending problem. Run `git config --global core.autocrlf false`, then
`git add --renormalize .` and commit.

**Can I keep using Overleaf?**
Only if the project owner links the Overleaf project to this repository (an
Overleaf premium feature). Otherwise, Codespaces gives the same nothing-to-install
experience.

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
