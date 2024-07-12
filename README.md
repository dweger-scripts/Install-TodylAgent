# Install-TodylAgent
Use this script to install the latest Todyl agent.

## Usage
Download this script then run with the -DeployKey parameter.

`.\Install-TodylAgent.ps1 -DeployKey ######################################### `

## RMM Deployment
Powershell one-liner for easy use in an RMM.

` $downloadURI = 'https://github.com/dweger-scripts/Install-TodylAgent/raw/main/Install-TodylAgent.ps1'; $script = 'C:\temp\Install-TodylAgent.ps1'; Invoke-WebRequest -URI $downloadURI -Outfile $script `
