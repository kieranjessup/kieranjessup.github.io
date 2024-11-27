---
title: blue.lab
author: Kieran
pubDatetime: 2023-12-12
slug: blue-lab
featured: true
draft: false
tags:
  - learning
  - blue
ogImage: ""
description: A small lab to test blue team activity for self learning
---

![something](@assets/images/blue-lab-updated.png)

- SP01 = Splunk Server
- DC01 = Domain Controller
  - DC01 now has CrowdStrike Falcon EDR
  - DC01 now running IIS, running all services on one system to limit sensor deployment for testing ($)
- Added Red Box, used to send AtomicTests into DC01
