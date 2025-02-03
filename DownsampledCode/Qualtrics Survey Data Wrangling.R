### DriverID Qulatrics Survey Data Wrangling 


# Load necessary libraries
library(tidyverse)
library(readxl)
library(lubridate)
library(ggplot2)
library(maps)
library(ggmap)

# Set working directory
setwd("/Volumes/Extreme SSD/ORNLDriverIDsCSVFormat")


survey_data <- read.csv("ORNL Driver Identification_November 4, 2024_23.37.csv")

##############


# Remove irrelevant data columns
survey_data <- survey_data %>%
  select(-c(StartDate, EndDate, Status, IPAddress, Progress, Duration..in.seconds., 
            Finished, ResponseId, RecipientLastName, RecipientFirstName, RecipientEmail, 
            ExternalReference, LocationLatitude, LocationLongitude, UserLanguage, 
            DistributionChannel))
 
# Remove the ImportID row
survey_data <- survey_data[-2,]

# Extract the survey_questions
survey_questions <- survey_data[1, ]


# Remove the first row (since it's now part of the column names)
survey_data <- survey_data[-1, ]

# Function to convert cdl_yrs to numeric years, preserving decimal points
convert_cdl_yrs <- function(cdl_yrs) {
  # Extract numeric value, preserving decimal points
  num <- as.numeric(gsub("[^0-9.]", "", cdl_yrs))
  
  # Check if it contains "months" and convert to years if necessary
  if (grepl("months", cdl_yrs, ignore.case = TRUE)) {
    return(num / 12)
  } else {
    return(num)
  }
}


# Apply the function to the cdl_yrs column
survey_data_numeric <- survey_data %>%
  mutate(
    Group = as.numeric(gsub("[^0-9]", "", Group)),
    Ss = as.numeric(gsub("[^0-9]", "", Ss)),
    age = as.numeric(gsub("[^0-9]", "", age)),
    cdl_yrs = sapply(cdl_yrs, convert_cdl_yrs),
    tickets = as.numeric(gsub("[^0-9]", "", tickets)),
    crashes = as.numeric(gsub("[^0-9]", "", crashes)),
    driving_yrs = as.numeric(gsub("[^0-9]", "", driving_yrs))
  )


# Manually correct specific rows for driving_yrs
survey_data_numeric <- survey_data_numeric %>%
  mutate(driving_yrs = case_when(
    driving_yrs == 712 ~ 7.5,  # Correct "7 1/2 years"
    driving_yrs == 1985 ~ as.numeric(format(Sys.Date(), "%Y")) - 1985,  # Correct "Received class C license in 1985"
    TRUE ~ driving_yrs
  ))


# Compare the cdl_yrs columns side by side
comparison_cdl_yrs <- data.frame(
  Before = survey_data$cdl_yrs,
  After = survey_data_numeric$cdl_yrs
)


# Compare the driving_yrs columns side by side
comparison_driving_yrs <- data.frame(
  Before = survey_data$driving_yrs,
  After = survey_data_numeric$driving_yrs
)



# Group by group and add subject number
group1 <- survey_data_numeric %>% 
  filter(Group == "1") %>% 
  arrange(Ss) %>% 
  mutate(Subject = row_number()) %>%
  mutate(gender = case_when(
    Ss == 46 & Group == 1 & Subject == 17 ~ "Female",
    TRUE ~ gender)) %>%
  mutate(Experience = case_when(
    (cdl == "Yes, and I still do." & Q20 == "Yes" & miles != "less than 5,000 miles") ~ "Professional",
    (Q20 == "Yes" & grepl("fire", Q21, ignore.case = TRUE)) ~ "Professional",
    TRUE ~ "Amateur")) %>%
  select(RecordedDate, Ss, Group, Subject, Experience, everything())


group2 <- survey_data_numeric %>% 
  filter(Group == "2") %>% 
  arrange(Ss) %>% 
  mutate(Subject = row_number()) %>%
  mutate(Experience = case_when(
    (grepl("Yes", cdl, ignore.case = TRUE)  & Q20 == "Yes" & miles != "less than 5,000 miles") ~ "Professional",
    (Q20 == "Yes" & grepl("fire", Q21, ignore.case = TRUE)) ~ "Professional",
    TRUE ~ "Amateur")) %>%
  select(RecordedDate, Ss, Group, Subject, Experience, everything())


