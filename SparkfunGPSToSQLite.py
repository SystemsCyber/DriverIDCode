# ArduinoGPSToSQLite
# Author: Tyler Biggs
#
# Purpose/Uses: 
# The purpose of this script is to decode a J1939 candump file and store the data into a sqlite database
#
# Requirements:
# https://github.com/SystemsCyber/TruckGPS
#
# How to Use:
# python3 ArduinoGPSToSQLite.py <Path to candump file>
# Example: python3 ArduinoGPSToSQLite.py ~/Desktop/InputFiles/candumpFile.log

import sys
import sqlite3

def twos_complement(hex_string, num_bits):
    # Convert hex to binary
    binary_string = bin(int(hex_string, 16))[2:].zfill(num_bits)
    
    # Check if it's a negative number
    if binary_string[0] == '1':
        inverted_bits = ''.join('1' if bit == '0' else '0' for bit in binary_string)
        incremented_value = int(inverted_bits, 2) + 1
        decimal_value = -incremented_value
    else:
        decimal_value = int(binary_string, 2)
    return decimal_value

#Decodes Arduino GPS data
def get_data(can_msgs):
    canloggerTime = []
    longitude = []
    latitude = []
    gpsSpeed = []
    headingDegree = []
    timestampHeading = []
    numSats = []
    gpsTime = []
    timestampSat = []
    timestampsLocation = []
    counter = 0

    for i in can_msgs:
        contents = i.split()
        data = contents[2].split('#')
        id = data[0]
        dataBytes = data[1]

        if(len(id) < 8):
            continue
        if(len(dataBytes) < 16):
            continue

        #Get Longitude and Latitude
        if(id[2:-2] == "FF01"):
            longitudeHex = dataBytes[14:16] + dataBytes[12:14] + dataBytes[10:12] + dataBytes[8:10]
            latitudeHex = dataBytes[6:8] + dataBytes[4:6] + dataBytes[2:4] + dataBytes[0:2]
            longitude.append(twos_complement(longitudeHex, 32)/10000000)
            latitude.append(twos_complement(latitudeHex, 32)/10000000)
            timestampsLocation.append(float(contents[0][1:-1]))

        #Get GPS Speed and Heading Degree
        elif(id[2:-2] == "FF02"):
            gpsSpeed.append(int((dataBytes[6:8] + dataBytes[4:6] + dataBytes[2:4] + dataBytes[0:2]), 16)/1000000)
            headingDegree.append(int((dataBytes[14:16] + dataBytes[12:14] + dataBytes[10:12] + dataBytes[8:10]), 16)/100000)
            timestampHeading.append(float(contents[0][1:-1]))

        #Get number of satellites and GPS time
        elif(id[2:-2] == "FF03"):
            numSats.append(int(dataBytes[0:2], 16))
            us = int((dataBytes[6:8] + dataBytes[4:6] + dataBytes[2:4]), 16)
            epoch = int((dataBytes[14:16] + dataBytes[12:14] + dataBytes[10:12] + dataBytes[8:10]), 16)
            gpsTime.append(float(epoch) + (float(us)/1000000))
            canloggerTime.append(float(contents[0][1:-1]))
            timestampSat.append(float(contents[0][1:-1]))

    return [canloggerTime, gpsTime, timestampsLocation, longitude, latitude, timestampHeading, gpsSpeed, headingDegree, 
            timestampSat, numSats]

# Create sqlite Table
def create_table(file, canData, dataTitles):
    #print(file)
    connection = sqlite3.connect(file[:-27] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''CREATE TABLE IF NOT EXISTS SparkfunGPSData
                      (id INTEGER PRIMARY KEY AUTOINCREMENT'''
    for i in range(len(dataTitles)):
        cursorString = cursorString + ''',\n''' + dataTitles[i] + ''' REAL'''

    cursorString = cursorString + ''')'''
    #print(cursorString)
    cursor.execute(cursorString)
    connection.commit()
    connection.close()

def insert_Data(file, canData, data, dataTitles):
    connection = sqlite3.connect(file[:-27] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''INSERT INTO SparkfunGPSData ('''
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
    file = ""
    for i, arg in enumerate(sys.argv):
        if(i == 1):
            file = arg

    # Decode CAN GPS Data
    with open(file) as f:
        can_msgs = f.readlines()
    canData = get_data(can_msgs)

    dataTitles= ['canloggerTime', 'gpsTime', 'timestampsLocation', 'longitude', 'latitude', 'timestampHeading', 'gpsSpeed', 'headingDegree', 
            'timestampSat', 'numSats']

    create_table(file, canData, dataTitles)

    placement = 0
    while(1 > 0):
        dataPoint = []
        matchedDataTitles = []

        for i in range(len(canData)):
            if(placement < len(canData[i])):
                data = canData[i][placement]
                dataPoint.append(data)
                matchedDataTitles.append(dataTitles[i])


        if(len(dataPoint) == 0):
            break

        insert_Data(file, canData, dataPoint, matchedDataTitles)
        placement = placement + 1

if __name__ == "__main__":
    main()