
# Why connect Jira → Ansible (business value)

- **Turn tickets into actions**: Jira is the source of truth for work; Ansible executes it automatically. No manual copy/paste.
    
- **Speed & consistency**: tasks that took 1–2 hours (create accounts, provision envs) become minutes and idempotent.
    
- **Audit trail & transparency**: Jira shows the request, status, and the automation result (logs, success/fail).
    
- **Scale safely**: run the same workflow for 1 or 1000 items reliably.
    
- **Reduce human error**: automation enforces the exact steps every time.
    

---

# Two common integration patterns

1. **Event-driven (webhook-triggered)** — Jira sends a webhook when a ticket is created/transitioned → Ansible job is launched (recommended for real-time ops).
    
2. **Polling (scheduled)** — A scheduled playbook checks Jira API for open tickets and processes them (simple, lower infra needs, but slower).
    

I'll focus primarily on the **event-driven** pattern (webhook → AWX/Tower or custom receiver → launch Ansible job) because it's the most powerful and common in enterprises.

---

# High-level architecture (event-driven)

```
Jira (ticket created) 
└─> Jira webhook (POST JSON) 
    └─> Webhook receiver (lightweight service) OR directly AWX webhook endpoint
        └─> Authenticate & map fields → Launch AWX/Tower Job Template (Ansible)
            └─> Playbook runs on target hosts (idempotent roles)
                └─> Register outputs / status
                   └─> Webhook receiver or AWX polls job → Update Jira via REST (comment/transition/attachment)

```
---

# Example use-case: Onboard new employee “John” — detailed flow

### 1) Start in Jira

- An HR or IT person creates a Jira issue with:
    
    - Summary: `Create user – John Doe`
        
    - Description or custom fields: `username: john.doe`, `email: john.doe@example.com`, `groups: dev,git`, `manager: alice`
        
    - Status: `Ready for Provisioning` (or a transition named “Approved”)
        

### 2) Trigger

- When the issue is transitioned to `Approved` (or created with a certain label), Jira Automation or webhook posts JSON to a URL.
    
    - (You can configure Jira Automation to only send payloads for certain issue types or statuses.)
        

### 3) Webhook Receiver (middleware)

- **Why a receiver?**: Jira webhooks are generic; AWX/Tower expects certain auth and input shape. A middleware lets you:
    
    - validate/sanitize payload,
        
    - map custom Jira fields to the variables your playbook expects,
        
    - store a record (audit DB) and issue id ↔ job id mapping,
        
    - then call AWX/Tower API securely.
        
- Implementation choices:
    
    - small Flask/FastAPI Lambda or container
        
    - serverless (AWS Lambda + API Gateway) or small VM
        
    - in some environments, AWX can accept webhooks directly — but middleware is safer and flexible.
        

**Sample webhook minimal payload** (Jira):

```
{
  "issue": {
    "key": "HR-1234",
    "fields": {
      "summary": "Create user - John Doe",
      "description": "username: john.doe\nemail: john.doe@example.com",
      "customfield_10010": "john.doe",  // e.g. username
      "customfield_10011": "john.doe@example.com"
    }
  },
  "user": { "name": "hr.person" },
  "webhookEvent": "jira:issue_updated"
}

```
### 4) Receiver parses and launches AWX job

- Extract variables:
    
    - `username = issue.fields.customfield_10010`
        
    - `email = issue.fields.customfield_10011`
        
    - `issue_key = issue.key`
        
- Launch AWX/Tower job template via API with `extra_vars`:
    

```
curl -s -X POST "https://awx.example.com/api/v2/job_templates/42/launch/" \
  -H "Authorization: Bearer $AWX_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "extra_vars": {
      "username":"john.doe",
      "email":"john.doe@example.com",
      "jira_issue":"HR-1234"
    }
  }'

```

- Response includes `job` id. Store job id so you can query status later.
    

### 5) AWX runs Ansible job (playbook)

- Job Template calls a playbook that uses roles and modules to perform onboarding:
    
    - Create Linux account (Ansible `user` module)
        
    - Add to groups (`user` / `group` module)
        
    - Create mailbox via API (e.g., Exchange / Google Workspace — `uri` module or provider-specific module)
        
    - Add GitLab / GitHub account via API (`uri` or gitlab modules)
        
    - Invite to Slack/Teams (Slack modules or webhook)
        
    - Configure home directories, SSH keys, git access, etc.
        
- Playbook captures results via `register` variables and organizes a summary.
    

**Example simplified playbook `onboard_user.yml`:**

