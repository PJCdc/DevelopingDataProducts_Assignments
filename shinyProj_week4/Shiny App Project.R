
# "C:\Users\TCarroll\OneDrive - TMC\GitRepos\DevelopingDataProducts_Assignments"
# setwd("C:/Users/TCarroll/OneDrive - TMC/GitRepos/DevelopingDataProducts_Assignments")
# getwd()


library(quantmod)
library(PerformanceAnalytics)
library(TTR)
library(lubridate)
library(plotly)
library(tidyr)
library(dplyr)
library(data.table)
library(dtplyr)

from="2008-01-01"
to="2016-12-30"
lstYear <- sort(seq(year(from), year(to)), decreasing = TRUE)


# symbols <- c("XLB", #SPDR Materials sector
#              "XLE", #SPDR Energy sector
#              "XLF", #SPDR Financial sector
#              "XLP", #SPDR Consumer staples sector
#              "XLI", #SPDR Industrial sector
#              "XLU", #SPDR Utilities sector
#              "XLV", #SPDR Healthcare sector
#              "XLK", #SPDR Tech sector
#              "XLY", #SPDR Consumer discretionary sector
#              "RWR", #SPDR Dow Jones REIT ETF
#              
#              "EWJ", #iShares Japan
#              "EWG", #iShares Germany
#              "EWU", #iShares UK
#              "EWC", #iShares Canada
#              "EWY", #iShares South Korea
#              "EWA", #iShares Australia
#              "EWH", #iShares Hong Kong
#              "EWS", #iShares Singapore
#              "IYZ", #iShares U.S. Telecom
#              "EZU", #iShares MSCI EMU ETF
#              "IYR", #iShares U.S. Real Estate
#              "EWT", #iShares Taiwan
#              "EWZ", #iShares Brazil
#              "EFA", #iShares EAFE
#              "IGE", #iShares North American Natural Resources
#              "EPP", #iShares Pacific Ex Japan
#              "LQD", #iShares Investment Grade Corporate Bonds
#              "SHY", #iShares 1-3 year TBonds
#              "IEF", #iShares 3-7 year TBonds
#              "TLT" #iShares 20+ year Bonds
# )

# Prepare data file of stock data

stockID <- c("AMZN", "IBM", "MSFT", "AAPL")
stockName <- c("Amazon", "IBM", "Microsoft", "Apple")
stockType <- rep("stock", length(stockID))
stockSymbols <- data.frame(Ticker = stockID, Name = stockName, Type = stockType,
                           stringsAsFactors = FALSE)
stockSymbols$Display <- paste(stockSymbols$Ticker, " - ", stockSymbols$Name)


indexID <- c("^DJI", "^IXIC", "^GSPC")
indexName <- c("Dow Industrials", "Nasdaq Composite", "S&P 500")
indexType <- rep("index", length(indexID))
indexSymbols <- data.frame(Ticker = indexID, Name = indexName, Type = indexType,
                           stringsAsFactors = FALSE)
indexSymbols$Display <- paste(indexSymbols$Ticker, " - ", indexSymbols$Name)


symbols <- rbind(stockSymbols, indexSymbols)
symbols <- mutate(symbols, altTicker = gsub("\\^", "", symbols$Ticker))


getSymbols(symbols$Ticker, from=from, to=to, src="yahoo", adjust=TRUE)

# Create data.table for each stock and index

testTick <- gsub("\\^", "", symbols$Ticker)

tickerList <- character()
tickerDTlist <- list()

for(tick in testTick) {
  tickSymbol <- paste0("dt", tick, "prices")
  tickerList <- c(tickerList,tickSymbol)
  
  assign(tickSymbol, as.data.table(eval(as.name(tick))))
  eval(as.name(tickSymbol))[,ID := tick]
  oldColNames <- names(eval(as.name(tickSymbol)))
  newColNames <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted", "ID")
  setnames(eval(as.name(tickSymbol)), oldColNames, newColNames)
  colOrder <- c("Date", "ID","Open", "High", "Low", "Close", "Volume", "Adjusted")
  setcolorder(eval(as.name(tickSymbol)), colOrder)

  eval(as.name(tickSymbol))[, `:=` (Volume = NULL,
                       Adjusted = NULL)]
  

}


