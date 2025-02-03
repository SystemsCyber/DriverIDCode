##### DriverID cyberattack data wrangling


# Install necessary packages
# install.packages('tidyverse')
# install.packages('readxl')
# install.packages('lubridate')
# install.packages("ggplot2")
# install.packages("maps")
# install.packages("ggmap")


# Load necessary libraries
library(tidyverse)
library(readxl)
library(lubridate)
library(ggplot2)
library(maps)
library(ggmap)

# Set working directory
setwd("/Volumes/Extreme SSD/ORNLDriverIDsCSVFormat")



# Read each CSV file and assign to a variable named after the file
G1_Subject1 <- read.csv("G1_Subject1_test2.csv")
G1_Subject2 <- read.csv("G1_Subject2_test2.csv")
G1_Subject3 <- read.csv("G1_Subject3_test2.csv")
G1_Subject4 <- read.csv("G1_Subject4_test2.csv")
G1_Subject5 <- read.csv("G1_Subject5_test2.csv")
G1_Subject6 <- read.csv("G1_Subject6_test2.csv")
G1_Subject7 <- read.csv("G1_Subject7_test2.csv")
G1_Subject8 <- read.csv("G1_Subject8_test2.csv")
G1_Subject9 <- read.csv("G1_Subject9_test2.csv")
G1_Subject10 <- read.csv("G1_Subject10_test2.csv")
G1_Subject11 <- read.csv("G1_Subject11_test2.csv")
G1_Subject12 <- read.csv("G1_Subject12_test2.csv")
G1_Subject13 <- read.csv("G1_Subject13_test2.csv")
G1_Subject14 <- read.csv("G1_Subject14_test2.csv")
G1_Subject15 <- read.csv("G1_Subject15_test2.csv")
G1_Subject16 <- read.csv("G1_Subject16_test2.csv")
G1_Subject17 <- read.csv("G1_Subject17_test2.csv")

G2_Subject1 <- read.csv("G2_Subject1_test2.csv")
G2_Subject2 <- read.csv("G2_Subject2_test2.csv")
G2_Subject3 <- read.csv("G2_Subject3_test2.csv")
G2_Subject4 <- read.csv("G2_Subject4_test2.csv")
G2_Subject5 <- read.csv("G2_Subject5_test2.csv")
G2_Subject6 <- read.csv("G2_Subject6_test2.csv")
G2_Subject7 <- read.csv("G2_Subject7_test2.csv")
G2_Subject8 <- read.csv("G2_Subject8_test2.csv")
G2_Subject9 <- read.csv("G2_Subject9_test2.csv")
G2_Subject10 <- read.csv("G2_Subject10_test2.csv")
G2_Subject11 <- read.csv("G2_Subject11_test2.csv")
G2_Subject12 <- read.csv("G2_Subject12_test2.csv")
G2_Subject13 <- read.csv("G2_Subject13_test2.csv")
G2_Subject14 <- read.csv("G2_Subject14_test2.csv")
G2_Subject15 <- read.csv("G2_Subject15_test2.csv")
G2_Subject16 <- read.csv("G2_Subject16_test2.csv")

G3_Subject1 <- read.csv("G3_Subject1_test2.csv")
G3_Subject2 <- read.csv("G3_Subject2_test2.csv")
G3_Subject3 <- read.csv("G3_Subject3_test2.csv")
G3_Subject4 <- read.csv("G3_Subject4_test2.csv")
G3_Subject5 <- read.csv("G3_Subject5_test2.csv")
G3_Subject6 <- read.csv("G3_Subject6_test2.csv")
G3_Subject7 <- read.csv("G3_Subject7_test2.csv")
G3_Subject8 <- read.csv("G3_Subject8_test2.csv")
G3_Subject9 <- read.csv("G3_Subject9_test2.csv")
G3_Subject10 <- read.csv("G3_Subject10_test2.csv")
G3_Subject11 <- read.csv("G3_Subject11_test2.csv")
G3_Subject12 <- read.csv("G3_Subject12_test2.csv")
G3_Subject13 <- read.csv("G3_Subject13_test2.csv")
G3_Subject14 <- read.csv("G3_Subject14_test2.csv")
G3_Subject15 <- read.csv("G3_Subject15_test2.csv")
G3_Subject16 <- read.csv("G3_Subject16_test2.csv")
G3_Subject17 <- read.csv("G3_Subject17_test2.csv")

