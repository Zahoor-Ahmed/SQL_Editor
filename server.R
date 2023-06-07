library(shiny)
library(shinymaterial)

server <- function(input, output) {
  result <- reactiveVal(NULL)
  script <- reactiveVal(NULL)
  running <- reactiveVal(FALSE)
  
  observeEvent(input$runButton, {
    running(TRUE)
    
    # Check if script file is uploaded or textarea is used
    if (!is.null(input$scriptFile$datapath)) {
      # Read the script file content
      script_content <- readLines(input$scriptFile$datapath)
      script(script_content)
    } else {
      # Get the script from the textarea
      script_content <- isolate(input$rScript)
      script(script_content)
    }
    
    # Establish database connection
    source("D:/R_Studio_Files/Connect_Carbon.R", local = TRUE)
    
    # Execute the SQL query
    if (!is.null(script())) {
      result_df <- dbGetQuery(carbon, paste(script(), collapse = "\n"))
      
      # Store the result in the reactive value
      result(result_df)
      
      # Close the database connection
      dbDisconnect(carbon)
    }
    
    running(FALSE)
  })
  
  output$resultOutput <- renderPrint({
    if (running()) {
      shinyMaterial::materialSpinner(color = "red")
    } else {
      result()
    }
  })
  
  output$downloadButton <- downloadHandler(
    filename = function() {
      if (!is.null(input$scriptFile$datapath)) {
        file_name <- basename(input$scriptFile$name)
        file_ext <- tools::file_ext(file_name)
        paste0("result.", file_ext)
      } else {
        "result.csv"
      }
    },
    content = function(file) {
      write.csv(result(), file, row.names = FALSE)
    }
  )
}
