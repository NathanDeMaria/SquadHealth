library(shiny)

# change to hover over rows/cols? :)

shinyUI(bootstrapPage(
  
# title
  h1(class='header',"Squad Health"),
  
  sidebarPanel(
    selectInput(inputId="time.period", label="Time Period:",
                choices)),
    htmlOutput('style'),
    htmlOutput('table')
  )
)