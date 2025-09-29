# register_vnc_autostart.ps1
param(
  [string]$DistroName = "Ubuntu",
  [string]$TaskName = "WSL-VNC-Startup"
)

$TaskXmlPath = Join-Path $PSScriptRoot "vnc_autostart_task.xml"

# Replace placeholder distro name in XML
$xml = Get-Content -Raw -Path $TaskXmlPath
$xml = $xml -replace "__WSL_DISTRO__", [Regex]::Escape($DistroName)
$tmp = Join-Path $env:TEMP "vnc_task.xml"
$xml | Set-Content -Path $tmp -Encoding UTF8

# Register the task
schtasks /Create /TN $TaskName /XML $tmp /F

Write-Host "Registered Task Scheduler job '$TaskName'. It will run at user logon."
