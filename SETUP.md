# SETUP.md  
Project Shadow Development Environment Guide

---

## Overview

This project uses a fully containerised workflow to ensure that everyone develops in the exact same environment.

We do not install ROS or dependencies directly on Windows or macOS.  
Instead, all development happens inside a shared Docker container.

### The container includes:

- Ubuntu 24.04 Noble  
- ROS 2 Jazzy Jalisco  
- Python 3.12  
- Ultralytics YOLO  
- OpenCV  
- Serial communication libraries  
- Gazebo Harmonic  

This approach removes version conflicts and prevents machine-specific issues.

---

# Part 1 – One Time Setup

These steps only need to be completed once per computer.

---

## Step 1 – Install Docker Desktop

Download Docker Desktop from:

https://www.docker.com/products/docker-desktop/

After installation:

1. Open Docker Desktop  
2. Go to Settings  
3. Open Resources → WSL Integration  
4. Enable integration with your default WSL distribution  

Without this step, the container will not function correctly.

---

## Step 2 – Install VS Code Extension

Open Visual Studio Code and install the Dev Containers extension.

- Open Extensions panel  
- Search for: Dev Containers  
- Install extension ID:  
  ms-vscode-remote.remote-containers  

This extension allows VS Code to connect directly into the Docker environment.

---

# Part 2 – Daily Workflow

These steps describe how to start working each day.

---

## Step A – Clone the Repository

Open a terminal and run:

git clone https://github.com/your-org/project-shadow.git
cd project-shadow
code .


You may clone the repository anywhere:

- Windows filesystem (Note: GUI apps like Turtlesim may not work easily here)
- WSL filesystem (**Recommended** for full GUI support and speed)

Using the WSL filesystem is strongly preferred to enable graphical tools out-of-the-box.

---

## Step B – Open the Project in the Container

When VS Code opens the folder, one of two things will happen.

### Option 1 – Automatic Prompt

A popup appears:

"Folder contains a Dev Container configuration file. Reopen to develop in a container?"

Select:

Reopen in Container

---

### Option 2 – Manual Launch

If no popup appears:

1. Press F1 or Ctrl + Shift + P  
2. Search for:  
   Dev Containers: Reopen in Container  
3. Press Enter  

---

### First Launch Note

The first time the container launches it may take between 5 and 10 minutes.

This is normal because the image must be built.

After the first build, future launches are very fast.

---

## Step C – Confirm You Are Inside

Open a terminal in VS Code using:

Ctrl + `

Check the command prompt.

If you see something like this:

C:\Users\YourName\project-shadow>

You are NOT inside the container.

If you see something like:

root@abcd1234:/workspaces/project-shadow#

Then you are correctly inside the environment.

---

### Test ROS Installation
Run this command:

```bash
ros2 --help
```

If the help menu appears, your setup is fully working.

---

### Verify GUI (Turtlesim)
To confirm that graphical applications (WSLg) are working, run the classic ROS turtle simulation.

1.  **Start the Simulation**:
    ```bash
    ros2 run turtlesim turtlesim_node
    ```
    A blue window with a turtle should appear.

2.  **Control the Turtle** (Optional):
    Open a **second terminal** (split verification) and run:
    ```bash
    ros2 run turtlesim turtle_teleop_key
    ```
    Use the arrow keys to move the turtle.

If you see the turtle, your graphical environment is perfect.

---

# Part 3 – Working with Code

---

## File System Behaviour

The container mounts your project folder directly.

This means:

- Files created inside the container appear on your computer  
- Files edited on your computer appear in the container  
- There are not two separate copies  

You always work on the same files.

---

## Git Usage

Git works exactly the same as normal.

VS Code automatically forwards your Windows Git credentials into the container.

Typical workflow:

git pull origin main
git checkout -b feature/new-feature

Make changes
git add .
git commit -m "Description of changes"
git push origin feature/new-feature


No special Git configuration is required.

---

# Part 4 – Tasks and Where They Run

Most development happens inside the container, but some tasks must run directly on Windows.

| Task | Location | Tool |
|-----|---------|------|
| Writing ROS code | Inside container | VS Code |
| Running simulations | Inside container | VS Code Terminal |
| Building ROS packages | Inside container | Colcon |
| Flashing STM32 boards | Windows host | STM32CubeIDE |
| Flashing SD cards | Windows host | Raspberry Pi Imager |

Only hardware flashing must be done outside Docker.

Everything else belongs inside the container.

---

# Part 5 – Common Problems

---

## Problem: Cannot Push to Git

If Git push fails from inside the container:

- Make sure you are logged into GitHub in VS Code on Windows  
- Check the Accounts icon in the bottom left of VS Code  
- Sign in again if necessary  

Authentication is passed automatically to the container.

---

## Problem: Docker Virtualization Error

If Docker reports that virtualization is disabled:

1. Restart your computer  
2. Enter BIOS settings  
3. Enable one of the following:

- Intel VT-x  
- Intel Virtualization Technology  
- AMD SVM Mode  

Save changes and reboot.

---

## Problem: Container Performance Is Slow

Performance may be poor if the project is stored on the Windows filesystem.

For best speed:

Move the repository into your WSL filesystem, for example:

\\wsl$\Ubuntu\home\username\project-shadow

Docker performs much faster with files stored inside WSL.

---

# Final Notes

Once these steps are complete, you are fully ready to develop.

All team members should follow this guide to ensure a consistent environment.

If you encounter issues not covered here, contact the project maintainer.

Happy coding.