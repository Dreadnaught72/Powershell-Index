# Get all distribution groups
$distributionGroups = Get-DistributionGroup

# Initialize an empty array to hold the results
$results = @()

# Loop through each distribution group
foreach ($group in $distributionGroups) {
    # Add the distribution group name to the results
    $results += [PSCustomObject]@{
        DistributionGroupName = $group.DisplayName
        MemberName = ""
        MemberEmail = ""
    }

    # Get the members of the current distribution group
    $members = Get-DistributionGroupMember -Identity $group.Identity

    # Loop through each member and add to results
    foreach ($member in $members) {
        $results += [PSCustomObject]@{
            DistributionGroupName = ""
            MemberName = $member.DisplayName
            MemberEmail = $member.PrimarySmtpAddress
        }
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\temp\distribution_groups_and_members1.csv" -NoTypeInformation
