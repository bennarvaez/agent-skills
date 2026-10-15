<#
.SYNOPSIS
  Saves an HTML page as a new version under ~\artifacts\<slug>\ and opens it.

.DESCRIPTION
  Copies the page to ~\artifacts\<slug>\index.html. The previous index.html is
  kept as index.<yyyyMMdd-HHmmss>.html, so every save is a version. If the page
  hasn't changed, no version is made. An assets\ folder next to the page is
  copied too (files are added or replaced, never deleted, so older versions
  keep their images).

.PARAMETER File
  The page to save. Write it somewhere other than ~\artifacts.

.PARAMETER Name
  The slug, which names the folder. Defaults to the file name, or to the parent
  folder's name when the file is called index.html.

.PARAMETER NoOpen
  Don't open the page in the browser (for remote or headless sessions).

.EXAMPLE
  .\save.ps1 -File $env:TEMP\q3-hiring-plan.html
  .\save.ps1 -File draft.html -Name q3-hiring-plan -NoOpen
#>
param(
    [Parameter(Mandatory)][string]$File,
    [string]$Name,
    [switch]$NoOpen
)
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $File -PathType Leaf)) { throw "No such file: $File" }
$src = (Resolve-Path $File).Path
$srcDir = Split-Path $src

if (-not $Name) {
    $Name = [IO.Path]::GetFileNameWithoutExtension($src)
    if ($Name -eq 'index') { $Name = Split-Path $srcDir -Leaf }
}
$slug = ($Name.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
if (-not $slug) { throw "Can't make a folder name from '$Name'. Pass -Name with letters or digits." }

$dir = Join-Path (Join-Path $HOME 'artifacts') $slug
$dest = Join-Path $dir 'index.html'
if ($src -eq $dest) { throw "That's the saved page itself. Write the new version somewhere else, then save it." }
New-Item -ItemType Directory -Force -Path $dir | Out-Null

if ((Test-Path $dest) -and (Get-FileHash $src).Hash -eq (Get-FileHash $dest).Hash) {
    Write-Host "Unchanged; no new version made."
} else {
    if (Test-Path $dest) {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $old = Join-Path $dir "index.$stamp.html"; $n = 1
        while (Test-Path $old) { $n++; $old = Join-Path $dir "index.$stamp-$n.html" }
        Move-Item $dest $old
        Write-Host "Previous version kept as $old"
    }
    Copy-Item $src $dest
}

$assets = Join-Path $srcDir 'assets'
if ((Test-Path $assets -PathType Container) -and ($srcDir -ne $dir)) {
    Copy-Item $assets $dir -Recurse -Force
    Write-Host "Copied assets folder."
}

$version = @(Get-ChildItem $dir -Filter 'index.*.html').Count + 1
$url = 'file:///' + ($dest -replace '\\', '/')
Write-Host "Saved $dest (version $version)"
Write-Host "Open: $url   (add ?theme=dark or ?theme=light to check a theme)"
if (-not $NoOpen) { Start-Process $dest }