# ADD cyberattack_active column for drives without CAN0
# Group 1 Subjects 1-12, Group 2 Subject 1
# List of dataframes to process
dataframes <- list(#G1_Subject1, G1_Subject2, G1_Subject3, G1_Subject4, G1_Subject5, 
                   #G1_Subject6, G1_Subject7, G1_Subject8, G1_Subject9, 
                   G1_Subject10, G1_Subject11, G1_Subject12)
                   #G2_Subject1)

# Loop through each dataframe
for (Group_Subject in dataframes) {

# Define the longitude range and specific start point for Group 1 subjects 1 to 12
long_intersection_Laporte_Overland <- -105.133813 
geo_start_point <- -105.1384
# sign is at -105.1384
cyberattack_duration <- 60  # maximum in seconds

#Group_Subject <- G1_Subject12

############
# Find the interval_1s where Group 1 Subject 1 first reaches long_intersection_Laporte_Overland
Overland_interval <- Group_Subject %>%
  filter(mean.longitude <= long_intersection_Laporte_Overland) %>%
  summarise(min_interval = min(interval_1s, na.rm = TRUE)) %>%
  pull(min_interval)

# Find the interval_1s where Group 1 Subject 1 reaches the furthest west point in avg_longitude
west_limit <- Group_Subject %>%
  summarise(min_longitude = min(mean.longitude, na.rm = TRUE)) %>%
  pull(min_longitude)

furthest_west_interval <- Group_Subject %>%
  filter(mean.longitude == west_limit) %>%
  summarise(min_interval = min(interval_1s, na.rm = TRUE)) %>%
  pull(min_interval)

cyberattack_segment_data <- Group_Subject %>%
  filter(interval_1s >= Overland_interval & interval_1s <= furthest_west_interval)

# Find the interval_1s where Group Subject first reaches cyberattack start 
start_interval <- cyberattack_segment_data %>%
  filter(mean.longitude <= geo_start_point) %>%
  summarise(min_interval = min(interval_1s, na.rm = TRUE) - 6) %>%
  pull(min_interval)

# Create the plot with a vertical red line at start_interval
  ggplot(cyberattack_segment_data, aes(x = interval_1s, y = mean.gpsSpeed)) +
  geom_line() + # Use geom_line for a line plot
  geom_vline(xintercept = start_interval, color = "red", linetype = "dashed", size = 1) + # Add vertical line
  labs(title = paste("Average Velocity During Cyberattack Segment"),
       x = "Time (interval_1s)",
       y = "avg_velocity_kmh") +
  theme_minimal() # Optional: a clean theme for the plot


# Register your Google API key
register_google(key = "AIzaSyCym8yNgkU319dA6pj9fJQcjkT1rjEvQfA")

# Calculate the new center by shifting the longitude to the right
new_center_lon <- mean(Group_Subject$mean.longitude, na.rm = TRUE) - 0.04  # Adjust the shift value as needed
new_center_lat <- mean(Group_Subject$mean.latitude, na.rm = TRUE) + 0.005

# Get the map of Fort Collins with the new center
fort_collins_map <- get_map(location = c(lon = new_center_lon, 
                                         lat = new_center_lat), 
                            zoom = 16, maptype = "roadmap")  # Adjust the zoom level as needed

# Find the coordinates for the start_interval
start_coords <- Group_Subject %>%
  filter(interval_1s == start_interval) %>%
  summarise(mean.longitude = mean(mean.longitude, na.rm = TRUE), 
            mean.latitude = mean(mean.latitude, na.rm = TRUE)) %>%
  as.list()

# Create the map plot
ggmap(fort_collins_map) +
  geom_path(data = Group_Subject, aes(x = mean.longitude, y = mean.latitude), size = 1) +
  geom_vline(xintercept = start_coords$mean.longitude, color = "red", linetype = "dashed", size = 1) + # Add vertical dotted red line
  labs(title = "Route with Cyberattack Segments",
       x = "Longitude",
       y = "Latitude") +
  theme_minimal()



# Initialize the cyberattack_active column with 0
cyberattack_segment_data$cyberattack_active <- 0

# Loop through each interval_1s starting from start_interval
attack_end_interval <- start_interval + cyberattack_duration
stopped <- FALSE
stop_interval <- NA

for (i in seq_len(nrow(cyberattack_segment_data))) {
  if (cyberattack_segment_data$interval_1s[i] >= start_interval) {
    if (cyberattack_segment_data$interval_1s[i] <= attack_end_interval) {
      cyberattack_segment_data$cyberattack_active[i] <- 1
      if (cyberattack_segment_data$mean.gpsSpeed[i] < 1 && !stopped) {
        stopped <- TRUE
        stop_interval <- cyberattack_segment_data$interval_1s[i]
      }
    } else if (stopped && !is.na(stop_interval) && cyberattack_segment_data$interval_1s[i] <= stop_interval + 5) {
      cyberattack_segment_data$cyberattack_active[i] <- 1
    } else {
      cyberattack_segment_data$cyberattack_active[i] <- 0
    }
  }
}

# Ensure cyberattack_active is set to 0 after the stop interval + 5 seconds
if (!is.na(stop_interval)) {
  cyberattack_segment_data <- cyberattack_segment_data %>%
    mutate(cyberattack_active = ifelse(interval_1s > stop_interval + 5, 0, cyberattack_active))
}


# Extract Group and Subject numbers
group_number <- unique(Group_Subject$Group)
subject_number <- unique(Group_Subject$Subject)

# Count the total number of cyberattack_active instances
total_cyberattacks <- sum(cyberattack_segment_data$cyberattack_active)

# Create the plot with vertical dashed red lines at intervals where cyberattack_active is 1
cyberattack_plot <-  
  ggplot(cyberattack_segment_data, aes(x = interval_1s, y = mean.gpsSpeed)) +
  geom_line() + # Use geom_line for a line plot
  geom_vline(data = filter(cyberattack_segment_data, cyberattack_active == 1), 
             aes(xintercept = interval_1s), color = "red", linetype = "dashed", size = 0.5) + # Add vertical lines
  labs(title = paste("Average Velocity During Cyberattack Segment - Group", group_number, "Subject", subject_number),
       x = "Time (interval_1s)",
       y = "mean.gpsSpeed") +
  theme_minimal() + # Optional: a clean theme for the plot
  annotate("text", x = Inf, y = Inf, label = paste("Cyberattack Duration:", total_cyberattacks), 
           hjust = 1.1, vjust = 2, size = 5, color = "blue")

print(cyberattack_plot)

# Create a new column to identify segments
cyberattack_segment_data <- cyberattack_segment_data %>%
  mutate(segment = cumsum(c(1, diff(cyberattack_active) != 0)))

# Create the map plot
cyberattack_plot <- ggmap(fort_collins_map) +
  geom_path(data = cyberattack_segment_data, aes(x = mean.longitude, y = mean.latitude, color = factor(cyberattack_active), group = segment), size = 1) +
  geom_vline(xintercept = start_coords$mean.longitude, color = "red", linetype = "dashed", size = 1) + # Add vertical dashed red line
  scale_color_manual(values = c("0" = "blue", "1" = "red"), labels = c("Inactive", "Active")) +
  labs(title = paste("Route with Cyberattack Segments - Group", group_number, "Subject", subject_number),
       x = "Longitude",
       y = "Latitude",
       color = "Cyberattack Status") +
  theme_minimal()

print(cyberattack_plot)

# Join the cyberattack_active column to the original Group_Subject data frame
updated_Group_Subject <- Group_Subject %>%
  left_join(cyberattack_segment_data %>% select(interval_1s, cyberattack_active), by = "interval_1s") %>%
  select(ID, Group, Subject, Time, interval_1s, cyberattack_active, everything()) %>%
  mutate(cyberattack_active = replace_na(cyberattack_active, 0))

############

# Save the updated dataframe to a new CSV file
filename <- paste0("G", group_number, "_Subject", subject_number, "_cyberattack.csv")
write.csv(updated_Group_Subject, filename, row.names = FALSE)

# Print the name of the file that was just saved
print(paste("Saved file:", filename))

}







