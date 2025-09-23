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
   
   ## Features and Capabilities

1. **Automation Anywhere**
    
    - Can automate almost anything if you know the right **modules** and **plugins**.
        
    - You can also build **custom plugins/modules** if something isn’t already available.
        
2. **System Configuration**
    
    - Supports OS-level configuration, apps, DBs, network devices, firewalls, etc.
        
3. **Software Deployment**
    
    - Install packages.
        
    - Manage configurations.
        
    - Set defaults and enforce consistency.
        
4. **Orchestration**
    
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