```
- name: Onboard user
  hosts: localhost
  vars:
    username: "{{ username }}"
    email: "{{ email }}"
    jira_issue: "{{ jira_issue }}"
  tasks:
    - name: Create linux user
      user:
        name: "{{ username }}"
        shell: /bin/bash
        state: present
        groups: "developers"
      register: user_create

    - name: Ensure home dir and SSH authorized_keys
      file: 
        path: "/home/{{ username }}/.ssh"
        state: directory
        owner: "{{ username }}"
        mode: '0700'

    - name: Create mailbox via REST API (example)
      uri:
        url: "https://email-api.example.com/users"
        method: POST
        headers:
          Authorization: "Bearer {{ email_api_token }}"
        body_format: json
        body:
          username: "{{ username }}"
          email: "{{ email }}"
        status_code: 201
      register: mail_create
      failed_when: mail_create.status not in [201,200]

    - name: Collect summary
      set_fact:
        onboarding_summary: |
          User create: {{ user_create.changed }}, rc: {{ user_create.rc | default('NA') }}
          Mailbox: {{ mail_create.status | default('NA') }}

```

### 6) Post back to Jira

- The webhook receiver watches AWX job status (periodically poll AWX job endpoint), or AWX can call a callback when job completes (webhook).
    
- When job completes:
    
    - Post a comment on Jira with summary (success/fail, logs link).
        
    - Optionally change Jira issue status to `Done` or `Failed`.
        
    - Attach logs (if allowed) or store logs in central logging and include link.
        

**Ansible task to update Jira (inside playbook)**:

```
- name: Post result to Jira
  uri:
    url: "https://your-instance.atlassian.net/rest/api/2/issue/{{ jira_issue }}/comment"
    method: POST
    user: "{{ jira_user }}"
    password: "{{ jira_token }}"
    force_basic_auth: yes
    body_format: json
    body:
      body: "Onboarding complete: {{ onboarding_summary }}"
    status_code: 201

```

> Tip: Use the receiver to do status transitions and attachments to keep playbook cleaner.

---

# Security & Secrets management (CRITICAL)

- **Never** keep credentials in Jira fields or inline playbooks. Use secure store:
    
    - **AWX/Tower Credentials**: store SSH keys, cloud creds, API tokens.
        
    - **Ansible Vault** for playbook-level secrets (encrypt group_vars/host_vars).
        
    - **HashiCorp Vault** (best), AWS Secrets Manager for dynamic/rotated creds.
        
- **Least privilege**: service accounts for AWX and Jira integration should have only necessary scopes (e.g., Jira API token that can comment/transition, not admin).
    
- **Network controls**: webhook receiver and AWX endpoints should be on private network or whitelisted via IP allow list.
    
- **Authentication**:
    
    - Jira → webhook uses secret header or token to verify source.
        
    - Receiver → AWX uses AWX API token (Rotate regularly).
        
    - AWX uses stored credentials to talk to managed hosts.
        
- **Input validation & sanitization**: sanitize Jira content before passing to playbooks (no shell injection).
    
- **Audit & logging**: store job logs outside Jira (ELK/CloudWatch) and only link to logs in Jira tickets.
    

---

# Error handling & retries

- Use `register` to capture module results, and `failed_when` / `changed_when` to control flow.
    
- Implement conditional `when` checks so subsequent tasks run only if previous succeeded.
    
- For long-running or external failures, return structured statuses to Jira:
    
    - `SUCCESS`, `PARTIAL_SUCCESS` (some subtasks failed), `FAILED`.
        
- Use AWX notifications to alert on job failures (email, Slack).
    
- Implement idempotent playbooks so re-runs are safe.
    

---

# Approvals and human-in-the-loop

- **Approval before run**:
    
    - In Jira workflow, add a transition `Approve Provision` that only authorized users can trigger → webhook triggers only after approval.
        
    - Or have AWX Job Template use a `Survey` or manual approval step (JT + Workflow with prompt).
        
- **Manual verification**:
    
    - Job runs in staging by default. Promoted to production only after QA signoff.
        

---

# Testing & CI/CD for playbooks

- **Version control**: playbooks & roles stored in Git (branching, PRs).
    
- **Unit testing**: use **molecule** to test roles locally (Docker/Podman).
    
- **Linting**: ansible-lint, yamllint in CI pipeline.
    
- **Integration tests**: test with a small fleet in staging environment before production.
    
- **Deployment**:
    
    - On PR merge, CI runs tests and then updates AWX project (or AWX pulls from Git if configured).
        
    - Tag releases for production changes.
        

---

# Observability & Compliance

- **Logs**: AWX logs + centralized log sys (ELK, Splunk).
    
- **Metrics**: job counts, success rates, mean time to provision.
    
- **Audit**: Jira ticket + AWX job ID + logs form a full audit trail (who requested, who approved, what ran, what changed).
    
- **Retention**: keep logs for required retention period.
    

---

# Practical code snippets & examples

### A. Example AWX launch (curl)

```
curl -X POST "https://awx.example.com/api/v2/job_templates/42/launch/" \
  -H "Authorization: Bearer $AWX_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "extra_vars":{
      "username":"john.doe",
      "email":"john.doe@example.com",
      "jira_issue":"HR-1234"
    }
  }'

```
### B. Poll AWX job status (to update Jira)

