library(tidyverse)
# Part 1
children <-
  read_csv(
    "children.csv",
    col_names = TRUE,
    col_types = NULL
  )

income <-
  (
    read_csv(
      "income.csv",
      col_names = TRUE,
      col_types = NULL
    )
  )

pop <-
  read_csv("pop.csv")

religion <-
  read.csv("religion.csv")
dim(religion)
str(religion)
names(religion)
head(religion)
religion

# Part 2
maximum <- max.col(religion[, 7:14]) + 6
cc = colnames(religion)[maximum]
cc = as.vector(cc)
religion <- mutate(religion, Religion = cc)
religion

#Part 3
children %>% select(country,"1800":"2018") %>% pivot_longer(-country,names_to = "Year",values_to = "Fertility",names_transform = list(Year = as.numeric))


income %>% select(country,"1800":"2018") %>% pivot_longer(-country,names_to = "Year",values_to = "Income",names_transform = list(Year = as.numeric))



pop %>% select(country,"1800":"2018") %>% pivot_longer(-country,names_to = "Year",values_to = "Population",names_transform = list(Year = as.numeric))


# Part 4
library(dplyr)
df <-
  children %>% select(country,"1800":"2018") %>% pivot_longer(-country,names_to = "Year",values_to = "Fertility",names_transform = list(Year = as.numeric))
df
df1 <- income %>% select(country,"1800":"2018") %>% pivot_longer(-country,names_to = "Year",values_to = "Income",names_transform = list(Year = as.numeric))
df1
df2 <-pop %>% select(country,"1800":"2018") %>% pivot_longer(-country,names_to = "Year",values_to = "Population",names_transform = list(Year = as.numeric))
df2
df3 <- religion <- mutate(religion, Religion = cc)
df3
df4 <- inner_join(df, df1)
df4
df5 <- inner_join(df2, df3)
df5
dat <- inner_join(df4, df5)
dat

#Plotting
library(ggplot2)
head(dat)
library(plotly)
P <- ggplot(data = dat, aes(x=Population, y=Income))+
  geom_point()
ggplotly(P)
