<# Created by Seth Alton 5/11/2021
    Script is used to install pre-requisites and the Teams Room System (TRS) appx package.
    Sets firewall rules (copied from script that Adam wrote using Primalscript)

    All software is installed via Intune. Grouptag in Autopilot is "autopilotconferencerooms" and is a dynamic member trigger for the Azure AD group "Autopilot Conference Room Devices"
    
    Run elevated powershell > move to the directory where this script is stored > .\TeamsRoomConfig.ps1
    
    Skype local user creation and associated registry keys have been moved to a separate script (set as an app in Intune)
    so that the user will be created before the application runs. 
    
#>

# Checks to see if Teams Rooms Systems application is running
$ProcCheck = (Get-Process -name microsoft.SkypeRoomSystem)

If (!($ProcCheck))
    {
        
    }
    else {
        exit
    }

# Check to see if user is "Skype"
If ($env:username -eq "Skype")
    {

    }
    else 
    {
        Write-host "Skype user was not detected to be logged in. Please ensure that the TRS - Skypeuser configuration has successfully installed and that user is present in local users"    
    }

#Install Dependencies

Set-Location 'C:\Program Files (x86)\Skype Room System Deployment Kit\$oem$\$1\Rigel\x64\Ship\AppPackages\SkypeRoomSystem\Dependencies\x64'
Add-AppxPackage -Path .\Microsoft.NET.Native.Framework.2.2_2.2.29512.0_x64__8wekyb3d8bbwe.appx
Add-AppxPackage -Path .\Microsoft.NET.Native.Runtime.2.2_2.2.28604.0_x64__8wekyb3d8bbwe.appx
Add-AppxPackage -Path .\Microsoft.VCLibs.120.00.Universal_12.0.30501.0_x64__8wekyb3d8bbwe.appx
Add-AppxPackage -Path .\Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.appx
Add-AppxPackage -Path .\Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.appx


# Installs TRS
Set-Location 'C:\Program Files (x86)\Skype Room System Deployment Kit\$oem$\$1\Rigel\x64\Ship\AppPackages\SkypeRoomSystem'

Add-AppxPackage -Path .\13b9a7a525c645cc84322447e7f52f24.appx


# Disables First Logon Animation
$regpath2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Policies\System"
 Set-ItemProperty $regpath2 "EnableFirstLogonAnimation" -Value "0" -type String

# Sets Firewall entries

netsh advfirewall firewall add rule name="All ICMP V4" protocol=icmpv4:any,any dir=in action=allow
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
netsh advfirewall firewall set rule group="Remote Event Log Management" new enable=Yes



# detects if TRS is running, if not, it'll launch it

$ProcCheck = (Get-Process -name microsoft.SkypeRoomSystem)

If (!($ProcCheck))
    {
        $appid = (get-startapps -name "Microsoft Teams Room").$appid
        start shell:appsfolder\$appid
    }