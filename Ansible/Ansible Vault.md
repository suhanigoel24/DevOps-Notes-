
## **1. What is Ansible Vault?**

- **Purpose**: To **protect sensitive information** in Ansible, like passwords, credentials, API keys, or any confidential data.
    
- **Problem Scenario**:
    
    - Inventory files (like `hosts`) often contain credentials.
        
    - Anyone with access to the file can see sensitive info (e.g., admin passwords).
        
    - Vault allows encrypting **whole files or specific strings** to keep secrets safe.
        

---

## **2. Basic Setup**

1. **Create a Playbook**
    
    - Example:
        
```
- name: Vault Demo
  hosts: windows_servers
  tasks:
    - name: Ping server
      win_ping:

```
        
    - Purpose: Check if the connection and inventory are working properly before encryption.
        
2. **Run Playbook**
    
    - Command:
        
        `ansible-playbook demo.yml -i hosts`
        
    - Confirms that credentials in `hosts` work.
        

---

## **3. Encrypting an Inventory File**

1. **Encrypt the file**
    
    `ansible-vault encrypt hosts`
    
    - Prompts for a **password** to encrypt the file.
        
    - After encryption, contents appear as unreadable gibberish.
        
2. **Running a Playbook with an encrypted file**
    
    `ansible-playbook demo.yml -i hosts --ask-vault-pass`
    
    - Asks for Vault password to decrypt the file during execution.
        

---

## **4. Decrypting a File**

- To view or edit the file:
    
    `ansible-vault decrypt hosts`
    
- Enter the same Vault password used to encrypt the file.
    

---

## **5. Encrypting Specific Strings**

- Instead of encrypting the whole file, you can encrypt **individual sensitive values**.
    
- Example: Encrypt a password string
    
    `ansible-vault encrypt_string 'admin' --name 'ansible_password'`
    
- Output is an encrypted string that can be used in YAML inventory or variable files.
    

---

## **6. Using Encrypted Strings in YAML Inventory**

1. **Convert inventory to YAML format** (required for encrypted strings):
    
```
win_servers:
  hosts:
    server1:
      ansible_user: Administrator
      ansible_password: !vault |
        $ANSIBLE_VAULT;1.1;AES256
        <encrypted_string_here>

```
    
2. **Test Playbook with YAML inventory**
    
    - Run normally, but include Vault password if using encrypted strings.
        

---

## **7. Running Playbooks with Vault**

### **Interactive Mode**

`ansible-playbook demo.yml -i hosts.yml --ask-vault-pass`

- Prompts every time for Vault password.
    

### **Silent/Automated Mode**

1. Create a **password file** (e.g., `secret.txt`) containing the Vault password.
    
2. Run Playbook:
    
    `ansible-playbook demo.yml -i hosts.yml --vault-password-file secret.txt`
    

- **Alternative**: Store password in **environment variable** and use a script (Python or shell) to pass it automatically.
    

---

## **8. Summary of Encryption Options**

|Option|Usage|Pros|Cons|
|---|---|---|---|
|Encrypt full file|`ansible-vault encrypt <file>`|All sensitive info protected|Need password to run Playbook|
|Encrypt string|`ansible-vault encrypt_string <value>`|Protects only sensitive parts|YAML inventory required|
|Vault password file|`--vault-password-file <file>`|Automates execution|File must be secured|
|Environment variable|Script fetches password|Secure for automation|Slightly more setup|

---

## **9. Key Points**

- Vault is essential for **security in automation**.
    
- Can encrypt **files or individual strings**.
    
- YAML format is required to embed encrypted strings in inventory.
    
- Automation is possible using **Vault password file** or **environment variable**.
    
- Always keep the Vault password **secret**.