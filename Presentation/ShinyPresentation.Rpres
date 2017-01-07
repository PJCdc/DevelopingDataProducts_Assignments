<style>
.exclaim .reveal .state-background {
  background: PaleGoldenRod ;
} 

<!-- This is a comment -->

<!-- .exclaim .reveal p {
  color: red;
} -->

</style>

<style>
.footer {
    display: block
    color: black; background: #E8E8E8;
    text-align:center; width:100%;
}
</style>


Interactive Stock Chart Using Shiny and Plotly R Packages
========================================================
author: TMC
date: January 06,  2017
autosize: true
transition: zoom
font-family: 'Helvetica'



  

Overview (1/2)
========================================================
type: exclaim


<img src = "Test3.png";></img>
***
<h4>
<p>This shiny application allows the user to select a stock or index for
a single year and plot the daily price data as a"candlestick" chart.
<br><br>
Additionally, two technical indicators can be selected and 
superimposed on the price chart.</p>
</h4>



Overview (2/2)
========================================================
type: exclaim
left: 40%

<img src = "Test3.png";></img>
***
<small>
The application uses drop down selection boxes when there are several choices the
user can make.

It also uses radio button selection groups when the user can select only one 
of the choices provided.

The chart itself is a plotly interactive chart that receives as input the selections make by the user. Hovering over a bar (the day's price data) will display the data for that day:
- High, Low, Open, Close Prices
- "Fast" MA value, "Slow" MA value
</small>




Daily Price Data - Candlestick Chart
========================================================
type: exclaim
left: 30%

<img src = "Candlestick.png";></img>
<small><em>Candlesticks are an improvement over a traditional chart. The graphical enhancements allow the user to quickly pick up key info on the day's price movement.
</em></small>

***
<small>
Four prices for each day are plotted as a set of two prices using different graphic elements:
- The Highest and Lowest price for the day. A thin line is drawn extending from the High price to the Low price.
- The Open and Close prices for the day. A filled rectangle extending between the Open and Close prices.
- The color of the H/L line and the fill of the O/C rectangle is determined by 
the relationship of the Open and Close prices: Green if the Close price is greater than the Open price. Otherwise, the color is Red.
</small>


Technical Indicators (1/3)
========================================================
type: exclaim

<img src = "Test3.png";></img>
***
<small>
The moving average is simply an average of the n previous prices. In this app, there are two choices:
- A window of the previous 50 days. This is referred to as the "Slow" moving average. It is the blue line in the adjacent screenshot.
- A window of the previous 20 days. This is referred to as the "Fast" moving average. It is the orange line in the adjacent screenshot.
</small>



Technical Indicators (2/3)
========================================================
type: exclaim
left: 40%

<img src = "Test3.png";></img>
***
<small>
Two types of moving averages are available for each window length:
- Simple moving average - Each price in the window has the same "weight". Each price is treated equally to all other prices.
- Weighted moving average - The more recent prices have a greater weight than the early prices in the window. Current prices have a greater impact on the average than older prices. This type of average is also called an "Exponential" moving average.
</small>


Technical Indicators (3/3)
========================================================
type: exclaim
left: 40%

<img src = "Test3.png";></img>
***
<small>
The combination of these two indicators <em>generally</em> are used to identify an up trend in the stock's price. 
An old rule of thumb is that when the "fast" moving average is above the "slow" moving average, the stock is trending up. The opposite indicates the stock trending down.  

<em><strong>This is a general indication of the stock's trend. It does not hold in all cases and is not a reliable signal on its own to enter of exit trades.</em>
</strong></small>





