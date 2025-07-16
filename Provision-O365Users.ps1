# Requires: Microsoft Graph, MSOnline, AzureAD modules

Import-Module Microsoft.Graph.Users
Import-Module AzureAD
Import-Module MSOnline

# Connect to Microsoft Services
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"
Connect-MsolService
Connect-AzureAD

# Import CSV
$users = Import-Csv "./users.csv"

foreach ($user in $users) {
    try {
        Write-Host "Provisioning user: $($user.DisplayName)"

        # Create user
        $PasswordProfile = @{
            ForceChangePasswordNextSignIn = $true
            Password = $user.Password
        }

        $NewUserParams = @{
            accountEnabled = $true
            displayName = $user.DisplayName
            mailNickname = $user.MailNickname
            userPrincipalName = $user.UserPrincipalName
            passwordProfile = $PasswordProfile
            usageLocation = $user.UsageLocation
        }

        $newUser = New-MgUser -BodyParameter $NewUserParams

        # Assign license
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $user.LicenseSku

        # Add to Group (if provided)
        if ($user.GroupId -ne "") {
            Add-AzureADGroupMember -ObjectId $user.GroupId -RefObjectId $newUser.Id
        }

        # Log success
        Add-Content -Path "./ProvisioningLog.txt" -Value "[$(Get-Date)] Provisioned: $($user.UserPrincipalName)"
    }
    catch {
        Add-Content -Path "./ProvisioningLog.txt" -Value "[$(Get-Date)] ERROR for $($user.UserPrincipalName): $_"
    }
}
