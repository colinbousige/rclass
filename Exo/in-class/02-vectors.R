library(tidyverse)

# # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 1
# # # # # # # # # # # # # # # # # # # # # # # # 

# Consider two vectors `x` and `y` such as:
x <- 1:5
y <- seq(0, 4, along=x)

# Without typing it into Rstudio, what are the values of `x`, `y`, and `x*y`?


# Consider two vectors `a` and `b` such as:

a <- c(1,5,4,3,6)
b <- c(3,5,2,1,9)

# Without typing it into Rstudio, what is the value of: `a<=b`?



# If 
x <- c(1:12, NA, 5:2)
# Without typing it into Rstudio, what is the value of: `length(x)`


# If 
a <- 12:5
# Without typing it into Rstudio, what is the value of: `is.numeric(a)`


# Consider two vectors `x` and `y` such as:
x <- 12:4
y <- c(0, 1, 2, 0, 1, 2, 0, 1, 2)
# Without typing it into Rstudio, what is the value of: `which(!is.finite(x/y))`?


# If 
x <- c('blue', 'red', 'green', 'yellow')
# Without typing it into Rstudio, what is the value of: `is.character(x)`?


# If 
x <- c('blue', 10, 'green', 20)
# Without typing it into Rstudio, what is the value of: `is.character(x)`?


# Assign value 5 to the variable x.
# Is there a difference between `1:x-1` and `1:(x-1)` ?
# Explain.



# Generate the sequence `9, 18, 27, 36, 45, 54, 63, 72, 81, 90` in 4 different manners.
c(___)
seq(___)
___:___
___

# Let `a <- c(2, 4, 6, 8)` and `b <- c(TRUE, FALSE, TRUE, FALSE)`.
# Without typing it into Rstudio, what will be the output for the R expression `max(a[b])`?


# # # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercice 2
# # # # # # # # # # # # # # # # # # # # # # # # # # # 

# We have the following `x` vector: `x <- c("10K", "100K", "200K", "500K", "1000K")`. Get rid of the  `"K"` character and turn this into a numerical vector.
# Hint: Use gsub() and as.numeric()

x <- c("10K", "100K", "200K", "500K", "1000K")



# # # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercice 3
# # # # # # # # # # # # # # # # # # # # # # # # # # # 

# We have the following `times` vector: `times <- c("010_min", "100_sec", "200_sec", "050_min")`
# We want a numerical vector containing times in seconds only.

# Using `substr()`, create 2 vectors `times_values` and `times_units` containing the numbers and the units from `times`.

times <- c("010_min", "100_sec", "200_sec", "050_min")
times_values <- substr(string, start, stop)
times_units  <- ___


# You could do the same using `strsplit()` and `unlist()`
strsplit("test", "e")
unlist(strsplit("test", "e"))


# Now, using `ifelse(test, yes, no)`, create the `times_sec` vector containing the numerical values of time all converted to seconds.

times_sec <- ifelse(test, yes, no)

# Finally, `tidyr` contains the `separate()` function that is very useful to do this kind of things. However, `separate()` takes a table as first argument, not a vector:

tibble(times) %>% 
    separate(input_column, output_columns, other_options)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 4
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Let's say we have this population data for these French cities for the two years 1962 and 2012:
# cities :
#     "Angers", "Bordeaux", "Brest", "Dijon", "Grenoble", "Le Havre",
#     "Le Mans", "Lille", "Lyon", "Marseille", "Montpellier", "Nantes",
#     "Nice", "Paris", "Reims", "Rennes", "Saint-Etienne", "Strasbourg",
#     "Toulon", "Toulouse"
# population in 1962 :
#     115273, 278403, 136104, 135694, 156707, 187845, 132181, 239955,
#     535746, 778071, 118864, 240048, 292958, 2790091, 134856, 151948,
#     210311, 228971, 161797, 323724
# population in 2012 :
#     149017, 241287, 139676, 152071, 158346, 173142, 143599, 228652,
#     496343, 852516, 268456, 291604, 343629, 2240621, 181893, 209860,
#     171483, 274394, 164899, 453317

# Create a `cities` vector containing all the cities listed above:

cities <- c(___)

# Create a `pop_1962` and `pop_2012` vectors containing the populations of each city at these years. Print the 2 vectors. 

pop_1962 <- c(___)
pop_1962
pop_2012 <- c(___)
pop_2012

# Use `names()` to name values of `pop_1962` and `pop_2012`. Print the 2 vectors again. Are there any change?

names(pop_1962) <- ___
names(pop_2012) <- ___

# What are the cities with more than 200000 people in 1962? Save the list of these cities into a vector named `cities200k`. For these, how many residents were there in 2012?

cities200k <- cities[___]
cities200k

# What is the population evolution of Montpellier and Nantes?


# Create a `pop_diff` vector to store population change between 1962 and 2012

pop_diff <- ___

# Print cities with a negative change

cities[___]

# Print cities which broke the 300000 people barrier between 1962 and 2012

pop_2012 > 300000

# Compute the total change in population of the 10 largest cities (as of 1962) between 1962 and 2012.

order(pop_1962)
ten_largest <- cities[___]
sum(___)

# Compute the population mean for year 1962


# Compute the population mean of Paris over these two years

mean(___)

# Sort the cities by decreasing order of population for 1962

sort(___, ___)



