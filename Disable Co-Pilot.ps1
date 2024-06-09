# Define the path to the registry key
$registryPath = "HKCU:\Software\Policies\Microsoft\Windows"

# Define the name of the new key
$newKey = "WindowsCopilot"

# Define the name and value of the new DWORD
$dwordName = "TurnOffWindowsCopilot"
$dwordValue = 1

# Check if the key already exists
if (-not (Test-Path -Path "$registryPath\$newKey")) {
    # Create the new key
    New-Item -Path $registryPath -Name $newKey -Force
    Write-Output "Created registry key: $registryPath\$newKey"
} else {
    Write-Output "Registry key already exists: $registryPath\$newKey"
}

# Set the DWORD value
New-ItemProperty -Path "$registryPath\$newKey" -Name $dwordName -PropertyType DWORD -Value $dwordValue -Force
Write-Output "Created DWORD $dwordName with value $dwordValue at $registryPath\$newKey"
