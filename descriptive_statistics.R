# Load necessary libraries
library(dplyr)
library(readr)

# Function to compute descriptive statistics for each data frame
descriptive_stats <- function(df) {
  summary(df)
}

# Define file paths
file_paths <- list(
  "1963_1972" = "C:/Users/user1/Documents/ESCResults/ESC_1963_1972.csv",
  "1973_1982" = "C:/Users/user1/Documents/ESCResults/ESC_1973_1982.csv",
  "1983_1992" = "C:/Users/user1/Documents/ESCResults/ESC_1983_1992.csv",
  "1993_2002" = "C:/Users/user1/Documents/ESCResults/ESC_1993_2002.csv",
  "2003_2012" = "C:/Users/user1/Documents/ESCResults/ESC_2003_2012.csv",
  "2013_2023" = "C:/Users/user1/Documents/ESCResults/ESC_2013_2023.csv"
)

# Load data frames
dataframes <- lapply(file_paths, read_csv)

# Apply descriptive statistics function to each data frame
descriptive_summaries <- lapply(dataframes, descriptive_stats)

# Print descriptive statistics summaries
descriptive_summaries
