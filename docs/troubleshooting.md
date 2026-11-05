# Troubleshooting

Tähän kirjaan asiat, jotka menivät pieleen, ja miten ne korjattiin.

---

## 4.11.2026: GitHubiin lähettäminen ei onnistunut

**Mitä tapahtui:** Yritin lähettää repon GitHubiin komennolla `git push`, mutta sain virheen
"Internal Server Error".

**Miksi:** Vika ei ollut omassa päässä, vaan GitHubissa. 
Sen näki sivulta githubstatus.com. `git push` myöähemmäksi.

**Miten korjasin:** Odotin, että GitHub sai vian korjattua ja yritin sitten uudelleen.
Työt olivat koko ajan tallessa omalla koneellani.

**Mitä opin:** Kun virheessä lukee "Internal Server Error" (eli virhe 500), ongelma on
palvelimen päässä. Tsekkaus tilasivuun ennen kuin alkaa korjata omia asetuksia.

---

## 4.11.2026: Palvelin-VM jäi mustalle ruudulle

**Mitä tapahtui:** Käynnistin DC01-virtuaalikoneen, mutta ruutu pysyi mustana.
Mitään ei tapahtunut, ei edes asennuksen aloitusta.

**Miksi:** Koneessani on päällä Windowsin oma tietoturvaominaisuus (Memory Integrity),
joka käyttää samaa virtualisointia kuin VirtualBox. Siksi VirtualBox joutuu toimimaan
"Windowsin kautta", ja se teki virtuaalikoneen käynnistyksestä epävakaan. Käynnistys jäi
jumiin kohtaan, jossa se yritti ottaa käyttöön useamman prosessoriytimen.

**Korjaus:** Vaihdoin VM:n asetuksista prosessorien määrän kahdesta yhteen. Sen jälkeen VM käynnistyi ja asennus lähti käyntiin.

**Mitä opin:** Jokaisella VM:llä on oma lokitiedosto (VirtualBox VMs\DC01\Logs\VBox.log),
josta näkee, mihin kohtaan käynnistys jäi. Sieltä vian syy löytyi.

---

## 5.11.2026: Windows 11 ei suostunut asentumaan, ja oikea korjaus mustaan ruutuun

**Mitä tapahtui:** CLIENT01:n asennus pysähtyi ilmoitukseen "The processor needs to have
two or more cores". Windows 11 vaatii vähintään kaksi prosessoria, mutta kahdella prosessorilla
VM jäi samalle mustalle ruudulle kuin DC01. Edellinen kikka (yksi prosessori) ei siis enää käynyt.

**Miksi:** Prosessorin virtualisointiominaisuutta (VT-x) voi käyttää vain yksi ohjelma kerrallaan.
Koneellani Windows piti sitä varattuna kolmelle omalle jutulleen, joten VirtualBox joutui
kulkemaan Windowsin kautta. Siitä tuli ongelmia.

**Miten korjasin:** Kytkin pois päältä kolme asiaa ja käynnistin koneen uudelleen:

1. **Memory Integrity** (Windows-suojaus → Laitteen suojaus → Ydinkulun eristys)
2. **Hypervisorin käynnistys:** `bcdedit /set hypervisorlaunchtype off` (admin-PowerShell)
3. **VBS** ja **Virtual Machine Platform:**
   ```powershell
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f
   Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
   ```

Ensimmäinen yritys (kohdat 1 ja 2) ei riittänyt, koska hypervisori käynnistyi silti. Tarkistuksessa
selvisi, että VBS oli yhä päällä rekisterissä. Kun kytkin senkin ja Virtual Machine Platformin pois,
homma toimi. Nyt VBox-lokissa lukee "VT-x", eikä enää "fall back to NEM", ja VM:t käynnistyvät
kahdella prosessorilla ja paljon nopeammin.

**Mitä se maksoi:** Koneestani puuttuu nyt yksi tietoturvakerros (ytimen eristys). Defender,
palomuuri ja päivitykset toimivat normaalisti. Hyväksyin tämän labrakäytön takia.

**Miten perun muutokset, kun labra on valmis** (admin-PowerShell + uudelleenkäynnistys):
```powershell
bcdedit /set hypervisorlaunchtype auto
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 1 /f
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
```
Lisäksi Memory Integrity takaisin päälle Windows-suojauksesta.

**Mitä opin:** Jos korjaus ei toimi, kannattaa tarkistaa, mikä oikeasti on päällä, eikä vain olettaa.
Lisäksi ensimmäinen "kikka" (yksi prosessori) kiersi ongelman, mutta ei korjannut sitä.
