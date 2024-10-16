# Blue Team - Cyber Security Team 
# Time: 09 Oct 2024
# Author: Salaheddin Darwish   
# Aim: 
# This script checks a list of email addresses which we have from our security provider against Our Entra ID and ExchangeOnline to determine if the accounts exist.
# It retrieves user information, including account status, job title, department, account creation date and user risk level based on their sign-ins. The results are saved to a CSV file.

# Set-ExecutionPolicy RemoteSigned # you need to set to be able to use MS Graph in PowerShell

# Install Microsoft Graph SDK and Exchange Online Management modules if not already installed
# Install-Module -Name Microsoft.Graph -Force
# Install-Module -Name ExchangeOnlineManagement -Force

$executionTime = Measure-Command {

    # Define the modules to check and install 
    $modules = @("Microsoft.Graph", "ExchangeOnlineManagement")

    foreach ($module in $modules) {
        # Check if the module is installed
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Write-Output "Module '$module' is not installed. Installing..."
            Install-Module -Name $module -Scope CurrentUser -Force
        } else {
            Write-Output "Module '$module' is already installed."
        }
    }

    # Connect to Microsoft Graph (Entra ID) using delegated permissions
    # Import-Module Microsoft.Graph

    Connect-MgGraph -Scopes "User.Read.All","Directory.Read.All","IdentityRiskEvent.Read.All", "IdentityRiskyUser.ReadWrite.All"
    #Select-MgProfile -Name "v1.0" -Verbose

    # Connect to ExchangeOnline
    Connect-ExchangeOnline 

   
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $account_counter = 0 

    # Path to the CSV source file with email addresses
    $inputFilePath = "C:\Path\To\Input\user_accounts.csv"

    # Path for output file
    $outputFilePath = "C:\Path\To\Output\results_$timestamp.csv"

    
    # Import the list of emails from the CSV file (ensure the first column is named "EmailAddress")
    $users = Import-Csv -Path $inputFilePath

    # Create an empty array to store results
    $results = @()

    Write-Host "User account checking has commenced ----------->>>>>>>>>!!!!!!!"

    # Loop through each email and check if the user exists in Microsoft Graph
    foreach ($user in $users) {
        
        # Get the email address from the CSV
        $email = $user.EmailAddress
     
        # Variable Initialisation 
        $mailbox   		= $null
        $graphUser 		= $null
        $riskDetections	= $null
        $accountStatus 	= $null
        $accountCreationDate = "N/A"
        $jobTitle 	= "N/A"
        $department = "N/A"
        $lastPasswordChangeTime = "N/A"
        $userPrincipalName 		= "N/A"
        $mail 		="N/A"
        $userRiskLevel  ="No Risk Level"
        # $userRiskState  ="No Risk State"


        # Try to find the mailbox of the user in ExchangeOnline
        $mailbox = Get-Mailbox -Identity $email -ErrorAction SilentlyContinue

        # Check if the mailbox exists
        if ($mailbox) {

            $account_counter++

            # Try to find the user in Microsoft Graph using the User ID (i.e. ID from Microsoft Graph)
            $graphUser = Get-MgUser -UserId $mailbox.ExternalDirectoryObjectId -Property "Id, DisplayName, UserPrincipalName, Mail, JobTitle, Department, AccountEnabled, CreatedDateTime, LastPasswordChangeDateTime" -ErrorAction SilentlyContinue

            # Get the risk detections for the user
			$riskDetections = Get-MgRiskyUser -RiskyUserId $mailbox.ExternalDirectoryObjectId -Property "riskLevel, riskState" -ErrorAction SilentlyContinue

			if ($riskDetections.riskLevel) {
				if ($riskDetections.riskLevel -ne "none") {
				$userRiskLevel = $riskDetections.riskLevel
				# $userRiskState = $riskDetections.riskState
				}
			}

            # Get UserPrincipalName in Azure

             $userPrincipalName = if ($graphUser.UserPrincipalName) {$graphUser.UserPrincipalName}
             $mail = if ($graphUser.Mail) {$graphUser.Mail}

            # Check if the account is enabled or disabled
            if ($graphUser.AccountEnabled -eq $true) {
                $accountStatus = "Active"
            } else {
                $accountStatus = "Disabled"
            }

            # Job Title
            $jobTitle = if ($graphUser.JobTitle) {$graphUser.JobTitle}

            # Department
            $department = if ($graphUser.Department) {$graphUser.Department}

            # Account Creation Time
            $accountCreationDate = $graphUser.CreatedDateTime.ToString("yyyy-MM-dd")

            #Last Time Password Changed
            $lastPasswordChangeTime  = $graphUser.LastPasswordChangeDateTime.ToString("yyyy-MM-dd")

            # Add the result to the array
            $results += [PSCustomObject]@{
                DisplayName        			= $graphUser.DisplayName
                ComboListAccount	        = $email
                UserPrincipalName			= $userPrincipalName
                EmailAddress				= $mail
                AccountStatus      			= $accountStatus
                JobTitle           			= $jobTitle
                Department         			= $department 
                CreationDateTime   			= $accountCreationDate
                LastPasswordChangeDateTime  = $lastPasswordChangeTime
                UserRiskLevel 				= $userRiskLevel
                #UserRiskState				= $userRiskState
                ObjectUserID       			= $mailbox.ExternalDirectoryObjectId
            }
        }
    }

    if ($account_counter -gt 0) {

        # Export the results to a CSV file
        $results | Export-Csv -Path $outputFilePath -NoTypeInformation
        Write-Host "User account check completed.`r`nWe found $account_counter accounts. `r`nResults saved to $outputFilePath"
        
    } else {
        Write-Host "User account check completed, No account was found!"
    }

    # Terminate Active Connection Sessions with Microsoft Graph and ExchangeOnline
    Disconnect-ExchangeOnline -Confirm:$false
    Disconnect-MgGraph
}

# Output the total time taken
Write-Output "Total execution time: $($executionTime.TotalSeconds) seconds"
