# VBOXToSQLite
# Author: Tyler Biggs
#
# Purpose/Uses: 
# The purpose of this script is to decode a VBOX file and store the data into a sqlite database
#
# How to Use:
# python3 VBOXToSQLite.py <Path to VBOX file>
# Example: python3 VBOXToSQLite.py ~/Desktop/InputFiles/vboxData.VBO

import sys
import sqlite3

#Decode VBOX Data
def decodeVBOX(file):
    with open(file, 'r', encoding='ISO-8859-1') as f:
        content = f.readlines()

    # Check if we are in the [data] section of the file
    in_data_section = False

    # List to hold extracted values
    satellites = []
    time = []
    lat = []
    long = []
    velocity_kmh = []
    heading = []
    height = []
    vertical_velocity_kmh = []
    glonass_sats = []
    gps_sats = []
    solution_type = []
    velocity_quality_kmh = []
    event_1_time = []
    Long_accel = []
    Lat_accel = []
    IMU_Kalman_Filter_Status = []
    Head_imu = []
    Pitch_imu = []
    Roll_imu = []
    Pos_Qual = []
    Lng_Jerk = []
    Lat_Jerk = []
    Head_imu2 = []
    YawRate = []
    X_Accel = []
    Y_Accel = []
    Temp = []
    PitchRate = []
    RollRate = []
    Z_Accel = []
    DualStatus = []
    True_Head = []
    Lat_Vel = []
    Lng_Vel = []
    RobotHead = []
    SlipHead = []
    Pitch_Ang = []
    Roll_Angle = []
    Yaw_Rate = []
    Slip_Angle = []
    T1 = []
    RMS_HPOS = []
    RMS_VPOS = []
    RMS_HVEL = []
    RMS_VVEL = []
    POSCov_xx = []
    POSCov_xy = []
    POSCov_xz = []
    POSCov_yy = []
    POSCov_yz = []
    POSCov_zz = []
    VELCov_xx = []
    VELCov_xy = []
    VELCov_xz = []
    VELCov_yy = []
    VELCov_yz = []
    VELCov_zz = []
    ms = []
    ns = []
    latency = []
    bias = []
    ADC_CH1 = []
    ADC_CH2 = []
    ADC_CH3 = []
    ADC_CH4 = []
    PreKF_Latitude = []
    PreKF_Longitude = []
    PreKF_Alt = []
    PreKF_Velocity = []
    PreKF_Heading = []
    PreKF_VertSpd = []
    Pos_X = []
    Pos_Y = []
    Pos_Z = []
    Exported_Elapsed_time = []
    Exported_Distance = []
    Exported_Longitudinal_acceleration = []
    Exported_Lateral_acceleration = []
    Exported_Relative_height = []
    Exported_Radius_of_turn = []

    for line in content:
        line = line.strip()

        if line == '[data]':
            in_data_section = True
            continue
        elif line.startswith('['):  # any other section starts
            in_data_section = False

        if in_data_section:
            values = line.split()
            satellites.append(float(values[0]))
            time.append(float(values[1]))
            
            latitude = float(values[2][1:])/60
            longitude = (-1)*float(values[3][1:])/60

            lat.append(latitude)
            long.append(longitude)

            velocity_kmh.append(float(values[4]))
            heading.append(float(values[5]))
            height.append(float(values[6]))
            vertical_velocity_kmh.append(float(values[7]))
            glonass_sats.append(float(values[8]))
            gps_sats.append(float(values[9]))
            solution_type.append(float(values[10]))
            velocity_quality_kmh.append(float(values[11]))
            event_1_time.append(float(values[12]))
            Long_accel.append(float(values[13]))
            Lat_accel.append(float(values[14]))
            IMU_Kalman_Filter_Status.append(float(values[15]))
            Head_imu.append(float(values[16]))
            Pitch_imu.append(float(values[17]))
            Roll_imu.append(float(values[18]))
            Pos_Qual.append(float(values[19]))
            Lng_Jerk.append(float(values[20]))
            Lat_Jerk.append(float(values[21]))
            Head_imu2.append(float(values[22]))
            YawRate.append(float(values[23]))
            X_Accel.append(float(values[24]))
            Y_Accel.append(float(values[25]))
            Temp.append(float(values[26]))
            PitchRate.append(float(values[27]))
            RollRate.append(float(values[28]))
            Z_Accel.append(float(values[29]))
            DualStatus.append(float(values[30]))
            True_Head.append(float(values[31]))
            Lat_Vel.append(float(values[32]))
            Lng_Vel.append(float(values[33]))
            RobotHead.append(float(values[34]))
            SlipHead.append(float(values[35]))
            Pitch_Ang.append(float(values[36]))
            Roll_Angle.append(float(values[37]))
            Yaw_Rate.append(float(values[38]))
            Slip_Angle.append(float(values[39]))
            T1.append(float(values[40]))
            RMS_HPOS.append(float(values[41]))
            RMS_VPOS.append(float(values[42]))
            RMS_HVEL.append(float(values[43]))
            RMS_VVEL.append(float(values[44]))
            POSCov_xx.append(float(values[45]))
            POSCov_xy.append(float(values[46]))
            POSCov_xz.append(float(values[47]))
            POSCov_yy.append(float(values[48]))
            POSCov_yz.append(float(values[49]))
            POSCov_zz.append(float(values[50]))
            VELCov_xx.append(float(values[51]))
            VELCov_xy.append(float(values[52]))
            VELCov_xz.append(float(values[53]))
            VELCov_yy.append(float(values[54]))
            VELCov_yz.append(float(values[55]))
            VELCov_zz.append(float(values[56]))
            ms.append(float(values[57]))
            ns.append(float(values[58]))
            latency.append(float(values[59]))
            bias.append(float(values[60]))
            ADC_CH1.append(float(values[61]))
            ADC_CH2.append(float(values[62]))
            ADC_CH3.append(float(values[63]))
            ADC_CH4.append(float(values[64]))
            PreKF_Latitude.append(float(values[65]))
            PreKF_Longitude.append(float(values[66]))
            PreKF_Alt.append(float(values[67]))
            PreKF_Velocity.append(float(values[68]))
            PreKF_Heading.append(float(values[69]))
            PreKF_VertSpd.append(float(values[70]))
            Pos_X.append(float(values[71]))
            Pos_Y.append(float(values[72]))
            Pos_Z.append(float(values[73]))
            Exported_Elapsed_time.append(float(values[74]))
            Exported_Distance.append(float(values[75]))
            Exported_Longitudinal_acceleration.append(float(values[76]))
            Exported_Lateral_acceleration.append(float(values[77]))
            Exported_Relative_height.append(float(values[78]))
            Exported_Radius_of_turn.append(float(values[79]))

    return [satellites,
    time,
    lat,
    long,
    velocity_kmh,
    heading,
    height,
    vertical_velocity_kmh,
    glonass_sats,
    gps_sats,
    solution_type,
    velocity_quality_kmh,
    event_1_time,
    Long_accel,
    Lat_accel,
    IMU_Kalman_Filter_Status,
    Head_imu,
    Pitch_imu,
    Roll_imu,
    Pos_Qual,
    Lng_Jerk,
    Lat_Jerk,
    Head_imu2,
    YawRate,
    X_Accel,
    Y_Accel,
    Temp,
    PitchRate,
    RollRate,
    Z_Accel,
    DualStatus,
    True_Head,
    Lat_Vel,
    Lng_Vel,
    RobotHead,
    SlipHead,
    Pitch_Ang,
    Roll_Angle,
    Yaw_Rate,
    Slip_Angle,
    T1,
    RMS_HPOS,
    RMS_VPOS,
    RMS_HVEL,
    RMS_VVEL,
    POSCov_xx,
    POSCov_xy,
    POSCov_xz,
    POSCov_yy,
    POSCov_yz,
    POSCov_zz,
    VELCov_xx,
    VELCov_xy,
    VELCov_xz,
    VELCov_yy,
    VELCov_yz,
    VELCov_zz,
    ms,
    ns,
    latency,
    bias,
    ADC_CH1,
    ADC_CH2,
    ADC_CH3,
    ADC_CH4,
    PreKF_Latitude,
    PreKF_Longitude,
    PreKF_Alt,
    PreKF_Velocity,
    PreKF_Heading,
    PreKF_VertSpd,
    Pos_X,
    Pos_Y,
    Pos_Z,
    Exported_Elapsed_time,
    Exported_Distance,
    Exported_Longitudinal_acceleration,
    Exported_Lateral_acceleration,
    Exported_Relative_height,
    Exported_Radius_of_turn]

