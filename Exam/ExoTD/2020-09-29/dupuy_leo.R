#my own path
# path <- file.path("C:", "Users", "leodu", "Desktop", "Rfile")
path <- file.path("Data")

##Load the tidyverse package
library(tidyverse)

#Download the TGA data file ATG.txt

#Load it into a tibble.
TGA <- read.csv(file.path(path,"ATG.txt"), skip = 12, sep = "", strip.white = TRUE, header = FALSE, nrows = 4088)
colnames(TGA) <- c("Index","t","Ts","Tr","Value")

#the values in the tibble are character, I must convert the type of data in every column. 
for(ploup in 1:length(TGA)){
  TGA[,ploup] <- as.numeric(TGA[,ploup])
}

TGA <- tibble(TGA)

#I struggle with the following lines so I chose the previous method
#TGA <- read_delim(file.path(path,"ATG.txt"),delim = " ",skip = 12, n_max = 4088 ,col_names = FALSE, locale = locale(decimal_mark = ",", grouping_mark = ".",encoding = "UTF-8", asciify = FALSE))
#colnames(TGA) <- c("Index","t","Ts","Tr","Value")
#TGA

#test
typeof(TGA_tibble$Index)
head(TGA_tibble)

##Plot the mass (column Value) as a function of the temperature Tr (Temperature Read) with lines, using ggplot2
#Remove data from the temperature decrease
TGA <- TGA[max(which(TGA$Tr == 25)):which.max(TGA$Tr),]

#Define nice axis labels with the units
library(ggplot2)
plot_tr_mass <- ggplot(TGA,aes(x = TGA$Tr, y = TGA$Value)) + geom_line()
plot_tr_mass <- plot_tr_mass + ylab("Mass [mg]") + xlab("Tr [°C]")
plot_tr_mass

#Convert degrees Celsius to Kelvins
TGA$Tr <- TGA$Tr + 273.15
plot_tr_mass <- ggplot(TGA,aes(x = TGA$Tr, y = TGA$Value)) + geom_line()
plot_tr_mass <- plot_tr_mass + ylab("Mass [mg]") + xlab("Tr [K]")
plot_tr_mass

##Write a function returning the derivative ???y/???x given two vectors x and y
derivatives <- function(x,y){
  diff(y)/diff(x)
}

#test

length(TGA$Tr)
length(diff(TGA$Tr))

#Add the temperature derivative of the mass reading in a red dashed line in a panel below the previous graph
d <- TGA$Tr[1:(length(TGA$Tr)-1)]
plot_tr_derivative <- ggplot(TGA[1:(length(TGA$Value)-1),],aes(d,derivatives(TGA$Tr,TGA$Value))) + 
  geom_line(linetype = "dashed", col = "Red")
plot_tr_derivative <- plot_tr_derivative + ylab("derivative [mg/K]") + xlab("Tr [K]")

library("patchwork")
plot_total <- plot_tr_mass/plot_tr_derivative
plot_total

##Zoom on the data to see the variations
install.packages("plotly")
library("plotly")
plot_total_bis <- subplot(plot_tr_mass, plot_tr_derivative, nrows = 2, margin = 0.04, heights = c(0.6, 0.4), titleY = TRUE, shareY = FALSE)
plot_total_bis

#Remove the x label of the top panel and have the same x axis for both panels
# -> useless now if we use subplot

#Try to reproduce the following graph:

# "dynamic" way
abs <- TGA$Tr[which.min(derivatives(TGA$Tr,TGA$Value))]

d <- TGA$Tr[1:(length(TGA$Tr)-1)]
dd <- TGA$Value[1:(length(TGA$Value)-1)]

plot_tr_derivative <- ggplot(TGA[1:(length(TGA$Value)-1),],aes(d,derivatives(TGA$Tr,TGA$Value))) + 
  geom_line(linetype = "dashed", col = "Red") +
  geom_vline(xintercept = abs, linetype="dashed", color = "grey", size=1)
plot_tr_derivative <- plot_tr_derivative + ylab("derivative [mg/K]") + xlab("Tr [K]")

plot_tr_mass <- ggplot(TGA,aes(x = TGA$Tr, y = TGA$Value)) + 
  geom_line() +
  geom_vline(xintercept = abs, linetype="dashed", color = "grey", size=1)
   #theme(axis.text.x = element_blank())
plot_tr_mass <- plot_tr_mass + ylab("Mass [mg]") + xlab("Tr [K]")

plot_total <- subplot(plot_tr_mass,plot_tr_derivative, nrows = 2, titleY = TRUE, shareY = FALSE, titleX = TRUE, shareX = TRUE)
plot_total

#"static" way
abs <- TGA$Tr[which.min(derivatives(TGA$Tr,TGA$Value))]

d <- TGA$Tr[1:(length(TGA$Tr)-1)]
dd <- TGA$Value[1:(length(TGA$Value)-1)]

plot_tr_derivative <- ggplot(TGA[1:(length(TGA$Value)-1),],aes(d,derivatives(TGA$Tr,TGA$Value))) + 
  geom_line(linetype = "dashed", col = "Red") +
  geom_vline(xintercept = abs, linetype="dashed", color = "grey", size=.75)
plot_tr_derivative <- plot_tr_derivative + ylab("derivative [mg/K]") + xlab("Tr [K]")

plot_tr_mass <- ggplot(TGA,aes(x = TGA$Tr, y = TGA$Value)) + 
  geom_line() +
  geom_vline(xintercept = abs, linetype="dashed", color = "grey", size=.75) +
  theme(axis.text.x = element_blank())
plot_tr_mass <- plot_tr_mass + ylab("Mass [mg]") + xlab(element_blank())

plot_total <- plot_tr_mass/plot_tr_derivative
plot_total
