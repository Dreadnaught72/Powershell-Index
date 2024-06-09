# Set the registry path
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
 
# Set the registry value
Set-ItemProperty -Path $regPath -Name SeparateProcess -Value 1
 
# Verify the change
Get-ItemProperty -Path $regPath -Name SeparateProcess