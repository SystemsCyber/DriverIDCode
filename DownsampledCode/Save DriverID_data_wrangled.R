# Save DriverID data as one big .csv 

# Set working directory
setwd("/Volumes/Extreme SSD/ORNLDriverIDsCSVFormat")

# Read in qualtrics survey data 
qualtrics_survey_data <- read.csv("Qualtrics_Survey_data.csv")



# Read each CSV file and assign to a variable named after the file
G1_Subject1 <- read.csv("G1_Subject1_cyberattack.csv")
G1_Subject2 <- read.csv("G1_Subject2_cyberattack.csv")
G1_Subject3 <- read.csv("G1_Subject3_cyberattack.csv")
G1_Subject4 <- read.csv("G1_Subject4_cyberattack.csv")
G1_Subject5 <- read.csv("G1_Subject5_cyberattack.csv")
G1_Subject6 <- read.csv("G1_Subject6_cyberattack.csv")
G1_Subject7 <- read.csv("G1_Subject7_cyberattack.csv")
G1_Subject8 <- read.csv("G1_Subject8_cyberattack.csv")
G1_Subject9 <- read.csv("G1_Subject9_cyberattack.csv")
G1_Subject10 <- read.csv("G1_Subject10_cyberattack.csv")
G1_Subject11 <- read.csv("G1_Subject11_cyberattack.csv")
G1_Subject12 <- read.csv("G1_Subject12_cyberattack.csv")
G1_Subject13 <- read.csv("G1_Subject13_cyberattack.csv")
G1_Subject14 <- read.csv("G1_Subject14_cyberattack.csv")
G1_Subject15 <- read.csv("G1_Subject15_cyberattack.csv")
G1_Subject16 <- read.csv("G1_Subject16_cyberattack.csv")
G1_Subject17 <- read.csv("G1_Subject17_cyberattack.csv")

G2_Subject1 <- read.csv("G2_Subject1_cyberattack.csv")
G2_Subject2 <- read.csv("G2_Subject2_cyberattack.csv")
G2_Subject3 <- read.csv("G2_Subject3_cyberattack.csv")
G2_Subject4 <- read.csv("G2_Subject4_cyberattack.csv")
G2_Subject5 <- read.csv("G2_Subject5_cyberattack.csv")
G2_Subject6 <- read.csv("G2_Subject6_cyberattack.csv")
G2_Subject7 <- read.csv("G2_Subject7_cyberattack.csv")
G2_Subject8 <- read.csv("G2_Subject8_cyberattack.csv")
G2_Subject9 <- read.csv("G2_Subject9_cyberattack.csv")
G2_Subject10 <- read.csv("G2_Subject10_cyberattack.csv")
G2_Subject11 <- read.csv("G2_Subject11_cyberattack.csv")
G2_Subject12 <- read.csv("G2_Subject12_cyberattack.csv")
G2_Subject13 <- read.csv("G2_Subject13_cyberattack.csv")
G2_Subject14 <- read.csv("G2_Subject14_cyberattack.csv")
G2_Subject15 <- read.csv("G2_Subject15_cyberattack.csv")
G2_Subject16 <- read.csv("G2_Subject16_cyberattack.csv")

G3_Subject1 <- read.csv("G3_Subject1_cyberattack.csv")
G3_Subject2 <- read.csv("G3_Subject2_cyberattack.csv")
G3_Subject3 <- read.csv("G3_Subject3_cyberattack.csv")
G3_Subject4 <- read.csv("G3_Subject4_cyberattack.csv")
G3_Subject5 <- read.csv("G3_Subject5_cyberattack.csv")
G3_Subject6 <- read.csv("G3_Subject6_cyberattack.csv")
G3_Subject7 <- read.csv("G3_Subject7_cyberattack.csv")
G3_Subject8 <- read.csv("G3_Subject8_cyberattack.csv")
G3_Subject9 <- read.csv("G3_Subject9_cyberattack.csv")
G3_Subject10 <- read.csv("G3_Subject10_cyberattack.csv")
G3_Subject11 <- read.csv("G3_Subject11_cyberattack.csv")
G3_Subject12 <- read.csv("G3_Subject12_cyberattack.csv")
G3_Subject13 <- read.csv("G3_Subject13_cyberattack.csv")
G3_Subject14 <- read.csv("G3_Subject14_cyberattack.csv")
G3_Subject15 <- read.csv("G3_Subject15_cyberattack.csv")
G3_Subject16 <- read.csv("G3_Subject16_cyberattack.csv")
G3_Subject17 <- read.csv("G3_Subject17_cyberattack.csv")

# Add timestamps to the first four rows of Time in G1_Subject10 and ensure character format for display
G1_Subject10$Time[1:4] <- format(as.POSIXct(
  c("2024-06-07 10:42:39", "2024-06-07 10:42:40", 
    "2024-06-07 10:42:41", "2024-06-07 10:42:42"), 
  format = "%Y-%m-%d %H:%M:%S", tz = "UTC"), "%Y-%m-%d %H:%M:%S")

