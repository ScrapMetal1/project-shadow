# Base Image: Ubuntu 24.04 with ROS 2 Jazzy installed
FROM osrf/ros:jazzy-desktop

# Set environment to non-interactive to avoid "Enter your region" prompts
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install System Tools
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    git \
    nano \
    udev \
    usbutils \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Python Dependencies (AI & Hardware)
# We use a virtual environment with --system-site-packages to allow access to ROS libraries
# while avoiding conflicts with system packages (fixing the PEP 668 / uninstall error).
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv --system-site-packages $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies into the venv. 
# We explicitly pin numpy<2 because ROS 2 Jazzy (on Ubuntu 24.04) is built against numpy 1.x.
# Ultralytics might pull in numpy 2.x otherwise, causing ABI incompatibilities.
RUN pip3 install --no-cache-dir \
    "numpy<2" \
    ultralytics \
    opencv-python \
    pyserial \
    setuptools==58.2.0

# 3. Setup ROS Environment
# This ensures "ros2 run" works immediately when you open a terminal
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# 4. Install Verification Tools (Turtlesim)
# We do this last to avoid rebuilding the heavy Python layers if we just want to add a tool.
RUN apt-get update && apt-get install -y \
    ros-jazzy-turtlesim \
    && rm -rf /var/lib/apt/lists/*
