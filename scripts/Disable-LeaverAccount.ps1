# Offboarding: disables the account of an employee who is leaving.
# Run on DC01 as administrator, e.g.: .\Disable-LeaverAccount.ps1 -Username vkoskinen
# Steps: disable -> description -> remove from all groups -> move to Disabled Users OU.

param(
    [Parameter(Mandatory = $true)]
    [string]$Username
)

Import-Module ActiveDirectory
$targetOU = "OU=Disabled Users,OU=JuhaLab,DC=juhalab,DC=internal"
$date = Get-Date -Format "d.M.yyyy"

# Get the user. If the username does not exist, the script stops here.
$user = Get-ADUser -Identity $Username -Properties MemberOf -ErrorAction Stop
Write-Host "Offboarding account: $($user.Name) ($Username)"

# 1. Disable first, because it blocks access immediately
Disable-ADAccount -Identity $user
Write-Host "Account disabled"

# 2. Description, so others can see why and when
Set-ADUser -Identity $user -Description "Disabled $date - left company"
Write-Host "Description set"

# 3. Remove from all groups (Domain Users stays, it is the primary group)
foreach ($group in $user.MemberOf) {
    Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
    Write-Host "Removed from group: $group"
}

# 4. Move to Disabled Users OU (last, because moving changes the DistinguishedName)
Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
Write-Host "Moved to: $targetOU"
Write-Host "Done."