# ADD cyberattack_active data for drives WITH CAN0
# List of dataframes to process, excluding Group 1 Subjects 1-12 and Group 2 Subject 1
dataframes_CAN0 <- list(
  #G1_Subject13, G1_Subject14, 
                        #G1_Subject15, G1_Subject16, 
                   #G1_Subject17, 
                   #G2_Subject2, G2_Subject3, G2_Subject4, G2_Subject5, G2_Subject6, 
                   #G2_Subject7, G2_Subject8, G2_Subject9, G2_Subject10, G2_Subject11, 
                   #G2_Subject12, 
                   #G2_Subject13, 
                   #G2_Subject14, G2_Subject15, G2_Subject16, 
                   #G3_Subject1, G3_Subject2, G3_Subject3, G3_Subject4, G3_Subject5, 
                   G3_Subject6)
                   #G3_Subject7, G3_Subject8, G3_Subject9, G3_Subject10, 
                   #G3_Subject11, G3_Subject12, 
                   #G3_Subject13,
                   #G3_Subject14, G3_Subject15, 
                   #G3_Subject16, G3_Subject17)

# Loop through each dataframe
for (Group_Subject in dataframes_CAN0) {

# Define the longitude range and specific start point for Group 1 subjects 1 to 12
long_intersection_Laporte_Overland <- -105.133813 
# sign is at -105.1384

#Group_Subject <- G3_Subject9
lead_amount <- 4

###################

# Find the interval_1s where Group 1 Subject 1 first reaches long_intersection_Laporte_Overland
Overland_interval <- Group_Subject %>%
  filter(mean.longitude <= long_intersection_Laporte_Overland) %>%
  summarise(min_interval = min(interval_1s, na.rm = TRUE)) %>%
  pull(min_interval)

# Find the interval_1s where Group 1 Subject 1 reaches the furthest west point in avg_longitude
west_limit <- Group_Subject %>%
  summarise(min_longitude = min(mean.longitude, na.rm = TRUE)) %>%
  pull(min_longitude)

furthest_west_interval <- Group_Subject %>%
  filter(mean.longitude == west_limit) %>%
  summarise(min_interval = min(interval_1s, na.rm = TRUE)) %>%
  pull(min_interval)

cyberattack_segment_data <- Group_Subject %>%
  filter(interval_1s >= Overland_interval & interval_1s <= furthest_west_interval)

# Create cyberattack_active column that is 1 for active and 0 for inactive
cyberattack_segment_data <- cyberattack_segment_data %>%
  mutate(cyberattack_active = ifelse(is.na(mean.190.Engine.Speed.CAN0), 1, 0))

cyberattack_segment_data <- cyberattack_segment_data %>%
  mutate(cyberattack_active = ifelse(is.na(mean.190.Engine.Speed.CAN0), 1, 0)) %>%
  mutate(cyberattack_active = lead(cyberattack_active, n = lead_amount, default = 0))

# Extract Group and Subject numbers
group_number <- unique(Group_Subject$Group)
subject_number <- unique(Group_Subject$Subject)

# Count the total number of cyberattack_active instances
total_cyberattacks <- sum(cyberattack_segment_data$cyberattack_active)

# Create the plot with vertical dashed red lines at intervals where cyberattack_active is 1
cyberattack_plot <-  
  ggplot(cyberattack_segment_data, aes(x = interval_1s, y = mean.gpsSpeed)) +
  geom_line() + # Use geom_line for a line plot
  geom_vline(data = filter(cyberattack_segment_data, cyberattack_active == 1), 
             aes(xintercept = interval_1s), color = "red", linetype = "dashed", size = 0.5) + # Add vertical lines
  labs(title = paste("Average Velocity During Cyberattack Segment - Group", group_number, "Subject", subject_number),
       x = "Time (interval_1s)",
       y = "mean.gpsSpeed") +
  theme_minimal() + # Optional: a clean theme for the plot
  annotate("text", x = Inf, y = Inf, label = paste("Cyberattack Duration:", total_cyberattacks), 
           hjust = 1.1, vjust = 2, size = 5, color = "blue")

print(cyberattack_plot)

# Register your Google API key
register_google(key = "AIzaSyCym8yNgkU319dA6pj9fJQcjkT1rjEvQfA")

# Calculate the new center by shifting the longitude to the right
new_center_lon <- mean(Group_Subject$mean.longitude, na.rm = TRUE) - 0.043  # Adjust the shift value as needed
new_center_lat <- mean(Group_Subject$mean.latitude, na.rm = TRUE) + 0.005

# Get the map of Fort Collins with the new center
fort_collins_map <- get_map(location = c(lon = new_center_lon, 
                                         lat = new_center_lat), 
                            zoom = 16, maptype = "roadmap")  # Adjust the zoom level as needed


# Create a new column to identify segments
cyberattack_segment_data <- cyberattack_segment_data %>%
  mutate(segment = cumsum(c(1, diff(cyberattack_active) != 0)))

# Create the map plot
cyberattack_plot <- ggmap(fort_collins_map) +
  geom_path(data = cyberattack_segment_data, aes(x = mean.longitude, y = mean.latitude, color = factor(cyberattack_active), group = segment), size = 1) +
  scale_color_manual(values = c("0" = "blue", "1" = "red"), labels = c("Inactive", "Active")) +
  labs(title = paste("Route with Cyberattack Segments - Group", group_number, "Subject", subject_number),
       x = "Longitude",
       y = "Latitude",
       color = "Cyberattack Status") +
  theme_minimal()

print(cyberattack_plot)

# Create new dataframe with cyberattack_active
cyberattack_active_data <- cyberattack_segment_data %>%
  select(interval_1s, cyberattack_active)

# Join the new column with the original dataframe
updated_Group_Subject <- Group_Subject %>%
  left_join(cyberattack_active_data, by = "interval_1s") %>%
  select(ID, Group, Subject, interval_1s, cyberattack_active, everything()) %>%
  mutate(cyberattack_active = replace_na(cyberattack_active, 0))



#####################

# Save the updated dataframe to a new CSV file
filename <- paste0("G", group_number, "_Subject", subject_number, "_cyberattack.csv")
write.csv(updated_Group_Subject, filename, row.names = FALSE)

# Print the name of the file that was just saved
print(paste("Saved file:", filename))

}































