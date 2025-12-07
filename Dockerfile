# ===== NitanshuOS Dev Container =====
FROM ubuntu:22.04

LABEL maintainer="Nitanshu <nitanshutak07105@gmail.com>"
LABEL project="NitanshuOS"
LABEL purpose="Kernel-building, OS-toolchain, and automated build environment"

RUN apt update && apt install -y \
    build-essential \
    bison \
    flex \
    bc \
    git \
    wget \
    libncurses-dev \
    qemu-system-x86 \
    python3 \
    python3-pip \
    cpio \
    file \
    sudo \
    vim \
    tree

WORKDIR /workspace

CMD ["/bin/bash"]
