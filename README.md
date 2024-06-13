### Eurovision Song Contest Collusion Analysis

This project investigates potential collusive voting patterns in the Eurovision Song Contest (ESC). Collusion refers to countries unfairly voting for each other, potentially influencing the contest's outcome.

**Table of Contents**

[Project Overview](https://github.com/users/noelmifsud/projects/1/settings#project-overview)
[Files](https://github.com/users/noelmifsud/projects/1/settings#files)
[How to Run](https://github.com/users/noelmifsud/projects/1/settings#how-to-run)
[Results Interpretation](https://github.com/users/noelmifsud/projects/1/settings#results-interpretation)
[Disclaimer](https://github.com/users/noelmifsud/projects/1/settings#disclaimer)

**Project Overview**
This analysis uses statistical methods and network analysis to identify unusual voting patterns that could suggest collusion. It involves cleaning and processing the voting data, applying a Monte Carlo simulation to establish a baseline for comparison, and then visualizing the results through various outputs.

**Files**

R Scripts:

collusion_detection_code.R: The main script for data processing, analysis, and generating result files.
descriptive_statistics.R: Generates descriptive statistics of the voting data.
heatmaps_function.R: Creates heatmap visualizations of voting patterns.
network_graphs_function.R: Generates network graphs to illustrate relationships between countries.

Dataset:

ESCData.xlsx: The raw voting data for the ESC.

Results:

ESC_....csv: Tables showing all countries' voting patterns, highlighting potentially unusual relationships.
collusion_detected_ESC_....csv: Tables focusing only on countries with voting patterns strongly suggestive of collusion.
ESC Desc Statistics.csv: Summary statistics of the voting data.

Images:
Heatmap images (.png): Visual representations of voting patterns, highlighting unusual behavior.
Network graph images (.png): Visualizations of relationships between countries, particularly those suspected of collusion.

**How to Run**

**Prerequisites**: Ensure you have R and RStudio installed on your system.
_Install Packages_: Run the following command in R to install the necessary packages:

`install.packages(c("readxl", "dplyr", "tidyverse", "parallel", "ggplot2", "igraph"))`

_Execute Scripts:_ Run the R scripts in the order they appear in the "Files" section above. Ensure the file paths in the scripts are correctly set to your local directories.

**Results Interpretation**

ESC_....csv Files: Examine these to see the full voting patterns and identify any unusual relationships between countries.
collusion_detected_ESC_....csv Files: Focus on these tables to see the specific countries where the analysis indicates a high likelihood of collusion.
Descriptive Statistics: Use these to understand the overall voting behavior in the contest.
Heatmaps: Visually inspect the heatmaps to spot patterns and clusters of unusual voting.
Network Graphs: Analyze the network graphs to see how countries with unusual voting patterns are connected.

**Disclaimer**
_This project was developed as an academic exercise to explore data analysis techniques. While the results are interesting and may raise questions, they do not definitively prove collusion in the ESC. Further investigation and consideration of contextual factors would be required to draw firm conclusions_.
