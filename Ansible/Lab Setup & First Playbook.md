
## 1. **Lab Setup**

- **Management Node (Control Node)** → where Ansible is installed and playbooks are written.  
    Example IP: `192.168.1.119`
    
- **Target Servers (Managed Nodes)** → machines where tasks will run.
    
    - CentOS servers (connected via **SSH**)
        
    - Windows server (connected via **WinRM**)
        

👉 The control node connects to target machines using different protocols:

- **Linux servers** → SSH
    
- **Windows servers** → WinRM
  
  ## **Important Concept – Avoid Root Login**

- By default, connections were shown using the **root user**.
    
- ❌ Bad practice in production → never manage servers directly with root.
    
- ✅ Instead, create a separate user for Ansible (e.g., `ansible`).
    
    `useradd ansible`
    
- This user is created on the **management node** and on all **target nodes**.
    
- Switch to the Ansible user:
    
    `su - ansible`

## **Inventory File (hosts file)**

The inventory file lists all target servers that Ansible will manage.

Example:

```
[centos_servers]
192.168.1.2
192.168.1.21

[windows_servers]
192.168.1.10 ansible_user=Administrator ansible_password=Admin@123 \
ansible_connection=winrm ansible_port=5985 \
ansible_winrm_server_cert_validation=ignore \
ansible_winrm_transport=ntlm

```

- `[centos_servers]` → group of Linux servers
    
- `[windows_servers]` → group of Windows servers
    
- Extra connection details are required for **Windows**:
    
    - `ansible_user` → username
        
    - `ansible_password` → password
        
    - `ansible_connection=winrm` → use WinRM protocol
        
    - `ansible_port=5985` → default WinRM port
        
    - `ansible_winrm_server_cert_validation=ignore` → skip cert checks
        
	- `ansible_winrm_transport=ntlm` → authentication method
## **Writing the First Playbook (Ping Linux Servers)**

File: `ping_centos_servers.yml`

```
---
- name: Ping CentOS Servers
  hosts: centos_servers
  gather_facts: no

  tasks:
    - name: Pinging CentOS servers
      ping:

```

- **`hosts`** → group name from inventory
    
- **`gather_facts: no`** → skip collecting extra system info (faster)
    
- **Task** → uses the built-in `ping` module (Linux)
    

---

## 5. **Ping Windows Servers Playbook**

File: `ping_windows_servers.yml`

```
---
- name: Ping Windows Servers
  hosts: windows_servers
  gather_facts: no

  tasks:
    - name: Pinging Windows servers
      win_ping:

```

- Uses `win_ping` instead of `ping` because it’s Windows.
    

---

## 6. **Running Playbooks**

Run with the `ansible-playbook` command:

```
ansible-playbook -i hosts ping_centos_servers.yml 
ansible-playbook -i hosts ping_windows_servers.yml
```

- `-i hosts` → specifies inventory file
    
- `ping_centos_servers.yml` / `ping_windows_servers.yml` → playbook name
    

👉 On first connection, Ansible asks to cache the **SSH/WinRM key**. Answer `yes`.

---

## 7. **Gather Facts**

- Default behavior: Ansible collects system info (OS, CPU, memory, etc.).
    
- Extra task called **"Gathering facts"** runs automatically.
    
- Disable if not needed:
    
    `gather_facts: no`
    

---

## 8. **Combining Multiple Playbooks**

You can create a playbook that **imports other playbooks**.

File: `ping_all_servers.yml`

```
--- 
- import_playbook: ping_windows_servers.yml
- import_playbook: ping_centos_servers.yml
```

Run:

`ansible-playbook -i hosts ping_all_servers.yml`

👉 This runs both Linux and Windows ping playbooks in sequence.

---

## 9. **Play Recap (Results)**

After running a playbook, Ansible shows a summary:

- ✅ **ok** → task succeeded
    
- 🔄 **changed** → something was modified
    
- ❌ **failed** → task failed
    
- 🔒 **skipped/ignored/unreachable** → server not reachable or skipped
    

Example:

```
PLAY RECAP
192.168.1.2   : ok=1  changed=0  failed=0
192.168.1.21  : ok=1  changed=0  failed=0
192.168.1.10  : ok=1  changed=0  failed=0

```
---

# ✅ Quick Recap of Workflow

1. Set up **management node** (with Ansible installed).
    
2. Add **target servers** to the inventory file.
    
3. Create **Ansible user** on all nodes (avoid root).
    
4. Write playbooks (`.yml` files).
    
5. Run them with `ansible-playbook -i hosts <playbook.yml>`.
    
6. Check results in the **Play Recap**.
    
7. Use `import_playbook` to combine multiple playbooks.
## What are "Facts" in Ansible?

- **Facts** = System information about a managed node (target server).
    
- Examples:
    
    - Hostname
        
    - IP addresses (IPv4, IPv6)
        
    - OS family (Linux, Windows, RedHat, Ubuntu, etc.)
        
    - Disk partitions & mount points
        
    - CPU & memory info
        
- They are automatically collected at the beginning of a playbook (unless disabled).
    

---

## 🔹 How to Gather Facts

- **Manually (ad-hoc command):**
    
    `ansible <host> -i hosts -m setup`
    
    - `-m setup` → calls the **setup module** which collects facts.
        
    - Output = a **JSON dictionary** with hundreds of facts.
        
- Example output might include:
    
    `"ansible_os_family": "RedHat", "ansible_hostname": "centos1", "ansible_all_ipv4_addresses": ["192.168.1.2"], "ansible_mounts": [...]`
    

---

## 🔹 Using Facts in Playbooks

You can **reference facts like variables** inside playbooks.

Example Playbook (`gather_facts_example.yml`):
```
- name: Gather facts about servers
  hosts: all
  tasks:
    - name: Show OS family
      debug:
        msg: "This server belongs to OS family: {{ ansible_os_family }}"

    - name: Show Mount Points (only for Linux)
      debug:
        var: ansible_mounts
      when: ansible_os_family == "RedHat"

```
---

## 🔹 Key Learnings from Transcript

1. **Setup module** collects ~300-400 lines of info in JSON format.
    
2. This info can be stored in a file for later use:
    
    `ansible <host> -m setup > sysinfo.json`
    
3. Facts can be directly used as variables in playbooks.
    
4. Sometimes variables don’t exist for all systems (e.g., `ansible_mounts` doesn’t exist on Windows).  
    → To avoid errors, use **conditions (`when`)**.
    
5. Playbooks can **target different groups of hosts** (Linux vs Windows).
    
6. Facts can be reused for **reports** (e.g., disk usage, memory utilization, OS type, etc.).
    

---

✅ So in **easy words**:  
Ansible “facts” are like **system fingerprints** that Ansible collects automatically. You can use them in playbooks to make decisions (if server is RedHat → do X, if Windows → do Y).

---
##### **In Short – The Flow**

1. Install Ansible → configure inventory → test connection.
    
2. Run ad-hoc commands or playbooks.
    
3. Ansible auto-gathers facts about nodes.
    
4. Use those facts as variables in playbooks.
    
5. Add conditions (`when`) to handle OS differences.
    
6. Store & reuse output for reporting or automation.