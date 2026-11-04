\# Active Directory Home Lab



\## Tavoite

Rakennan Windows Server 2025 -domainin ja liitän siihen Windows 11 -klientin.

Harjoittelen AD DS:ää, DNS:ää, GPO:ita ja Power## Ympäristö



\##Ympäristö

\- Hypervisor: VirtualBox 7.2

\- Verkko: NAT Network, 10.0.2.0/24

\- Domain: juhalab.internal



| VM     | OS                        | IP         | DNS        | RAM  |

|--------|---------------------------|------------|------------|------|

| DC01   | Windows Server 2025 (GUI) | 10.0.2.10  | 127.0.0.1  | 4 GB |

| CLIENT01 | Windows 11 Enterprise   | DHCP       | 10.0.2.10  | 4 GB |



\## Miksi clientin DNS osoittaa DC:hen?

Domainiin liittyvä kone etsii domain controllerin DNS:n SRV-tietueiden avulla.

Jos client käyttää julkista DNS:ää, se ei löydä juhalab.internal-domainia,

ja liittyminen epäonnistuu.



\## Eteneminen

\- \[ ] VM:t luotu

\- \[ ] AD DS asennettu ja DC promotoitu

\- \[ ] Client liitetty domainiinShell-automaatiota.

