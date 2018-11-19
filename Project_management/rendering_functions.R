# functions to call in order to render appropriate page


renderLoginPage <- function(){
  fluidPage(
  
    tags$head(
      tags$link(href = "style.css", rel="stylesheet", type="text/css")
    ),
    
    tags$div(
      
      id = "login-container",
      
      class = "wrapper",
      
      wellPanel(
        
        textInput("txtLogin", "Login", value = "postgres"),
        
        passwordInput("txtPassword", "Password", value = "5gYuABiu"),
        
        actionButton("btnLogin", type = "button", "Sign In")
      ),
      
      wellPanel(
        
        id = "login-failed",
        
        "Unable to connect to the database."
        
      )
    ),
    
    mainPanel(
      
    )
  )
}


logoutHeader <- function(){
  
  tags$div(
    
    class = "logout-container",
    actionLink("lnkLogout", "Log out"))
}


createHeading <- function(title){
  
  tags$h2(title)
}


screen_001 <- function(){
  
  # renders a list of projects depending on user's role
  fluidPage(
    
    logoutHeader(),
    
    createHeading("Projects:"),
    
    tags$div(
      
      class = "main-content",
      
      tags$div(
        
        class = "project-manipulation",
        
        dataTableOutput("tblProjectList"),
        
        tags$div(
          
          class = "project-manip-buttons",
          
          actionButton("btnEditPreview", "Edit / Preview"),
          
          actionButton("btnAddProject", "+ Add"),
          
          actionButton("btnRemoveProject", "- Remove", class = "delete-button")    
        )
      )
    )
  )
}


screenAddProject <- function(){
  
  fluidPage(
    
    logoutHeader(),
    
    createHeading("New project:"),
    
    tags$div(
      
      class = "main-content",
      
      tags$div(
        
        class = "add-project",
      
        textInput("txtAddProj_Name", label = "Project name:"),
        
        selectInput("cbxAddProj_ClientID",
                    label = "Client:",
                    choices = NULL,
                    selectize = TRUE),
        
        dateInput("dteAddProj_Start", "Start date:"),
        
        checkboxInput("chkEndDate", value = FALSE, label = "End date?"),
        
        dateInput("dteAddProj_End", "End date:", value = NULL),
        
        tags$div(
          
          class = "footer",
          
          actionButton("btnAddProj_Create", "Create"),
          
          actionButton("btnAddProj_Cancel", "Cancel", class = "delete-button")
        )
        
      ),
      
      tags$div(
        
        id = "members",
        
        class = "add-project",
        
        dataTableOutput("tblMembers")
      )
      
      
    )  
  )
}