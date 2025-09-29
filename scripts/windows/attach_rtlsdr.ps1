# attach_rtlsdr.ps1
$Log = "C:\Temp\rtlsdr_usbipd.log"
New-Item -ItemType Directory -Force -Path (Split-Path $Log) | Out-Null
"[$(Get-Date -Format s)] START attach_rtlsdr" | Tee-Object -FilePath $Log -Append | Out-Null

$line = (usbipd list) | Where-Object { $_ -match '0bda:2838' } | Select-Object -First 1
if (-not $line) { "No RTL-SDR (0bda:2838) found." | Tee-Object -FilePath $Log -Append; exit 1 }
$bus = ($line -split '\s+')[0]

"Binding BUSID $bus (force)" | Tee-Object -FilePath $Log -Append
Start-Process -Verb RunAs powershell -ArgumentList "-NoProfile -Command usbipd bind --busid $bus --force" -Wait

"Attaching $bus to default WSL" | Tee-Object -FilePath $Log -Append
usbipd attach --wsl --busid $bus | Tee-Object -FilePath $Log -Append

usbipd list | Tee-Object -FilePath $Log -Append
"[$(Get-Date -Format s)] DONE attach_rtlsdr" | Tee-Object -FilePath $Log -Append
