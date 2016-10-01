
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

pozwolenia <- readRDS('data/pozwolenia.Rds')
 # pozwolenia <- pozwolenia[sample.int(nrow(pozwolenia), 2000),]

shinyServer(

    function(input, output, session) ({

            output$map <- renderLeaflet({
                leaflet() %>%
                    addTiles(
                        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
                    ) %>%
                    setView(lng = 17.08, lat = 51.1, zoom = 13) 
            })
            
            # pointsInDate <- reactive({
            #     subset(pozwolenia, Data.wniosku >= input$dat[1] & Data.wniosku <= input$dat[2])
            # })
            
            # A reactive expression that returns the set of zips that are
            # in bounds right now
            pointsInBounds <- reactive({
                if (is.null(input$map_bounds))
                    return(pozwolenia[FALSE,])
                bounds <- input$map_bounds
                latRng <- range(bounds$north, bounds$south)
                lngRng <- range(bounds$east, bounds$west)
                
                subset(pozwolenia,
                       lat >= latRng[1] & lat <= latRng[2] &
                           lon >= lngRng[1] & lon <= lngRng[2])
            })
            
            #histogram
             czasyAll <- pozwolenia$Czas.rozpatrzenia[order(pozwolenia$Czas.rozpatrzenia)]
             max1 <- round(length(czasyAll)*0.98)
             centileBreaks <- hist(plot = FALSE, czasyAll[1:max1], breaks = 20)$breaks
            # 
            
            output$histCzasy <- renderPlot({
                # If no zipcodes are in view, don't plot
                if (nrow(pointsInBounds()) == 0)
                    return(NULL)


                czasy <- pointsInBounds()$Czas.rozpatrzenia[order(pointsInBounds()$Czas.rozpatrzenia)]
                max <- round(length(czasy)*0.98)
                hist(czasy[1:max],
                     # breaks = centileBreaks,
                     main = "Rozkład czasów rozpatrzenia wniosków 
        (widoczne wnioski)",
                     xlab = "Czas rozpatrzenia",
                     ylab = "Ilość wniosków",
                     xlim = range(czasyAll[1:max1]),
                     col = '#00DD00',
                     border = 'black')
            })
            
            
            #dodawanie punktow
            observe({
                if(nrow(pozwolenia)==0) { leafletProxy("map", data = pozwolenia) %>% clearMarkerClusters() %>% clearMarkers()}
                else{
                    leafletProxy("map", data = pozwolenia) %>%
                        clearMarkers() %>%
                        clearMarkerClusters() %>%
                        addCircleMarkers(~lon, ~lat, radius=5,
                                   stroke=FALSE, fillOpacity=0.4) #, clusterOptions = markerClusterOptions())  #%>%
                    
                        
                    # addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                        #           layerId="colorLegend")
                    }
                    })
    })
)

