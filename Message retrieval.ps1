# Define the specific date range
$startDate = Get-Date "2024-06-14"
$endDate = Get-Date "2024-06-17 23:59:59"

# Retrieve messages from the specified date range
$messages = Get-MessageTrackingLog -Start $startDate -End $endDate -ResultSize Unlimited

# Filter messages that failed to send (Status: 'Fail', 'Retry', 'Expired', etc.)
$failedMessages = $messages | Where-Object {
    $_.EventId -eq 'FAIL' -or $_.EventId -eq 'RETRY' -or $_.EventId -eq 'DEFER' -or $_.EventId -eq 'DELIVER'
}

# Format the results as a list
$failedMessagesList = $failedMessages | Format-List

# Export the results to a CSV file
$failedMessages | Export-Csv -Path "C:\temp\Messages.csv" -NoTypeInformation

# Output the list to the console for immediate viewing
$failedMessagesList
