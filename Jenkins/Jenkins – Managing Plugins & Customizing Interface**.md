### 1. **Recap**

In the last session, we learned about:

- **Configure System**
    
- **Global Configuration**
    
- How to manage tools and system-wide settings.
    

Now, this video focuses on:

> 🔹 Installing Plugins  
> 🔹 Using Plugins  
> 🔹 Changing Jenkins appearance with Custom CSS/JS

---

### 2. **What are Plugins in Jenkins?**

- **Plugins** extend Jenkins functionality.
    
- They allow Jenkins to integrate with different tools and services.
    
- You can **add, remove, or update plugins** anytime.
    

Examples of plugins:

- **Git Plugin** → to integrate Git repositories.
    
- **Maven Integration Plugin** → for building Java projects.
    
- **Docker Plugin** → to run builds inside Docker containers.
    
- **Slack Plugin** → to send notifications.
    
- **Custom CSS & JavaScript Plugin** → to customize Jenkins appearance.
    

---

### 3. **How to Install a Plugin**

Steps:

1. Go to **Manage Jenkins → Manage Plugins**.
    
2. In the **Available** tab, search for the plugin (e.g., “Custom CSS and JavaScript”).
    
3. Select it and click:
    
    - **“Install without restart”** (recommended)
        
    - or **“Download now and install after restart.”**
        
4. Wait for installation to complete.
    
5. After installation, you may need to **configure** it in **Configure System**.
    

---

### 4. **Example: Custom CSS & JavaScript Plugin**

This plugin allows you to **change the look and feel** of Jenkins.

#### Steps:

1. Search for **“Custom CSS and JavaScript”** in the Available plugins list.
    
2. Install it (as shown above).
    
3. After installation, go to:  
    **Manage Jenkins → Configure System.**
    
4. Scroll down to find the **Custom CSS / JS** section.
    
5. Add your CSS or JS code.
    

Example:

```css
body {
  background-color: indigo;
}
```

This will change Jenkins’ background color to **indigo**.

---

### 5. **Testing the Plugin**

- After saving, refresh Jenkins’ home page — the new styles will apply.
    
- If you make a mistake or don’t like the new look:
    
    1. Go back to **Configure System**.
        
    2. Remove or edit the custom CSS.
        
    3. Save again to revert to the old design.
        

---

### 6. **Important Tips**

- Always install plugins **only from trusted sources**.
    
- Don’t overload Jenkins with unnecessary plugins — it can slow down the system.
    
- Keep plugins **up to date** for security and compatibility.
    
- You can view installed plugins under the **Installed** tab.
    

---

### 7. **If Plugin Doesn’t Work**

- Check if Jenkins needs a restart.
    
- Verify the plugin version supports your Jenkins version.
    
- Look in **Manage Jenkins → System Log** for plugin-related errors.
    

---

### 8. **Reverting Changes**

If a custom CSS/JS breaks the layout:

1. Go to **Manage Jenkins → Configure System.**
    
2. Remove the CSS or JS code.
    
3. Click **Save**.
    
4. Jenkins UI will revert to its default appearance.
    

---

### 9. **Summary Table**

|Action|Menu Path|Description|
|---|---|---|
|Install Plugin|Manage Jenkins → Manage Plugins → Available|Add new functionality|
|Update Plugin|Manage Jenkins → Manage Plugins → Updates|Keep plugins current|
|Uninstall Plugin|Manage Jenkins → Manage Plugins → Installed|Remove unused plugins|
|Apply Custom CSS/JS|Manage Jenkins → Configure System|Change Jenkins appearance|
|Restore Default UI|Remove custom CSS/JS|Revert to default look|

## **Installing Plugins & Customizing Jenkins with CSS and JavaScript**

### 1. **Recap**

In the previous video:

- We learned about **“Configure System”** and **global configurations**.
    
- Discussed how to set global tool paths and system-wide settings.
    

