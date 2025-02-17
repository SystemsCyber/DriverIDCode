# ORNL Driver Identification Data Processing Repository

## Overview
This repository contains the code used to generate the ORNL Driver Identification Dataset. The dataset is created by processing **raw data files** collected from **50 participants** driving a **2014 Kenworth T270 Class 6** truck. The code processes the data into three different formats:
1. **High-resolution SQLite database**
2. **High-resolution CSV files**
3. **Downsampled CSV files** (includes additional variables and survey answers)
4. **KML file generation** (for GPS visualization in Google Earth)

## Repository Structure
The repository is organized into four main folders, each containing the necessary scripts to generate the corresponding data files:

### 1. **CSVHighResolutionCode/**
- Contains scripts to generate **high-resolution CSV files** from raw data.
- Requires all raw data files for processing.
- Contains README with more info

### 2. **SQLiteHighResolutionCode/**
- Contains scripts to generate a **high-resolution SQLite database**.
- Requires all raw data files for processing.
- Contains README with more info

### 3. **DownsampledCode/**
- Contains scripts to generate **downsampled CSV files**.
- The downsampled data includes additional computed variables (e.g., **distance traveled**, **cyberattack active**) and **survey responses**.
- Contains README with more info

### 4. **KMLGeneratorCode/**
- Contains the Python script to generate a **KML file** for GPS visualization.
- The script reads longitude and latitude from the **sqlite** database.
- Outputs a **KML file** that can be opened with **Google Maps, Earth, etc**.
- Script file: `GenerateKLMFile.py`

## KML File Generation
To generate a KML file from the SQLite database, use the script `GenerateKLMFile.py`. This script reads the `SparkfunGPSData` table and extracts the `longitude` and `latitude` values.

### **Usage**
```bash
python3 GenerateKLMFile.py
```

The script will create a file named `DriverID#G#TruckCape.kml` in the same directory. Open this file with **Google Maps, Earth, etc** to visualize the GPS data and route of the drives.

Ex Image from DriverIDG1S01:



## Required Raw Data Files
To generate the processed datasets, the following raw data files are required for each participant:
- **DriverIDSXGYCANLogger3.bin** (CAN data from CANLogger3 (https://github.com/SystemsCyber/CAN-Logger-3))
- **DriverIDSXGYEDA.csv** (Electrodermal activity data from Empatica E4 wristband)
- **DriverIDSXGYHR.csv** (Heart rate data from Empatica E4 wristband)
- **DriverIDSXGYIBI.csv** (Interbeat interval data from Empatica E4 wristband)
- **DriverIDSXGYTruckCape.log** (CAN data from TruckCape Beaglebone (https://github.com/SystemsCyber/TruckCapeProjects))
- **DriverIDSXGYVBOX.vbo** (GPS and inertia data from VBOX 3i)

where:
- **X = Subject Number (1-50)**
- **Y = Group Number (G1, G2, G3)**

### **Participant Groups**
- **Group 1 (G1)**: 17 subjects
- **Group 2 (G2)**: 16 subjects
- **Group 3 (G3)**: 17 subjects

## CAN Data Decoding Requirement
The **J1939 digital annex** is required to decode the CAN data. It must be converted into a **JSON format** following the instructions in this repository:
- [pretty_j1939 Repository](https://github.com/SystemsCyber/pretty_j1939)




