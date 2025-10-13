Script: `add_user.sh`

```
#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") <username> <public_key_file> [--sudo]" >&2
  exit 1
}

[[ $# -lt 2 ]] && usage

username=$1
pubkey=$2
grant_sudo=${3:-}

if [[ $(id -u) -ne 0 ]]; then
  echo "Run this script as root (use sudo)." >&2
  exit 1
fi

if [[ ! -f $pubkey ]]; then
  echo "Public key file '$pubkey' not found." >&2
  exit 1
fi

if ! getent passwd "$username" >/dev/null; then
  echo "Creating user '$username'..."
  useradd --create-home --shell /bin/bash "$username"
else
  echo "User '$username' already exists; skipping creation."
fi

home_dir=$(getent passwd "$username" | cut -d: -f6 || true)
if [[ -z $home_dir || ! -d $home_dir ]]; then
  echo "Cannot find home directory for '$username'." >&2
  exit 1
fi

ssh_dir="$home_dir/.ssh"
authorized_keys="$ssh_dir/authorized_keys"

install -d -m 700 "$ssh_dir"
touch "$authorized_keys"
chmod 600 "$authorized_keys"

if grep -Fxq "$(cat "$pubkey")" "$authorized_keys"; then
  echo "SSH key already present for '$username'."
else
  cat "$pubkey" >> "$authorized_keys"
  echo "SSH key added for '$username'."
fi

chown -R "$username:$username" "$ssh_dir"

if [[ $grant_sudo == "--sudo" ]]; then
  if [[ -r /etc/os-release ]]; then
    . /etc/os-release
  fi

  sudo_group=""
  if [[ ${ID:-} == "ubuntu" || ${ID_LIKE:-} == *"debian"* ]]; then
    sudo_group="sudo"
  elif [[ ${ID:-} =~ ^(centos|rhel|rocky|almalinux|fedora)$ || ${ID_LIKE:-} == *"rhel"* || ${ID_LIKE:-} == *"fedora"* ]]; then
    sudo_group="wheel"
  elif getent group wheel >/dev/null; then
    sudo_group="wheel"
  elif getent group sudo >/dev/null; then
    sudo_group="sudo"
  else
    echo "Cannot determine sudo group on this system." >&2
    exit 1
  fi

  if id -nG "$username" | tr ' ' '\n' | grep -Fxq "$sudo_group"; then
    echo "'$username' is already in '$sudo_group'."
  else
    usermod -aG "$sudo_group" "$username"
    echo "Granted sudo via group '$sudo_group'."
  fi
else
  echo "Sudo access not requested."
fi

echo "User '$username' ready. Test with: ssh $username@<host>"

```

### 🪜 **Steps to Use**

1. **SSH into the server**
    
    `ssh <your-admin-user>@<server-ip>`
    
2. **Create a directory to store SSH keys**  
    (For example, `user_keys` to hold public key files)
    
    `mkdir -p ~/keys`
    
3. **Create and add the user’s public SSH key**  
    (This key will be used for login)
    
    `nano ~/keys/new_user.pub`
    
    Paste the public key and save.
    
4. **Save the script**  
    Create the script file and make it executable:
    
    `nano add_user.sh`
    
    Paste the script above, then:
    
    `chmod +x add_user.sh`
    
5. **Run the script to create the user and add the SSH key**
    
    `sudo ./add_user.sh <username> <path_to_pubkey>`
    
6. **(Optional)** Grant sudo access to the user by adding `--sudo` at the end:
    
    `sudo ./add_user.sh newuser ~/keys/new_user.pub --sudo`
    
7. **Test SSH access**
    
    `ssh newuser@<server-ip>`