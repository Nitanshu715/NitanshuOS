
<p align="center">
  <img src="https://github.com/Nitanshu715/NitanshuOS/raw/main/NitanshuOS.PNG" alt="NitanshuOS Logo" width="220"/>
</p>

<h1 align="center">NitanshuOS⚡</h1>
<h3 align="center">A fully custom Linux distro built from scratch with Buildroot, QEMU and a lot of stubbornness.</h3>

<p align="center">
  <b>Status:</b> Stable locally (QEMU) · AWS import: in-progress / research phase
</p>

---

## ✨ TL;DR – What is NitanshuOS?

**NitanshuOS** is a **custom Linux distribution** that I built using **Buildroot**, targeted at **x86_64** and booted using **QEMU**.  
It’s not an Ubuntu remix or a pre-made ISO tweak – it’s a **from-scratch root filesystem, custom kernel, boot flow, and automation scripts**.

Think of it as:

> “If Arch Linux and embedded DevOps had a tiny, efficient, minimal-but-powerful baby that boots instantly and speaks SSH.”

---

## 🚀 Core Highlights

- ✅ **Fully custom root filesystem** generated via Buildroot
- ✅ **Custom Linux kernel** (configured & compiled by hand)
- ✅ Clean **boot banner & OS branding** – `Welcome to NitanshuOS!!`
- ✅ Proper **`/etc/os-release`** so the OS identifies as:
  ```bash
  NAME="NitanshuOS"
  ID=nitanshuos
  PRETTY_NAME="NitanshuOS (Buildroot-based custom Linux)"
  VERSION="1.0"
  ```
- ✅ **Networking stack working** (eth0, IPv4, IPv6, routing)
- ✅ **BusyBox userland** with standard Unix tooling
- ✅ **Dropbear SSH server** running on boot (remote login ready)
- ✅ **Automated disk image creation** via a custom `post-image.sh` script
- ✅ Reproducible build: **entire OS can be rebuilt from config**

AWS import is currently blocked by **strict kernel version validation** on AMI import (more on that below 👇), but the local OS itself is legit, bootable, and fully functional.

---

## 🧱 Architecture Overview

### 1️⃣ Build System – Buildroot

NitanshuOS is built with **Buildroot 2025.11-rc1**.  
Buildroot is responsible for:

- Fetching and compiling the Linux kernel
- Building the root filesystem (BusyBox + libraries + tools)
- Generating the initial ext2 rootfs image (`rootfs.ext2`)
- Producing the kernel image (`bzImage`)

Key file in this repo:

- `configs/buildroot-config`  
  → exact `.config` used to generate NitanshuOS.  
  Anyone can reproduce my OS by dropping this into a Buildroot tree and running:

  ```bash
  make menuconfig     # (optional – to inspect)
  make                # full system build
  ```

---

### 2️⃣ Kernel – Custom Linux

- Base: **mainline Linux 5.10.220** (LTS line)
- Built as a **custom tarball** from kernel.org
- Configured via **x86_64 defconfig** + custom tweaks
- Built as `bzImage` for x86_64

I experimented with:

- **CIP SLTS kernels** (5.10.162-cip24 & RT variants)
- Newer **6.x kernels**

…but AWS import is extremely picky with kernel versions, so NitanshuOS uses a **clean, self-built LTS kernel** that boots reliably under QEMU.

Kernel is configured to support:

- x86_64 PC platform
- Virtio/standard PC disk + net drivers
- TTY console on `ttyS0`
- Filesystems required for the rootfs

---

### 3️⃣ Root Filesystem & Userspace

The root filesystem is a **minimal BusyBox-based system** with:

- Standard Unix tools (`ls`, `ps`, `ip`, `df`, etc.)
- Basic `/etc` layout
- Networking tools (`ip`, `ping`)
- `dropbear` SSH server
- `crond` for scheduled tasks

On boot, NitanshuOS prints:

```text
Welcome to NitanshuOS!!
```

Then you log in as:

- **user:** `root`
- **password:** (set in Buildroot config)

---

### 4️⃣ Custom Disk Image & Boot Flow

By default Buildroot gives you:

- `bzImage` (kernel)
- `rootfs.ext2` (root filesystem)

NitanshuOS goes further using a custom **post-image automation script**:

> `scripts/post-image.sh`

This script:

1. Creates a raw disk image (`nitanshuos.raw`)
2. Partitions it (MBR, single primary ext4 partition, bootable)
3. Formats the partition with ext4
4. Mounts both:
   - rootfs image (`rootfs.ext2`)
   - new disk partition
5. Copies the root filesystem into the disk
6. Drops `bzImage` into the disk root
7. Installs a minimal **GRUB**-based bootloader:
   - Writes `grub.cfg` pointing to `/bzImage`:
     ```cfg
     menuentry "NitanshuOS" {
         linux /bzImage root=/dev/sda1 rw console=ttyS0
     }
     ```
   - Writes GRUB stage1 + core.img into the MBR and first sectors
8. Cleans up loop devices and mounts

End result: a **fully bootable raw disk** (`nitanshuos.raw`) that can be:

- Booted in QEMU  
- Converted to VMDK (`nitanshuos-aws.vmdk`) for cloud experiments

---

## 🧪 Testing NitanshuOS

All tests done inside **QEMU** on my machine.

### ✅ 1. OS Identity

```bash
cat /etc/os-release
```

Output:

```bash
NAME="NitanshuOS"
ID=nitanshuos
PRETTY_NAME="NitanshuOS (Buildroot-based custom Linux)"
VERSION="1.0"
```

✅ Confirms branding + OS metadata.

---

### ✅ 2. CPU, RAM & Disk Health

```bash
free -h
df -h
```

Example snapshot:

