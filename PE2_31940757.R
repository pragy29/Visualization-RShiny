#Tidyverse for better transform and tidy presentation of data
library(tidyverse)
#Dplyr for easy data manipulation
library(dplyr)
#GGpplot2 for data visualization
library(ggplot2)
#Shiny for building web applications
library(shiny)
#Leaflet for creating dynamic online maps
library(leaflet)
#Lubridate for easy and fast processing of datetime datatypes
library(lubridate)

#---------------------- Data Cleaning and Manipulation--------------------------
#Reading frog PE2 data into dataframe
frog_pe2 <- read_csv("PE2_frog_data.csv")
#Extracting the date part from the Date column
frog_pe2$Date <- as.Date(frog_pe2$Date) 
#Extracting the datetime part of using Australia as a Time Zone
frog_pe2$Time_Start <- as.POSIXct(frog_pe2$Time_Start,tz = "Australia")
#Rounding up Longitude and Latitude value upto 3 decimal places
frog_pe2$Longitude <- round(frog_pe2$Longitude, digits = 3)
frog_pe2$Latitude <- round(frog_pe2$Latitude, digits = 3)

#-----------------------Data Visualization (Data VIS1)--------------------------

#Counting frogs by their terrain
frog_pe2_genera <- frog_pe2 %>%
  group_by(Habitat,Genus) %>%
  summarise(Genera_Count = n())

#Plotting a dodged bar graph to compare different frogs and
#their preferred terrain
vis1 <- ggplot(frog_pe2_genera, aes(x=Genus, y=Genera_Count, fill=Habitat))+
  geom_bar(stat="identity", position = "dodge")+
  geom_text(aes(label = Genera_Count), position = 
              position_dodge(width = 1), vjust = -1) +
  scale_fill_manual(values = c("royalblue3","springgreen3"))+
#Reference: https://stackoverflow.com/questions/67872482/dodged-bar-plot-in-r-based-on-to-columns-with-count-year-with-ggplot2
  labs(title = "Frogs: Genus and Preferred Terrains",
       y="Count of Frogs Observed",
       x="Type of Frog(Genus")+
  theme(plot.background = element_rect(fill = "mistyrose2")
        ,plot.title = element_text(color = "black", size = 12, face = "bold", 
                                  hjust = 0.5))+
  guides(fill=guide_legend(title="Terrain"))

#-----------------------Data Visualization (Data VIS2)--------------------------
# Grouping data based on Genus name
frog_pe2_total_count <- frog_pe2_genera %>%
  group_by(Genus) %>%
  summarise(Total_Genera_Count = sum(Genera_Count))

# Sorting Data in descending order of Total Count of Frogs for each Genus
frog_pe2_ordered <- frog_pe2_total_count %>%
  arrange(desc(Total_Genera_Count))

# Fetching Top 4 Genus with highest counts
frog_pe2_top4 <- head(frog_pe2_ordered, n = 4)

# Combining data to combine the count with the rest of the data 
merged_frog_pe2 <-merge(x = frog_pe2, y = frog_pe2_top4, by = "Genus",
                        all.x = FALSE)

# Hourly data for each genus name
frog_pe2_hourly <- merged_frog_pe2 %>%
  group_by(Genus, Time_Start) %>%
  summarise(Count = n(), .groups = "drop") %>%
  as.data.frame()

# Converting Time_Start column into datetime type
frog_pe2_hourly$Time_Start <- as.POSIXct(frog_pe2_hourly$Time_Start, 
                                         format = "%Y-%m-%d %H:%M:%S")

# Creating hourly bins for the grouped data
frog_pe2_hourly_grouped <- frog_pe2_hourly %>%
  group_by(Genus, Time_Start= cut(Time_Start, breaks = "hour")) %>%
  #Reference: https://stackoverflow.com/questions/42875556/r-how-to-use-cut-function-with-hour-break-on-time
  summarise(Count = sum(Count))

# Converting time bins into datetime type
frog_pe2_hourly_grouped$Time_Start <- as.POSIXct(
  frog_pe2_hourly_grouped$Time_Start, format = "%Y-%m-%d %H:%M:%S")

#Plotting hourly frog observations
vis2 <- ggplot(frog_pe2_hourly_grouped, aes(x = Time_Start, y = Count)) +
  geom_line(aes(color = Genus)) +
  scale_x_datetime(date_labels = "%H:%M")+
  labs(title = "Frogs: Genus and Hourly Observations",
       x = "Hour of the day", y = "Count of Frogs Observed") +
  theme(plot.background = element_rect(fill = "mistyrose2")
        ,plot.title = element_text(color = "black", size = 12, face = "bold", 
                                   hjust = 0.5))+
  guides(fill=guide_legend(title="Type of Frog(Genus)"))
#--------------------------------Mapping Data-----------------------------------
#Grouping data according to Genus and Location
mapping_df <- frog_pe2 %>%
  group_by(Genus, Longitude, Latitude) %>%
  summarise(Count = n(),.groups = "drop")%>%
  as.data.frame()
