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
    connection = sqlite3.connect(file[:-4] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''CREATE TABLE IF NOT EXISTS SPNData
                      (id INTEGER PRIMARY KEY AUTOINCREMENT'''
    for i in range(len(PGNs)):
        if(PGNs[i] in decodedData['can1'] and SPNs[i] in decodedData['can1'][PGNs[i]] and len(decodedData['can1'][PGNs[i]][SPNs[i]]["data"]) > 0):
            cursorString = cursorString + ''',\nTime''' + SPNs[i] + ''' REAL'''
            cursorString = cursorString + ''',\n"''' + SPNs[i] + ''' ''' + decodedData['can1'][PGNs[i]][SPNs[i]]["SPLabel"] + '''" REAL'''

    cursorString = cursorString + ''')'''
    #print(cursorString)
    cursor.execute(cursorString)
    connection.commit()
    connection.close()

#Insert Data into SQLite Database
def insert_Data(file, decodedData, data, PGNs, SPNs):
    connection = sqlite3.connect(file[:-4] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''INSERT INTO SPNData ('''
    pgnCheck = []
    counter = 0
    for i in range(len(PGNs)):
        if(PGNs[i] in decodedData['can1'] and SPNs[i] in decodedData['can1'][PGNs[i]]):
            if(i < len(PGNs)-1):
                cursorString = cursorString + '''Time''' + SPNs[i] + ''', '''
                cursorString = cursorString + '''"''' + SPNs[i] + ''' ''' + decodedData['can1'][PGNs[i]][SPNs[i]]["SPLabel"] + '''", '''
                counter = counter + 2
            else:
                cursorString = cursorString + '''Time''' + SPNs[i] + ''', '''
                cursorString = cursorString + '''"''' + SPNs[i] + ''' ''' + decodedData['can1'][PGNs[i]][SPNs[i]]["SPLabel"] + '''") VALUES ('''
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
    #PGNss = ['65170', '65266','65266','65266','65266','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65265','65198','65198','65198','65198','65198','65198','61444',
    #        '61444','61443','61443','61443','61452', '65247', '65247', '61443', '61444', '61445', '61445','61452', '64914', '65198', '65247', '65265', '65265', '65266']
    
    PGNs = ['61443', '65098', '61444', '61444', '61443', '61440', '65110', '65110', '64800', '64946', '64948', '64908', '64947', '64891', '64891', '64948', '61455', '61455', '61455',
            '61455', '61455', '64830', '64709', '64830', '65247', '65269', '65269', '65271', '65274', '65274', '64765', '64732', '61444', '65247', '65266', '65262', '65263', '61444',
            '65188', '61454', '65170', '61450', '65188', '64916', '65213', '57344', '65243', '65266', '65266', '61450', '65270', '65270', '65263', '61443', '0', '0', '0', '61444',
            '65266', '65257', '65253', '65244', '65244', '65253', '65257', '65178', '65245', '64931', '65247', '61443', '65215', '65276', '65170', '0', '0', '61442', '65247', '65264',
            '65215', '65215', '65215', '65215', '65198', '65198', '65132', '64914', '65248', '61442', '61442', '61445', '61452', '61445', '65272', '61445', '61442', '61442', '61442',
            '61452', '65203', '65248', '65217', '61443', '65265']

    #SPNss = ["1242", "184", "185", "51", "3673", "69", "70", "1633", "3807", "595", "596", "598", "599", "600", "601", "602", "86", "976", "527", "968", "967", "966", "1237",
    #        '46','1086','1087','1088','1089','1090','2432',
    #        '4154','5398', '3357','92','3030', '2978', '515', '91', '190', '523', '524','5052', '632', '1351', '514', '84', '597', '183']
    
    SPNs = ['91', '2945', '513', '4154', '3357', '1717', '3031', '1761', '4765', '3251', '3242', '3610', '3246', '5466', '3721', '3241', '3229', '3232', '3226', 
            '3230', '3231', '4360', '5862', '4363', '3239', '171', '108', '168', '117', '118', '5313', '7319', '512', '515', '185', '110', '101', '2432', 
            '1136', '3216', '1209', '2659', '412', '27', '975', '986', '157', '183', '184', '132', '102', '105', '100', '92', '898', '4191', '518', '190', 
            '51', '250', '247', '236', '235', '249', '182', '1172', '103', '641', '2978', '5398', '904', '96', '1242', '4207', '4206', '5015', '514', '187', 
            '905', '906', '907', '908', '1087', '1088', '1624', '3544', '245', '161', '191', '526', '5052', '523', '177', '524', '574', '573', '4816', 
            '3030', '1029', '244', '918', '2979', '84']

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
            if(PGNs[i] in decodedData['can1'] and SPNs[i] in decodedData['can1'][PGNs[i]]):
                if(placement < len(decodedData['can1'][PGNs[i]][SPNs[i]]["data"])):
                    data = decodedData['can1'][PGNs[i]][SPNs[i]]["time"][placement] + 1717856900.628432 - 1651394063.497876
                    dataPoint.append(data)
                    data = decodedData['can1'][PGNs[i]][SPNs[i]]["data"][placement]
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