# Add timestamps to the first five rows of Time in G1_Subject11 and ensure character format for display
G1_Subject11$Time[1:5] <- format(as.POSIXct(
  c("2024-06-07 14:16:58", "2024-06-07 14:16:59", 
    "2024-06-07 14:17:00", "2024-06-07 14:17:01", 
    "2024-06-07 14:17:02"), 
  format = "%Y-%m-%d %H:%M:%S", tz = "UTC"), "%Y-%m-%d %H:%M:%S")

# Add timestamps to the first two rows of Time in G1_Subject12 and ensure character format for display
G1_Subject12$Time[1:2] <- format(as.POSIXct(
  c("2024-06-08 14:28:19", "2024-06-08 14:28:20"), 
  format = "%Y-%m-%d %H:%M:%S", tz = "UTC"), "%Y-%m-%d %H:%M:%S")


# List of all data frames
file_names <- list(
  G1_Subject1 = G1_Subject1, G1_Subject2 = G1_Subject2, G1_Subject3 = G1_Subject3, 
  G1_Subject4 = G1_Subject4, G1_Subject5 = G1_Subject5, G1_Subject6 = G1_Subject6, 
  G1_Subject7 = G1_Subject7, G1_Subject8 = G1_Subject8, G1_Subject9 = G1_Subject9, 
  G1_Subject10 = G1_Subject10, G1_Subject11 = G1_Subject11, G1_Subject12 = G1_Subject12, 
  G1_Subject13 = G1_Subject13, G1_Subject14 = G1_Subject14, G1_Subject15 = G1_Subject15, 
  G1_Subject16 = G1_Subject16, G1_Subject17 = G1_Subject17, 
  G2_Subject1 = G2_Subject1, G2_Subject2 = G2_Subject2, G2_Subject3 = G2_Subject3, 
  G2_Subject4 = G2_Subject4, G2_Subject5 = G2_Subject5, G2_Subject6 = G2_Subject6, 
  G2_Subject7 = G2_Subject7, G2_Subject8 = G2_Subject8, G2_Subject9 = G2_Subject9, 
  G2_Subject10 = G2_Subject10, G2_Subject11 = G2_Subject11, G2_Subject12 = G2_Subject12, 
  G2_Subject13 = G2_Subject13, G2_Subject14 = G2_Subject14, G2_Subject15 = G2_Subject15, 
  G2_Subject16 = G2_Subject16, 
  G3_Subject1 = G3_Subject1, G3_Subject2 = G3_Subject2, G3_Subject3 = G3_Subject3, 
  G3_Subject4 = G3_Subject4, G3_Subject5 = G3_Subject5, G3_Subject6 = G3_Subject6, 
  G3_Subject7 = G3_Subject7, G3_Subject8 = G3_Subject8, G3_Subject9 = G3_Subject9, 
  G3_Subject10 = G3_Subject10, G3_Subject11 = G3_Subject11, G3_Subject12 = G3_Subject12, 
  G3_Subject13 = G3_Subject13, G3_Subject14 = G3_Subject14, G3_Subject15 = G3_Subject15, 
  G3_Subject16 = G3_Subject16, G3_Subject17 = G3_Subject17
)

processed_data <- lapply(names(file_names), function(name) {
  df <- file_names[[name]]
  
  df %>%
    # Remove rows where Time is NA and where Time is before 2024
    filter(!is.na(Time) & as.POSIXct(Time, format = "%Y-%m-%d %H:%M:%S") >= as.POSIXct("2024-01-01 00:00:00")) %>%
    # Set ID to the filename
    mutate(ID = name) %>%
    # Capture the original first Time before arranging
    mutate(original_first_time = as.POSIXct(Time[1], format = "%Y-%m-%d %H:%M:%S")) %>%
    # Arrange by Time
    arrange(as.POSIXct(Time, format = "%Y-%m-%d %H:%M:%S")) %>%
    # Update interval_1s based on time difference from the original first Time
    mutate(interval_1s = as.numeric(difftime(as.POSIXct(Time, format = "%Y-%m-%d %H:%M:%S"), 
                                             original_first_time, 
                                             units = "secs"))) %>%
    # Remove the helper column
    select(-original_first_time) %>%
    # Relocate the specified columns to positions 7 to 18
    relocate(mean.EDA, sd.EDA, min.EDA, max.EDA, 
             mean.HR, sd.HR, min.HR, max.HR, 
             mean.IBI, sd.IBI, min.IBI, max.IBI, .before = 7)
})

# Combine all processed data frames into a single data frame
DriverID_data_wrangled <- bind_rows(processed_data)



# Haversine formula to determine distance on sphere with latitude and longitude
haversine_meters <- function(lat1, lon1, lat2, lon2) {
  R <- 6371000  # Earth radius in meters
  delta_lat <- (lat2 - lat1) * pi / 180
  delta_lon <- (lon2 - lon1) * pi / 180
  a <- sin(delta_lat / 2) * sin(delta_lat / 2) +
    cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
    sin(delta_lon / 2) * sin(delta_lon / 2)
  c <- 2 * atan2(sqrt(a), sqrt(1 - a))
  R * c  # Distance in meters
}

