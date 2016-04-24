$limit = (Get-Date).AddDays(-15)
$path = "C:\scripts\ServerMonitor\Logs"

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

dir C:\scripts\ServerMonitor\logs\available.txt | Rename-Item -NewName {$_.BaseName+(Get-Date -f yyyy-MM-dd-HH-mm-ss)+$_.Extension}
dir C:\scripts\ServerMonitor\logs\down.txt | Rename-Item -NewName {$_.BaseName+(Get-Date -f yyyy-MM-dd-HH-mm-ss)+$_.Extension}

Get-Content C:\scripts\ServerMonitor\hosts.txt | foreach { if (test-connection $_ -count 1 -quiet) { write-output "$_" | out-file C:\scripts\ServerMonitor\logs\available.txt -append } else { write-output "$_" | out-file C:\scripts\ServerMonitor\logs\down.txt -append}}

