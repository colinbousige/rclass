library(tidyverse)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 1
# # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Create a 3 column `data.frame` called `df` containing three columns `x`, `y` and `z` with:

# - `x` a vector from -pi to pi of length 10
# - `y` the sinus of `x`
# - and `z` the sum of the two first columns.

x <- ___
y <- ___
z <- ___
df <- data.frame()

# /!\ 
# With a tibble you could do all this in a single call, but NOT with a data.frame
data.frame(x = seq(-10,10), # you define the column x
           y = cos(x), # here to define the column y you refer to 
                       # the vector x that was created outside the call to data.frame
           z = x*y) # here to define the column z you refer to the vectors 
                    # x and y that were created outside the call to data.frame)
tibble(x = seq(-10,10),# you define the column x
       y = cos(x),# you define the column y by referring tho the column x previously defined
       z = x*y)   # you define the column z by referring tho the columns x and y previously defined

# Print the 4 first lines of the table df.
# Hint: Take a look at the head() function


# Print the second (*i.e.* `y`) column with three different methods.

df[___]
df[___]
df$___

# Modify the column `z` so that it contains its value minus its minimum.



# Print the average of the `z` column.
# Hint: look at the mean() function



# Using `plot(x,y)` where `x` and `y` are vectors, plot the 2nd column as a function of the first.

plot(___, ___)

# Look into the function `write.table()` to write a text file containing this `data.frame`.

write.table(___)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 2
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# We will work with 3 different files:
#     - "Data/rubis_01.txt"
#     - "Data/population.csv"
#     - "Data/FTIR_rocks.xlsx"

# Load them into separate `data.frames`. 
# Look into the options of `read.table()`, `read.csv()`, `readxl::read_excel()`, to get the proper data fields. 
# Make sure that the `rubis_01` data.frame has `w` and `intensity` as column names.

rubis_01   <- ___("Data/rubis_01.txt", ___)
population <- ___("Data/population.csv")
FTIR_rocks <- ___("Data/FTIR_rocks.xlsx")


# Print their dimensions and column names. 

# Dimensions
rubis_01
population
FTIR_rocks
# Names
rubis_01
population
FTIR_rocks

# Do the same things by loading directly into tibbles.
library(tidyverse)
rubis_01 <- read_table(___)
population <- read_csv(___)


# # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 3
# # # # # # # # # # # # # # # # # # # # # # # # # # 

# We will use the TGA data file `"Data/ATG.txt"`

# Load it into a `data.frame`. Look into the options of [`read.table()`](https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/read.table) to get the proper data fields.
# Hints:
# - check how many lines you have to read
# - check how many lines you have to skip before reading
# - you need to skip the line with the unit

d <- read.table("Data/ATG.txt",
                ___
                )
d

# Do the same using the `tidyverse` function [`read_table()`](https://www.rdocumentation.org/packages/readr/versions/1.3.1/topics/read_table):

library(tidyverse)
d <- read_table("Data/ATG.txt",
                ___
                )
d



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 4
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Load the `"Data/population.csv"` file into a `tibble` called `popul`.

library(___)
popul <- read____("Data/population.csv")

# What are the names of the columns? What's the dimension of the table ?

popul

# Are the data tidy? make the table tidy if needed

popul
popul.tidy <- popul %>% 
    pivot_longer(
        cols     = ___, # what are the columns we want to keep? -> -these
        names_to = ___, # name of the column gathering the original column names
        values_to= ___  # name of the column gathering the original column values
        )

# Create a subset containing the data for Montpellier using a [filtering](https://dplyr.tidyverse.org/reference/filter.html) function from the `tidyverse`.

mtp <- popul.tidy %>% ___

# What is the max and min of population in this city?


# The average population over time?


# What is the total population over all cities in 2012?

popul.tidy %>% 
    ___ %>%         # You need to filter the data for the year 2012
    ___ %>%         # Then select the right column
    ___             # And perform the sum of its data

# What is the total population per year?

popul.tidy %>% 
    ___ %>%    # You need to group data per year
    ___        # Then summarize the data of each year as 
               # the total population of each group

# What is the average population per city over the years?

popul.tidy %>%
    ___ %>%  # You need to group data per...?
    ___      # Then...?




# # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 5
# # # # # # # # # # # # # # # # # # # # # # # # # # 

# First, load the `tidyverse` and `lubridate` packages
___
___

# Load `"Data/people1.csv"` and `"Data/people2.csv"` into `pp1` and `pp2`, and take a look at them.

