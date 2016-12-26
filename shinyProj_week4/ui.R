#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyBS)
load(file = "plotlyStocks.RData")

# Define UI for application that draws a histogram


shinyUI(
  fluidPage(
    titlePanel("Stock Performance Review"),
    
    fluidRow(
      column(3,
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
      
      column(3,
             checkboxGroupInput("selectIndicators", "Select Indicators:",
                                choices = c("50-day Simple Moving Averge" = "sma50",
                                            "20-day Simple Moving Average" = "sma20",
                                            "50-day Weighted Moving Average" = "wma50",
                                            "20-day Weighted Movinr Average" = "wma20",
                                            "Average Close" = "avgClose")
                                )
             
             ),
      column(4,
             p("Indicator Descriptions"),
             p("Average over a 50-day window"),
             p("Average over a 20-day window"),
             
             tagList(tags$ul(),
                     tags$li("50-SMA"),
                     tags$li("20-SMA"))
             )
      
      
      
    )
    
    
  )
)
  

  
  
  








