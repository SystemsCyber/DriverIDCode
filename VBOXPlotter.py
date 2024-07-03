# DriverIDPlotter
# Author: Tyler Biggs
#
# Purpose/Uses: 
# The purpose of this script is to decode GPS data, J1939 data, VBOX data, and Heart Rate Data from a box truck.
# This is used to visualize the data for the ORNL DriverID project.
#
# Requirements:
# This python script requires the J1939 digital annex in a json file format
# The J1939 digital annex can be converted to a json file through this github page:
# https://github.com/SystemsCyber/J1939Converters
#
# How to Use:
# python3 DriverIDPlotter.py <Path to candump file> <Path to J1939 Digital Annex JSON File> <Path to VBOX data file> <Path to EDA csv file> <Path to HR csv file> <Path to IBI csv file>
# Example: python3 CANDataToSQLite.py ~/Desktop/candumpFile.log ~/Desktop/J1939DA_MAY2022.json ~/Desktop/VBOXDriverID1.VBO ~/Desktop/EDA.csv ~/Desktop/HR.csv ~/Desktop/IBI.csv

import os
import matplotlib.pyplot as plt
import plotly.graph_objs as go
import plotly.subplots as sp
import argparse
import struct
from collections import Counter
from numpy import mean
import numpy as np
import sys
import plotly.graph_objects as go
from CANDataSPNDecoder2023 import CANDataSPNDecode
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import pandas as pd
import datetime
import time

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

#Converts the CAN Binary format into a candump format
def convert_bin_to_candump(filename):
    candump_list =[]
    fileLocation = 0
    file_size = os.path.getsize(filename)
    with open(filename,'rb') as binFile:
        while(fileLocation<file_size):
            block =binFile.read(512) #read every 512 bytes
            fileLocation+=512
            for recordNum in range(19): #Parse through CAN message
                record = block[4+recordNum*25:4+(recordNum+1)*25]
                channel = record[0]
                timeSeconds = struct.unpack("<L",record[1:5])[0]
                timeMicrosecondsAndDLC = struct.unpack("<L",record[13:17])[0]
                timeMicroseconds = timeMicrosecondsAndDLC & 0x00FFFFFF
                abs_time = timeSeconds + timeMicroseconds * 0.000001
                ID = struct.unpack("<L",record[9:13])[0]
                message_bytes = record[17:25]
                #create list for all data parsed
                candump_list.append("({:0.6f}) can{:0.0f} {:08X}#{}"
                                    .format(abs_time,channel,ID,''.join(["{:02X}"
                                        .format(b) for b in message_bytes])))
    return candump_list

#Decodes CAN data
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
        if counter == 0:
            firstTimestamp = float(contents[0][1:-1])
            counter = 1
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
            timestampsLocation.append((float(contents[0][1:-1]) - float(firstTimestamp))/60)

        #Get GPS Speed and Heading Degree
        elif(id[2:-2] == "FF02"):
            gpsSpeed.append(int((dataBytes[6:8] + dataBytes[4:6] + dataBytes[2:4] + dataBytes[0:2]), 16)/1000000)
            headingDegree.append(int((dataBytes[14:16] + dataBytes[12:14] + dataBytes[10:12] + dataBytes[8:10]), 16)/100000)
            timestampHeading.append((float(contents[0][1:-1]) - float(firstTimestamp))/60)

        #Get number of satellites and GPS time
        elif(id[2:-2] == "FF03"):
            numSats.append(int(dataBytes[0:2], 16))
            us = int((dataBytes[6:8] + dataBytes[4:6] + dataBytes[2:4]), 16)
            epoch = int((dataBytes[14:16] + dataBytes[12:14] + dataBytes[10:12] + dataBytes[8:10]), 16)
            gpsTime.append(float(epoch) + (float(us)/1000000))
            canloggerTime.append(float(contents[0][1:-1]))
            timestampSat.append((float(contents[0][1:-1]) - float(firstTimestamp))/60)

    return [longitude, latitude, gpsSpeed, headingDegree, numSats, gpsTime, timestampSat, 
            timestampHeading, timestampsLocation, canloggerTime]

