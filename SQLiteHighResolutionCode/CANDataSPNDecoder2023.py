import re
import json
import sys
import matplotlib.pyplot as plt

def CANDataSPNDecode(file, jsonFile):
    #Open and read CAN data file
    with open(file, "r") as file:
        can_msgs = file.readlines()

    #Open and Read J1939 json file
    with open(jsonFile, "r") as file:
        jsonData = json.load(file) 

    

    #Declare dictionary that will be returned
    returnJson = {}
    returnJson['can0'] = {}
    returnJson['can1'] = {}

    #Declare lists
    time = []
    dataID = []
    bytesString = []
    canChannel = []

    #Parses CAN data into four lists, which are time, ID, data bytes, and byte data length
    #If timestamps are not in the data, then it has a case to check for it
    for i in can_msgs:
        contents = i.split()
        data = contents[2].split('#')
        id = data[0]
        dataBytes = data[1]

        if(len(id) < 8):
            continue
        if(len(dataBytes) < 16):
            continue

        
        
        time.append(float(contents[0][1:-1]))
        dataID.append(id)
        canChannel.append(contents[1])
        bytesString.append(dataBytes)

        

    #Analyze CAN data
    for i in range(0, len(dataID)):

        #if(cantype[i] != "can1"):
        #    continue

        #Checks byte amount
        if(len(dataID[i]) < 8):
            continue

        #Calculate PGN
        pgn = dataID[i][2:6]
        if(int(pgn[0:2],16) < int("F0",16)):
            pgn = pgn[0:2] + "00"
        pgn = str(int(pgn, 16))

        #Load in data, time, unit, and SP Labels into returnFile dictionary
        if(pgn in returnJson[canChannel[i]]):

            #If the pgn is in the dictionary, then just append the SPN data into the corresponding lists in the dictionary
            try:
                spnList = jsonData["PGN"][pgn]["SPN"]
            except KeyError:
                continue
            startBit = jsonData["PGN"][pgn]["SPNStartBit"]
            for j in range(0, len(spnList)):

                #Splits the spLength into two strings. One is the value and other is a unit
                spLength = jsonData["SPN"][spnList[j]]["SP Length"].split(" ")

                #Case for if spLength does not exist
                if(spLength == ["nan"]):
                    continue

                #Creates bitLength variable and adds amount of bits into it based on if the unit is byte or bit
                bitLength = 1
                if(spLength[1] == "bytes" or spLength[1] == "byte"):
                    bitLength = int(spLength[0]) * 8
                elif(spLength[1] == "bits" or spLength[1] == "bit"):
                    bitLength = int(spLength[0])


                #Gets the start bit into a better value for accessing a specific part of the binary value of the data
                splitStartBit = startBit[j].split(".")
                SPNStartBit = (int(splitStartBit[0])-1)*8 + (int(splitStartBit[1])-1)

                #Creates binary value of data
                val = bin(int(bytesString[i], 16))[2:].zfill(64)

                #Case for if val is empty
                if(val == ""):
                    continue

                #Checks if it is in bits, if so, then calculate data and append lists
                if(spLength[1] == "bits" or spLength[1] == "bit"):
                    data = int(val[SPNStartBit:SPNStartBit+bitLength]) *float(jsonData["SPN"][spnList[j]]["Scale (Value Only)"]) +float(jsonData["SPN"][spnList[j]]["Offset (Value Only)"])
                    returnJson[canChannel[i]][pgn][spnList[j]]["data"].append(int(data))
                    if(contents[0][0] == "("):
                        returnJson[canChannel[i]][pgn][spnList[j]]["time"].append(float(time[i]))
                    continue


                #Parse the binary value into the specific SPN data range
                binaryData = val[SPNStartBit:SPNStartBit+bitLength]

                dataRangeBinary = ""

                #If it is in bytes, then read the bytes in reverse
                for z in range(0, int(spLength[0])):
                    dataRangeBinary += binaryData[(len(binaryData)-8*z-8):(len(binaryData)-8*z)]


                #Calculate Data
                data = int(dataRangeBinary,2) *float(jsonData["SPN"][spnList[j]]["Scale (Value Only)"]) +float(jsonData["SPN"][spnList[j]]["Offset (Value Only)"])

                if(float(jsonData["SPN"][spnList[j]]["Offset (Value Only)"]) <= data <= float(jsonData["SPN"][spnList[j]]["RangeMax (Value Only)"])):
                    returnJson[canChannel[i]][pgn][spnList[j]]["data"].append(data)
                    if(contents[0][0] == "("):
                        returnJson[canChannel[i]][pgn][spnList[j]]["time"].append(float(time[i]))

        else:
            #If the pgn is not in the dictionary, then add it into the dictionary and declare the SPNs and add in data into lists
            try:
                spnList = jsonData["PGN"][pgn]["SPN"]
            except KeyError:
                continue
            startBit = jsonData["PGN"][pgn]["SPNStartBit"]
            
            returnJson[canChannel[i]][pgn] = {}

            #Loop for going through SPNs corresponding to the PGN
            for j in range(0, len(spnList)):
                #Make a dictionary for each SPN
                returnJson[canChannel[i]][pgn][spnList[j]] = {}
                returnJson[canChannel[i]][pgn][spnList[j]]["SPLabel"] = jsonData["SPN"][spnList[j]]["SP Label"]
                returnJson[canChannel[i]][pgn][spnList[j]]["Unit"] = jsonData["SPN"][spnList[j]]["Unit"]
                returnJson[canChannel[i]][pgn][spnList[j]]["data"] = []
                if(contents[0][0] == "("):
                    returnJson[canChannel[i]][pgn][spnList[j]]["time"] = []



                #Splits the spLength into two strings. One is the value and other is a unit
                spLength = jsonData["SPN"][spnList[j]]["SP Length"].split(" ")

                #Case for if spLength does not exist
                if(spLength == ["nan"]):
                    continue

                #Creates bitLength variable and adds amount of bits into it based on if the unit is byte or bit
                bitLength = 1
                if(spLength[1] == "bytes" or spLength[1] == "byte"):
                    bitLength = int(spLength[0]) * 8
                elif(spLength[1] == "bits" or spLength[1] == "bit"):
                    bitLength = int(spLength[0])


                #Gets the start bit into a better value for accessing a specific part of the binary value of the data
                splitStartBit = startBit[j].split(".")
                SPNStartBit = (int(splitStartBit[0])-1)*8 + (int(splitStartBit[1])-1)


                #Creates binary value of data
                #print(bytesString[i])
                val = bin(int(bytesString[i], 16))[2:].zfill(64)

                #Case for if val is empty
                if(val == ""):
                    continue

                #Checks if it is in bits, if so, then calculate data and append lists
                if(spLength[1] == "bits" or spLength[1] == "bit"):
                    data = int(val[SPNStartBit:SPNStartBit+bitLength]) *float(jsonData["SPN"][spnList[j]]["Scale (Value Only)"]) +float(jsonData["SPN"][spnList[j]]["Offset (Value Only)"])
                    returnJson[canChannel[i]][pgn][spnList[j]]["data"].append(int(data))
                    if(contents[0][0] == "("):
                        returnJson[canChannel[i]][pgn][spnList[j]]["time"].append(float(time[i]))
                    continue

                #Parse the binary value into the specific SPN data range
                binaryData = val[SPNStartBit:SPNStartBit+bitLength]

                dataRangeBinary = ""

                #If it is in bytes, then read the bytes in reverse
                for z in range(0, int(spLength[0])):
                    dataRangeBinary += binaryData[(len(binaryData)-8*z-8):(len(binaryData)-8*z)]

                #Calculate data
                data = int(dataRangeBinary,2) *float(jsonData["SPN"][spnList[j]]["Scale (Value Only)"]) +float(jsonData["SPN"][spnList[j]]["Offset (Value Only)"])

                if(float(jsonData["SPN"][spnList[j]]["Offset (Value Only)"]) <= data <= float(jsonData["SPN"][spnList[j]]["RangeMax (Value Only)"])):
                    returnJson[canChannel[i]][pgn][spnList[j]]["data"].append(data)
                    if(contents[0][0] == "("):
                        returnJson[canChannel[i]][pgn][spnList[j]]["time"].append(float(time[i]))

    return returnJson

