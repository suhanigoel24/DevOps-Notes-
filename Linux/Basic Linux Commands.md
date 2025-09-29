
## **File and Directory Management**

|🔧 Command|📌 Description|
|---|---|
|`ls`|List files and directories.|
|`pwd`|Show current working directory.|
|`cd <directory>`|Change directory.|
|`mkdir <directory>`|Create a new directory.|
|`rmdir <directory>`|Remove an **empty** directory.|
|`rm <file>`|Delete a file.|
|`rm -r <directory>`|Delete a directory **and its contents**.|
|`cp <source> <destination>`|Copy files or directories.|
|`mv <source> <destination>`|Move or rename files and directories.|

---

## 📜 **File Viewing**

|🔍 Command|📌 Description|
|---|---|
|`cat <file>`|Display file contents.|
|`less <file>`|View file **page by page** (scroll with ↑ ↓).|
|`head <file>`|Show the **first 10 lines**.|
|`tail <file>`|Show the **last 10 lines**.|
|`tail -f <file>`|Continuously monitor a log file in real time.|

---

## 🔒 **File Permissions and Ownership**

|🔧 Command|📌 Description|
|---|---|
|`chmod <permissions> <file>`|Change file permissions. (e.g., `chmod 755 script.sh`)|
|`chown <user>:<group> <file>`|Change file ownership.|

---

⚡ **Tip on Permissions (`chmod`)**:

- `r` = read, `w` = write, `x` = execute.
    
- Numbers are used (e.g., `chmod 755 file`):
    
    - `7 = rwx`
        
    - `5 = r-x`
        
    - `4 = r--`
        

---
## **Process Management**

| Command                | Description                                | Notes / Tips                                                                    |
| ---------------------- | ------------------------------------------ | ------------------------------------------------------------------------------- |
| `ps`                   | Show running processes                     | Often combined with `aux` (`ps aux`) to see all processes with detailed info.   |
| `top`                  | Display system resource usage in real-time | Shows CPU, memory, and process info. Use `q` to quit.                           |
| `htop`                 | Interactive process viewer (if installed)  | Easier to navigate than `top`, supports killing processes interactively.        |
| `kill <PID>`           | Terminate a process by its ID              | `PID` is the process ID from `ps` or `top`. Use `kill -9 <PID>` for force kill. |
| `pkill <process_name>` | Kill a process by name                     | Handy if you don’t want to look up the PID.                                     |
## **System Information**

| Command    | Description         | Notes / Tips                                                                      |
| ---------- | ------------------- | --------------------------------------------------------------------------------- |
| `uname -a` | Show system details | Displays kernel name, hostname, kernel version, architecture, and OS info.        |
| `df -h`    | Display disk usage  | `-h` makes it human-readable (GB, MB). Use `df -Th` to also see filesystem types. |
| `free -m`  | Check memory usage  | `-m` shows memory in MB. Use `free -h` for human-readable format.                 |
## **Networking Commands**

| Command                     | Description                     | Notes / Tips                                               |
| --------------------------- | ------------------------------- | ---------------------------------------------------------- |
| `ping <host>`               | Check network connectivity      | Sends ICMP packets. Ctrl+C stops the ping.                 |
| `ifconfig` / `ip addr show` | View network interfaces         | `ifconfig` is older; `ip addr` is newer and preferred.     |
| `netstat -tulnp`            | Show active network connections | `t`=TCP, `u`=UDP, `l`=listening, `n`=numeric, `p`=process. |
| `curl <URL>`                | Fetch data from a URL           | Can also be used to test HTTP responses or download files. |
## **Command Line Help in Linux/macOS**

|Command|Description|Notes / Tips|
|---|---|---|
|`man <command>`|Show the manual page for a command|Example: `man ls` → shows usage, options, and examples. Navigate with ↑/↓, search with `/keyword`, quit with `q`.|
|`info <command>`|View more detailed documentation|Example: `info coreutils 'ls invocation'`. Often more verbose than `man` and sometimes includes tutorials.|
|`<command> --help`|Show brief help / options summary|Example: `ls --help` → lists all flags and usage examples. Works with most modern commands.|
|`whatis <command>`|Show a one-line description|Example: `whatis ls` → “ls (1) - list directory contents.”|
|`apropos <keyword>`|Search manual page descriptions|Example: `apropos copy` → lists commands related to “copy.”|

---

💡 **Tips for using `man` effectively:**

1. Sections: Some commands exist in multiple sections (e.g., `man 3 printf` vs `man 1 printf`).
    
2. Search inside `man`: Press `/` then type your keyword.
    
3. Quit anytime with `q`.
    

---