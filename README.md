# Interactive Data Visualization with R Shiny, ggplot2, and Leaflet

This repository contains an interactive data visualization project using R, ggplot2, Leaflet, and Shiny. The project explores a dataset of frog observations from the state of Victoria, Australia, focusing on observations from 2000-2018 within specific local government areas (LGAs).

## Project Overview
The primary goal is to create an interactive visualization that displays spatial and tabular data related to frog observations in the LGAs of Monash, Knox, Whitehorse, and Maroondah. The visualization incorporates ggplot2 and Leaflet for static and interactive elements, with R Shiny managing the overall layout and interactivity.

## Files in the Repository
- `PE2_31940757.R`: The R script(s) for the Shiny application, including the ggplot2 and Leaflet visualizations.
- `PE2_frog_data.csv`: The dataset used for this project, containing records of frog observations from 2000-2018.

## Project Structure
The project involves the following components:
1. **Interactive Proportional Symbol Map (Leaflet)**: Displays spatial positions of observed frog genera, with features like sliders for range selection, checklists for filtering, and tooltips for symbol details.
2. **Static Visualizations (ggplot2)**: 
   - `VIS 1`: Shows the number of observations for each frog genus and their preferred terrain.
   - `VIS 2`: Displays the hours in which observations occurred for the top four frog genera.

3. **Shiny Application**: Combines the interactive map and static visualizations into a single layout. Descriptions are provided for each visual and textual component, explaining the context, data interpretation, and design choices.

## How to Run the Project
To run the Shiny application, follow these steps:
1. Ensure you have the required R packages installed (e.g., Shiny, ggplot2, Leaflet, dplyr).
2. Open RStudio and load the R script.
3. Click "Run App" to launch the Shiny application.
4. Interact with the application using the provided controls, including the range slider, checklists, and visualization elements.
