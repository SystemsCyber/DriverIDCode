import sqlite3
import pandas as pd
import os
from CANDataSPNDecoder2023 import CANDataSPNDecode
from zipfile import BadZipFile

# Base directory where your SQLite files are located
base_dir = '/Volumes/Extreme SSD/ORNLDriverIDs/'
group_structure = {
    'G1': 17,  # 17 subjects in Group 1
    'G2': 16,  # 16 subjects in Group 2
    'G3': 17   # 17 subjects in Group 3
}

# Define the path to save the Excel file on the external drive
output_file_path = '/Volumes/Extreme SSD/ORNLDriverIDs/ORNLDriverIDs_data.xlsx'
jsonFile = '/Volumes/Extreme SSD/SystemsCyberWork/J1939DA_MAY2022.json'

# Function to write to the Excel file
def write_to_excel(dataframe, sheet_name, mode):
    try:
        with pd.ExcelWriter(output_file_path, engine='openpyxl', mode=mode) as excel_writer:
            dataframe.to_excel(excel_writer, sheet_name=sheet_name, index=False)
    except BadZipFile:
        print(f"Corrupted file detected: {output_file_path}. Deleting and recreating...")
        # If file is corrupted, delete it and create a new one
        os.remove(output_file_path)
        with pd.ExcelWriter(output_file_path, engine='openpyxl') as excel_writer:
            dataframe.to_excel(excel_writer, sheet_name=sheet_name, index=False)

# Write each sheet individually to reduce memory usage
for group, subject_count in group_structure.items():
    for subject_num in range(1, subject_count + 1):
        print(group, subject_num)
        # Construct the directory path and file name dynamically
        directory_path = f"ORNLDriverID{group}S{str(subject_num).zfill(2)}"
        sqlite_file = os.path.join(base_dir, directory_path, f"DriverIDS{subject_num}G{group[-1]}.sqlite")

        if(group == "G1" and subject_num > 9 and subject_num < 13):
            print("adding can0")
            canFile = os.path.join(base_dir, directory_path, f"DriverIDS{subject_num}G{group[-1]}CANLogger3CandumpFormat.txt")
            decodedData = CANDataSPNDecode(canFile, jsonFile)

            engineSpeedCAN0 = decodedData['can0']["61444"]["190"]["data"]
            engineSpeedCAN0Time = decodedData['can0']["61444"]["190"]["time"]

            # Convert the lists to a pandas DataFrame
            lists_df = pd.DataFrame({
                '190 Engine Speed CAN0': engineSpeedCAN0,
                'Time190 CAN0': engineSpeedCAN0Time
            })
        elif((group == "G1" and subject_num > 12) or (group == "G2" and subject_num > 1) or (group == "G3")):
            print("adding can0")
            canFile = os.path.join(base_dir, directory_path, f"DriverIDS{subject_num}G{group[-1]}TruckCape.log")
            decodedData = CANDataSPNDecode(canFile, jsonFile)

            engineSpeedCAN0 = decodedData['can0']["61444"]["190"]["data"]
            engineSpeedCAN0Time = decodedData['can0']["61444"]["190"]["time"]

            # Convert the lists to a pandas DataFrame
            lists_df = pd.DataFrame({
                '190 Engine Speed CAN0': engineSpeedCAN0,
                'Time190 CAN0': engineSpeedCAN0Time
            })

        # Check if the SQLite file exists before attempting to connect
        if not os.path.exists(sqlite_file):
            print(f"SQLite file not found: {sqlite_file}")
            continue

        # Connect to the SQLite database
        conn = sqlite3.connect(sqlite_file)

        # Extract all data from each table
        spn_data = pd.read_sql_query("SELECT * FROM SPNData", conn)
        vbox_data = pd.read_sql_query("SELECT * FROM VBOXData", conn)
        sparkfun_gps_data = pd.read_sql_query("SELECT * FROM SparkfunGPSData", conn)
        heart_data = pd.read_sql_query("SELECT * FROM HeartData", conn)

        # Create a dictionary to hold all data for this subject
        subject_data = {
            'SPNData': spn_data,
            'VBOXData': vbox_data,
            'SparkfunGPSData': sparkfun_gps_data,
            'HeartData': heart_data
        }

        if((group == "G1" and subject_num > 9) or (group != "G1")):
            # Concatenate the data frames horizontally
            combined_data = pd.concat(subject_data.values(), axis=1)
            combined_with_lists = pd.concat([lists_df, combined_data], axis=1)
        else:
            combined_with_lists = pd.concat(subject_data.values(), axis=1)

        # Determine the mode ('a' for append if the file exists, 'w' for new file creation)
        if os.path.exists(output_file_path):
            mode = 'a'
        else:
            mode = 'w'

        # Write data to the Excel file
        sheet_name = f"{group}_Subject{subject_num}"
        write_to_excel(combined_with_lists, sheet_name, mode)

        # Close the SQLite connection to free memory
        conn.close()

print(f"Data extraction complete, file saved at: {output_file_path}.")
