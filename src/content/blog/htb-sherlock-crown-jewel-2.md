---
title: HTB Sherlock - Crown Jewel 2
author: Kieran
pubDatetime: 2025-01-09
slug: htb-sherlock-crown-jewel-2
featured: true
draft: false
tags:
  - blue
  - sherlock
  - htb
ogImage: ""
description: A walkthrough of the HTB sherlock - crown jewel 2
---

For this challenge we are given 3 evtx files to review;

```
PS F:\Sherlocks\Crown-Jewel-2> ls


    Directory: F:\Sherlocks\Crown-Jewel-2


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        15/05/2024   3:41 PM        1118208 APPLICATION.evtx
-a----        15/05/2024   3:41 PM        1118208 SECURITY.evtx
-a----        15/05/2024   3:42 PM        1118208 SYSTEM.evtx
```

**Task 1) When utilizing ntdsutil.exe to dump NTDS on disk, it simultaneously employs the Microsoft Shadow Copy Service. What is the most recent timestamp at which this service entered the running state, signifying the possible initiation of the NTDS dumping process?**

For us to answer this question, we'll need to know which event ID is used when a service is started in Windows. The event ID is 7036 and this is logged into the SYSTEM logs. There are numerous ways you can review evtx files. You can use powershell, import them into event viewer or use tools such as chainsaw.

https://github.com/WithSecureLabs/chainsaw

I decided to use powershell as I'm trying to upskill in this area, using powershell we can review the evtx files as so;

```
PS F:\Sherlocks\Crown-Jewel-2> Get-WinEvent -Path ".\SYSTEM.evtx" | Where-Object { $_.Id -eq 7036 -and $_.Message -match "volume shadow copy"} | Select-Object @{Name="TimeCreatedUTC";Expression={$_.TimeCreated.ToUniversalTime()}},id,message

TimeCreatedUTC          Id Message
--------------          -- -------
15/05/2024 5:39:55 AM 7036 The Volume Shadow Copy service entered the running state.
15/05/2024 5:38:29 AM 7036 The Volume Shadow Copy service entered the stopped state.
15/05/2024 5:35:29 AM 7036 The Volume Shadow Copy service entered the running state.
```
I was stuck a while here as I did not realise UTC time was required.

This gives us the answer to Task 1: `2024-05-15 05:39:55`

**On-Going**