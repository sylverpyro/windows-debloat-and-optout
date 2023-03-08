# Preamble
This is the outline doc for the process.  It includes executable code snips as well as manual steps that need to be taken.  Eventually these will get converted into a comprehensive powershell script, but function first

# NOTES
- Some commands are powerShell while others are CMD shell commands.  Make sure you run the command in the correct environment or it will not work at all.

# Sources and credits
- https://dl5.oo-software.com - Shutup and OptOut 10+
- https://github.com/builtbybel/BloatyNosy/releases - BloatyNoisy
- https://github.com/Sycnex/Windows10Debloater - Various code snippits
- https://github.com/5cover/WinClean - Various code snippits

# Update the OS 
This is required to do anything as winget is hidden in the windows updates)
```win+x , A (admin terminal)
Install-Module PSWindowsUpdate 
Add-WUServiceManager -MicrosoftUpdate
Get-WindowsUpdate
Install-WindowsUpdate
```
Once all upates are installed REBOOT

# Create a system restore point!
Win menu: system restore

# Get and run BloatyNoisy
https://github.com/builtbybel/BloatyNosy/releases

# Get and run Opt out and ShutUp 11
https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe

# Reboot again!
BloatyNoisy and OOSU10 both make a lot of changes that will only take effect on the next reboot and we want a known state before we mess with more settings

# Remove optional features packages that are not already intalled
```dism /online /cleanup-image /StartComponentCleanup /ResetBase```

# Disable all ads
Windows Registry Editor Version 5.00

[HKEYCURRENTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SilentInstalledAppsEnabled"=dword:00000000

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SystemPaneSuggestionsEnabled"=dword:00000000

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowSyncProviderNotifications"=dword:00000000

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SoftLandingEnabled"=dword:00000000

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"RotatingLockScreenEnabled"=dword:00000000

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"RotatingLockScreenOverlayEnabled"=dword:00000000

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-310093Enabled"=dword:00000000

# Disable hyper-v services
cmd.exe
```sc config vmicshutdown start= disabled
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
```

# Disable network and buisness services
```sc config TrkWks start= disabled
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
```

# Disable Smart Card services
```sc config SCardSvr start= disabled
sc config ScDeviceEnum start= disabled
sc config scfilter start= disabled
sc config SCPolicySvc start= disabled
sc config applockerfltr start= disabled
```

# Disable telemetry and data collection services
```Import-Module Microsoft.PowerShell.Management
Import-Module ScheduledTasks

# Disables Windows Feedback Experience
$Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
If (Test-Path $Advertising) {
    Set-ItemProperty $Advertising Enabled -Value 0
}

# Stops Cortana from being used as part of your Windows Search Function
$Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (Test-Path $Search) {
    Set-ItemProperty $Search AllowCortana -Value 0
}

# Disables Web Search in Start Menu
$WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0
If (!(Test-Path $WebSearch)) {
    New-Item $WebSearch
}
Set-ItemProperty $WebSearch DisableWebSearch -Value 1

# Stops the Windows Feedback Experience from sending anonymous data
$Period = "HKCU:\Software\Microsoft\Siuf\Rules"
If (!(Test-Path $Period)) {
    New-Item $Period
}
Set-ItemProperty $Period PeriodInNanoSeconds -Value 0

# Prevents bloatware applications from returning and removes Start Menu suggestions
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
If (!(Test-Path $registryPath)) {
    New-Item $registryPath
}
Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1
If (!(Test-Path $registryOEM)) {
    New-Item $registryOEM
}
    Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0
    Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0
    Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0

# Preping mixed Reality Portal for removal
$Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"
If (Test-Path $Holo) {
    Set-ItemProperty $Holo  FirstRunSucceeded -Value 0

}
# Disables Wi-fi Sense
$WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
$WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
$WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
If (!(Test-Path $WifiSense1)) {
    New-Item $WifiSense1
}
Set-ItemProperty $WifiSense1  Value -Value 0
If (!(Test-Path $WifiSense2)) {
    New-Item $WifiSense2
}
Set-ItemProperty $WifiSense2  Value -Value 0
Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0

#Disables live tiles
$Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
If (!(Test-Path $Live)) {
    New-Item $Live
}
Set-ItemProperty $Live  NoTileApplicationNotification -Value 1

# Turns off Data Collection via the AllowTelemtry key by changing it to 0
$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
$DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
If (Test-Path $DataCollection1) {
    Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0
}
If (Test-Path $DataCollection2) {
    Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0
}
If (Test-Path $DataCollection3) {
    Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0
}

# Disabling Location Tracking
$SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
$LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
If (!(Test-Path $SensorState)) {
    New-Item $SensorState
}
Set-ItemProperty $SensorState SensorPermissionState -Value 0
If (!(Test-Path $LocationConfig)) {
    New-Item $LocationConfig
}
Set-ItemProperty $LocationConfig Status -Value 0

# Disables People icon on Taskbar
$People = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"
If (!(Test-Path $People)) {
    New-Item $People
}
Set-ItemProperty $People  PeopleBand -Value 0

# Disable scheduled tasks that are considered unnecessary
Write-Output "Disabling scheduled tasks"
Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask
Get-ScheduledTask  XblGameSaveTask | Disable-ScheduledTask
Get-ScheduledTask  Consolidator | Disable-ScheduledTask
Get-ScheduledTask  UsbCeip | Disable-ScheduledTask
Get-ScheduledTask  DmClient | Disable-ScheduledTask
Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask
```

# Stop and disable WAP Push Service
```Stop-Service "dmwappushservice"
Set-Service "dmwappushservice" -StartupType Disabled
```

# Disable Bitlocker
Don't run this if you encrypt your drive with bitlocker
```cmd.exe
sc config BDESVC start= disabled
```

# Disable windows maps
`sc config MapsBroker start= disabled`

# Disable parental controls
`sc config WpcMonSvc start= disabled`

# Disable mobile hotspot service (hotspot hosting)
`sc config icssvc start= disabled`

# Disable other useless services
```sc config WebClient start= disabled
sc config PhoneSvc start= disabled
sc config TapiSrv start= disabled
sc config Fax start= disabled
sc config lfsvc start= disabled
sc config RetailDemo start= disabled
```
# OPTIONAL Disabling the Diagnostics Tracking Service
If you use the diagnostic troubleshooter DO NOT run this
```PowerShell:
Stop-Service "DiagTrack"
Set-Service "DiagTrack" -StartupType Disabled

Then cmd.exe:
sc config DiagTrack start= disabled
sc config diagnosticshub.standardcollector.service start= disabled
sc config WMPNetworkSvc start= disabled
```

## OPTIONAL: Disable Shared account manager
`sc config shpamsvc start= disabled`

# Diable XBox services EXCEPT AUTH manager
If you play games through XBox Live, do NOT disable these
```sc config XboxNetApiSvc start= disabled
sc config XboxGipSvc start= disabled
sc config xboxgip start= disabled
sc config xbgm start= disabled
sc config XblGameSave start= disabled
```

# OPTIONAL disable xbox auth service
If you play any games (Minecraft) that require a microsoft account, DO NOT disable this
```sc config XblAuthManager start= disabled```

# Keep thumbnail caches between reboots
Windows Registry Editor Version 5.00
[HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache]
"Autorun"=dword:00000000
[HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache]
"Autorun"=dword:00000000

# Fully remove Cortana
```Import-Module Microsoft.PowerShell.Management
Import-Module Appx

$Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
$Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
$Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
If (!(Test-Path $Cortana1)) {
    New-Item $Cortana1
}
Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0
If (!(Test-Path $Cortana2)) {
    New-Item $Cortana2
}
Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1
Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1
If (!(Test-Path $Cortana3)) {
    New-Item $Cortana3
}
Set-ItemProperty $Cortana3 HarvestContacts -Value 0
Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
```

# Fully remove IE 11
`DISM /Online /Remove-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0`

# Remove legacy 'malicious software removal tool' (replaced by MS Defender)
**WARNING** this does not truly remove the tool, just makes it so the OS can never execute it.  It's a poor solution, but there's no way to fully remove the tool at this time.  If this doesn't sound good to you,  just leave it be. 
cmd.exe
cd /d %windir%\System32
takeown /f MRT.exe
icacls MRT.exe /grant:r "%username%":D
del /f /q MRT.exe

# Purge appx packages (NOT MS Store!)
# Based on https://github.com/Sycnex/Windows10Debloater/blob/master/Individual%20Scripts/Debloat%20Windows
```
Import-Module Appx
Import-Module DISM
$AppXApps = @(
"*Microsoft.BingNews*"
"*Microsoft.GetHelp*"
"*Microsoft.Getstarted*"
"*Microsoft.Messaging*"
"*Microsoft.Microsoft3DViewer*"
"*Microsoft.MicrosoftOfficeHub*"
"*Microsoft.MicrosoftSolitaireCollection*"
"*Microsoft.NetworkSpeedTest*"
"*Microsoft.Office.Sway*"
"*Microsoft.OneConnect*"
"*Microsoft.People*"
"*Microsoft.Print3D*"
"*Microsoft.SkypeApp*"
"*Microsoft.WindowsAlarms*"
"*Microsoft.WindowsCamera*"
"*microsoft.windowscommunicationsapps*"
"*Microsoft.WindowsFeedbackHub*"
"*Microsoft.WindowsMaps*"
"*Microsoft.WindowsSoundRecorder*"
"*Microsoft.Xbox.TCUI*"
"*Microsoft.XboxApp*"
"*Microsoft.XboxGameOverlay*"
"*Microsoft.XboxIdentityProvider*"
"*Microsoft.XboxSpeechToTextOverlay*"
"*Microsoft.ZuneMusic*"
"*Microsoft.ZuneVideo*"
"*EclipseManager*"
"*ActiproSoftwareLLC*"
"*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
"*Duolingo-LearnLanguagesforFree*"
"*PandoraMediaInc*"
"*CandyCrush*"
"*Wunderlist*"
"*Flipboard*"
"*Twitter*"
"*Facebook*"
"*Spotify*"
"*Microsoft.Advertising.Xaml_10.1712.5.0x64__8wekyb3d8bbwe*"
"*Microsoft.Advertising.Xaml_10.1712.5.0x86__8wekyb3d8bbwe*"
"*Microsoft.BingWeather*"
"*Microsoft.MicrosoftStickyNotes*"
)
foreach ($App in $AppXApps) {
Get-AppxPackage -Name $App | Remove-AppxPackage -ErrorAction SilentlyContinue
Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $App | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}
```
# Remove ALL AppxPackages
**WARNING** This will remove ALL applications from the Microsoft store that are not in the allow list!
**DO NOT RUN THIS if you have already installed applications from the MS Store! They will be removed!**
 - Credit to /u/GavinEke for a modified version of my whitelist code
```[regex]$AllowlistedApps = 'Microsoft.WindowsStore|NVIDIACorp.NVIDIAControlPanel|Microsoft.WindowsTerminal|Microsoft.Paint|Microsoft.Windows.Photos|Microsoft.Paint3D|Microsoft.WindowsCalculator|Microsoft.WindowsStore|Microsoft.Windows.Photos|CanonicalGroupLimited.UbuntuonWindows|Microsoft.XboxGameCallableUI|Microsoft.XboxGamingOverlay|Microsoft.Xbox.TCUI|Microsoft.XboxGamingOverlay|Microsoft.XboxIdentityProvider|Microsoft.MicrosoftStickyNotes|Microsoft.MSPaint*'
Get-AppxPackage -AllUsers | Where-Object {$_.Name -NotMatch $AllowlistedApps} | Remove-AppxPackage
Get-AppxPackage | Where-Object {$_.Name -NotMatch $AllowlistedApps} | Remove-AppxPackage
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -NotMatch $AllowlistedApps} | Remove-AppxProvisionedPackage -Online
```

# Remove useless scheduled tasks
```Import-Module ScheduledTasks
Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask
Get-ScheduledTask  XblGameSaveTask | Disable-ScheduledTask
Get-ScheduledTask  Consolidator | Disable-ScheduledTask
Get-ScheduledTask  UsbCeip | Disable-ScheduledTask
Get-ScheduledTask  DmClient | Disable-ScheduledTask
Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask
```

# Remove wordpad
`DISM /Online /Remove-Capability /CapabilityName:Microsoft.Windows.WordPad~~~~0.0.1.0`

# Disable apps running in background
Windows Registry Editor Version 5.00

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications]
"GlobalUserDisabled"=dword:00000001

