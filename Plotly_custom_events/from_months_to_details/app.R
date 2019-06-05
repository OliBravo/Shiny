library(shiny)
library(plotly)
library(dplyr)

ui <- fluidPage(
  plotlyOutput("monthly"),
  
  plotlyOutput("details")
)

server <- function(input, output, session) {
  
  monthly.df <- data.frame(
    month = factor(month.name, levels = month.name),
    sales = runif(12, 100, 500)
  )
  
  detailed.df <- expand.grid(
    month.name,
    channel = c("tv", "cinema", "print", "poster", "youtube")
  ) %>% 
    as.data.frame() %>% 
    mutate(KPI = rnorm(n = nrow(.), mean = 10, sd = 3)) %>% 
    # tidyr::spread(key = "Var2", value = "KPI") %>% 
    rename(month = Var1)
  
  
  output$monthly <- renderPlotly({
    monthly.df %>% 
      plot_ly(source = "general",
              x = ~month,
              y = ~sales,
              type = "bar")
  })
  
  
  output$details <- renderPlotly({
    event.data <- event_data("plotly_click", source = "general")
    req(!is.null(event.data))
    
    sel_month <- event.data$x
    df <- subset(detailed.df, month == sel_month)
    print(df)
    
    plot_ly(data = df,
           x = ~channel,
           y = ~KPI,
           color = ~channel) %>% 
      layout(showlegend = FALSE,
             title = "Detailed information for selected month")
  })
  
}

shinyApp(ui, server)