
install.packages(c('tidyverse', 'shiny'))
library(shiny)
library(tidyverse)

theme_set(theme_bw() +
            theme(text = element_text(size = 20)))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(h1("Basic Reinforcement Learning Agent Tutorial")),
    titlePanel(h4(HTML(paste(
                    "This is an introduction to creating a basic algorithm that learns the value of its environment.",
                  "<br/>",
                  "Here the agent is placed in an environment where it learns about the value of two cards.
                  On each trial it samples a card to learn whether it gained a reward.
                  Over time the agent will come to learn which card will give it most reward; the
                  agent will seek to maximise its return.",
                  "<br/>",
                  "The rate at which the agent will explore its environment is governed by two parameters:
                  a learning rate (how quickly an agent learns) and a decision temperature (how noisy an agent chooses
                  between each option)",sep="<br/>")))),

    titlePanel(h4("This agent uses the following equations:")),

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
                  sep="<br/>")))),
    br(),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("lr",
                        HTML(paste("Learning Rate: (&lambda;)")),
                        min = 0,
                        max = 1,
                        value = 0.1,
                        step = 0.01),
            sliderInput("tau",
                        HTML(paste("Decision Temperature: (&tau;)")),
                        min = 0,
                        max = 10,
                        value = 1,
                        step = 0.1),
           # sliderInput("gamma",
           #             HTML(paste("Discount Rate: (&gamma;)")),
           #             min = 0,
           #             max = 1,
           #             value = 0,
           #             step = 0.1),
            sliderInput("trials",
                        "Task Length:",
                        min = 0,
                        max = 1000,
                        value = 100,
                        step = 10),
            sliderInput("winprob",
                        "Win Probability of Card 2:",
                        min = 0,
                        max = 1,
                        value = 0.8,
                        step = 0.1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    ),

    titlePanel(h6("CC Dr Joe M Barnby 2022"))

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

        actions <- 2
        Q2      <- matrix(NA, trials+1, actions)

        Q2[1,]  <- c(0.5, 0.5) # Initialize the first two actions as equal probabilities
        R2      <- matrix(c(1-input$winprob, input$winprob, input$winprob, 1-input$winprob), 2, 2)
        prob_a1 <- rep(NA, trials+1)

        #Sample the cards
        for (t in 1:trials){

          #sample an action
          a1         <- exp(Q2[t,1]/tau)
          a2         <- exp(Q2[t,2]/tau)
          prob_a1[t] <- a1/(a1+a2)
          a          <- sample(c(1,2),  1, T, prob = c(prob_a1[t], 1-prob_a1[t]))

          #sample a reward for the action
          prob_r     <- R2[a,]
          r          <- sample(c(1, 0), 1, T, prob = prob_r)

          #update
          PE         <- r - Q2[t, a]

          #if(input$gamma > 0){
          #Q2[t+1, a] <- Q2[t, a] + lambda * (r + gamma * (max(Q2[t,] - Q2[t, a], 0))) #RW equation w discount
          #} else{
          Q2[t+1, a] <- Q2[t, a] + (lambda * PE) #RW equation
          #}
          Q2[t+1,-a] <- Q2[t,-a]

        }

        # draw the choice selection
        colnames(Q2) <- c('Card 1', 'Card 2')
        Q2 %>%
          as.data.frame() %>%
          mutate(Trial = 0:trials,
                 ProbA1= prob_a1) %>%
          pivot_longer(1:2, 'Option', values_to = 'Q') %>%

          ggplot(aes(Trial, Q, color = Option))+
          geom_line()+
          geom_line(aes(Trial, ProbA1), linetype = 2, color = 'black')+
          #geom_text(aes(trials/2, prob_a1[trials/2]),
          #          label = 'Probability of \n choosing card 1',
          #          color = 'black', check_overlap = T, nudge_y = 0.1, fontface = 'bold', size = 6)+
          geom_hline(yintercept = c(input$winprob, 1-input$winprob),
                     color = c("#377EB8", "#E41A1C"),
                     linetype = 2, alpha = 0.2)+
          coord_cartesian(ylim = c(0,1))+
          scale_color_brewer(palette = 'Set1')+
          labs(y = expression(paste('Q'[c]^t)))+
          scale_y_continuous(breaks = seq(0, 1, 0.2), labels = seq(0, 1, 0.2))+
          theme(axis.title = element_text(size = 20),
                axis.text = element_text(size = 20),
                legend.title = element_blank(),
                legend.text = element_text(size = 20),
                legend.position = c(0.9, 0.1),
                legend.background = element_rect(color = 'black'))
    })
}

# Run the application
shinyApp(ui = ui, server = server)