def create_kml_fileGPS(filename, longitude_list, latitude_list):
    filtered_latitude = []
    filtered_longitude = []
    for i in range(0,len(longitude_list),100):
        filtered_latitude.append(latitude_list[i])
        filtered_longitude.append(longitude_list[i])
    
    with open(filename, 'w') as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write('<kml xmlns="http://www.opengis.net/kml/2.2">\n')
        f.write('  <Document>\n')
        
        # Define a style for a smaller pin
        f.write('    <Style id="smallPin">\n')
        f.write('      <IconStyle>\n')
        f.write('        <scale>0.5</scale>\n')  # This scale value can be adjusted to your desired size
        f.write('        <Icon>\n')
        f.write('          <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>\n')  # default yellow pushpin
        f.write('        </Icon>\n')
        f.write('      </IconStyle>\n')
        f.write('    </Style>\n')

        for i, (filtered_longitude, filtered_latitude) in enumerate(zip(filtered_longitude, filtered_latitude), start=1):
            f.write(f'    <Placemark>\n')
            f.write(f'      <name>Location {i}</name>\n')
            f.write(f'      <styleUrl>#smallPin</styleUrl>\n')  # Reference the custom style
            f.write(f'      <Point>\n')
            f.write(f'        <coordinates>{filtered_longitude},{filtered_latitude},0</coordinates>\n')
            f.write(f'      </Point>\n')
            f.write(f'    </Placemark>\n')

        f.write('  </Document>\n')
        f.write('</kml>\n')

#Generates a kml file to be used for Google Earth
def create_kml_fileVBOX(filename, longitude_list, latitude_list):
    filtered_latitude = []
    filtered_longitude = []
    for i in range(0,len(longitude_list),1000):
        filtered_latitude.append(latitude_list[i])
        filtered_longitude.append(longitude_list[i])
    
    with open(filename, 'w') as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write('<kml xmlns="http://www.opengis.net/kml/2.2">\n')
        f.write('  <Document>\n')
        
        # Define a style for a smaller pin
        f.write('    <Style id="smallPin">\n')
        f.write('      <IconStyle>\n')
        f.write('        <scale>0.5</scale>\n')  # This scale value can be adjusted to your desired size
        f.write('        <Icon>\n')
        f.write('          <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>\n')  # default yellow pushpin
        f.write('        </Icon>\n')
        f.write('      </IconStyle>\n')
        f.write('    </Style>\n')

        for i, (filtered_longitude, filtered_latitude) in enumerate(zip(filtered_longitude, filtered_latitude), start=1):
            f.write(f'    <Placemark>\n')
            f.write(f'      <name>Location {i}</name>\n')
            f.write(f'      <styleUrl>#smallPin</styleUrl>\n')  # Reference the custom style
            f.write(f'      <Point>\n')
            f.write(f'        <coordinates>{filtered_longitude},{filtered_latitude},0</coordinates>\n')
            f.write(f'      </Point>\n')
            f.write(f'    </Placemark>\n')

        f.write('  </Document>\n')
        f.write('</kml>\n')

