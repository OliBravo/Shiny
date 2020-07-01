# HOC: ----
with_greetings_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(id = ns("greeting"),
        h2("Hello World!")
    ),

    uiOutput(ns("component_ui"))
  )
}


with_greetings <- function(input, output, session, component) {

  output$component_ui <- renderUI({
    component$ui(session$ns)
  })


  component$server()
}



# An ordinary shiny module: ----
text_input_component_ui <- function(id) {
  ns <- NS(id)

  tagList(
    textInput(ns("txt_in"), label = "Enter text:"),
    actionButton(ns("btn_go"), "Go!"),
    div(
      h3("Click Go to see Your text"),
      div(
        style = "border: 2px gray solid; border-radius: 5px; text-align: center; padding: 20px; font-size: 2rem;",
        textOutput(ns("txt_out"))
      )
    )
  )
}

text_input_component <- function(input, output, session) {
  out <- eventReactive(input$btn_go, {
    input$txt_in
  })

  output$txt_out <- renderText({
    out()
  })
}


# a customized component using a module: ----
custom_component <- list(
  ui = function(ns) {
    text_input_component_ui(ns("test"))
  },
  server = function(...) { # dots in case a module should accept an extra input
    callModule(
      text_input_component,
      "test",
      ...
    )
  }
)

# The App: ----
ui <- fluidPage(
  with_greetings_ui("hoc")
)

server <- function(input, output, session) {
  callModule(
    with_greetings,
    "hoc",
    component = custom_component
  )
}

shinyApp(ui, server)

