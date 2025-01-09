---
title: HTB Sherlock - Brutus
author: Kieran
pubDatetime: 2025-01-09
slug: htb-sherlock-brutus
featured: true
draft: false
tags:
  - htb
  - blue
  - sherlock
ogImage: ""
description: My experience with the HTB Sherlock, Brutus.
---

For this challenge we are given a zip file containing 2 files;

Contents of brutus.zip
```
┌──(root㉿monster)-[/mnt/f/sherlocks/brutus]
└─# ls
auth.log  wtmp
```

The `auth.log` file is a log file found in Unix-like operating systems, typically located in the /var/log directory. It records authentication-related events such as login attempts, sudo actions, and service authentications.

The `wtmp` file is a binary log file in Unix-like systems that records login sessions, logout events, and system boots or shutdowns.

```
┌──(root㉿monster)-[/mnt/f/sherlocks/brutus]
└─# utmpdump wtmp | grep 65.2.161.68
Utmp dump of wtmp
[7] [02549] [ts/1] [root    ] [pts/1       ] [65.2.161.68         ] [65.2.161.68    ] [2024-03-06T06:32:45,387923+00:00]
[7] [02667] [ts/1] [cyberjunkie] [pts/1       ] [65.2.161.68         ] [65.2.161.68    ] [2024-03-06T06:37:35,475575+00:00]
```