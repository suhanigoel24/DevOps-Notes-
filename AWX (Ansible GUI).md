
## **1. Introduction to AWX GUI**

- **AWX** is the **graphical user interface (GUI)** for Ansible.
    
- While Ansible can be run via **CLI**, AWX GUI is widely used because it provides:
    
    - Easier task management.
        
    - Visualization of inventories, jobs, and job status.
        
    - **REST API support** to integrate with other tools (e.g., monitoring tools or service management platforms).
        
    - Automation triggers based on certain events or thresholds.

---

## **2. Logging into AWX**

- Before using AWX, it must be installed.
    
    - Requires **Docker** and basic understanding of Docker concepts.
        
- After installation, log in as an **admin user**.
    
- Dashboard overview shows:
    
    - Hosts being managed.
        
    - Failed hosts.
        
    - Inventory sync failures.
        
    - Project details.
        
- Main sections in AWX:
    
    1. **View** – see jobs, inventories, projects.
        
    2. **Resources** – manage hosts, credentials, templates.
        
    3. **Administration** – user and role management (RBAC).
        

---

## **3. Setting Up Inventories**

- Inventories represent **groups of hosts** you want to manage.
    
- Steps to create an inventory:
    
    1. Go to **Inventories → Add Inventory**.
        
    2. Give a name (e.g., `centos_servers`).
        
    3. Optionally, define variables (can leave blank if none).
        
- Adding hosts to inventory:
    
    - Example hosts:
        
        - `192.168.1.19`
            
        - `192.168.1.2`
            
    - Assign them to the inventory created (`centos_servers`).
        
    - Hosts can be enabled/disabled individually.
        

---

## **4. Setting Up Projects**

- Projects are collections of **playbooks**.
    
- Sources:
    
    - GitHub or other repositories.
        
    - Manual (local directory) – specify the path to your playbooks.
        
- Example setup:
    
    - Project name: `awx_demo_playbook`
        
    - Source type: Manual
        
    - Directory: path to your playbook (e.g., `1.example/demo.yml`)
        
- Example playbook tasks:
    
    - Ping servers.
        
    - Show facts.
        

---

## **5. Adding Credentials**

- Credentials allow AWX to **connect to target systems**.
    
- Steps:
    
    1. Go to **Credentials → Add Credential**.
        
    2. Provide:
        
        - Credential type: **Machine**.
            
        - Username and password.
            
        - Private key for SSH (if needed).
            
    3. Save the credential.
        

---

## **6. Creating Job Templates**

- Job templates define **what playbook runs on which inventory with which credentials**.
    
- Steps:
    
    1. Go to **Templates → Add Template**.
        
    2. Provide:
        
        - Name (e.g., `ping_all_servers`).
            
        - Description of the job.
            
        - Job type: Run / Check mode.
            
        - Inventory: Choose target inventory.
            
        - Project: Choose project containing the playbook.
            
        - Playbook: Select playbook (e.g., `demo.yml`).
            
        - Credential: Select the machine credential created earlier.
            
        - Optional: Variables, verbosity, privilege escalation.
            
    3. Save the template.
        

---

## **7. Launching Jobs**

- Launch a job by:
    
    - Clicking the **rocket icon** on the template.
        
- Job execution:
    
    - Moves to **Jobs interface**.
        
    - Shows **real-time execution logs**.
        
    - Displays **success/failure** of each task.
        
- Example: Both hosts in inventory executed the playbook successfully.
    

---

## **8. Benefits of AWX GUI**

- Simplifies management of inventories, projects, and jobs.
    
- Easier to visualize **job execution results** and logs.
    
- Supports **advanced workflows, notifications, and integrations**.
    
- REST API allows integration with:
    
    - Monitoring tools (e.g., Grafana).
        
    - Service management tools.
        
    - Event-triggered automation workflows.
        

---

## **9. Future Topics (Next Lessons)**

- Advanced workflows.
    
- Email notifications.
    
- Integration with monitoring tools.
    
- Using AWX REST API for automation triggers.
  

  # **Ansible AWX and Automation Platform Notes**

## **1. Introduction**

- **Topic:** Difference between **Ansible AWX** and **Ansible Tower / Automation Platform**.
    
- **AWX**: Open-source version of Ansible Tower.
    
- **Ansible Tower / Automation Platform**: Paid, enterprise-grade version of AWX with official support and extra features.
    
- **Key point**: AWX and Tower share almost all core functionalities like running playbooks, managing inventories, and creating workflows.
    

---

## **2. Interface Overview**

- Logging into **AWX** gives a similar interface to Ansible Tower.
    
- **Tower** is now officially called **Ansible Automation Platform**.
    
- **AWX** is the open-source edition of Tower / Automation Platform.
    
- Actions performed in AWX (running playbooks, workflows, integrations) are **almost identical** to Tower.
    

