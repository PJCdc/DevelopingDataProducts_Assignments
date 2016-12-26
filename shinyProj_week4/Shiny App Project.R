
"C:\Users\TCarroll\OneDrive - TMC\GitRepos\DevelopingDataProducts_Assignments"
setwd("C:/Users/TCarroll/OneDrive - TMC/GitRepos/DevelopingDataProducts_Assignments")
getwd()


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
to="2016-11-22"


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

# symbols <- c("AMZN", "^DJI", "^IXIC", "^GSPC")

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


getSymbols(symbols$Ticker, from=from, to=to, src="yahoo", adjust=TRUE)

# Create data.table for each stock
# AMZN

dtAMZNprices <- as.data.table(AMZN)
dtAMZNprices[,ID := "AMZN"]
oldColNames <- names(dtAMZNprices)
newColNames <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted", "ID")
setnames(dtAMZNprices, oldColNames, newColNames)
colOrder <- c("Date", "ID","Open", "High", "Low", "Close", "Volume", "Adjusted")
setcolorder(dtAMZNprices, colOrder)

dtAMZNprices[, `:=` (Volume = NULL,
                     Adjusted = NULL)]

dRet <- as.vector(periodReturn(AMZN, period='daily')$daily.returns)

dtAMZNprices[,`:=` (dailyRet = dRet,
                    cumRet = cumsum(dRet),
                    sma20 = SMA(Close,20),
                    sma50 = SMA(Close,50),
                    ema20 = EMA(Close,20),
                    ema50 = EMA(Close,50))]
              

#IBM

dtIBMprices <- as.data.table(IBM)
dtIBMprices[,ID := "IBM"]
oldColNames <- names(dtIBMprices)
newColNames <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted", "ID")
setnames(dtIBMprices, oldColNames, newColNames)
colOrder <- c("Date", "ID","Open", "High", "Low", "Close", "Volume", "Adjusted")
setcolorder(dtIBMprices, colOrder)

dtIBMprices[, `:=` (Volume = NULL,
                     Adjusted = NULL)]

dRet <- as.vector(periodReturn(IBM, period='daily')$daily.returns)

dtIBMprices[,`:=` (dailyRet = dRet,
                    cumRet = cumsum(dRet),
                    sma20 = SMA(Close,20),
                    sma50 = SMA(Close,50),
                    ema20 = EMA(Close,20),
                    ema50 = EMA(Close,50))]


# MSFT

dtMSFTprices <- as.data.table(MSFT)
dtMSFTprices[,ID := "MSFT"]
oldColNames <- names(dtMSFTprices)
newColNames <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted", "ID")
setnames(dtMSFTprices, oldColNames, newColNames)
colOrder <- c("Date", "ID","Open", "High", "Low", "Close", "Volume", "Adjusted")
setcolorder(dtMSFTprices, colOrder)

dtMSFTprices[, `:=` (Volume = NULL,
                    Adjusted = NULL)]

dRet <- as.vector(periodReturn(MSFT, period='daily')$daily.returns)

dtMSFTprices[,`:=` (dailyRet = dRet,
                   cumRet = cumsum(dRet),
                   sma20 = SMA(Close,20),
                   sma50 = SMA(Close,50),
                   ema20 = EMA(Close,20),
                   ema50 = EMA(Close,50))]


#AAPL

dtAAPLprices <- as.data.table(AAPL)
dtAAPLprices[,ID := "AAPL"]
oldColNames <- names(dtAAPLprices)
newColNames <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted", "ID")
setnames(dtAAPLprices, oldColNames, newColNames)
colOrder <- c("Date", "ID","Open", "High", "Low", "Close", "Volume", "Adjusted")
setcolorder(dtAAPLprices, colOrder)

dtAAPLprices[, `:=` (Volume = NULL,
                     Adjusted = NULL)]

dRet <- as.vector(periodReturn(AAPL, period='daily')$daily.returns)

dtAAPLprices[,`:=` (dailyRet = dRet,
                    cumRet = cumsum(dRet),
                    sma20 = SMA(Close,20),
                    sma50 = SMA(Close,50),
                    ema20 = EMA(Close,20),
                    ema50 = EMA(Close,50))]


# Create data.table for each index

# DJI

dtDJIprices <- as.data.table(DJI)
dtDJIprices[,ID := "DJI"]
oldColNames <- names(dtDJIprices)
newColNames <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted", "ID")
setnames(dtDJIprices, oldColNames, newColNames)
colOrder <- c("Date", "ID","Open", "High", "Low", "Close", "Volume", "Adjusted")
setcolorder(dtDJIprices, colOrder)

dtDJIprices[, `:=` (Volume = NULL,
                     Adjusted = NULL)]

dRet <- as.vector(periodReturn(DJI, period='daily')$daily.returns)

dtDJIprices[,`:=` (dailyRet = dRet,
                    cumRet = cumsum(dRet),
                    sma20 = SMA(Close,20),
                    sma50 = SMA(Close,50),
                    ema20 = EMA(Close,20),
                    ema50 = EMA(Close,50))]


# NAS

dtNASprices <- as.data.table(IXIC)
dtNASprices[,ID := "NAS"]
oldColNames <- names(dtNASprices)
newColNames <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted", "ID")
setnames(dtNASprices, oldColNames, newColNames)
colOrder <- c("Date", "ID","Open", "High", "Low", "Close", "Volume", "Adjusted")
setcolorder(dtNASprices, colOrder)

dtNASprices[, `:=` (Volume = NULL,
                    Adjusted = NULL)]

dRet <- as.vector(periodReturn(IXIC, period='daily')$daily.returns)

dtNASprices[,`:=` (dailyRet = dRet,
                   cumRet = cumsum(dRet),
                   sma20 = SMA(Close,20),
                   sma50 = SMA(Close,50),
                   ema20 = EMA(Close,20),
                   ema50 = EMA(Close,50))]


# SP

dtSPprices <- as.data.table(GSPC)
dtSPprices[,ID := "SP"]
oldColNames <- names(dtSPprices)
newColNames <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted", "ID")
setnames(dtSPprices, oldColNames, newColNames)
colOrder <- c("Date", "ID","Open", "High", "Low", "Close", "Volume", "Adjusted")
setcolorder(dtSPprices, colOrder)

dtSPprices[, `:=` (Volume = NULL,
                    Adjusted = NULL)]

dRet <- as.vector(periodReturn(GSPC, period='daily')$daily.returns)

dtSPprices[,`:=` (dailyRet = dRet,
                   cumRet = cumsum(dRet),
                   sma20 = SMA(Close,20),
                   sma50 = SMA(Close,50),
                   ema20 = EMA(Close,20),
                   ema50 = EMA(Close,50))]

# length(names(dtAMZNprices))


temp <- rbind(dtAMZNprices, dtIBMprices)
temp <- rbind(temp, dtMSFTprices)
temp <- rbind(temp, dtAAPLprices)
temp <- rbind(temp, dtDJIprices)
temp <- rbind(temp, dtNASprices)
temp <- rbind(temp, dtSPprices)


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

save(stockSymbols, indexSymbols, symbols, dCLoseSymbols, dReturnsSymbols, file = "plotlyStocks.RData")

load(file = "plotlyStocks.RData")




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