# Define the function to add cyberattack_active to CAN0 
add_cyberattack_active_CAN0 <- function(subject_data, long_intersection_Laporte_Overland, output_filename) {
  Overland_interval <- subject_data %>%
    filter(avg_longitude <= long_intersection_Laporte_Overland) %>%
    summarise(min_interval = min(interval_1s, na.rm = TRUE)) %>%
    pull(min_interval)
  
  west_limit <- subject_data %>%
    summarise(min_longitude = min(avg_longitude, na.rm = TRUE)) %>%
    pull(min_longitude)
  
  furthest_west_interval <- subject_data %>%
    filter(avg_longitude == west_limit) %>%
    summarise(min_interval = min(interval_1s, na.rm = TRUE)) %>%
    pull(min_interval)
  
  cyberattack_segment_data <- subject_data %>%
    filter(interval_1s >= Overland_interval & interval_1s <= furthest_west_interval)
  
  cyberattack_segment_data <- cyberattack_segment_data %>%
    mutate(cyberattack_active = ifelse(is.na(avg_190_Engine_Speed_CAN0), 1, 0))
  
  group_number <- subject_data$Group
  subject_number <- subject_data$Subject
  
  
  plot <- ggplot(cyberattack_segment_data, aes(x = interval_1s, y = avg_gpsSpeed)) +
    geom_line() +
    geom_vline(data = filter(cyberattack_segment_data, cyberattack_active == 1), 
               aes(xintercept = interval_1s), color = "red", linetype = "dashed", size = 0.5) +
    labs(title = paste("Average Velocity During Cyberattack Segment- Group", group_number, "Subject", subject_number),
         x = "Time (interval_1s)",
         y = "avg_gpsSpeed") +
    theme_minimal()
  
  print(plot)
  
  cyberattack_active_data <- cyberattack_segment_data %>%
    select(interval_1s, cyberattack_active)
  
  updated_subject_data <- subject_data %>%
    left_join(cyberattack_active_data, by = "interval_1s") %>%
    select(ID, Group, Subject, interval_1s, cyberattack_active, everything())
  
  # Save the updated dataframe to a CSV file
  write.csv(updated_subject_data, output_filename, row.names = FALSE)
  
  return(updated_subject_data)
}


