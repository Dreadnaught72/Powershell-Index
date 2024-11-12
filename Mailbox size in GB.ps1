Get-Mailbox -ResultSize Unlimited | ForEach-Object {
    $mailbox = $_
    $stats = Get-MailboxStatistics -Identity $mailbox.Alias
    [PSCustomObject]@{
        DisplayName = $mailbox.DisplayName
        PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
        TotalItemSizeGB = [math]::Round(($stats.TotalItemSize.Value.ToBytes() / 1GB), 2) # Size in GB
        ItemCount = $stats.ItemCount
    }
} | Sort-Object -Property TotalItemSizeGB -Descending | Export-Csv -Path "C:\scripts\MailboxSizes NOV 2024.csv" -NoTypeInformation -Encoding UTF8
