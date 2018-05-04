﻿# build.ps1: Build script for Z-code interpreter Ozmoo
# 
# Usage:
# build.ps1 -Type z3           Build a disk image with a z3 story and the v3 terp
# build.ps1 -Type z5 -Run      Build a disk image with a z5 story and the v5 terp, then execute in Vice
# build.ps1                    -Type defaults to z5. Vice is not run.


param (
    [string]$Type = "z5",
    [switch]$UseVmem = $false,
    [switch]$Run = $false
)

# File paths. Adapt to your system.

[string] $acmeExe = "C:\ProgramsWoInstall\Acme\acme.exe"
[string] $c1541Exe = "C:\ProgramsWoInstall\WinVICE-3.1-x64\c1541.exe"
[string] $viceExe = "C:\ProgramsWoInstall\WinVICE-3.1-x64\x64.exe"

[string] $upperType = $type.ToUpper();
[string] $diskImage;

function BuildImage([string]$type, [bool]$useVmem) {
	
	[string] $useVmemOption = ""
	if($useVmem) {
		$useVmemOption = "-DUSEVM=1"
	}
    & $acmeExe ("-D"+$type+"=1") $useVmemOption -DDEBUG=1 --cpu 6510 --format cbm --outfile ozmoo -l acme_labels.txt ozmoo.asm
    if($lastExitCode -ne 0) {
        exit
    }           
    copy -Force d64toinf/$diskImage $diskImage
    if($lastExitCode -ne 0) {
        exit
    }           
    & $c1541Exe -attach $diskImage -write ozmoo ozmoo
    if($lastExitCode -ne 0) {
        exit
    }           
    Write-Output ("Successfully built disk image " + $diskImage)  
}

################
# Main program #
################

if($upperType -eq 'Z3') {
    $diskImage = 'dejavu.d64'
} elseif($upperType -eq 'Z5') {
    $diskImage = 'dragontroll.d64'
} else {
    Write-Error "Error: Type can only be z3 or z5"
    exit
}

BuildImage -type $upperType -useVmem $UseVmem

if($Run) {
    Write-Output 'Launching Vice...'
    & $viceExe $diskImage
}
