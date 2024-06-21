# Get all shared mailboxes
$SharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox

# Initialize an array to store the results
$SharedMailboxPermissions = @()

# Loop through each shared mailbox to get permissions
foreach ($Mailbox in $SharedMailboxes) {
    $Permissions = Get-MailboxPermission -Identity $Mailbox.Identity | Where-Object { $_.User -notlike "NT AUTHORITY\SELF" -and $_.User -notlike "S-1-5-*" }
    $MailboxDetails = [PSCustomObject]@{
        SharedMailbox = $Mailbox.PrimarySmtpAddress
        User          = ''
        AccessRights  = ''
        Deny          = ''
        IsInherited   = ''
    }
    $SharedMailboxPermissions += $MailboxDetails
    foreach ($Permission in $Permissions) {
        $SharedMailboxPermissions += [PSCustomObject]@{
            SharedMailbox = ''
            User          = $Permission.User
            AccessRights  = $Permission.AccessRights
            Deny          = $Permission.Deny
            IsInherited   = $Permission.IsInherited
        }
    }
}

# Export the results to a CSV file
$SharedMailboxPermissions | Export-Csv -Path "C:\temp\SharedMailboxPermissions1.csv" -NoTypeInformation
