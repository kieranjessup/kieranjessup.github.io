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

**Q1) Which process most likely contains injected code, providing its name, PID, and memory address? (Format: Name, PID, Address)**

```
svchost.exe, 856, 0xc30000
```

**Q2) What dump file in the malfind output directory corresponds to the memory address identified for code injection? (Format: Output File Name)**

To help us find this, we can try;

```
python vol.py -f ../BlackEnergy.vnem --profile=WinXPSP2x86 malfind -h | grep dump
Volatility Foundation Volatility Framework 2.6.1
  -D DUMP_DIR, --dump-dir=DUMP_DIR
            
```

Now we can execute;

```
mkdir outputs && python vol.py -f ../BlackEnergy.vnem --profile=WinXPSP2x86 malfind --dump-dir=outputs/
```



```
ubuntu@ip-10-0-10-204:~/Desktop/volatility/$ cd outputs
ubuntu@ip-10-0-10-204:~/Desktop/volatility/outputs$ ls
process.0x80ff88d8.0xc30000.dmp    process.0xff1ec978.0x33470000.dmp  process.0xff1ec978.0x71ee0000.ee0000.dmp process.0xff1ec978.0x793e0000.dmp
```

Looking at each of the .dmps, the memory address from Question 1 is in the filename: ```process.0x80ff88d8.0xc30000.dmp ```

**Q3) Which full filename path is referenced in the strings output of the memory section identified by malfind as containing a portable executable (PE32/MZ header)? (Format: Filename Path)**

If we run [strings](https://linux.die.net/man/1/strings) on the abovementioned .dmp file we should be able to review the output and find the filename;

```
ubuntu@ip-10-0-10-204:~/Desktop/volatility/outputs$ strings process.0x80ff88d8.0xc30000.dmp
******
xBILLY-DB5B96DD3_CC41CD50
C:\WINDOWS\system32\drivers\str.sys
3L3\3b3r3|3
******
```
```C:\WINDOWS\system32\drivers\str.sys```






