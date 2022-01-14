library(shiny)
library(shinydashboard)
library(raster)
library(rgdal)
library(ggplot2)
library(rasterVis)
library(viridis)
library(ggthemes)
library(dplyr)
library(reshape2)
library(leaflet)

# install and load packages

pck <- c("shiny","shinydashboard","rgdal","ggplot2","raster","viridis","ggthemes","rasterVis","dplyr","reshape2","leaflet")
new_pck <- pck[!pck %in% installed.packages()[,"Package"]] # checking which packages that doesn't exist
if(length(new_pck)){install.packages(new_pck)}             # install package that doesn't exist
sapply(pck, require, character.only = T)                   # load the packages

#----User interface---------------------------------------------------------------------
# header
header <- dashboardHeader(
  title = "Select Information"
)
# sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Tabular', tabName = 'tabular', icon = icon('chart-line')),
    menuItem('Spatial', tabName = 'spatial', icon = icon('map'))
  )
)
# body
body <- dashboardBody(
  title = "Hansen Tree Cover Loss 2001 - 2020",
  tabItems(
    # first tab content
    tabItem(tabName = 'tabular',
            fluidRow(
              box(
                plotOutput("plot1")
              ),
              box(background = "navy",
                selectInput("zone", "Zone Selection",
                            list("All Zones", "Zone 1", "Zone 2", "Zone 3")
                )
              ),
              box(background = "navy",title = "Loss Year",
                  sliderInput("range", "Select Year",
                              min = 2001,
                              max = 2020,
                              value = c(2005, 2010)
                  )
              )
            ),
            fluidRow(
              box(title = "Potential Loss Area (Ha)",
                  tableOutput("table1"),
                  downloadButton("download", "Download")
              ),
              box(title = "Trend of Potential Loss (Ha)",
                plotOutput("plot2")
              )
            ),
    ),
    # second tab content
    tabItem(tabName = 'spatial',
            leafletOutput("leafplot", height = 800)
    )
  )
)