---

## **3. Differences Between AWX and Automation Platform**

|Aspect|AWX|Automation Platform (Tower)|
|---|---|---|
|Type|Open-source|Paid / subscription-based|
|Features|Core features of Tower|All Tower features + enterprise integrations|
|Support|Community support|Official Red Hat support (24x7 or standard hours)|
|Cost|Free|Depends on nodes, environment, and subscription type|

- **Key point:** If you know how to use AWX, you can use Tower in the same way; main differences are **support and subscription costs**.
    

---

## **4. Features and Functionalities**

- Tower / Automation Platform offers:
    
    - Managed and self-managed environments.
        
    - Advanced workflows.
        
    - SMTP and cloud integrations.
        
    - Enterprise-grade support.
        
- AWX has **all core functionalities**, but support is **community-driven**.
    

---

## **5. Pricing and Support**

- **Pricing depends on:**
    
    - Number of managed nodes.
        
    - Environment type (managed vs self-managed).
        
    - Cloud region or deployment platform (e.g., AWS Marketplace).
        
- **Support options:**
    
    1. **Standard:** 8:00 a.m. – 5:00 p.m.
        
    2. **Premium:** 24x7 support.
        
- **Example:** Running Red Hat Ansible Automation Platform on AWS with up to 100 managed nodes costs roughly **$1/hour**.
    
- Premium support ensures you get help if anything goes wrong in production.
    

---

## **6. Choosing the Right Platform**

- **Use AWX** if:
    
    - You are comfortable managing Ansible yourself.
        
    - Enterprise doesn’t want to pay for subscriptions.
        
    - Community support is sufficient.
        
- **Use Automation Platform** if:
    
    - You want official Red Hat support.
        
    - You need enterprise-grade integrations.
        
    - You prefer a managed environment with SLAs.
        

---

## **7. Summary**

- **AWX** = free, open-source version of Tower.
    
- **Automation Platform / Tower** = paid version with official support and additional enterprise features.
    
- Core functionality (playbooks, workflows, inventory management) is **the same**.
    
- Main differences: **support, pricing, and enterprise integrations**.

# **Email Notifications in Ansible AWX**

## **1. Purpose**

- Email notifications in AWX allow you to **alert users when a job starts, succeeds, or fails**.
    
- Useful for monitoring automation workflows without manually checking the AWX dashboard.
    

---

## **2. Reviewing Existing Job Templates**

- Go to **Templates → Jobs** to see existing job templates.
    
- Click on a job to view **execution details and output logs**.
    
- Before sending notifications, make sure the job template exists and has executed at least once.
    

---

## **3. Setting Up Notifications**

1. Go to **Administration → Notifications**.
    
2. Click **Add** to create a new **Notification Template**.
    
3. **Name & Description**: Give a meaningful name (e.g., “Send Emails”).
    
4. **Notification Type**: Select **Email**.
    

---

## **4. Configuring SMTP**

- SMTP details are required to send emails:
    
    - **Host**: SMTP server address.
        
    - **Port**: SMTP port (default often 587 for TLS, 465 for SSL).
        
    - **Username & Password**: Credentials to access SMTP server.
        
    - **Timeout**: Optional; e.g., 60 seconds.
        
    - **TLS/SSL**: Select based on your SMTP configuration.
        
- These details are usually provided by your **system administrator**.
    

---

## **5. Adding Recipients**

- Provide the email addresses where notifications should be sent.
    
- You can test using a temporary mailbox like **Mailinator**.
    

---

## **6. Enabling Notifications for a Job**

1. Go to **Templates → Select Job Template**.
    
2. Click on **Notifications**.
    
3. Select your created email notification template.
    
4. Enable notifications for:
    
    - **Job Start**
        
    - **Job Success**
        
    - **Job Failure**
        

---

## **7. Launching Jobs**

- Jobs can be launched from either **Templates** or **Jobs** section.
    
- Execution results:
    
    - If a host is down, the job may **fail for that host**.
        
    - Email notifications will still be sent according to the configured scenarios.
        

---

## **8. Troubleshooting**

- If emails are not received:
    
    - Double-check **SMTP credentials** (username/password).
        
    - Ensure SMTP server is reachable from AWX.
        
    - Verify **recipient email addresses**.
        

---

## **9. Email Content**

- Notification emails contain:
    
    - **Job ID** (e.g., Job #16).
        
    - **Job Name**.
        
    - **Start Time & End Time**.
        
    - **Job Status** (Success/Failure).
        
    - **Additional details** for troubleshooting the job quickly.
        

---

## **10. Summary**

- Email notifications in AWX allow automated monitoring of jobs.
    
- Can be configured for **job start, success, and failure**.
    
- Requires **SMTP server details** and proper recipient configuration.
    
- Ensures teams are alerted in real-time without manually checking jobs.
    

---