$ExchAddins = Get-PSSnapin | ? {$_.Name -match 'Exchange'}
$ExchSess = Get-PSSession | ? {$_.Name -match 'Exchange' -and $_.State -eq 'Opened'}
if (-not ($ExchAddins -or $ExchSess))
{
	Get-PSSnapin -Registered | ? {$_.Name -match 'Exchange'} | Add-PSSnapin
}
$date = (Get-Date).AddMinutes(-5)
$smtp = "HOSTNAME"
$To = "name@example.com"
$From = "alerts@example.com"
$MailSubject = "Email failed to send"
If(Get-MessageTrackingLog -Start $date | Where {$_.EventId -eq "FAIL" -or $_.EventId -eq "DSN" -or $_.EventId -eq "DEFER"})
{
	$result = Get-MessageTrackingLog -Start $date | Where {$_.EventId -eq "FAIL" -or $_.EventId -eq "DSN"} | select -Last 1 | sort TimeStamp -desc | FL Timestamp, EventId, Source, Sender, {$_.Recipients}, {$_.RecipientStatus}, MessageSubject, TotalBytes, RecipientCount, MessageId, ClientIp, ClientHostname, OriginalClientIp, ServerIp, ServerHostname, MessageInfo, MessageLatency, MessageLatencyType, {$_.EventData}, SourceContext, ConnectorId, Reference | Out-String
	Send-MailMessage -To $To -From $From -Subject $MailSubject -SmtpServer $smtp -Body $result
}
ElseIf(Get-EventLog "Application" -After $date -Source "MsExchangeTransport" | where {$_.eventid -eq 2022})
{
	$result = Get-EventLog "Application" -After $date -Source "MsExchangeTransport" | where {$_.eventid -eq 2022} | sort TimeStamp -desc | FL | Out-String
	Send-MailMessage -To $To -From $From -Subject $MailSubject -SmtpServer $smtp -Body $result
}
Else {Write-Host "Email check passed."}