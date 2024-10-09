# Blue Team - Cyber Security Team 
# Time: 07 Oct 2024
# Author: Salaheddin Darwish   
# Aim: 
# This script checks a list of email addresses against Azure AD (Entra ID) and Exchange Online to determine if the accounts exist. 
# It retrieves user information, including account status, job title, department, and creation date. The results are saved to a CSV file.

# Install AzureAD and Exchange Online Management modules if not already installed
# Install-Module -Name ExchangeOnlineManagement -Force
# Install-Module -Name AzureAD


# Define the modules to check and install 
$modules = @("ExchangeOnlineManagement", "AzureAD")

foreach ($module in $modules) {
        # Check if the module is installed
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Write-Output "Module '$module' is not installed. Installing..."
            Install-Module -Name $module -Scope CurrentUser -Force
        } else {
            Write-Output "Module '$module' is already installed."
        }
}

# Connect to Azure AD (Entra ID)
  Connect-AzureAD 

# Connect to ExchangeOnline
  Connect-ExchangeOnline 

$executionTime = Measure-Command {

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $account_counter = 0 

    # Path to the CSV source file with email addresses
    $inputFilePath = "C:\localpath\user_accounts.csv"

    # Path for output file
    $outputFilePath = "C:\localpath\results_$timestamp.csv"

    # Import the list of emails from the CSV file (ensure the column is named "EmailAddress")
    $users = Import-Csv -Path $inputFilePath

    # Create an empty array to store results
    $results = @()

    Write-Host "User account checking has commenced ----------->>>>>>>>>!!!!!!!"

    # Loop through each email and check if the user exists in Azure AD
    foreach ($user in $users) {
        
        # Get the email address from the CSV
        $email = $user.EmailAddress
     
        # Variable Initialisation 
        $mailbox   = $null
        $azureUser = $null
        $accountStatus = $null
        $accountCreationDate = "N/A"
        $jobTitle = "N/A"
        $department = "N/A"

        # Try to find the mailbox of the user in ExchangeOnline
        $mailbox = Get-Mailbox -Identity $email -ErrorAction SilentlyContinue

        # Check if the mailbox exists
        if ($mailbox) {

            $account_counter++

            # Try to find the user in Azure AD using the User ID
            $azureUser =  Get-AzureADUser -ObjectId $mailbox.ExternalDirectoryObjectId -ErrorAction SilentlyContinue

            # Check if the account is enabled or disabled
            if ($azureUser.AccountEnabled -eq $true) {
                $accountStatus = "Active"
            } else {
                $accountStatus = "Disabled"
            }

            # Job Title
            $jobTitle = if ($azureUser.JobTitle) {$azureUser.JobTitle}

            # Department
            $department = if ($azureUser.Department) {$azureUser.Department}

            # Account Creation Time
            $accountCreationDate = (Get-AzureADUserExtension -ObjectId $mailbox.ExternalDirectoryObjectId).Get_Item("createdDateTime")

            # Add the result to the array
            $results += [PSCustomObject]@{
                DisplayName        = $azureUser.DisplayName
                EmailAddress       = $email
                AccountStatus      = $accountStatus
                jobTitle           = $jobTitle
                Department         = $department 
                CreationDateTime   = $accountCreationDate
                ObjectUserID       = $mailbox.ExternalDirectoryObjectId
            }
        }
    }

    if ($account_counter -gt 0) {

        # Export the results to a CSV file
        $results | Export-Csv -Path $outputFilePath -NoTypeInformation
        Write-Host "User account check completed.`r`nWe found $account_counter accounts.`r`nResults saved to $outputFilePath"
		        
    } else {
        Write-Host "User account check completed, No account was found!"
    }

    # Terminate Active Connection Sessions with AAD and ExchangeOnline
    Disconnect-ExchangeOnline -Confirm:$false
    Disconnect-AzureAD
}

# Output the total time taken
Write-Output "Total execution time: $($executionTime.TotalSeconds) seconds"
