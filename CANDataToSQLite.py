# CANDataSPNDecoder
# Author: Tyler Biggs
#
# Purpose/Uses: 
# The purpose of this script is to decode a J1939 candump file and store the data into a sqlite database
#
# Requirements:
# This python script requires the J1939 digital annex in a json file format
# The J1939 digital annex can be converted to a json file through this github page:
# https://github.com/SystemsCyber/J1939Converters
#
# How to Use:
# python3 CANDataToSQLite.py <Path to candump file> <Path to J1939 JSON File>
# Example: python3 CANDataToSQLite.py ~/Desktop/InputFiles/candumpFile.log ~/Desktop/InputFiles/J1939DA_MAY2022.json

import sys
import sqlite3
from CANDataSPNDecoder2023 import CANDataSPNDecode

# Create sqlite Table
def create_table(file, decodedData, PGNs, SPNs):
    connection = sqlite3.connect(file[:-27] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''CREATE TABLE IF NOT EXISTS SPNData
                      (id INTEGER PRIMARY KEY AUTOINCREMENT'''
    for i in range(len(PGNs)):
        if(PGNs[i] in decodedData and SPNs[i] in decodedData[PGNs[i]] and len(decodedData[PGNs[i]][SPNs[i]]["data"]) > 0):
            cursorString = cursorString + ''',\nTime''' + SPNs[i] + ''' REAL'''
            cursorString = cursorString + ''',\n"''' + SPNs[i] + ''' ''' + decodedData[PGNs[i]][SPNs[i]]["SPLabel"] + '''" REAL'''

    cursorString = cursorString + ''')'''
    #print(cursorString)
    cursor.execute(cursorString)
    connection.commit()
    connection.close()

#Insert Data into SQLite Database
def insert_Data(file, decodedData, data, PGNs, SPNs):
    connection = sqlite3.connect(file[:-27] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''INSERT INTO SPNData ('''
    pgnCheck = []
    counter = 0
    for i in range(len(PGNs)):
        if(PGNs[i] in decodedData and SPNs[i] in decodedData[PGNs[i]]):
            if(i < len(PGNs)-1):
                cursorString = cursorString + '''Time''' + SPNs[i] + ''', '''
                cursorString = cursorString + '''"''' + SPNs[i] + ''' ''' + decodedData[PGNs[i]][SPNs[i]]["SPLabel"] + '''", '''
                counter = counter + 2
            else:
                cursorString = cursorString + '''Time''' + SPNs[i] + ''', '''
                cursorString = cursorString + '''"''' + SPNs[i] + ''' ''' + decodedData[PGNs[i]][SPNs[i]]["SPLabel"] + '''") VALUES ('''
                counter = counter + 2
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
    jsonFile = ""
    for i, arg in enumerate(sys.argv):
        if(i == 1):
            file = arg
        elif(i == 2):
            jsonFile = arg

    # Decode candump log File
    decodedData = CANDataSPNDecode(file, jsonFile)

    #Initialize PGNs and SPNs
    PGNs = []
    SPNs = []
    
    # PGNs and SPNs
    PGNs = ['65170', '65266','65266','65266','65266','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65198','65198','65198','65198','65198','65198','61444',
            '61444','61443','61443','61443','61452', '65247', '65247', '61443', '61444', '61445', '61445','61452', '64914', '65198', '65247', '65265', '65265', '65266']

    SPNs = ["1242", "184", "185", "51", "3673", "69", "70", "1633", "3807", "595", "596", "598", "599", "600", "601", "602", "86", "976", "527", "968", "967", "966", "1237",
            '46','1086','1087','1088','1089','1090','2432',
            '4154','5398', '3357','92','3030', '2978', '515', '91', '190', '523', '524','5052', '632', '1351', '514', '84', '597', '183']

    #print(len(PGNs))
    #print(len(SPNs))

    create_table(file, decodedData, PGNs, SPNs)

    #Loop through decoded data and insert into database
    placement = 0
    while(1 > 0):
        dataPoint = []
        matchedPGNs = []
        matchedSPNs = []

        for i in range(len(PGNs)):
            if(PGNs[i] in decodedData and SPNs[i] in decodedData[PGNs[i]]):
                if(placement < len(decodedData[PGNs[i]][SPNs[i]]["data"])):
                    data = decodedData[PGNs[i]][SPNs[i]]["time"][placement]
                    dataPoint.append(data)
                    data = decodedData[PGNs[i]][SPNs[i]]["data"][placement]
                    dataPoint.append(data)
                    matchedPGNs.append(PGNs[i])
                    matchedSPNs.append(SPNs[i])

        #print(matchedPGNs)
        #print(matchedSPNs)
        #print(len(matchedSPNs))
        #print(len(dataPoint))

        if(len(dataPoint) == 0):
            break

        insert_Data(file, decodedData, dataPoint, matchedPGNs, matchedSPNs)
        placement = placement + 1

if __name__ == "__main__":
    main()