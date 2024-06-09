# Prompt the user to input a domain
$domain = Read-Host "Enter Domain:"

# Prompt the user to select an OU
$ouName = Read-Host "Enter the name or part of the name of the OU in domain:"
$selectedOU = Get-ADOrganizationalUnit -Filter {Name -like "*$ouName*"} -SearchBase "DC=$domain" | Out-GridView -PassThru -Title "Select an OU"

# Check if the user selected an OU
if ($selectedOU) {
    Write-Output "You selected OU: $($selectedOU.DistinguishedName)"

    # Prompt the user to input the security group name
    $groupName = Read-Host "Enter the name or part of the name of the security group to search for:"

    # Get all users in the selected OU
    $users = Get-ADUser -Filter * -SearchBase $selectedOU.DistinguishedName

    # Create an array to store user information
    $userArray = @()

    # Loop through each user and check if they are in the specified security group
    foreach ($user in $users) {
        $isMember = $false
        $groups = Get-ADUser $user -Properties MemberOf | Select-Object -ExpandProperty MemberOf
        foreach ($groupDN in $groups) {
            $group = Get-ADGroup -Identity $groupDN
            if ($group.Name -like "*$groupName*") {
                $isMember = $true
                break
            }
        }
        if ($isMember) {
            $userObj = New-Object PSObject -Property @{
                "User" = $user.Name
                "SamAccountName" = $user.SamAccountName
                "DistinguishedName" = $user.DistinguishedName
            }
            $userArray += $userObj
        }
    }

    # Check if there are any users in the security group
    if ($userArray) {
        # Output users to a CSV file
        $csvFilePath = "C:\Users\UserName\Desktop\Security_Group_Users.csv" # Replace with your desired output path
        $userArray | Export-Csv -Path $csvFilePath -NoTypeInformation

        Write-Output "User information from the selected security group exported to $csvFilePath"
    } else {
        Write-Output "No users found in the specified security group within the selected OU."
    }
} else {
    Write-Output "No OU selected."
}
