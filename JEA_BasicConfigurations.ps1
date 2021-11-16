##############################
### Basic Session Configurations
##############################

# If it has not started start it start-service –name Winrm
Get-service –name winrm

# Show the current Ps session configurations. Make sure you run PowerShell as administrator
Get-PSSessionConfiguration | ft name, PSSessionConfigurationTypeName

# session configuration name, but it did use Microsoft.powershell by default. 
# Let’s take a closer look at this configuration to see some of the settings and take a look at what they mean.
Get-PSSessionConfiguration -Name microsoft.powershell | Select *

# Create a new JEA endpoint on a machine: 
# Create a new PS session configuration file
New-PSSessionConfigurationFile -SessionType RestrictedRemoteServer -Path .\MyJEAEndpoint.pssc 

### 
# alternatively edit .pssc file
### 

# Register a new PS session using the just created file 
Register-PSSessionConfiguration -Path .\MyJEAEndpoint.pssc  -Name 'JEAMaintenance' -Force 

# view session configurations
Get-PSSessionConfiguration | ft name, PSSessionConfigurationTypeName

# Look at the WSMAN configuration / show some of the sub properties
Cd wsman:\localhost\plugin
dir

# go back to root
cd c:\

# Remove the endpoint again
Unregister-PSSessionConfiguration -Name 'JEAMaintenance' -Force

# view session configurations
Get-PSSessionConfiguration | ft name, PSSessionConfigurationTypeName

# cleanup / remove .pssc file
del .\MyJEAEndpoint.pssc 

#############################################################
