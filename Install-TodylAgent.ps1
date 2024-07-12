#*********************************************************************
#========================
# Install-TodylAgent.ps1
#========================
# This script will install the Todyl Agent.
# Requires the DeployKey when running the script.
#========================
# Modified: 07.11.2024
# https://github.com/dweger-scripts/Install-TodylAgent
#========================
#*********************************************************************

    #-------------------------------------------------
	# Parameters/Switches
	#-------------------------------------------------
param (
	[Parameter(Mandatory=$true)]
    [string]$DeployKey
)
    #-------------------------------------------------
	# Variables
	#-------------------------------------------------
	$ProgressPreference = 'SilentlyContinue'
	$logFolder = "C:\temp"
	$RunTimestamp = get-date -Format "MM.dd.yyy-HH_mm_ss"
	$logFileName = "TodylInstallLog-" + $RunTimestamp + ".txt"
	$logFilePath = Join-Path $logFolder $logFileName
	
	# Function to log output
function Log-Output {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Write-Host $logMessage
    Add-Content -Path $logFilePath -Value $logMessage
}

    # Download the latest installer from Todyl.
    Log-Output "Downloading installer."
    try {
        Invoke-WebRequest https://download.todyl.com/sgn_connect/SGNConnect_Latest.exe -UseBasicParsing -OutFile "$env:temp\SGNConnect_Latest.exe" -ErrorAction Stop
        Log-Output "Successfully downloaded installer."
    } catch {
        Log-Output "Failed to download installer. Error: $_"
        exit 1
    }


	# Run the installer using DeployKey submitted when running this script
    Log-Output "Installing."
    try {
        $msiArgumentList = "/i $installerPath /q VERIFY=0"
		Start-Process -FilePath "$env:temp\SGNConnect_Latest.exe" -ArgumentList "/silent /deployKey $DeployKey" -Wait -ErrorAction Stop
        Log-Output "Installation completed successfully."
    } catch {
        Log-Output "Installation failed. Error: $_"
        exit 1
    }

	# Error Checking.
	Log-Output "LastExitCode: $LASTEXITCODE"
	IF ($LASTEXITCODE -eq 0) {
		# Start SGN Client.
		try {
		cd "C:\Program Files\SGN Connect\Current"
		Start-Process .\sgnconnect.exe -ErrorAction Stop
		Log-Output "Successfully started the SGN Client."
		} catch {
			Log-Output "Failed to start SGN Client."
			exit 1
		}
	}
	# Clean up Installer.
	try {
	Remove-Item "$env:temp\SGNConnect_Latest.exe"
	Log-Output "Cleaned up (deleted) the installer."
	} catch {
		Log-Output "Failed to clean (delete) the installer."
		exit 1
	}
