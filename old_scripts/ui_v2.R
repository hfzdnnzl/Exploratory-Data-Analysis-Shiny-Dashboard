
# library
library(shiny)
library(bs4Dash)

# ui
ui = dashboardPage(
  dashboardHeader(
    materialSwitch(
      inputId = "reset",
      label = "Reset",
      value = T,
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
