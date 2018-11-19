#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(DBI)
library(RPostgres)
library(dplyr)
library(tidyr)
library(DT)

source("rendering_functions.R")
source("database_functions.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  user <- reactiveValues(logged = FALSE) # to track if a user's logged in
  
  cursor <- reactiveValues(position = 1) # resulting recordset navigation
  
  
  
  #### Login initial dataset: -------
  db_res <- eventReactive(input$btnLogin, {
    
    # returns a recordset with customer information;
    # row level security policies are defined in the database, so we don't have to
    # handle security issues in the code; instead we can just query the database.
    
    cnx <- db_connect(input$txtLogin, input$txtPassword)
    
    
    validate(
      need(cnx, message = "Unable to connect to the database.")
    )
    
    
    rst <- queryDB(
      cnx,
      sql = "select * from projects order by project_id"
    )
    
    
    dbDisconnect(cnx)
    
    return(rst)
  })
  
  
  #### Login observers: ------
  observe({
    # which page should we render:
    
    if (!user$logged){
      # user's not logged in
      output$page <- renderUI({
        
        renderLoginPage()
      })
    } else {
      # user is authorized to see the content
      output$page <- renderUI({
        
        screen_001()
      })
    }
  })
  
  
  observeEvent(input$btnLogin, {


    cnx <- db_connect(input$txtLogin, input$txtPassword)


    if(is.null(cnx)){

      shinyjs::toggle("login-failed", condition = T)

    } else {

      user$logged <- TRUE

      dbDisconnect(cnx)

    }
  })
  
  
  
  observe({
    
    if (user$logged){
      db_res()
      cursor$position <- 1
    }
      
  })
  
  
  output$tblProjectList <- renderDataTable({
    
    db_res()
  })
  
  
  observeEvent(input$lnkLogOut, {
    
    user$logged = FALSE
  })
  
  
  
  
  #### Add Project: --------
  observeEvent(input$btnAddProject, {
    
    clients <- queryDB(
      connection = db_connect(login = input$txtLogin, password = input$txtPassword),
      sql = "select * from clients"
    )
    
    updateSelectInput(session = session,
                      inputId = "cbxAddProj_ClientID",
                      choices = clients[,2])
    
    output$page <- renderUI({
      
      screenAddProject()
    })
  })
  
  
  
  observe({
    
    shinyjs::toggle(id = "dteAddProj_End", anim= T, animType = "slide", condition = input$chkEndDate)  
  })
  
  
})
