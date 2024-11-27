# Directories to clean
$GlobalDirs = @(
    "C:\temp", 
    "C:\Windows\Temp", 
    "C:\Windows\SoftwareDistribution\Download", 
    "C:\Windows\Installer", 
    "C:\Windows\Prefetch", 
    "C:\Windows\System32\winevt\Logs", 
    "C:\$Recycle.Bin"
)
$UserSpecificDirs = @(
    "Microsoft\Teams", 
    "Microsoft\Edge", 
    "Google", 
    "Mozilla\Firefox", 
    "Microsoft\Windows\INetCache"
)

# Log file path
$LogFilePath = "C:\cleanup-log.txt"

# Function to clean a directory
function Clean-Directory {
    param (
        [string]$Path
    )
    try {
        # Ensure directory exists
        if (Test-Path $Path) {
            Write-Host "Cleaning $Path..."
            # Remove files and subdirectories
            Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                try {
                    # Attempt to remove the item
                    Remove-Item -Path $_.FullName -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
                    
                    # Log the deleted item
                    Add-Content -Path $LogFilePath -Value "Deleted: $($_.FullName)"
                    
                } catch {
                    Write-Warning "Skipping $_.FullName (in use or permission issue)"
                    # Optionally log skipped files
                    Add-Content -Path $LogFilePath -Value "Failed to delete: $($_.FullName) - $($_.Exception.Message)"
                }
            }
        } else {
            Write-Warning "Path not found: $Path"
        }
    } catch {
        Write-Warning "Error accessing ${Path}: $($_.Exception.Message)"
    }
}

# Clean global directories
foreach ($Dir in $GlobalDirs) {
    Clean-Directory -Path $Dir
}

# Clean user-specific AppData directories
$Users = Get-ChildItem -Path "C:\Users" -Directory
foreach ($User in $Users) {
    foreach ($SubDir in $UserSpecificDirs) {
        $UserDir = Join-Path -Path $User.FullName -ChildPath "AppData\Local\$SubDir"
        Clean-Directory -Path $UserDir
    }
}

Write-Host "✅ Cleanup completed. Check C:\cleanup-log.txt for deleted items."
