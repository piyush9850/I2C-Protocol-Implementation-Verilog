# I2C Protocol Implementation in Verilog

> A learning-oriented implementation of the I²C (Inter-Integrated Circuit) protocol in **Verilog HDL**, featuring custom **Master** and **Slave** controllers, a **baud generator**, and a **loopback testbench** for functional verification.

---

## Overview

This project was developed to strengthen RTL design concepts by implementing the I²C communication protocol from scratch using Verilog.

The design focuses on understanding how serial communication protocols are implemented at the hardware level using **Finite State Machines (FSMs)**, **tri-state buses**, **address matching**, **ACK/NACK handling**, and **bidirectional data transfer**.

The project was simulated using **Icarus Verilog**, visualized with **GTKWave**, and synthesized using **Xilinx Vivado**.

---

## Project Architecture

<img width="1498" height="1010" alt="I2C_block__dig" src="https://github.com/user-attachments/assets/3952e93b-4a7f-438c-a8ba-9ee59e3cd3f7" />


---

## RTL Schematic

RTL generated using **Xilinx Vivado**.

<img width="1582" height="815" alt="Screenshot 2026-06-26 173433" src="https://github.com/user-attachments/assets/1fb3be88-3614-4756-b91b-f1dc55f04294" />


---

## Simulation Waveform

Loopback simulation showing START generation, address transmission, clock generation, and protocol timing.

<img width="1580" height="803" alt="Screenshot 2026-06-26 173200" src="https://github.com/user-attachments/assets/efaee98d-86da-4686-97f5-90d4de06fd57" />


---

# Features

* Custom I²C Master implementation
* Custom I²C Slave implementation
* FSM-based protocol control
* 7-bit Slave Address Matching
* Read and Write transaction support
* START condition generation
* STOP condition detection
* ACK/NACK handling
* Tri-state SDA bus implementation
* Programmable Baud Generator
* Loopback Testbench
* Vivado RTL Synthesis
* GTKWave Simulation

---

# Project Structure

```text
I2C-Protocol-Implementation-Verilog
│
├── rtl
│   ├── I2C_master.v
│   ├── I2C_slave.v
│   └── baud.v
│
├── testbench
│   └── I2C_LOOPBACK_TB.v
│
├── images
│   ├── architecture.png
│   ├── rtl_schematic.png
│   └── waveform.png
│
├── README.md
├── LICENSE
└── .gitignore
```

---

# Module Description

## I2C Master

Responsible for initiating all bus transactions.

Implements:

* START generation
* Address transmission
* Read/Write control
* ACK/NACK checking
* Data transmission
* STOP generation

---

## I2C Slave

Continuously monitors the bus and responds whenever its configured address is detected.

Implements:

* START detection
* Address matching
* ACK generation
* Data reception
* Data transmission
* STOP detection

---

## Baud Generator

Generates the serial clock (**SCL**) from the system clock.

---

# Master FSM

```text
IDLE
   │
   ▼
START
   │
   ▼
ADDRESS
   │
   ▼
ACK_WAIT
   │
   ▼
ACK1
   │
   ▼
DATA
   │
   ▼
ACK2
   │
   ▼
STOP
   │
   ▼
IDLE
```

---

# Slave FSM

```text
IDLE
   │
   ▼
START_DETECT
   │
   ▼
ADDRESS
   │
   ▼
ACK_WAIT
   │
   ▼
ACK1
   │
   ▼
DATA
   │
   ▼
ACK2
   │
   ▼
STOP
   │
   ▼
IDLE
```

---

# Tools Used

* Verilog HDL
* Xilinx Vivado 2025.2
* Icarus Verilog
* GTKWave
* Git
* GitHub

---

# Current Status

This repository represents a learning implementation of the I²C protocol.

The project successfully demonstrates:

* RTL architecture design
* FSM implementation
* Bidirectional SDA bus
* START/STOP handling
* Address matching
* ACK/NACK logic
* Loopback verification environment

Protocol timing and synchronization are still being refined, and additional protocol features will be incorporated in future updates.

---

# Future Improvements

* Repeated START support
* Multi-byte transactions
* Clock Stretching
* Arbitration
* Protocol timing refinement
* SystemVerilog Testbench
* Assertions (SVA)
* Functional Coverage
* Constrained Random Verification
* UVM-based Verification Environment

---

# Learning Outcomes

Through this project, I gained hands-on experience with:

* RTL Design
* Finite State Machines (FSM)
* Verilog HDL
* Serial Communication Protocols
* Tri-state Bus Design
* Clock Domain Timing
* Vivado RTL Synthesis
* Functional Simulation
* Digital System Design

---

## Author

**Piyush Choudhary**

Electronics and Communication Engineering (ECE)
IIIT Nagpur

---

⭐ If you found this project useful or interesting, consider giving it a star!
