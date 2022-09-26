library(shiny)

shinyApp(
  ui = fluidPage(
    selectInput(
      "year",
      "Year",
      max(josp::brimr_table_3$year):(min(josp::brimr_table_3$year) + 3)
    ),
    selectInput(
      "department",
      "Department",
      josp::brimr_wusm_dept_mappings$nih_dept_combining_name
    ),
    downloadButton("slide", "Generate Slide")
  ),

  server = function(input, output) {
    file_base_name <- reactive({
      sprintf("brimr_%s_%s", gsub("[/ ]", "_", input$department), input$year)
    })

    output$slide <- downloadHandler(
      filename = function() { paste0(file_base_name(), ".pptx") },

      content = function(file) {
        josp::brimr_dept_slide(input$year, input$department, file)
      },

      contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    )
  }
)
