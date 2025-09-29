
## **File Ownership**

Every file or directory in Linux has **three types of owners** associated with it:

|Owner Type|Description|
|---|---|
|**User (u)**|The owner of the file. Usually the creator of the file.|
|**Group (g)**|A group of users. The file can be associated with a group.|
|**Others (o)**|Everyone else on the system who is not the owner or in the group.|

You can check ownership using:

`ls -l <file>`

Example output:

`-rw-r--r-- 1 suhani dev 1024 Sep 29 12:00 myfile.txt`

Explanation:

- `suhani` → **user** (file owner)
    
- `dev` → **group**
    
- `-rw-r--r--` → permissions (we’ll explain next)

## **File Permissions**

There are **three types of permissions**:

|Permission|Symbol|What it allows|
|---|---|---|
|**Read**|r|View the contents of the file.|
|**Write**|w|Modify or delete the file.|
|**Execute**|x|Run the file (if it’s a program or script).|

Permissions apply **separately** for **user, group, and others**.

### Example:

`-rwxr-xr--`

Breakdown:

| Position | Meaning                                   |
| -------- | ----------------------------------------- |
| `rwx`    | User can read, write, execute             |
| `r-x`    | Group can read and execute, but not write |
| `r--`    | Others can only read                      |
## **Changing Permissions**

### Symbolic Mode (letters)

```
chmod u+x file.txt    # Add execute permission for user
chmod g-w file.txt    # Remove write permission from group
chmod o+r file.txt    # Add read permission for others
chmod a+x file.txt    # Add execute for all (u, g, o)

```

- `u` = user
    
- `g` = group
    
- `o` = others
    
- `a` = all

  
### Numeric Mode (octal)

Permissions can also be represented as numbers:

|Number|Permission|Binary|
|---|---|---|
|0|---|000|
|1|--x|001|
|2|-w-|010|
|3|-wx|011|
|4|r--|100|
|5|r-x|101|
|6|rw-|110|
|7|rwx|111|
Example:

`chmod 755 script.sh`

- User = 7 → rwx
    
- Group = 5 → r-x
    
- Others = 5 → r-x

  
  ## **Changing Ownership**

To change **user** or **group** ownership:

```
chown newuser file.txt       # Change owner 
chown newuser:newgroup file.txt  # Change owner and group

```
Example:

`chown suhani:dev myfile.txt`

## **Directory Permissions Special Notes**

- **Read (`r`)** → Can list files inside the directory.
    
- **Write (`w`)** → Can create/delete files inside.
    
- **Execute (`x`)** → Can enter the directory (`cd`).
    

💡 So, to access a directory, **execute (`x`) permission is mandatory**, even if you have read permission.

---

### 🔍 Quick Tip

Use `ls -l` to check permissions and ownership:

```
drwxr-xr-x  2 suhani dev 4096 Sep 29 12:00 mydir
-rw-r--r--  1 suhani dev 1024 Sep 29 12:00 myfile.txt

```

- `d` → directory, `-` → file
    
- First three = user perms, next three = group, last three = others


