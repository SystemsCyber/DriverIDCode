import sqlite3

# Function to create KML file with GPS coordinates
def create_kml_fileGPS(filename, longitude_list, latitude_list):
    filtered_latitude = []
    filtered_longitude = []
    for i in range(0, len(longitude_list), 50):
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

# Function to generate KML file for large data
def create_kml_fileVBOX(filename, longitude_list, latitude_list):
    filtered_latitude = []
    filtered_longitude = []
    for i in range(0, len(longitude_list), 500):
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

# Function to fetch coordinates from the SQLite database
def fetch_coordinates_from_db(db_filename):
    conn = sqlite3.connect(db_filename)
    cursor = conn.cursor()
    
    cursor.execute("SELECT longitude, latitude FROM SparkfunGPSData")
    rows = cursor.fetchall()
    
    longitude_list = [row[0] for row in rows]
    latitude_list = [row[1] for row in rows]
    
    conn.close()
    return longitude_list, latitude_list

# Main function
def generate_kml_from_db(db_filename, kml_filename, use_vbox_style=False):
    longitude_list, latitude_list = fetch_coordinates_from_db(db_filename)
    
    if use_vbox_style:
        create_kml_fileVBOX(kml_filename, longitude_list, latitude_list)
    else:
        create_kml_fileGPS(kml_filename, longitude_list, latitude_list)
    
# Example usage:
db_filename = 'DriverIDS1G1.sqlite'
kml_filename = 'DriverIDS1G1TruckCape.kml'
generate_kml_from_db(db_filename, kml_filename)