- Memory: ~94 MB total, ~72 MB free (super lightweight)
- Disk root (`/`): ~182 MB size, ~19 MB used

This proves NitanshuOS is **tiny, efficient and fast** – perfect for cloud/embedded style workloads.

---

### ✅ 3. Network Stack

```bash
ip addr
```

Sample output:

```text
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 10.0.2.15/24 brd 10.0.2.255 scope global eth0
```

Then tested connectivity:

```bash
ping -c 4 8.8.8.8
ping -c 4 google.com || echo "DNS might not be set"
```

Even when DNS was misconfigured, interface + routing + stack behaved correctly.  
It’s a **real** networked OS, not just a demo shell.

---

### ✅ 4. DevOps‑style System Snapshot

To show off the system quickly, I used a one-liner:

```bash
echo "[MEMORY]"; free -h; echo; \
echo "[DISK]"; df -h; echo; \
echo "[NETWORK]"; ip addr
```

This prints a **mini health dashboard** in one screenshot – very recruiter‑friendly.

---

## ☁️ AWS AMI Import Journey (aka Boss Fight)

I attempted to turn NitanshuOS into a **custom EC2 AMI** via:

1. Uploading `nitanshuos-aws.vmdk` to S3:
   ```bash
   aws s3 cp nitanshuos-aws.vmdk s3://nitanshuos-import-bucket/
   ```
2. Creating/importing via:
   ```bash
   aws ec2 import-image \
     --region ap-south-1 \
     --description "NitanshuOS Buildroot Distro" \
     --disk-containers file://containers.json
   ```

We hit multiple **real‑world cloud issues**:

- Missing / misconfigured `vmimport` IAM role
- S3 permissions for import
- VMDK format constraints (`streamOptimized` requirement)
- Finally: **strict kernel validation** on AWS side

Example failure message from AWS:

```text
CLIENT_ERROR : ClientError: Unsupported kernel version 5.10.220
```

Instead of hiding this, I’m keeping it **transparent in the project** because:

- It shows actual debugging & research work
- It’s a realistic production-style problem
- It opens room for a v2: building an **AWS-approved kernel** or basing NitanshuOS on top of an existing cloud image

Right now NitanshuOS is **fully functional in QEMU**, and AWS support is an **active research track**, not a blocker to calling this a serious OS project.

---

## 📁 Repo Layout

```text
NitanshuOS/
├── NitanshuOS.PNG          # Project logo (used in README & branding)
├── README.md               # You’re reading the styled version of this
├── NitanshuOS.zip          # Exported configs & scripts bundle
├── configs/
│   └── buildroot-config    # Full Buildroot .config for reproducible builds
├── scripts/
│   └── post-image.sh       # Disk image + GRUB automation script
└── docs/
    └── architecture.md     # High-level architecture notes
```

---

## 🧠 What I Learned Building NitanshuOS

### Systems & OS Concepts

- How a **Linux system actually boots** (firmware → bootloader → kernel → init → userland)
- Difference between:
  - Kernel image (`bzImage`)
  - Root filesystem (`rootfs.ext2`)
  - Disk image (`.raw`, `.vmdk`)
- Manual GRUB install vs pre-packaged distro images

### Buildroot & Tooling

- Configuring Buildroot for a **custom distro**
- Tweaking kernels, BusyBox, packages
- Rebuilding from `.config` for reproducible output

### Networking

- Bringing up interfaces in a minimal system
- Understanding QEMU’s `10.0.2.x` NAT network
- Debugging DNS vs connectivity

### Cloud / DevOps

- Working with S3, IAM roles, and `vmimport`
- Understanding EC2’s expectations from guest kernels
- Converting & validating disk formats (RAW → VMDK)

### Git & Project Hygiene

- Structuring a repo like a **real open-source project**
- Writing architecture docs instead of just “it works on my laptop”
- Using branches + PR flow on GitHub

---

## 🧭 How to Rebuild NitanshuOS Yourself

> You need a Linux environment (WSL2 works), Git, and Buildroot.

```bash
# 1. Clone my repo
git clone https://github.com/Nitanshu715/NitanshuOS.git
cd NitanshuOS

# 2. Clone Buildroot (if you don’t already have it)
git clone https://git.buildroot.net/buildroot
cd buildroot

# 3. Drop my config in and build
cp ../configs/buildroot-config .config
make oldconfig      # optional, to review
make                # full system build (this takes time)

# 4. Run post-image script (adapt paths if needed)
cp ../scripts/post-image.sh board/qemu/post-image.sh
chmod +x board/qemu/post-image.sh
# Re-run 'make' so Buildroot calls the post-image hook
make

# 5. Boot with QEMU (example)
qemu-system-x86_64 -m 256M -hda output/images/nitanshuos.raw -serial mon:stdio
```

From here, you can SSH into it (if you expose ports) or continue experimenting with cloud import, different kernels, or extra packages.

---

## 🔮 Future Ideas

- ✅ Finish AWS‑compatible AMI version (pass kernel validation)
- ⬜ Add a small **web server** or demo app inside the OS
- ⬜ Ship **pre-made QEMU run script**
- ⬜ Add a **custom shell MOTD + color theme**
- ⬜ Explore **container runtime** support on top of NitanshuOS

---

## 👤 Author

**Nitanshu Tak**  
B.Tech CSE (Cloud Computing & Virtualization)  
Cloud | DevOps | Linux | OS Internals | Machine Learning | Music on the side | Coffee in my blood streams |

- LinkedIn: [Nitanshu Tak](https://www.linkedin.com/in/nitanshu-tak-89a1ba289/)
- Project: [NitanshuOS](https://github.com/Nitanshu715/NitanshuOS)


---

🔥 This is the root cause of my sleepless nights. Finally, my laptop's jet engines can rest better than I can. 
