
## 🧩 What is Packer?

Think of **Packer** like a **magical copy machine for servers**.

- You tell it: “Here’s a base server (like Ubuntu or Amazon Linux), install these programs, tweak these settings, and make it look exactly like I want.”
    
- Packer then **automatically makes an AMI** (or other types of images) for you — no manual clicking in AWS.
    

So instead of doing things by hand every time, you **write it once** and Packer **repeats it perfectly**.

---

### 🧠 Why we use Packer

1. **Consistency:** Every AMI you create looks exactly the same. No human mistakes.
    
2. **Speed:** Make new AMIs automatically, faster than doing everything manually.
    
3. **Automation:** Works well with pipelines — devs or devops can make new server images automatically.
    
4. **Multi-cloud:** Not just AWS — you can make images for Azure, Google Cloud, VMware, etc.
    

---

## 🚀 How Packer Works (Step-by-Step)

Imagine Packer as a **robot chef** making your “server cake”:

1. **Pick a Base** 🥣
    
    - Example: Start with **Amazon Linux 2** or **Ubuntu**.
        
2. **Write a Recipe** 📜
    
    - In Packer, this is called a **template** (a JSON or HCL file).
        
    - You tell it what software to install, configs to change, scripts to run.
        
    
    Example:
    
```
source "amazon-ebs" "my-ami" {
  region      = "us-east-1"
  instance_type = "t2.micro"
  ami_name    = "myapp-ami-{{timestamp}}"
  source_ami  = "ami-0abcdef1234567890" # base AMI
}

build {
  name = "myapp-ami-build"
  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y nginx",
      "echo 'Hello World' > /var/www/html/index.html"
    ]
  }
}

```
    
3. **Press “Go”** ▶️
    
    - Packer launches a temporary EC2 instance.
        
    - It installs everything you told it to (like your recipe).
        
    - When it’s done, it **takes a snapshot** and saves it as a new AMI.
        
    - Then the temporary EC2 is deleted automatically.
        
4. **Use Your AMI** 🚀
    
    - Now you have a **ready-to-use AMI**.
        
    - You can launch EC2 instances or update your Auto Scaling Group with it.
        

---

### 🎯 Real-life Analogy

- **Base AMI** = plain cupcake
    
- **Packer recipe** = frosting, sprinkles, and decorations
    
- **Final AMI** = beautiful, ready-to-eat cupcake that looks exactly the same every time
    

---

### 🧩 TL;DR

- Packer = automatic AMI builder
    
- Why? Because it’s **fast, repeatable, and mistake-free**
    
- Steps: Base AMI → Packer template → Run → New AMI → Launch instances
    

---
# Packer — clear, easy-to-follow notes 
---
## One-line summary

**Packer** is a HashiCorp tool dedicated to building machine images (AMIs for AWS, images for Azure/GCP, Docker images, Vagrant boxes, etc.). Use Packer to _automate_ and _standardize_ image creation so you never configure servers manually.

---

## Why use Packer (short)

- Purpose-built for image creation (better than shoehorning image creation into Terraform).
    
- Produces repeatable, versioned images with OS + packages + config + app code baked in.
    
- Works across multiple platforms from one configuration.
    

---

## File types and naming

- Packer HCL2: `something.pkr.hcl` — modern recommended format.
    
- JSON template: `something.json` — legacy format, still supported by older workflows.
    
- When you run Packer without a filename, it defaults to the `.pkr.hcl` in the current directory.
    

---

## Main blocks in a Packer config

1. **packer.required_plugins** — declare plugins Packer must download (e.g., `amazon` plugin).
    
2. **source "amazon-ebs" "name"** — builder block: defines how to create the machine (region, source AMI, instance type, ssh user, IAM role, tags).
    
3. **build { sources = [...] }** — references builders to run.
    
4. **provisioner** — commands (shell/ansible) executed inside the temporary instance to install packages and configure it.
    
5. **post-processor** — optional; runs after AMI creation (e.g., produce vagrant box, compress artifacts, create manifest).
    

---

## Demo flow (what happens when you run `packer build`)

1. `packer init` downloads required plugins (if HCL template declares them).
    
