# Whitelist of known user profiles (Administrator, default accounts, etc.)
$KnownProfiles = @("Administrator", "Public", "Default", "All Users", "Default User")

# Function to delete a folder if it exists
function Delete-IfExists {
    param (
        [string]$Path
    )
    if (Test-Path $Path) {
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Deleted: $Path"
    }
}

# Clear Recycle Bin for all users
$RecycleBinPaths = @(
    "$env:SystemDrive\$Recycle.Bin\*",
    "$env:SystemDrive\Recycler\*"
)

foreach ($RecycleBinPath in $RecycleBinPaths) {
    Write-Host "Emptying Recycle Bin: $RecycleBinPath"
    Delete-IfExists $RecycleBinPath
}

# Clear System Temp Files
$TempPaths = @(
    "$env:SystemRoot\Temp\*",
    "$env:TEMP\*",
    "$env:TMP\*",
    "$env:LOCALAPPDATA\Temp\*"
)

foreach ($TempPath in $TempPaths) {
    Write-Host "Clearing Temp Files: $TempPath"
    Delete-IfExists $TempPath
}

# Clear known browser caches (Chrome, Firefox, Edge)
$BrowserCachePaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\cache2\*",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*"
)

foreach ($BrowserCachePath in $BrowserCachePaths) {
    Write-Host "Clearing Browser Cache: $BrowserCachePath"
    Delete-IfExists $BrowserCachePath
}

# Remove Windows Update Cache Files
$WindowsUpdateCache = "$env:SystemRoot\SoftwareDistribution\Download\*"
Write-Host "Deleting Windows Update Cache: $WindowsUpdateCache"
Delete-IfExists $WindowsUpdateCache

# Remove old Windows Error Reporting files
$ErrorReportPath = "$env:SystemRoot\System32\wermgr\*"
Write-Host "Deleting Error Reporting Files: $ErrorReportPath"
Delete-IfExists $ErrorReportPath

# Run Disk Cleanup silently to free additional space
Write-Host "Running Disk Cleanup..."
Start-Process -Wait -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1"

Write-Host "System cleanup completed!"