#Creating color palettes to associate the different Genus with different colors
colPal <- colorFactor(palette = "Dark2", domain=mapping_df$Genus)
#------------------------------------Shiny--------------------------------------
# Defining the UI component of the web page
ui<- fixedPage(
  
  # Title and project description Panel 
  titlePanel(
    wellPanel(h1("FROGS OBSERVED IN OUTER EASTERN MELBOURNE, 2000-2018", 
                 align = "center",
                 style = "font-size: 30px; text-decoration: underline;"),
              style = "background-color: #F0FFFF;")),
  
  wellPanel(h4("The frog census data provides information about different
               Frog Species observed around in Victoria. The aim of this project
               is to analyse the different Genus of frogs observed around the
               outer eastern Melbourne suburbs.",
               align = "justified",
               ),
            style = "background-color: #F0FFFF;"),
  
  # Panel1: Data Visualtion Task 1 and Map:
  fixedRow(
    # Panel for vis1 output
    column(width = 5,
           wellPanel( plotOutput('vis1_shiny'),
                      align = "center",
           style = "align-items: center; 
           background-color: #F0FFFF;")),
     
    column(width = 7,
           fixedRow(
             # Panel for slider input
             column(width = 6,
                    wellPanel(sliderInput("slidercount",
                                          label = h3("Observation Count"),
                                          min = 0, max = 50, 
                                          value =c(0,3),
                                          width = '500'),
                              style = "font-size: 12px; height: 200px; align-items: center;
                  overflow-y: scroll;
                  background-color: #F0FFFF;")
                    ),
             # Panel for genus choice list
             column(width = 6, 
                  wellPanel(checkboxGroupInput("genus",label = h4("Genus"),
                              choices = unique(frog_pe2$Genus)),
                  style = "font-size: 12px; height: 200px; align-items: center;
                  overflow-y: scroll;
                  background-color: #F0FFFF;")
                  )
           ),
           fixedRow(
             # Panel for leaflet interactive map
             column(width= 12,wellPanel(leafletOutput("genusmap",
                                                      width = '600'),
                                        style = "background-color: #F0FFFF;")
                                        ))
           )
  ),
  # Panel for Vis1 and Map description
  fixedRow(
    column(width = 12, wellPanel(
      h3("Frequency and location of frogs",
      align = "left",
      style = "font-size: 30px; text-decoration: underline;
      "), style = "background-color: #F0FFFF;"),
      fixedRow(
        column(width = 6, wellPanel(
          h4("The above visualistion shows a \"Dogded Bar Graph\" between number
             of frogs observed relative to their genus. This is also a measure
             of compare as to what is the preferred terrain for different types
             of frogs"),  style = "background-color: #F0FFFF;"
        )),
        column(width = 6, wellPanel(
          h4("The map above is the visual representation of different type
          of frog genus spotted at different locations. We can select the genus
          from the checklist which are needed to be analysed and also the slider
          sets the number of frogs spotted."),  
          style = "background-color: #F0FFFF;"
        ))
      )
      )
    ),
  #Panel for vis2 plot output and description
  fixedRow(
    column(width =12,
           wellPanel(h1("Observation Time",style = 
           "font-size: 30px; text-decoration: underline;"), 
           style = "background-color: #F0FFFF;"),
           fixedRow(
             column(width =6, wellPanel(
               h4("The adjacent visualisation depicts the timeseries trend in 
                  observations that have been recorded in an hourly fashion.
                  This plot compares count of top 4 genus having highest number 
                  of total observations against hour of the day it was observed.
                  "), style = "background-color: #F0FFFF;"
             )),
             column(width = 6,
                    wellPanel( plotOutput('vis2_shiny'),
                               align = "center",
                               style = "align-items: center;
                               background-color: #F0FFFF;"))
           )
           )
  )
)


#Server component for Shiny webpage
server <- function(input, output, session) {
  #Filtering the data based on the received input values for number of 
  #observations and type iof frog
  mapping_pe2_int <- reactive({mapping_df %>% 
      filter(as.numeric(Count) >= input$slidercount[1] & 
               as.numeric(Count)<= input$slidercount[2]
             & Genus %in% input$genus)
    
  })
  # Creating an interactive leaflet map according to the received inputs
  observeEvent( input, {
    output$genusmap <- renderLeaflet({
      leaflet(data = as.data.frame(mapping_pe2_int())) %>% addTiles() %>%
        addCircleMarkers(~Longitude, ~Latitude, radius = ~Count+0.5,
                         color =  ~colPal(Genus), 
                         popup = paste("Genus: ", 
                                       as.data.frame(mapping_pe2_int())$Genus,
                                       "<br>",
                                       "Count: ",
                                       as.data.frame(mapping_pe2_int())$Count,
                                       "<br>"  ))
    })
    })
  # Creating legend for the color coded values of the Genus
  observe({
    proxy <- leafletProxy("genusmap")
    
    # Get unique values from Genus column
    Genus <- unique( as.data.frame(mapping_pe2_int())$Genus)
    
    # Add legend to map
    proxy %>% addLegend(
      position = "bottomright",
      colors = colPal(Genus),
      labels = Genus,
      title = "Genus",
      opacity = 1
    )
  })

  # Rendering vis1 plot
  output$vis1_shiny <- renderPlot(vis1)
  # Rendering vis2 plot
  output$vis2_shiny <- renderPlot(vis2)
  
}

shinyApp(ui = ui, server = server)


# Other References:
# Other References
# 1. https://www.w3schools.com/cssref/css_colors.php
# 2. https://www.rdocumentation.org/packages/ggplot2/versions/3.4.1/topics/theme
# 3. https://www.youtube.com/watch?v=Q19cAn8x82Y
# 4. https://leafletjs.com/examples.html
# 5. https://www.codementor.io/@packt/producing-layout-in-rows-and-columns-with-shiny-qcjj8szq0
# 6. https://stackoverflow.com/questions/67872482/dodged-bar-plot-in-r-based-on-to-columns-with-count-year-with-ggplot2
# 7. https://stackoverflow.com/questions/7636733/r-ggplot2-plotting-hourly-data
# 8. https://dplyr.tidyverse.org/reference/group_by.html
