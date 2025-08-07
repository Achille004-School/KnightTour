# Running RISC-V Assembly Code on Debian

This guide walks you through setting up a RISC-V development environment on Debian and running assembly code using cross-compilation tools and QEMU emulation.

## Prerequisites

- Debian-based system (Debian, Ubuntu, etc.)
- Terminal access with sudo privileges

### Step 1: Update System Packages

First, update your package list and upgrade existing packages:

```bash
sudo apt update && sudo apt upgrade -y
```

This ensures you have the latest package information and system updates.

### Step 2: Install RISC-V Development Tools

Install the necessary tools for RISC-V cross-compilation and emulation:

```bash
sudo apt install binutils-riscv64-linux-gnu gcc-riscv64-linux-gnu qemu-user -y
```

This installs:
- `binutils-riscv64-linux-gnu`: Cross-compilation tools (assembler, linker, etc.) for RISC-V 64-bit
- `gcc-riscv64-linux-gnu`: RISC-V 64-bit cross-compiler and linker for Linux user-space programs
- `qemu-user`: QEMU user-mode emulation for running RISC-V binaries

### Step 3: Get Your Assembly Code

Clone your repository containing the RISC-V assembly code:

```bash
# Replace with your actual repository URL
git clone https://github.com/Achille004-School/KnightTour.git
cd your-riscv-project
```

Make sure your project contains a `main.s` file with your RISC-V assembly code.

### Step 4: Assemble the Code

Convert your assembly source code into an object file:

```bash
riscv64-linux-gnu-as main.s -o main.o
```

This command:
- `riscv64-linux-gnu-as`: The RISC-V 64-bit assembler
- `main.s`: Your assembly source file
- `-o main.o`: Output object file name

### Step 5: Link the Object File

Create an executable from the object file:

```bash
riscv64-linux-gnu-gcc -static main.o -o main 
```

This command:
- `riscv64-linux-gnu-gcc`: The RISC-V 64-bit cross-compiler and linker for Linux user-space programs
- `main.o`: Input object file
- `-o main`: Output executable name

### Step 6: Run and Check Exit Code

Execute the RISC-V binary using QEMU:

```bash
qemu-riscv64 ./main
```

This command:
- `qemu-riscv64`: QEMU emulator for RISC-V 64-bit binaries
- `./main`: Your compiled executable

## Complete Workflow Script

Here's a complete script that automates the entire process:

```bash
#!/bin/bash

# Update system and install tools
sudo apt update && sudo apt upgrade -y
sudo apt install binutils-riscv64-linux-gnu gcc-riscv64-linux-gnu qemu-user -y

# Clone repository (replace with your actual repo)
git clone https://github.com/Achille004-School/KnightTour.git
cd your-riscv-project

# Assemble, link, and run
riscv64-linux-gnu-as main.s -o main.o
riscv64-linux-gnu-gcc -static main.o -o main
qemu-riscv64 ./main
```

Save this as `setup_and_run.sh`, make it executable with `chmod +x setup_and_run.sh`, and run it with `./setup_and_run.sh`.

---

## Running on Windows: Use WSL (Windows Subsystem for Linux)

If you are using Windows, it is highly recommended to use WSL (Windows Subsystem for Linux) to follow this guide. WSL allows you to run a full Linux environment directly on Windows, making it easy to use Debian-based tools and commands.

### How to Set Up WSL

1. **Enable WSL**
   - Open PowerShell as Administrator and run:
     ```powershell
     wsl --install
     ```
   - This installs WSL and sets up Ubuntu by default. You can choose Debian from the Microsoft Store if preferred.

2. **Install Debian (optional)**
   - Open the Microsoft Store, search for "Debian", and install it.
   - Launch Debian from your Start menu.

3. **Update and Follow the Guide**
   - Once inside your WSL terminal (Debian or Ubuntu), you can follow all the steps in this guide exactly as written for Debian.

### Why Use WSL?
- Seamless integration with Windows
- Access to Linux tools and package management
- No need for a separate virtual machine

For more details, see the official documentation: [WSL Installation Guide](https://learn.microsoft.com/en-us/windows/wsl/install)