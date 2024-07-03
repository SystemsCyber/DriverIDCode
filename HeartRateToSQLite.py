# HeartRateToSQLite
# Author: Tyler Biggs
#
# Purpose/Uses: 
# The purpose of this script is to decode a VBOX file and store the data into a sqlite database
#
# How to Use:
# python3 HeartRateToSQLite.py <Path to EDA file> <Path to HR file> <Path to IBI file>
# Example: python3 HeartRateToSQLite.py ~/Desktop/InputFiles/EDA.csv ~/Desktop/InputFiles/HR.csv ~/Desktop/InputFiles/IBI.csv 

import sys
import sqlite3
import pandas as pd
import datetime

# Function to parse EDA and HR CSV files
def parse_eda_hr(file_path):
    # Read the CSV file
    data = pd.read_csv(file_path, header=None)
    
    # Extract initial time and sample rate
    initial_time = datetime.datetime.utcfromtimestamp(data.iloc[0, 0])
    sample_rate = data.iloc[1, 0]
    
    # Extract the data
    data_values = data.iloc[2:].values.flatten().astype(float).tolist()
    
    # Calculate timestamps
    timestamps = [((initial_time + datetime.timedelta(seconds=i/sample_rate)).timestamp() - initial_time.timestamp()) for i in range(len(data_values))]
    #print(timestamps)
    return data_values, timestamps

# Function to parse IBI CSV file
def parse_ibi(file_path):
    # Read the CSV file, skipping the first row
    data = pd.read_csv(file_path, skiprows=1, header=None, names=['Relative Time (s)', 'Duration (s)'])
    
    # Convert data to lists
    data_values = data['Duration (s)'].astype(float).tolist()
    timestamps = (data['Relative Time (s)'].astype(float)).tolist()
    
    #print(timestamps)

    return data_values, timestamps

# Create sqlite Table
def create_table(file, canData, dataTitles):
    #print(file)
    connection = sqlite3.connect(file[:-13] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''CREATE TABLE IF NOT EXISTS HeartData
                      (id INTEGER PRIMARY KEY AUTOINCREMENT'''
    for i in range(len(dataTitles)):
        cursorString = cursorString + ''',\n''' + dataTitles[i] + ''' REAL'''

    cursorString = cursorString + ''')'''
    #print(cursorString)
    cursor.execute(cursorString)
    connection.commit()
    connection.close()

def insert_Data(file, canData, data, dataTitles):
    connection = sqlite3.connect(file[:-13] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''INSERT INTO HeartData ('''
    counter = 0
    for i in range(len(data)):
        if(i < len(data)-1):
            cursorString = cursorString + '''"''' + dataTitles[i] + '''", '''
            counter = counter + 1
        else:
            cursorString = cursorString + '''"''' + dataTitles[i] +  '''") VALUES ('''
            counter = counter + 1
            for j in range(counter):
                if j != counter -1:
                    cursorString = cursorString + "?, "
                else:
                    cursorString = cursorString + "?)"

    #print(cursorString)
    tupleData = ()
    for i in range(len(data)):
        tupleData = tupleData + (data[i],)
    #print(tupleData)
    cursor.execute(cursorString, tupleData)
    connection.commit()
    connection.close()

def main():
    # Get User Input
    EDAFile = ""
    HRFile = ""
    IBIFile = ""
    for i, arg in enumerate(sys.argv):
        if(i == 1):
            EDAFile = arg
        elif(i == 2):
            HRFile = arg
        elif(i == 3):
            IBIFile = arg

    # File paths
    eda_file_path = EDAFile
    hr_file_path = HRFile
    ibi_file_path = IBIFile

    # Parse the data
    eda_data_values, eda_timestamps = parse_eda_hr(eda_file_path)
    hr_data_values, hr_timestamps = parse_eda_hr(hr_file_path)
    ibi_data_values, ibi_timestamps = parse_ibi(ibi_file_path)

    HR_Data = [eda_timestamps, eda_data_values, hr_timestamps, hr_data_values, ibi_timestamps, ibi_data_values]

    dataTitles= ['EDATime', 'EDA', 'HRTime', 'HR', 'IBITime', 'IBI']
    #print(len(dataTitles))

    file = "/Users/tylerbiggs/Desktop/ORNLDriverIDs/ORNLDriverIDS8G1/DriverIDS8G1TruckCape.log"
    create_table(file, HR_Data, dataTitles)

    placement = 0
    while(1 > 0):
        dataPoint = []
        matchedDataTitles = []

        for i in range(len(HR_Data)):
            if(placement < len(HR_Data[i])):
                data = HR_Data[i][placement]
                dataPoint.append(data)
                matchedDataTitles.append(dataTitles[i])

        if(len(dataPoint) == 0):
            break

        insert_Data(file, HR_Data, dataPoint, matchedDataTitles)
        placement = placement + 1

if __name__ == "__main__":
    main()