library(tidyverse)
library(readr)
library(magrittr)
library(dplyr)
library(data.table)
library(knitr)
library(ggplot2)
library(plotly)
install.packages("plotly")

#1

children_per_woman<-read.csv("C:/Users/Lenovo/Documents/Assignment_R/children_per_woman_total_fertility.csv")
children <- data.frame(children_per_woman)
print (children)
income_per_person<-read.csv("C:/Users/Lenovo/Documents/Assignment_R/income_per_person_gdppercapita_ppp_inflation_adjusted.csv")
income <- data.frame(income_per_person)
print (income)
pop_total<-read.csv("C:/Users/Lenovo/Documents/Assignment_R/population_total.csv")
pop <- data.frame(pop_total)
print (pop)
reli<-read.csv("C:/Users/Lenovo/Documents/Assignment_R/religion.csv")
religion <- data.frame(reli)
print (religion)

#2

religion$Religion=colnames(religion[7:14])[apply(religion[7:14],1,which.max)]


#3
#a
children1=children %>% 
  select(Country, 'X1800':'X2018') %>% 
  pivot_longer(col=-Country,
               names_to="Year", 
               values_to="Fertility",
               names_transform=list(Year = as.character))
Year_children=c() 
for (i in 1:40296){
  Year_children<-append(Year_children, as.numeric(substr(children1$Year[i],2,5)))
}
children1$Year<-Year_children
print(children1)
#3
#b
income1=income %>% 
  select(Country, 'X1800':'X2018') %>% 
  pivot_longer(col=-Country,
               names_to="Year", 
               values_to="Income",
               names_transform=list(Year = as.character))
Year_income=c() 
for (i in 1:42267){
  Year_income<-append(Year_income, as.numeric(substr(income1$Year[i],2,5)))
}
income1$Year<-Year_income
print(income1)
#3
#c
pop_total1=pop_total %>% 
  select(Country, 'X1800':'X2018') %>% 
  pivot_longer(col=-Country,
               names_to="Year", 
               values_to="Population",
               names_transform=list(Year = as.character))
Year_pop_total=c() 
for (i in 1:42705){
  Year_pop_total<-append(Year_pop_total, as.numeric(substr(pop_total1$Year[i],2,5)))
}
pop_total1$Year<-Year_pop_total
print(pop_total1)

#4
total_dataset_c=children1[1:37887, 1:3]
total_dataset_i=income1[1:37887, 3]
total_dataset_p=pop_total1[1:37887, 3]
total_dataset_r=religion[, 15]
total_dataset_c$Income <-total_dataset_i
total_dataset_c$Population <-total_dataset_p
#Plotting
#1
theme_set(theme_bw())
dat_India<-subset(total_dataset_c,total_dataset_c$Country=="India")
#2
ggplot_income<-ggplot(data = dat_India, aes(x = Year, y = Income$Income)) + geom_point(size=3, colour="gray")
ggplot_income + ggtitle("Household Income in India") +
  xlab("Year") + ylab("Household income per capita per year [constant $]")
#3
ggplot_fertility<-ggplot(data = dat_India, aes(x = Year, y = Fertility)) + geom_line(size=2, colour="red")
ggplot_fertility + ggtitle("Fertility in India") +
  xlab("Year") + ylab("Children per Women")
#4
dat_India_region<-subset(total_dataset_c,total_dataset_c$Country==c("India", "Pakistan","Nepal", "Bangladesh"))

#5
Country_region = dat_India_region["Country"]

p<-lapply(Country_region, function(Country_region)
{
  ggplot(dat_India_region[dat_India_region[, "Country"]==Country_region,], aes(x = Year, y = Income$Income, colour=Country_region)) + geom_point(size=3)
})

lapply(p, function(x) print(x))

#6

q<-lapply(Country_region, function(Country_region)
{
  ggplot(dat_India_region[dat_India_region[, "Country"]==Country_region,], aes(x = Year, y = Fertility, colour=Country_region)) + geom_point(size=3)
})

lapply(q, function(x) print(x))

#7

P <- ggplot(data = dat_India, aes(x=Population$Population, y=Income$Income))+
  geom_point()
ggplotly(P)# add dynamicTicks=TRUE allows redrawing ticks when zooming in
P+xlab("Population") + ylab("Income")
