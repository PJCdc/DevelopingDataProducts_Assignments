# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Stock Performance Review"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("selectStock",
                  label = "Select Stock:",
                  choices = c("AMZN", "GOOGL", "IBM"),
                  selected = "AMZN"),
      selectInput("selectIndex",
                  label = "Select Reference Index:",
                  choices = c("DJI", "NAS", "SP500"),
                  selected = "DJI")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
    )
  )
  
))



fluidRow(
  column(3,
         h4("Diamonds Explorer"),
         sliderInput('sampleSize', 'Sample Size', 
                     min=1, max=nrow(dataset),
                     value=min(1000, nrow(dataset)), 
                     step=500, round=0),
         br(),
         checkboxInput('jitter', 'Jitter'),
         checkboxInput('smooth', 'Smooth')
  ),
  column(4, offset = 1,
         selectInput('x', 'X', names(dataset)),
         selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
         selectInput('color', 'Color', c('None', names(dataset)))
  ),
  column(4,
         selectInput('facet_row', 'Facet Row',
                     c(None='.', names(diamonds[sapply(diamonds, is.factor)]))),
         selectInput('facet_col', 'Facet Column',
                     c(None='.', names(diamonds[sapply(diamonds, is.factor)])))
  )


  
  mainPanel(
    h4("T E S T"),
    em("Add tabsetPanel")
    
  )
  
  
  
  fluidRow(
    column(3,
           selectInput("selectStock",
                       label = "Select Stock:",
                       choices = stockSymbols$Display,
                       # choices = c("AMZN", "GOOGL", "IBM"),
                       selected = "AMZN",
                       width = "300px")),
    column(4,
           selectInput("selectIndex",
                       label = "Select Reference Index:",
                       choices = indexSymbols$Display,
                       # choices = c("DJI", "NAS", "SP500"),
                       selected = "DJI",
                       width = "300px"))
    
  ),
  
  selectInput("selectStock",
              label = "Select Stock:",
              choices = stockSymbols$Display,
              # choices = c("AMZN", "GOOGL", "IBM"),
              selected = "AMZN"),
  
  selectInput("selectIndex",
              label = "Select Reference Index:",
              choices = indexSymbols$Display,
              # choices = c("DJI", "NAS", "SP500"),
              selected = "DJI")
  
  
  bsTooltip(id = "sma50", title = "Testing ToolTips", 
            placement = "right", trigger = "hover")
  
  
  
# Examples of format function sprintf
  sprintf("%f", pi)
  sprintf("%.3f", pi)
  sprintf("%1.0f", pi)
  sprintf("%5.1f", pi)
  sprintf("%05.1f", pi)
  sprintf("%+f", pi)
  sprintf("% f", pi)
  sprintf("%-10f", pi) # left justified
  sprintf("%e", pi)
  sprintf("%E", pi)
  sprintf("%g", pi)
  sprintf("%g",   1e6 * pi) # -> exponential
  sprintf("%.9g", 1e6 * pi) # -> "fixed"
  sprintf("%G", 1e-6 * pi)
  
  ## no truncation:
  sprintf("%1.f", 101)
  
  ## re-use one argument three times, show difference between %x and %X
  xx <- sprintf("%1$d %1$x %1$X", 0:15)
  xx <- matrix(xx, dimnames = list(rep("", 16), "%d%x%X"))
  noquote(format(xx, justify = "right"))
  
  ## More sophisticated:
  
  sprintf("min 10-char string '%10s'",
          c("a", "ABC", "and an even longer one"))
  
  ## Platform-dependent bad example from qdapTools 1.0.0:
  ## may pad with spaces or zeroes.
  sprintf("%09s", month.name)
  
  n <- 1:18
  sprintf(paste0("e with %2d digits = %.", n, "g"), n, exp(1))
  
  ## Using arguments out of order
  sprintf("second %2$1.0f, first %1$5.2f, third %3$1.0f", pi, 2, 3)
  
  ## Using asterisk for width or precision
  sprintf("precision %.*f, width '%*.3f'", 3, pi, 8, pi)
  
  ## Asterisk and argument re-use, 'e' example reiterated:
  sprintf("e with %1$2d digits = %2$.*1$g", n, exp(1))
  
  ## re-cycle arguments
  sprintf("%s %d", "test", 1:3)
  
  ## binary output showing rounding/representation errors
  x <- seq(0, 1.0, 0.1); y <- c(0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1)
  cbind(x, sprintf("%a", x), sprintf("%a", y))
  