group3 <- survey_data_numeric %>% 
  filter(Group == "3") %>% 
  arrange(Ss) %>% 
  mutate(Subject = row_number()) %>%
  mutate(gender = case_when(
    Ss == 32 & Group == 3 & Subject == 6 ~ "Male",
    TRUE ~ gender)) %>%
  mutate(Experience = case_when(
    (cdl == "Yes, and I still do." & Q20 == "Yes" & miles != "less than 5,000 miles") ~ "Professional",
    (Q20 == "Yes" & grepl("fire", Q21, ignore.case = TRUE)) ~ "Professional",
    TRUE ~ "Amateur")) %>%
  select(RecordedDate, Ss, Group, Subject, Experience, everything())


# Combine all groups into one dataframe
combined_survey_data <- bind_rows(group1, group2, group3)


# Define the mapping of responses to scores for Q11 and Q12 questions
MMDBQ_score_mapping <- c(
  "Never" = 1,
  "Hardly Ever" = 2,
  "Occasionally" = 3,
  "Quite Often" = 4,
  "Frequently" = 5,
  "Nearly All the Time" = 6
)

GRiPS_score_mapping <- c(
  "Strongly disagree" = 1,
  "Somewhat disagree" = 2,
  "Neither agree nor disagree" = 3,
  "Somewhat agree" = 4,
  "Strongly agree" = 5
)


# Assign scores to Q11 questions and create new columns for the scores
combined_survey_data <- combined_survey_data %>%
  mutate(
    Q11_1_score = MMDBQ_score_mapping[Q11_1],
    Q11_2_score = MMDBQ_score_mapping[Q11_2],
    Q11_3_score = MMDBQ_score_mapping[Q11_3],
    Q11_4_score = MMDBQ_score_mapping[Q11_4],
    Q11_5_score = MMDBQ_score_mapping[Q11_5],
    Q11_6_score = MMDBQ_score_mapping[Q11_6],
    Q11_7_score = MMDBQ_score_mapping[Q11_7],
    Q11_8_score = MMDBQ_score_mapping[Q11_8],
    Q11_9_score = MMDBQ_score_mapping[Q11_9],
    Q11_10_score = MMDBQ_score_mapping[Q11_10]
  )

# Assign scores to Q12 questions and create new columns for the scores
combined_survey_data <- combined_survey_data %>%
  mutate(
    Q12_1_score = GRiPS_score_mapping[Q12_1],
    Q12_2_score = GRiPS_score_mapping[Q12_2],
    Q12_3_score = GRiPS_score_mapping[Q12_3],
    Q12_4_score = GRiPS_score_mapping[Q12_4],
    Q12_5_score = GRiPS_score_mapping[Q12_5],
    Q12_6_score = GRiPS_score_mapping[Q12_6],
    Q12_7_score = GRiPS_score_mapping[Q12_7],
    Q12_8_score = GRiPS_score_mapping[Q12_8]
  )

# Calculate total MMDBQ score
combined_survey_data <- combined_survey_data %>%
  rowwise() %>%
  mutate(total_MMDBQ_score = sum(c_across(starts_with("Q11_") & ends_with("_score")), na.rm = TRUE))

# Calculate average MMDBQ score
combined_survey_data <- combined_survey_data %>%
  rowwise() %>%
  mutate(
    avg_MMDBQ_score = total_MMDBQ_score / sum(!is.na(c_across(starts_with("Q11_") & ends_with("_score")))))


# Calculate total GRiPS score
combined_survey_data <- combined_survey_data %>%
  rowwise() %>%
  mutate(total_GRiPS_score = sum(c_across(starts_with("Q12_") & ends_with("_score")), na.rm = TRUE))


# Calculate average GRiPS score
combined_survey_data <- combined_survey_data %>%
  rowwise() %>%
  mutate(
    avg_GRiPS_score = total_GRiPS_score / sum(!is.na(c_across(starts_with("Q12_") & ends_with("_score")))))


# Define the mapping of responses to scores for cyberattack questions
cyberattack_score_mapping <- c(
  "Strongly disagree" = 1,
  "Somewhat disagree" = 2,
  "Neither agree nor disagree" = 3,
  "Somewhat agree" = 4,
  "Strongly agree" = 5
)

# Assign scores to cyberattack questions and create new columns for the scores
combined_survey_data <- combined_survey_data %>%
  mutate(
    cyberattack_1_score = cyberattack_score_mapping[cyberattack_1],
    cyberattack_2_score = cyberattack_score_mapping[cyberattack_2],
    cyberattack_3_score = cyberattack_score_mapping[cyberattack_3],
    cyberattack_4_score = cyberattack_score_mapping[cyberattack_4]
  )
 
#################

