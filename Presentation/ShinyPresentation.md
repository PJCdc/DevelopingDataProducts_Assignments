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


ShinyPresentation
========================================================
author: TMC
date: January 02,  2017
autosize: true
transition: zoom
font-family: 'Helvetica'

  

Overview
========================================================
type: exclaim


<img src = "Test2.png";></img>
***
<h4>
<p>This shiny application allows the user to select a stock or index for
a single year and plot the daily price data as a"candlestick" chart.
<br><br>
Additionally, two technical indicators can be seleced and 
superimposed on the price chart.</p>
</h4>



Daily Price Data - Candlestick Chart
========================================================
type: exclaim

<img src = "Test2.png";></img>
***
<h4>Four prices for each day are plotted as a set of two pairs:</h4>
- The Highest and Lowest price for the day
- The Open and Close prices for the day  

Each price pair is plotted using diferent graphic elements:
- A thin line is drawn extending from the High price to the Low price
- A filled rectangle extending between the Open and Close prices

The color of the H/L line and the fill of the O/C rectangle is determined as:
- Green if the Close price is greater than the Open price. Otherwise, the color is Red



Thrid Slide
========================================================
type: exclaim

- <h3>Text for image</h3>


Fourth Slide
========================================================
type: exclaim

- <h3>Text for image</h3>
