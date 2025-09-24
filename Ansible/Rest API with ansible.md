
### 🔹 Why use REST API with Ansible?

- Many modern tools (like Jira, GitHub, Jenkins, cloud providers) expose **REST APIs**.
    
- With Ansible, you can call these APIs inside playbooks to **automate tasks** beyond servers (e.g., create Jira tickets, fetch user info, manage cloud resources).
    

---

## 1. The Key Module → **`uri`**

- Ansible uses the **`uri` module** to interact with REST APIs.
    
- It lets you send:
    
    - `GET` requests → fetch data
        
    - `POST` requests → create new resources
        
    - `PUT/PATCH` requests → update resources
        
    - `DELETE` requests → remove resources
        

---

## 2. Basic Example

```
- name: Call REST API
  hosts: localhost
  tasks:
    - name: REST API example
      uri:
        url: "https://restcountries.com/v3.1/name/india"
        method: GET
        status_code: 200
      register: rest_response

    - name: Show API response
      debug:
        msg: "{{ rest_response }}"

```

🔑 **Explanation**:

- `url`: API endpoint.
    
- `method`: Type of HTTP request (GET here).
    
- `status_code`: Expected success code (200 = OK).
    
- `register`: Stores the response in a variable.
    
- `debug`: Prints the response.
    

---

## 3. The `register` Variable Structure

When you register an API response, you get a **dictionary** with details like:

- `status` → HTTP status code (e.g., 200)
    
- `json` → parsed JSON response (if API returns JSON)
    
- `content` → raw response body
    

👉 You usually access `response.json` to work with data.

---

## 4. Real-World Example → **Jira Integration**

### Playbook Snippet:

```
- name: Get Jira tasks
  hosts: localhost
  tasks:
    - name: Call Jira API
      uri:
        url: "https://your-jira-instance.atlassian.net/rest/api/2/search"
        method: GET
        user: "{{ jira_user }}"
        password: "{{ jira_token }}"
        force_basic_auth: yes
        status_code: 200
      register: jira_response

    - name: Show task summaries
      debug:
        msg: "{{ item.fields.summary }}"
      loop: "{{ jira_response.json.issues }}"

```

🔑 **Explanation**:

- `user` & `password`: Credentials (username + API token).
    
- `force_basic_auth`: Forces basic authentication (instead of OAuth).
    
- `jira_response.json.issues`: Contains list of issues returned by Jira.
    
- Loop extracts the **summary** field of each issue.
    

---

## 5. How This Can Be Used

- Automate **user creation**:
    
    1. Jira task created with "Create user John".
        
    2. Ansible playbook fetches this Jira issue via API.
        
    3. Playbook uses that username (`John`) to run another play that creates the user on servers.
        
- Automate **environment setup**:
    
    - Jira ticket: "Setup test environment for project X".
        
    - Ansible fetches details → runs playbooks to provision infra.
        

---

## 6. Benefits

✅ Connect Ansible with any tool that has an API.  
✅ Standardize workflows (e.g., ticket → automation).  
✅ Reduce manual API calls (done automatically inside playbooks).

---

⚡ **In summary:**

- Use the `uri` module for REST API calls.
    
- `register` stores responses.
    
- Access `response.json` for structured data.
    
- Combine with loops and conditions for powerful automations.