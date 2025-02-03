import struct
import sys
import os

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


def main():
    # Get User Input
    canFile = ""

    for i, arg in enumerate(sys.argv):
        if(i == 1):
            canFile = arg
    
    candumpFormat = convert_bin_to_candump(canFile)
    #for i in candumpFormat:
    #    print(i)

    # Write candumpFormat to a file
    output_file = "candump_output.txt"
    with open(output_file, 'w') as f:
        for line in candumpFormat:
            f.write(f"{line}\n")


if __name__ == "__main__":
    main()