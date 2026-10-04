# Checks that this machine can build the project the same way CI does.
$ExpectedTL = 2026   # TeX Live year used by CI (texlive/texlive:latest)
$failed = $false

function Ok($m)   { Write-Host "  OK    $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  WARN  $m" -ForegroundColor Yellow }
function Fail($m) { Write-Host "  FAIL  $m" -ForegroundColor Red; $script:failed = $true }

Write-Host "Tools"
foreach ($cmd in "git", "pdflatex", "latexmk", "biber", "latexdiff") {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) { Ok "$cmd found" }
    elseif ($cmd -eq "latexdiff") { Warn "$cmd missing (only needed for diff PDFs)" }
    else { Fail "$cmd missing" }
}

Write-Host "Distribution"
if (Get-Command pdflatex -ErrorAction SilentlyContinue) {
    $v = (pdflatex --version | Select-Object -First 1)
    Write-Host "  $v"
    if ($v -match 'TeX Live (\d{4})') {
        $y = [int]$Matches[1]
        if ($y -eq $ExpectedTL)    { Ok "TeX Live $y, same year as CI" }
        elseif ($y -lt $ExpectedTL) { Warn "TeX Live $y is older than CI ($ExpectedTL): biber/biblatex errors are likely" }
        else                        { Ok "TeX Live $y (newer than CI's $ExpectedTL)" }
    }
    elseif ($v -match 'MiKTeX') {
        Warn "MiKTeX: supported, but keep it fully updated and install Perl for latexmk"
        if (-not (Get-Command perl -ErrorAction SilentlyContinue)) { Fail "perl missing (MiKTeX needs it for latexmk)" }
    }
}

Write-Host "Repository"
if ((git config core.autocrlf) -eq "true") { Warn "core.autocrlf=true; .gitattributes overrides it, but 'input' or 'false' is cleaner" }
if (Test-Path .latexmkrc) { Ok ".latexmkrc present" } else { Fail "run this from the repo root" }

Write-Host ""
if ($failed) { Write-Host "Some required tools are missing. See section 4 of the README." }
else         { Write-Host "Ready. Build with: latexmk" }