pp1 <- read____(___)
pp2 <- read____(___)

# Create a new tibble `pp` by using the pipe operator (`%>%`) and successively:
# - joining the two tibbles into one using `inner_join()`
# - adding a column `age` containing the age in years (use `lubridate::time_length(x, 'years')` with x a time difference in days) by using `mutate()`

pp <- pp1 %>%
    ___ %>%       # you need to join with pp2
    mutate(___)   # then add a column `age` computing the right thing
pp

# Display a summary of the table using `str()`


# Using `group_by()` and `summarize()`:
# - Show the number of males and females in the table (use the counter `n()`)
pp %>%
    ___ %>%
    ___
# - Show the average age per gender
pp %>%
    ___ %>%
    ___
# - Show the average size per gender and institution
pp %>%
    ___ %>%
    ___
# - Show the number of people from each country, sorted by descending population
pp %>%
    ___ %>%
    ___ %>%
    ___

# Using `select()`, display:
# - only the name and age columns
pp ___
# - all but the name column
pp ___

# Using `filter()`, show data only for:
# - Chinese people
pp ___
# - From institution ECL and UCBL
pp ___
# - People older than 22
pp ___
# - People with a `e` in their name
pp ___


# # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 6
# # # # # # # # # # # # # # # # # # # # # # # # # # 

# Here we will see how to load many files at once with the `tidyverse` and how to perform some data wrangling.

### Loading the data

# We will work with the files whose paths are stored in the vector `flist`. These files are all `.csv` files containing two columns and a header. We can use the fact that `read_csv()` accepts vectors as argument and read them all at once. 

# - Read them all in a tidy tibble called `tib`.
# - Make sure to add a column named `"file"` containing the list of filenames: look at the `id` parameter 
# - Modify this `"file"` column so that it contains just the file name and not the full path – look at the `basename()` function.

flist <- list.files(path="Data", pattern="sample")

tib <- read_csv(___,           # what do we want to read? give the vector of file names
                id = ___) %>%  # what is the name of the column containing the file names ?
        mutate(___)            # modify this column so that it contains just the file
                               # name and not the full path


### Operations on strings

# We also want to get information from our file names, such as the sample number, the temperature, the time, and the time unit. 
# Use the function [`separate()`](https://tidyr.tidyverse.org/reference/separate.html) to split the `file` column into `sample`, `T`, `time` and `time_unit`. 
# If applicable, make sure that the resulting columns are numeric by getting rid of the annoying characters.

tib <- tib %>% 
    separate(col = ___, # what is the column containing these informations
             into = ___, # vector of strings containing new column names (NA to drop a column)
             convert = ___) %>% # do we convert strings to numbers if applicable?
    mutate(sample = as.numeric(str_replace(___)),
           T = ___,
           time = ___,
           time_unit = ___
           )
tib

# Now we want all times to be in the same unit. Using `mutate()` and `ifelse()`, convert the minutes in seconds, then get rid of the `time_unit` column.

tib <- tib %>% 
    mutate(time = ifelse(test, yes, no)) %>% # convert minutes to seconds
    select(___) # get rid of the `time_unit` column
tib



### Plotting data

# Before going further, we want to take a look at our data using `ggplot`. Modify the following code so that a color is added as a function of the sample number, and the plots are gathered on a grid showing the time as a function of the temperature.

tib %>% 
    ggplot(aes(x = x, y = y, color = ___)) +
        geom_point() + 
        facet_grid(___ ~ ___)


### Nesting data

# We want to **nest** our data to be able to perform operations on them – like fitting them. Using the `nest()` function, nest the data so that we end up with only 4 columns: `sample`, `temp`, `time`, and `data`.
# Hint: What are the columns to nest ? data = c(these_columns), or data=-c(all_other_columns)
tib <- tib %>% 
    nest(___)
tib


### Fitting all data

# Now we can fit all our data at once with a linear model:
library(broom)

tib <- tib %>%
    mutate(fit = map(data, ~ lm(data = ., y ~ x)),
           tidied = map(fit, tidy),
           augmented = map(fit, augment))
tib
tib %>% unnest(tidied)
tib %>% unnest(augmented)

# Adding the linear model on the plot

tib %>% 
    unnest(augmented) %>% 
    mutate(time = factor(time)) %>% 
    ggplot(aes(x=x, y=y, color = time, group=time)) +
        geom_point() + 
        facet_grid(sample ~ temp)+
        geom_line(aes(y = .fitted), color="black")

