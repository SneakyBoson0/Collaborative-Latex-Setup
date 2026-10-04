# Maintainer notes: using this repository as a template

This file is for whoever owns the template. Collaborators read the README.

## Publish the template (once)

```bash
cd latex-collab-template
git init -b main
git add -A
git commit -m "LaTeX collaboration template"
gh repo create latex-collab-template --private --source . --push
```

Then on GitHub: *Settings* → *General* → tick **Template repository**.

## Start a new project from it

```bash
gh repo create my-new-paper --private --template OWNER/latex-collab-template --clone
cd my-new-paper
```

or on GitHub: *Use this template* → *Create a new repository*.

Then, in the new repo:

1. Replace `OWNER/REPO` everywhere in the README (badge and clone command) and
   the project title at the top:

   ```powershell
   (Get-Content README.md -Raw) -replace 'OWNER/REPO','your-user/my-new-paper' -replace 'Project title','Real title' |
     Set-Content README.md -NoNewline -Encoding utf8NoBOM
   ```
2. Set title and authors in `main.tex`, rename or delete the example sections.
3. Language: the last option of `babel` in `preamble.tex` is the main language.
   Change `ltex.language` in `.vscode/settings.json` to match.
4. Engine: `$pdf_mode` in `.latexmkrc` (1 pdflatex, 4 lualatex, 5 xelatex).
   Use lualatex or xelatex only if you need `fontspec`/system-style fonts.
5. Journal class: put the `.cls`/`.bst` in `tex/` if it's not on CTAN, change the
   `\documentclass`. Classes such as REVTeX use BibTeX instead of biblatex: then
   remove the biblatex block, use `\bibliography{refs}` and set `$bibtex_use = 1`.
6. Delete this file if you don't want collaborators to see it.

## GitHub settings per project

- *Settings* → *Collaborators* → add people with **Write** access.
- *Settings* → *Branches* → *Add rule* for `main`:
  - Require a pull request before merging (1 approval if you want reviews).
  - Require status checks to pass → select **build**.
  This keeps `main` always compilable.
- *Settings* → *Actions* → *General*: Actions enabled (default).

## Releasing a version

```bash
git tag -a v1.0 -m "Submitted to the journal"
git push origin v1.0
```

The workflow builds the PDF and attaches it to a GitHub Release named `v1.0`.
Later, `scripts/diff.sh v1.0` produces the changes-since-submission PDF that
referees usually ask for.

## TeX Live version policy

`texlive/texlive:latest` is the full current TeX Live, rebuilt weekly. Each spring
it jumps to the new year. Two ways to handle that:

- **Follow latest** (default): keep `latest` and update local installs yearly.
- **Freeze** a project near submission: once the next year is out, replace
  `texlive/texlive:latest` with `texlive/texlive:TL2026-historic` (adjust year) in
  `.github/workflows/build.yml` (two places) and `.devcontainer/devcontainer.json`.

When moving to a new year, change `EXPECTED_TL` in `scripts/doctor.sh` and
`scripts/doctor.ps1` too.

## Keeping old projects in sync with template improvements

Projects created from a template don't track it. To pull an improvement into an
existing project, copy the changed file(s) by hand, or:

```bash
git remote add template https://github.com/OWNER/latex-collab-template.git
git fetch template
git checkout template/main -- .github/workflows/build.yml .latexmkrc
```

## Overleaf bridge (optional)

Overleaf premium can sync a project with a GitHub repository. Useful when one
co-author won't leave Overleaf. Overleaf compiles with its own TeX Live version,
so keep `main.tex` as the root and check that the GitHub build stays green after
syncs.
