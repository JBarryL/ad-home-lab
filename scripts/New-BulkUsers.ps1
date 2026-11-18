# Creates AD users from a CSV file (users.csv).
# Run on DC01 as administrator. The password is asked at runtime and not saved to a file.
# Users that already exist anywhere in the domain are skipped, so the script can be run again
# after new rows are added to the CSV.

Import-Module ActiveDirectory
$users = Import-Csv C:\Scripts\users.csv
$password = Read-Host "Initial password" -AsSecureString

# Stop if the password is empty (e.g. an extra Enter was pressed)
if ($password.Length -eq 0) {
    Write-Host "Password is empty. Stopping, no users were created." -ForegroundColor Red
    exit
}

$domainPath = "OU=Users,OU=JuhaLab,DC=juhalab,DC=internal"

foreach ($u in $users) {
    # Check the whole domain, not just the target OU (e.g. leavers are in Disabled Users)
    $existing = Get-ADUser -Filter "SamAccountName -eq '$($u.SamAccountName)'"
    if ($existing) {
        Write-Host "Skipped (already exists): $($u.SamAccountName) -> $($existing.DistinguishedName)" -ForegroundColor Yellow
        continue
    }

    # Department column decides the OU (HR / Sales)
    $ou = "OU=$($u.Department),$domainPath"
    try {
        New-ADUser -Name "$($u.FirstName) $($u.LastName)" `
            -GivenName $u.FirstName `
            -Surname $u.LastName `
            -SamAccountName $u.SamAccountName `
            -UserPrincipalName "$($u.SamAccountName)@juhalab.internal" `
            -Department $u.Department `
            -Path $ou `
            -AccountPassword $password `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -ErrorAction Stop
        Write-Host "Created: $($u.SamAccountName) -> $ou" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED: $($u.SamAccountName) - $($_.Exception.Message)" -ForegroundColor Red
        # New-ADUser creates the account before setting the password. If the password is
        # rejected, a half-created disabled account is left behind, so remove it.
        $partial = Get-ADUser -Filter "SamAccountName -eq '$($u.SamAccountName)'"
        if ($partial) {
            Remove-ADUser -Identity $partial -Confirm:$false
            Write-Host "Removed half-created account: $($u.SamAccountName)" -ForegroundColor Red
        }
    }
}
