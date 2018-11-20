library(shiny)
library(plotly)

ui <- fluidPage(
  
  # numericInput('noOfNodes', "Number of nodes", step = 2, min = 8, max = 26, value = 18),
  
  selectInput('start_color',
              "Start color:",
              choices = colors(),
              selected = "deepskyblue4"),
  selectInput('mid_color',
              "Mid color:",
              choices = colors(),
              selected = "lavenderblush3"),
  selectInput('stop_color',
              "Stop color:",
              choices = colors(),
              selected = "olivedrab1"),
  
  plotlyOutput('sankey')
)

server <- function(input, output, session) {
  
  generate_links <- function(nodes){
    # browser()
    noOfLayers <- min(sample(2:4, 1), length(nodes))
    df <- data.frame(source = numeric(),
                     target = numeric(),
                     value = numeric())
    for (i in 1:noOfLayers){
      source <- sample(1:length(nodes), 3, replace = T)
      nodes <- nodes[-source]
      
      target <- sample(1:length(nodes), 3, replace = T)
      nodes <- nodes[-target]
      
      value <- sample(1:10, 3)
      
      df <- rbind(df,
                  cbind(source, target, value))
      
    }
    
    df <- data.frame(
      source = c(0, 0, 1, 4, 5, 5, 6, 7, 7, 9, 9, 8, 8, 8, 10, 10),
      target = c(4, 5, 5, 6, 7, 8, 9, 9, 8, 10, 11, 12, 13, 14, 15, 16),
      value = 1
    )
    
    return(df)
  }
  
  nodes <- reactive({
    
    data.frame(nodeID = 1:15,
               name = LETTERS[1:15])
  })
  
  links <- reactive({
    generate_links(nodes()$node)
  })
  
  
  colors <- reactive({
    
    n <- length(nodes()$node)
    
    colorRampPalette(c(input$start_color,
                       input$mid_color,
                       input$stop_color))(15)
  })
  
  output$sankey <- renderPlotly({
    # browser()
    p <- plot_ly(
      type = "sankey",
      domain = list(
        x = c(0,1),
        y = c(0,1)
      ),
      
      node = list(
        label = nodes()$name,
        color = colors()
      ),
      
      link = list(
        source = links()$source,
        target = links()$target,
        value = links()$value,
        
        hoverinfo = "skip"
      )
    )
    
    p
  })
}

shinyApp(ui, server)
