install.packages("tidyverse")
library(tidyverse)
df <-read.table("Data/ATG.txt",
                skip = 12,
                header = FALSE,
                nrows = 4088 )

names(df) <- c("index", "t", "Ts", "Tr", "value")
df <- tibble(df) 
head(df)
#remove data from the temperature decrease
subset(df, t <= 11100)
#draw graph
library(ggplot2)
df %>% filter(value<30.6) %>% 
  ggplot(aes(x=Tr , y=value))+
  geom_point()+
# define axis labels
labs(x="Tr (C)", y="Mass (mg)")
 
#conversion to Kelvin
df %>% mutate(Value=value+273)
df %>% filter(value<30.6) %>%
  ggplot(aes(x=Tr, y=value))+

  geom_point()+
  labs(x="Tr (K)", y="Mass (mg)")

#derivation function
d1 <- function(x,y)
{diff(y)/diff(x)}

colors <- c("red")
d1 <- df %>% 
  ggplot(aes(x=?deriv(x), y=?deriv(y)))+
  geom_point()+
  labs(x="T (K)", y="derivative")



