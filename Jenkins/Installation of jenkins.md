### **JENKINS INSTALLATION ON AMAZON LINUX 2 / AMAZON LINUX 2023**

---

### **1. Update your instance**

```
sudo yum update -y
```
### **2. Install Java 17 (required by Jenkins)**
```
sudo dnf install -y java-17-amazon-corretto
```

✅ Verify installation:

`java -version`

You should see something like:

 `openjdk version "17.x.x" 2024-...`
### **3. Add Jenkins repository and import the key**
```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

### **4. Install Jenkins**

```
sudo dnf install -y jenkins
```
### 5. Enable Jenkins to start on boot

```
sudo systemctl enable jenkins
```
### **6. Start Jenkins service**

```
sudo systemctl start jenkins
```
### 7. Check Jenkins status
```
sudo systemctl status jenkins
```
### **8. Open port 8080 in Security Group**

In AWS Console:

- Go to **EC2 → Security Groups → Inbound rules → Edit inbound rules**
    
- Add a new rule:

```
Type: Custom TCP
Port range: 8080
Source: 0.0.0.0/0
```

### **9. Get Jenkins unlock password**
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 10. Access Jenkins in browser
```
http://<your-ec2-public-ip>:8080
```

##  **JENKINS INSTALLATION ON UBUNTU 20.04 / 22.04 / 24.04**
---
### **1. Update packages**
```
sudo apt update -y && sudo apt upgrade -y
```
### 2. Install Java 17
```
sudo apt install -y openjdk-17-jdk
```
✅ Verify:

`java -version`
### 3. Add Jenkins repository key
```
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

```
### 4. Add Jenkins repo
```
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

### 5. Update apt and install Jenkins
```
sudo apt update -y
sudo apt install -y jenkins
```

### 6. Enable Jenkins to start on boot
```
sudo systemctl enable jenkins
```

### 7. Start Jenkins
```
sudo systemctl start jenkins
```

### **8. Check Jenkins service status**
```
sudo systemctl status jenkins
```

### 9. Allow Jenkins port (if UFW firewall is enabled)
```
sudo ufw allow 8080
sudo ufw reload
```

### 10. Get Jenkins initial password

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

```

### **11. Access Jenkins**

In your browser:
```
http://<your-ec2-public-ip>:8080
```

- Enter the password
    
- Install suggested plugins
    
- Create admin user
    

✅ Jenkins setup complete on **Ubuntu**.

---

## What is Port Forwarding?


👉 **Port forwarding** means **redirecting network traffic** from one computer’s port to another computer’s port.

It’s like saying:

> “Hey, when I (your laptop) send data to port 8080, please forward it to port 8080 on that EC2 instance.”

So, even if the EC2’s port is blocked or not open publicly, you can still reach it _through the SSH tunnel._

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