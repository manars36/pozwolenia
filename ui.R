
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)



shinyUI(
    
    navbarPage("Pozwolenia na budowę", id="nav",
        tabPanel("Mapa interaktywna",
                div(class="outer",
                    tags$head(
                        # Include our custom CSS
                        includeCSS("styles.css"),
                        includeScript("gomap.js")
                    ),
                    
                leafletOutput("map", width="100%", height="100%"),
                
                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                              width = 300, height = "auto",
                              
                              h2("Eksplorer danych"),
                              
                              # 
                              # sliderInput("dat", h3("Zakres dat złożenia wniosku"), min = as.Date("2008-01-01"), max = as.Date("2016-12-31"),
                              #             value = c(as.Date("2008-01-01"), as.Date("2016-12-31")), step = 30),

                              
                              plotOutput("histCzasy", height = 350)
    
                ),
                
                
                tags$div(id="cite",
                         'Dane pochodzą ze strony ', tags$em('http://www.wroclaw.pl/open-data/')
                         )
                    )
               )
            )
)


