# Load XML file
[xml]$xmlData = Get-Content -Path '.\services.xml'

# Get last service date
$lastServiceDate = $xmlData.NTServices.NTService | 
                   Select-Object -ExpandProperty changed |
                   Sort-Object -Descending |
                   Select-Object -First 1

# Check if WinRM service is in the XML file
$winRMService = $xmlData.NTServices.NTService |
                Where-Object { $_.name -eq 'WinRM' }

# If WinRM service is not in the XML file, append it
if ($null -eq $winRMService) {
    # Create WinRM service node
    $winRMServiceNode = $xmlData.CreateElement('NTService')

    $winRMServiceNode.SetAttribute('clsid', '{ab6f0BJSK-23444-435D-93HN4J-AKSJOFIO30900}')
    $winRMServiceNode.SetAttribute('uid', '{j230939f-3j9f-dsnf3-sdkjo3-sdjf9i930id}')
    $winRMServiceNode.SetAttribute('changed', $lastServiceDate)
    $winRMServiceNode.SetAttribute('image', '1')
    $winRMServiceNode.SetAttribute('name', 'WinRM')
    $winRMServiceNode.SetAttribute('removePolicy', '0')
    $winRMServiceNode.SetAttribute('userContext', '0')

    # Create properties node for WinRM service
    $propertiesNode = $xmlData.CreateElement('Properties')

    $propertiesNode.SetAttribute('interact', '1')
    $propertiesNode.SetAttribute('accountName', 'LocalSystem')
    $propertiesNode.SetAttribute('timeout', '30')
    $propertiesNode.SetAttribute('serviceAction', 'START')
    $propertiesNode.SetAttribute('serviceName', 'WinRM')
    $propertiesNode.SetAttribute('startupType', 'AUTODELAYED')

    # Append properties node to WinRM service node
    $winRMServiceNode.AppendChild($propertiesNode)

    # Append WinRM service node to NTServices
    $xmlData.NTServices.AppendChild($winRMServiceNode)

    # Save the XML file
    $xmlData.Save('.\services.xml')
}

# Load XML file
[xml]$xmlData = Get-Content -Path '.\services.xml'

# Check if WinRM service is in the XML file
$winRMService = $xmlData.NTServices.NTService |
                Where-Object { $_.name -eq 'WinRM' }

# If WinRM service is in the XML file, update it
if ($null -ne $winRMService) {
    # Set attributes
    $winRMService.clsid = '{ab6f0BJSK-23444-435D-93HN4J-AKSJOFIO30900}'
    $winRMService.uid = '{j230939f-3j9f-dsnf3-sdkjo3-sdjf9i930id}'
    $winRMService.image = '1'
    $winRMService.name = 'WinRM'
    $winRMService.removePolicy = '0'
    $winRMService.userContext = '0'

    # Set properties
    $winRMService.Properties.interact = '1'
    $winRMService.Properties.accountName = 'LocalSystem'
    $winRMService.Properties.timeout = '30'
    $winRMService.Properties.serviceAction = 'START'
    $winRMService.Properties.serviceName = 'WinRM'
    $winRMService.Properties.startupType = 'AUTODELAYED'

    # Save the XML file
    $xmlData.Save('.\services.xml')
}
else {
    Write-Output "WinRM service does not exist."
}


# Import Active Directory Module
Import-Module ActiveDirectory

# Get all users
$users = Get-ADUser -Filter *

# Loop through all users
foreach ($user in $users) {
    # Generate a random password
    $password = New-Object -TypeName System.Security.SecureString
    $rand = New-Object -TypeName System.Random

    1..16 | ForEach-Object { $password.AppendChar([char]$rand.Next(33,126)) }

    # Reset user password
    try {
        Set-ADAccountPassword -Identity $user.SamAccountName -NewPassword $password -Reset -PassThru -Confirm:$false
        # Optionally, you can enforce password change at next logon
        # Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true

        Write-Output "Password has been reset for $($user.SamAccountName)"
    } catch {
        Write-Error "Failed to reset password for $($user.SamAccountName): $_"
    }
}

