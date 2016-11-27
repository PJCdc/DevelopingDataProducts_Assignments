n <- 40
lambda <- .75
epochs <- 1000

test <- data.frame(matrix(data = 0, nrow = epochs, ncol = n))

set.seed(101)
for(nsim in 1:1000)
  test[nsim,] <- rexp(n, lambda)

simAvg <- apply(test, 1, mean)
hist(simAvg)
1/lambda


library(shiny)
library(miniUI)
library(plotly)

simExponential <- function() {
  ui <- miniPage(
    gadgetTitleBar("Simulation"),
    miniContentPanel(
      sliderInput("sliderN", "Sample Size", min = 10, max = 100, value = 10),
      sliderInput("sliderLambda", "Rate Parameter", min = 0, max = 10, value = 1),
      
      
      plotlyOutput("simPlot")
      
      
    )
  )

  
  server <- function(input, output, session) {
    size <- 40
    rate <- .75
    epochs <- 1000
    
    test <- data.frame(matrix(data = 0, nrow = epochs, ncol = n))
    
    set.seed(101)
    for(nsim in 1:1000)
      test[nsim,] <- rexp(n, lambda)
    
    simAvg <- apply(test, 1, mean)
    simAvg <- as.data.frame(simAvg)
    
    
    observeEvent(input$done, {
      stopApp()
    })
    
    reactive(input$sliderN, {
      size <- as.numeric(input$sliderN)
    })

    reactive(input$sliderLambda, {
    
      rate <- as.numeric(input$sliderLambda)
    })
      
      set.seed(101)
      
      for(nsim in 1:1000)
        test[nsim,] <- rexp(size, rate)
      
      simAvg <- apply(test, 1, mean)
      simAvg <- as.data.frame(simAvg)
      
      # stopApp(
      output$simPlot <- renderPlotly({
        
       p <- plot_ly(simAvg, x = simAvg, type = "histogram")
              
        
      })
      # )
      
      
      
  }
  
  runGadget(ui, server)
  
  }
# }
  
simExponential()
  
  
  
  
  
  
  
  