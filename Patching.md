### ⚙️ **Typical Steps for Patching a Linux Server**

#### **1️⃣ SSH into the server**

`ssh -i "your-key.pem" ec2-user@<public-ip>`

---

#### **2️⃣ Switch to root (if needed)**

`sudo su -`

---

#### **3️⃣ Check the current OS release**

Useful to verify what OS version is running before patching.

`cat /etc/os-release`

---

#### **4️⃣ List current versions of key packages (optional pre-check)**

If you want to see what’s currently installed:

`rpm -qa | sort     # for RHEL/Amazon Linux/CentOS`

or

`dpkg -l            # for Ubuntu/Debian`

You can also check a specific package:

`rpm -qa | grep <package-name>`

---

#### **5️⃣ Clean old cache (optional but good practice)**

`yum clean all`

or for newer versions:

`dnf clean all`

---

#### **6️⃣ Update the package list and apply patches**

For **Amazon Linux / RHEL / CentOS**:

`yum update -y`

or

`dnf update -y`

For **Ubuntu/Debian**:

`apt update && apt upgrade -y`

> ⚠️ The `-y` flag automatically confirms updates.  
> For critical servers, omit `-y` first and review what’s being updated.

---

#### **7️⃣ (Optional) Apply security patches only**

Amazon Linux:

`yum update-minimal --security -y`

Ubuntu:

`apt-get install unattended-upgrades unattended-upgrade`

---

#### **8️⃣ Reboot if kernel or major libraries updated**

Check if a reboot is required:

`needs-restarting -r      # Amazon Linux/RHEL`

or

`sudo reboot`

---

#### **9️⃣ Verify after reboot**

Check uptime and kernel version:

`uname -r`

Make sure your services are running fine:

`systemctl status <service-name>`

---

#### **10️⃣ Record the patch status**

Log OS version again:

`cat /etc/os-release`

and optionally save a list of updated packages:

`rpm -qa --last | head`

---

### ✅ **Summary (Quick version)**

|Step|Command|Purpose|
|---|---|---|
|1|`ssh`|Connect to server|
|2|`sudo su -`|Become root|
|3|`cat /etc/os-release`|Check OS|
|4|`rpm -qa` / `dpkg -l`|List installed packages|
|5|`yum clean all`|Clean cache|
|6|`yum update -y`|Apply patches|
|7|`reboot`|Restart if needed|
|8|`uname -r`|Verify new kernel|
|9|`systemctl status`|Check service health|