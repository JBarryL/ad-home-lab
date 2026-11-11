# Luo AD-käyttäjät CSV-tiedostosta (users.csv).
# Ajetaan DC01:llä järjestelmänvalvojana. Salasana kysytään ajon aikana, ei tallenneta tiedostoon.

Import-Module ActiveDirectory
$users = Import-Csv C:\Scripts\users.csv
$password = Read-Host "Anna alkusalasana" -AsSecureString
$domainPath = "OU=Users,OU=JuhaLab,DC=juhalab,DC=internal"

foreach ($u in $users) {
    # Department-sarake ratkaisee OU:n (HR / Sales)
    $ou = "OU=$($u.Department),$domainPath"
    New-ADUser -Name "$($u.FirstName) $($u.LastName)" `
        -GivenName $u.FirstName `
        -Surname $u.LastName `
        -SamAccountName $u.SamAccountName `
        -UserPrincipalName "$($u.SamAccountName)@juhalab.internal" `
        -Department $u.Department `
        -Path $ou `
        -AccountPassword $password `
        -Enabled $true `
        -ChangePasswordAtLogon $true
    Write-Host "Luotu: $($u.SamAccountName) -> $ou"
}
