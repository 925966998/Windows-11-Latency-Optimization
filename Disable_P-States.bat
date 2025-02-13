@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo Disabling Dynamic P-state for GPUs...
powershell -Command "$gpuDevices = Get-WmiObject Win32_VideoController | Where-Object { $_.PNPDeviceID -match 'PCI\\VEN_' }; foreach ($gpu in $gpuDevices) { Write-Host 'Processing GPU:' $gpu.Name; $driverKey = (Get-ItemProperty \"HKLM:\SYSTEM\CurrentControlSet\Enum\$($gpu.PNPDeviceID)\" -Name 'Driver').Driver; if ($driverKey -match '{.*}') { $regPath = \"HKLM:\SYSTEM\CurrentControlSet\Control\Class\$driverKey\"; Write-Host 'Setting registry key at:' $regPath; Set-ItemProperty -Path $regPath -Name 'DisableDynamicPstate' -Value 1 -Type DWord; Write-Host 'Dynamic P-state disabled successfully' } }"
echo.
echo Complete! Press any key to exit...
pause
