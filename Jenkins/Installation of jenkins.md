
## 🔹 Step 1: Connect to your EC2

`ssh -i your-key.pem ec2-user@<EC2-Public-IP>`

---

## 🔹 Step 2: Update system packages

`sudo yum update -y   # for AL2 # OR sudo dnf update -y   # for AL2023`

---

## 🔹 Step 3: Install Java (Jenkins needs Java 11 or higher)

For **Amazon Linux 2**:

`sudo amazon-linux-extras enable corretto11 sudo yum install -y java-11-amazon-corretto`

For **Amazon Linux 2023**:

`sudo dnf install -y java-17-amazon-corretto`

Check Java:

`java -version`

---

## 🔹 Step 4: Add Jenkins repo & install Jenkins

### For both AL2 & AL3:

`sudo wget -O /etc/yum.repos.d/jenkins.repo \     https://pkg.jenkins.io/redhat-stable/jenkins.repo  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key`

### Install Jenkins

- On **AL2**:
    

`sudo yum install -y jenkins`

- On **AL2023**:
    

`sudo dnf install -y jenkins`

---

## 🔹 Step 5: Start & enable Jenkins service

`sudo systemctl enable jenkins sudo systemctl start jenkins sudo systemctl status jenkins`

---

## 🔹 Step 6: Open firewall / security group

Allow Jenkins default port **8080** in your EC2 Security Group:

- Inbound Rule → Custom TCP → Port **8080** → Source: 0.0.0.0/0 (or restrict to your IP)
    

---

## 🔹 Step 7: Get Jenkins admin password

`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

Copy this password → Open Jenkins in browser:  
`http://<EC2-Public-IP>:8080`

---


Ah! Let’s break this down carefully — port forwarding is actually pretty simple once you understand the concept, and it’s super handy when direct access is blocked.

---

## **1️⃣ What is Port Forwarding?**

Port forwarding is a way to **tunnel network traffic from one machine to another through a specific port**.

- It allows you to **access a service** running on a remote machine (like Jenkins on EC2) **through a local port** on your machine.
    
- Think of it as a “secure pipe” from your computer to the remote server.
    

---

## **2️⃣ How it works (SSH example)**

Suppose:

- Jenkins is running on your EC2 instance on **port 8080**.
    
- Your company firewall blocks direct access to port 8080.
    

You can use **SSH port forwarding**:

```bash
ssh -i your-key.pem -L 8888:localhost:8080 ec2-user@<EC2-Public-IP>
```

Breaking this down:

|Part|Meaning|
|---|---|
|`-L`|Local port forwarding|
|`8888`|Port on **your local machine** you’ll use to access Jenkins|
|`localhost:8080`|**Destination** on the EC2 machine — Jenkins is listening here|
|`ec2-user@<IP>`|SSH login to your EC2 instance|

---

### **Step-by-step flow**

1. You open your browser on **localhost:8888**.
    
2. Your computer sends the traffic into the SSH tunnel.
    
3. SSH forwards it to **localhost:8080** on the EC2 instance.
    
4. Jenkins responds, and the SSH tunnel sends the data back to your browser.
    

Effectively, it **looks like Jenkins is running on your local machine**, but it’s actually on the remote server.

---

## **3️⃣ Why it’s useful**

- Access **blocked ports** securely without changing firewall rules.
    
- Encrypts traffic (SSH tunnel is secure).
    
- Can forward **any TCP service**, not just Jenkins.
    

---

💡 Analogy: Think of it as sending a **letter through a trusted courier** (SSH tunnel) instead of putting it directly in the mailbox (blocked port). The letter reaches the destination safely and comes back with the reply.

---

If you want, I can draw a **small diagram showing local machine → SSH tunnel → EC2 → Jenkins**. It makes the concept much easier to visualize. Do you want me to do that?