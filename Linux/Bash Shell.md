
**What is Bash?**

- Bash stands for **Bourne Again SHell**.
    
- It is the **default shell** on most Linux distributions and macOS (Zsh is default on newer macOS versions, but Bash is still widely used).
    
- It allows you to **interact with the system** by typing commands, running scripts, and managing processes.
    
- Supports **command history**, **scripting**, and **job control**.
    

---

### **Key Bash Features**

|Feature|Description|Example / Usage|
|---|---|---|
|**Command History**|Stores previously executed commands|Navigate with ↑ / ↓ arrow keys. View history with `history`.|
|**Auto-completion**|Auto-completes commands, files, and directories|Press **Tab** to autocomplete partial commands or paths.|
|**Aliases**|Create shortcuts for commands|Example: `alias ll='ls -lah'` → now `ll` runs `ls -lah`.|
|**Job Control**|Manage background/foreground processes|`&` → run command in background, `jobs` → list jobs, `fg %1` → bring job to foreground.|
|**Scripting**|Automate tasks using scripts|Create `.sh` files with commands, make executable with `chmod +x script.sh`, run with `./script.sh`.|

---

💡 **Tips for Using Bash Efficiently:**

1. Combine commands using `;`, `&&`, or `||` for more complex workflows.
    
2. Use `Ctrl + R` for **reverse search** in command history.
    
3. Use `man bash` to explore all built-in Bash features.
   
   
## **Bash Scripting Basics**

### **1️⃣ Create a New Script File**

`nano script.sh`

- Opens the **nano editor** to create or edit `script.sh`.
    
- You can also use `vi script.sh` or `vim script.sh` if you prefer.
    

---

### **2️⃣ Add Script Content**
```
#!/bin/bash 
echo "Hello, World!"
```

- `#!/bin/bash` → called a **shebang**, tells the system to use Bash to run the script.
    
- `echo "Hello, World!"` → prints text to the terminal.
    

---

### **3️⃣ Make the Script Executable**

`chmod +x script.sh`

- `chmod +x` gives **execute permission** to the script so it can be run.
    

---

### **4️⃣ Run the Script**

`./script.sh`

- `./` indicates the script is in the current directory.
    
- Output will be:
    

`Hello, World!`

---

### **💡 Extra Tips for Beginners**

1. **Comments**: Use `#` to add comments in your script.
    
    `# This is a comment`
    
2. **Variables**:
    
```
    name="Suhani"
	echo "Hello, $name"

```
1. **Loops**:
```
for i in {1..3}; do
    echo "Number $i"
done

```
    
2. **Conditional Statements**:
    
```
if [ $name == "Suhani" ]; then
    echo "Welcome!"
fi

```
    
3. **Running Without `./`**:
    
    - Add the script’s directory to `$PATH` or run with `bash script.sh`.
- 