#Syntax: .\run_nvidia-driver-setup.ps1 *Datei mit Computernamen (DNS, Netbios)* *Ordner mit entpacktem Grafikkartentreiber*
#Example no Logfile is saved: .\run_nvidia-driver-setup.ps1 .\Computer.csv .\Nvidia
#Example no Logfile is saved: .\run_nvidia-driver-setup.ps1 C:\Liste.csv "C:\Nvidia"
#Example with saved Logfile: .\run_nvidia-driver-setup.ps1 Computer.csv .\Nvidia Save

#Variablen
$script:ver = "1.1"
$script:verdate = "12.02.2018"
$script:scriptname = "Nvidia Treiber"
$script:tmplogfile = "$env:temp\run_nvidia-driver-setup.tmp"
$script:logfile = "$env:temp\run_nvidia-driver-setup.log"

$script:computerliste = $Args[0]
$script:grafiktreiberordner = $Args[1]
$script:grafiktreiberdatei = ($Args[1] + "\setup.exe")

$script:startdate = Get-Date -UFormat %d.%m.%Y
$script:starttime = Get-Date -UFormat %R

#Logfunktion starten
Start-Transcript -Path "$tmplogfile"


#Informationsblock Anfang
Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Gray
Write-Host "Start $scriptname Script Ver. $ver, $verdate" -ForegroundColor Gray
Write-Host "Written by Andyt for face of buildings planning stimakovits GmbH" -ForegroundColor Gray
Write-Host "Promoted development by BlackSeals.net Technology" -ForegroundColor Gray
Write-Host "Copyright 2018 by Reisenhofer Andreas" -ForegroundColor Gray
Write-Host "Gestartet am $startdate um $starttime Uhr..." -ForegroundColor Gray
Write-Host "==========================================================================" -ForegroundColor Gray
Write-Host ""

#Prüfe auf existierende Datei
$script:checkpath_liste = Test-Path -Path $computerliste -PathType Leaf
$script:checkpath_ordner = Test-Path -Path $grafiktreiberordner -PathType Container
$script:checkpath_datei = Test-Path -Path $grafiktreiberdatei -PathType Leaf
$script:checkpath_PsExec = Test-Path -Path "$PSScriptRoot\PsExec64.exe" -PathType Leaf

If (($checkpath_liste -eq "True") -and ($checkpath_ordner -eq "True") -and ($checkpath_datei -eq "True") -and ($checkpath_PSExec -eq "True")) {

	#Ausführen für jeden Computer aus Computerliste
	Get-Content $computerliste | ForEach-Object {
		Write-Host "Ablauf für Computer $_" -ForegroundColor Green
		If (Test-Connection -ComputerName $_ -Count 1 -Quiet) {
			Write-Host "$_ ist erreichbar."
			#Kopiere Grafikkartentreiber
			Copy-Item -Path "$grafiktreiberordner" -Destination "\\$_\c$" -Recurse -Force
			$script:kopierterordner = Split-Path ($grafiktreiberordner) -Leaf
			Write-Host "Der Ordner '$kopierterordner' wurde nach $_ kopiert."

			#Installation des Grafikkartentreiber
			& "$PSScriptRoot\PsExec64.exe" \\$_ c:\$kopierterordner\setup.exe /passive /nosplash /noeula /clean /noreboot
			#Write-Host "& "$PSScriptRoot\PsExec64.exe" \\$_ C:\$kopierterordner\setup.exe /passive /nosplash /noeula /clean /noreboot"
			Write-Host "Die Installation mit PsExec64 wurde auf $_ abgeschlossen."			

			#Lösche Grafikkartentreiber
			Remove-Item -Path "\\$_\c$\$kopierterordner" -Recurse -Force
			Write-Host "Der Ordner '$kopierterordner' wurde auf $_ gelöscht."
			Write-Host ""
		} Else {
			Write-Host "$_ ist nicht eingeschaltet bzw. erreichbar." -ForegroundColor Yellow
			Write-Host ""
		}
	}
} Else  {
	#Prüfung ist fehlgeschlagen. Ausgabe erfolgt.
	Write-Host "Es wurde eine wichtige Datei bzw. Ordner nicht gefunden. Bitte Parameter kontrollieren." -ForegroundColor Red
	Write-Host "Computerliste: $computerliste | Prüfungsergebnis: $checkpath_liste" -ForegroundColor Red
	Write-Host "Grafiktreiberordner: $grafiktreiberordner | Prüfungsergebnis: $checkpath_ordner" -ForegroundColor Red
	Write-Host "Grafiktreiberdatei: $grafiktreiberdatei | Prüfungsergebnis: $checkpath_datei" -ForegroundColor Red
	Write-Host "PsExec64 (aus Sysinternals PsTools) im selben Ordner | Prüfungsergebnis: $checkpath_PsExec" -ForegroundColor Red
	Write-Host ""
	Write-Host ""
	$script:erroravailable = 1
}

#Informationsblock Ende
Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Gray
Write-Host "Abschluss $scriptname Script Ver. $ver, $verdate" -ForegroundColor Gray
Write-Host "...beendet am $(get-date -uformat "%d.%m.%Y") um $(get-date -uformat "%R") Uhr."  -ForegroundColor Gray
Write-Host "==========================================================================" -ForegroundColor Gray
Write-Host ""


#Kontrolle ob Logfile existiert und gespeichert wird
Stop-Transcript
if (Test-Path $tmplogfile) {

	#Kontrolle ob Logfile gespeichert werden soll.
    if ($Args[2] -eq "Save") {
        Get-Content "$tmplogfile" >>"$logfile"
    }
    Remove-Item -Path "$tmplogfile" -Force
}