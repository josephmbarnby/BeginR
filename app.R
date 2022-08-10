
#install.packages(c('ggplot2','dplyr', 'shiny'))
library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(patchwork)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(h1("Basic Reinforcement Learning Tutorial")),
    titlePanel(h4(HTML(paste(
                    "This is an introduction to creating a basic algorithm that learns the value of its environment.",
                  "<br/>",
                  "Here the agent is placed in an environment where it learns about the value of two cards.
                  On each trial it samples a card to learn whether it gained a reward.
                  Over time the agent will come to learn which card will give it most reward; the
                  agent will seek to maximise its return.",
                  "<br/>",
                  "The way in which the agent acts upon the environment to maximise its return is to convert its beliefs into actions",
                  "<br/>",
                  "<i><center> Beliefs </i> &#8594; <i> Actions </i></center>",
                  "<br/>",
                  "The rate at which the agent will explore its environment, generate new beliefs, and make optimised actions is governed by two parameters:
                  a learning rate (how quickly an agent learns from each reward) and a decision temperature (how noisily an agent chooses
                  between each option)",sep="<br/>")))),

    titlePanel(h4("This agent uses the following equations:")),
    br(),
    withMathJax(),
      tabPanel(
      title = "Diagnostics",
      h4(textOutput("diagTitle")),
      uiOutput("formula")
      ),
    br(),
    titlePanel(h4(HTML(paste("Move the sliders to change the task structure and agent policy.",
                  "<br/>",
                  "The black dashed line is the probability that the agent will choose Card 1,
                  and the coloured lines are the internal beliefs the agent holds about the value of each card.",
                  "</br/>",
                  "Click 'Select a new agent' to start a new agent from scratch using the same settings",
                  sep="<br/>")))),
    br(),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            actionButton("setseed", "Select a new agent"),
            br(),
            br(),
            sliderInput("lr",
                        HTML(paste("Learning Rate: (&lambda;)")),
                        min = 0.01,
                        max = 1,
                        value = 0.1,
                        step = 0.01),
            br(),
            sliderInput("tau",
                        HTML(paste("Decision Temperature: (&tau;)")),
                        min = 0.1,
                        max = 10,
                        value = 1,
                        step = 0.1),
            br(),
           # sliderInput("gamma",
           #             HTML(paste("Discount Rate: (&gamma;)")),
           #             min = 0,
           #             max = 1,
           #             value = 0,
           #             step = 0.1),
            sliderInput("trials",
                        "Task Length:",
                        min = 50,
                        max = 1000,
                        value = 500,
                        step = 50),
            br(),
            sliderInput("winprob",
                        "Win Probability of Card 2:",
                        min = 0,
                        max = 1,
                        value = 0.8,
                        step = 0.1),
           br()#,
           #actionButton("colour", "I'm bored of these colours")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot", height = '700px', width = 'auto')
        )
    ),

    titlePanel(h5(HTML(paste("CC <a href='https://www.joebarnby.com/'>Dr Joe M Barnby</a> 2022"))))

)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$formula <- renderUI({
    withMathJax(paste0("
                       $$Q^{t}_{c} = Q^{t-1}_{c} * \\lambda + ({Reward - Q^{t-1}_{c}})$$
                       $$p(\\hat{c} = c) = \\frac{e^{\\frac{Q^{t}_{c}}{\\tau}}}{\\sum_{c'\\in(c_1, c_2)} e^{\\frac{Q^{t}_{c'}}{\\tau}}}$$

                       $$\\text{Therefore, } Q^{t}_{c} = \\text{the internal beliefs the agent holds about the value of each card at each trial}$$
                       "))
    })

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        trials  <- input$trials
        lambda  <- input$lr
        tau     <- input$tau
        gamma   <- input$gamma
        seed    <- input$setseed

        actions <- 2
        Q2      <- matrix(NA, trials+1, actions)

        Q2[1,]  <- c(0.5, 0.5) # Initialize the first two actions as equal probabilities
        R2      <- matrix(c(1-input$winprob, input$winprob, input$winprob, 1-input$winprob), 2, 2)
        a       <- r <- prob_a1 <- rep(NA, trials+1)

        #Sample the cards
        observeEvent(input$setseed, {
          set.seed(sample(1:100000, 1))
        })

        #Set colours
        defcols <- c("#E41A1C" ,"#377EB8")
        #observeEvent(input$colour, {
        #defcols <- sample(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00",
        #                      "#FFFF33", "#A65628", "#F781BF"), 2, replace = F)
        #})

        for (t in 1:trials){

          #sample an action
          a1         <- exp(Q2[t,1]/tau)
          a2         <- exp(Q2[t,2]/tau)
          prob_a1[t] <- a1/(a1+a2)
          a[t]       <- sample(c(1,2),  1, T, prob = c(prob_a1[t], 1-prob_a1[t]))

          #sample a reward for the action
          prob_r     <- R2[a[t],]
          r[t]       <- sample(c(1, 0), 1, T, prob = prob_r)

          #update
          PE         <- r[t] - Q2[t, a[t]]

          #if(input$gamma > 0){
          #Q2[t+1, a[t]] <- Q2[t, a[t]] + lambda * (gamma * r + (max(Q2[t,]) - Q2[t, a[t]])) #RW equation w discount
          #} else{
          Q2[t+1, a[t]] <- Q2[t, a[t]] + (lambda * PE) #RW equation
          #}
          Q2[t+1,-a[t]] <- Q2[t,-a[t]]

        }

        # draw the choice selection

        colnames(Q2) <- c('Card 1', 'Card 2')
        mainplot <- Q2 %>%
          as.data.frame() %>%
          mutate(Trial = 0:trials,
                 ProbA1= prob_a1) %>%
          pivot_longer(1:2, 'Option', values_to = 'Q') %>%

          ggplot(aes(Trial, Q, color = Option))+
          geom_line()+
          geom_line(aes(Trial, ProbA1), linetype = 2, color = 'black')+
          #geom_text(x = trials*0.25, y = 0.05,
          #          label = paste('Total rewards received = ',sum(r[1:trials])),
          #          color = 'black', check_overlap = T, nudge_y = 0.1, fontface = 'bold', size = 5)+
          geom_hline(yintercept = c(input$winprob, 1-input$winprob),
                     color = defcols,
                     linetype = 2, alpha = 0.2)+
          coord_cartesian(ylim = c(0,1))+
          scale_color_brewer(palette = 'Set1')+
          labs(y = expression(paste('Q'[c]^t, '    &    p(' ,hat(c), '= c)')))+
          scale_y_continuous(breaks = seq(0, 1, 0.2), labels = seq(0, 1, 0.2))+
          theme_bw() +
          theme(text = element_text(size = 20),
                axis.title = element_text(size = 20),
                axis.text = element_text(size = 20),
                legend.title = element_blank(),
                legend.text = element_text(size = 20),
                legend.position = c(0.9, 0.1),
                legend.background = element_rect(color = 'black'))

        subplot <- data.frame(Action = a, Reward = r) %>%
          na.omit() %>%
          mutate(Action1  = ifelse(Action == 1, 1, 0),
                 Action2  = ifelse(Action == 2, 1, 0),
                 ActionS1 = sum(Action1),
                 ActionS2 = sum(Action2),
                 RewardS  = sum(Reward)) %>%
          dplyr::select(ActionS1, ActionS2, RewardS) %>%
          rename(`Card 1 Choices` = 1, `Card 2 Choices` = 2, `Rewards`= 3) %>%
          distinct() %>%
          pivot_longer(1:3, 'Index', values_to = 'Value') %>%
          ggplot(aes(Index, Value))+
          geom_col(fill = c(defcols, "#FFB302"), color = 'black')+
          coord_cartesian(ylim = c(0, trials))+
          labs(title = 'Sum of...')+
          theme_bw() +
          theme(text = element_text(size = 20),
                plot.title = element_text(face = 'bold', vjust = -6, hjust = 0.05),
                axis.title = element_blank(),
                axis.text = element_text(size = 20))
#
        (mainplot / subplot) & plot_layout(nrow = 2, heights = c(2,1))
    })
}

# Run the application
shinyApp(ui = ui, server = server)
