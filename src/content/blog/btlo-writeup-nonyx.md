---
title: BTLO Writeup - Nonyx
author: Kieran
pubDatetime: 2024-11-21
slug: btlo-writeup-nonyx
featured: true
draft: false
tags:
  - btlo
  - blue
  - T1014
ogImage: ""
description: In this post we detail the investigation Nonyx from Blue Team Labs Online
---

![BTLO Nonyx](@assets/images/btlo-writeup-nonyx.png)

After booting into the investigation, we can see on the desktop we have a note (README), a .vnem file named BlackEnergy and a folder named [Volatility](https://volatilityfoundation.org/). 

![Readme](@assets/images/btlo-writeup-nonyx-readme.png)

The README indicates which profile we should use when running volatility, lets jump in.

```
python vol.py -f ../BlackEnergy.vnem --profile=WinXPSP2x86 malfind
```

After executing the above command we're given the some output to review, looking at each of the processes returned we find one that stands out with MZ in the magic bytes (4d 5a) [EXE](https://en.wikipedia.org/wiki/DOS_MZ_executable)


```
Process: svchost.exe Pid: 856 Address: 0xc30000
Vad Tag: VadS Protection: PAGE_EXECUTE_READWRITE
Flags: CommitCharge: 9, MemCommit:1, PrivateMemory: 1, Protection 6

0x0000000000c30000  4d 5a 90 00 03 00 00 00 04 00 00 00 ff ff 00 00   MZ..............
```

From this we can extract the answer to question 1.

Q1) Which process most likely contains injected code, providing its name, PID, and memory address? (Format: Name, PID, Address)

```
svchost.exe, 856, 0xc30000
```