2. `packer build` begins:
    
    - Packer finds the source AMI (base image).
        
    - Packer launches a temporary EC2 instance from that source AMI (using the builder config).
        
    - Packer waits until SSH is available.
        
    - Packer runs provisioners (shell scripts, ansible, etc.) to customize that instance.
        
    - Once provisioners finish, Packer stops the instance and creates an AMI (snapshot).
        
    - Packer waits for the AMI to be ready, cleans up temporary resources (key pairs, instance, security group) and runs post-processors.
        
3. You find the resulting AMI under **EC2 → AMIs** (status: Available).
    

---

## Key commands used in demo

- `packer init .` — initialize directory (download plugins for HCL).
    
- `packer fmt .` — format HCL files (nice-to-have).
    
- `packer validate <file>` — check config correctness.
    
- `packer build <file>` — run the build and create the AMI.
    
- Example: `packer build aws-ubuntu.pkr.hcl` or `packer build aws-ami.json` (depending on file format).
    

---

## What to include in your builder block (minimum useful fields)

- `region` — where the AMI will be built.
    
- `instance_type` — temporary instance size used during build (`t2.micro` for small builds).
    
- `source_ami` or `source_ami_filter` — the base image. `source_ami_filter` helps pick the latest official image.
    
- `ssh_username` — user Packer will use to SSH into the instance (`ubuntu` for Ubuntu base AMIs, `ec2-user` for Amazon Linux).
    
- `ami_name` — name to give the created AMI (you can add a timestamp manually).
    
- `iam_instance_profile` (optional) — attach an IAM role to the temporary instance so it has permissions (recommended instead of embedding keys).
    
- `subnet_id`, `security_group_id`, `associate_public_ip_address` — networking so Packer can reach SSH.
    

---

## Provisioners (what they do)

- Run shell scripts or commands inside the temporary instance to:
    
    - `apt update` / `yum update`
        
    - install packages (nginx, docker, etc.)
        
    - enable/start services
        
    - configure firewall rules (ufw/iptables)
        
- You can put those commands inline or reference script files (e.g., `provision.sh`).
    

---

## Post-build cleanup (deleting AMIs correctly)

If you want to remove an AMI:

1. **Deregister the AMI** (EC2 → AMIs → Actions → Deregister).
    
2. **Delete associated snapshot(s)** (EC2 → Snapshots) — otherwise you still get storage charges.
    

---

## Authentication / credentials — how Packer authenticates to AWS

- **Recommended:** Attach an **IAM role** to the EC2 where Packer runs, so Packer picks up temporary credentials automatically (no keys in files).
    
- **Alternative:** Run `aws configure` and store Access Key ID & Secret Access Key in `~/.aws/credentials` (not recommended for long-term or production).
    
- **Do not hardcode** credentials in Packer files.
    

---

## Practical tips & gotchas from the transcript

- **`packer init`** (HCL) is required to download plugins. Without `packer.required_plugins` Packer may not know to fetch the Amazon plugin.
    
- **Source AMI is region-specific** — ensure you choose a base AMI ID/template valid for the target region. `source_ami_filter` is handy to auto-select the most recent official image.
    
- **Provisioning takes time** (package updates & installs); be patient.
    
- **Packer creates temporary resources** (key pair, SG, EC2) during build; it will usually clean them up, but check the console if something fails.
    
- **Testing:** Always launch an EC2 from the produced AMI to verify your services are installed and started (e.g., open `http://<public-ip>` to check nginx).

### Example minimal HCL flow (illustrative, not full file)

```
packer {
  required_plugins {
    amazon = { source = "github.com/hashicorp/amazon", version = ">= 1.0.0" }
  }
}

source "amazon-ebs" "ubuntu" {
  region        = "ap-south-1"
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  source_ami_filter {
    owners      = ["099720109477"] # official Ubuntu owner
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    }
    most_recent = true
  }
  ami_name = "my-packer-ubuntu-001"
}

build {
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

```

Run:

```
packer init .
packer validate packer-ami.pkr.hcl
packer build packer-ami.pkr.hcl
```

## Best practices (short list)

- Attach an IAM role to the Packer host instead of storing keys.
    
- Use `source_ami_filter` to pick the latest official base image rather than hardcoding an AMI ID.
    
- Add smoke tests (curl localhost) in provisioners to fail early.
    
- Tag AMIs with metadata (version, environment, team) so you can manage/rotate them.
    
- Automate Packer builds in CI (scheduled or on code changes) to keep images patched.