def write_filtered_dict_to_file(d, file, indent=0):
    if isinstance(d, dict):
        for key, value in d.items():
            if key not in ["data", "time"]:
                if isinstance(value, dict):
                    file.write(' ' * indent + f"{key}:\n")
                    write_filtered_dict_to_file(value, file, indent + 4)
                else:
                    file.write(' ' * indent + f"{key}: {value}\n")
            if key == "SPLabel" and "" in value:
                if "data" in d and "time" in d:
                    plot_data_and_time(d["time"], d["data"], value.replace("/", "").replace("\\", "").replace(" ", ""))

def plot_data_and_time(time, data, label):
    plt.figure()
    plt.plot(time, data, marker='o')
    plt.title(f"{label} Data")
    plt.xlabel("Time")
    plt.ylabel("Data")
    plt.grid(True)
    plt.savefig(f"{label}_plot.png")
    plt.close()


if __name__ == '__main__':
    file = ""
    for i, arg in enumerate(sys.argv):
        if(i==1):
            file = arg
        elif(i==2):
            jsonFile = arg


    decoded = CANDataSPNDecode(file, jsonFile)

    with open("filtered_output.txt", "w") as file:
        write_filtered_dict_to_file(decoded, file)

    #with open("CANDataSPNDecoded.json", "w") as outfile:
    #    outfile.write(json.dumps(decoded, indent=4))