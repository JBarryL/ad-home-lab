# Active Directory Home Lab

> **In English:** A self-built Windows Server 2025 Active Directory lab in VirtualBox with a
> domain-joined Windows 11 client. I set up the domain, DNS, OU structure, security groups, Group
> Policies, a permission-controlled file share with a GPO drive map, user onboarding and offboarding
> with PowerShell scripts, and AD Recycle Bin. Every step is documented (in Finnish) with screenshots,
> including the problems I ran into and how I solved them.

## Mitä labrassa on tehty

Rakensin oman pienen "yrityksen" domainin ja tein siinä tehtäviä, joita helpdeskissä ja
ylläpidossa tehdään oikeasti:

- **Domain ja DNS**: Windows Server 2025 domain controlleriksi, Windows 11 -työasema domainiin,
  DNS-forwarderit ja reverse lookup zone
- **Käyttäjät ja ryhmät**: OU-rakenne osastoittain, oikeudet ryhmien kautta eikä yksittäisille käyttäjille
- **Ryhmäkäytännöt (GPO)**: salasana- ja lukituspolitiikka (testattu tapahtumilla 4740/4767),
  taustakuva ja verkkoasema
- **Jaettu kansio**: share- ja NTFS-oikeuksien ero, vain IT-ryhmä pääsee kansioon. Testattu
  sekä sallitulla että estetyllä käyttäjällä.
- **Käyttäjän elinkaari PowerShellillä**: massaluonti CSV:stä ja offboarding-skripti
  (disable → ryhmät pois → siirto Disabled Users -OU:hun)
- **Palautus**: AD Recycle Bin ja vahingossa poistetun käyttäjän palautus ryhmineen
- **Hyökkääjän näkökulma (Kali Linux)**: verkon kartoitus (nmap), password spray ja
  autentikoitu enumerointi (NetExec) – ja kovennusten testaaminen hyökkääjän päästä
- **Vianetsintä**: mm. virtualisointiongelmat, DC:n kellon jättämä ja skriptien virhetilanteet.
  Kaikki on kirjattu [troubleshooting.md](docs/troubleshooting.md)-tiedostoon.

## Ympäristö

- Virtualisointi: VirtualBox 7.2
- Verkko: NAT Network, 10.0.2.0/24
- Domain: juhalab.internal (NetBIOS: JUHALAB)

| VM | Käyttöjärjestelmä | IP | DNS | RAM |
|---|---|---|---|---|
| DC01 | Windows Server 2025 (GUI) | 10.0.2.10 | 127.0.0.1 | 3 GB |
| CLIENT01 | Windows 11 Enterprise | DHCP | 10.0.2.10 | 3 GB |
| KALI01 | Kali Linux | 10.0.2.101 | - | 3 GB |

DC01 on domainin DNS-palvelin, ja muut kyselyt välitetään forwardereille (Quad9: 9.9.9.9 ja 149.112.112.112).

## Domainin rakenne

```
juhalab.internal
└── JuhaLab
    ├── Computers
    ├── Groups           GRP-IT, GRP-Management
    ├── Users
    │   ├── HR           4 käyttäjää (luotu skriptillä)
    │   ├── IT           euotila (GRP-IT)
    │   ├── Management   amakela (GRP-Management)
    │   └── Sales
    └── Disabled Users   3 lähtenyttä käyttäjää (offboarding)
```

| GPO | Linkitetty | Tehtävä |
|---|---|---|
| GPO-Domain-PasswordPolicy | domain | Salasana vähintään 12 merkkiä, lukitus 5 väärän yrityksen jälkeen |
| GPO-User-Wallpaper | JuhaLab\Users | Yhteinen taustakuva |
| GPO-User-DriveMap-IT | JuhaLab\Users | Verkkoasema I: vain GRP-IT:lle (Item-level targeting) |

## Skriptit

| Skripti | Mitä tekee |
|---|---|
| [New-BulkUsers.ps1](scripts/New-BulkUsers.ps1) | Luo käyttäjät [CSV:stä](scripts/users.csv) oikeisiin OU:ihin. Ohittaa jo olemassa olevat, joten sen voi ajaa uudelleen, kun CSV:hen tulee uusia rivejä. |
| [Disable-LeaverAccount.ps1](scripts/Disable-LeaverAccount.ps1) | Offboarding yhdellä komennolla: disable, kuvaus, poisto kaikista ryhmistä ja siirto Disabled Users -OU:hun. |

## Dokumentaatio

1. [Virtuaalikoneiden luonti](docs/01-vm-setup.md)
2. [DC01:n asennus](docs/02-dc01-install.md)
3. [Active Directory ja DC:n ylennys](docs/03-active-directory.md)
4. [Työaseman liittäminen domainiin](docs/04-client-domain-join.md)
5. [OU-rakenne ja ensimmäiset käyttäjät](docs/05-ou-and-users.md)
6. [Ryhmät ja kirjautumistesti](docs/06-groups-and-login-test.md)
7. [Ryhmäkäytännöt (GPO)](docs/07-gpo.md)
8. [Käyttäjien massaluonti PowerShellillä](docs/08-powershell-bulk-users.md)
9. [DNS: forwarder ja reverse lookup zone](docs/09-dns-forwarder-reverse-zone.md)
10. [Jaettu kansio ja verkkoasema GPO:lla](docs/10-shared-folder-drive-map.md)
11. [Käyttäjän poistuminen (offboarding)](docs/11-offboarding.md)
12. [AD Recycle Bin: poistetun käyttäjän palautus](docs/12-ad-recycle-bin.md)
13. [Bulk-skriptin parannus: uudelleenajo ja virhetilanteet](docs/13-bulk-script-improvements.md)
14. [Hyökkääjän näkökulma: recon ja enumerointi Kalilta](docs/14-kali-recon-enumeration.md)

Ongelmat ja niiden ratkaisut: [troubleshooting.md](docs/troubleshooting.md)

## Seuraavaksi

Jatkan hyökkääjän näkökulmasta: AD:n polkujen mallinnus BloodHoundilla ja löydösten pohjalta
kovennusten viimeistely.

## Kansiot

- `docs/` - vaiheiden dokumentaatio
- `screenshots/` - kuvakaappaukset
- `scripts/` - PowerShell-skriptit
