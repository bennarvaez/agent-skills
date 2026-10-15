<#
.SYNOPSIS
  Installs the skills in this repo for Claude Code and GitHub Copilot (Windows).

.DESCRIPTION
  Links each folder in .\skills into:
    %USERPROFILE%\.agents\skills   (read by Copilot in VS Code and other agents)
    %USERPROFILE%\.claude\skills   (read by Claude Code; only if Claude Code is installed)
  Links are directory junctions, which need no admin rights, so `git pull` in
  this repo updates the installed skills. An existing real folder with the same
  name is renamed to <name>.backup-<date>, never deleted. Safe to run again:
  links and copies this script made are replaced, not backed up.

.PARAMETER Copy
  Copy the skills instead of linking (updates then need a re-run).

.PARAMETER Uninstall
  Remove the links (or copies) this script created. Backups and your personal
  standards file (~\.agents\repo-bootstrap\standards.md) are left alone.

.EXAMPLE
  .\install.ps1
  .\install.ps1 -Copy
  .\install.ps1 -Uninstall
#>
param([switch]$Copy, [switch]$Uninstall)
$ErrorActionPreference = 'Stop'

$source = Join-Path $PSScriptRoot 'skills'
$targets = @(Join-Path $HOME '.agents\skills')
if (Test-Path (Join-Path $HOME '.claude')) { $targets += Join-Path $HOME '.claude\skills' }
else { Write-Host "Claude Code not found (no ~\.claude); installing for Copilot only." }

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
foreach ($skill in Get-ChildItem $source -Directory) {
    foreach ($dir in $targets) {
        $dest = Join-Path $dir $skill.Name
        $item = Get-Item $dest -Force -ErrorAction SilentlyContinue
        $isLink = $item -and $item.LinkType
        $isOurCopy = $item -and -not $isLink -and (Test-Path (Join-Path $dest '.installed-copy'))

        if ($Uninstall) {
            if ($isLink) { $item.Delete(); Write-Host "Removed link $dest" }
            elseif ($isOurCopy) { Remove-Item $dest -Recurse -Force; Write-Host "Removed copy $dest" }
            continue
        }

        if (-not $Copy -and $isLink -and (@($item.Target)[0] -eq $skill.FullName)) {
            Write-Host "Already linked $dest"
            continue
        }

        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        try {
            if ($isLink) { $item.Delete() }
            elseif ($isOurCopy) { Remove-Item $dest -Recurse -Force }
            elseif ($item) {
                $backup = "$dest.backup-$stamp"; $n = 1
                while (Test-Path $backup) { $n++; $backup = "$dest.backup-$stamp-$n" }
                Rename-Item $dest $backup
                Write-Host "Existing folder kept as $backup"
            }
        }
        catch { throw "Couldn't replace $dest ($($_.Exception.Message)). If VS Code or Claude Code has it open, close them and run this again." }

        if ($Copy) {
            Copy-Item $skill.FullName $dest -Recurse
            New-Item (Join-Path $dest '.installed-copy') -ItemType File | Out-Null
            Write-Host "Copied $($skill.Name) -> $dest"
        } else {
            New-Item -ItemType Junction -Path $dest -Target $skill.FullName | Out-Null
            Write-Host "Linked $dest -> $($skill.FullName)"
        }
    }
}
if (-not $Uninstall) { Write-Host "`nDone. Restart VS Code / Claude Code, then type / in chat to see the skills." }
