ui = dashboardPage(
  dashboardHeader(
    materialSwitch(
      inputId = "reset",
      label = "Reset",
      value = FALSE,
      status = "danger"
    )
  ),
  dashboardSidebar(disable = T),
  dashboardBody(
    fluidPage(
      uiOutput("mainpage")
    )
  )
  #title = "boxPad"
)

# # UI Test 3:
# ui = dashboardPage(
#   dashboardHeader(
#     materialSwitch(
#       inputId = "reset",
#       label = "Reset",
#       value = FALSE, 
#       status = "danger"
#     )
#   ),
#   dashboardSidebar(disable = T),
#   dashboardBody(
#     fluidPage(
#       conditionalPanel(
#         "input.reset == 1",
#         fileInput("file", label = h3("File input"))
#       ),
#       conditionalPanel(
#         "input.reset == 0",
#         actionButton("test","test")
#       )
#       
#     )
#   )
#   #title = "boxPad"
# )