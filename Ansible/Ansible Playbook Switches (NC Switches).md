

When running **Ansible Playbooks**, you can pass **switches** at execution time to control how the playbook runs. These switches can help with **debugging, testing, or controlling task execution**.

---

## **1. Creating a Simple Playbook**

1. Create a playbook file, e.g., `switches_demo.yml`.
    
2. Add a **task** to create a user using the `user` module:
    
```
- name: Create a user
  ansible.builtin.user:
    name: Joe
    state: present

```
1. Target machine is specified as `localhost` (management node).
    
2. Make sure `localhost` exists in your **inventory file** (`hosts`) or you will get an error.
    

---

## **2. Running a Playbook**

Basic command to run a playbook:

```
ansible-playbook -i hosts switches_demo.yml

```

- `-i hosts`: specifies the inventory file.
    
- `switches_demo.yml`: the playbook file.
    

---

## **3. Verbosity Switch (`-v`)**

- **Purpose:** Show more detailed logs during execution. Useful for debugging.
    
- **Levels of verbosity:**
    
    - `-v` → basic verbosity (default)
        
    - `-vv` → more detailed
        
    - `-vvv` → even more detailed
        
    - `-vvvv` → debug-level details
        

**Example:**

`ansible-playbook -i hosts switches_demo.yml -vv`

- Increasing verbosity shows **additional information**, such as task execution details and errors.
    
- Useful when troubleshooting issues.
    

---

## **4. Handling Permission Issues (`become`)**

- If a task requires **elevated privileges** (like creating a user), add the `become` parameter:
    

```
- name: Create a user
  ansible.builtin.user:
    name: Joe
    state: present
  become: yes

```

- `become: yes` allows Ansible to **use sudo privileges** to perform restricted tasks.
    

---

## **5. Step Switch (`--step`)**

- **Purpose:** Execute tasks **interactively**, one by one.
    
- You can **choose whether to run a task or skip it**.
    
- Example command:
    

`ansible-playbook -i hosts switches_demo.yml --step`

**Behavior:**

- Ansible prompts for each task:
    
    `Perform task "Create a user"? (y/n)`
    
- You can choose **y (yes)** to execute or **n (no)** to skip.
    
- Useful for **testing specific tasks** in large playbooks without running all tasks.
    

---

## **6. Check Switch (`--check`)**

- **Purpose:** **Dry run** – Ansible **does not actually perform changes**, only shows what would happen.
    
- Especially useful for **production environments** or **large inventories**.
    

**Example command:**

`ansible-playbook -i hosts switches_demo.yml --check -vv`

**Behavior:**

- Shows which tasks would make changes.
    
- `changed: true` indicates the task **would modify the system** if run normally.
    
- The system remains unchanged (safe to test).
    
- Ideal for **validating new playbooks** before running them on many servers.
    

---

## **7. Summary of Useful Playbook Switches**

|**Switch**|**Purpose**|**Example**|
|---|---|---|
|`-v / -vv / -vvv / -vvvv`|Increase verbosity to see detailed logs|`ansible-playbook -i hosts switches_demo.yml -vv`|
|`--step`|Run tasks interactively, confirm execution task by task|`ansible-playbook -i hosts switches_demo.yml --step`|
|`--check`|Dry run, see what changes would happen without executing|`ansible-playbook -i hosts switches_demo.yml --check`|
|`become: yes` (task parameter)|Execute task with elevated privileges (sudo)|Used in playbook tasks like creating users|

---

## **8. Practical Tips**

1. **Use `--check`** when running a new playbook on production servers.
    
2. **Use verbosity (`-vv`)** to debug why a task failed.
    
3. **Use `--step`** for large playbooks when you want to run only specific tasks interactively.
    
4. Always ensure **permissions** are correct (`become: yes`) for tasks that require elevated access.
    
5. You can combine switches:
    

`ansible-playbook -i hosts switches_demo.yml --check --step -vv`

- This will perform an **interactive dry run** with detailed logs.