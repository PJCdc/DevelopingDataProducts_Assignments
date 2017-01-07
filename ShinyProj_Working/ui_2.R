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
lstYear <- c("2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")

# Define UI for application that draws a histogram
# "Average Close" = "avgClose")
# p("Indicator Descriptions"),
# p("Average over a 50-day window"),
# p("Average over a 20-day window"),
# tagList(tags$ul(),
#         tags$li("50-SMA"),
#         tags$li("20-SMA"))


shinyUI(
  fluidPage(
    titlePanel("Interactive Stock Chart"),
    
    fluidRow(
      column(3,
             selectInput("selectStock",
                         label = "Select Stock / Index:",
                         choices = stockSymbols$Display,
                         # choices = c("AMZN", "GOOGL", "IBM"),
                         selected = "AMZN"),
             
             selectInput("selectYear",
                         label = "Select Year: ",
                         choices = lstYear,
                         selected = "2016")
      ),
      
      column(3,
             radioButtons("selectSlowMA", "Slow Moving Average:",
                                choices = c("Simple 50-day Moving Wndow" = "sma50",
                                            "Weighted 50-day Moving Wndow" = "wma50")
                                )
             
             
             ),
      
      column(4,
             radioButtons("selectFastMA", "Fast Moving Average:",
                                choices = c("Simple 20-day Moving Wndow" = "sma20",
                                            "Weighted 20-day Moving Wndow" = "wma20")
                                )
             )
      
      
      
    ),
    
    h3("Insert Chart Here")
    
    
    
  )
)
  

  
  
  








