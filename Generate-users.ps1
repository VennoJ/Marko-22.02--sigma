# Määra failide asukohad (eeldab, et failid on skriptiga samas kaustas)
$eesnimedFail = ".\Eesnimed.txt"
$perenimedFail = ".\Perenimed.txt"
$kirjeldusedFail = ".\Kirjeldused.txt"
$valjundFail = ".\new_users_accounts.csv"

# Kontrolli, kas sisendfailid on olemas
If (!(Test-Path $eesnimedFail) -or !(Test-Path $perenimedFail) -or !(Test-Path $kirjeldusedFail)) {
    Write-Host "Viga: Üks või mitu sisendfaili on puudu!" -ForegroundColor Red
    Exit
}

# Loe failide sisu (Encoding UTF8 oluline täpitähtede jaoks)
$eesnimed = Get-Content $eesnimedFail -Encoding UTF8
$perenimed = Get-Content $perenimedFail -Encoding UTF8
$kirjeldused = Get-Content $kirjeldusedFail -Encoding UTF8

# Funktsioon teksti puhastamiseks kasutajanime jaoks
function Clean-String {
    param ([string]$InputString)
    
    # 1. Kõik väikeseks
    $clean = $InputString.ToLower()
    
    # 2. Asenda täpitähed ja sümbolid (õ,ä,ö,ü,š,ž)
    $clean = $clean -replace 'õ', 'o' -replace 'ä', 'a' -replace 'ö', 'o' -replace 'ü', 'u'
    $clean = $clean -replace 'š', 's' -replace 'ž', 'z'
    
    # 3. Eemalda tühikud ja sidekriipsud
    $clean = $clean -replace '[ -]', ''
    
    return $clean
}

# Funktsioon suvalise parooli genereerimiseks (5-8 märki)
function Get-RandomPassword {
    $pikkus = Get-Random -Minimum 5 -Maximum 9
    # Kasutatavad märgid (numbrid ja tähed)
    $chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    $pass = ""
    for ($i=0; $i -lt $pikkus; $i++) {
        $idx = Get-Random -Maximum $chars.Length
        $pass += $chars[$idx]
    }
    return $pass
}

# Massiiv kasutajate hoidmiseks
$uuedKasutajad = @()

# Genereeri 5 kasutajat
for ($i=1; $i -le 5; $i++) {
    # Vali suvalised andmed
    $randEesnimi = $eesnimed | Get-Random
    $randPerenimi = $perenimed | Get-Random
    $randKirjeldus = $kirjeldused | Get-Random

    # Loo kasutajanimi (eesnimi.perenimi puhastatud kujul)
    $puhasEesnimi = Clean-String -InputString $randEesnimi
    $puhasPerenimi = Clean-String -InputString $randPerenimi
    $kasutajanimi = "$puhasEesnimi.$puhasPerenimi"

    # Loo parool
    $parool = Get-RandomPassword

    # Lisa objekt massiivi
    $uuedKasutajad += [PSCustomObject]@{
        Eesnimi      = $randEesnimi
        Perenimi     = $randPerenimi
        Kasutajanimi = $kasutajanimi
        Parool       = $parool
        Kirjeldus    = $randKirjeldus
    }
}

# Kirjuta faili (üle) semikoolon eraldajaga ja UTF8 kodeeringus
$uuedKasutajad | Export-Csv -Path $valjundFail -Delimiter ";" -NoTypeInformation -Encoding UTF8

Write-Host "Fail '$valjundFail' on edukalt loodud!" -ForegroundColor Green
Write-Host "--- Loodud kasutajate ülevaade ---" -ForegroundColor Cyan

# Kuva konsoolis info (Kirjeldus lühendatud 10 märgini)
$uuedKasutajad | Select-Object Eesnimi, Perenimi, Kasutajanimi, Parool, @{
    Name = 'Kirjeldus'; 
    Expression = { 
        if ($_.Kirjeldus.Length -gt 10) { 
            $_.Kirjeldus.Substring(0, 10) + "..." 
        } else { 
            $_.Kirjeldus 
        } 
    }
} | Format-Table -AutoSize