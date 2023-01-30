library(tidyverse)
library(patchwork)
theme_set(theme_bw())

# # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 1
# # # # # # # # # # # # # # # # # # # # # # # # # # 

# We will work with the well known table `mtcars` included in R:

?mtcars


### Basic stuff 1

# Modify the following code to add a color depending on the `gear` column:
mtcars %>% # we work on the mtcars dataset, send it to ggplot
    # define the x and y variables of the plot, and also the color:
    ggplot(aes(x = wt, y = mpg))+ 
        geom_point() # plot with points

# Now change the color and shape of the points, and add transparency
mtcars %>% 
    ggplot(aes(x = wt, y = mpg))+ 
        geom_point(___)

### Basic stuff 2

# What happens if you use `factor(gear)` instead?

P <- mtcars %>% # we work on the mtcars dataset, send it to ggplot
    # define the x and y variables of the plot, and also the color:
    ggplot(aes(x = wt, y = mpg, color = gear))+ 
        geom_point() # plot with points

### Tuning the plot
# Using the previously defined plot P:
# Add nice labels : 
# - wt = Weight (1000 lbs)
# - mpg = Miles/(US) gallon
# - gear = Number of forward gears
# - title : add a title
# Set colors to :
# - ones you define yourself
# - ones you define from the palette 'Set1' from scale_color_brewer()
# Force the x and y ranges to reach 0
# Reorganise the gears in descending order in the legend

P + ___

### Faceting 1

# Modify the following code to place each `carb` in a different facet. Also add a color, but remove the legend.
mtcars %>% # we work on the mtcars dataset, send it to ggplot
    ggplot(aes(x = wt, y = mpg))+ # define the x and y variables of the plot, and also the color
        geom_point() +   # plot with points
        facet____(___) + # add a faceting
        theme(___)       # remove the legend


### Faceting 2

# Modify the following code to arrange `mpg` vs `wt` plots on a grid showing `gear` vs `carb`. Also add a color depending on `cyl`. Also, try adding a free `x` scale range, or a free `y` scale range, or free `x` and `y` scale ranges.
mtcars %>% # we work on the mtcars dataset, send it to ggplot
    ggplot(aes(x = ___, y = ___))+ # define the x and y variables of the plot, and also the color
        geom_point() +   # plot with points
        facet____(___) # add a faceting


# # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 2
# # # # # # # # # # # # # # # # # # # # # # # # # 

# We will look at data loaded into `df`. 
df <- read_table("Data/exo_fit.txt")
df

# Using `ggplot`, plot `y` as a function of `x` with points and save it into `Py`:

Py <- df %>% 
    ___
Py

# Add a straight line in `Py` resulting from a linear fit:

Py <- Py +
    geom_smooth(___)
Py

# Using `ggplot`, plot `z` as a function of `x` with a red line and save it into `Pz`:

Pz <- df %>% 
    ___
Pz

# Using `ggplot`, plot a histogram of `w` with transparent blue bars surrounded by a red line, and save it into `Pw`. You can play with the number of bins too.

Pw <- df %>% 
    ___
Pw

# Using `ggplot`, plot a density of `u` with a transparent blue area surrounded by a red line, and save it into `Pu`. Play with the `bw` parameter so that you see many peaks.

Pu <- df %>% 
    ___
Pu

# Using `patchwork`, gather the previous plots on a 2x2 grid.
library(patchwork)
Py
Pz
Pw
Pu

# Using `patchwork`, gather the previous plots on a grid with 3 plots in the 1st row, and one large plot in the 2nd row. Using `plot_annotation()`, add tags such as (a), (b)...

Py
Pz
Pw
Pu


# # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 3
# # # # # # # # # # # # # # # # # # # # # # # # # 

# Let's work on `faithfuld` and plot as a 3D color plot the density, as a function of eruptions vs waiting
# Plot with geom_contour_filled() or geom_raster() and see the difference
# Add big red diamond points in (4.4, 80) and (1.94, 53) using either geom_point() or annotate("point", ...)

faithfuld %>% 
    ggplot(___)+
        geom_contour_filled()

faithfuld %>% 
    ggplot(___)+
        geom_raster()



