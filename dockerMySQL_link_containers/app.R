library(shiny)
library(DBI)
library(RMySQL)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput('txtUser', "User", value = "root"),
      passwordInput('txtPwd', "Password", value = "my-secret-pw"),
      
      actionButton('btnLogin', "Login")
    ),
    
    mainPanel(
	  textOutput('txtStatus'),
      tableOutput('tblMyData')
    )
  )
)

server <- function(input, output, session) {

  showNotification(Sys.info()[['user']])

  CNX <- reactiveValues(status = 'not connected')
  
  myData <- eventReactive(input$btnLogin,{
    
	showNotification('trying to connect...')
	
    cnx <- try(dbConnect(
      RMySQL::MySQL(),
      dbname = 'test',
      username = input$txtUser, #'root',
      password = input$txtPwd,
	  # host = '192.168.114.188',
	  # host = '172.18.0.2',
	  # host = '127.0.0.1',
	  # host = 'localhost',
	   port=3306
    ))
	
	if (class(cnx)=='try-error'){
		CNX$status <- as.character(cnx)
	}
    
    validate(
      need(cnx, message = "Connection failed.")
    )
    
    print('Connected :)')
    print(cnx)
	
	CNX$status <- 'connected'
    
    rst <- dbGetQuery(cnx, "SELECT * FROM user")
    
    # data <- fetch(rst, n = 10)
    
    dbDisconnect(cnx)
    
    rst
  })
  
  
  output$tblMyData <- renderTable({
    
    myData()
  })
  
  output$txtStatus <- renderText({
    CNX$status
  })
}

shinyApp(ui, server)