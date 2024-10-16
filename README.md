# **User Account Check and Verification Script**


**Date**: 09 October 2024  
**Author**: Salaheddin Darwish  

---

## **Table of Contents**

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Script Overview](#script-overview)
4. [Usage Instructions](#usage-instructions)
5. [Example Input and Output](#example-input-and-output)
6. [Error Handling](#error-handling)
7. [Performance and Execution Time](#performance-and-execution-time)
8. [Troubleshooting](#troubleshooting)
9. [Contact Information](#contact-information)

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
     ```
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
mike.adams@example.com
