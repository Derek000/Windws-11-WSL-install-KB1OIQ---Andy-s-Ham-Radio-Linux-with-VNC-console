# attach_rtlsdr_distro.ps1
param([Parameter(Mandatory=$true)][string]$DistroName)
$Log = "C:\Temp\rtlsdr_usbipd.log"
New-Item -ItemType Directory -Force -Path (Split-Path $Log) | Out-Null
"[$(Get-Date -Format s)] START attach_rtlsdr_distro -> $DistroName" | Tee-Object -FilePath $Log -Append | Out-Null

$line = (usbipd list) | Where-Object { $_ -match '0bda:2838' } | Select-Object -First 1
if (-not $line) { "No RTL-SDR (0bda:2838) found." | Tee-Object -FilePath $Log -Append; exit 1 }
$bus = ($line -split '\s+')[0]

Start-Process -Verb RunAs powershell -ArgumentList "-NoProfile -Command usbipd bind --busid $bus --force" -Wait

try {
  usbipd attach --wsl $DistroName --busid $bus | Tee-Object -FilePath $Log -Append
} catch {
  usbipd attach --wsl --busid $bus --distribution $DistroName | Tee-Object -FilePath $Log -Append
}

usbipd list | Tee-Object -FilePath $Log -Append
"[$(Get-Date -Format s)] DONE attach_rtlsdr_distro" | Tee-Object -FilePath $Log -Append
