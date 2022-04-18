# Title: Data Explanatory Shiny App Extra Functions
# Date Commence: 2 December 2021
# By: Hafizuddin
# Maintainer: 
# Objective: To serve as the extra functions used in the server of the data explanatory shiny web app
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
library(DataExplorer)
library(ggplot2)
library(dplyr)
library(gridExtra)
library(data.table)

# functions
data_summary = function(data){
  df = introduce(data)
  df = data.frame(Name = colnames(df), Value = as.integer(unlist(df[1,])))
  # rename Name
  df$Name = gsub('_',' ',df$Name)
  # reformat memory
  df$Value[9] = format(object.size(data),'auto')
  # return data
  return(df)
}

data_percentage = function(data){
  # clean data
  summary = data_summary(data)[1:8,]
  summary$Value = as.integer(summary$Value)
  pies = list()
  # rows
  Val = c((summary$Value[1]-summary$Value[7]),summary$Value[7])
  Lab = c('Incomplete Rows','Complete Rows')
  rows_df = data.frame(Label = Lab, Value = Val)
  pies[[1]] = plot_pie(df=rows_df,maxVal=summary$Value[1],tajuk='Rows Summary')
  # columns
  Val = c(summary$Value[3],summary$Value[4])
  Lab = c('Discrete Columns','Continuous Columns')
  cols_df = data.frame(Label = Lab, Value = Val)
  pies[[2]] = plot_pie(cols_df,summary$Value[2],'Columns Summary')
  # Observations
  Val = c(summary$Value[6],(summary$Value[8]-summary$Value[6]))
  Lab = c('Missing Observations','Available Observations')
  obs_df = data.frame(Label = Lab, Value = Val)
  pies[[3]] = plot_pie(obs_df,summary$Value[8],'Observations Summary')
  # return data
  return(pies)
}

plot_pie = function(df,maxVal,tajuk){
  percent = round(df$Value*100/maxVal)
  pie = ggplot(df,aes(x='',y=Value,fill=Label)) + geom_bar(stat = 'identity',width = 1)
  pie = pie + coord_polar("y", start=0) + 
    geom_text(aes(label = paste0(percent, "%")), position = position_stack(vjust = 0.5))
  pie = pie + scale_fill_manual(values=c('#00bdc4','#f8766d',''))
  pie = pie + labs(x = NULL, y = NULL, fill = NULL, title = tajuk)
  pie = pie + theme_classic() + theme(axis.line = element_blank(),
                                      axis.text = element_blank(),
                                      axis.ticks = element_blank(),
                                      plot.title = element_text(hjust = 0.5, color = "#666666"))
  pie = pie + theme(legend.position = 'bottom')
  return(pie)
}

data_structure = function(data){
  data_classes = vector()
  for(i in 1:ncol(data)){data_classes = append(data_classes,class(data[,i]))}
  df = data.frame(Variable = colnames(data), Class = data_classes)
  return(df)
}

data_uv_histogram = function(data){
  idx = sapply(seq_len(ncol(data)),function(x) class(data[,x])) !='character'
  data = data[,idx]
  # plot histogram
  plts = lapply(colnames(data), function(df,column){
    ggplot(df,aes_string(x = column)) +
      geom_histogram(color = 'white',fill = '#00bdc4') +
      theme_minimal() + xlab(NULL) + ylab(NULL) + ggtitle(column) +
      theme(plot.title = element_text(hjust = 0.5))
  },df = data)
  # arrange plot in a grid
  nCol = ceiling(sqrt(length(plts)))
  do.call('grid.arrange', c(plts,ncol = nCol,left = 'Frequencies', bottom = 'Values'))
}

data_uv_qq = function(data){
  idx = sapply(seq_len(ncol(data)),function(x) class(data[,x])) !='character'
  data = data[,idx]
  # plot histogram
  plts = lapply(colnames(data), function(df,column){
    ggplot(df,aes_string(sample = column)) +
      stat_qq(color = '#00bdc4') + stat_qq_line(color = '#f8766d') +
      theme_minimal() + xlab(NULL) + ylab(NULL) + ggtitle(column) +
      theme(plot.title = element_text(hjust = 0.5))
  },df = data)
  # arrange plot in a grid
  nCol = ceiling(sqrt(length(plts)))
  do.call('grid.arrange', c(plts,ncol = nCol,left = 'y', bottom = 'x'))
}

data_correlation = function(data){
  intro = introduce(data)
  if (intro[["complete_rows"]] > 0) {
    data = dummify(data)
    data = split_columns(data)$continuous
    data = na.omit(data)    
    plot_correlation(data,ggtheme = theme_minimal())
  }
}

data_pca = function(data, variance_cap = 0.8, parallel = FALSE){
  intro = introduce(data)
  if (intro[["complete_rows"]] > 0) {
    # standardize data
    data = dummify(data)
    data = split_columns(data)$continuous
    data = na.omit(data)
    # get pca data
    pca = prcomp(data,retx = F,scale. = T)
    var_exp <- pca$sdev^2
    pc_var <- data.table(pc = paste0("PC", seq_along(pca$sdev)), 
                         var = var_exp, pct = var_exp/sum(var_exp), cum_pct = cumsum(var_exp)/sum(var_exp))
    min_cum_pct <- min(pc_var$cum_pct)
    pc_var2 <- pc_var[cum_pct <= max(variance_cap, min_cum_pct)]
    pc_var2$percent = paste0(round(pc_var2$cum_pct*100),'%')
    # first plot
    varexp_plot <- ggplot(pc_var2, aes(x = reorder(pc, pct), y = pct)) + 
      geom_bar(stat = "identity", fill = '#00bdc4') + scale_y_continuous(labels = scales::percent) + 
      coord_flip() + labs(x = "Principal Components", y = "% Variance Explained") + 
      geom_label(mapping = aes(label = percent)) + theme_minimal() + 
      ggtitle('% Variance Explained By Principal Components\n(Note: Labels indicate cumulative % explained variance)')
    # second plot
    rotation_dt <- data.table(Feature = rownames(pca$rotation), 
                              data.table(pca$rotation)[, seq.int(nrow(pc_var2)), with = FALSE])
    melt_rotation_dt <- melt.data.table(rotation_dt, id.vars = "Feature")
    feature_names <- rotation_dt[["Feature"]]
    layout <- DataExplorer:::.getPageLayout(3, 3, ncol(rotation_dt) - 1L)
    plot_list <- DataExplorer:::.lapply(parallel = parallel, X = layout[[1]], FUN = function(x) {
      ggplot(melt_rotation_dt[variable %in% paste0("PC", x)],
             aes(x = Feature, y = value)) + 
        geom_bar(stat = "identity", fill = '#00bdc4') + 
        ggtitle(paste0('PC',x)) + theme(plot.title = element_text(hjust = 0.5)) +
        coord_flip() + ylab("Relative Importance")
    })
    pc_plot = ggarrange(plotlist = plot_list,ncol = 3)
    # return data
    return(list(varexp_plot,pc_plot))
  }
}
