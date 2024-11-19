---
title: EventID 4624
author: Kieran
pubDatetime: 2024-01-01
slug: event-id-4624
featured: true
draft: false
tags:
  - windows
  - blue
ogImage: ""
description: EventID 4624 General Info
---

# Event ID 4624: Successful Account Logon

Event ID 4624 is a Windows Security event that records successful account logons. It is commonly used for monitoring authentication activities and identifying potential unauthorized access.

---

## **Logon Types in Event ID 4624**

### **Logon Type 2: Interactive**
- **Description**: A user logged on directly to the system, usually at the console (keyboard, mouse, or remote desktop using the console session).
- **Use Case**: Physical user access or administrator login.

---

### **Logon Type 3: Network**
- **Description**: A user or computer logged on over the network.
- **Use Case**: Accessing shared folders, printers, or connecting to a server via SMB.

---

### **Logon Type 4: Batch**
- **Description**: Logon for batch-processing tasks.
- **Use Case**: Scheduled tasks or scripts running under a specific account.

---

### **Logon Type 5: Service**
- **Description**: Service account logon.
- **Use Case**: Services configured to run under a particular user account.

---

### **Logon Type 7: Unlock**
- **Description**: A user unlocked a workstation.
- **Use Case**: Resuming work after the lock screen.

---

### **Logon Type 8: Network Cleartext**
- **Description**: A user logged on with credentials sent in clear text over the network.
- **Use Case**: Outdated or insecure authentication mechanisms.

---

### **Logon Type 9: New Credentials**
- **Description**: A process logged on with explicit credentials using the `LogonUser` API.
- **Use Case**: Impersonation or running a process under different credentials.

---

### **Logon Type 10: Remote Interactive**
- **Description**: Remote Desktop Protocol (RDP) session logon.
- **Use Case**: Remote desktop or terminal services.

---

### **Logon Type 11: Cached Interactive**
- **Description**: Cached credentials were used to log on.
- **Use Case**: Offline authentication, such as a laptop user logging in while disconnected from a domain.

---

## **Key Fields in Event 4624**
- **Subject**: The account initiating the logon.
- **Logon Information**: Includes the `Logon Type`, `Account Name`, and `Workstation Name`.
- **Network Information**: Details the source IP address and port, useful for identifying the origin of a logon attempt.
- **Logon Process**: Indicates the authentication protocol (e.g., `Kerberos` or `NTLM`).

---

## **Security Use Cases**
Monitoring Event ID 4624 and its logon types is essential for:
- **Detecting unauthorized access**: Identify unusual or suspicious logon attempts.
- **Investigating patterns**: Look for excessive RDP logons (`Type 10`) or outdated mechanisms (`Type 8`).
- **Forensic analysis**: Use detailed fields to trace security incidents.
- **Ensuring compliance**: Maintain logs for auditing and security reviews.

---

## test code in blog

```
index=main sourcetype="WinEventLog:Security" EventCode=4624
```