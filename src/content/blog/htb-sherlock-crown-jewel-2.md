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

**Task 2) Identify the full path of the dumped NTDS file.**

```
PS F:\Sherlocks\Crown-Jewel-2> Get-WinEvent -Path .\APPLICATION.evtx | Where-Object {($_.Id -eq 325 -or $_.Id -eq 327) } | Select-Object timecreated,id,message

TimeCreated            Id Message
-----------            -- -------
15/05/2024 3:39:58 PM 327 NTDS (3940,D,100) The database engine detached a database (1, C:\$SNAP_202405151039_VOLUMEC$\Windows\NTDS\ntds.dit). (Time=0 seconds) ...
15/05/2024 3:39:58 PM 327 NTDS (3940,D,100) The database engine detached a database (2, C:\Windows\Temp\dump_tmp\Active Directory\ntds.dit). (Time=0 seconds) ...
15/05/2024 3:39:56 PM 325 NTDS (3940,D,100) The database engine created a new database (2, C:\Windows\Temp\dump_tmp\Active Directory\ntds.dit). (Time=0 seconds) ...
14/05/2024 2:01:50 PM 325 DFSRs (7344,D,35) \\.\C:\System Volume Information\DFSR\database_72E6_EF45_E6EF_865\dfsr.db: The database engine created a new database (1, \\.\C:\System Volume Information\DFSR\database...
9/03/2023 8:25:32 PM  325 svchost (1676,D,35) DS_Token_DB: The database engine created a new database (1, C:\Windows\system32\config\systemprofile\AppData\Local\DataSharing\Storage\DSTokenDB2.dat). (Time=0 second...
8/03/2023 9:05:39 PM  325 DFSRs (2328,D,35) \\.\C:\System Volume Information\DFSR\database_72E6_EF45_E6EF_865\dfsr.db: The database engine created a new database (1, \\.\C:\System Volume Information\DFSR\database...
```

This gives us the answer to Task 2: ` C:\Windows\Temp\dump_tmp\Active Directory\ntds.dit`


**Task 3) When was the database dump created on the disk?**
We can get retrieve the time the dump was created by using the above query ensuring we convert the time to UTC;
```
PS F:\Sherlocks\Crown-Jewel-2> Get-WinEvent -Path .\APPLICATION.evtx | Where-Object {($_.Id -eq 325 -or $_.Id -eq 327) } | Select-Object @{Name="TimeCreatedUTC";Expression={$_.TimeCreated.ToUniversalTime()}},id,message | findstr "created"
15/05/2024 5:39:56 AM 325 NTDS (3940,D,100) The database engine created a new database (2, C:\Windows\Temp\dump_tmp\Active
```

From the output, we can see the creation of a new database relating to the NTDS.

The answer for task 3: `2024-05-15 05:39:56`


**Task 4) When was the newly dumped database considered complete and ready for use**

Once the database has detached it is ready for use, using the same method as above we can review the existing output or trim it down to just detachments as below;

```
PS F:\Sherlocks\Crown-Jewel-2> Get-WinEvent -Path .\APPLICATION.evtx | Where-Object {($_.Id -eq 325 -or $_.Id -eq 327) } | Select-Object @{Name="TimeCreatedUTC";Expression={$_.TimeCreated.ToUniversalTime()}},id,message | findstr "detached"
15/05/2024 5:39:58 AM 327 NTDS (3940,D,100) The database engine detached a database (1, C:\$SNAP_202405151039_VOLUMEC$\Win...
15/05/2024 5:39:58 AM 327 NTDS (3940,D,100) The database engine detached a database (2, C:\Windows\Temp\dump_tmp\Active Di...
```

The answer for task 4: `2024-05-15 05:39:58`


**Task 4) Event logs use event sources to track events coming from different sources. Which event source provides database status data like creation and detachment?**

To get the source using powershell, we can use `Get-WinEvent` and pull the `providername` from the output as follows;

```
PS F:\Sherlocks\Crown-Jewel-2> Get-WinEvent -Path .\APPLICATION.evtx | Where-Object {($_.Id -eq 325 -or $_.Id -eq 327) } | Select-Object ProviderName,id,message

ProviderName  Id Message
------------  -- -------
ESENT        327 NTDS (3940,D,100) The database engine detached a database (1, C:\$SNAP_202405151039_VOLUMEC$\Windows\NTDS...
ESENT        327 NTDS (3940,D,100) The database engine detached a database (2, C:\Windows\Temp\dump_tmp\Active Directory\n...
ESENT        325 NTDS (3940,D,100) The database engine created a new database (2, C:\Windows\Temp\dump_tmp\Active Director...
ESENT        325 DFSRs (7344,D,35) \\.\C:\System Volume Information\DFSR\database_72E6_EF45_E6EF_865\dfsr.db: The database...
ESENT        325 svchost (1676,D,35) DS_Token_DB: The database engine created a new database (1, C:\Windows\system32\confi...
ESENT        325 DFSRs (2328,D,35) \\.\C:\System Volume Information\DFSR\database_72E6_EF45_E6EF_865\dfsr.db: The database...
```

The answer for Task 5 is: `ESENT`.

