library("tidyverse")
library("dplyr")

getwd()
setwd(dir = "C:/Users/leodu/Desktop/Rfile/religion_and_babies")

### DATA
#1
woman <- read_csv("Data/children_per_woman_total_fertility.csv", col_names = TRUE,col_types = NULL)
incomes <- read_csv("Data/income_per_person_gdppercapita_ppp_inflation_adjusted.csv", col_names = TRUE, ,col_types = NULL)
population <- read_csv("Data/population_total.csv", col_names = TRUE, ,col_types = NULL)
religion <- read_csv("Data/religion.csv", col_names = TRUE, col_types = NULL)


head(woman)
head(incomes)
head(population)
head(religion)

#2
maxx <- max.col(religion[,7:14])+6
cc <- colnames(religion)[maxx]
cc= as.vector(cc)
religion <- mutate(religion,religion = cc)

#3
population <- population %>% select(Country,'1800':'2018') %>% pivot_longer(col=-Country, 
                                                                            names_to="Year", 
                                                                            values_to="Population",
                                                                            names_transform=list(Year = as.numeric))
population <- arrange(population, population$Year)

incomes <- incomes %>% select(Country,'1800':'2018') %>% pivot_longer(col=-Country,
                                                                      names_to="Year",
                                                                      values_to="Incomes",
                                                                      names_transform=list(Year = as.numeric))
incomes <- arrange(incomes, incomes$Year)

woman <- woman %>% select(Country,'1800':'2018') %>% pivot_longer(col=-Country, 
                                                                  names_to="Year", 
                                                                  values_to="Fertility",
                                                                  names_transform=list(Year = as.numeric))
woman <- arrange(woman, woman$Year)

annees <- c()
for (i in 1800:2018){
  annees <- c(annees,as.vector(rep(i,234)))
}
tt <- tibble(Country = rep(religion$Country[1:234],219), Year = annees, Religions = rep(religion$religion[1:234],219))
tt <- arrange(tt, tt$Year)

dat <- inner_join(population,incomes, by = NULL)
dat <- inner_join(dat,woman, by = NULL)
dat <- full_join(dat, tt, by = NULL)

###PLOTTING
#1
library("ggplot2")
theme_set(theme_bw())

#2

dat_france <- filter(dat, Country == "France")
dat_france


#3
library(patchwork)

plotincomes <-   ggplot(dat_france, aes(x = Year, y = Incomes)) + 
                 geom_point() + 
                 geom_smooth() +
                 geom_rect(aes(NULL,NULL, xmin = 1914, xmax = 1918, ymin = -Inf, ymax = +Inf, colour = NULL),
                    fill = 'grey', alpha = 0.01, show.legend = FALSE) +
                 geom_rect(aes(NULL,NULL, xmin = 1939, xmax = 1945, ymin = -Inf, ymax = +Inf, colour = NULL),
                    fill = 'grey', alpha = 0.01, show.legend = FALSE) +
                 ggtitle("Household Incomes in France") +
                 xlab("Year") +
                 ylab("household incomes per capita per year [constant $]")
plotfertility <-  ggplot(dat_france, aes(x = Year, y = Fertility)) + 
                  geom_point() + 
                  geom_smooth(col = "red") +
                  geom_rect(aes(NULL,NULL, xmin = 1914, xmax = 1918, ymin = -Inf, ymax = +Inf, colour = NULL),
                           fill = 'grey', alpha = 0.01, show.legend = FALSE) +
                  geom_rect(aes(NULL,NULL, xmin = 1939, xmax = 1945, ymin = -Inf, ymax = +Inf, colour = NULL),
                           fill = 'grey', alpha = 0.01, show.legend = FALSE) +
                  ggtitle("Fertility in France") +
                  xlab("Year") +
                  ylab("Children per woman")
plotincomes / plotfertility

#4
dat_neighbours <- filter(dat, Country == "France" | Country == "Belgium"| Country =="Switzerland"| Country =="Germany" | Country == "Italy" | Country == "Spain" | Country == "Luxembourg")
dat_neighbours

#5
dat_neighbours <- arrange(dat_neighbours,Country)
plotincomes <-  dat_neighbours %>% ggplot(aes(x = Year, y = Incomes, size = Population)) + 
  geom_point(aes(color=Country), alpha=0.2) +
  geom_rect(aes(NULL,NULL, xmin = 1914, xmax = 1918, ymin = -Inf, ymax = +Inf, colour = NULL),
            fill = 'grey', alpha = 0.01, show.legend = FALSE) +
  geom_rect(aes(NULL,NULL, xmin = 1939, xmax = 1945, ymin = -Inf, ymax = +Inf, colour = NULL),
            fill = 'grey', alpha = 0.01, show.legend = FALSE) +
  ggtitle("Household Incomes in France") +
  xlab("Year") +
  ylab("household incomes per capita per year [constant $]")
plotfertility <-  dat_neighbours %>% ggplot(aes(x = Year, y = Fertility, size = Population)) + 
  geom_point(aes(color=Country), alpha=0.2) + 
  geom_rect(aes(NULL,NULL, xmin = 1914, xmax = 1918, ymin = -Inf, ymax = +Inf, colour = NULL),
            fill = 'grey', alpha = 0.01, show.legend = FALSE) +
  geom_rect(aes(NULL,NULL, xmin = 1939, xmax = 1945, ymin = -Inf, ymax = +Inf, colour = NULL),
            fill = 'grey', alpha = 0.01, show.legend = FALSE) +
  ggtitle("Fertility in France") +
  xlab("Year") +
  ylab("Children per woman")
plotincomes / plotfertility

#6
library("plotly")
plotincomes <-  dat_neighbours %>% ggplot(aes(x = Incomes, y = Fertility, size = Population, frame = Year, id = Country)) + 
  geom_point(aes(color=Country), alpha=0.2) +
  ggtitle("Children per woman = f(Incomes)") +
  xlab("Incomes") +
  ylab("Children per woman")
ggplotly(plotincomes, dynamicTicks = TRUE)

