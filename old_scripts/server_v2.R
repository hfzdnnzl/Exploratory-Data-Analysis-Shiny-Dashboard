
# library
library(shiny)
library(shinyWidgets)
library(DT)
library(ggplot2)
library(tidyr)

# server
server = function(input, output, session) {
  # reactive values
  rv = reactiveValues(data = NULL, df = data.frame(), df_long = data.frame())
  cp = reactiveValues(plot = F, change = F)
  # ct = reactiveValues(change = F)
  
  # main page
  output$mainpage = renderUI({
    rv_null = ifelse(is.null(rv$data),'yes',
                     ifelse(!input$reset,'no'))
    rv_null = ifelse(cp$plot, 'plot', rv_null)
    switch(rv_null,
           'yes'= uiOutput("page1"),
           'no'= uiOutput('page2'),
           'plot'= uiOutput('barplot')
    )
  })
  # first page ui
  output$page1 <- renderUI({
    tagList(
      headerPanel('Bar Plotter'),
      fileInput("file", label = h3("File input"))
    )
  })
  # reading and resetting file
  observeEvent(input$file,{
    updateSwitchInput(session = session,inputId = 'reset', value = F)
    rv$data = input$file
    rv$df = readRDS(rds_file())
    rv$df_long = readRDS(rds_file())
  })
  observeEvent(input$reset,{
    if(input$reset){rv$data = NULL}
  })
  # read rds file
  rds_file <- reactive({
    req(input$file)
    input$file$datapath
  })
  
  
  # page 2
  output$page2 = renderUI({
    tagList(
      headerPanel('Convert Table to Long Format'),
      radioButtons('x_axis','Choose First Column',choices = colnames(rv$df)),
      uiOutput('cb_reactive'),
      textInput('y_name','Second Column Name'),
      textInput('l_name','Third Column Name'),
      actionButton('convert_long','Convert to long format'),
      actionButton('revert_wide','Revert to wide format'),
      actionButton('show_barplot','Show Barplot'),
      uiOutput('table')
    )
  })
  # check box output
  output$cb_reactive = renderUI({
    cn = colnames(rv$df)[colnames(rv$df)!=input$x_axis]
    checkboxGroupInput('y_axis','Choose Second Column',choices = cn)
  })
  # action button
  observeEvent(input$convert_long,{
    if(length(input$y_axis)>0){
      # edit to long dataframe
      df = rv$df %>% select(all_of(input$x_axis),all_of(input$y_axis))
      rv$df_long = gather(df,category,total,-input$x_axis)
      # rename column
      if(input$y_name!=''){colnames(rv$df_long)[2] = input$y_name}
      if(input$l_name!=''){colnames(rv$df_long)[3] = input$l_name}
      # ct$change=T
    }
  })
  observeEvent(input$revert_wide,{
    rv$df_long = rv$df
    # ct$change=F
  })
  # show table
  output$table = renderUI({
    tagList(
      renderDataTable({
        rv$df_long
      })      
    )
  })
  
  # observe button
  observeEvent(input$show_barplot,{cp$plot=T})
  # bar plot page
  output$barplot <- renderUI({
    if (is.null(rds_file())) {return(NULL)}
    # plot data
    tagList(
      actionButton('flip_barplot','Change Axis'),
      plotOutput('sub_bar')
    )
  })
  # bar plot change axis
  observeEvent(input$flip_barplot,{
    if(cp$change){cp$change=F}
    else{cp$change=T}
  })
  # bar plot
  output$sub_bar = renderPlot({
    # read and edit data
    bar_df = rv$df_long
    x_name = colnames(bar_df)[1]
    y_name = colnames(bar_df)[2]
    colnames(bar_df) = c('x','y','JUMLAH')
    # plot
    if(cp$change){
      ggplot(bar_df,aes(x=y,y=JUMLAH,fill=x,label=x)) +
        geom_bar(stat = 'identity') +
        xlab(y_name) + labs(fill = x_name)        
    }else{
      ggplot(bar_df,aes(x=x,y=JUMLAH,fill=y,label=y)) +
        geom_bar(stat = 'identity') +
        xlab(x_name) + labs(fill = y_name)      
    }
  })
  
}