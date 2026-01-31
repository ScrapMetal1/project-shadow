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
    && rm -rf /var/lib/apt/lists/*

# 2. Install Python Dependencies (AI & Hardware)
# We use --break-system-packages because Ubuntu 24.04 forces PEP 668. 
# Inside a container, this is safe.
RUN pip3 install --break-system-packages \
    ultralytics \
    opencv-python \
    pyserial \
    setuptools==58.2.0

# 3. Setup ROS Environment
# This ensures "ros2 run" works immediately when you open a terminal
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
