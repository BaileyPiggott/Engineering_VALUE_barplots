
# user interface definition
# Engineering VALUE rubric data by discipline

library(shiny)

shinyUI(fluidPage(
  
  headerPanel("Eng VALUE Scores"), 
  
  sidebarPanel(
    selectInput("discipline", "Select Discipline:",
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
    downloadButton("downloadPDF", "Download PDF"), 
    
    # text description of app:
    
    br(),br(),
    h4("About This App"),
    p("This app displays second year engineering students' scores on the VALUE rubrics created 
      by the Association of American Colleges & Universities. The work sample that was marked 
      was the final P2 report from the APSC 200 course."),
    p("VALUE rubrics used to assess these reports were:"),
    tags$li("Problem Solving"),
    tags$li("Critical Thinking"),
    tags$li("Written Communication"),
    br(),
    p("Each of these three rubrics contained 5 or 6 categories. The rubrics can be found ", 
      a("here.", href = "https://www.aacu.org/value-rubrics")),
    br(),
    p("Learn more about the HEQCO Learning Outcomes Assessment Project ", 
      a("here.", href = "http://www.queensu.ca/qloa/"))
    

  ),#end sidebar panel
  
  mainPanel(
    plotOutput("valuePlot")
  )
  
))
