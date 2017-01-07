#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
load(file = "plotlyStocks.RData")

# Define UI for application that draws a histogram


shinyUI(fluidPage(
  titlePanel("Stock Performance Review"),
  # Application title
  
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("selectStock",
                  label = "Select Stock:",
                  choices = stockSymbols$Display,
                  # choices = c("AMZN", "GOOGL", "IBM"),
                  selected = "AMZN"),
      
      selectInput("selectIndex",
                  label = "Select Reference Index:",
                  choices = indexSymbols$Display,
                  # choices = c("DJI", "NAS", "SP500"),
                  selected = "DJI")
    ),
    
    mainPanel(width = 12,
              br(),
              br(),
              
              h4("You Selected:"),
              # splitLayout(textOutput("stockPick"), textOutput("indexPick")
              textOutput("stockPick"),
              textOutput("indexPick"),
              
              h4("T E S T"),
              em("Add tabsetPanel")
              
              
    )
  )
))


library(plotly)
library(shiny)
shiny::runApp(system.file("examples", "plotlyEvents", package = "plotly"))


R_LIBS_USER = "C:/Users/TCarroll/OneDrive - TMC/R/win-library/3.3"


"C:/Users/TCarroll/Documents/R/win-library/3.3"
"C:/Program Files/R/R-3.3.2/library"

