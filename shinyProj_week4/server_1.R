#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# library(shiny)
# library(shinyBS)
# library(plotly)

load(file = "plotlyStocks.RData")

# selection examples (Put in renderPlotly function!!)
tempYear <- "2010"
pickYear <- as.IDate(tempYear, format = "%Y")
pickID <- "AMZN"
pickMAtype <- "ema"
slowMA <- paste0(pickMAtype, "20")
fastMA <- paste0(pickMAtype, "50")
pltTitle <- filter(stockSymbols, Ticker == pickID)
pltTitle <- paste0(pltTitle$Display, " Price Chart for ", tempYear)


dtSelect <- data.table(Year = year(pickYear), ID = pickID)
dtPlotSelection <- dtPriceData[dtSelect, on = c("Year", "ID")]

# Compute moving averages, returns (Put in renderPlotly function!!)
tempID <- dtPlotSelection[,unique(ID)]
tempClose <- as.xts(dtPlotSelection[,.(Date,Close)])

dRet <- as.vector(periodReturn(tempClose, period='daily')$daily.returns)

dtPlotSelection[,`:=` (dailyRet = dRet,
                       cumRet = cumsum(dRet),
                       sma20 = SMA(Close,20),
                       sma50 = SMA(Close,50),
                       ema20 = EMA(Close,20),
                       ema50 = EMA(Close,50))]

dtPlotSelection[, hText := paste0("Open: ", sprintf("%.2f",Open)," / ", 
                                  "High: ", sprintf("%.2f",High), "<br>",
                                  "Low: ", sprintf("%.2f",Low), " / ", 
                                  "Close: ",sprintf("%.2f",Close), "<br>",
                                  fastMA, ": ", sprintf("%.2f",eval(as.name(fastMA))), " / ",
                                  slowMA, ": ", sprintf("%.2f",eval(as.name(slowMA))))]

plot_ly(dtPlotSelection, x = ~Date, xend = ~Date,
        colors = c("red", "forestgreen"), text = ~hText, hoverinfo = 'none') %>%
  add_segments(y = ~Low, yend = ~High, size = I(1), color = ~Close > Open) %>%
  add_segments(y = ~Open, yend = ~Close, size = I(4), color = ~Close > Open) %>%
  add_lines(y = ~eval(as.name(fastMA)), color = I("orange"), name = "Fast MA - 20 bars") %>% 
  add_lines(y = ~eval(as.name(slowMA)), color = I("blue"), name = "Slow MA - 50 bars") %>% 
  add_lines(y = ~Close,  opacity = 0, hoverinfo = 'x+text' , showlegend = FALSE) %>% 
  layout(title = pltTitle, showlegend = TRUE, yaxis = list(title = "Price"))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$stockPlot <- renderPlotly(pChart)
#   output$stockPick <- renderText({input$selectStock})
#   output$indexPick <- renderText({input$selectIndex})
  
  
  # output$userPick <- c(tempStock," & ", tempIndex)
  
  
})
