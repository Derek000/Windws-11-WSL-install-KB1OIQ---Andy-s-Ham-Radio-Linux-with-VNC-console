# 03_install_wsl_usb_manager.ps1
# Downloads and installs the latest WSL USB Manager from GitHub releases.
# Run as standard user (elevation will be prompted by the installer if required).

$ErrorActionPreference = "Stop"
$Repo = "nickbeth/wsl-usb-manager"
$DownloadDir = "$env:TEMP\wsl-usb-manager"
New-Item -ItemType Directory -Force -Path $DownloadDir | Out-Null

# Get latest release asset (EXE or ZIP). We prefer the installer EXE if available.
try {
  $releases = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/$Repo/releases/latest"
  $assets = @($releases.assets)
  $asset = $assets | Where-Object { $_.name -match '\.exe$' } | Select-Object -First 1
  if (-not $asset) { $asset = $assets | Where-Object { $_.name -match '\.zip$' } | Select-Object -First 1 }
  if (-not $asset) { throw "No suitable asset found in latest release."; }
  $out = Join-Path $DownloadDir $asset.name
  Write-Host "Downloading $($asset.browser_download_url) -> $out"
  Invoke-WebRequest -UseBasicParsing -Uri $asset.browser_download_url -OutFile $out
} catch {
  Write-Error "Failed to query or download the latest release: $_"
  exit 1
}

if ($out -like "*.exe") {
  Write-Host "Launching installer..."
  Start-Process -FilePath $out -Wait
} elseif ($out -like "*.zip") {
  Write-Host "Unzipping portable version..."
  $dest = Join-Path $DownloadDir "portable"
  Expand-Archive -Path $out -DestinationPath $dest -Force
  Write-Host "Portable build extracted to $dest. Launch the EXE from there."
} else {
  Write-Error "Unexpected asset type: $out"
}