1. Save the `job.id` from the launch response.
    
2. Poll `/api/v2/jobs/<id>/` and check `status` = `successful` / `failed`.
    
3. On completion, call Jira API to add comment / transition.
    

### C. Minimal webhook receiver (Python Flask outline)

```
from flask import Flask, request, jsonify
import requests, os, base64

app = Flask(__name__)
AWX_TOKEN = os.environ['AWX_TOKEN']

@app.route('/jira-webhook', methods=['POST'])
def jira_webhook():
    payload = request.json
    issue = payload['issue']
    issue_key = issue['key']
    username = issue['fields']['customfield_10010']
    email = issue['fields']['customfield_10011']
    # sanitize inputs here
    resp = requests.post(
      "https://awx.example.com/api/v2/job_templates/42/launch/",
      headers={"Authorization": f"Bearer {AWX_TOKEN}"},
      json={"extra_vars": {"username": username, "email": email, "jira_issue": issue_key}}
    )
    return jsonify({'launched': resp.json()}), 202

```

> Production receiver must validate the webhook signature, handle errors, log to persistent store, and avoid blocking (use background queue for polling job status).

---

# Mapping Jira fields → Ansible variables

- Use Jira custom fields (or description parsing) to include the exact data Ansible needs.
    
- Mapping should be defined in middleware; never rely on free-text parsing if possible.
    
- Example mappings:
    
    - `customfield_userName` → `username`
        
    - `customfield_groups` → `linux_groups` (comma-separated → list)
        
    - `components` → `env` (staging/prod)
        

---

# Approval workflows & safety checks (recommended)

- **Two-stage**: Jira ticket created → approver moves to `Approved` → webhook triggers automation.
    
- **Dry-run**: optionally run playbook with `--check` and attach results to Jira before actual run.
    
- **Canary**: Apply changes to small test set first; if OK, continue to rest via playbook logic.
    

---

# Example workflows beyond onboarding

- **Environment provisioning**: ticket has env params → playbook provisions infra (cloud modules) + deploys app + provides URL back in Jira.
    
- **Patch window**: security team raises a task, Ansible patches servers and posts final compliance report back to Jira.
    
- **Incident remediation**: Ops raises incident -> Ansible runs restart & fix tasks and updates issue.
    

---

# Implementation roadmap / checklist (practical)

1. **Define use-cases & acceptance criteria** (start small: user onboarding; then expand).
    
2. **Design architecture**: AWX/Tower + webhook receiver, or direct AWX webhook.
    
3. **Secure credentials**: set up AWX credentials & secrets (Vault).
    
4. **Create playbook roles** (idempotent roles: linux_user, mailbox, gitlab_user).
    
5. **Create AWX job templates** and surveys for required inputs.
    
6. **Create webhook receiver** (validate, sanitize, map fields).
    
7. **Configure Jira webhook or Automation rule** to call receiver only for specific events.
    
8. **Test**: unit tests (molecule), staging runs, integration tests.
    
9. **Add Jira update logic**: job-id mapping, polling/completion updates, and comments.
    
10. **Add monitoring & alerts**: AWX notifications, Slack messages, etc.
    
11. **Train users**: show HR/IT how to create the Jira issue, include required fields.
    
12. **Rollout**: phased rollout with audit & rollback plan.
    

---

# Common pitfalls & how to avoid them

- **Passing raw text from Jira → shell**: sanitize and never substitute unsanitized text into shell commands.
    
- **Missing approvals**: enforce transition-based triggers or manual checks for risky changes.
    
- **Storing creds in Jira**: never.
    
- **No testing**: use molecule + CI to catch regressions.
    
- **No rollback**: design playbooks to be idempotent and include a revert role if possible.
    

---

# Quick checklist for a production-ready setup

-  Playbooks & roles in Git, PR + code review
    
-  CI pipeline for lint/test
    
-  AWX/Tower with RBAC & cred store
    
-  Webhook receiver with auth & validation
    
-  Secrets in Vault/Ansible Vault/AWX cred store
    
-  Jira Automation configured for particular transitions only
    
-  Logging centralization & Jira comments on completion
    
-  Health metrics & alerts for failed jobs
    
-  Clear runbook & rollback plan
    

---

## Final summary (one-paragraph)

Linking Jira to Ansible makes tickets actionable: when an approved Jira issue appears, your automation platform (AWX/Tower or custom runner) runs vetted, tested, idempotent playbooks to perform the requested tasks, posts the results back into Jira (comments, status, attachments), and keeps everything auditable, fast, and consistent. Use webhooks (event-driven) + a small secure receiver or AWX’s API, store credentials safely (Vault/AWX), develop roles with tests, and implement robust error handling and approvals to operate safely at scale.