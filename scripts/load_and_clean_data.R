# This file is purely as an example. 
# There are a few places

#loan_data <- read_csv(here::here("dataset", "loan_refusal.csv"))

## CLEAN the data
#loan_data_clean <- loan_data

#write_csv(loan_data_clean, file = here::here("dataset", "loan_refusal_clean.csv"))

#save(loan_data_clean, file = here::here("dataset/loan_refusal.RData"))

#____________________________________________________________________________
# Load necessary libraries
library(here)
library(readr)
library(tidyverse)

# Obtaining the data from the data-ignore folder since its > 50mb
dataset_path <- here("dataset-ignore", "NYSERDA_LMI_Census_2013-2015.csv")
data <- read_csv(dataset_path)

# basic information about the dataset before any cleaning
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

# Confirming duplicate rows and missing values were dealt with
duplicate_rows <- sum(duplicated(data))
print(paste("Number of duplicate rows after cleaning:", duplicate_rows))
missing_values <- sapply(data, function(x) sum(is.na(x)))
print("Missing values per column after cleaning:")
print(missing_values)

# Convert all character columns to factors
data <- data.frame(lapply(data, function(x) if(is.character(x)) factor(x) else x))

# Checking size of cleaned data
#memory_size_bytes <- object.size(data)
#memory_size_kb <- memory_size_bytes / 1024
#memory_size_mb <- memory_size_kb / 1024
# print(paste("Dataframe memory size: ", round(memory_size_mb, 2), " MB"))

#check again for the whole dataset, check again for no unusual values
str(data)

# Save the cleaned dataset

# This is the code to save the whole cleaned data set
#cleaned_dataset_path <- here("dataset", "cleaned_NYSERDA_LMI_Census_2013-2015.csv")
#write_csv(cleaned_data, cleaned_dataset_path)

# Saving a subset of the clean data that is < 5mb
rows_saved <- 13500 

# random subset of the data
data_subset <- sample_n(data, rows_saved)

# Saving the subset to a new file
subset_dataset_path <- here("dataset", "clean_subset_NYSERDA_LMI_Census_2013-2015.csv")
write_csv(data_subset, subset_dataset_path)