lstPriceData <- lapply(tickerList, function(x) eval(as.name(x)))
dtPriceData <- rbindlist(lstPriceData)

dtPriceData[,Year := year(Date)]

# dtPriceData is data file to geneate stock chart
# Save data for App to load  
save(from, to,
     lstYear,
     symbols, 
     dtPriceData,
     file = "plotlyStocks.RData")




# selection examples:
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


# Plot Example

# formatC(x, digits = 2, format = "f")
# sprintf("%.2f", pi)


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




# Save data for App to load  
# save(from, to,
#      lstYear,
#      symbols, 
#      dtPriceData,
#      file = "plotlyStocks.RData")
# 
# load(file = "plotlyStocks.RData")  
  

# dtSelect <- data.table(ID = c("AMZN", "IBM"), variable = "Close")
# 
# dtPricesLong[year(Date) == "2008" & ID == "AMZN" & variable == "Close",]
# dtPricesLong[month(Date) == "1" & ID == "AMZN" & variable == "dailyRet",]
# 
# dtPricesLong[dtSelect, on = c("ID", "variable")]
# dtPricesLong[dtSelect, on = c("ID")]

dtPricesLong <- melt(temp, id.vars = c("Date", "ID"), measure.vars = 3:12)



# selection examples:

dtSelect <- data.table(ID = c("AMZN", "IBM"), variable = "Close")

dtPricesLong[year(Date) == "2008" & ID == "AMZN" & variable == "Close",]
dtPricesLong[month(Date) == "1" & ID == "AMZN" & variable == "dailyRet",]

dtPricesLong[dtSelect, on = c("ID", "variable")]
dtPricesLong[dtSelect, on = c("ID")]

# Plot Example

pltDate <- as.data.frame(temp[ID == "AMZN" & year(Date) == "2016"])

plot_ly(pltDate, x = ~Date, xend = ~Date,
        colors = c("red", "forestgreen"), hoverinfo = "none") %>%
  add_segments(y = ~Low, yend = ~High, size = I(1), color = ~Close > Open) %>%
  add_segments(y = ~Open, yend = ~Close, size = I(6), color = ~Close > Open) %>%
  add_lines(y = ~sma20, color = I("orange")) %>% 
  add_lines(y = ~sma50, color = I("blue")) %>% 
  layout(showlegend = FALSE, yaxis = list(title = "Price"))



# Code for Stock Chart - Candlesticks
# Using segments
# From plotly book online at
# https://cpsievert.github.io/plotly_book/scatter-traces.html

library(quantmod)

msft <- getSymbols("MSFT", auto.assign = F)
dat <- as.data.frame(msft)
dat$date <- index(msft)
dat <- subset(dat, date >= "2016-01-01")

names(dat) <- sub("^MSFT\\.", "", names(dat))

plot_ly(dat, x = ~date, xend = ~date, color = ~Close > Open, 
        colors = c("red", "forestgreen"), hoverinfo = "none") %>%
  add_segments(y = ~Low, yend = ~High, size = I(1)) %>%
  add_segments(y = ~Open, yend = ~Close, size = I(3)) %>%
  layout(showlegend = FALSE, yaxis = list(title = "Price")) %>%
  rangeslider()



# Old Code 
dtCloseDJI <- as.data.table(Cl(DJI), keep.rownames = TRUE)
dtCloseNAS <- as.data.table(Cl(IXIC), keep.rownames = TRUE)
dtCloseSP <- as.data.table(Cl(GSPC), keep.rownames = TRUE)

