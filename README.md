# Frog Population Analysis with R Shiny

## Overview
This repository contains an R-based application designed to create interactive and static visualizations for analyzing a dataset of frog observations from Victoria, Australia. The project involves processing spatial and tabular data, generating various visualizations, and presenting the results using Shiny.

## Getting Started

### Prerequisites
- R with RStudio installed
- External libraries: `shiny`, `ggplot2`, `leaflet`, `dplyr`
- Dataset for frog observations in the state of Victoria (provided in the repository)

### Installation
- Clone the repository to your local machine:
  ```sh
  git clone https://github.com/pragy29/Visualization-RShiny
  ```
- Navigate to the cloned directory:
  ```sh
  cd Visualization-RShiny
  ```
### Setup
Ensure you have installed the required R libraries. You can use the following command in R to install them if needed:
```r
install.packages(c("shiny", "ggplot2", "leaflet", "dplyr"))
```
### Running the Application
To run the Shiny application, open PE2_31940757.R in RStudio and click "Run App". Ensure the dataset is in the same directory as your R script.

### Features
- Interactive Map: A Leaflet-based proportional symbol map showing frog observations with filtering options and tooltips.
- Static Visualizations: Graphs created with ggplot2 to show trends in frog observations and their preferred terrains.
- Shiny Application: Combines interactive maps and static visualizations into a single user-friendly interface.

### Usage
- Interactive Map: Use the range slider and checklist in the Shiny application to filter frog observations by genera and location.
- Static Visualizations: View graphs showing trends in frog observations over time and across different terrains.
- Data Analysis: Analyze frog observations by running the Shiny application and exploring the different visualizations.

### Authors
- [Pragy Parashar](https://github.com/pragy29)
