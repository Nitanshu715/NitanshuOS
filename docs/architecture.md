# NitanshuOS – System Architecture

NitanshuOS is a lightweight custom Linux operating system built using Buildroot and designed for cloud, virtualization, and low-resource environments.

---

## 1. Core Base
- Build System: Buildroot
- Kernel Version: Linux 5.10.x / 6.x (Custom selectable)
- Architecture: x86_64
- Init System: BusyBox init
- C Library: musl / glibc (Buildroot managed)

---

## 2. Boot Flow
1. Bootloader (QEMU / Virtual machine boot)
2. Linux Kernel loads
3. Root filesystem mounted (ext2)
4. Init process starts
5. Network + SSH services start
6. User login prompt appears

---

## 3. Filesystem Layout
- Root FS: ext2
- /bin → BusyBox utilities
- /etc → System configs
- /proc, /sys → Kernel interfaces
- /dev → Dynamic devices
- /tmp, /run → Temporary runtime data

---

## 4. Networking Stack
- Interface: eth0 (QEMU virtual NIC)
- DHCP-based IP assignment
- DNS via virtual gateway
- ping, ip, route utilities supported

---

## 5. Services Enabled
- dropbear (SSH)
- cron
- init
- syslog (optional)
- networking auto-start

---

## 6. Image Automation
Post-image automation is handled using:
- post-image.sh
- Custom raw → ext2 → vmdk conversion supported

---

## 7. Purpose of NitanshuOS
- Cloud OS experimentation
- DevOps OS testing
- Embedded Linux learning
- Kernel & OS customization
- Virtual machine optimization research

---

## 8. Project Author
Built & maintained by: Nitanshu Tak  
Project Name: NitanshuOS
