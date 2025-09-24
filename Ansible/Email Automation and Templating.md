# Email Automation in Ansible

## 1. Why send emails with Ansible?

- Sometimes we want **notifications** after a task or playbook runs.
    
- Example: After installing Apache, send an email saying whether it was successful or failed.
    
- Useful for **monitoring, alerts, or reporting**.
    

---

## 2. The Tool: `mail` Module

- Ansible provides a **predefined module** called `mail`.
    
- It is used to send emails directly from a playbook.
    

---

## 3. Key Settings in `mail` Module

When configuring, you need some details:

- **host** → The SMTP server (e.g., Gmail, Outlook, company mail server).
    
- **port** → Usually `25`, `465`, or `587` (depends on server).
    
- **username** & **password** → Only if your SMTP server requires login.
    
- **from** → Email ID that sends the mail.
    
- **to** → Recipient’s email.
    
- **subject** → Subject line of the email.
    
- **body** → The main content of the email.
    
- **secure** → (`starttls` or `ssl`) based on SMTP settings.
    

👉 You usually get these details from your **system administrator**.

---

## 4. Using Variables in Emails

- You can include **variables** in subject/body.
    
- Example: `{{ ansible_play_name }}` → inserts the playbook name.
    
- Example: `{{ install_apache }}` → inserts results of the registered task.
    

---

## 5. Registering Task Results

- Use `register` to capture the result of a task.
    
- Example:
    
```
- name: Install Apache
  yum:
    name: httpd
    state: present
  register: install_apache

```
    
- Later, you can use `install_apache` in the email body to send details.
    

---

## 6. Sending Attachments

- You can attach files with the `attach` option:
    
```
    attach:
  - /tmp/sysinfo.txt
  - /tmp/config.log

```
    
- Attachments are delivered along with the email.
    

---

## 7. Free vs. Real Email Accounts

- **Mailinator (free)** → Can receive emails but doesn’t show attachments in free tier.
    
- **Real accounts (Outlook, Gmail, etc.)** → Can view attachments properly.
    

---

## 8. Example Playbook

```
- name: Install Apache and send email
  hosts: all
  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: present
      register: install_apache

    - name: Send email
      mail:
        host: smtp.yourcompany.com
        port: 587
        username: user@example.com
        password: mypassword
        to: manager@example.com
        from: ansible@example.com
        subject: "{{ ansible_play_name }} completed"
        body: |
          Here are the results:
          {{ install_apache }}
        attach:
          - /tmp/sysinfo.txt

```

---

## 9. Next Step (Preview from transcript)

- Instead of plain text emails, we can use **templates (Jinja2)**.
    
- Templates allow creating **beautiful, formatted email bodies**.
    

---

✅ **Summary:**

- `mail` module → used to send emails.
    
- Needs SMTP details (host, port, credentials).
    
- `register` lets us capture task results and include them in the email.
    
- Can send attachments.
    
- Next step is using templates for nicer emails.


# Ansible Templates

## 1. What is an Ansible Template?

- A **template** in Ansible is a way to create **dynamic files**.
    
- Instead of writing fixed configuration files, templates let you use **variables, loops, conditions, and logic** to make the file **customized for each server**.
    
- Templates use **Jinja2 syntax** (a templating engine).
    

👉 Example: Instead of one fixed `index.html`, you can create one template that automatically fills in each server’s **hostname, IP address, and OS type**.

---

## 2. Why Templates?

- Ansible is used for **configuration management**.
    
- Most software needs a **configuration file** (e.g., Apache needs `httpd.conf`, Nginx needs `nginx.conf`).
    
- Templates let you **avoid writing separate files for each server**. Instead:
    
    - You write **one template file**.
        
    - Ansible fills in the correct details **per host**.
        

---

## 3. Template Architecture (File Structure)

Typical setup looks like this:

```
project-folder/
 ├── playbook.yml
 ├── inventory
 └── templates/
      └── mytemplate.j2

```

- **`playbook.yml`** → Defines tasks (e.g., install Apache, copy template).
    
- **`templates/`** → Special folder where you keep `.j2` template files.
    
- **`.j2 file (Jinja2)** → Contains your HTML/config with variables, loops, conditions.
    

---

## 4. Template Module in Playbook

The **`template` module** is used in playbooks:
```
- name: Deploy index.html file
  template:
    src: webpage_template.j2   # template source (inside templates/)
    dest: /var/www/html/index.html   # destination path on server