# Remove MS Edge
## Modified version of Shadow Whisperer's Remove-Edge-Chromium script. See https://github.com/ShadowWhisperer/Remove-Edge-Chromium
```## Stop Edge Task
taskkill /im "msedge.exe" /f  >nul 2>&1

##Do not install Edge from Windows Updates (Does not appear to work anymore)
reg add HKLM\SOFTWARE\Microsoft\EdgeUpdate /t REGDWORD /v DoNotUpdateToEdgeWithChromium /d 1 /f >nul 2>&1

:: Uninstall - 32Bit
if exist "C:\Program Files (x86)\Microsoft\Edge\Application\" (
for /f "delims=" %%a in ('dir /b "C:\Program Files (x86)\Microsoft\Edge\Application\"') do (
cd /d "C:\Program Files (x86)\Microsoft\Edge\Application\%%a\Installer\"
if exist "setup.exe" (
echo - Removing Microsoft Edge
start /w setup.exe --uninstall --system-level --force-uninstall)
echo Finished
timeout /t 3 & exit
))

:: Uninstall - 64Bit
if exist "C:\Program Files\Microsoft\Edge\Application\" (
for /f "delims=" %%a in ('dir /b "C:\Program Files\Microsoft\Edge\Application\"') do (
cd /d "C:\Program Files\Microsoft\Edge\Application\%%a\Installer\"
if exist "setup.exe" (
echo - Removing Microsoft Edge
start /w setup.exe --uninstall --system-level --force-uninstall)
echo Finished
timeout /t 3 & exit
))

:: Delete Edge icon from the desktop of all users
for /f "delims=" %%a in ('dir /b "C:\Users"') do (
del /S /Q "C:\Users\%%a\Desktop\edge.lnk" >nul 2>&1
del /S /Q "C:\Users\%%a\Desktop\Microsoft Edge.lnk" >nul 2>&1
)
```

