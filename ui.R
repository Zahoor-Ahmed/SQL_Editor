library(shiny)
library(shinycssloaders)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .wide-textarea {
        width: 100%;
      }
      .spinner-container {
        text-align: center;
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
      div(
        class = "spinner-container",
        withSpinner(
          verbatimTextOutput("resultOutput"),
          type = 1,  # Use spinner type 1 (circle)
          color = "#dc3545",
          size = 2
        )
      )
    )
  )
)