# Create sqlite Table
def create_table(file, canData, dataTitles):
    #print(file)
    connection = sqlite3.connect(file[:-13] + ".sqlite")
    cursor = connection.cursor()
    cursorString = '''CREATE TABLE IF NOT EXISTS VBOXData
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
    cursorString = '''INSERT INTO VBOXData ('''
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
    vboxFile = ""
    for i, arg in enumerate(sys.argv):
        if(i == 1):
            vboxFile = arg
    #print(vboxFile)
    # Decode VBOX Data
    vboxData = decodeVBOX(vboxFile)
    #print(len(vboxData))

    dataTitles= ['satellites',
    'time',
    'lat',
    'long',
    'velocity_kmh',
    'heading',
    'height',
    'vertical_velocity_kmh',
    'glonass_sats',
    'gps_sats',
    'solution_type',
    'velocity_quality_kmh',
    'event_1_time',
    'Long_accel',
    'Lat_accel',
    'IMU_Kalman_Filter_Status',
    'Head_imu',
    'Pitch_imu',
    'Roll_imu',
    'Pos_Qual',
    'Lng_Jerk',
    'Lat_Jerk',
    'Head_imu2',
    'YawRate',
    'X_Accel',
    'Y_Accel',
    'Temp',
    'PitchRate',
    'RollRate',
    'Z_Accel',
    'DualStatus',
    'True_Head',
    'Lat_Vel',
    'Lng_Vel',
    'RobotHead',
    'SlipHead',
    'Pitch_Ang',
    'Roll_Angle',
    'Yaw_Rate',
    'Slip_Angle',
    'T1',
    'RMS_HPOS',
    'RMS_VPOS',
    'RMS_HVEL',
    'RMS_VVEL',
    'POSCov_xx',
    'POSCov_xy',
    'POSCov_xz',
    'POSCov_yy',
    'POSCov_yz',
    'POSCov_zz',
    'VELCov_xx',
    'VELCov_xy',
    'VELCov_xz',
    'VELCov_yy',
    'VELCov_yz',
    'VELCov_zz',
    'ms',
    'ns',
    'latency',
    'bias',
    'ADC_CH1',
    'ADC_CH2',
    'ADC_CH3',
    'ADC_CH4',
    'PreKF_Latitude',
    'PreKF_Longitude',
    'PreKF_Alt',
    'PreKF_Velocity',
    'PreKF_Heading',
    'PreKF_VertSpd',
    'Pos_X',
    'Pos_Y',
    'Pos_Z',
    'Exported_Elapsed_time',
    'Exported_Distance',
    'Exported_Longitudinal_acceleration',
    'Exported_Lateral_acceleration',
    'Exported_Relative_height',
    'Exported_Radius_of_turn']
    #print(len(dataTitles))

    file = '/Volumes/Extreme SSD/ORNLDriverIDs/ORNLDriverIDG3S13/DriverIDS13G3TruckCape.log'
    create_table(file, vboxFile, dataTitles)

    placement = 0
    while(1 > 0):
        dataPoint = []
        matchedDataTitles = []

        for i in range(len(vboxData)):
            if(placement < len(vboxData[i])):
                data = vboxData[i][placement]
                dataPoint.append(data)
                matchedDataTitles.append(dataTitles[i])

        if(len(dataPoint) == 0):
            break

        insert_Data(file, vboxData, dataPoint, matchedDataTitles)
        placement = placement + 1

if __name__ == "__main__":
    main()