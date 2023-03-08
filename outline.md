# Preamble
This is the outline doc for the process.  It includes executable code snips as well as manual steps that need to be taken.  Eventually these will get converted into a comprehensive powershell script, but function first

# NOTES
- Some commands are powerShell while others are CMD shell commands.  Make sure you run the command in the correct environment or it will not work at all.

# Sources and credits
- https://dl5.oo-software.com - Shutup and OptOut 10+
- https://github.com/builtbybel/BloatyNosy/releases - BloatyNoisy
- https://github.com/Sycnex/Windows10Debloater - Win10Debloater and Various code snippits
- https://github.com/5cover/WinClean - Various code snippits (don't actually recommend running it)
- https://devblogs.microsoft.com/powershell-community/how-to-update-or-add-a-registry-key-value-with-powershell/ - for powershell regedit code

# Update the OS 
This is required to do anything as winget is hidden in the windows updates)
```
win+x , A (admin terminal)
Install-Module PSWindowsUpdate 
Add-WUServiceManager -MicrosoftUpdate
Get-WindowsUpdate
Install-WindowsUpdate
```
Once all upates are installed REBOOT

# Create a system restore point!
```
Checkpoint-Computer -Description "Before debloating tools"
```

# Get and run Win10 Debloater
```
wget https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip -OutFile ~\Downloads\Win10Debloater-sycnex.zip
```

# Get and run BloatyNoisy
https://github.com/builtbybel/BloatyNosy/releases/latest

# Get and run Opt out and ShutUp 11
```
wget https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe -OutFile ~\Downloads\OOSU10.exe
```

# Reboot again!
The above applicationns make a lot of changes that will only take effect on the next reboot and we want a known state before we mess with more settings

# Make another restore point for safety
```
Checkpoint-Computer -Description "Before manual debloating tweaks"
```

# Remove optional features packages that are not already intalled
```
dism /online /cleanup-image /StartComponentCleanup /ResetBase
```

# Stop and disable WAP Push Service
```
Stop-Service "dmwappushservice"
Set-Service "dmwappushservice" -StartupType Disabled
```
# Disable various useless services for home devices
These must be run from an admin shell of cmd.exe
```
# Disable hyper-v services
sc config vmicshutdown start= disabled
sc config vmicrdv start= disabled
sc config vmicvmsession start= disabled
sc config vmicheartbeat start= disabled
sc config vmictimesync start= disabled
sc config vmickvpexchange start= disabled
sc config vmicguestinterface start= disabled
sc config gencounter start= disabled
sc config vmgid start= disabled
sc config storflt start= disabled
sc config vmicvss start= disabled


# Disable network and buisness services
sc config TrkWks start= disabled
sc config lmhosts start= disabled
sc config NetTcpPortSharing start= disabled
sc config Netlogon start= disabled
sc config RasMan start= disabled
sc config RasAuto start= disabled
sc config RemoteAccess start= disabled
sc config MSiSCSI start= disabled
sc config SessionEnv start= disabled
sc config SmsRouter start= disabled
sc config RemoteRegistry start= disabled
sc config workfolderssvc start= disabled
sc config TlntSvr start= disabled
sc config ssh-agent start= disabled

# Disable Smart Card services
sc config SCardSvr start= disabled
sc config ScDeviceEnum start= disabled
sc config scfilter start= disabled
sc config SCPolicySvc start= disabled
sc config applockerfltr start= disabled

# Disable windows maps
sc config MapsBroker start= disabled

# Disable parental controls
sc config WpcMonSvc start= disabled

# Disable mobile hotspot service (hotspot hosting)
sc config icssvc start= disabled

# Disable other useless services
sc config WebClient start= disabled
sc config PhoneSvc start= disabled
sc config TapiSrv start= disabled
sc config Fax start= disabled
sc config lfsvc start= disabled
sc config RetailDemo start= disabled
```
# OPTIONAL service disabling

## Disabling the Diagnostics Tracking Service
If you use the diagnostic troubleshooter DO NOT run these
PowerShell:
```
Stop-Service "DiagTrack"
Set-Service "DiagTrack" -StartupType Disabled
```
Then cmd.exe:
```
sc config DiagTrack start= disabled
sc config diagnosticshub.standardcollector.service start= disabled
sc config WMPNetworkSvc start= disabled
```

## Disable Shared account manager
cmd.exe
```
sc config shpamsvc start= disabled
```

## Diable XBox services EXCEPT AUTH manager
**WARNING** If you play games through XBox Live, do NOT disable these
cmd.exe
```
sc config XboxNetApiSvc start= disabled
sc config XboxGipSvc start= disabled
sc config xboxgip start= disabled
sc config xbgm start= disabled
sc config XblGameSave start= disabled
```