# Calculate summary statistics for age, total_MMDBQ_score, and total_GRiPS_score between each group
summary_statistics <- combined_survey_data %>%
  group_by(Group) %>%
  summarise(
    age_mean = mean(age, na.rm = TRUE),
    age_sd = sd(age, na.rm = TRUE),
    age_min = min(age, na.rm = TRUE),
    age_max = max(age, na.rm = TRUE),
    total_MMDBQ_score_mean = mean(total_MMDBQ_score, na.rm = TRUE),
    total_MMDBQ_score_sd = sd(total_MMDBQ_score, na.rm = TRUE),
    total_MMDBQ_score_min = min(total_MMDBQ_score, na.rm = TRUE),
    total_MMDBQ_score_max = max(total_MMDBQ_score, na.rm = TRUE),
    total_GRiPS_score_mean = mean(total_GRiPS_score, na.rm = TRUE),
    total_GRiPS_score_sd = sd(total_GRiPS_score, na.rm = TRUE),
    total_GRiPS_score_min = min(total_GRiPS_score, na.rm = TRUE),
    total_GRiPS_score_max = max(total_GRiPS_score, na.rm = TRUE)
  )

# View the summary statistics
print(summary_statistics)




# Extract the first row from survey_questions
survey_questions_first_row <- as.character(survey_questions[1, ])

# Create a named vector for the new column names
new_colnames <- colnames(combined_survey_data)

# Update the column names only if they match the column headers in survey_questions
for (i in seq_along(new_colnames)) {
  if (new_colnames[i] %in% colnames(survey_questions)) {
    new_colnames[i] <- paste(new_colnames[i], survey_questions_first_row[which(colnames(survey_questions) == new_colnames[i])], sep = ": ")
  }
}

# Rename the columns in combined_survey_data
colnames(combined_survey_data) <- new_colnames

# Add the survey data to only include the rows where interval_1s is 0
combined_survey_data <- combined_survey_data %>%
  mutate(interval_1s = 0)

# Reorganize the dataframe with the desired column order
combined_survey_data <- combined_survey_data %>%
  select(
    starts_with("RecordedDate"), starts_with("Ss"), interval_1s, starts_with("Group"), starts_with("Subject"), 
    starts_with("Experience"), starts_with("gender"), starts_with("age"), starts_with("Q10"), starts_with("cdl"), 
    starts_with("cdl_yrs"), starts_with("Q20"), starts_with("Q21"), starts_with("miles"), starts_with("tickets"), 
    starts_with("crashes"), starts_with("driving_yrs"), total_MMDBQ_score, avg_MMDBQ_score, total_GRiPS_score, avg_GRiPS_score,
    everything()) %>%
  rename(Group = `Group: Group (to be filled out by researcher):`) %>%
  mutate(RecordedDate = mdy_hm(`RecordedDate: Recorded Date`)) %>%
  select(RecordedDate, everything(), -`RecordedDate: Recorded Date`)


# Calculate summary statistics for age, total_MMDBQ_score, and total_GRiPS_score between each group
summary_statistics <- combined_survey_data %>%
group_by(Group) %>%
  summarise(
    age_mean = mean(`age: What is your age (in years)?`, na.rm = TRUE),
    age_sd = sd(`age: What is your age (in years)?`, na.rm = TRUE),
    age_min = min(`age: What is your age (in years)?`, na.rm = TRUE),
    age_max = max(`age: What is your age (in years)?`, na.rm = TRUE),
    total_MMDBQ_score_mean = mean(total_MMDBQ_score, na.rm = TRUE),
    total_MMDBQ_score_sd = sd(total_MMDBQ_score, na.rm = TRUE),
    total_MMDBQ_score_min = min(total_MMDBQ_score, na.rm = TRUE),
    total_MMDBQ_score_max = max(total_MMDBQ_score, na.rm = TRUE),
    total_GRiPS_score_mean = mean(total_GRiPS_score, na.rm = TRUE),
    total_GRiPS_score_sd = sd(total_GRiPS_score, na.rm = TRUE),
    total_GRiPS_score_min = min(total_GRiPS_score, na.rm = TRUE),
    total_GRiPS_score_max = max(total_GRiPS_score, na.rm = TRUE)
  )

# View the summary statistics
print(summary_statistics)





# Save the combined_survey_data as a CSV file
write.csv(combined_survey_data, "Qualtrics_Survey_data.csv", row.names = FALSE)

# Confirm the file has been saved
print("The combined_survey_data has been saved as Qualtrics_Survey_data.csv")

