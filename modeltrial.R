library(here)
library(dplyr)
library(forcats)
library(ggplot2)
View(clean_data)
cleaned_dataset_path_rds <- here("dataset", "cleaned_NYSERDA_LMI_Census_2013-2015.rds")
clean_data <- readRDS(cleaned_dataset_path_rds)
clean_data$OwnerStatue<-ifelse(clean_data$"Owner.Renter.Status"=="Own",1,0)

clean_data$`Income Numeric` <- case_when(
  clean_data$`Income.Groups` == "$0 to <$10,000" ~ 5,
  clean_data$`Income.Groups` == "$10,000-<$20,000" ~ 15,
  clean_data$`Income.Groups` == "$20,000-<$30,000" ~ 25,
  clean_data$`Income.Groups` == "$30,000-<$40,000" ~ 35,
  clean_data$`Income.Groups` == "$40,000-<$50,000" ~ 45,
  clean_data$`Income.Groups` == "$50,000+" ~ 55,
  TRUE ~ NA_real_)

#Run lm
modellm<-lm(`Income Numeric` ~ `Household.Weight`+`OwnerStatue`, data = clean_data)
summary(modellm)
plot(x = clean_data$`Household.Weight`, y = clean_data$`Income Numeric`) 

#Run ggplot--- it is not linearily
ggplot(clean_data, aes(x = `Household.Weight`, y = `Income Numeric`, color = `Race / Ethnicity`, group = `Race / Ethnicity`)) +
  geom_line() +
  labs(title = "Income Disparity across Race",
       x = "Household Weight",
       y = "Income",
       color = "Race") +
  theme_minimal()

# Multinomial logistic regression
library(nnet)
multinom_model <- multinom(`Income Groups` ~ `Education Level` + `Household Weight` + OwnerStatue, data = clean_data)
summary(multinom_model)

weight_range <- seq(min(clean_data$`Household Weight`, na.rm = TRUE),
                    max(clean_data$`Household Weight`, na.rm = TRUE), length.out = 223085)

clean_data$`Education Level` <- factor(clean_data$`Education Level`, levels = unique(as.character(clean_data$`Education Level`)))
clean_data$OwnerStatue <- factor(clean_data$OwnerStatue, levels = unique(as.character(clean_data$OwnerStatue)))

pred_data <- data.frame(
  `Education Level` = factor(rep(levels(clean_data$`Education Level`)[1], 223085), levels = levels(clean_data$`Education Level`)),
  `Household Weight` = weight_range, 
  OwnerStatue = rep(as.numeric(levels(clean_data$OwnerStatue)[1]), 223085)
)

library(tidyr)
prob_data$`Household Weight` = weight_range

prob_data_long <- pivot_longer(prob_data, 
                               cols = -`Household Weight`, 
                               names_to = "Income Group", 
                               values_to = "Probability")

predicted_probs <- predict(multinom_model, newdata = pred_data, type = "probs")
prob_data <- as.data.frame(predicted_probs)

#ok 
ggplot(prob_data_long, aes(x = `Household Weight`, y = Probability, color = `Income Group`)) +
  geom_line() +
  labs(title = "Predicted Probability of Income Groups by Household Weight",
       x = "Household Weight", y = "Probability") +
  theme_minimal()

