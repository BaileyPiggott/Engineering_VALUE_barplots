
# user interface definition
# Engineering VALUE rubric data by discipline

library(shiny)

shinyUI(fluidPage(
  
  headerPanel("Eng VALUE Scores"), 
  
  sidebarPanel(
    selectInput("discipline", "Discipline:",
                c("Mechanical" = 1, 
                  "Electrical and Computer" = 2, 
                  "Civil" = 4,
                  "Chemical and Eng Chem" = 5,
                  "Mining" = 7,
                  "Geological" = 8,
                  "Engineering Physics" = 9,
                  "Engineering Math" = 10
                )#end options
    ),#end selectInput
    
    selectInput("outcome", "Learning Outcome:", 
                c( "Summary" = 4,
                  "Problem Solving" = 1,
                  "Critical Thinking" = 2,
                  "Written Communication" = 3,
                  selected = 4
                  )
                ),
    downloadButton("downloadPDF", "Download PDF")

  ),#end sidebar panel
  
  mainPanel(
    plotOutput("valuePlot")
  )
  
))