# Always show file extensions
Windows Registry Editor Version 5.00

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"HideFileExt"=dword:00000000

# Disable explorer 'help' key
**WARNING** This does not remove the help tool, just makes it so the OS can no longer execute it.  If this sounds bad to you, just don't run this
```taskkill /f /im HelpPane.exe
takeown /f %WinDir%\HelpPane.exe
icacls %WinDir%\HelpPane.exe /deny Everyone:(X)
```

# Disable Hibernation
**NOTE** You only want this if you have an SSD or NVME drive as your boot drive.  
**NOTE** If you are on a laptop you probablay DO NOT want to turn this off
```powercfg -h off```

# Disable the '- Shortcut' suffix on all shortcuts
Windows Registry Editor Version 5.00

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer]
"link"=hex:1b,00,00,00

# Disable start menu web search mixing 
Windows Registry Editor Version 5.00

[HKEYCURRENTUSER\SOFTWARE\Policies\Microsoft\Windows\Explorer]
"DisableSearchBoxSuggestions"=dword:00000001

# Disable legacy NTFS 8.3 name retention
Windows Registry Editor Version 5.00

[HKEYLOCALMACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
"NtfsDisable8dot3NameCreation"=dword:00000003

# Disable user timeline
Windows Registry Editor Version 5.00

[HKEYLOCALMACHINE\SOFTWARE\Policies\Microsoft\Windows\System]
"EnableActivityFeed"=dword:00000000

# Show checkboxes in explorer for files/folders
Windows Registry Editor Version 5.00

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"AutoCheckSelect"=dword:00000001

# Show full path in exporer title bars
Windows Registry Editor Version 5.00

[HKEYCURRENTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState]
"FullPath"=dword:00000001

# Install main application stack
```winget_install_list="brave.brave, notepad++.notepad++" 
foreach app in $winget_install_list; do print-output "Installing app: $app"; winget install --id $app
```
```
