# Title: Data Explanatory Shiny App Server
# Date Commence: 2 December 2021
# By: Hafizuddin
# Maintainer: 
# Objective: To serve as the server of the data explanatory shiny web app
# Version: 1.0
# Date Modified:
# Input Data: 
# Output: 

# R version 4.0.4 (2021-02-15)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 19042)
# 
# Matrix products: default
# 
# locale:
#   [1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252    LC_MONETARY=English_United States.1252
# [4] LC_NUMERIC=C                           LC_TIME=English_United States.1252    
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] data.table_1.14.0     gridExtra_2.3         dplyr_1.0.7           DataExplorer_0.8.2    ggpubr_0.4.0          ggplot2_3.3.5        
# [7] shinycssloaders_1.0.0 DT_0.19               shinyWidgets_0.6.1    shinyjs_2.0.0         shinydashboard_0.7.1  shiny_1.6.0          
# 
# loaded via a namespace (and not attached):
#   [1] sass_0.4.0        tidyr_1.1.3       jsonlite_1.7.2    carData_3.0-4     bslib_0.3.0       cellranger_1.1.0  yaml_2.2.1        pillar_1.6.2     
# [9] backports_1.2.1   glue_1.4.2        digest_0.6.27     promises_1.2.0.1  ggsignif_0.6.3    colorspace_2.0-2  cowplot_1.1.1     plyr_1.8.6       
# [17] htmltools_0.5.2   httpuv_1.6.2      pkgconfig_2.0.3   broom_0.7.9       haven_2.4.3       purrr_0.3.4       xtable_1.8-4      scales_1.1.1     
# [25] openxlsx_4.2.4    later_1.3.0       rio_0.5.27        tibble_3.1.4      generics_0.1.0    farver_2.1.0      car_3.0-11        ellipsis_0.3.2   
# [33] cachem_1.0.6      withr_2.4.2       magrittr_2.0.1    crayon_1.4.1      readxl_1.3.1      mime_0.11         evaluate_0.14     fansi_0.5.0      
# [41] rstatix_0.7.0     forcats_0.5.1     foreign_0.8-81    tools_4.0.4       hms_1.1.0         lifecycle_1.0.0   stringr_1.4.0     munsell_0.5.0    
# [49] zip_2.2.0         networkD3_0.4     compiler_4.0.4    jquerylib_0.1.4   tinytex_0.33      rlang_0.4.11      grid_4.0.4        htmlwidgets_1.5.3
# [57] crosstalk_1.1.1   igraph_1.2.6      labeling_0.4.2    rmarkdown_2.10    gtable_0.3.0      abind_1.4-5       curl_4.3.2        reshape2_1.4.4   
# [65] R6_2.5.1          knitr_1.33        fastmap_1.1.0     utf8_1.2.2        stringi_1.7.4     parallel_4.0.4    Rcpp_1.0.7        vctrs_0.3.8      
# [73] tidyselect_1.1.1  xfun_0.25  

# library
library(shiny)
library(shinydashboard)
library(DT)
library(shinycssloaders)
library(ggpubr)

# source
source('explorer_fcn.R')