Now, this video explains:

> 🔹 How to **install plugins**  
> 🔹 How to **use the Custom CSS & JavaScript plugin**  
> 🔹 How to **change the Jenkins UI appearance**

---

### 2. **Introduction to Plugins**

- **Plugins** enhance Jenkins by adding extra features and integrations.
    
- Without plugins, Jenkins is just a core automation server — plugins give it power and flexibility.
    
- You can install plugins for:
    
    - Source control (Git, GitHub, Bitbucket)
        
    - Build tools (Maven, Gradle)
        
    - Containers (Docker, Kubernetes)
        
    - Notifications (Slack, Email)
        
    - UI customization (Custom CSS & JS)
        

---

### 3. **Installing a Plugin**

**Steps:**

1. Go to **Manage Jenkins → Manage Plugins**
    
2. Click the **Available** tab
    
3. Search for your desired plugin (e.g., “Custom CSS and JavaScript”)
    
4. Click **Install without restart**
    
    - This installs the plugin immediately without restarting Jenkins
        
5. Wait until the installation completes
    

✅ **Tip:** Always check plugin compatibility with your Jenkins version.

---

### 4. **Example: Installing “Custom CSS and JavaScript” Plugin**

This plugin lets you change Jenkins’ user interface design by applying your own CSS or JS.

**Steps:**

1. Go to **Manage Jenkins → Manage Plugins → Available**
    
2. Search for **“Custom CSS and JavaScript”**
    
3. Select it and click **Install without restart**
    
4. Once installed, go to **Manage Jenkins → Configure System**
    
5. Scroll to the **Custom CSS and JavaScript** section
    
6. Add custom CSS or JS code
    

---

### 5. **Example: Changing Jenkins Background Color**

You can customize Jenkins UI using simple CSS.

For example:

`body {   background-color: indigo; }`

After adding the above code:

- Click **Save**
    
- Refresh Jenkins — the background color will change to **indigo**
    

This is useful for making Jenkins look more personal or theme-based.

---

### 6. **Reverting Back to Default**

If you don’t like the new appearance:

1. Go to **Manage Jenkins → Configure System**
    
2. Remove the custom CSS or JS
    
3. Click **Save**
    
4. Jenkins will return to its original default look
    

✅ **Best Practice:**  
Test small changes first before applying large CSS modifications.

---

### 7. **Understanding Customization Control**

- You can edit and preview how Jenkins looks using CSS and JS.
    
- Changes affect **the entire UI**, not just one project.
    
- Be cautious — wrong CSS can make your UI hard to use.
    

---

### 8. **Searching and Managing Plugins**

- You can **search any plugin** by name or functionality in the Jenkins plugin manager.
    
- Categories include:
    
    - Build Tools
        
    - Source Code Management
        
    - User Interface
        
    - Notifications
        
    - Security
        

---

### 9. **If the Plugin Doesn’t Work or UI Breaks**

- Go back to the **Configure System** page.
    
- Remove your custom code.
    
- Save and refresh Jenkins.
    
- If still broken, disable the plugin under **Manage Plugins → Installed**.
    

---

### 10. **Summary Table**

|Action|Location|Purpose|
|---|---|---|
|Install Plugin|Manage Jenkins → Manage Plugins → Available|Add new functionality|
|Apply Custom CSS/JS|Manage Jenkins → Configure System|Change UI style|
|Revert to Default|Remove CSS/JS → Save|Restore original look|
|Update Plugin|Manage Jenkins → Manage Plugins → Updates|Get latest version|
|Disable Plugin|Manage Jenkins → Manage Plugins → Installed|Turn off faulty plugins|

---

### 11. **Key Takeaways**

- Plugins make Jenkins powerful and flexible.
    
- The **Custom CSS & JS plugin** lets you personalize Jenkins’ appearance.
    
- Always test changes before applying globally.
    
- You can easily revert to the original Jenkins theme anytime.