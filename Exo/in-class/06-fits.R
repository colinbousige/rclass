library(tidyverse)

# # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 1
# # # # # # # # # # # # # # # # # # # # # # # # # # 

# Let's say we have these data in a tibble called `df` and want to fit them with a linear model:

x <- 1:10
y <- 0.5*x + runif(length(x))*0.8
df <- tibble(x,y)
ggplot(df, aes(x = x, y = y)) +
    expand_limits(x=0,y=0)+
    geom_point()

# Let's fit it with free parameters:

head(df,2)
fit <- lm(data = ___, ___ ~ ___)
# Print the fit summary
summary(___)
# Let's plot the result
df %>%
    ggplot(aes(x = x, y = y)) +
    expand_limits(x = 0, y = 0) +
    geom_point()+
    geom_line(aes(y = predict(fit)), col="red")


# Now let's say we want to fix the intercept in 0 or in 1, how would you do it?

fit_fixed0 <- lm(data = ___, ___ ~ ___)
fit_fixed1 <- lm(data = ___, ___ ~ ___)
# Let's plot the result and compare it to the previous one
df %>%
    ggplot(aes(x = x, y = y)) +
    expand_limits(x = 0, y = 0) +
    geom_point() +
    geom_line(aes(y = predict(fit), col = "Free")) +
    geom_line(aes(y = predict(fit_fixed0), col = "Fixed 0")) +
    geom_line(aes(y = 1 + coef(fit_fixed1) * x, col = "Fixed 1"))



# # # # # # # # # # # # # # # # # # # # # # # # # # #  
## Exercise 2
# # # # # # # # # # # # # # # # # # # # # # # # # # #  

# Load the `tidyverse` library, then read the file `"Data/exo_fit.txt"` into a `tibble` called `tofit`.

library(___)
tofit <- ___
tofit
```

# Plot all columns as a function of `x` to see your data. For this, use on-the-fly the function `pivot_longer()` to turn the tibble into a tidy one:

tofit %>% 
    pivot_longer(cols = ___, # what column do we keep? cols = -this_column
                 values_to = ___, # name of the column gathering the values
                 names_to = ___ # names of the column gathering the variable names
                 ) %>% 
    ggplot(aes(x = ___, y = ___)) + # what columns contain the x and y values?
        geom_point() + # plot with points
        facet____(~ ___, scales = ___) # put the plots on a grid varying according to a column, with free scales

# Using `lm()` or `nls()` fit each column as a function of `x` and display the "experimental" data and the fit on the same graph.
# Tip: Take a look at the function `dnorm()` to define a Gaussian

fit_y <- lm(data = ___, ___) # what is the dataframe? what do we fit against what?
# predict(fit_y)
# coef(fit_y)
P1 <- ___ %>% # what dataframe are we working on?
    ggplot(aes(x = ___, y = ___)) + # what are the x and y values of the plot?
        geom____() + # plot the data to fit with points
        geom_line(___, col = ___) # how do we add the fitted values with a red line?

# # # # # # # # # # # # # # # # # # # # # # #
fit_z <- nls(data = ___, # the data
    ___, # the function
    start = list(___) # the list of starting parameters
)
P2 <- ___ %>% 
    ggplot(___) +
        ___

# # # # # # # # # # # # # # # # # # # # # # #
fit_w <- lm(___) # how can we fit w with a linear function?
P3 <- ___ %>% 
    ggplot(___) +
        ___

# # # # # # # # # # # # # # # # # # # # # # #
fit_u <- lm(___) # how can we fit u with a linear function?
P4 <- ___ %>% 
    ggplot(___) +
        ___

# # # # # # # # # # # # # # # # # # # # # # #
fit_s <- ___ # linear or non-linear fit?
P5 <- ___ %>% 
    ggplot(___) +
        ___

# # # # # # # # # # # # # # # # # # # # # # #
library(patchwork) # to gather the plots on a grid easily
P1 + P2 + P3 + P4 + P5 # plot on a grid




