![NitanshuOS Logo](https://github.com/Nitanshu715/NitanshuOS/blob/main/NitanshuOS.PNG)

# 🚀 NitanshuOS – A Custom Linux Operating System Built from Scratch Using Buildroot

NitanshuOS is a fully custom-built Linux operating system created from the ground up using **Buildroot**. This project demonstrates deep expertise in **Linux kernel configuration, embedded Linux, system automation, virtualization, and DevOps-style image pipelines**.

This is not a prebuilt distro. Every component — from the kernel to the root filesystem — has been selected, configured, built, tested, debugged, and documented manually.

---

## 📌 Project Highlights

- ✅ Custom Linux OS built using **Buildroot**
- ✅ Fully automated post-build disk image pipeline
- ✅ Custom OS branding with `/etc/os-release`
- ✅ Boot-tested on **QEMU**
- ✅ Root filesystem generated and verified
- ✅ Networking stack enabled and validated
- ✅ Reproducible build system published on GitHub
- ✅ Professional Git workflow with feature branch + PR + merge

---

## 🧠 What This Project Proves

This project demonstrates:

- Embedded Linux Engineering
- Kernel Integration
- Filesystem Construction
- Build Automation
- Virtualization & Emulation
- Git & DevOps Practices
- Low-level System Debugging

---

## 🏗️ System Architecture

User Space → BusyBox  
Init System → Buildroot Init  
Kernel → Custom Linux Kernel  
Bootloader → QEMU Direct Boot  
Filesystem → EXT RootFS  

The system is built in a fully automated pipeline using Buildroot as the primary framework.

---

## 🛠️ Technologies Used

- Linux Kernel
- Buildroot
- BusyBox
- QEMU
- Bash Scripting
- Git & GitHub
- WSL (for Linux build environment)
- EXT Filesystems

---

## 🧪 Testing Performed

- ✅ Boot Test on QEMU
- ✅ Root Filesystem Verification
- ✅ Memory & Disk Usage Checks
- ✅ Network Interface Validation
- ✅ DNS Resolution Tests
- ✅ Custom OS Branding Validation

---

## ⚠️ Major Challenges Solved

### 1️⃣ Kernel Version Conflicts
Multiple kernel versions failed due to unsupported AWS formats and missing hypervisor drivers. Eventually, a stable Buildroot-compatible kernel was used.

### 2️⃣ Filesystem Mount Failures
Block device mapping errors during EXT image mounting were debugged and corrected using proper loopback devices.

### 3️⃣ AWS AMI Import Errors
VMDK format compatibility errors were encountered and resolved via proper raw-to-vmdk conversion using `qemu-img`.

### 4️⃣ JSON Validation Issues
Malformed AWS import JSON caused task failures which were corrected via strict JSON formatting.

### 5️⃣ Git Authentication Failures
GitHub authentication via HTTPS failed multiple times and was fixed using proper token authentication and Git configuration.

---

## 📁 Repository Structure

configs/ → Buildroot Configuration  
scripts/ → Post-build automation scripts  
docs/ → Architecture & system documentation  
NitanshuOS.zip → Packaged project artifact  

---

## 🧾 Reproducible Build Steps

1. Setup Linux environment
2. Install Buildroot dependencies
3. Load configuration from `configs/buildroot-config`
4. Build kernel and root filesystem
5. Run post-image automation script
6. Boot using QEMU

---

## 🧑‍💻 Author

**Nitanshu Tak**  
B.Tech CSE (Cloud & Virtualization)  
Linux Systems Engineer | DevOps Enthusiast | OS Builder  

GitHub: https://github.com/Nitanshu715  

---

## 🏆 Final Statement

NitanshuOS is not a tutorial copy-paste project. It is a **fully engineered Linux operating system**, built through real debugging, kernel issues, cloud import failures, and professional DevOps workflows.

This project reflects my ability to work at:
- Operating System Layer
- Embedded Linux Layer
- Virtualization Layer
- DevOps Automation Layer

---

🔥 This is the root cause of my sleepless nights. Finally, my laptop's jet engines can rest better than I can. 