# Define the longitude range and specific start point
long_intersection_Laporte_Overland <- -105.133813 


# Apply the function to each subject separately with updated names
G1_Subject13_updated <- add_cyberattack_active_CAN0(G1_Subject13, long_intersection_Laporte_Overland, "G1_Subject13.csv")
# Ran for too long 
# G1_Subject14_updated <- add_cyberattack_active_CAN0(G1_Subject14, long_intersection_Laporte_Overland, "G1_Subject14.csv")
G1_Subject15_updated <- add_cyberattack_active_CAN0(G1_Subject15, long_intersection_Laporte_Overland, "G1_Subject15.csv")
G1_Subject16_updated <- add_cyberattack_active_CAN0(G1_Subject16, long_intersection_Laporte_Overland, "G1_Subject16.csv")
G1_Subject17_updated <- add_cyberattack_active_CAN0(G1_Subject17, long_intersection_Laporte_Overland, "G1_Subject17.csv")

# Register your Google API key
register_google(key = "AIzaSyCym8yNgkU319dA6pj9fJQcjkT1rjEvQfA")

# Calculate the new center by shifting the longitude to the right
new_center_lon <- mean(cyberattack_segment_data$avg_longitude) + 0.006  # Adjust the shift value as needed
new_center_lat <- mean(cyberattack_segment_data$avg_latitude)

