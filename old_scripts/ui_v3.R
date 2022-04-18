
# library
library(shiny)
library(bs4Dash)
library(shinyWidgets)

# ui
ui = dashboardPage(
  dashboardHeader(
    materialSwitch(
      inputId = "reset",
      label = "Reset",
      value = TRUE,
      status = "danger"
    )
  ),
  dashboardSidebar(disable = T),
  dashboardBody(
    fluidPage(
      uiOutput("mainpage")
    )
  )
)