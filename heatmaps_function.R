# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)

# Function to create a heatmap for collusion detection
create_heatmap <- function(df, period) {
  ggplot(df, aes(x = from, y = to, fill = collusion)) +
    geom_tile(color = "white") +
    scale_fill_manual(values = c("FALSE" = "white", "TRUE" = "red")) +
    labs(title = paste("Collusive Voting Patterns", period), x = "From Country", y = "To Country") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Load collusion data
period_files <- list.files(path = "C:/Users/user1/Documents/ESCResults", pattern = "collusion_.*\\.csv", full.names = TRUE)

# Create and save heatmaps for each period
for (file in period_files) {
  period <- gsub("collusion_|.csv", "", basename(file))
  collusion_data <- read_csv(file)
  heatmap <- create_heatmap(collusion_data, period)
  ggsave(filename = paste0("C:/Users/user1/Documents/ESCResults/heatmap_", period, ".png"), plot = heatmap)
}
