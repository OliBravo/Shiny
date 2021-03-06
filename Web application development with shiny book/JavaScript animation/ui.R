library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Text based animations"),
  sidebarPanel(
    h3("Let's animate something!"), # heading helper
    p("Please enjoy the
      animation responsibly"), # paragraph helper
    tags$textarea(id="textArea", # tags$XX for
                  "Please enter text here"), # generating HTML
    tags$input(type = "button",
               id = "animate",
               value = "Animate!",
               onClick = "buttonClick()") # reference to JS
    ),
  mainPanel(
    tags$canvas(id="myCanvas", # graphical output area
                width="500",
                height="250"),
    includeHTML("textSend.js"), # include JS file
    textOutput("textDisplay")
  )
))