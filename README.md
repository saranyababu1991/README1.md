# 👤 Automated Office 365 User Provisioning

This PowerShell project automates the creation of users in Microsoft 365, including:

✅ Azure AD user creation  
✅ Microsoft 365 license assignment  
✅ Group membership management  
✅ MFA-ready setup  
✅ CSV-based input  
✅ Logging to a local file  

### 🔧 Technologies Used:
- PowerShell
- Microsoft Graph API
- Azure AD Module
- MSOnline Module

### 🛠️ Setup:
1. Install required modules:
   ```powershell
   Install-Module Microsoft.Graph -Scope CurrentUser
   Install-Module AzureAD -Scope CurrentUser
   Install-Module MSOnline -Scope CurrentUser
