#!/usr/bin/env bash
# Checks that this machine can build the project the same way CI does.
EXPECTED_TL=2026   # TeX Live year used by CI (texlive/texlive:latest)

ok()   { printf '  \033[32mOK\033[0m    %s\n' "$1"; }
warn() { printf '  \033[33mWARN\033[0m  %s\n' "$1"; }
fail() { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; FAILED=1; }
FAILED=0

echo "Tools"
for cmd in git pdflatex latexmk biber latexdiff; do
  if command -v "$cmd" >/dev/null 2>&1; then ok "$cmd found"; else
    case "$cmd" in latexdiff) warn "$cmd missing (only needed for diff PDFs)";; *) fail "$cmd missing";; esac
  fi
done

echo "Distribution"
if command -v pdflatex >/dev/null 2>&1; then
  V="$(pdflatex --version | head -n1)"
  echo "  $V"
  if [[ "$V" =~ TeX\ Live\ ([0-9]{4}) ]]; then
    Y="${BASH_REMATCH[1]}"
    if   (( Y == EXPECTED_TL )); then ok "TeX Live $Y, same year as CI"
    elif (( Y <  EXPECTED_TL )); then warn "TeX Live $Y is older than CI ($EXPECTED_TL): biber/biblatex errors are likely"
    else ok "TeX Live $Y (newer than CI's $EXPECTED_TL)"; fi
    [[ "$V" == *Debian* || "$V" == *Ubuntu* ]] && warn "Linux distro packages lag behind; prefer upstream TeX Live"
  elif [[ "$V" == *MiKTeX* ]]; then
    warn "MiKTeX: supported, but keep it fully updated and install Perl for latexmk"
  fi
fi

echo "Repository"
git config core.autocrlf >/dev/null 2>&1 && [[ "$(git config core.autocrlf)" == "true" ]] \
  && warn "core.autocrlf=true; .gitattributes overrides it, but 'input' or 'false' is cleaner"
[[ -f .latexmkrc ]] && ok ".latexmkrc present" || fail "run this from the repo root"

echo
(( FAILED )) && echo "Some required tools are missing. See docs/SETUP.md." || echo "Ready. Build with: latexmk"