```
👉 `src` looks inside `templates/` folder automatically.  
👉 `dest` is where the file should be created on the target server.

---

## 5. Writing a Template File (`.j2`)

Templates are written using **Jinja2 syntax**.  
Example: `webpage_template.j2`

```
<html>
  <body>
    <h1>This is {{ inventory_hostname }}</h1>
    <p>Server IP: {{ ansible_host }}</p>
    <p>OS Family: {{ ansible_os_family }}</p>
    <p>Play Name: {{ ansible_play_name }}</p>
  </body>
</html>

```
- `{{ inventory_hostname }}` → Magic variable → replaces with host’s name.
    
- `{{ ansible_host }}` → Becomes the server’s IP.
    
- `{{ ansible_os_family }}` → Comes from Ansible facts (Linux family).
    
- `{{ ansible_play_name }}` → The play’s name from the playbook.
    

---

## 6. How It Works (Execution Flow)

1. You run the playbook.
    
2. Ansible installs required software (e.g., Apache).
    
3. The `template` module:
    
    - Takes the `.j2` file from `templates/`.
        
    - Replaces variables with real values (hostname, IP, etc.).
        
    - Copies the **rendered file** to the destination server.
        
4. Now each server has its own **customized file**.
    

---

## 7. Example

Playbook (`playbook.yml`):
```
- name: Install and configure Apache HTTP server
  hosts: webservers
  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: present

    - name: Copy template index.html
      template:
        src: webpage_template.j2
        dest: /var/www/html/index.html

```
Template (`templates/webpage_template.j2`):
```
<html>
  <h1>This is {{ inventory_hostname }}</h1>
  <p>IP Address: {{ ansible_host }}</p>
  <p>OS: {{ ansible_os_family }}</p>
</html>

```

👉 On `server1`:

```
This is server1
IP Address: 192.168.1.2
OS: RedHat

```

👉 On `server2`:

```
This is server2
IP Address: 192.168.1.3
OS: Ubuntu

```

---

## 8. Key Points

- Templates make files **dynamic** → same template works for 100 servers.
    
- Uses **Jinja2 syntax** → `{{ variable }}`, `{% if %}`, `{% for %}`.
    
- Stored inside a `templates/` folder (by convention).
    
- Uses Ansible **variables + facts** to fill in values.
    
- Very useful for:
    
    - Config files (`nginx.conf`, `httpd.conf`)
        
    - HTML pages
        
    - Service definitions (systemd, etc.)
        

---

⚡ In short: **Templates in Ansible = Smart files that write themselves for each server using variables, loops, and conditions.**

### Is it mandatory to gather facts while using templates?


No, it is **not mandatory** to gather facts when using templates in Ansible.

Here’s the breakdown:

---

### 🔹 When **facts are required**

- If your Jinja2 template (`.j2` file) uses **Ansible facts** (like `ansible_hostname`, `ansible_os_family`, `ansible_default_ipv4.address`), then Ansible needs to **gather facts** first.
    
- Example in template:
    
```
<h1>Server: {{ ansible_hostname }}</h1>
<p>OS: {{ ansible_os_family }}</p>

```
    → These values come from **facts**, so gathering facts must be enabled.
    

---

### 🔹 When **facts are not required**

- If your template only uses:
    
    - Variables defined in the **playbook**
        
    - Variables from **inventory/host_vars/group_vars**
        
    - Custom variables passed via `vars:` or `extra_vars`
        
    
    Then you can disable fact gathering.
    
- Example:
    
```
<h1>Welcome to {{ company_name }}</h1>
<p>App version: {{ app_version }}</p>

```
    
    Here, `company_name` and `app_version` can be defined in inventory or playbook — no facts needed.
    

---

### 🔹 Controlling fact gathering

By default, Ansible gathers facts at the start of a play (`gather_facts: true`).  
You can disable it if not needed:

```
- hosts: webservers
  gather_facts: false
  tasks:
    - name: Deploy config using template
      template:
        src: myconfig.j2
        dest: /etc/myapp/config.conf

```

---

✅ **In short:**

- Using facts in template → need fact gathering.
    
- Only using your own variables → can skip fact gathering.