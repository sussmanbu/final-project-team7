# This file is purely as an example. 
# There are a few places

library(tidyverse)

loan_data <- read_csv(here::here("dataset", "loan_refusal.csv"))

## CLEAN the data
loan_data_clean <- loan_data

write_csv(loan_data_clean, file = here::here("dataset", "loan_refusal_clean.csv"))

save(loan_data_clean, file = here::here("dataset/loan_refusal.RData"))