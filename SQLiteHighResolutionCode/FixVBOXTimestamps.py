import sqlite3
import pandas as pd
import numpy as np
import os

def calculate_correlation(spn_data, vbox_data, adjusted_vbox_time, shift_range):
    print("Finding Correlation")

    # Ensure VBOXData is not empty
    if vbox_data.empty:
        print("Skipping file: VBOXData is empty")
        return None, None, None

    # Drop NaN values in VBOXData speeds
    vbox_data = vbox_data.dropna(subset=["velocity_kmh"])

    # Ensure adjusted_vbox_time has the same length as vbox_data
    adjusted_vbox_time = adjusted_vbox_time[:len(vbox_data)]

    # Generate a common time grid from SPNData and VBOXData
    spn_time_grid = np.arange(spn_data["Time84"].min(), spn_data["Time84"].max(), 0.01)
    vbox_time_grid = np.arange(adjusted_vbox_time.min(), adjusted_vbox_time.max(), 0.01)
    common_time_grid = np.arange(max(spn_time_grid.min(), vbox_time_grid.min()),
                                 min(spn_time_grid.max(), vbox_time_grid.max()),
                                 0.01)

    # Interpolate SPNData onto the common grid
    spn_interp = np.interp(common_time_grid, spn_data["Time84"], spn_data["84 Wheel-Based Vehicle Speed"])

    # Normalize SPNData speeds
    spn_interp = (spn_interp - np.mean(spn_interp)) / np.std(spn_interp)

    # Initialize variables to track the best correlation
    max_correlation = float("-inf")
    best_shift = None
    best_vbox_time = None

    for shift in shift_range:
        # Apply shift to adjusted VBOX timestamps
        shifted_time = adjusted_vbox_time + shift

        # Ensure shifted_time and vbox_data["velocity_kmh"] have the same length
        min_length = min(len(shifted_time), len(vbox_data["velocity_kmh"]))
        shifted_time = shifted_time[:min_length]
        vbox_speeds = vbox_data["velocity_kmh"].iloc[:min_length]

        # Interpolate the shifted VBOXData speeds onto the common grid
        vbox_interp = np.interp(common_time_grid, shifted_time, vbox_speeds)

        # Normalize VBOXData speeds
        vbox_interp = (vbox_interp - np.mean(vbox_interp)) / np.std(vbox_interp)

        # Calculate correlation for the speeds only (timestamps are not part of this calculation)
        correlation = np.corrcoef(spn_interp, vbox_interp)[0, 1]

        # Track the maximum correlation
        if correlation > max_correlation:
            max_correlation = correlation
            best_shift = shift
            best_vbox_time = shifted_time

    # Round the best shift to two decimal places
    rounded_best_shift = round(best_shift, 2)

    print(f"Max correlation found: {max_correlation} at shift: {rounded_best_shift} seconds")
    return max_correlation, rounded_best_shift, best_vbox_time

def validate_time_increments(final_shifted_time, increment=0.01):
    # Calculate the differences between consecutive timestamps
    differences = np.diff(final_shifted_time)
    
    # Check if all differences are equal to the expected increment
    if not np.allclose(differences, increment, atol=1e-6):
        # If not, generate a new array with the correct increments
        final_shifted_time = np.linspace(final_shifted_time[0], 
                                         final_shifted_time[0] + (len(final_shifted_time) - 1) * increment, 
                                         len(final_shifted_time))
    
    return final_shifted_time

def process_sqlite_file(file_path):

    print(f"Processing file: {file_path}")

    # Connect to the SQLite database
    conn = sqlite3.connect(file_path)

    # Read SPNData and VBOXData tables into DataFrames
    spn_data = pd.read_sql_query("SELECT * FROM SPNData", conn)
    vbox_data = pd.read_sql_query("SELECT * FROM VBOXData", conn)

    print(len(vbox_data))

    # Ensure there is valid data
    if spn_data.empty or vbox_data.empty:
        print(f"Skipping {file_path}: Missing SPNData or VBOXData")
        conn.close()
        return

    # Adjust VBOX timestamps
    first_spn_timestamp = spn_data["Time84"].iloc[0]
    adjusted_vbox_time = np.arange(
        first_spn_timestamp,  # Start at the first SPNData timestamp
        first_spn_timestamp + len(vbox_data) * 0.01,
        0.01
    )

    # Round adjusted VBOX timestamps to two decimal places
    adjusted_vbox_time = np.round(adjusted_vbox_time, 2)

    # Generate shift range (-100 to 100 seconds)
    shift_range = np.arange(-100, 100, 0.01)

    # Calculate the best correlation
    max_correlation, rounded_best_shift, best_vbox_time = calculate_correlation(
        spn_data, vbox_data, adjusted_vbox_time, shift_range
    )

    # If no correlation was found, skip this file
    if max_correlation is None:
        print(f"Skipping file {file_path} due to calculation errors.\n")
        conn.close()
        return

    # Update the VBOXData timestamps with the rounded best shift
    final_shifted_time = adjusted_vbox_time + rounded_best_shift

    # **Fix: Ensure final_shifted_time has the same length as vbox_data**
    final_shifted_time = final_shifted_time[:len(vbox_data)]
    print(len(final_shifted_time))
    # Validate time increments
    final_shifted_time = validate_time_increments(final_shifted_time)
    print(len(final_shifted_time))



    # Replace the time column in VBOXData
    vbox_data["time"] = final_shifted_time

    # Save the updated VBOXData table back to the SQLite file
    vbox_data.to_sql("VBOXData", conn, if_exists="replace", index=False)

    print(f"Updated timestamps in: {file_path}\n")

    # Close the connection
    conn.close()




def process_all_files(base_path, groups):
    for group, count in groups.items():
        for i in range(14, count + 1):
            folder_suffix = f"S{i:02d}"  # Folder uses S01, S02, etc.
            file_suffix = f"S{i}{group}"  # File uses S1, S2, etc.
            folder_path = os.path.join(base_path, f"ORNLDriverID{group}{folder_suffix}")
            file_path = os.path.join(folder_path, f"DriverID{file_suffix}.sqlite")
            
            if os.path.exists(file_path):
                process_sqlite_file(file_path)
            else:
                print(f"File not found: {file_path}\n")

if __name__ == "__main__":
    base_directory = "/Volumes/Extreme SSD/ORNLDriverIDs/"
    group_counts = {"G2": 16}  # Number of files in each group
    process_all_files(base_directory, group_counts)
