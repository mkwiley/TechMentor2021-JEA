################
###  Managing JEA Endpoints
################

# Create a JEA session configuration file with standard options
New-PSSessionConfigurationFile -Path “c:\MyJEAEndpoint.pssc”

# test configuration
Test-PSSessionConfigurationFile -Path “c:\MyJEAEndpoint.pssc”

# Create a JEA session configuration file with all options
New-PSSessionConfigurationFile -Path “c:\MyJEAEndpointFULL.pssc” –full

# Open both files and look at differences in options logged in the files
ise .\MyJEAEndpoint.pssc
ise .\MyJEAEndpointFULL.pssc

# Copy the standard options file to use as a restricted file
Copy-Item -Path "C:\MyJEAEndpoint.pssc" -Destination "C:\MyJEAEndpointRestricted.pssc"

# Open the C:\MyJEAEndpointrestricted.pssc and change the session type to Restrictedremoteserver
ise C:\MyJEAEndpointrestricted.pssc
### edit file
# --> SessionType = 'RestrictedRemoteServer’
# --> save file

# Create 2 new JEA endpoints on a machine: 
# Register a new PS session using the just created file 
Register-PSSessionConfiguration -Path “c:\MyJEAEndpoint.pssc”  -Name “JEADefault”

Register-PSSessionConfiguration -Path “C:\MyJEAEndpointRestricted.pssc”  -Name “JEARestricted”

# view configurations
Get-PSSessionConfiguration | ft name, PSSessionConfigurationTypeName

# Restart WinRM to make the configuration active
Restart-Service –name winrm -Verbose

# Show the configuration on both endpoints in different
# Connect to the default session
Enter-PSSession -ComputerName localhost -ConfigurationName ”JEADefault”

# Run get command to show all available commands
Get-Command 
Get-Command | Measure-Object

# Disconnect from the session
Exit-PSSession

# Connect to the Restricted session
Enter-PSSession -ComputerName localhost -ConfigurationName ”JEARestricted”

# Run get command to show all available commands
# Only 8 cmdlets should show up
Get-Command
Get-Command | Measure-Object

# Run a cmdlet that not available
Get-host

# Disconnect from the session
Exit-PSSession

# Re-Run a cmdlet that was not available but is in normal shell
Get-host

# cleanup
Unregister-PSSessionConfiguration -Name JEADefault
Unregister-PSSessionConfiguration -Name JEARestricted
del c:\*.pssc 
