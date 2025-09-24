

Variables in Ansible allow you to **store values** and **reuse them** in playbooks, tasks, and templates. They make your automation **dynamic** and **flexible**.

---

## **1. Defining Variables**

- Variables are defined as **name-value pairs**.
    
- Syntax in a playbook:
    

```
vars:
  variable_name: value

```

**Example:**

```
vars:
  http_port: 80
  user: admin
  path: /opt/app

```

- You can define **multiple variables** under `vars`.
    

---

## **2. Using Variables**

- Use the `debug` module to display variable values:
    

```
- name: Show variable value
  ansible.builtin.debug:
    msg: "Port is {{ http_port }}"

```
- Output will display the value of `http_port`.
    

---

## **3. Task-Level vs Play-Level Variables**

### **Play-Level Variables**

- Defined under the play (`vars:` section).
    
- Available to **all tasks in the play**.
    

### **Task-Level Variables**

- Defined under a specific task.
    
- **Overrides** play-level variables if the same variable name is used.
    

**Example:**
```
- name: Task with task-level variable
  ansible.builtin.debug:
    msg: "Port is {{ http_port }}"
  vars:
    http_port: 90   # Overrides play-level variable

```

**Precedence:**  
**Task-level > Play-level** > Inventory-level > Group-level > Extra-vars

---

## **4. Inventory-Level Variables**

- Defined in the **inventory file** (`hosts`) for individual hosts.
    
- Useful when different servers need **different values**.
    

**Example Inventory (`hosts`):**
```
server1 ansible_host=192.168.1.19 tomcat_path=/opt/tomcat
server2 ansible_host=192.168.1.20 tomcat_path=/dmp/tomcat

```
- In playbook, you can access them:
    
```
- name: Show Tomcat path
  ansible.builtin.debug:
    msg: "Tomcat is installed at {{ tomcat_path }}"

```

---

## **5. Group-Level Variables**

- Defined for **groups of hosts**.
    
- Useful when multiple servers share **common configurations**.
    

**Example Inventory with Groups:**
```
[app_servers]
server1
server2

[db_servers]
server3
server4

[app_servers:vars]
tomcat_path=/opt/tomcat

[db_servers:vars]
mysql_path=/opt/mysql

```
- Access group variables in playbooks the same way as host variables.
    

---

## **6. Environment Variables**

- Environment variables are defined on the **target machine**.
    
- Access them in Ansible using **lookup**:
    
```
- name: Show environment variable
  ansible.builtin.debug:
    msg: "Java path is {{ lookup('env','JAVA_HOME') }}"

```

- You can set environment variables on a server:
    

`export JAVA_HOME=/dmp/java`

- Then playbook will pick up this value.
    

---

## **7. Extra Variables (`--extra-vars`)**

- Extra-vars allow you to **override variables at runtime**.
    
- Highest precedence, can **override task, play, or inventory variables**.
    

**Example:**

```
ansible-playbook -i hosts variable_example.yml --extra-vars "http_port=8080"

```

- `http_port` defined in the playbook will be overridden by `8080` at execution time.
    

---

## **8. Key Takeaways**

1. **Variables make playbooks dynamic**; they avoid hardcoding values.
    
2. **Precedence order (highest to lowest):**
    
    `extra-vars > task vars > block vars > play vars > host/group vars > defaults`
    
3. Use **inventory/group variables** to manage host-specific or group-specific settings.
    
4. Use **task-level variables** to temporarily override values for specific tasks.
    
5. Use **extra-vars** for runtime overrides, useful in production deployments.
    
6. Environment variables can be **accessed via lookup**, useful for application paths or configs.
    

---

This note covers **all variable types** from your transcript:

- Play-level
    
- Task-level
    
- Inventory-level
    
- Group-level
    
- Environment variables
    
- Extra variables (runtime overrides)
  
# Ansible Registers — Detailed Notes

## 🔹 What is a Register in Ansible?

- A **register** is used to **store the output/result of a task into a variable**.
    
- Once stored, you can:
    
    - Debug or display it.
        
    - Check if a task succeeded/failed.
        
    - Use conditions (`when`) based on the result.
        
    - Trigger actions like sending alerts or skipping tasks.
        

---

## 🔹 How to Use `register`
```
tasks:
  - name: Install Apache HTTP Server
    yum:
      name: httpd
      state: present
    register: install_apache

```
- Here, the output of installing Apache will be stored in a variable named `install_apache`.
    

---

## 🔹 What Gets Stored in a Register?

Each register variable contains:

- **`rc` (return code)** → `0` means success, non-zero means failure.
    
- **`changed`** → whether something was changed (`true/false`).
    
- **`failed`** → whether the task failed (`true/false`).
    
- **`msg`** → error or success message.
    
- **stdout/stderr** → command output (for command/shell tasks).
    
- **other metadata** depending on the module.
    

---

## 🔹 Example: Debugging a Register
```
- name: Show output
  debug:
    var: install_apache

```

👉 This will print the full structure of the register variable.

---

## 🔹 Handling Failures

- By default, if a task fails → **Playbook stops**.
    
- Options:
    
    1. **ignore_errors: yes** → continue even if failed.
        
    2. Use **register + conditions** → handle intelligently.
        

Example:
```
- name: Change Apache config
  copy:
    src: httpd.conf
    dest: /tmp/httpd.conf
  register: change_apache_port
  ignore_errors: yes

```

---

## 🔹 Using Register with Conditions

### Example 1: Run next task only if installation succeeded
```
- name: Change Apache Port
  lineinfile:
    path: /etc/httpd/conf/httpd.conf
    regexp: '^Listen'
    line: 'Listen 8080'
  when: install_apache.rc == 0

```

### Example 2: Run only if previous task made changes
```
- name: Restart Apache
  service:
    name: httpd
    state: restarted
  when: change_apache_port.changed

```

---

## 🔹 Sending Alerts with Register

Registers let you simulate monitoring:

```
- name: Send alert
  debug:
    msg: >
      Install Apache: {{ 'Success' if install_apache.rc == 0 else 'Failed' }}
      Change Port: {{ 'Success' if change_apache_port.rc == 0 else 'Failed' }}

```
👉 In real setups, instead of `debug`, you can integrate with **email, Slack, or monitoring systems**.

---

## 🔹 Common Attributes in Register Variables

|Attribute|Meaning|
|---|---|
|`rc`|Return code (0=success, non-zero=failure)|
|`stdout`|Standard output of command|
|`stderr`|Error messages (if any)|
|`changed`|True if something was changed|
|`failed`|True if task failed|
|`msg`|Message from the module|

---

## 🔹 Why Registers Are Important?

✅ Allow decision-making in Playbooks.  
✅ Prevent complete Playbook failure.  
✅ Useful for conditional execution.  
✅ Enable advanced automation (e.g., alerts, dynamic configs).

---

⭐ **Summary in One Line:**  
Registers in Ansible capture the result of a task into a variable so you can check success/failure, act conditionally, or pass outputs to later tasks.

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