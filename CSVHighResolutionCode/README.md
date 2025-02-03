# CSV High-Resolution Data Processing

## Overview
This folder contains a script to convert the **high-resolution SQLite databases** into CSV files. The output provides an alternative format for those who prefer working with CSV data instead of SQLite. The script generates **50 individual CSV files**, one for each participant.

## Script Overview
### **ConvertSQLiteToCSV.py**
- **Purpose:** Converts all participant data stored in SQLite into separate CSV files.
- **Output Format:** `G#Subject#.csv` (e.g., `G1Subject1.csv`, `G2Subject10.csv`)

## How It Works
1. **Reads SQLite Database:** The script connects to the SQLite database containing high-resolution driving data.
2. **Retrieves Data for Each Participant:** Queries data for each of the **50 participants**.
3. **Writes to CSV:** Saves each participant’s data into an individual CSV file.

## Usage Instructions
1. Ensure the high-resolution **SQLite database** is available.
2. Make sure the script reads the directory where the files are stored.
3. Run the script:
   ```bash
   python ConvertSQLiteToCSV.py
   ```
4. The script will generate **50 CSV files** named according to participant IDs.
