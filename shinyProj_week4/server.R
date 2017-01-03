#



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  tempYear <- reactive({input$selectYear})
  slowMA <- reactive({input$selectSlowMA})
  fastMA <- reactive({input$selectFastMA})
  pickYear <- reactive({as.IDate(tempYear(), format = "%Y")})
  pickID <- reactive({
    txtStock <- input$selectStock
    filter(symbols,Display == txtStock)$altTicker
    })
  
  pltTitle <- reactive({
    txtTicker <- pickID()
    tickerInfo <- filter(symbols, altTicker == txtTicker)
    paste0(tickerInfo$Display, " Price Chart for ", tempYear())
    })
  
  
  output$chartTitle <- renderText(pltTitle())
  
  
  dtPlotSelection <- reactive({
    dtSelect <- data.table(Year = year(pickYear()), ID = pickID())
    dtPlotSelection <- dtPriceData[dtSelect, on = c("Year", "ID")] 
    # as.character(dtPriceData[5,6])
    # Compute moving averages, returns
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
                                      "Slow MA: ", slowMA(), ": ", sprintf("%.2f",eval(as.name(slowMA()))),
                                      "<br>",
                                      "Fast MA: ", fastMA(), ": ", sprintf("%.2f",eval(as.name(fastMA()))))] 
                                      
    
    })
  
  
  output$stockChart <- renderPlotly(
    plot_ly(dtPlotSelection(), x = ~Date, xend = ~Date,
            colors = c("red", "forestgreen"), text = ~hText, 
            hoverinfo = 'none') %>%
      add_segments(y = ~Low, yend = ~High, size = I(1), 
                   color = ~Close > Open, showlegend = FALSE) %>%
      add_segments(y = ~Open, yend = ~Close, size = I(4), 
                   color = ~Close > Open, showlegend = FALSE) %>%
      add_lines(y = ~eval(as.name(fastMA())), color = I("orange"), 
                name = "Fast MA - 20 bars") %>%
      add_lines(y = ~eval(as.name(slowMA())), color = I("blue"), 
                name = "Slow MA - 50 bars") %>%
      add_lines(y = ~Close,  opacity = 0, hoverinfo = 'x+text' , showlegend = FALSE) %>%
      layout(yaxis = list(title = "Price"))
  )
  
  

  
})
