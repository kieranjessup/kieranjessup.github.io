---
title: Searching for IOCs - Volt Typhoon/Vanguard Panda
author: Kieran
pubDatetime: 2024-11-17
slug: threat-hunt-volt-typhoon
featured: true
draft: false
tags:
  - windows
  - blue
  - vanguard panda
  - volt typhoon
ogImage: ""
description: searching for indicators of compromise using known Volt Typhoon TTPs
---

### To Do

1. create script to push VT TTPs through blue.lab
   1. PurpleSharp.exe can do this;
2. map ttps
3. dashboard them in splunk, check detections in Falcon
4. 27/11/2024, check Atomics for Vanguard Panda/Volt Typhoon
   1. use; https://research.splunk.com/stories/volt_typhoon/?query=vol
5. finish this post

```

# Testing PurpleSharp

PS C:\Users\root\Downloads> .\PurpleSharp_x64.exe /rhost DC01 /ruser purple.sharp /rpwd <redacted> /d blue.lab /t T1059.001,T1059.003, T1053.005, T1569.002
[+] Uploading and executing the Scout on \\DC01\C$\Windows\Temp\Scout.exe
[+] Connecting to the Scout ...
[+] OK
[!] Recon -> Identified logged user: BLUE\kieran.jessup
[+] Uploading Simulator to \\DC01\C$\Users\kieran.jessup\Downloads\Firefox_Installer.exe
[+] Triggering simulation using PPID Spoofing | Process: explorer.exe | PID: 1736 | High Integrity: False
[+] Results:

11/20/2024 03:18:26 [*]  Starting T1059.001 Simulation on DC01
11/20/2024 03:18:26 [*]  Simulator running from C:\Users\kieran.jessup\Downloads\Firefox_Installer.exe with PID:4960 as BLUE\kieran.jessup
11/20/2024 03:18:26 [*]  Using the command line to execute the technique
11/20/2024 03:18:26 [*]  Using the Win32 API call CreateProcess to execute: 'powershell.exe -enc UwB0AGEAcgB0AC0AUwBsAGUAZQBwACAALQBzACAAMgAwAA=='
11/20/2024 03:18:26 [*]  Process successfully created. (PID): 316
11/20/2024 03:18:26 [*]  Simulation Finished
11/20/2024 03:18:26 [*]  Playbook Finished

[+] Cleaning up...
[+] Deleting \\DC01\C$\Windows\Temp\Scout.exe
[+] Deleting \\DC01\C$\Windows\Temp\0001.dat
[+] Deleting \\DC01\C$\Users\kieran.jessup\Downloads\Firefox_Installer.exe
[+] Deleting \\DC01\C$\Users\kieran.jessup\Downloads\0001.dat

# Testing Atomics

PS C:\users\root\Desktop> $sess = New-PSSession -ComputerName DC01 -Credential BLUE\kieran.jessup
PS C:\users\root\Desktop> Invoke-AtomicTest T1505.004 -Session $sess
PathToAtomicsFolder = C:\AtomicRedTeam\atomics
Executing test: T1505.004-1 Install IIS Module using AppCmd.exe
MODULE object "DefaultDocumentModule_Atomic" added
GLOBAL MODULE object "DefaultDocumentModule_Atomic" added
Exit code: 0
Done executing test: T1505.004-1 Install IIS Module using AppCmd.exe
Executing test: T1505.004-2 Install IIS Module using PowerShell Cmdlet New-WebGlobalModule
Done executing test: T1505.004-2 Install IIS Module using PowerShell Cmdlet New-WebGlobalModule

```