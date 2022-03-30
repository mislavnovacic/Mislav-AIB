

#region Set logging 
$logFile = "c:\temp\" + (get-date -format 'yyyyMMdd') + '_softwareinstall.log'
function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}
#endregion

# Install 7Zip app
try {
$dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
# modified to work without IE
# above code from: https://perplexity.nl/windows-powershell/installing-or-updating-7-zip-using-powershell/
$installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
Invoke-WebRequest $dlurl -OutFile $installerPath
Copy-Item $installerPath -Destination c:\temp
Start-Process -FilePath 'C:\temp\7z2107-x64.exe' -Wait -ErrorAction Stop -ArgumentList '/S'
    if (Test-Path "C:\Program Files\7-Zip\7zFM.exe") {
        Write-Log "7Zip has been installed"
    }
    else {
        write-log "Error locating 7Zip executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing Notepad++: $ErrorMessage"
}
Remove-Item $installerPath
Remove-Item 'C:\temp\7z2107-x64.exe'
# End region