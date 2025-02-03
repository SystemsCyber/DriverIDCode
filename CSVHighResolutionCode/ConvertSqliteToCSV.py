import sqlite3
import pandas as pd
import sys
from CANDataSPNDecoder2023 import CANDataSPNDecode

inFile = ""
outFile = ""
canFile = ""

for i, arg in enumerate(sys.argv):
        if(i == 1):
            inFile = arg
        elif(i == 2):
            outFile = arg
        elif(i ==3):
            canFile = arg
        elif(i==4):
             jsonFile = arg

decodedData = CANDataSPNDecode(canFile, jsonFile)



EngineSpeedCAN0 = decodedData['can0']["61444"]["190"]['data']
Time190CAN0 = decodedData['can0']["61444"]["190"]['time']

# Create a DataFrame from the two lists
primary_df = pd.DataFrame({
    "190 Engine Speed CAN0": EngineSpeedCAN0,
    "Time190 CAN0": Time190CAN0
})

# Connect to the SQLite database
conn = sqlite3.connect(inFile)

# List of tables to read from the SQLite database
tables = ['SPNData', 'SparkfunGPSData', 'VBOXData', 'HeartData']

# Read each table into a DataFrame
dataframes = [pd.read_sql_query(f'SELECT * FROM {table}', conn) for table in tables]

# Concatenate the primary DataFrame and the database tables side-by-side
merged_df = pd.concat([primary_df] + dataframes, axis=1)

# Write the merged DataFrame to CSV
merged_df.to_csv(outFile, index=False)

# Close the database connection
conn.close()

print("Data successfully written to G3_Subject6.csv")
