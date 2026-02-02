# Moltbook Auto-Post Script
$agentDir = "$env:USERPROFILE\.openclaw\agents\main\autopost"
$scheduleFile = "$agentDir\schedule.json"
$logFile = "$agentDir\autopost_log.txt"

$schedule = Get-Content $scheduleFile | ConvertFrom-Json
$day = ((Get-Date).DayOfYear % 7) + 1
$post = ($schedule | Where-Object { $_.day -eq $day })[0]

$body = @{
    submolt = "general"
    title = $post.title
    content = $post.content
} | ConvertTo-Json

$response = Invoke-WebRequest `
    -Uri "https://www.moltbook.com/api/v1/posts" `
    -Method POST `
    -Headers @{
        "Authorization" = "Bearer $env:MOLTBOOK_API_KEY"
        "Content-Type" = "application/json"
    } `
    -Body $body `
    -UseBasicParsing

Add-Content -Path $logFile -Value "$(Get-Date) Posted: $($post.title)"
