#1) Load the tidyverse
library(tidyverse)

#2) Download the ATG.txt file
df <- read.table("Data/ATG.txt", 
                 skip = 12,
                 header = FALSE,
                 nrows = 4088
                 )
names(df) <- c("Index", "t", "Ts", "Tr", "Value")

#3) Load into a table
df <- tibble(df)
head(df)
#4) Plot the mass (column Value) as a function of the temperature Tr 
library(ggplot2)
df %>%
  ggplot(aes(x=Tr, y=Value))+
  geom_point()+
  
#Change the axis labels
labs(x="Tr", y="The mass")

#5) Remove data from the temperature decrease
  df <- df %>% subset(t<11100)
  
  #deleting the equal values when Tr=25K
 df <- df %>% filter(Tr>25)
 
#6) Define nice axis labels with the units
labs(x="Tr [c]", y="The mass [Mg]")

#7) convert Celuis to Kalvin
df %>% mutate(Tr=Tr+273)
df %>%
  ggplot(aes(x=Tr, y=Value))+
  geom_point()+
  labs(x="Tr [K]", y="The mass [Mg]")

#8) Write a function returning the derivative ???y/???x given two vectors x and y
dr <- function(x,y) {
  diff(y)/diff(x)
  
}
#9) Add the temperature derivative of the mass reading in a red 
#dashed line in a panel below the previous graph


