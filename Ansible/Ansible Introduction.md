	## What is Ansible?

- **Ansible** is an **open-source automation tool**.
    
- It is mainly used for:
    
    - **Configuration management** – making sure servers or systems are set up the way you want.
        
    - **Application deployment** – installing and updating apps automatically.
        
    - **Orchestration** – managing multiple systems at the same time, coordinating tasks across them.
        
    - **Provisioning** – setting up servers, networks, or cloud infrastructure automatically.

**Key points:**

- Agentless: It doesn’t need any software installed on the remote machines. It works over SSH.
    
- Declarative: You define **what** you want, not **how** to do it.
    
- Written in **Python**.
  
[^1]Ansible is like a **remote helper** for your computers and servers. It can:

- Install software for you automatically.
    
- Start or stop services (like a web server).
    
- Copy files or configure settings.
    
- Do all this on **many computers at once** without you logging into each one.
    

Basically, it **automates tasks** so you don’t have to do them manually.

[^1]

### **How it works**?

1. You have a **control computer** where you run Ansible.
    
2. You have **other computers** you want to manage (called managed nodes).
    
3. You write instructions in a **playbook** (a simple file written in **YAML**, which is easy to read).
    
4. Ansible connects to the other computers via **SSH** and runs the instructions.
    
5. Your computers are now set up exactly how you want.
   
	
### **Example**

Imagine you want to install Nginx on 3 servers:

**Playbook (instructions file):**

```
- name: Install Nginx
  hosts: webservers
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present

```

- `hosts: webservers` → tells Ansible which computers to work on.
    
- `tasks:` → what you want it to do.
    
- `apt:` → tells it to install the package.

Run this, and **all servers in `webservers` will have Nginx installed automatically**.

---

### **Why it’s cool**

- No need to log into every server.
    
- Can repeat tasks safely (won’t break if run again).
    
- Easy to read and share with your team.
    
- Works for servers, cloud, and networks.

## Ansible Architecture

![[Screenshot 2025-09-22 at 4.45.20 PM.png]]

## **Ansible Architecture Simplified**

1. **Users**
    
    - People who use Ansible: system admins, DevOps engineers, etc.
        
    - They write **playbooks** (instructions) and decide **which machines** to manage.
        
    - Basically, the ones who tell Ansible what to do.
        
2. **Ansible (the Tool)**
    
    - The brain of the operation.
        
    - Executes tasks like installing software, configuring servers, or deploying apps.
        
    - **Agentless:** No software is needed on the remote machines.
        
    - Talks to hosts via SSH (Linux) or WinRM (Windows).
        
3. **Host Inventory**
    
    - A list of all the machines Ansible will manage.
        
    - Contains IP addresses or hostnames.
        
    - Hosts can be **grouped** (like web servers, database servers) for easier management.
        
4. **Playbooks**
    
    - YAML files with step-by-step instructions.
        
    - Define **tasks** to run on specific hosts or groups.
        
    - Example: Install Nginx on all web servers.
        
5. **Modules**
    
    - **Core Modules:** Built-in tools to do common tasks (e.g., `apt` for packages, `service` to start/stop services).
        
    - **Custom Modules:** You can create your own if built-in modules don’t cover your needs.
        
6. **Plugins**
    
    - Extra helpers that extend functionality.
        
    - Examples: logging actions, sending email notifications, adding custom behavior.
        
7. **Connection Plugins**
    
    - Handle how Ansible talks to the hosts.
        
    - Most common: **SSH** for Linux, **WinRM** for Windows.
        
    - Allows Ansible to execute tasks remotely.
        
8. **Cloud Support (Private/Public)**
    
    - Ansible can manage machines in **cloud environments** too.
        
    - Private Cloud: Internal setups (OpenStack, VMware).
        
    - Public Cloud: Platforms like AWS, Azure, GCP.
        
9. **Hosts**
    
    - The actual machines Ansible manages.
        
    - Can be physical servers, VMs, or containers.
        
    - Tasks can run on single hosts or groups of hosts.
      
### **How it all works together**

1. **User** writes a playbook → chooses hosts from **inventory**.
    