## Disable xbox auth service
If you play any games (Minecraft) that require a microsoft account, DO NOT disable this
cmd.exe
```
sc config XblAuthManager start= disabled
```

## Disable Bitlocker
**WARNING** Don't run this if you encrypt your drive with bitlocker
cmd.exe
```
sc config BDESVC start= disabled
```


# Fully remove IE 11
```
DISM /Online /Remove-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0
```

# Remove MS Edge
**NOTE** Not recommended, but if you really want to do it, use *ShaowWhisperer*'s script here
https://github.com/ShadowWhisperer/Remove-Edge-Chromium/archive/refs/heads/main.zip

# Remove legacy 'malicious software removal tool' (replaced by MS Defender)
**WARNING** this does not truly remove the tool, just makes it so the OS can never execute it.  It's a poor solution, but there's no way to fully remove the tool at this time.  If this doesn't sound good to you,  just leave it be. 
cmd.exe
```
cd /d %windir%\System32
takeown /f MRT.exe
icacls MRT.exe /grant:r "%username%":D
del /f /q MRT.exe
```

# Remove useless scheduled tasks
```
Import-Module ScheduledTasks
Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask
Get-ScheduledTask  XblGameSaveTask | Disable-ScheduledTask
Get-ScheduledTask  Consolidator | Disable-ScheduledTask
Get-ScheduledTask  UsbCeip | Disable-ScheduledTask
Get-ScheduledTask  DmClient | Disable-ScheduledTask
Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask
```

# Remove wordpad
```
DISM /Online /Remove-Capability /CapabilityName:Microsoft.Windows.WordPad~~~~0.0.1.0
```

# Disable apps running in background
**WARNING** This will stop all MS Store apps from running unless explicitly launched by the user.  This includes, but is not limited to, alarms and reminders.  If you use features of any application that you don't launch youself/live in the system tray, DO NOT run this.  
[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications]
"GlobalUserDisabled"=dword:00000001
```
# Set variables to indicate value and key to set
$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications'
$Name         = 'GlobalUserDisabled'
$Value        = '00000001'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force 
```

# Always show file extensions
[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"HideFileExt"=dword:00000000
```
# Set variables to indicate value and key to set
$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$Name         = 'HideFileExt'
$Value        = '00000000'
$Type         = 'DWORD'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType $Type -Force 
```

# Disable the '- Shortcut' suffix on all shortcuts
[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer]
"link"=hex:1b,00,00,00
```
# Set variables to indicate value and key to set
$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer'
$Name         = 'link'
$Value        = '1b,00,00,00'
$Type         = 'HEX'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType $Type -Force 
```

# Disable legacy NTFS 8.3 name retention
[HKEYLOCALMACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
"NtfsDisable8dot3NameCreation"=dword:00000003
```
# Set variables to indicate value and key to set
$RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem'
$Name         = 'NtfsDisable8dot3NameCreation'
$Value        = '00000003'
$Type         = 'DWORD'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType $Type -Force 
```

# Show checkboxes in explorer for files/folders
[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"AutoCheckSelect"=dword:00000001
```
# Set variables to indicate value and key to set
$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$Name         = 'AutoCheckSelect'
$Value        = '00000001'
$Type         = 'DWORD'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType $Type -Force 
```

# Show full path in exporer title bars
[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState]
"FullPath"=dword:00000001
```
# Set variables to indicate value and key to set
$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'
$Name         = 'FullPath'
$Value        = '00000001'
$Type         = 'DWORD'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType $Type -Force 
```

# Disable explorer 'help' key
**WARNING** This does not remove the help tool, just makes it so the OS can no longer execute it.  If this sounds bad to you, just don't run this
```
taskkill /f /im HelpPane.exe
takeown /f %WinDir%\HelpPane.exe
icacls %WinDir%\HelpPane.exe /deny Everyone:(X)
```

# Disable Hibernation
**NOTE** You only want this if you have an SSD or NVME drive as your boot drive.  
**NOTE** If you are on a laptop you probablay DO NOT want to turn this off
```
powercfg -h off
```

# Reboot again
To settle the system state

# Checkpint again
Now that you have a clean base to start installing on top of, good idea to make a checkpoint before moving on
```
Checkpoint-Computer -Description "Clean base"
```

# Install main application stack
```winget_install_list="brave.brave, notepad++.notepad++" 
foreach app in $winget_install_list; do print-output "Installing app: $app"; winget install --id $app
```
