

## **1. Creating a New Job**


- **Action:** Go to **“New Item” → “Freestyle Project”**.
    
- Example job name: `demo-second`.
    
- Enter a simple **command/script** inside the “Execute Shell” section.  
    Example:
    
    ```bash
    echo "Hello Hello World from Demo Second Job"
    ```
    
- Click **Apply → Save**.
    

---

## **3. Jenkins Dashboard Overview**

- The dashboard lists all created jobs.  
    Each row shows:
    
    - **Job Name**
        
    - **Build Status Icon** (Blue/Green = Success, Red = Failed)
        
    - **Last Build Result**
        
    - **Last Success/Failure Count**
        
    - **Last Run Time**
        
- **Key indicator:**
    
    - 🔵 **Blue/Green icon** → Job succeeded
        
    - 🔴 **Red icon** → Job failed
        

---

## **4. Understanding Job Build History**

- The dashboard shows **last build results** for each job.
    
- It helps you quickly identify which job failed or passed recently.
    
- Each job’s row also includes:
    
    - Total number of builds
        
    - Build timestamps
        
    - Last build status (Success or Failure)
        

---

## **5. Example Demonstration**

- The instructor created multiple builds:
    
    - `demo-first`
        
    - `demo-second`
        
- He triggered `demo-second` job **5 times**, showing:
    
    - Each build gets a new incremental number (#1, #2, #3…)
        
    - The build status icon updates live after each run.
        

---

## **6. How Jenkins Indicates Success or Failure**

- Jenkins updates job status dynamically:
    
    - If a job fails, the color/icon changes to red.
        
    - If it passes, it remains blue or green.
        
- To intentionally cause a **failure**, the instructor added a command that doesn’t exist:
    
    ```bash
    gaurav
    ```
    
    (Since there’s no command named “gaurav”, Jenkins throws an error and marks the build as failed.)
    
- After running this failed job, the dashboard shows:
    
    - Red icon (failure)
        
    - Updated build history
        
    - Job count increased (failed build still counts)
        

---

## **7. Viewing Build Details**

- Clicking on a job opens:
    
    - Console output of the build
        
    - Success or failure message
        
    - Timestamps
        
    - Build duration
        
- You can re-run or delete builds from here as well.
    

---

## **8. Search Bar Functionality**

- The **search bar** in Jenkins isn’t just for searching — it’s also a **navigation shortcut**.
    
- You can type:
    
    - Job name → to open that job directly
        
    - Build number → to open that specific build
        
- Example:
    
    - Typing `demo-first` takes you directly to that job.
        
    - Typing `demo-first #32` takes you directly to build #32.
        
- This saves time versus clicking multiple times through menus.
    

---

## **9. Best Practices for Naming Jobs**

- Always follow a **consistent naming convention** for your Jenkins jobs.
    
- Example convention:
    
    ```
    <ProjectName>-<Environment>-<Purpose>
    ```
    
    Examples:
    
    - `testproject-build`
        
    - `testproject-deploy`
        
    - `testproject-pipeline`
        
- This helps you:
    
    - Identify which project a job belongs to
        
    - Distinguish between build/test/deploy jobs
        
    - Use the search bar effectively
        

---

## **10. Summary**

- You learned:
    
    1. How to create multiple freestyle jobs.
        
    2. How to interpret job status icons (success/failure).
        
    3. How to view build history and details.
        
    4. How to use the Jenkins **search bar** to quickly navigate jobs and builds.
        
    5. The importance of **proper job naming conventions** for easier management.
        

---

## **11. Key Takeaways**

- Jenkins Dashboard shows **all job summaries** in one view.
    
- **Color codes** quickly indicate job health.
    
- **Search bar = power navigation tool** — jump straight to any job or build.
    
- **Naming conventions** help maintain large Jenkins setups cleanly.
    
- Regularly clean old builds or failed jobs to keep Jenkins lightweight.
    

## **Jenkins – Configure System

### 1. **Overview**

In this video, the speaker explains the **“Configure System”** section in Jenkins.  
This area contains all **global configuration and administrative settings** used to control how Jenkins operates.

---

### 2. **Configure System**

- Found under **“Manage Jenkins → Configure System.”**
    
- Used to configure **global settings** for all Jenkins jobs and tools.
    

#### **Key Uses:**

- Configure any **installed plugin** (e.g., Maven, Git, Gradle, Docker, etc.).
    
- Set **tool paths** like `JAVA_HOME`, `MAVEN_HOME`, or `GIT_HOME`.
    
- Define **environment variables** that can be used across Jenkins jobs.
    
- Update any global parameters related to builds and environment.
    

---

### 3. **Security Configuration**

- This section manages **user access, authentication, and permissions**.
    
- You can control:
    
    - Whether anonymous users can view or trigger jobs.
        
    - Whether new users can **sign up** or must be added manually.
        
    - What access permissions each user or group should have.
        
    - URL access settings (who can access Jenkins remotely).
        

---

### 4. **Manage Plugins**

- Located under **“Manage Jenkins → Manage Plugins.”**
    
- Allows you to:
    
    - **Install** new plugins.
        
    - **Update** existing ones.
        
    - **Disable** or **uninstall** plugins.
        
- Plugins extend Jenkins functionality — for example, for Docker, Slack notifications, Maven, etc.
    

---

### 5. **Manage Nodes and Clouds**

- Jenkins can distribute workloads across multiple machines (called **nodes** or **agents**).
    
- This section lets you:
    
    - Add and configure new build agents.
        
    - Define **executor count** (how many jobs a node can run simultaneously).
        
    - Assign **labels** to nodes to target specific jobs to specific machines.
        
    - Connect cloud providers (like AWS, GCP, or Kubernetes).
        

---

### 6. **System Message**

- A **notice banner** displayed at the top of the Jenkins dashboard.
    
- Configured in the **Configure System** page.
    
- Example:  
    _“Hello Developers! Jenkins will be down for maintenance at 6 PM.”_
    
- Useful for notifying users about maintenance, policy changes, etc.
    

---

### 7. **Executors**

- Determines how many builds Jenkins can run **in parallel** on a node.
    
    - Example: 2 executors = 2 concurrent builds.
        
- Keep in mind:  
    More executors → more load on the system (CPU/RAM).  
    So adjust based on system resources.
    

---

### 8. **Typical Global Configurations**

|Category|Example|
|---|---|
|JDK Path|`/usr/lib/jvm/java-17-openjdk`|
|Maven Installation|`/opt/maven/bin/mvn`|
|Git Path|`/usr/bin/git`|
|Environment Variable|`BUILD_ENV=staging`|
|System Message|“Welcome to Jenkins CI Server”|

---

### 9. **Summary**

|Section|Purpose|
|---|---|
|**Configure System**|Manage global Jenkins settings and tool paths|
|**Security**|User authentication and access control|
|**Manage Plugins**|Install, update, or remove plugins|
|**Manage Nodes**|Add agents and control parallel build execution|
|**System Message**|Display custom notices on the dashboard|
|**Executors**|Control number of parallel builds on each node|
