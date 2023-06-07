ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .wide-textarea {
        width: 100%;
      }
    "))
  ),
  titlePanel("R Script Execution"),
  sidebarLayout(
    sidebarPanel(
      fileInput("scriptFile", "Upload Script File"),
      tags$textarea(id = "rScript", class = "wide-textarea", rows = 10, 
                    placeholder = "Paste your R script here"),
      actionButton("runButton", "Run Query"),
      downloadButton("downloadButton", "Download Result")
    ),
    mainPanel(
      h3("Execution Result"),
      verbatimTextOutput("resultOutput"),
      verbatimTextOutput("timerOutput")
      
    )
  )
)