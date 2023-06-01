# Get all devices that can wake the computer
$wakeDevices = powercfg /devicequery wake_armed

# Loop through all devices
foreach ($device in $wakeDevices) {
    # If the device is a keyboard or mouse
    if ($device -like "*keyboard*" -or $device -like "*mouse*") {
        # Disallow the device from waking the computer
        powercfg /devicedisablewake "$device"
    }
}

# Define GUIDs
$GUID_POWER_SUBGROUP_BUTTONS_LID = "4f971e89-eebd-4455-a8de-9e59040e7347"
$GUID_SETTING_LID_CLOSE_ACTION = "5ca83367-6e45-459f-a27b-476b1d01c936"
$GUID_SETTING_POWER_BUTTON_ACTION = "7648efa3-dd9c-4e3e-b566-50f929386280"
$GUID_SLEEP = "2942f679-e64d-4a61-8462-a3c78ac89b84" # Sleep

# Get the active power scheme
$activeScheme = (powercfg /GetActiveScheme) -replace ".*:\s*"

# Set the Lid close action to Sleep
powercfg /SetDCValueIndex $activeScheme $GUID_POWER_SUBGROUP_BUTTONS_LID $GUID_SETTING_LID_CLOSE_ACTION $GUID_SLEEP
powercfg /SetACValueIndex $activeScheme $GUID_POWER_SUBGROUP_BUTTONS_LID $GUID_SETTING_LID_CLOSE_ACTION $GUID_SLEEP
powercfg /SetACValueIndex $activeScheme $GUID_POWER_SUBGROUP_BUTTONS_LID $GUID_SETTING_POWER_BUTTON_ACTION $GUID_SLEEP

# Make the change effective immediately
powercfg /SetActive $activeScheme


# Define the path to the batch file
$batchFilePath = "C:\path\to\your\debugger.bat"

# Define the command to write to the file
$command = @'
@echo off
powercfg -hibernate off
start /min "" %windir%\System32\rundll32.exe powrprof.dll,SetSuspendState 0,1,0
'@

# Write the command to the file
Set-Content -Path $batchFilePath -Value $command


# Path to the registry key
$key = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\shutdown.exe"

# Create the key if it does not exist
if (-not (Test-Path -Path $key)) {
    New-Item -Path $key -Force | Out-Null
}

# Set the Debugger value
Set-ItemProperty -Path $key -Name "Debugger" -Value "C:\path\to\your\debugger.bat"

