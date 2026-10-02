# Local setup

What you need on your computer for option B in the [README](../README.md).
Option A (Codespaces) needs none of this.

## 1. A TeX distribution

TeX Live of the same year as the GitHub build (see `scripts/doctor.*`) is the
smoothest choice. It includes `latexmk`, `biber`, `latexdiff` and its own Perl.

**Windows**
1. Download `install-tl-windows.exe` from <https://tug.org/texlive/acquire.html>.
2. Run it as administrator. Default scheme (*full*, about 8 GB) is recommended;
   keep *Adjust searchpath* checked.
3. Open a **new** terminal and check: `latexmk --version`.

**If the installer fails with `checksums differ`**, the mirror it picked
automatically is out of sync (common right after an update; from Colombia it often
picks a Brazilian mirror). Use the zip installer with a fixed mirror instead, in an
elevated PowerShell:

```powershell
cd $HOME\Downloads
Invoke-WebRequest https://mirrors.mit.edu/CTAN/systems/texlive/tlnet/install-tl.zip -OutFile install-tl.zip
Expand-Archive install-tl.zip -DestinationPath install-tl
Set-Location (Get-ChildItem install-tl -Directory | Select-Object -First 1).FullName
.\install-tl-windows.bat -repository https://mirrors.mit.edu/CTAN/systems/texlive/tlnet
```

Afterwards, make updates use the same mirror:
`tlmgr option repository https://mirrors.mit.edu/CTAN/systems/texlive/tlnet`.

If you already have MiKTeX and prefer to keep it: open *MiKTeX Console*, apply all
updates, enable automatic package installation, and install Perl
(`winget install StrawberryPerl.StrawberryPerl`) because MiKTeX's `latexmk` needs
it. Don't keep MiKTeX and TeX Live both on the PATH.

**macOS**
Install MacTeX from <https://tug.org/mactex/> (it is TeX Live with a macOS
installer), or `brew install --cask mactex-no-gui`.

**Linux**
Prefer upstream TeX Live (<https://tug.org/texlive/quickinstall.html>) over the
distribution's packages, which are often one or more years behind. If you do use
the system packages, `texlive-full` avoids missing pieces.

**Keeping it updated** (TeX Live): `tlmgr update --self --all` every few weeks.
A new TeX Live year is a fresh install; `tlmgr` cannot upgrade across years.

## 2. Git

- Windows: `winget install Git.Git`. macOS: `xcode-select --install`.
  Linux: your package manager.
- Once per machine:

  ```bash
  git config --global user.name  "Your Name"
  git config --global user.email "you@example.com"   # same email as your GitHub account
  git config --global core.autocrlf false            # the repo handles line endings
  git config --global pull.rebase false
  ```

- Authentication: the easiest way is GitHub CLI (`winget install GitHub.cli`,
  then `gh auth login`), or sign in from VS Code when it asks.

## 3. VS Code

Install from <https://code.visualstudio.com>. When you open the repository it
offers the recommended extensions (listed in `.vscode/extensions.json`); accept.
The main one is **LaTeX Workshop**. The project settings in `.vscode/settings.json`
already point it at the repo's build configuration, so no manual setup is needed.

## 4. Check

From the repo root:

```powershell
.\scripts\doctor.ps1      # Windows
bash scripts/doctor.sh    # macOS / Linux
latexmk                   # should produce build/main.pdf
```

If PowerShell refuses to run the script, allow local scripts once:
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.
