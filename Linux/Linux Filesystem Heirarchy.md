
## **Linux Filesystem Hierarchy (FHS)**

The **Filesystem Hierarchy Standard (FHS)** organizes Linux directories and their purposes.

|Directory|Purpose|Example Command|
|---|---|---|
|`/`|Root directory (everything starts here)|`ls /`|
|`/bin`|Essential binaries (commands like `ls`, `cat`)|`ls /bin`|
|`/boot`|Boot files (Kernel, GRUB config)|`ls /boot`|
|`/dev`|Device files (hardware devices)|`ls /dev`|
|`/etc`|Configuration files|`ls /etc`|
|`/home`|User home directories|`ls /home`|
|`/lib`|Shared libraries & kernel modules|`ls /lib`|
|`/media`|Mount points for removable media|`ls /media`|
|`/mnt`|Temporary mount points|`ls /mnt`|
|`/opt`|Optional software packages|`ls /opt`|
|`/proc`|Virtual filesystem (process info)|`ls /proc`|
|`/root`|Home directory for root user|`ls /root`|
|`/sbin`|System binaries (admin tasks)|`ls /sbin`|
|`/srv`|Data served by the system|`ls /srv`|
|`/tmp`|Temporary files|`ls /tmp`|
|`/usr`|User applications and libraries|`ls /usr`|
|`/var`|Variable data (logs, caches, databases)|`ls /var`|

---

### **Checking Disk Usage**

| Command           | Description                                |     |
| ----------------- | ------------------------------------------ | --- |
| `df -h`           | Show available disk space (human-readable) |     |
| `du -sh /var/log` | Display the size of `/var/log` directory   |     |

💡 **Tips:**

- Use `df -h` to quickly check if any partition is running out of space.
    
- `du -sh` is great for checking which directories are consuming the most space.
    
- `/proc` is a virtual filesystem: you can see running process info here, e.g., `cat /proc/cpuinfo`.