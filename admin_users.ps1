# admin_users.ps1

# 1. Administraatori õiguste kontroll
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Käivita skript administraatori õigustes!"
    Break
}

# Sunnime UTF-8 toetuse (vajalik täpitähtede jaoks täisnimedes)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$csvFail = ".\new_users_accounts.csv"
if (-not (Test-Path $csvFail)) { Write-Error "CSV faili ei leitud!"; Break }

Clear-Host
Write-Host "--- KASUTAJA HALDUS (PS7 & Windows 11 Fixed) ---" -ForegroundColor Cyan
Write-Host "1. Lisa kasutajad failist"
Write-Host "2. Kustuta kasutaja"
$valik = Read-Host "Vali tegevus"

if ($valik -eq "1") {
    $kasutajad = Import-Csv $csvFail -Delimiter ";" -Encoding utf8

    foreach ($rida in $kasutajad) {
        $uName = $rida.Kasutajanimi
        $fullName = "$($rida.Eesnimi) $($rida.Perenimi)"
        $desc = $rida.Kirjeldus
        $pw = $rida.Parool

        if (Get-LocalUser -Name $uName -ErrorAction SilentlyContinue) {
            Write-Host "Kasutaja '$uName' on juba olemas." -ForegroundColor Yellow
            Continue
        }

        try {
            # Kasutame 'net user' käsku, et vältida PS7 TelemetryAPI viga
            $netArgs = "`"$uName`" `"$pw`" /add /comment:`"$desc`" /fullname:`"$fullName`" /logonpasswordchg:yes"
            cmd /c "net user $netArgs"

            if ($LASTEXITCODE -eq 0) {
                Write-Host "OK: '$uName' lisatud (Täisnimi: $fullName)." -ForegroundColor Green
            } else {
                Write-Host "VIGA: '$uName' loomine ebaõnnestus." -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Süsteemne viga: $_" -ForegroundColor Red
        }
    }
}
elseif ($valik -eq "2") {
    $kustutatavad = Get-LocalUser | Where-Object { $_.Name -notin @("Administrator", "Guest", "DefaultAccount", "WDAGUtilityAccount") }
    $i = 1
    foreach ($k in $kustutatavad) { Write-Host "$i. $($k.Name)"; $i++ }
    $v = Read-Host "Vali number"
    if ($v -match '^\d+$') {
        $nimi = $kustutatavad[[int]$v - 1].Name
        cmd /c "net user `"$nimi`" /delete"
        Write-Host "Kasutaja $nimi kustutatud." -ForegroundColor Green
    }
}