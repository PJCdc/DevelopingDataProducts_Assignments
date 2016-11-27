
"C:\Users\TCarroll\OneDrive - TMC\GitRepos\DevelopingDataProducts_Assignments"
setwd("C:/Users/TCarroll/OneDrive - TMC/GitRepos/DevelopingDataProducts_Assignments")
getwd()

library(magrittr)
library(quantmod)
library(PerformanceAnalytics)
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

symbols <- c("AMZN", "^DJI", "^IXIC", "^GSPC")

getSymbols(symbols, from=from, to=to, src="yahoo", adjust=TRUE)

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
dailyReturnsAMZN <- transmute(dailyReturnsAMZN, cReturnAMZN = cReturnAMZN)

dailyReturnsDJI <- as.data.frame(periodReturn(DJI,period='daily'), row.names = FALSE)
colnames(dailyReturnsDJI) <- c("dReturnsDJI")
dailyReturnsDJI <- mutate(dailyReturnsDJI, cReturnDJI = cumsum(dReturnsDJI))
dailyReturnsDJI <- transmute(dailyReturnsDJI, cReturnDJI = cReturnDJI)

dailyReturnsNAS <- as.data.frame(periodReturn(IXIC,period='daily'), row.names = FALSE)
colnames(dailyReturnsNAS) <- c("dReturnsNAS")
dailyReturnsNAS <- mutate(dailyReturnsNAS, cReturnNAS = cumsum(dReturnsNAS))
dailyReturnsNAS <- transmute(dailyReturnsNAS, cReturnNAS = cReturnNAS)

dailyReturnsSP <- as.data.frame(periodReturn(GSPC,period='daily'), row.names = FALSE)
colnames(dailyReturnsSP) <- c("dReturnsSP")
dailyReturnsSP <- mutate(dailyReturnsSP, cReturnSP = cumsum(dReturnsSP))
dailyReturnsSP <- transmute(dailyReturnsSP, cReturnSP = cReturnSP)

dReturnsSymbols <- cbind(dailyReturnsAMZN, dailyReturnsDJI, dailyReturnsNAS, dailyReturnsSP)
dReturnsSymbols <- gather(dReturnsSymbols, index, returns) %>% mutate(Date = rep(dateCLose$Date,4))

save(dCLoseSymbols, dReturnsSymbols, file = "plotlyStocks.RData")
