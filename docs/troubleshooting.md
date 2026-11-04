# Troubleshooting

Tähän kirjaan asiat, jotka menivät pieleen, ja miten ne korjattiin.

---

## 4.11.2026: GitHubiin lähettäminen ei onnistunut

**Mitä tapahtui:** Yritin lähettää repon GitHubiin komennolla `git push`, mutta sain virheen
"Internal Server Error".

**Miksi:** Vika ei ollut omassa päässä, vaan GitHubissa. Heillä oli häiriö juuri sillä hetkellä.
Sen näki sivulta githubstatus.com.

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