#Decode VBOX Data
def decodeVBOX(file):
    with open(file, 'r', encoding='ISO-8859-1') as f:
        content = f.readlines()

    # Check if we are in the [data] section of the file
    in_data_section = False

    # List to hold extracted values
    sats = []
    time = []
    lat = []
    long = []
    velocity = []
    heading = []
    height = []
    vert_vel = []
    Longacc = []
    Latacc = []
    Glonass_Sats = []
    GPS_Sats = []
    IMU_Kalman_Filter_Status = []
    Solution_Type = []
    Velocity_Quality = []
    event_1 = []
    _lat = []
    _long = []
    _velocity = []
    _heading = []
    _height = []
    _vert_vel = []
    KF_WheelSpeed_Left = []
    KF_WheelSpeed_Right = []
    RMS_hpos = []
    RMS_vpos = []
    RMS_HVELVal = []
    RMS_VVELVal = []
    POSCov_xx = []
    POSCov_yy = []
    POSCov_zz = []
    VELCov_xx = []
    VELCov_yy = []
    VELCov_zz = []
    T1Val = []
    True_Head = []
    Slip_Angle = []
    Pitch_Ang = []
    Lat_Vel = []
    Yaw_Rate = []
    Roll_Angle = []
    Lng_Vel = []
    Slip_COG = []
    Slip_FL = []
    Slip_FR = []
    Slip_RL = []
    Slip_RR = []
    SlipHead = []
    RobotHead = []
    YawRate = []
    X_Accel = []
    Y_Accel = []
    Temp = []
    PitchRate = []
    RollRate = []
    Z_Accel = []
    Head_imu = []
    Pitch_imu = []
    Roll_imu = []
    Pos_Qual = []
    Lng_Jerk = []
    Lat_Jerk = []
    Head_imu2 = []

    firstTimestamp = 0
    counter =0

    for line in content:
        line = line.strip()

        if line == '[data]':
            in_data_section = True
            continue
        elif line.startswith('['):  # any other section starts
            in_data_section = False

        if in_data_section:
            values = line.split()
            sats.append(float(values[0]))
            if counter == 0:
                firstTimestamp = float(values[1][0:2])*60*60 + float(values[1][2:4])*60 + float(values[1][4:])
                counter = 1
            time.append((float(values[1][0:2])*60*60 + float(values[1][2:4])*60 + float(values[1][4:]) - firstTimestamp)/60)
            
            latitude = float(values[2][1:])/60
            longitude = (-1)*float(values[3][1:])/60

            lat.append(latitude)
            long.append(longitude)

            velocity.append(float(values[4]))
            heading.append(float(values[5]))
            height.append(float(values[6]))
            vert_vel.append(float(values[7]))
            Longacc.append(float(values[8]))
            Latacc.append(float(values[9]))
            Glonass_Sats.append(float(values[10]))
            GPS_Sats.append(float(values[11]))
            IMU_Kalman_Filter_Status.append(float(values[12]))
            Solution_Type.append(float(values[13]))
            Velocity_Quality.append(float(values[14]))
            event_1.append(float(values[15]))
            _lat.append(float(values[16]))
            _long.append(float(values[17]))
            _velocity.append(float(values[18]))
            _heading.append(float(values[19]))
            _height.append(float(values[20]))
            _vert_vel.append(float(values[21]))
            KF_WheelSpeed_Left.append(float(values[22]))
            KF_WheelSpeed_Right.append(float(values[23]))
            RMS_hpos.append(float(values[24]))
            RMS_vpos.append(float(values[25]))
            RMS_HVELVal.append(float(values[26]))
            RMS_VVELVal.append(float(values[27]))
            POSCov_xx.append(float(values[28]))
            POSCov_yy.append(float(values[29]))
            POSCov_zz.append(float(values[30]))
            VELCov_xx.append(float(values[31]))
            VELCov_yy.append(float(values[32]))
            VELCov_zz.append(float(values[33]))
            T1Val.append(float(values[34]))
            True_Head.append(float(values[35]))
            Slip_Angle.append(float(values[36]))
            Pitch_Ang.append(float(values[37]))
            Lat_Vel.append(float(values[38]))
            Yaw_Rate.append(float(values[39]))
            Roll_Angle.append(float(values[40]))
            Lng_Vel.append(float(values[41]))
            Slip_COG.append(float(values[42]))
            Slip_FL.append(float(values[43]))
            Slip_FR.append(float(values[44]))
            Slip_RL.append(float(values[45]))
            Slip_RR.append(float(values[46]))
            SlipHead.append(float(values[47]))
            RobotHead.append(float(values[48]))
            YawRate.append(float(values[49]))
            X_Accel.append(float(values[50]))
            Y_Accel.append(float(values[51]))
            Temp.append(float(values[52]))
            PitchRate.append(float(values[53]))
            RollRate.append(float(values[54]))
            Z_Accel.append(float(values[55]))
            Head_imu.append(float(values[56]))
            Pitch_imu.append(float(values[57]))
            Roll_imu.append(float(values[58]))
            Pos_Qual.append(float(values[59]))
            Lng_Jerk.append(float(values[60]))
            Lat_Jerk.append(float(values[61]))
            Head_imu2.append(float(values[62]))

    return [sats, time, lat, long, velocity, heading, height, vert_vel, Longacc, Latacc, Glonass_Sats, GPS_Sats, IMU_Kalman_Filter_Status, Solution_Type, Velocity_Quality, event_1, _lat, _long, _velocity, _heading, _height, _vert_vel, KF_WheelSpeed_Left, KF_WheelSpeed_Right, RMS_hpos, RMS_vpos, RMS_HVELVal, RMS_VVELVal, POSCov_xx, POSCov_yy, POSCov_zz, VELCov_xx, VELCov_yy, VELCov_zz, T1Val, True_Head, Slip_Angle, Pitch_Ang, Lat_Vel, Yaw_Rate, Roll_Angle, Lng_Vel, Slip_COG, Slip_FL, Slip_FR, Slip_RL, Slip_RR, SlipHead, RobotHead, YawRate, X_Accel, Y_Accel, Temp, PitchRate, RollRate, Z_Accel, Head_imu, Pitch_imu, Roll_imu, Pos_Qual, Lng_Jerk, Lat_Jerk, Head_imu2]

