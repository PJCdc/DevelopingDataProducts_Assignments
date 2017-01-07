
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

# save(AMZN, DJI, IXIC, GSPC, file = "plotlyStocks.RData")

dateCLose <- as.data.frame(index(AMZN))
colnames(dateCLose) = "Date"

dCloseAMZN <- as.data.frame(Cl(AMZN), row.names = FALSE)
dCloseDJI <- as.data.frame(Cl(DJI), row.names = FALSE)
dCloseNAS <- as.data.frame(Cl(IXIC), row.names = FALSE)
dCloseSP <- as.data.frame(Cl(GSPC), row.names = FALSE)


dCLoseSymbols <- cbind(dCloseAMZN, dCloseDJI, dCloseNAS, dCloseSP)
dCLoseSymbols <- gather(dCLoseSymbols, index, price) %>% mutate(Date = rep(dateCLose$Date,4))

  
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

# Compute SMA & EMA

amznSMA20 <-   SMA(AMZN[,"AMZN.Close"], 20)
amznSMA20 <- data.frame(amznSMA20, Date = index(amznSMA20), row.names = NULL)
amznSMA20 <- rename(amznSMA20, AMZN = SMA)

amznAMZ50 <-   SMA(AMZN[,"AMZN.Close"], 50)



ibmSMA20 <-   SMA(IBM[,"IBM.Close"], 20)
ibmSMA50 <-   SMA(IBM[,"IBM.Close"], 50)

msftSMA20 <-   SMA(MSFT[,"MSFT.Close"], 20)
msftSMA50 <-   SMA(MSFT[,"MSFT.Close"], 50)

aaplSMA20 <-   SMA(AAPL[,"AAPL.Close"], 20)
aaplSMA50 <-   SMA(AAPL[,"AAPL.Close"], 50)

symbolsSMA20 <- cbind(amznSMA20, ibmSMA20, msftSMA20, msftSMA20)
symbolsSMA20 <- gather(symbolsSMA20, index, returns) %>% mutate(Date = rep(dateCLose$Date,4))

symbolsSMA50 <- cbind(amznAMZ50, ibmSMA50, msftSMA50, aaplSMA50)


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





