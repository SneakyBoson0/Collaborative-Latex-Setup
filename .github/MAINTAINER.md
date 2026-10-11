# Maintainer notes: using this repository as a template

This file is for whoever owns the template. Collaborators read the README.

## The template repository

The template lives at `SneakyBoson0/Collaborative-Latex-Setup`. To let GitHub
offer *Use this template*, tick **Template repository** once in *Settings* →
*General* (or run `gh repo edit SneakyBoson0/Collaborative-Latex-Setup --template`).

## Start a new project from it

```bash
gh repo create my-new-paper --private --template SneakyBoson0/Collaborative-Latex-Setup --clone
cd my-new-paper
```

or on GitHub: *Use this template* → *Create a new repository*.

Then, in the new repo:

1. Point the README at the new repository: the badge, the clone command and the
   folder name still name the template, and the title is a placeholder.

   ```powershell
   (Get-Content README.md -Raw) `
     -replace 'SneakyBoson0/Collaborative-Latex-Setup','your-user/my-new-paper' `
     -replace 'cd Collaborative-Latex-Setup','cd my-new-paper' `
     -replace 'Project title','Real title' |
     Set-Content README.md -NoNewline -Encoding utf8NoBOM
   ```

   If you skip this, the badge shows the template's build status instead of the
   project's, and collaborators clone the wrong repository.
2. Fill in the *Document data* block of `main.tex` (course, assignment, title,
   authors, emails). Delete the example sections and `figures/damped-oscillator.pdf`
   with its script, but only after the checks in *Test drive* below pass.
3. Language: at the top of `main.tex`, keep `\input{preamble-en}` or switch to
   `\input{preamble-es}`. For Spanish, also set `"ltex.language": "es"` in
   `.vscode/settings.json` so the spell checker matches. If the project will only
   ever use one language, you can delete the other preamble.

   The two preambles must stay identical except for the lines marked
   `[language]`; `git diff --no-index preamble-en.tex preamble-es.tex` shows the
   differences. Figure captions say "Fig." in both because of
   `\captionsetup[figure]{name=Fig.}`; remove that line for "Figure"/"Figura".
   For a decimal comma in Spanish, remove `es-nodecimaldot` and add
   `\sisetup{output-decimal-marker={,}}` after siunitx.
4. Engine: `$pdf_mode` in `.latexmkrc` (1 pdflatex, 4 lualatex, 5 xelatex).
   Use lualatex or xelatex only if you need `fontspec`/system-style fonts.
5. Journal class: put the `.cls`/`.bst` next to `main.tex` if it's not on CTAN, change the
   `\documentclass`. Classes such as REVTeX use BibTeX instead of biblatex: then
   remove the biblatex block, use `\bibliography{refs}` and set `$bibtex_use = 1`.
6. Delete this file if you don't want collaborators to see it.

## Test drive: checking that everything works

The example document is self-checking: each section says what it tests and what
the PDF should show. Run through this once after setting up a machine, and once
for each new project.

1. Open the repository folder in VS Code (`code .` from its top folder), accept
   the recommended extensions, and check that `pdflatex --version` mentions
   the same TeX Live year as the CI image.
2. Open `sections/01-introduction.tex`, press `Ctrl+S`, open the PDF with
   `Ctrl+Alt+V`, and read it: every check should be satisfied, with no `??` and
   no `[?]`.
3. `Ctrl+click` a formula in the PDF: the editor should jump to that line.
   `Ctrl+Alt+J` on a source line should jump back to the PDF.
4. Type a misspelled word in a section: LTeX+ should underline it after a few
   seconds (the first time it downloads its language server).
5. Push the repository: the *LaTeX* workflow should turn green, and a few minutes
   later the README's *Read the latest PDF* link should open the document. That
   link points to the `pdf` branch, which the workflow's `publish` job rewrites
   after every successful build of `main`.
6. Test the pull-request flow:

   ```powershell
   git switch -c test/diff
   # edit any sentence in sections/01-introduction.tex, save
   git commit -am "test: change a sentence"
   git push -u origin test/diff
   gh pr create --fill
   ```

   The pull request should show a green check and, under *Checks* → *LaTeX* →
   *Artifacts*, a `diff-pdf` with your change in blue and red. Close it without
   merging (`gh pr close --delete-branch`) and run `git switch main`.
7. Test releases: `git tag -a v0.0-test -m test`, `git push origin v0.0-test`.
   A Release with the PDF should appear. Delete it afterwards with
   `gh release delete v0.0-test --cleanup-tag --yes`.

## GitHub settings per project

- *Settings* → *Collaborators* → add people with **Write** access.
- *Settings* → *Branches* → *Add rule* for `main`:
  - Require a pull request before merging (1 approval if you want reviews).
  - Require status checks to pass → select **build**.
  Don't protect the `pdf` branch: the workflow overwrites it on every build of `main`.
  This keeps `main` always compilable.
- *Settings* → *Actions* → *General*: Actions enabled (default).

## Releasing a version

```bash
git tag -a v1.0 -m "Submitted to the journal"
git push origin v1.0
```

The workflow builds the PDF and attaches it to a GitHub Release named `v1.0`.
Later, `.github/diff.sh v1.0` (or `.github\diff.ps1 v1.0`) produces the changes-since-submission PDF that
referees usually ask for.

## TeX Live version policy

`texlive/texlive:latest` is the full current TeX Live, rebuilt weekly. Each spring
it jumps to the new year. Two ways to handle that:

- **Follow latest** (default): keep `latest` and update local installs yearly.
- **Freeze** a project near submission: once the next year is out, replace
  `texlive/texlive:latest` with `texlive/texlive:TL2026-historic` (adjust year) in
  `.github/workflows/build.yml` (two places) and `.devcontainer.json`.

When the CI moves to a new year, update the year mentioned in README section 2, step 4.

## Keeping old projects in sync with template improvements

Projects created from a template don't track it. To pull an improvement into an
existing project, copy the changed file(s) by hand, or:

```bash
git remote add template https://github.com/SneakyBoson0/Collaborative-Latex-Setup.git
git fetch template
git checkout template/main -- .github/workflows/build.yml .latexmkrc
```

## Overleaf bridge (optional)

Overleaf premium can sync a project with a GitHub repository. Useful when one
co-author won't leave Overleaf. Overleaf compiles with its own TeX Live version,
so keep `main.tex` as the root and check that the GitHub build stays green after
syncs.
