# Load necessary libraries
library(here)
library(readr)
library(tidyverse)
library(tidyr)

# Obtaining the data from the data-ignore folder since its > 50mb
dataset_path <- here("dataset-ignore", "NYSERDA_LMI_Census_2013-2015.csv")
data <- read_csv(dataset_path)

# Display basic information about the dataset before any cleaning
str(data)

# Checking for duplicate rows
duplicate_rows <- sum(duplicated(data))
print(paste("Number of duplicate rows before cleaning:", duplicate_rows))

# Removing duplicate rows
data <- data[!duplicated(data), ]

# Checking for missing values
missing_values <- sapply(data, function(x) sum(is.na(x)))
print("Missing values per column before cleaning:")
print(missing_values)

# Replacing missing values with a new category for "Mortgage Indicator"
data[["Mortgage Indicator"]][is.na(data[["Mortgage Indicator"]])] <- 'Unknown'

# Improved splitting of the 'County / County Group' column
data <- data %>%
  mutate(`County / County Group` = strsplit(as.character(`County / County Group`), ",\\s*|&\\s*")) %>%
  unnest(`County / County Group`) %>%
  mutate(`County / County Group` = trimws(`County / County Group`))  # Trim whitespace to avoid creating empty entries

# Ensuring there are no empty or NA county names after splitting
data <- data %>%
  filter(`County / County Group` != "" & !is.na(`County / County Group`))

# Rename the column 'County / County Group' to 'County' 
data <- rename(data, County = `County / County Group`)

# Confirming duplicate rows and missing values were dealt with
duplicate_rows <- sum(duplicated(data))
print(paste("Number of duplicate rows after cleaning:", duplicate_rows))
missing_values <- sapply(data, function(x) sum(is.na(x)))
print("Missing values per column after cleaning:")
print(missing_values)

# Converting all character columns to factors
data <- data.frame(lapply(data, function(x) if(is.character(x)) factor(x) else x))

# Checking again for the whole dataset, ensure no unusual values
str(data)

names(data) <- gsub("Race...Ethnicity", "Race_Ethnicity", names(data), fixed = TRUE)
names(data) <- gsub(".", "_", names(data), fixed = TRUE)

# Saving the cleaned and updated dataset

# Saving as an RDS file
cleaned_dataset_path_rds <- here("dataset", "cleaned_NYSERDA_LMI_Census_2013-2015.rds")
saveRDS(data, file = cleaned_dataset_path_rds)

# Saving as a CSV file
cleaned_dataset_path <- here("dataset", "cleaned_Data.csv")
write_csv(data, cleaned_dataset_path)
