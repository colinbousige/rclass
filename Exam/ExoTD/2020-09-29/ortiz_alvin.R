title : "TGA Data: loading a complicated text file, derivative and plotting"

library(tidyverse)

##loading data from file ATG.txt
ATGdata <- read.table("Data/ATG.txt", skip=12, header=FALSE, nrows=4088)
ATGdata

names(ATGdata) <- c("Index","t","Ts","Tr","Value")
head(ATGdata)

##loading ATG.txt as tibble
ATG <- tibble(ATGdata)
ATG

##Plotting mass[Value,mg] as a function of temperature[Tr,degC]
library(ggplot2)

ATG %>% select(4,5) #Selecting columns 4(Tr) and 5(Value) for plotting

G <- ggplot(data=ATG, aes(x=Tr+273.15,y=Value)) + 
    labs(x='T[K]',y='mass[mg]')
G + geom_point()

##Removing data from the temperature decrease,
  #defining axis labels for the units,
  #converting Tr[C to K] and plotting

head(ATG,which.max(ATG$Tr))
head(ATG,which.max(ATG$Tr)) %>% ggplot(aes(x=Tr+273.15,y=Value))+
      labs(x='T[K]',y='mass[mg]') + 
      geom_line(linetype="solid", color="black", size=1) + 
      theme_classic()

##Summary of ATG.txt at which Tr is highest
summary(ATG)

##Writing a function returning the derivative dy/dx

D <- ATG %>% select(3,4,5)
D$diffX <- lead(D$Ts,1) - D$Ts;
D$diffY <- lead(D$Value,1) - D$Value;
D$Deriv <- (D$diffY/D$diffX);
D

##Plotting Temperature Derivative of Mass Reading

head(D,which.max(D$Tr))
head(D,which.max(D$Tr))%>% ggplot(aes(x=Tr+273.15,y=Deriv))+
  labs(x='T[K]',y='Derivative') + 
  geom_line(linetype="solid", color="red", size=1) + 
  ylim(-0.15,0.05)
