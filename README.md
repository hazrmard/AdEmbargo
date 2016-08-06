# AdEmbargo
`AdEmbargo` is a script that modifies the system `hosts` file so that address that serve advertisements are blocked. Since this change happens at the system level, ad traffic to *any* application is blocked.  
  
## Usage
Simply start the `run.bat` file. It will ask for administrative rights before proceeding. This script makes a backup of the existing `hosts` file whenever it is run. If you have run the script previously, you'll be prompted:  
```
> Backup file found. Do you want to restore backup? [Y/N]
```
  
Entering `Y` will restore the backup file and terminate script. Entering `N` (or first-time run) will prompt:  
```
> Proceed with modifying hosts file? [Y/N]
```
Entering `N` will terminate script. Entering `Y` will:  
1. Create backup of current `hosts` file,  
2. Download new `hosts` file,  
3. Merge current and new files,  
4. Copy merged file into `C:\Windows\System32\drivers\etc\hosts`.  
  
## Hosts
The hosts downloaded are taken from an [actively curated repository](https://github.com/StevenBlack/hosts). They contain addresses of known adware and malware providers.  
Bear in mind that a large hosts file *may* incur additional processing cost. I personally did not see a noticeable difference.
  
## Compatibility
Tested on Windows 10. Should run on Win 7, 8, 8.1 as well.
