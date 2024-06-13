# Load necessary libraries
library(igraph)
library(dplyr)
library(readr)

# Function to create and save network graphs
create_network_graph <- function(file_path, period) {
  data <- read_csv(file_path)
  
  # Create the network graph
  edges <- data %>%
    filter(collusion == TRUE) %>%
    select(from, to)
  
  # Create an igraph object
  graph <- graph_from_data_frame(d = edges, directed = TRUE)
  
  # Plot the network graph
  png(paste0("C:/Users/user1/Documents/ESCResults/network_graph_", period, ".png"), width = 800, height = 800)
  plot(graph, vertex.size=15, vertex.label.cex=0.8, edge.arrow.size=0.5, main=paste("Collusive Voting Network", period))
  dev.off()
}

# Create and save network graphs for each period
period_files <- list.files(path = "C:/Users/user1/Documents/ESCResults", pattern = "collusion_detected_ESC_.*\\.csv", full.names = TRUE)
for (file in period_files) {
  period <- gsub("collusion_detected_ESC_|.csv", "", basename(file))
  create_network_graph(file, period)
}
