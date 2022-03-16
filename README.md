<h1 align="center">
  <a href="https://blackseals.net">
    <img src="https://blackseals.net/features/blackseals.png" width=66% alt="BlackSeals">
  </a>
</h1>

> Promoted development by BlackSeals.net Technology.
> Written by Andyt for BlackSeals.net.
> Copyright 2018-2022 by BlackSeals Network.

## Description

**run_nvidia-driver-setup.ps1** is a Windows PowerShell script that will install nvidia driver to several windows clients through network.


## Requirement

* **[PsExec v2.34 and newer](https://docs.microsoft.com/de-de/sysinternals/downloads/psexec)** from PSTools.
* **"PSExec64.exe"** should be in the same folder as the script file.

 
## Quick Start

Download the script and copy **run_nvidia-driver-setup.ps1** to the folder which contains "PSExec64.exe". Look to Requirement for more information. Additional download gpu driver from nvidia - Geforce or Quadro - it work both. Extract the downloaded driver setup to a folder.


## Syntax

`.\run_nvidia-driver-setup.ps1 *csv file with computer names* *folder with extracted gpu driver*`
* **csv file with computer names** is a csv-file which contains FQDN or NetBIOS names for all computer, which should get the driver.
* **folder with extracted gpu driver** is the folder which contains the extracted download Nvidia driver file. To extract the setup, the downloaded Nvidia driver setup can be started on any computer. This will automatically extract itself to the Windows partition (usually "C:\") in the folder "Nvidia". Simply copy the latest parent folder (usually "International") where the "setup.exe" can be found to another directory. The Nvidia driver setup removes the extracted files.


## Examples

`.\run_nvidia-driver-setup.ps1 .\Computer.csv .\Nvidia`
* Using csv-file from the same folder as the script.
* The extracted Nvidia driver setup will be in a subfolder called "Nvidia".
* There is no logfile after finishing the process.

`.\run_nvidia-driver-setup.ps1 C:\Liste.csv "C:\Nvidia"`
* Using csv-file from the C:\. If the path contains space, then use quotes.
* The extracted Nvidia driver setup will be on C:\. If the path contains space, then use quotes.
* There is no logfile after finishing the process.

`.\run_nvidia-driver-setup.ps1 Computer.csv .\Nvidia Save`
* Using csv-file from the same folder as the script.
* The extracted Nvidia driver setup will be in a subfolder called "Nvidia".
* There is a logfile after finishing the process. You find it at your temporary user folder: $env:temp (Powershell) or %temp% (Explorer, Command Shell).