2. **Ansible** uses **connection plugins** to reach hosts.
    
3. Executes tasks using **modules**.
    
4. Can use **plugins** to enhance actions.
    
5. Works on hosts whether they’re on **private/public clouds** or physical machines.
   
   ## Ansible Architecture

1. **Control Node (Management Node)**
    
    - Where Ansible is installed.
        
    - Users create **playbooks** and **inventory** here.
        
    - This node executes all automation.
        
2. **Inventory**
    
    - File listing the servers (hosts) Ansible manages.
        
    - Example:
```
[dbservers]
192.168.1.10
192.168.1.11

[webservers]
web01.example.com
web02.example.com

```
        
        
        
    - You can group hosts (`dbservers`, `webservers`) for easier targeting.
        
    - Can also store **credentials** (usernames, passwords, SSH keys).
        
3. **Playbooks**
    
    - YAML files containing automation instructions.
        
    - End with `.yml`.
        
    - Structure:
        
        - Start with `---` (YAML syntax).
            
        - **Play** → A set of tasks to run on defined hosts.
            
        - **Tasks** → Actions to be done (like install a package).
            
        - **Variables** → Define values (like port numbers) so they can be reused.
            
        - **Handlers** → Special tasks triggered only if something changes.
            
    - Example:
        
```
 - name: Install Apache on webservers
  hosts: webservers
  become: yes
  tasks:
    - name: Ensure Apache is installed
      apt:
        name: apache2
        state: present

```
        
4. **Modules**
    
    - Small programs Ansible uses to perform tasks.
        
    - Example: `apt`, `yum`, `service`, `user`, `copy`.
        
    - Thousands of modules exist.
        
5. **Handlers**
    
    - Triggered after certain tasks.
        
    - Example: Restart Apache only if the config file changes.
   
   ## Features and Capabilities

6. **Automation Anywhere**
    
    - Can automate almost anything if you know the right **modules** and **plugins**.
        
    - You can also build **custom plugins/modules** if something isn’t already available.
        
7. **System Configuration**
    
    - Supports OS-level configuration, apps, DBs, network devices, firewalls, etc.
        
8. **Software Deployment**
    
    - Install packages.
        
    - Manage configurations.
        
    - Set defaults and enforce consistency.
        
9. **Orchestration**
    
    - Run multiple tasks in sequence.
        
    - Add conditions (if/else logic).
        
    - Useful for complex workflows.
## Ansible Editions

1. **Open Source Edition**
    
    - Free to use.
        
    - Community-driven.
        
    - Source code available → you can modify or enhance it.
        
    - No vendor lock-in.
        
    - Very widely adopted.
        
2. **Enterprise Edition (Red Hat Ansible Automation Platform)**
    
    - Paid version by **Red Hat**.
        
    - Offers enterprise-grade **support**.
        
    - **Certified content** (modules, roles, playbooks) so you know it’s secure and reliable.
        
    - Extra features:
        
        - **Role-Based Access Control (RBAC)**.
            
        - **Graphical User Interface (GUI)**.
            
        - **Automation Analytics & Insights**.
            
        - **Automation Hub** → official marketplace for trusted playbooks/modules.
            
        - **REST APIs** for integration with other tools.
            
        - Better **security & compliance** integration.
## Key Characteristics of Ansible

1. **Agentless**
    
    - Unlike other tools (like Puppet or Chef), no need to install agents on target machines.
        
    - Only needs Ansible installed on a **control node**.
        
    - Connects to target machines using:
        
        - **SSH** → Linux/Unix.
            
        - **WinRM** → Windows.
            
2. **Idempotency**
    
    - Running the same playbook multiple times won’t break your system.
        
    - Example:
        
        - First run: Creates a user `ansible-user` on 10,000 servers.
            
        - Second run: Detects user already exists → does nothing.
            
    - Prevents duplication or system corruption.
        
3. **Open Source Security & Transparency**
    
    - You can see and audit the code.
        
    - Scan with security tools if needed.

### Ansible playbook line by line

