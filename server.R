
# server logic
# Engineering VALUE rubric data by discipline
# bar plots of VALUE data for chosen discipline and all engineering; sample sizes are calculated 

source("set_up.R") #loads libraries and creates data frames for each discipline's scores


shinyServer(function(input, output) {

    plotInput<- reactive({

#if else statements for discipline    
    if(input$discipline == 1){
      disp = mech
      graph_title = "Mechanical Engineering VALUE Scores" 
      disp_legend_1  <- "Mechanical" # legend needs to be in three pieces to plot correctly for summary
      disp_legend_2 <- "Engineering"
      disp_legend_3 <- paste0("n = ", n_mech)
    }
    else if(input$discipline == 2){
      disp = ece
      graph_title = "Electrical and Computer Engineering VALUE Scores"
      disp_legend_1  <- "Electrical and"
      disp_legend_2 <- "Computer Engineering"
      disp_legend_3 <- paste0("n = ", n_ece)    
    } 
    else if(input$discipline == 4){
      disp = civl
      graph_title = "Civil Engineering VALUE Scores"
      disp_legend_1  <- "Civil"
      disp_legend_2 <- "Engineering"
      disp_legend_3 <- paste0("n = ", n_civl)   
    }    
    else if(input$discipline == 5){
      disp = chee
      graph_title = "Chem Eng Chem VALUE Scores"
      disp_legend_1  <- "Chem Eng"
      disp_legend_2 <- "Chem"
      disp_legend_3 <- paste0("n = ", n_chee)   
    }  
    else if(input$discipline == 7){
      disp = mine
      graph_title = "Mining Engineering VALUE Scores"
      disp_legend_1  <- "Mining"
      disp_legend_2 <- "Engineering"
      disp_legend_3 <- paste0("n = ", n_mine)   
    } 
    else if(input$discipline == 8){
      disp = geoe
      graph_title = "Geological Engineering VALUE Scores"
      disp_legend_1  <- "Geological"
      disp_legend_2 <- "Engineering"
      disp_legend_3 <- paste0("n = ", n_geoe)   
    } 
    else if(input$discipline == 9){
      disp = enph
      graph_title = "Engineering Physics VALUE Scores"
      disp_legend_1  <- "Engineering"
      disp_legend_2 <- "Physics"
      disp_legend_3 <- paste0("n = ", n_enph)   
    } 
    else{ 
      disp = mthe
      graph_title = "Math and Engineering VALUE Scores"
      disp_legend_1  <- "Math and"
      disp_legend_2 <- "Engineering"
      disp_legend_3 <- paste0("n = ", n_mthe)   
    }

    
#set up data and labels for plot

all_eng_legend <- paste0("Second Year Engineering\nn = ", n_eng, "\n")

data <- rbind(disp, all_eng) # must be in this order to plot correctly

#learning outcomes
ps <- data %>% select(Discipline, PS1.1, PS2.1, PS3.1, PS4.1, PS5.1,PS6.1) %>% gather(learning_outcome, score, PS1.1:PS6.1) #na.rm=FALSE because some categories were not evaluated for some disciplines and need NA for bar widths to be correct
ct <- data %>% select(Discipline, CT1.1, CT2.1, CT3.1, CT4.1, CT5.1) %>% gather(learning_outcome, score, CT1.1:CT5.1)
wc <- data %>% select(Discipline, WC1.1, WC2.1, WC3.1, WC4.1, WC5.1) %>% gather(learning_outcome, score, WC1.1:WC5.1)

#summary
ps_avg <- data %>% select(Discipline, PS1.1, PS2.1, PS3.1, PS4.1, PS5.1,PS6.1)
ps_avg <- ps_avg %>% transmute(Discipline, PS = rowMeans( ps_avg[, -1], na.rm =TRUE )) 

ct_avg <- data %>% select(Discipline, CT1.1, CT2.1, CT3.1, CT4.1, CT5.1)
ct_avg <- ct_avg %>% transmute(Discipline, CT = rowMeans( ct_avg[, -1],  na.rm =TRUE )) 

wc_avg <- data %>% select(Discipline, WC1.1, WC2.1, WC3.1, WC4.1, WC5.1)
wc_avg <- wc_avg %>% transmute(Discipline, WC = rowMeans( wc_avg[, -1],  na.rm =TRUE )) 

#combine averages into one data frame and tidy
summary <- cbind(ps_avg, ct_avg, wc_avg) %>% #combine columns
  subset(select = c("Discipline", "PS", "CT", "WC")) %>% #take out repeated discipline column
  gather(learning_outcome, score, PS:WC) #tidy

# add column to summary data frame for colours
summary_colours <- data.frame(c('a','A','b','B','c','C'))
colnames(summary_colours) <- 'summary_colours'
summary <- summary %>% bind_cols(summary_colours)
#factor colour column to change order of legend
summary$summary_colours <- factor(summary$summary_colours, levels = c("a","b","c", "A","B","C")) # make sure lower case is matched to discipline and upper case to all eng


#if else statements for learning outcome
if(input$outcome == 1){ #problem solving
  learning = ps %>% rename(summary_colours = Discipline) # rename for graphing purposes
  x_labels <- c("Define\nProblem", "Identify\nStrategies", "Propose\nSolutions", "Evaluate\nPotential\nSolutions", "Implement\nSolutions", "Evaluate\nOutcomes")
  bar_colours <- c("#33cc44", "#1f7a29")
  id <- "Problem Solving Criteria"
  legend_text <- c(paste0(disp_legend_1, " ",disp_legend_2, "\n", disp_legend_3, "\n"), # discipline specific
                          all_eng_legend) #all eng
}
else if(input$outcome == 2){
  learning = ct %>% rename(summary_colours = Discipline) # rename for graphing purposes
  x_labels <- c("Explanation\nof Issues", "Evidence", "Influence of\nContext and\nAssumptions", "Student's\nPosition", "Conclusions")
  bar_colours <- c("#3388ee", "#1f528f")   
  id <- "Critical Thinking Criteria"
  legend_text <- c(paste0(disp_legend_1, " ",disp_legend_2, "\n", disp_legend_3, "\n"), # discipline specific
                   all_eng_legend) #all eng
}
else if(input$outcome == 3){
  learning = wc %>% rename(summary_colours = Discipline) # rename for graphing purposes
  x_labels <- c("Context and\nPurpose\nfor Writing", "Content\nDevelopment", "Genre and\nDisciplinary\nConventions", "Sources and\nEvidence", "Syntax and\nMechanics") 
  bar_colours <- c("#ff8833", "#cc5200")      
  id <- "Written Communication Criteria"
  legend_text <- c(paste0(disp_legend_1, " ",disp_legend_2, "\n", disp_legend_3, "\n"), # discipline specific
                   all_eng_legend) #all eng
}
else{ #summary
  learning = summary
  x_labels <- c("Problem\nSolving", "Critical\nThinking", "Written\nCommunication")
  bar_colours <- c("#99E6A2", "#99C4F6","#FFC499", "#33CC44", "#3388EE" ,"#FF8833")
  id <- "Learning Outcomes"
  legend_text <- c(disp_legend_1,disp_legend_2, disp_legend_3, 
                   "Second Year", "Engineering", paste0("n = ", n_eng))
}
# end of if else statements



#plot

ggplot(
  data = learning, 
  aes(x = learning_outcome, y = score, fill = summary_colours)
  )+
  geom_bar(
    stat = "identity",
    position = "dodge", 
    width = 0.5
    ) + 
  coord_cartesian(ylim = c(0, 4)) + 
  scale_x_discrete(labels = x_labels)+
  theme(
    axis.line = element_line("grey"), #change colour of x and y axis
    panel.grid.major.y = element_line("grey"), #change horizonatal line colour (from white)
    panel.background = element_rect("white"), #change background colour
    legend.text.align = 0.5, #center legend text (value 0 to 1)
    legend.key.height = unit(0.18, "inches"),
    panel.grid.major.x = element_blank(),
    plot.title = element_text(size = 15),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12) 
    ) +
  labs(title = graph_title, x = id, y = "Average Rubric Level") +
  scale_fill_manual(
    values =  bar_colours, 
    name = "Legend", 
    labels = legend_text
  ) # end ggplot definition


  }) # end plot definition


# plot graph
output$valuePlot <- renderPlot({
  ggsave("plot.pdf", plotInput())
  plotInput()  
})


# download pdf of graph
output$downloadPDF <- downloadHandler(
  filename = function() {"plot.pdf"},
  content = function(file) {
    file.copy("plot.pdf", file, overwrite=TRUE)
  }
)


})#end shiny server