server = function(input, output, session){
  # body side
  # reactive values
  rv = reactiveValues(tab = NULL, data = NULL)
  
  # read file
  observeEvent(input$file,{
    rmPop = F
    if(grepl('rds$',input$file$datapath,ignore.case = T)){
      rv$data = readRDS(input$file$datapath)
      rmPop = T
    }
    if(grepl('csv$',input$file$datapath,ignore.case = T)){
      rv$data = read.csv(input$file$datapath)
      rmPop = T
    }
    if(rmPop){
      removeModal()
    }
    # browser()
  })
  
  # reset file
  observeEvent(input$reset,{
    showModal(modalDialog(
      tags$style('.modal-dialog {margin-top:15%}'),
      tags$style('.modal-header {text-align:center}'),
      tags$style('.modal-body {text-align:center}'),
      tags$style('#resetYes,#resetNo {margin:20px}'),
      actionBttn('resetYes',label = 'Yes',style = 'jelly', color = 'danger',size = 'sm'),
      actionBttn('resetNo',label = 'No',style = 'jelly', color = 'default',size = 'sm'),
      title = 'Are you sure you want to reset the data?',size = 'l',footer = NULL
    ))
  })
  
  # close reset modal dialog
  observeEvent(input$resetYes,{
    removeModal()
    rv$data = NULL
    updateTabItems(session = session,'sidebar',selected = 'tab1')
  })
  observeEvent(input$resetNo,{
    removeModal()
  })
  
  # main page
  output$mainpage = renderUI({
    # show file input
    if(is.null(rv$data)){
      showModal(modalDialog(
        tags$style('.modal-dialog {margin-top:15%}'),
        tags$style('.modal-header {text-align:center}'),
        tags$style('.form-group {margin:auto;text-align:center}'),
        fileInput('file','Choose a CSV or an RDS file',accept = '.csv,.rds'),
        title = 'Welcome to Data Explorer',size = 'l',footer = NULL))
      rv$tab = 'NULL'
    }else{rv$tab = input$sidebar}
    # browser()
    switch (rv$tab,
      'tab1' = uiOutput('pg1'),
      'tab2' = uiOutput('pg2'),
      'tab3' = uiOutput('pg3'),
      'tab4' = uiOutput('pg4'),
      'tab5' = uiOutput('pg5'),
      uiOutput('blank')
    )
  })
  
  output$blank = renderUI({})
  
  output$pg1 = renderUI({
    # read data
    if(!is.null(rv$data)){
      # get data summary
      ds = data_summary(rv$data)
      # frontend
      tagList(
        fluidRow(
          div(valueBox(ds$Name[1],value = ds$Value[1], width = '100%'), class = 'col-md-4 col-lg-2'),
          div(valueBox(ds$Name[2],value = ds$Value[2], width = '100%'), class = 'col-md-4 col-lg-2'),
          div(valueBox(ds$Name[8],value = ds$Value[8], width = '100%'), class = 'col-md-4 col-lg-3'),
          div(valueBox(ds$Name[3],value = ds$Value[3], width = '100%'), class = 'col-md-4 col-lg-2'),
          div(valueBox(ds$Name[4],value = ds$Value[4], width = '100%'), class = 'col-md-4 col-lg-3'),
          div(valueBox(ds$Name[7],value = ds$Value[7], width = '100%'), class = 'col-md-4 col-lg-3'),
          div(valueBox(ds$Name[5],value = ds$Value[5], width = '100%'), class = 'col-md-4 col-lg-3'),
          div(valueBox(ds$Name[6],value = ds$Value[6], width = '100%'), class = 'col-md-4 col-lg-3'),
          div(valueBox(ds$Name[9],value = ds$Value[9], width = '100%'), class = 'col-md-4 col-lg-3'),
        ),
        box(title = 'Percentage', status = 'primary',solidHeader = T,
            fluidRow(
              div(box(renderPlot(data_percentage(rv$data)[[1]]), width = '100%'), class = 'col-md-12 col-lg-4'),
              div(box(renderPlot(data_percentage(rv$data)[[2]]), width = '100%'), class = 'col-md-12 col-lg-4'),
              div(box(renderPlot(data_percentage(rv$data)[[3]]), width = '100%'), class = 'col-md-12 col-lg-4'), 
              tags$head(tags$style(HTML('.box{-webkit-box-shadow: none; -moz-box-shadow: none;box-shadow: none;border: 0;}'))),
            ),width = 12),
        box(title = 'Missing Data Profile', status = 'primary',solidHeader = T,
            renderPlot(plot_missing(rv$data,ggtheme = theme_minimal()))),
        box(title = 'Data Structure', status = 'primary',solidHeader = T,
            renderTable(data_structure(rv$data), width = '100%', striped = T)),
      )
      # browser()
    }
  })
  
  output$pg2 = renderUI({
    tagList(
      div(box(title = 'Univariate Distribution',solidHeader = T,
          'Univariate Distribution is the probability distribution of a single random variable. 
          In contrast, bivariate distributions have two variables and multivariate distributions have two or more.',HTML('<br/><br/>'),
          a("More info on Q-Q Plot", href="https://towardsdatascience.com/q-q-plots-explained-5aa8495426c0"),
          width = '100%'), class = 'col-12'),
      div(box(title = 'Histogram', status = 'primary',solidHeader = T,
          renderPlot(data_uv_histogram(rv$data)),
          width = '100%'),class = 'col-lg-12 col-xl-6'),
      div(box(title = 'QQ Plot', status = 'primary',solidHeader = T,
          renderPlot(data_uv_qq(rv$data)),
          width = '100%'),class = 'col-lg-12 col-xl-6'),
    )
  })  
  
  output$pg3 = renderUI({
    tagList(
      box(title = 'Correlation Analysis',solidHeader = T,
          'Correlation Analysis is used to test relationships between quantitative or categorical variables. 
          In other words, it\'s a measure of how things are related. 
          The study of how variables are correlated is called correlation analysis.',HTML('<br/><br/>'),
          'A correlation coefficient is a way to put a value to the relationship. 
          Correlation coefficients have a value of between -1 and 1. 
          A "0" means there is no relationship between the variables at all, 
          while -1 or 1 means that there is a perfect negative or positive correlation 
          (negative or positive correlation here refers to the type of graph the relationship will produce).',
          width = 12),
      box(title = 'Correlation Matrix', status = 'primary',
          solidHeader = T,renderPlot(data_correlation(rv$data)),
          width = 12)
    )
  })  
  
  output$pg4 = renderUI({
    # browser()
    tagList(
      div(box(title = 'Principal Components Analysis',solidHeader = T,
          'Principal Components Analysis (PCA) reduces dimensionality and redundancy by combining original variables in a way that maximizes variance.',
          HTML('<br/><br/>'),
          a("More info on PCA", href="https://towardsdatascience.com/principal-component-analysis-pca-79d228eb9d24"),
          width = '100%'),class = 'col-12'),
      div(box(title = 'Principal Components', status = 'primary',
          solidHeader = T,renderPlot(data_pca(rv$data)[[1]]),
          width = '100%'),class = 'col-md-12 col-lg-6'),
      div(box(title = 'Features Relative Importance', status = 'primary',
          solidHeader = T,renderPlot(data_pca(rv$data)[[2]]),
          width = '100%'),class = 'col-md-12 col-lg-6'),
    )
  })  
  
  output$pg5 = renderUI({
    tagList(
      box(title = 'Dataset', status = 'primary',
          solidHeader = T,DT::datatable(rv$data,width = '100%'),
          width = 12)
    )
  }) 

}