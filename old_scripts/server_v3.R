
# library
library(shiny)
library(DataExplorer)

# source scripts
source('explorer_fcn.R')

# server
server = function(input, output, session){
  rv = reactiveValues(dataIn = NULL)
  
  output$mainpage = renderUI({
    dataIn = ifelse(is.null(rv$dataIn),'yes','no')
    
    switch (dataIn,
      'yes' = uiOutput('first_pg'),
      'no' = uiOutput('second_pg')
    )
  })
  
  # observer reactive values
  observeEvent(input$file,{
    updateMaterialSwitch(session = session, 'reset', value = F)
    rv$dataIn = readRDS(input$file$datapath)
  })
  observeEvent(input$reset,{
    if(input$reset){rv$dataIn = NULL}
  })
  
  output$first_pg = renderUI({
    tagList(
      fileInput("file", label = h3("File input"))
    )
  })
  
  output$second_pg = renderUI({
    intro =
    tagList(
      'Data Overview',
      renderTable(head(rv$dataIn),width = '80%', align = 'l'),
      'Data Summary',
      renderTable(data_summary(rv$dataIn),width = '80%', align = 'l'),
      'Data Structure',
      renderTable(data_structure(rv$dataIn),width = '80%', align = 'l'),
      'Summary Plot',
      renderPlot({plot_intro(rv$dataIn)}),
      'Missing Data Profile',
      renderPlot({plot_missing(rv$dataIn)}),
      'Histogram',
      renderPlot({plot_histogram(rv$dataIn)}),
      'QQ Plot',
      renderPlot({plot_qq(rv$dataIn)}),
      'Correlation',
      renderPlot({data_correlation(rv$dataIn)}),
      'Principal Component Analysis',
      renderPlot({data_pca(rv$dataIn)[1]}),
      renderPlot({data_pca(rv$dataIn)[2]}),
    )
  })
  
}