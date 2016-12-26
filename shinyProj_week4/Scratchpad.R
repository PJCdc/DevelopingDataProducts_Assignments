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
  