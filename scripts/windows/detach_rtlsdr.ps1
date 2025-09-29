# detach_rtlsdr.ps1
$Log = "C:\Temp\rtlsdr_usbipd.log"
New-Item -ItemType Directory -Force -Path (Split-Path $Log) | Out-Null
$line = (usbipd list) | Where-Object { $_ -match '0bda:2838' } | Select-Object -First 1
if ($line) {
  $bus = ($line -split '\s+')[0]
  "Detaching BUSID $bus" | Tee-Object -FilePath $Log -Append
  usbipd detach --busid $bus | Tee-Object -FilePath $Log -Append
} else {
  "RTL-SDR not listed." | Tee-Object -FilePath $Log -Append
}
usbipd list | Tee-Object -FilePath $Log -Append
