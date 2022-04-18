# Test 1: Switch
# server = function(input, output) {
# 
#   rv = reactiveValues(data = NULL)
# 
# 
#   output$mainpage = renderUI({
#     abc = ifelse(input$reset == TRUE,"YES","NO")
#     switch(
#       abc,
#       "NO" = uiOutput("page_data_entry"),
#       "YES" = uiOutput("page_vis")
#     )
#   })
# 
#   output$page_data_entry = renderUI({
#     tagList(
#           fileInput("file", label = h3("File input")),
# 
#           hr(),
#           fluidRow(column(4, verbatimTextOutput("value")))
#         )
#   })
# 
#   output$page_vis = renderUI({
#     tagList(
#           actionButton("test","test")
#         )
#   })
# 
# 
#   output$value <- renderPrint({
#     rv$data = input$file
#     str(input$file)
#     cat("Value Reset: ",input$reset, " Value Data",is.null(rv$data))
#   })
# }

# Test 2: IFelse
# server = function(input, output) {
# 
#   rv = reactiveValues(data = NULL)
# 
# 
#   output$mainpage = renderUI({
#     if(is.null(rv$data)){
#       tagList(
#         fileInput("file", label = h3("File input Case 1")),
# 
#         hr(),
#         fluidRow(column(4, verbatimTextOutput("value")))
#       )
#     }else if(!is.null(rv$data) & input$reset == FALSE){
#       tagList(
#         actionButton("test","Case2")
#       )
#     }else if(!is.null(rv$data) & input$reset == TRUE){
#       tagList(
#         fileInput("file", label = h3("File input Case 3"))
#       )
#     }
# 
#   })
# 
#   output$value <- renderPrint({
#     rv$data = input$file
#     str(input$file)
#     cat("Value Reset: ",input$reset, " Value Data",is.null(rv$data))
#   })
# }



# switch

# server = function(input, output) {
# 
#   rv = reactiveValues(data = NULL)
# 
# 
#   output$mainpage = renderUI({
#     abc = ifelse(input$reset == TRUE,"YES","NO")
#     switch(
#       abc,
#       "NO" = tagList(
#         fileInput("file", label = h3("File input Case 1")),
# 
#         hr(),
#         fluidRow(column(4, verbatimTextOutput("value")))
#       ),
#       "YES" = tagList(
#         actionButton("test","Case2")
#       ))
# 
#   })
# 
#   output$value <- renderPrint({
#     rv$data = input$file
#     str(input$file)
#     cat("Value Reset: ",input$reset, " Value Data",is.null(rv$data))
#   })
# }


# switch
server = function(input, output) {
  
  rv = reactiveValues(data = NULL)
  
  
  output$mainpage = renderUI({
    rv_null = ifelse(is.null(rv$data),'yes',
                     ifelse(input$reset,'no yes','no no'))
    switch(rv_null,
           'yes'= uiOutput("dataui"),
           'no yes'= uiOutput("dataui"),
           'no no'= uiOutput("vis")
    )
    
  })
  
  
  output$vis <- renderUI({
    actionButton("test","Case2")
  })
  
  output$dataui <- renderUI({
    tagList(
      fileInput("file", label = h3("File input Case 1")),
      hr(),
      fluidRow(column(4, verbatimTextOutput("value")))
    )
  })
  
  output$value <- renderPrint({
    # browser()
    rv$data = input$file
    str(input$file)
    cat("Value Reset: ",input$test2, " Value Data",is.null(rv$data))
  })
}


# Test3: Using conditionalpanel at UI
# server = function(input, output) {
# 
#   rv = reactiveValues(data = NULL)
# 
#   output$value <- renderPrint({
#     rv$data = input$file
#     str(input$file)
#     cat("Value Reset: ",input$reset, " Value Data",is.null(rv$data))
#   })
# }