# Calculate distance based on latitude and longitude in meters
DriverID_data_wrangled <- DriverID_data_wrangled %>%
  arrange(ID, interval_1s) %>%  # Ensure data is sorted by ID and time interval
  group_by(ID) %>%  # Group by ID to calculate distance for each driver
  mutate(
    distance_meters = haversine_meters(lag(mean.latitude, default = first(mean.latitude)),
                                       lag(mean.longitude, default = first(mean.longitude)),
                                       mean.latitude, mean.longitude),
    distance_meters = replace_na(distance_meters, 0),  # Replace NA values with 0
    cumulative_distance_meters = cumsum(distance_meters)) %>%  # Calculate cumulative distance in meters
  ungroup()  # Ungroup to return to original data structure


# Reorganize the data
DriverID_data_wrangled <- DriverID_data_wrangled %>%
  select(ID, Group, Subject, Time, interval_1s, cyberattack_active, cumulative_distance_meters, everything())

# Count total number of subjects for each group
subject_count_by_group <- DriverID_data_wrangled %>%
  group_by(Group) %>%
  summarize(total_subjects = n_distinct(Subject)) %>%
  ungroup()

# Display the count of subjects for each group
print(subject_count_by_group)





# Sanity check using cumulative distance 
total_cumulative_distance <- DriverID_data_wrangled %>%
  group_by(Group, Subject) %>%
  summarize(total_cumulative_distance_meters = max(cumulative_distance_meters, na.rm = TRUE)) %>%
  ungroup()

# Display the total cumulative distance for each subject
print(total_cumulative_distance)

# Calculate summary statistics for total cumulative distance
distance_summary <- total_cumulative_distance %>%
  summarize(
    count = n(),
    mean_distance_meters = mean(total_cumulative_distance_meters, na.rm = TRUE),
    median_distance_meters = median(total_cumulative_distance_meters, na.rm = TRUE),
    sd_distance_meters = sd(total_cumulative_distance_meters, na.rm = TRUE),
    max_distance_meters = max(total_cumulative_distance_meters, na.rm = TRUE),
    min_distance_meters = min(total_cumulative_distance_meters, na.rm = TRUE),
    range_distance_meters = max(total_cumulative_distance_meters, na.rm = TRUE) - min(total_cumulative_distance_meters, na.rm = TRUE),
    q1_distance_meters = quantile(total_cumulative_distance_meters, 0.25, na.rm = TRUE),
    q3_distance_meters = quantile(total_cumulative_distance_meters, 0.75, na.rm = TRUE),
    iqr_distance_meters = IQR(total_cumulative_distance_meters, na.rm = TRUE)
  )

# Display the summary statistics
print(distance_summary)

# Combine qualtrics data 
# Merge the survey data with the driving data
combined_data <- DriverID_data_wrangled %>%
  left_join(qualtrics_survey_data, by = c("Group", "Subject", "interval_1s"))

# Create the date_comparison dataframe
date_comparison <- combined_data %>%
  select(Group, Subject, interval_1s, Time, RecordedDate) %>%
  filter(interval_1s == 0)

# Remove some columns that are unnnessary
combined_data <- combined_data %>%
  select(-c(distance_meters,))

# Rename some columns 
combined_data <- combined_data %>%
  rename(Participant.Number = Ss..Participant.Number..to.be.filled.out.by.researcher..) %>%
  rename(Gender = gender..What.is.your.gender.) %>%
  rename(Age = age..What.is.your.age..in.years..)

id_order <- c(
  "G1_Subject1", "G1_Subject2", "G1_Subject3", "G1_Subject4", "G1_Subject5", 
  "G1_Subject6", "G1_Subject7", "G1_Subject8", "G1_Subject9", "G1_Subject10", 
  "G1_Subject11", "G1_Subject12", "G1_Subject13", "G1_Subject14", "G1_Subject15", 
  "G1_Subject16", "G1_Subject17", 
  "G2_Subject1", "G2_Subject2", "G2_Subject3", "G2_Subject4", "G2_Subject5", 
  "G2_Subject6", "G2_Subject7", "G2_Subject8", "G2_Subject9", "G2_Subject10", 
  "G2_Subject11", "G2_Subject12", "G2_Subject13", "G2_Subject14", "G2_Subject15", 
  "G2_Subject16", 
  "G3_Subject1", "G3_Subject2", "G3_Subject3", "G3_Subject4", "G3_Subject5", 
  "G3_Subject6", "G3_Subject7", "G3_Subject8", "G3_Subject9", "G3_Subject10", 
  "G3_Subject11", "G3_Subject12", "G3_Subject13", "G3_Subject14", "G3_Subject15", 
  "G3_Subject16", "G3_Subject17"
)

combined_data <- combined_data %>%
  mutate(ID = factor(ID, levels = id_order)) %>%  # Set ID as a factor with specified levels
  arrange(ID)  # Arrange by the ordered ID

combined_data <- combined_data %>%
  slice(-c(34241, 34243))

# Save the combined data frame as a CSV file
write.csv(combined_data, "DriverID_data_wrangled.csv", row.names = FALSE)

