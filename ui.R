# Title: Data Explanatory Shiny App User Interface
# Date Commence: 2 December 2021
# By: Hafizuddin
# Maintainer: 
# Objective: To serve as the user interface of the data explanatory shiny web app
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
library(shinyjs)
library(shinyWidgets)

ui = dashboardPage(
  header = dashboardHeader(title = 'Data Explorer',
                           tags$li(class = 'dropdown',
                                   actionBttn('reset',
                                              label = 'Reset Data',
                                              style = 'jelly',
                                              color = 'danger',
                                              size = 'sm'),
                                   tags$style('#reset {margin: 10px}')
                                   # tags$style('.navbar {position:fixed}')
                                   )),
  sidebar = dashboardSidebar(
    sidebarMenu(id = 'sidebar',
                menuItem('Dataset Summary',
                         tabName = 'tab1'),
                menuItem('Univariate Distribution',
                         tabName = 'tab2'),
                menuItem('Correlation Analysis',
                         tabName = 'tab3'),
                menuItem('Principal Component Analysis',
                         tabName = 'tab4'),
                menuItem('View Dataset',
                         tabName = 'tab5')
                # style = 'position:fixed'
                )),
  body = dashboardBody(
    useShinyjs(),
    fluidPage(uiOutput('mainpage')),
    tags$script(HTML("$('body').addClass('fixed');"))
  )
)