ui <- dashboardPage(
  header,
  sidebar,
  body
)
#-----------------------------------------------------------------------------------------------------
server <- function(input, output) {
#----Loading dataset----------------------------------------------------------------------------------
  # raster
  r_dayun <- raster("/Users/bramudya/Documents/R/Calculating pixels inside polygons/raster/Dayun_TCL2020.tif")
  # vector
  p_dayun <- readOGR("/Users/bramudya/Documents/R/Calculating pixels inside polygons/shp/DayunII.shp")
  # years
  Year <- as.character(c(seq(2000,2020, 1)))
  # list of polygons from vector
  list_zone <- split(p_dayun, p_dayun$Zone)
  
#----Masking-------------------------------------------------------------------------------------------
  # masking is needed to calculate area inside polygon
  # I cannot calculate raster area inside mask if directly masked from original raster for some reason
  # That is why I cropped it first before masking
#------------------------------------------------------------------------------------------------------
  # cropping raster inside vector
  cropped_dayun <- crop(r_dayun, extent(p_dayun))
  # masking
  masked_dayun <- mask(cropped_dayun, p_dayun)
  # masked raster for each zone
  list_masked <- lapply(list_zone, function (a) {mask(cropped_dayun, a)})
  # input dayun in the list
  list_masked <- c(list_masked,masked_dayun)
  # rename the new list to 'All' zone
  names(list_masked)[[4]] <- "All"
  
#----Reading pixels inside polygons and transform it into spatial pixel data frame---------------------
  list_masked_spdf <- lapply(list_masked, function (b) {as(b, "SpatialPixelsDataFrame")})
  
#---Transform SPDF into data frame---------------------------------------------------------------------
  list_masked_df <- lapply(list_masked_spdf, function (c) {as.data.frame(c)})
  
#---Delete column for the year 0 because that year is the baseline----------------------------------
  list_masked_df <- lapply(list_masked_df, function(e) {e[e$Dayun_TCL2020>0,]})
  
#----Changing colnames inside list of data frame-------------------------------------------------------
  colnames_loss <- c("LossYear", "x", "y")
  list_masked_df <- lapply(list_masked_df, setNames, colnames_loss)
  
#---Changing the year column---------------------------------------------------------------------------
  list_masked_df <- lapply(list_masked_df, function(d) {cbind(d[1]+2000, d[-1])})

  
#----Calculate loss area based on pixel size and value each zone---------------------------------------
  list_lossarea <- lapply(list_masked, function(f) {data.frame(tapply(area(f), f[], sum))})
  # the result in this calculation is in metre square because both vector and raster is is using UTM
  # projection
  
#----Calculate the loss into Ha and round it-----------------------------------------------------------
  list_lossarea <- lapply(list_lossarea, function (g) {data.frame(round(g/10000, 2))})

#----Color palete for leaflet map----------------------------------------------------------------------
  pal = colorNumeric(c("blue","green","yellow","orange","red"), values(masked_dayun), 
                     na.color = "transparent")
  
#----Adding a row in Zone 3 since there is no data at Row 3--------------------------------------------
  # skipping this step will result failure in making combined_loss data 
#------------------------------------------------------------------------------------------------------
  # create a function of row addition
  insertRow <- function(existingDF, newrow, r) {
    existingDF[seq(r+1,nrow(existingDF)+1),] <- existingDF[seq(r,nrow(existingDF)),]
    existingDF[r,] <- newrow
    return (existingDF)
  }
  row4 <- 4
  newrow <- 0
  # extract zone 3
  z3 <- list_lossarea$Zone3
  # insert row
  z3 <- insertRow(z3, newrow, row4)

#----Combine data frame of all loss zones
  combined_loss <- cbind(Year, list_lossarea$All, list_lossarea$Zone1, list_lossarea$Zone2, z3)
  colnames(combined_loss) <- c("Year", "All Zones", "Zone 1", "Zone 2", "Zone 3")
  
#----Rendering----------------------------------------------------------------------------------------
  # draw zone selection
  output$plot1 <- renderPlot({
    if(input$zone == "All Zones"){
      ggplot()+
        geom_tile(data = list_masked_df$All, aes(x=x, y=y, fill=LossYear), alpha= 0.8)+
        ggtitle("All Zones")+
        scale_fill_viridis()+
        coord_equal()+
        theme_map()+
        theme(legend.position = "bottom") +
        theme(legend.key.width = unit(2, "cm"))+
        theme(plot.title = element_text(face = "bold", size = (20)))
      
    }
    else if(input$zone == "Zone 1"){
      ggplot()+
        geom_tile(data = list_masked_df$Zone1, aes(x=x, y=y, fill=LossYear), alpha= 0.8)+
        ggtitle("Zones 1")+
        scale_fill_viridis()+
        coord_equal()+
        theme_map()+
        theme(legend.position = "bottom") +
        theme(legend.key.width = unit(2, "cm"))+
        theme(plot.title = element_text(face = "bold", size = (20)))
    }
    else if(input$zone == "Zone 2"){
      ggplot()+
        geom_tile(data = list_masked_df$Zone2, aes(x=x, y=y, fill=LossYear), alpha= 0.8)+
        ggtitle("Zones 2")+
        scale_fill_viridis()+
        coord_equal()+
        theme_map()+
        theme(legend.position = "bottom") +
        theme(legend.key.width = unit(2, "cm"))+
        theme(plot.title = element_text(face = "bold", size = (20)))
    }
    else if(input$zone == "Zone 3"){
      ggplot()+
        geom_tile(data = list_masked_df$Zone3, aes(x=x, y=y, fill=LossYear), alpha= 0.8)+
        ggtitle("Zones 3")+
        scale_fill_viridis()+
        coord_equal()+
        theme_map()+
        theme(legend.position = "bottom") +
        theme(legend.key.width = unit(2, "cm"))+
        theme(plot.title = element_text(face = "bold", size = (20)))
    }
  })
#----Plot Table----------------------------------------------------------------------
  output$table1 <- renderTable(
    combined_loss %>% filter(Year >= input$range[1] & Year <= input$range[2])
  )
#----Downloadable table--------------------------------------------------------------
  output$download <- downloadHandler(
    filename = function(){
     paste("All LossYears", ".csv", sep = "") 
    },
    content = function(file){
      write.csv(combined_loss[-1,], file)
    }
  )
#----Plot Trend Analysis-------------------------------------------------------------
  output$plot2 <- renderPlot(
    combined_loss %>% melt(id.vars = "Year") %>%
      filter(Year >= input$range[1] & Year <= input$range[2]) %>%
        ggplot(aes(x=Year, y = value, fill = variable, colour = variable)) +
          geom_bar(stat = "identity", position = "dodge")
)
#----Plot Spatial--------------------------------------------------------------------
  output$leafplot <- renderLeaflet({
    leaflet() %>% addTiles() %>%
      addRasterImage(masked_dayun, colors = pal, opacity = 0.4) %>%
      addLegend("bottomright", pal = pal, values = values(masked_dayun))
  })
  
}

shinyApp(ui, server)

