## **Linux Kernel**

**What is the Linux Kernel?**

- The **kernel** is the **core of the Linux operating system**.
    
- Acts as a **bridge between hardware and user applications**.
    
- Responsible for managing:
    
    - **Processes** 🧠
        
    - **Memory**
        
    - **Devices** 🎧📱
        
    - **File systems** 📁
        
    - **Networking** 🌐
        

**Checking Kernel Information:**

```
uname -r        # Display kernel version 
uname -a        # Show complete system information 
cat /proc/version  # Detailed kernel version info

```
**Updating the Kernel (Ubuntu/Debian):**

```
sudo apt update && apt list --upgradable | grep linux-image  # Check kernel updates
sudo apt install linux-image-generic                        # Upgrade kernel

```
---

## **2️⃣ Working with Hardware**

### **Device Files in Linux**

- Linux represents hardware as **files in /dev/**.
    
- **Character Devices** – handle data **one character at a time** (e.g., `/dev/tty` for terminals).
    
- **Block Devices** – handle data **in blocks** (e.g., `/dev/sda` for storage devices).
    

### **Checking Hardware Information**
```
lscpu      # Display CPU details
lsblk      # Show storage devices and partitions
lspci      # List PCI devices (graphics, network cards)
lsusb      # List connected USB devices
df -h      # Show disk space usage
free -m    # Display RAM usage in MB

```

### **Managing Devices**
```
sudo mount /dev/sdb1 /mnt       # Mount device at /mnt
sudo umount /mnt                # Unmount device
sudo modprobe <module_name>     # Load a kernel module
sudo rmmod <module_name>        # Remove a kernel module

```

## **Linux Boot Process**

**Steps in Booting Linux:**

| Step                                            | Description                                     |
| ----------------------------------------------- | ----------------------------------------------- |
| **1. BIOS/UEFI**                                | Initializes hardware and loads the bootloader.  |
| **2. Bootloader (GRUB, LILO, Syslinux, etc.)**  | Loads the Linux kernel into memory.             |
| **3. Kernel Initialization**                    | Detects hardware, mounts root filesystem.       |
| **4. Init System (Systemd, SysVinit, Upstart)** | Starts essential system processes and services. |
| **5. Runlevel / Target Execution**              | Loads user processes and additional services.   |
Checking Boot Information:

```
dmesg | less          # Show boot messages
journalctl -b         # View system logs from last boot
cat /var/log/syslog    # Check system boot logs

```

## **Runlevels (SysVinit) and Systemd Targets**

### **SysVinit Runlevels**

|Runlevel|Description|
|---|---|
|0|Shutdown 🔴|
|1|Single-user mode 🔧|
|2|Multi-user mode (No networking)|
|3|Multi-user mode (With networking) 🌐|
|4|Unused / Custom ⚙|
|5|Graphical mode (GUI) 🎨|
|6|Reboot 🔄|

**Check & Change Runlevel (SysVinit):**
```
runlevel           # Check current runlevel
sudo init 3        # Change to runlevel 3 (multi-user mode)

```

### **Systemd Targets (Modern Systems)**

|Systemd Target|Equivalent Runlevel|
|---|---|
|poweroff.target|0 (Shutdown)|
|rescue.target|1 (Single-user mode)|
|multi-user.target|3 (Multi-user mode)|
|graphical.target|5 (Graphical mode)|
|reboot.target|6 (Reboot)|

**Managing Systemd Targets:**

`systemctl get-default                      # Check current default target sudo systemctl set-default multi-user.target # Set default target sudo systemctl isolate graphical.target     # Switch to a specific target temporarily`

---

## **6️⃣ Linux File Types**

|File Type|Description|Example|
|---|---|---|
|Regular File|Normal text, binary, or script|`/etc/passwd`|
|Directory|Folder containing files|`/home/user/`|
|Symbolic Link|Shortcut to another file|`/usr/bin/python -> /usr/bin/python3`|
|Character Device|Reads/writes one character at a time|`/dev/tty`|
|Block Device|Reads/writes data in blocks|`/dev/sda`|
|Named Pipe|Inter-process communication|`/tmp/mypipe`|
|Socket|Network communication endpoint|`/var/run/docker.sock`|

**Checking File Types:**

```
ls -l               # Display file types in directory
file /dev/sda        # Check type of a specific file

```

**Example output of `ls -l`:**

`-rw-r--r-- 1 user user 1024 Mar 07 12:00 file.txt   # Regular file drwxr-xr-x 2 user user 4096 Mar 07 12:00 mydir/    # Directory lrwxrwxrwx 1 user user 10 Mar 07 12:00 link -> file.txt # Symbolic link`

---

✅ **Tip:**

- In `ls -l` output:
    
    - `-` → Regular file
        
    - `d` → Directory
        
    - `l` → Symbolic link
        
    - `c` → Character device
        
    - `b` → Block device
        
    - `p` → Named pipe
        
    - `s` → Socket