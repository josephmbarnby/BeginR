
# Load libs ---------------------------------------------------------------

library(tidyverse)

# Load Data ---------------------------------------------------------------

wcmatches <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-29/wcmatches.csv')
worldcups <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-29/worldcups.csv')
mydata   <- wcmatches

# Visualise ---------------------------------------------------------------

  ## Data

  exampleviz <- newdata %>%
    pivot_longer(home_team:away_team, names_to = 'Home_Away', values_to = 'Team')%>%
            mutate(dayofweek = factor(dayofweek, levels = c(
              'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
              ordered = T))

  ## Aesthetics

  ggplot(exampleviz,           # this is the dataframe we're wanting to visualise
         aes(x = home_score,   # my x axis variables
             y = away_score,
             fill = dayofweek)
         ) +                   # the '+' signifies we want another layer added below

  ## Geometries

  geom_jitter(shape = 21, colour = 'black')
  geom_smooth(aes(x = home_score, y = away_score), color = 'blue', fill = 'grey', method = 'lm')

  ## Facets

  facet_wrap(~dayofweek, nrow = 1) +

  ## Statistics

  stat_smooth(method = 'lm')+

  ## Coordinates

  labs(x = 'Home Score', y = 'Away Score')+
  coord_cartesian(xlim = c(0,10))+
  scale_x_continuous(breaks = c(0, 5, 10))+

  ## Theme

  theme_bw()+
  theme(text = element_text(size = 14),
        legend.position = 'none')

# Joes example ------------------------------------------------------------

library(tidybayes)
library(ggpubr)
library(ggflags)

vizdata <- newdata %>%
            pivot_longer(home_team:away_team, 'Position', values_to = 'Team') %>%
            group_by(Team) %>%
            mutate(n = sum(n())) %>%
            filter(n>30,
                   !Team %in% c('Yugoslavia',
                              'West Germany',
                              'Soviet Union')) %>%
            group_by(Team, dayofweek) %>%
            summarise(Goals = sum(TotalGoals)/n) %>%
            mutate(dayofweek = factor(dayofweek, levels = c(
              'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
              ordered = T),
              code = case_when(
                Team == 'Argentina' ~ 'ar',
                Team == 'Belgium' ~ 'be',
                Team == 'Brazil' ~ 'br',
                Team == 'Chile' ~ 'cl',
                Team == 'England' ~ 'gb',
                Team == 'France' ~ 'fr',
                Team == 'Germany' ~ 'de',
                Team == 'Hungary' ~ 'hu',
                Team == 'Italy' ~ 'it',
                Team == 'Mexico' ~ 'mx',
                Team == 'Netherlands' ~ 'nl',
                Team == 'Poland' ~ 'pl',
                Team == 'South Korea' ~ 'kr',
                Team == 'Spain' ~ 'es',
                Team == 'Sweden' ~ 'se',
                Team == 'Switzerland' ~ 'ch',
                Team == 'United States' ~ 'us',
                Team == 'Uruguay' ~ 'uy',
                TRUE ~ as.character(Team)
              )) %>%
            distinct()

ggplot(vizdata,
       aes(Goals, fct_rev(Team), fill = dayofweek))+
  geom_point(shape = 21, size = 3, colour = 'black')+
  geom_flag(aes(country = code), x = -0.05, size = 6)+
  labs(x = 'Standardised Goals', x = '',
       title = 'Do weekends make better games?',
       subtitle = 'Standardised goals scored by day of the week',
       caption = 'Goals weighted by total goals scored from 1930-2018 | CC JMBarnby')+
  scale_fill_brewer(name = 'Day')+
  theme_bw() +
  theme(axis.title.y = element_blank(),
        legend.position = c(0.8, 0.8),
        legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        legend.background = element_rect(colour = 'black'),
        text = element_text(size = 22, family = 'Helvetica'),
        plot.caption = element_text(size = 14, face = 'italic', colour = 'grey'),
        plot.subtitle = element_text(size = 16, face = 'italic', color = 'grey'),
        plot.title = element_text(face = 'bold'))+
  annotate(x = c(1, 1.7), y = 11,
           geom = 'line', size = 1, arrow = arrow(type = 'closed'))+
  annotate(x = c(1.35), y = 10,
           geom = 'text', label = 'The Sunday Effect',
           size = 8)


