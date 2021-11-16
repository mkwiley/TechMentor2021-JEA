################
###  Role Capabilities
################
# Start PowerShell as an Administrator.
# Create a new AD groups used to map the role capability to group
New-Adgroup –name “Role1” –groupscope “Global” –server “DC”  

# Add user to the group “Role1”
Add-adgroupmember –identity role1 –members Admin1  

# Start winRM service if this is a client machine
# or start manual via services.msc
Start-service –name Winrm

# Create a JEA session configuration file with standard options
New-PSSessionConfigurationFile -Path “c:\MyJEARoleEndpoint.pssc”  

# Open the file and change the role capabilities:
###
#-->SessionType = 'RestrictedRemoteServer’
#-->RoleDefinitions = @{ 'CONTOSO\role1' = @{ RoleCapabilities = ‘role1’}}
#--> Save file  
 
# Register a new PS JEA session using the just created file 
Register-PSSessionConfiguration -Path “c:\MyJEARoleEndpoint.pssc” -Name “JEARoles” -Force   

# Restart WinRM to make the configuration active
Restart-Service –name winrm

# Create a new JEA role capability files: 
New-PSRoleCapabilityFile -Path c:\role1.psrc  

# Open the file and make changes:
# -> Don't forget to uncomment, Might need to update quotes if you copy paste
# --> Modulestoimport = ‘Activedirectory’      
# --> Visiblecmdlets =  ‘get-ad*’        

# Copy the file to the rolecapabilityfolder in the AD module directory
New-item –path “c:\windows\system32\Windowspowershell\v1.0\modules\activedirectory\Rolecapabilities” –type “Directory”
Copy-item –path ”c:\role1.psrc” –destination “c:\windows\system32\Windowspowershell\v1.0\modules\activedirectory\Rolecapabilities\role1.psrc”  

# Show the configuration is different depending on group membership
# Connect to the JEA session
# -> will fail as your not member of the AD group
Enter-PSSession -ComputerName localhost -ConfigurationName ”JEARoles”  

# Re-Connect to the JEA session
Enter-PSSession -ComputerName CLIENT -ConfigurationName ”JEARoles”  

# Run get command to show all available commands
# AD get commands should now be there
Get-Command          

# Disconnect from the session
Exit-PSSession  

# cleanup
Unregister-PSSessionConfiguration jearoles
del C:\MyJEARoleEndpoint.pssc
del C:\role1.psrc
del “c:\windows\system32\Windowspowershell\v1.0\modules\activedirectory\Rolecapabilities” -Recurse -Force
remove-ADGroup "Role1" -Server "DC"