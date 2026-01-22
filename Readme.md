# Kasutajakontode Generaator (PowerShell)

See projekt on automaatne lahendus kasutajakontode andmete genereerimiseks. Skript töötleb etteantud tekstifaile ja loob neist juhusliku valiku alusel uue CSV andmebaasi, mida saab kasutada süsteemi administreerimise harjutamiseks või testimiseks.

## Failide struktuur

Projekt vajab tööks järgmisi faile samas kaustas:

* **Generate-Users.ps1** – Peamine PowerShelli skript, mis teostab loogikat.
* [cite_start]**Eesnimed.txt** – Sisendfail eesnimedega (nt Riina, Sten, Karl Kristjan jne)[cite: 1].
* [cite_start]**Perenimed.txt** – Sisendfail perenimedega (nt Lillemets, Vill-Kruus jne)[cite: 6].
* [cite_start]**Kirjeldused.txt** – Sisendfail rollide kirjeldustega (nt "Vastutab süsteemi laiade haldusülesannete eest...")[cite: 2].

Skripti käivitamisel luuakse (või kirjutatakse üle):
* **new_users_accounts.csv** – Lõplik nimekiri genereeritud kasutajatest.

## Funktsionaalsus

Skript täidab järgmisi ülesandeid:

1.  **Juhuslik valik:** Valib failidest suvaliselt 5 eesnime, perenime ja kirjeldust.
2.  **Kasutajanime loomine:**
    * Vorming: `eesnimi.perenimi`
    * Puhastamine: Eemaldab tühikud ja sidekriipsud.
    * Normaliseerimine: Asendab täpitähed (õ, ä, ö, ü, š, ž) ladina vastetega ja muudab kõik tähed väikseks.
3.  **Parooli genereerimine:** Loob igale kasutajale unikaalse juhusliku parooli pikkusega 5-8 märki.
4.  **Aruandlus:**
    * Salvestab andmed CSV faili (eraldajaks semikoolon `;`).
    * Kuvab konsoolis ülevaate loodud kasutajatest (kirjeldust kuvatakse lühendatult).

## Kasutamine

1.  Lae kõik failid oma arvutisse ühte kausta.
2.  Ava **PowerShell** ja navigeeri sellesse kausta (`cd` käsk).
3.  Käivita skript:

```powershell
.\Generate-Users.ps1