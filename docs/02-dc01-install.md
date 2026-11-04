# 02 - Windows Server -asennus (DC01)

Tein 4.11.2026.

## Asennus

- Asensin Windows Server 2025 Standard Evaluation (Desktop Experience) -version.
  "Desktop Experience" tarkoittaa, että mukana on graafinen käyttöliittymä. Ilman sitä kaikki tehtäisiin komentoriviltä.
- Kieli English (US), mutta näppäimistö Finnish, jotta salasanan merkit menevät oikein.
- Asennus kesti noin tunnin, koska VirtualBox toimii koneellani Hyper-V:n kautta ja yhdellä prosessorilla.
- Diagnostiikkadata: valitsin vain pakolliset tiedot.

## Asetukset asennuksen jälkeen

**Aikavyöhyke:** Kello oli väärin, koska aikavyöhykkeenä oli Yhdysvaltain länsirannikko.
Vaihdoin sen Helsingin aikaan.

**Koneen nimi:** 
- Vaihdoin nimeksi DC01.
- Nimi kannattaa vaihtaa ennen kuin koneesta tehdään domain controller.

**Kiinteä IP-osoite:** Domain controllerin osoite ei saa vaihtua, koska muut koneet etsivät sitä
tietystä osoitteesta. 

| Asetus | Arvo | Mikä se on |
|---|---|---|
| IP address | 10.0.2.10 | Serverin pysyvä osoite |
| Subnet mask | 255.255.255.0 | Kertoo mitkä osoitteet ovat samassa verkossa |
| Default gateway | 10.0.2.1 | "Ovi ulos nettiin" |
| Preferred DNS | 127.0.0.1 | "Minä itse", koska serveristä tulee domainin DNS-palvelin |
| Alternate DNS | 9.9.9.9 | Varalla, jotta netti toimii ennen kuin DNS on asennettu |

**DHCP-alueen siirto:** VirtualBoxin LabNet jakoi osoitteita väliltä 10.0.2.3–254, eli myös serverin
osoitetta 10.0.2.10. Siirsin DHCP-alueen väliin 10.0.2.100–200, ettei client saa vahingossa samaa osoitetta:

```powershell
VBoxManage dhcpserver modify --network=LabNet --lower-ip=10.0.2.100 --upper-ip=10.0.2.200
```

## Seuraavaksi

- Testaan, että serverin netti toimii
- Asennan AD DS -roolin ja teen serveristä domain controllerin (juhalab.internal)
