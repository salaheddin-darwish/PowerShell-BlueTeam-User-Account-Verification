<p align="center">
  <img src="https://github.com/PowerShell/PowerShell/raw/master/assets/Powershell_256.png" width="100" alt="project-logo">
</p>

<p align="center">
    <h1 align="center">User Account Verification</h1>
</p
</p> 
<p align="center">
    <em *align="center">Checking user accounts with PowerShell </em>
</p>

 <p align="center">
	<img src="https://img.shields.io/github/license/DownWithUp/CallMon?style=flat&logo=opensourceinitiative&logoColor=white&color=lightgrey" alt="license">
	<img src="https://img.shields.io/github/last-commit/DownWithUp/CallMon?style=flat&logo=git&logoColor=white&color=lightgrey" alt="last-commit">
	<img src="https://img.shields.io/github/languages/top/DownWithUp/CallMon?style=flat&color=lightgrey" alt="repo-top-language">
	<img src="https://img.shields.io/github/languages/count/DownWithUp/CallMon?style=flat&color=lightgrey" alt="repo-language-count">
<p>

---

## **Table of Contents**

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Script Overview](#script-overview)
4. [Usage Instructions](#usage-instructions)
5. [Example Input and Output](#example-input-and-output)
6. [Troubleshooting and Error Handling](#troubleshooting-and-error-handling)
7. [Contributing](#contributing)
8. [License](#license)


---

## **Introduction**

This PowerShell script is designed to streamline the process of checking user accounts in **Azure Active Directory (Azure AD)** and **Exchange Online**. It takes a list of email addresses from a CSV file, a combo list of compromised accounts provided by security vendors. Then, the script checks whether each email corresponds to an existing user mailbox in Exchange Online, retrieves relevant information from Azure AD, and exports the results to a CSV file for further analysis.

This is part of a security audit to verify potentially compromised accounts and to retrieve important account details such as account status, creation date, and job title.

---

## **Prerequisites**

Before running this script, ensure that the following requirements are met:

- **PowerShell Version**: The script is designed to run in **PowerShell 5.1** or later.
- **Modules Required**:
    - **ExchangeOnlineManagement**: Install using:
      ```powershell
      Install-Module -Name ExchangeOnlineManagement -Force
      ```
    - **AzureAD**: Install using:
      ```powershell
      Install-Module -Name AzureAD
      ```
  
- **Admin Privileges**: The script requires administrator access to execute and connect to Azure AD and Exchange Online services.

- **CSV File**: A properly formatted CSV file containing the email addresses of the users to check. The file should have a header column named `EmailAddress`.

---

## **Script Overview**

The script performs the process of:
1. **Installing Required Modules**: If `ExchangeOnlineManagement` or `AzureAD` are not installed, the script will automatically install them.
2. **Connecting to Azure AD and Exchange Online**: Establishes a connection to both services.
3. **User Account Verification**: Loops through each email in the CSV and checks:
    - Existence of the user’s mailbox in Exchange Online.
    - Account details from Azure AD, including **Account Status**, **Job Title**, **Department**, and **Creation Date**.
4. **Results Export**: Exports the results to a CSV file in a specified location.

---

## **Usage Instructions**

### **Steps to Execute the Script**:

1. **Download the Script**: Save the PowerShell script to your local machine.
2. **Open PowerShell**: Run PowerShell as an administrator.
3. **Edit the Script**:
   - Update the input and output file paths in the script:
     ```powershell
     $inputFilePath = "C:\Path\To\Input\user_accounts.csv"
     $outputFilePath = "C:\Path\To\Output\results_$timestamp.csv"
   ###
4. **Run the Script**: Execute the script in PowerShell:
   ```powershell
   ./ComboListChecking-PS-MG-Final.ps1

---
## **Example Input and Output**

### **CSV Input Example**:
The input file for the script is a CSV that contains a list of email addresses to check in Azure AD and Exchange Online. The CSV must have a column header named `EmailAddress`. An example format is shown below:

```csv
EmailAddress
john.doe@example.com
jane.smith@example.com
michael.brown@example.com
emily.johnson@example.co
sue.karmen@example.com
sarah.williams@example.com
 ```

### **CVS Output Example**
After running the script, the results will be exported to a CSV file. Below is a sample of what the output might look like in the generated CSV, displayed here as a table for clarity:

After running the script, the results will be exported to a CSV file. Below is a sample of what the output might look like in the generated CSV, displayed here as a table for clarity:

| DisplayName     | EmailAddress           | AccountStatus | JobTitle         | Department     | CreationDateTime     | LastPasswordChangeTime | UserRiskLevel | ObjectUserID                         |
|-----------------|------------------------|---------------|------------------|----------------|----------------------|------------------------|---------------|--------------------------------------|
| John Doe        | john.doe@example.com    | Active        | IT Manager       | Information Tech | 2022-06-01T10:15:00  | 2023-07-20T08:32:00     | Low           | 2c63bff1-4a55-4893-b635-0a285c567e34|
| Jane Smith      | jane.smith@example.com  | Disabled      | Marketing Lead   | Marketing       | 2020-09-12T08:30:00  | 2021-08-15T10:22:00     | High          | 5b75cdd2-6d45-411a-9c8f-8a29a1c7de93|
| Emily Johnson   | emily.johnson@example.com| Active        | Data Analyst     | Finance         | 2021-03-21T14:22:00  | 2023-05-17T12:48:00     | Medium        | 9d8c8f3f-1a57-48e5-a3b9-0d2d676e1de7|
| Michael Brown   | michael.brown@example.com| Active        | HR Specialist    | Human Resources | 2019-11-05T09:12:00  | 2023-01-09T09:15:00     | No Risk       | 6f85bb54-2c23-45e1-9e5c-0d3c90ff547f|
| Sarah Williams  | sarah.williams@example.com| Disabled     | Sales Director   | Sales           | 2018-07-17T16:05:00  | 2022-09-12T14:50:00     | High          | 4d35c9a2-4f19-422d-995e-7f40d129f923|

### Explanation of Fields

- **DisplayName**: The full name of the user from Azure AD.
- **EmailAddress**: The email address of the user, as provided in the input CSV.
- **AccountStatus**: Indicates whether the account is `Active` or `Disabled` in Azure AD.
- **JobTitle**: The job title of the user in Azure AD.
- **Department**: The department the user is associated with in Azure AD.
- **CreationDateTime**: The date and time when the account was created in Azure AD.
- **LastPasswordChangeTime**: The date and time of the last password change by the user.
- **UserRiskLevel**: The current risk level of the user account (`Low`, `Medium`, `High`).
- **ObjectUserID**: The unique Object ID of the user in Azure AD.


---
The output file is named with a timestamp and saved in the format:

```bash
results_YYYYMMDD_HHmmss.csv
```

## **Troubleshooting and Error Handling**

The script includes error-handling mechanisms to ensure smooth execution even when issues arise. Here's how errors are managed:

1. **Module Installation Errors**:
   - If required modules (`AzureAD` and `ExchangeOnlineManagement`) are not installed, the script attempts to install them. If the installation fails, an error message will appear, and the script will stop execution.
   
   - To prevent this, ensure you have administrative rights and an active internet connection when running the script for the first time.

2. **Silent Error Handling**:
   - When looking up user accounts or mailboxes, the script uses the `-ErrorAction SilentlyContinue` flag. This means that if a specific lookup fails (e.g., if a mailbox or user does not exist), the script will continue processing the remaining accounts without stopping or displaying an error in the console.

3. **Missing Accounts**:
   - If a user account or mailbox is not found, the script will simply skip that entry and continue. 
   
   - At the end of execution, the script will indicate how many valid user accounts were found and processed. If no accounts were found, the following message will be displayed:
     ```powershell
     "No account was found!"
     ```

4. **Connection Errors**:
   - If the script cannot connect to **Azure AD** or **Exchange Online** (due to incorrect credentials, network issues, or permission problems), it will display an error message and terminate the session. 
   
   - Make sure you have the proper administrative permissions for Azure AD and Exchange Online to avoid this issue.

5. **Invalid CSV File Format**:
   - If the input CSV file is not correctly formatted (i.e., if the first column is not named `EmailAddress`), the script will not be able to process the accounts.
   
   - To prevent this, ensure the CSV file conforms to the expected format as described in the [CSV Input Format](#cvs-input-example) section.

## Contributing

Contributions to improve the script are welcome. Please feel free to submit a Pull Request.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Disclaimer

This script is provided as-is, without any warranties. Always test in a non-production environment before using in production.