dtClosePrices <- copy(dtCloseAMZN)
dtClosePrices <- dtClosePrices[dtCloseDJI, on = "index"]
dtClosePrices <- dtClosePrices[dtCloseNAS, on = "index"]
dtClosePrices <- dtClosePrices[dtCloseSP, on = "index"]

oldColNames <- c("index", "AMZN.Close", "DJI.Close", "IXIC.Close", "GSPC.Close")
newColNames <- c("Date", "AMZM", "DJI", "IXIC", "GSPC")
setnames(dtClosePrices, oldColNames, newColNames)





dCLoseSymbolsWide <- cbind(dCloseAMZN, dCloseDJI, dCloseNAS, dCloseSP)
dCLoseSymbols <- gather(dCLoseSymbolsWide, index, price) %>% mutate(Date = rep(dateCLose$Date,4))

  
dailyReturnsAMZN <- as.data.frame(periodReturn(AMZN,period='daily'), row.names = FALSE)
colnames(dailyReturnsAMZN) <- c("dReturnsAMZN")
dailyReturnsAMZN <- mutate(dailyReturnsAMZN, cReturnAMZN = cumsum(dReturnsAMZN))
dailyReturnsAMZN <- transmute(dailyReturnsAMZN, AMZN = 100 * cReturnAMZN)

dailyReturnsDJI <- as.data.frame(periodReturn(DJI,period='daily'), row.names = FALSE)
colnames(dailyReturnsDJI) <- c("dReturnsDJI")
dailyReturnsDJI <- mutate(dailyReturnsDJI, cReturnDJI = cumsum(dReturnsDJI))
dailyReturnsDJI <- transmute(dailyReturnsDJI, DJI = 100 * cReturnDJI)

dailyReturnsNAS <- as.data.frame(periodReturn(IXIC,period='daily'), row.names = FALSE)
colnames(dailyReturnsNAS) <- c("dReturnsNAS")
dailyReturnsNAS <- mutate(dailyReturnsNAS, cReturnNAS = cumsum(dReturnsNAS))
dailyReturnsNAS <- transmute(dailyReturnsNAS, NAS = 100 * cReturnNAS)

dailyReturnsSP <- as.data.frame(periodReturn(GSPC,period='daily'), row.names = FALSE)
colnames(dailyReturnsSP) <- c("dReturnsSP")
dailyReturnsSP <- mutate(dailyReturnsSP, cReturnSP = cumsum(dReturnsSP))
dailyReturnsSP <- transmute(dailyReturnsSP, SP = 100 * cReturnSP)

dReturnsSymbols <- cbind(dailyReturnsAMZN, dailyReturnsDJI, dailyReturnsNAS, dailyReturnsSP)
dReturnsSymbols <- gather(dReturnsSymbols, index, returns) %>% mutate(Date = rep(dateCLose$Date,4))






#---
# From TTR package
# e.g.: SMA(x, n = 10, ...)

data(ttrc)
ema.20 <-   EMA(ttrc[,"Close"], 20)
sma.20 <-   SMA(ttrc[,"Close"], 20)
dema.20 <-  DEMA(ttrc[,"Close"], 20)
evwma.20 <- EVWMA(ttrc[,"Close"], ttrc[,"Volume"], 20)
zlema.20 <- ZLEMA(ttrc[,"Close"], 20)
alma <- ALMA(ttrc[,"Close"])
hma <- HMA(ttrc[,"Close"])

## Example of Tim Tillson's T3 indicator
T3 <- function(x, n=10, v=1) DEMA(DEMA(DEMA(x,n,v),n,v),n,v)
t3 <- T3(ttrc[,"Close"])

## Example of short-term instability of EMA
## (and other indicators mentioned above)
x <- rnorm(100)
tail( EMA(x[90:100],10), 1 )
tail( EMA(x[70:100],10), 1 )
tail( EMA(x[50:100],10), 1 )
tail( EMA(x[30:100],10), 1 )
tail( EMA(x[10:100],10), 1 )
tail( EMA(x[ 1:100],10), 1 )





