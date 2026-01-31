# 🤖 Project Shadow: Autonomous "Follow-Me" Robot
### Year 3 Mechatronics Capstone | Hybrid Architecture (RPi 5 + STM32)

**Status:** `Development Phase`
**Middleware:** ROS 2 Jazzy Jalisco (Ubuntu 24.04 LTS)
**Low-Level:** STM32 HAL (C/C++)

---

## 🧠 System Architecture: "The Split Brain"

This project uses a hierarchical control strategy to ensure real-time performance and safety, optimizing the new hardware capabilities of the RPi 5.

1.  **High-Level Brain (Raspberry Pi 5):** Handles Perception (YOLOv8), Decision Making, and ROS 2 Networking. Runs on Ubuntu 24.04.
2.  **Low-Level Brain (STM32):** Handles Hard Real-Time Motor Control (PID), Encoder Reading, and Odometry calculation.
3.  **The Bridge:** A custom ROS 2 Serial Node communicates between the two via USB/UART.

---

## 👥 The Team & Roles

| Member | Role | Responsibility | Tech Stack |
| :--- | :--- | :--- | :--- |
| **Aaron** | **Perception Engineer** | Computer Vision & Target Acquisition | Python, YOLOv8 (ONNX/CPU), ROS 2 Jazzy |
| **Arjun** | **Control Engineer** | Motion Logic & Embedded Firmware | C++ (STM32), Python (ROS Serial), PID |
| **Dhruv** | **Sim & Hardware Lead** | Simulation & Physical Integration | Gazebo Harmonic, URDF, SolidWorks |

---

## 🔌 The "Contract" (Interfaces)

**CRITICAL:** Do not change topic names or message types without team consensus.

### 1. Vision Interface (Aaron → Arjun)
* **Topic Name:** `/vision/target_offset`
* **Message Type:** `geometry_msgs/Point`
* **Data:**
    * `x`: Horizontal Error. Range: `[-1.0, 1.0]` (0.0 is center).
    * `z`: Estimated Distance (meters).

### 2. High-Level Control Interface (Arjun → System)
* **Topic Name:** `/cmd_vel`
* **Message Type:** `geometry_msgs/Twist`
* **Source:** Logic Node (Arjun) or Teleop.

### 3. The Hardware Bridge (Arjun Internal)
* **Protocol:** Serial (USB-TTL or USB-CDC) @ 115200 Baud.
* **Format (Pi → STM32):** `<LINEAR_X, ANGULAR_Z>`
    * Example: `<0.5, 0.1>` (Drive 0.5m/s, Turn 0.1rad/s)
* **Format (STM32 → Pi):** `<ENCODER_L, ENCODER_R>` or `<ODOM_X, ODOM_Y>`

---

## 📅 Execution Master Plan

### Phase 1: Distributed Development (Weeks 1-3)
*Goal: Prove individual subsystems work in isolation.*

* **Aaron (Perception):**
    * Export `yolov8n` to **ONNX** format for CPU inference.
    * Write a Python script to run inference on a standard Webcam.
    * Benchmark FPS on laptop (Target: >15 FPS).
* **Arjun (Control):**
    * **Task A (Firmware):** Flash STM32 to read 2x Encoders and output count to Serial Monitor.
    * **Task B (ROS):** Write a `serial_bridge` Python node that reads `/cmd_vel` and `print()`s the string it *would* send to the STM32.
* **Dhruv (Sim):**
    * Setup **Gazebo Harmonic** (The default for Jazzy).
    * Create a world with a "Walking Human" actor so Aaron has a target to detect.

### Phase 2: The "Software" Integration (Weeks 4-6)
*Goal: Verify logic in Simulation.*

* **Aaron:** Wrap the ONNX script in a ROS 2 Node (`shadow_vision`).
* **Arjun:** Implement the PID logic in the STM32 firmware. Tune `Kp, Ki, Kd` on a bench test (motor spinning in air).
* **Dhruv:** Integrate Aaron's node into the Launch file. Verify the virtual robot follows the virtual person.

### Phase 3: Hardware Integration (Weeks 7-9)
*Goal: Wire it up and don't let the magic smoke out.*

* **Dhruv:** Assemble Chassis. Wire: `Battery -> UBEC -> Pi 5` and `Battery -> Motor Driver -> Motors`.
* **Arjun:** Connect STM32 to Pi 5 via USB.
* **Team:** Run the **"Hello World" of Robotics**:
    1.  Send `/cmd_vel` of `0.1 m/s`.
    2.  Pi sends `<0.1, 0.0>` to STM32.
    3.  STM32 PID spins wheels at exactly 0.1 m/s.
    4.  Robot moves forward.

### Phase 4: Field Testing (Weeks 10-12)
* Deploy to a corridor.
* Tune PID gains for the added weight of the chassis.
* **Latency Check:** Measure time from "Person Moves" to "Wheels Turn".

---

## 📦 Bill of Materials (Procurement Lead: Dhruv)

| Component | Specification | Notes |
| :--- | :--- | :--- |
| **Compute** | **Raspberry Pi 5 (4GB/8GB)** | The Master. Ubuntu 24.04. |
| **Cooling** | **Active Cooler for Pi 5** | **MANDATORY** for AI workloads. |
| **Microcontroller** | **STM32 Nucleo-64 / Blue Pill** | The Slave (Motor Controller). |
| **Connection** | Micro-USB Data Cable | Connects STM32 to Pi 5. |
| **Camera** | Raspberry Pi Camera Module 3 | Connects to Pi CSI port. |
| **Motors** | 12V DC Motors w/ Encoders | High torque preferred (~200 RPM). |
| **Driver** | L298N or TB6612FNG | Interfaces STM32 to Motors. |
| **Power** | 3S LiPo + **5V 5A UBEC** | UBEC required for Pi 5 stability. |

---

## 🛠️ Docker Setup

To ensure the Pi 5 and our Laptops run the same code, we use a Dev Container.

**Dockerfile Base:**
```dockerfile
FROM osrf/ros:jazzy-desktop
# Installs ROS 2 Jazzy (Ubuntu 24.04)
