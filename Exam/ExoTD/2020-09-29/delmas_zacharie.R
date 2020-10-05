library(tidyverse)
df <- read.table("Data/ATG.txt",
                 skip = 12,
                 header = FALSE,
                 nrows = 4088 )
names(df) <- c("Index", "t", "Ts", "Tr", "Value")
df <- tibble(df)

library(ggplot2)
df %>% mutate(Tk=Value+273.15)
df <- subset(df, t<=11100 & t>1801) 
head(df)

df %>% 
  ggplot(aes(x=Tr+273.5, y=Value))+
  geom_point(size=0.5, color="black")+
  labs(x="Tr [K]", y="Mass [mg]")+
  theme_bw()+
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

dr <- function(x,y) {diff(y)/diff(x)}

Fc <- dr(df$Value, df$Tr)

Red <- data.frame(Fc, df$Tr)

Red %>% 
  ggplot(aes(x=Tr+273.5, y=Fc))+
  geom_point(size=0.5, color="red")+
  labs(x="Tr [K]", y="Derivative")+
  theme_bw()

install.packages("RGraphics")
install.packages("gridExtra")
library(RGraphics)
library(gridExtra)

P1 <- ggplot(df, aes(x=Tr+273.5, y=Value))+
  geom_point(size=0.5, color="black")+
  labs(x="Tr [K]", y="Mass [mg]")+
  theme_bw()+
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

P2 <- ggplot(Red, aes(x=Tr+273.5, y=Fc))+
  geom_point(size=0.5, color="red")+
  labs(x="Tr [K]", y="Derivative")+
  theme_bw()

grid.arrange(P1, P2)