# Active Directory Home Lab

## Tavoite

Rakennan Windows Server 2025 -domainin ja liitän siihen Windows 11 -työaseman.
Harjoittelen AD DS:ää, DNS:ää, ryhmäkäytäntöjä (GPO) ja PowerShell-automaatiota.

## Ympäristö

- Virtualisointi: VirtualBox 7.2
- Verkko: NAT Network, 10.0.2.0/24
- Domain: juhalab.internal

| VM | Käyttöjärjestelmä | IP | DNS | RAM |
|---|---|---|---|---|
| DC01 | Windows Server 2025 (GUI) | 10.0.2.10 | 127.0.0.1 | 3 GB |
| CLIENT01 | Windows 11 Enterprise | DHCP | 10.0.2.10 | 3 GB |

## Miksi työaseman DNS osoittaa DC:hen?

Domainiin liittyvä kone etsii domain controllerin DNS:n SRV-tietueiden avulla.
Jos työasema käyttää julkista DNS:ää, se ei löydä juhalab.internal-domainia,
eikä domainiin liittyminen onnistu.

## Eteneminen

- [x] [01 - Virtuaalikoneiden luonti](docs/01-vm-setup.md)
- [x] [02 - DC01:n asennus](docs/02-dc01-install.md)
- [x] [03 - Active Directory ja DC:n ylennys](docs/03-active-directory.md)
- [x] [04 - Työaseman liittäminen domainiin](docs/04-client-domain-join.md)
- [x] [05 - OU-rakenne ja ensimmäiset käyttäjät](docs/05-ou-and-users.md)
- [x] [06 - Ryhmät ja kirjautumistesti](docs/06-groups-and-login-test.md)
- [x] [07 - Ryhmäkäytännöt (GPO)](docs/07-gpo.md)
- [x] [08 - Käyttäjien massaluonti PowerShellillä](docs/08-powershell-bulk-users.md)
- [ ] DNS: forwarder ja reverse lookup zone

Ongelmat ja niiden ratkaisut: [troubleshooting.md](docs/troubleshooting.md)

## Kansiot

- `docs/` - vaiheiden dokumentaatio
- `screenshots/` - kuvakaappaukset
- `scripts/` - PowerShell-skriptit
