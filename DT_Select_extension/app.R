library(shiny)
library(DT)

ui <- fluidPage(
  tags$head(tags$script(src = "dataTables.checkboxes.min.js")),
  tags$head(tags$script(src = "dataTables.select.min.js")),
  tags$head(tags$script(src = "jquery.dataTables.min.js")),
  
  DT::dataTableOutput('myTable'),
  
  actionButton('get_rows', 'Get selected rows')
)

server <- function(input, output, session) {
  
  data <- iris
  data <- cbind(1:nrow(data), data)
  
  output$myTable <- DT::renderDataTable(server = FALSE, {
    
    datatable(
      data,
      rownames = FALSE,
      selection = "none",
      options = list(
        dom = "ftlipS",
        columnDefs = list(list(
          targets = 0,
          checkboxes = list(selectRow = TRUE)
        )),
        select = list(
          selector='td:not(:first-child)',
          style='multi',
          items = "row"
        )
      ),
      extensions = "Select",
      callback = JS(
        "table.on( 'select deselect', function (e, dt, type, indexes) {", # react on click event
        "var idx = table.rows({selected: true}).indexes().toArray();", # get the index of selected items
        "var DT_id = table.table().container().parentNode.id;", # get the output id of DT
        "Shiny.onInputChange(DT_id + '_selected', idx);", # send the index to input$outputid_selected
        "})"
      )
    )
  })
  
  
  observeEvent(input$myTable_selected, {
    
    print(input$myTable_selected)
    # print(length(input$myTable_selected))
  }, ignoreNULL = FALSE)
}

shinyApp(ui, server)


