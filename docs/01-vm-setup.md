# 01 - VirtualBox setup

Tein 4.11.2026 virtuaaliverkon ja kaksi virtuaalikonetta.

## Virtuaaliverkko: LabNet

* Tyyppi: NAT Network, verkko 10.0.2.0/24, gateway 10.0.2.1, DHCP päällä
* Miksi NAT Network eikä pelkkä NAT: pelkässä NAT:ssa jokainen VM on omassa kuplassaan
eivätkä ne näe toisiaan. NAT Networkissa ne ovat samassa verkossa ja pääsevät silti nettiin.

## DC01 (palvelin)

* Windows Server 2025 Evaluation (Desktop Experience)
* 4 GB RAM, 1 CPU (alun perin 2, katso troubleshooting.md), EFI, 64 GB levy
* Verkko: Adapter 1 → NAT Network (LabNet)
* Automaattinen asennus ohitettu, jotta asennan Windowsin itse

## CLIENT01 (työasema)

* Windows 11 Enterprise Evaluation
* 4 GB RAM, 2 CPU, EFI, Secure Boot, TPM 2.0, 64 GB levy
* Verkko: Adapter 1 → NAT Network (LabNet)
* Huom: VirtualBox 7.2:ssa kohta on nimeltään "Proceed with Unattended Installation".
Jätin sen valitsematta.
* Unohdin ensin vaihtaa verkon NAT → NAT Network. Huomasin sen tarkistuksessa ja korjasin.
* Vaihdoin prosessorin kahdesta yhteen etukäteen, että ei tarvitse huolehtia käynnistymisongelmasta, mitä tapahtui DC01-palvelimen kanssa. 