# Get the map of Fort Collins with the new center
fort_collins_map <- get_map(location = c(lon = new_center_lon, 
                                         lat = new_center_lat), 
                            zoom = 14, maptype = "roadmap")  # Adjust the zoom level as needed

# Create the map plot
map_plot <- ggmap(fort_collins_map) +
  geom_path(data = cyberattack_segment_data, aes(x = avg_longitude, y = avg_latitude, color = factor(cyberattack_active)), size = 1) +
  scale_color_manual(values = c("0" = "blue", "1" = "red"), labels = c("Inactive", "Active")) +
  labs(title = "Route with Cyberattack Segments",
       x = "Longitude",
       y = "Latitude",
       color = "Cyberattack Status") +
  theme_minimal()

# Save the plot to a file
ggsave("cyberattack_map_plot.png", plot = map_plot, width = 10, height = 8)

# Display the plot
print(map_plot)


#G2_Subject1_updated <- add_cyberattack_active_CAN0(G2_Subject1, long_intersection_Laporte_Overland, "G2_Subject1.csv")
G2_Subject2_updated <- add_cyberattack_active_CAN0(G2_Subject2, long_intersection_Laporte_Overland, "G2_Subject2.csv")
#G2_Subject3_updated <- add_cyberattack_active_CAN0(G2_Subject3, long_intersection_Laporte_Overland, "G2_Subject3.csv")
G2_Subject4_updated <- add_cyberattack_active_CAN0(G2_Subject4, long_intersection_Laporte_Overland, "G2_Subject4.csv")
G2_Subject5_updated <- add_cyberattack_active_CAN0(G2_Subject5, long_intersection_Laporte_Overland, "G2_Subject5.csv")
# subject drove into forest parking lot
#G2_Subject6_updated <- add_cyberattack_active_CAN0(G2_Subject6, long_intersection_Laporte_Overland, "G2_Subject6.csv")
#G2_Subject7_updated <- add_cyberattack_active_CAN0(G2_Subject7, long_intersection_Laporte_Overland, "G2_Subject7.csv")
G2_Subject8_updated <- add_cyberattack_active_CAN0(G2_Subject8, long_intersection_Laporte_Overland, "G2_Subject8.csv")
G2_Subject9_updated <- add_cyberattack_active_CAN0(G2_Subject9, long_intersection_Laporte_Overland, "G2_Subject9.csv")
G2_Subject10_updated <- add_cyberattack_active_CAN0(G2_Subject10, long_intersection_Laporte_Overland, "G2_Subject10.csv")
G2_Subject11_updated <- add_cyberattack_active_CAN0(G2_Subject11, long_intersection_Laporte_Overland, "G2_Subject11.csv")
G2_Subject12_updated <- add_cyberattack_active_CAN0(G2_Subject12, long_intersection_Laporte_Overland, "G2_Subject12.csv")
G2_Subject13_updated <- add_cyberattack_active_CAN0(G2_Subject13, long_intersection_Laporte_Overland, "G2_Subject13.csv")
G2_Subject14_updated <- add_cyberattack_active_CAN0(G2_Subject14, long_intersection_Laporte_Overland, "G2_Subject14.csv")
G2_Subject15_updated <- add_cyberattack_active_CAN0(G2_Subject15, long_intersection_Laporte_Overland, "G2_Subject15.csv")
G2_Subject16_updated <- add_cyberattack_active_CAN0(G2_Subject16, long_intersection_Laporte_Overland, "G2_Subject16.csv")

