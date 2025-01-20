---
title: HTB Sherlock - Loggy
author: Kieran
pubDatetime: 2025-01-20
slug: htb-sherlock-loggy
featured: true
draft: true
tags:
  - blue
  - sherlock
  - htb
  - malware analysis
ogImage: ""
description: A walkthrough of the HTB sherlock - Loggy
---

For this exercise we are given a zip file containing the malware that requires analysis;

**Task 1) What is the SHA-256 hash of this malware binary?**

```
PS C:\Users\root\Documents\htb sherlocks > Get-FileHash -Algorithm SHA256 .\Loggy.exe

Algorithm       Hash                                                                   Path
---------       ----                                                                   ----
SHA256          6ACD8A362DEF62034CBD011E6632BA5120196E2011C83DC6045FCB28B590457C       C:\Users\root\Documents\htb s...
```

The answer for task 1 is: `6ACD8A362DEF62034CBD011E6632BA5120196E2011C83DC6045FCB28B590457C`
