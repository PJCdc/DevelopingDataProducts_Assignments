#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# load(file = "plotlyStocks.RData")


shinyUI(
  fluidPage(
    #titlePanel("Interactive Stock Chart"),
    h1("Interactive Stock Chart", style = "color: DarkGreen ;"),
    tags$hr(style = "border-width: 4px; border-color: steelblue;"),
    
    wellPanel(
    fluidRow(
      column(4,
             selectInput("selectStock",
                         label = "Select Stock / Index:",
                         choices = symbols$Display,
                         # choices = c("AMZN", "GOOGL", "IBM"),
                         selected = "AMZN"),
             
             selectInput("selectYear",
                         label = "Select Year: ",
                         choices = lstYear,
                         selected = "2016")
      ),
      
      column(4,
             radioButtons("selectSlowMA", "Slow Moving Average:",
                                choices = c("Simple 50-day Moving Wndow" = "sma50",
                                            "Weighted 50-day Moving Wndow" = "ema50")
                                )
             
             
             ),
      
      column(4,
             radioButtons("selectFastMA", "Fast Moving Average:",
                                choices = c("Simple 20-day Moving Wndow" = "sma20",
                                            "Weighted 20-day Moving Wndow" = "ema20")
                                )
             ),
      
      column(7, div(style = "border: 2px solid steelBlue; padding: 5px;",
             em(strong("Simple Moving Average: ")), "All values in the window have equal weight",
                       br(),
                       em(strong("Weighted Moving Average: ")), "Recent values in the window
                       carry more weight than early values"
             )
             
             )
      
      
      
    )
    ),
    
    tags$hr(style = "border-width: 4px; border-color: steelblue;"),
    
    h3(textOutput("chartTitle"), style = "color: DarkGreen ;"),
    
    plotlyOutput(("stockChart")
    
    # steelblue  midnightblue
    
  )
)
)
  

  
  
  