G3_Subject1_updated <- add_cyberattack_active_CAN0(G3_Subject1, long_intersection_Laporte_Overland, "G3_Subject1.csv")
G3_Subject2_updated <- add_cyberattack_active_CAN0(G3_Subject2, long_intersection_Laporte_Overland, "G3_Subject2.csv")
G3_Subject3_updated <- add_cyberattack_active_CAN0(G3_Subject3, long_intersection_Laporte_Overland, "G3_Subject3.csv")
G3_Subject4_updated <- add_cyberattack_active_CAN0(G3_Subject4, long_intersection_Laporte_Overland, "G3_Subject4.csv")
G3_Subject5_updated <- add_cyberattack_active_CAN0(G3_Subject5, long_intersection_Laporte_Overland, "G3_Subject5.csv")
G3_Subject6_updated <- add_cyberattack_active_CAN0(G3_Subject6, long_intersection_Laporte_Overland, "G3_Subject6.csv")
G3_Subject7_updated <- add_cyberattack_active_CAN0(G3_Subject7, long_intersection_Laporte_Overland, "G3_Subject7.csv")
G3_Subject8_updated <- add_cyberattack_active_CAN0(G3_Subject8, long_intersection_Laporte_Overland, "G3_Subject8.csv")
G3_Subject9_updated <- add_cyberattack_active_CAN0(G3_Subject9, long_intersection_Laporte_Overland, "G3_Subject9.csv")
G3_Subject10_updated <- add_cyberattack_active_CAN0(G3_Subject10, long_intersection_Laporte_Overland, "G3_Subject10.csv")
G3_Subject11_updated <- add_cyberattack_active_CAN0(G3_Subject11, long_intersection_Laporte_Overland, "G3_Subject11.csv")
G3_Subject12_updated <- add_cyberattack_active_CAN0(G3_Subject12, long_intersection_Laporte_Overland, "G3_Subject12.csv")
G3_Subject13_updated <- add_cyberattack_active_CAN0(G3_Subject13, long_intersection_Laporte_Overland, "G3_Subject13.csv")
G3_Subject14_updated <- add_cyberattack_active_CAN0(G3_Subject14, long_intersection_Laporte_Overland, "G3_Subject14.csv")
G3_Subject15_updated <- add_cyberattack_active_CAN0(G3_Subject15, long_intersection_Laporte_Overland, "G3_Subject15.csv")
G3_Subject16_updated <- add_cyberattack_active_CAN0(G3_Subject16, long_intersection_Laporte_Overland, "G3_Subject16.csv")
G3_Subject17_updated <- add_cyberattack_active_CAN0(G3_Subject17, long_intersection_Laporte_Overland, "G3_Subject17.csv")



##################

