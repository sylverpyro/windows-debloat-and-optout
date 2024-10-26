
# TODO Make arg/behaviour flags argParse()

# Defualts
function setDefulats {

  # Wether or not to make a restore point before any work is done
  $script:make_restore_point=false
  $script:disableXboxServices=false

}

function makeRestorePoint {
  if ( $script:make_restore_point == true ) {
    # Make a restore point
    
    # Restore points are usually limmited to one restore point per 24 hours
    # so we have to temporairly remove that limitation
    # Remove the checkpoint interval entierly
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /V "SystemRestorePointCreationFrequency" /T REG_DWORD /D 0 /F
    
    # Now do the checkpiont
    Checkpoint-Computer -Description "pre-debloat.ps1"
    
    # Set the checkpoint interval back to default
    REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /V "SystemRestorePointCreationFrequency" /F
  }
}


function removeTrashAppxPacks {
  Write-Host "Removing Appx Apps"
  # List of pacage names ala Remove-provisionedappxPackage
  # 'Microsoft.GamingApp_', 
  $appxPackagePrefixes_remove = @(
    'Clipchamp.Clipchamp_'
    'Microsoft.BingNews_'
    'Microsoft.BingWeather_'
    'Microsoft.GetHelp_'
    'Microsoft.Getstarted_'
    'Microsoft.MicrosoftOfficeHub_'
    'Microsoft.MicrosoftSolitaireCollection_'
    'Microsoft.People_'
    'Microsoft.PowerAutomateDesktop_'
    'Microsoft.Todos_'
    'Microsoft.WindowsAlarms_'
    'microsoft.windowscommunicationsapps_'
    'Microsoft.WindowsFeedbackHub_'
    'Microsoft.WindowsMaps_'
    'Microsoft.WindowsSoundRecorder_'
    'Microsoft.Xbox.TCUI_'
    'Microsoft.XboxGamingOverlay_'
    'Microsoft.XboxGameOverlay_'
    'Microsoft.XboxSpeechToTextOverlay_'
    'Microsoft.YourPhone_'
    'Microsoft.ZuneMusic_'
    'Microsoft.ZuneVideo_'
    'MicrosoftCorporationII.MicrosoftFamily_'
    'MicrosoftCorporationII.QuickAssist_'
    'MicrosoftTeams_'
    'Microsoft.549981C3F5F10_'
  )

  # TODO List all of the allow-listed appx packages that are OK to keep

  # TODO Remove all appx packages that do not appear in the allow list
}

function removeTrashApps {

  # Default applications to remove
  $appsToRemove = @(
    "3D Viewer"
    "Feedback Hub"
    "Get Help"
    "HEIF Image Extensions"
    "HEVC Video Extensions from Device Manufacturer"
    "Mail and Calendar"
    "Microsoft Accessory Center"
    "Microsoft 365 (Office)"
    "Microsoft Sticky Notes"
    "Microsoft Teams"
    "Microsoft To Do"
    "Microsoft Family"
    "Quick Assist"
    "Microsoft Update Health Tools"
    "Microsoft Whiteboard"
    "Mixed Reality Portal"
    "Movies & TV"
    "MPEG-2 Video Extension"
    "OneNote for Windows 10"
    "Power Automate"    
    "Raw Image Extension"  
    "VP9 Video Extensions"  
    "Web Media Extensions"
    "Webp Image Extensions"
    "Windows Clock"
    "Windows Maps"  
    "Your Phone" 
  )

  # Append the xbox applications to the remove list if removing those
  if ( $script:removeXboxApps == true ) {
    $appsToRemove += @(
      "Xbox TCUI"
      "Xbox Game Bar Plugin"
      "Xbox Game Bar"
      "Xbox Game Speech Window"
      "Microsoft GameInput"
      "Gaming Services"
    )
  }

  # Remove the applications
  # Winget currently does not have a 'bulk' list option so this needs to
  # be done one at a time
  # TODO first check to see if the app is installed to save error messages
  foreach ($app in $appsToRemove) {
    winget uninstall --name "$app"
  }
}

function disableServicesHomeDevice {
  # NOTE: To get all names of all services use
  # Get-Service | Format-Table -AutoSize
  # To get a specific service by regex:
  # Get-Service -Include Diag* | Format-Table -AutoSize
  # TODO Annotate this services list to indicate what they all do
  $disableServices = @(
    # TODO make Hyper-V services switchable
    # Hyper-V services
    "vmicshutdown"
    "vmicrdv"
    "vmicvmsession"
    "vmicheartbeat"
    "vmictimesync"
    "vmickvpexchange"
    "vmicguestinterface"
    "gencounter"
    "vmgid"
    "storflt"
    "vmicvss"

    # TODO Make switchable
    # Disable network and buisness services
    "TrkWks"
    "lmhosts"
    "NetTcpPortSharing"
    "Netlogon"
    "RasMan"
    "RasAuto"
    "RemoteAccess"
    "MSiSCSI"
    "SessionEnv"
    "SmsRouter"
    "RemoteRegistry"
    "workfolderssvc"
    "TlntSvr"
    # TODO make ssh-agent switchable for FOSS/Linux admins
    "ssh-agent"

    # TODO make switchable
    # Disable Smart Card services
    "SCardSvr"
    "ScDeviceEnum"
    "scfilter"
    "SCPolicySvc"
    "applockerfltr"

    # Disable windows maps
    "MapsBroker"

    # Disable parental controls
    "WpcMonSvc"

    # Disable mobile hotspot service (hotspot hosting)
    "icssvc"

    # Disable other useless services
    "WebClient"
    "PhoneSvc"
    "TapiSrv"
    "Fax"
    "lfsvc"
    "RetailDemo"

    # TODO make switchable for users that actually use this
    # Diagnostics Telemetry, helper, and hub
    "DiagTrack"
    "diagnosticshub.standardcollector.service"
    "WMPNetworkSvc"

    # Shared account manager
    "shpamsvc"
  )

  if ( $script:disableXboxServices == true ) {
    $disableServices += @(
      "XboxNetApiSvc"
      "XboxGipSvc"
      "xboxgip"
      "xbgm"
      "XblGameSave"
    )
  }
  foreach ($service in $disableServices) {
    # Disable and stop pthe service
    Set-Service -Name $service -StartupType Disabled -Status Stopped
  }
}
function main {
  setDefulats
}

main