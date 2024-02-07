
# Load libs ---------------------------------------------------------------

library(tidyverse)

# Load Data ---------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2023-06-06')
fuel_23  <- tuesdata$`owid-energy`
mydata   <- fuel_23

# Full codebook: https://github.com/owid/energy-data/blob/master/owid-energy-codebook.csv

# Visualise ---------------------------------------------------------------

  ## Data

  mydata_filtered <- mydata %>%
    filter(
      # the next line asks to remove all NA values for fossil fuel consumption
      # AND (&) gdp. The returned data frame will be conditional on these two logical
      # statements
      !is.na(fossil_fuel_consumption) & !is.na(gdp) & !is.na(coal_consumption),
      # This is asking that we only take the year 2010
      year %in% c(2000:2020),
      country != 'World'
      # If we wanted multiple years we could switch on the line below
      # and turn off the line above
      # year %in% c(2009, 2010, 2011, 2012)
      ) %>%
  mutate(renewables_ordinal = ntile(renewables_consumption, 3))

  ## Aesthetics

  ggplot(mydata_filtered,           # this is the dataframe we're wanting to visualise
         aes(x = fossil_fuel_consumption,   # my x axis variables
             y = gdp, # my y axis
             fill = factor(renewables_ordinal) # my grouping variable for colour
             )
         ) +                   # the '+' signifies we want another layer added below

  ## Geometries

  geom_jitter(shape = 21, colour = 'black')+

  ## Facets

  facet_wrap(~year)+

  ## Statistics

  #stat_smooth(method = 'lm')+
  scale_fill_brewer(palette = 'BuPu')+


  ## Coordinates

  labs(x = 'Fossil Fuel Consumption (Tonnes)', y = 'Gross Domestic Product ($)')+
  coord_cartesian(xlim = c(0,10000))+

  ## Theme

  theme_bw()+
  theme(text = element_text(size = 14),
        legend.position = 'none')

# Joes example ------------------------------------------------------------

library(tidybayes)
library(ggpubr)

vizdata <- mydata %>%
  filter(
      !is.na(fossil_fuel_consumption) & !is.na(gdp) & !is.na(renewables_consumption),
      year %in% c(1990:2020),
      country != 'World'
      ) %>%
  mutate(renewables_ordinal = ntile(renewables_consumption, 3),
         fossil_fuel_ordinal = ntile(fossil_fuel_consumption,3),
         renewables_ordinal = factor(renewables_ordinal),
         fossil_fuel_ordinal = factor(fossil_fuel_ordinal),
         renewables_ordinal = fct_recode(renewables_ordinal,
                            "Low" = '1',
                            "Medium" = '2',
                            "High" = '3'),
         fossil_fuel_ordinal = fct_recode(fossil_fuel_ordinal,
                            "Low" = '1',
                            "Medium" = '2',
                            "High" = '3'),) %>%
  group_by(year, fossil_fuel_ordinal) %>%
  dplyr::select(year, fossil_fuel_ordinal, gdp) %>%
  mutate(gdp = sum(gdp)) %>%
  distinct()

ggplot(vizdata,
       aes(year, gdp, fill = factor(fossil_fuel_ordinal)))+
  geom_line(size = 2)+
  geom_point(shape = 21, size = 5,
             colour = 'black')+
  labs(x = 'Year', y = 'Gross Domestic Product ($)',
       title = 'How has GDP increased with fossil fuel use?',
       subtitle = 'GDP from year 1990 to 2020',
       caption = 'CC JMBarnby')+
  scale_fill_manual(name = 'fossil_fuel_ordinal', values = c(
    "#08519C","#F9CB40", "#BA2D0B"
  ))+
  theme_bw() +
  theme(axis.title.y = element_blank(),
        legend.position = c(0.8, 0.5),
        legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        legend.background = element_rect(colour = 'black'),
        text = element_text(size = 24, family = 'Helvetica'),
        plot.caption = element_text(size = 16, face = 'italic', colour = 'grey'),
        plot.subtitle = element_text(size = 18, face = 'italic', color = 'grey'),
        plot.title = element_text(face = 'bold'))


