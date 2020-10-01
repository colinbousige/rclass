#loading Tidyverse Library 
library(tidyverse)
#Download the TGA data file ATG.txt
df<- read.table("/Users/toshiba/Desktop/joseph university-france/R in class/ATG.txt",
                skip=12,
                header=FALSE,
                nrows=4088 )
names(df) <- c("index", "T", "Ts", "Tr", "Value")
#trial to see the resulting table
#write df ctrl+enter 
df
#load into a tibble
df <-tibble(df)
#plot the mass (column Value) as a function of the temperature Tr (Temperature Read) with lines, using ggplot2
library(ggplot2)
df %>%
ggplot(aes(x= Tr, y= Value ))+ 
  geom_point()+
#Define nice axis labels with the units
labs(x= "Tr [°C]", y="Mass [mg]")
#Remove data from the temperature decrease
df <- subset(df, T <=11100)
#in order to have the same graph as the one in the question sheet, the first part should be removed 
df <-subset(df, T>=1800)
#Convert degrees Celsius to Kelvins
df %>%
  mutate(Tr=Tr+273)

#plot the curve but in Kelvin 
df %>%
ggplot(aes(x= Tr, y= Value ))+
  geom_point()+
#Define nice axis labels with the units
labs(x="Tr [k]", y="Mass [mg]")
#Write a function returning the derivative \(\partial y/\partial x\) given two vectors x and y
derv <- function(x,y){
  diff(y)/diff(x)
}
#Add the temperature derivative of the mass reading in a red dashed line in a panel below the previous graph
#Zoom on the data to see the variations
#Remove the x label of the top panel and have the same x axis for both panels
#Try to reproduce the following graph:
deriva <- derv(df$Value, df$Tr)
df %>%
ggplot(aes(x=Tr, y=deriva))+ 
geom_line()+
labs(x="Tr", y="Derivative", colour="red")



