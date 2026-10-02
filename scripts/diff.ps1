# Build a "track changes" PDF comparing an older revision with the current files.
#   .\scripts\diff.ps1                 # vs. previous commit
#   .\scripts\diff.ps1 v1.0            # vs. a tag
#   .\scripts\diff.ps1 origin/main
# Output: build\diff.pdf
param([string]$Rev = "HEAD~1")
$ErrorActionPreference = "Stop"

$root = git rev-parse --show-toplevel
Set-Location $root

$tmp = Join-Path ([IO.Path]::GetTempPath()) ("latexdiff-" + [guid]::NewGuid())
$old = Join-Path $tmp "old"
try {
    git worktree add --detach $old $Rev | Out-Null
    # Write without BOM so LaTeX reads it cleanly
    $out = latexdiff --flatten (Join-Path $old "main.tex") main.tex | Out-String
    [IO.File]::WriteAllText((Join-Path $root "diff.tex"), $out, (New-Object Text.UTF8Encoding $false))
    latexmk diff.tex
    Write-Host "Created build\diff.pdf (changes since $Rev)"
}
finally {
    git worktree remove --force $old 2>$null
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
