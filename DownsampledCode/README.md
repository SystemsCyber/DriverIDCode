# DownsampledCode Data Processing

## Overview
The **DownsampledCode** folder contains R scripts designed to process high-resolution driving data from various sources (VBOX, CANbus, and heart rate) into a single downsampled CSV. The scripts align and synchronize the data, calculating the mean for each 1-second interval. Additional derived metrics, such as **cumulative_distance_meters** and **cyberattack_active**, are also generated. Survey answers from each participant are included. The survey questions are from the MMDBQ (Modified Manchester Driver Behavior Questionnaire) and are used to generate GRiPS (General Risk Propensity Scale). 

### Key Features:
- Downsamples high-resolution data to 1-second intervals.
- Synchronizes timestamps across multiple sources.
- Calculates distance traveled using the Haversine formula.
- Identifies periods of active cyberattacks.
- Integrates survey data to score participants' driving risk.

## Data Sources and Processing
- **VBOX:** GPS and inertial data.
- **CANbus:** Vehicle telemetry.
- **Heart Rate:** Collected from the Empatica E4 wristband.
- **Survey Data:** Self-reported driver behavior.

## Key Variables:
- `cumulative_distance_meters`: Distance calculated using lat/long.
- `cyberattack_active`: Binary indicator of a cyberattack (1 = active, 0 = inactive).

## Scripts Overview

### 1. GenerateCSVsPart1.R
- Processes data for files without CAN0 engine speed data (G1_Subject1, G1_Subject2, G1_Subject4, G1_Subject5, G1_Subject6, G1_Subject7, G1_Subject8, G1_Subject9, G2_Subject1).
- Cyberattack detection based on location.

### 2. GenerateCSVsPart2.R
- Processes files with CAN0 engine speed data.
- Subjects include G1_Subject13, G1_Subject14, G1_Subject17, G2_Subject2, G2_Subject3, G2_Subject5, G2_Subject6, G2_Subject7, G2_Subject8, G2_Subject9, G2_Subject10, G2_Subject11, G2_Subject12, G2_Subject14, G2_Subject15, G2_Subject16, G3_Subject1, G3_Subject2, G3_Subject3, G3_Subject4, G3_Subject5, G3_Subject6, G3_Subject7, G3_Subject8, G3_Subject9, G3_Subject10, G3_Subject11, G3_Subject12, G3_Subject14, G3_Subject15, G3_Subject16, and G3_Subject17.

### 3. GenerateCSVsPart3.R
- Adjusts timestamps for subjects using CANLogger3.
- Subjects: G1_Subject10, G1_Subject11, G1_Subject12.

### 4. GenerateCSVsPart4.R
- Handles files with missing or faulty VBOX data.
- Subjects: G1_Subject15, G1_Subject16, G2_Subject13, G3_Subject13.

### 5. GenerateCSVsPart5.R
- Adjusts timestamps for G1_Subject3 with unusual VBOX timing.

### 6. GenerateCSVsPart6.R
- Corrects timestamps for G2_Subject4 with a midnight-starting VBOX time.

## Supporting Scripts

### DriverID Cyberattack Wrangling.R
- Generates the `cyberattack_active` variable based on CAN0 engine speed loss or GPS location.

### Qualtrics Survey Data Wrangling.R
- Processes survey responses to derive a driver risk score.

### Save DriverID_data_wrangled.R
- Combines downsampled data from all participants into a single CSV.
- Adds the `cumulative_distance_meters` variable.

## Usage Instructions

1. Ensure all necessary high-resolution CSV and SQLite files are present.
2. Run the scripts in the order specified.
3. The final output will be a single CSV with synchronized, downsampled data for all participants.

## Notes
- Data alignment is achieved by maximizing correlation between VBOX and CANbus speed data.
- Timestamp adjustments are necessary for files recorded with different logging devices.
- Survey data enhances the dataset with behavioral insights.

**End of Documentation**


