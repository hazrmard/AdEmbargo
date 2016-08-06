$hosts_web = 'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts'
$hosts_local = $env:HOMEDRIVE + '\Windows\System32\drivers\etc\hosts'
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition # script path
$hosts_backup = $scriptPath + '\hosts.backup'
$temp_buff = $scriptPath + '\temp.txt'
$out_file = $scriptPath + '\output.txt'

# taken from http://stackoverflow.com/a/31602095/4591810
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

If (Test-Path $hosts_backup) {
    $ans = Read-Host 'Backup file found. Do you want to restore backup? [Y/N]'
    If ($ans -eq 'Y') {
        Write-Host 'Restoring backup...'
        Copy-Item -Path $hosts_backup -Destination $hosts_local
    }
}
$ans = Read-Host 'Proceed with modifying hosts file? [Y/N]'
If ($ans -ne 'Y') {
    exit
}

Write-Host 'Downloading hosts list...'
Invoke-WebRequest -Uri $hosts_web -OutFile $temp_buff  # download hosts file
Write-Host 'Backing up current hosts file...'
Copy-Item -Path $hosts_local -Destination $hosts_backup

Write-Host 'Merging hosts...'
# duplicates code modified from http://www.secretgeek.net/ps_duplicates
$hash = @{}                     # Define an empty hash table
Get-Content $hosts_backup, $temp_buff |   # Send the content of the file into the pipeline...
  % {                           # For each object in the pipeline...
     if ($hash.$_ -eq $null) {
         $_                     # ... send that line further along the pipe
     };
     $hash.$_ = 1               # Add that line to the hash
  } > $out_file                 # redirect the pipe into a new file.

Copy-Item -Path $out_file -Destination $hosts_local

Write-Host 'Deleting local files...'
Remove-Item $out_file
Remove-Item $temp_buff

Write-Host 'Flushing DNS cache...'
Clear-DnsClientCache

Write-Host 'DONE'
Read-Host -Prompt "Press Enter to exit..."
exit
