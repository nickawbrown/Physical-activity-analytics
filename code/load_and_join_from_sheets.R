# Packages ----------------------------------------------------------------

pkgs <- c("tidyverse", "googlesheets4", "janitor", "here")
#install.packages(pkgs)

# Load packages
library(here)
library(tidyverse); theme_set(theme_bw(base_size = 16))
library(googlesheets4)
library(janitor)



# Import data from training log -------------------------------------------


# Drive ID
daily_log_id <- as_sheets_id("https://docs.google.com/spreadsheets/d/1m4cimPkPWSvhHYERKfwjfo8x7_BxhIviB1gcPqg9X10/edit?gid=0#gid=0")


# Load daily log data
logs <- read_sheet(
  daily_log_id, 
  sheet = "Daily log",
  col_types = "c" # Read all columns as character
)


# Load discomfort tracker
pain_sore <- read_sheet(
  daily_log_id, 
  sheet = "Pain/soreness tracking",
  col_types = "c" # Read all columns as character
)


# Load activity descriptions
activities <- read_sheet(
  daily_log_id,
  sheet = "Activity descriptions",
  col_types = "c" # Read all columns as character
)


# Join all data by date and save as new file ----------------------------------


# Using left joins
full_data <- logs |> 
  left_join(activities) |> 
  left_join(pain_sore) |> 
  clean_names() |> 
  relocate(description:rest_per_set_s, .after = name) |> 
  rename("physical_preparedness" = physical_preparedness_1_10)


# Save as .csv file
write.csv(
  full_data,
  here("data", "daily_log_data_joined.csv"),
  row.names = FALSE
)
