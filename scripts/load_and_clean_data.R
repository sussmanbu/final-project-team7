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

#check again for the whole dataset, check again for no unusual values
str(data)

# Save the cleaned dataset

# Saving as an rds file
cleaned_dataset_path_rds <- here("dataset", "cleaned_NYSERDA_LMI_Census_2013-2015.rds")
saveRDS(cleaned_data, file = cleaned_dataset_path_rds)