def driverIDPlot(vboxData):
    #VBOX3i
    vboxTime = vboxData[1]
    vboxSat = vboxData[0]
    vboxLat = vboxData[2]
    vboxLong = vboxData[3]
    vboxVelocity = vboxData[4]
    vboxHeading = vboxData[5]
    vboxIMUHeading = vboxData[16]
    vboxIMUPitch = vboxData[17]
    vboxIMURoll = vboxData[18]

    # Create a subplot layout
    # Create a subplot layout with titles
    fig = make_subplots(
        rows=8, 
        cols=1, 
        shared_xaxes=False, 
        vertical_spacing=0.02,
        subplot_titles=(
            'Velocity (VBOX3i)', 
            'Longitude (VBOX3i)',
            'Latitude (VBOX3i)', 
            'Heading (VBOX3i antenna)', 
            'Number of Sats (VBOX3i)', 
            'IMU Heading (VBOX3i)',
            'IMU Pitch (VBOX3i)',
            'IMU Roll (VBOX3i)',
        )
    )

    # Add J1939 CAN Data
    fig.add_trace(go.Scatter(x=vboxTime, y=vboxVelocity), row=1, col=1)

    # Add Arduino GPS Data
    fig.add_trace(go.Scatter(x=vboxTime, y=vboxLong), row=2, col=1)
    fig.add_trace(go.Scatter(x=vboxTime, y=vboxLat), row=3, col=1)
    fig.add_trace(go.Scatter(x=vboxTime, y=vboxHeading), row=4, col=1)

    # Add VBOX3i Data
    fig.add_trace(go.Scatter(x=vboxTime, y=vboxSat), row=5, col=1)
    fig.add_trace(go.Scatter(x=vboxTime, y=vboxIMUHeading), row=6, col=1)
    fig.add_trace(go.Scatter(x=vboxTime, y=vboxIMUPitch), row=7, col=1)
    fig.add_trace(go.Scatter(x=vboxTime, y=vboxIMURoll), row=8, col=1)


    # Update layout
    fig.update_layout(height=4000, title_text="DriverID Data Visualization", showlegend=False)

    
    fig.show()

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
    timestamps = [((initial_time + datetime.timedelta(seconds=i/sample_rate)).timestamp() - initial_time.timestamp())/60 for i in range(len(data_values))]
    #print(timestamps)
    return data_values, timestamps

# Function to parse IBI CSV file
def parse_ibi(file_path):
    # Read the CSV file, skipping the first row
    data = pd.read_csv(file_path, skiprows=1, header=None, names=['Relative Time (s)', 'Duration (s)'])
    
    # Convert data to lists
    data_values = data['Duration (s)'].astype(float).tolist()
    timestamps = (data['Relative Time (s)'].astype(float)/60).tolist()
    
    #print(timestamps)

    return data_values, timestamps

def main():
    # Get User Input
    canFile = ""
    jsonFile = ""
    vboxFile = ""
    EDAFile = ""
    HRFile = ""
    IBIFile = ""
    for i, arg in enumerate(sys.argv):
        #if(i == 1):
        #    canFile = arg
        #elif(i == 2):
        #    jsonFile = arg
        if(i == 1):
            vboxFile = arg
        #elif(i == 4):
        #    EDAFile = arg
        #elif(i == 5):
        #    HRFile = arg
        #elif(i == 6):
        #    IBIFile = arg

    # File paths
    #eda_file_path = EDAFile
    #hr_file_path = HRFile
    #ibi_file_path = IBIFile

    # Parse the data
    #eda_data_values, eda_timestamps = parse_eda_hr(eda_file_path)
    #hr_data_values, hr_timestamps = parse_eda_hr(hr_file_path)
    #ibi_data_values, ibi_timestamps = parse_ibi(ibi_file_path)

    #print('Heart Rate Data Parsed')

    # Decode candump log File
    #decodedData = CANDataSPNDecode(canFile, jsonFile)
    #print("can data decoded")

    # Decode CAN GPS Data
    #with open(canFile) as f:
    #    can_msgs = f.readlines()
    #canData = get_data(can_msgs)
    #print("GPS data decoded")
    #kml_file_name = canFile[:-4] + ".kml"
    #create_kml_fileGPS(kml_file_name, canData[0], canData[1])
    #print("Arduino GPS kml File Successfully Created")

    # Decode VBOX Data
    vboxData = decodeVBOX(vboxFile)
    print("VBOX data decoded")
    print("VBOX kml File Successfully Created")
    
    kml_file_name = vboxFile[:-4] + "VBOX.kml"
    create_kml_fileVBOX(kml_file_name, vboxData[3], vboxData[2])

    driverIDPlot(vboxData)

if __name__ == "__main__":
    main()