```
---
- name: Configure Web Servers
  hosts: web_servers
  gather_facts: yes
  vars:
    web_server_port: 80

  tasks:
    - name: Ensure Apache is installed (Debian)
      become: yes
      apt:
        name: apache2
        state: present
      when: ansible_facts['ansible_os_family'] == 'Debian'
      notify: Restart Apache (Debian)

- name: Ensure Apache is listening on port {{ web_server_port }}
      become: yes
      lineinfile:
        path: /etc/apache2/ports.conf
        line: Listen {{ web_server_port }}
      when: ansible_facts['ansible_os_family'] == 'Debian'

  handlers:
    - name: Restart Apache (Debian)
      become: yes
      service:
        name: apache2
        state: restarted

```


### Header

`---`

- Marks the beginning of a YAML file.
    
- Standard in Ansible playbooks.
    

---

### 🔹 Play Definition

`- name: Configure Web Servers`

- Defines the **play** (a set of tasks).
    
- This play is called **“Configure Web Servers”**.
    

  `hosts: web_servers`

- Target group of hosts is **`web_servers`** (defined in the inventory file).
    
- All tasks under this play will run on those hosts.
    

  `gather_facts: yes`

- Tells Ansible to collect **facts** (system information like OS, IP, CPU, etc.).
    
- Useful for conditional tasks (e.g., run only if Debian).
    

 
  ```vars:     web_server_port: 80```
  

- Defines a **variable** `web_server_port` with value **80**.
    
- This avoids hardcoding values and makes the playbook reusable.
    

---

### 🔹 Tasks Section

  `tasks:`

- All tasks to be executed on the target hosts go here.
    

---

#### **Task 1: Install Apache**

    `- name: Ensure Apache is installed (Debian)       become: yes`

- Task name for readability: install Apache on Debian.
    
- `become: yes` → run as **root (sudo)**, since installing packages needs admin rights.
    

      `apt:         name: apache2         state: present`

- Uses the **`apt` module** (package manager for Debian/Ubuntu).
    
- Ensures package **apache2** is installed.
    
- `state: present` → install if not already installed.
    

      `when: ansible_facts['ansible_os_family'] == 'Debian'`

- Conditional execution.
    
- Task runs **only if the target OS family is Debian**.
    

      `notify: Restart Apache (Debian)`

- Triggers a **handler** named "Restart Apache (Debian)" **if this task makes changes** (e.g., if Apache was installed).
    
- If no change, the handler won’t run.
    

---

#### **Task 2: Configure Apache Port**

    `- name: Ensure Apache is listening on port {{ web_server_port }}       become: yes`

- Ensures Apache is listening on the port defined in the variable (`80`).
    
- Again uses **sudo privileges**.
    

      `lineinfile:         path: /etc/apache2/ports.conf         line: Listen {{ web_server_port }}`

- Uses the **`lineinfile` module** to edit files.
    
- Ensures `/etc/apache2/ports.conf` contains the line:
    
    `Listen 80`
    
- If line already exists → no changes made (idempotency).
    
- If not → line will be added.
    

      `when: ansible_facts['ansible_os_family'] == 'Debian'`

- Runs only on Debian-based systems.
    

---

### 🔹 Handlers Section

  `handlers:     - name: Restart Apache (Debian)       become: yes       service:         name: apache2         state: restarted`

- Defines a **handler** named "Restart Apache (Debian)".
    
- Handlers run only when **notified** by tasks.
    
- Uses the **`service` module**:
    
    - Restarts the `apache2` service if triggered.
        
- `become: yes` → requires root privileges.
    

---

## ✅ Flow of this Playbook

1. Gather facts about the system.
    
2. Check if host OS is Debian:
    
    - If yes → install Apache (`apache2`).
        
    - If Apache was installed → notify handler to restart it.
        
3. Ensure Apache is listening on port `80` by editing `/etc/apache2/ports.conf`.
    
4. If either task changes something, the handler will **restart Apache**.
    

---

⚡In short:

- This playbook installs Apache (if missing), ensures it listens on port 80, and restarts it if necessary.
    
- Runs only on **Debian-based systems**.
    
- Uses variables, conditionals, and handlers → making it modular, reusable, and safe.