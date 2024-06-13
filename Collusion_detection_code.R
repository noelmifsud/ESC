# Install and load necessary libraries
if (!require("readxl")) install.packages("readxl")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("parallel")) install.packages("parallel")
library(readxl)
library(dplyr)
library(tidyverse)
library(parallel)

# File path for the data
file_path <- "C:/Users/user1/Documents/ESCData.xlsx"

# Read and inspect the data
esc_data <- read_excel(file_path)
print(colnames(esc_data))
head(esc_data)

# Clean the dataset by removing redundant columns and filtering out rows with 'x' in 'Duplicate' column
esc_data_cleaned <- esc_data %>%
  filter(!is.na(Year), !is.na(`From country`), !is.na(`To country`), !is.na(Points), is.na(Duplicate)) %>%
  mutate(Points = as.integer(Points)) %>%
  select(Year, `Year Edition` = `(semi-) final`, From = `From country`, To = `To country`, Points) %>%
  drop_na()

# Print the cleaned dataset column names to verify
print(colnames(esc_data_cleaned))
head(esc_data_cleaned)

# Function to detect collusion
# start_year: The beginning year of the period
# end_year: The ending year of the period
# data: The cleaned data
# scores: The possible scores that can be given
# simulations: The number of simulations to perform
collusion_detection <- function(start_year, end_year, data, scores = c(12, 10, 8, 7, 6, 5, 4, 3, 2, 1), simulations = 1000) {
  # Filter data for the given period
  range_data <- data %>%
    filter(Year >= start_year, Year <= end_year)
  
  # Get unique country pairs
  country_pairs <- unique(range_data[c('From', 'To')])
  country_pairs <- country_pairs %>% filter(From %in% range_data$To)
  
  results <- list() # Initialize a list to store results
  
  # Create a parallel cluster
  cl <- makeCluster(detectCores() - 1)
  clusterEvalQ(cl, library(dplyr))
  clusterExport(cl, varlist = c("range_data", "scores"), envir = environment())
  
  # Loop over each unique country pair
  for (i in 1:nrow(country_pairs)) {
    from_country <- country_pairs$From[i]
    to_country <- country_pairs$To[i]
    
    # Calculate the actual mean points awarded from from_country to to_country
    actual_mean <- range_data %>%
      filter(From == from_country, To == to_country) %>%
      summarise(mean_points = mean(Points, na.rm = TRUE))
    
    # Perform Monte Carlo simulations to generate expected voting patterns
    simulations_result <- parSapply(cl, 1:simulations, function(sim, data, scores, from_country, to_country) {
      sim_scores <- c()
      for (year in unique(data$Year)) {
        year_data <- filter(data, Year == year, From == from_country)
        if (nrow(year_data) > 0) {
          num_countries <- n_distinct(year_data$To)
          prob_points <- rep(1 / num_countries, length(scores))
          prob_no_points <- 1 - sum(prob_points)
          if (prob_no_points < 0) prob_no_points <- 0 # Ensure no negative probability
          scores_sim <- sample(c(scores, 0), size = 1, replace = TRUE, prob = c(prob_points, prob_no_points))
          sim_scores <- c(sim_scores, scores_sim)
        }
      }
      return(mean(sim_scores, na.rm = TRUE))
    }, range_data, scores, from_country, to_country)
    
    # Determine the 95th percentile of the simulated average points as the threshold
    sim_threshold <- quantile(simulations_result, probs = 0.95, na.rm = TRUE)
    
    # Compare the actual average points to the threshold to detect collusion
    if (actual_mean$mean_points > sim_threshold) {
      result <- list(from = from_country, to = to_country, average = actual_mean$mean_points, threshold = sim_threshold, collusion = TRUE)
      print(paste("Collusion detected from:", from_country, "to:", to_country))
    } else {
      result <- list(from = from_country, to = to_country, average = actual_mean$mean_points, threshold = sim_threshold, collusion = FALSE)
      print(paste("No collusion detected from:", from_country, "to:", to_country))
    }
    
    results[[length(results) + 1]] <- result # Append result to the results list
  }
  
  stopCluster(cl) # Stop the parallel cluster
  
  # Convert results to data frame and return
  results_df <- bind_rows(results)
  return(results_df)
}

# Define periods for analysis in 10-year intervals
periods <- list(
  '1963_1972' = c(1963, 1972),
  '1973_1982' = c(1973, 1982),
  '1983_1992' = c(1983, 1992),
  '1993_2002' = c(1993, 2002),
  '2003_2012' = c(2003, 2012),
  '2013_2023' = c(2013, 2023)
)

# File path for the results
file_path <- "C:/Users/user1/Documents/ESCResults/"

# Run analysis for each period and save results
for (period_name in names(periods)) {
  period <- periods[[period_name]]
  start_year <- period[1]
  end_year <- period[2]
  
  result <- collusion_detection(start_year, end_year, esc_data_cleaned)
  write_csv(result, paste0(file_path, "ESC_", period_name, ".csv"))
  print(paste("Collusion detected data saved for period:", period_name))
}
