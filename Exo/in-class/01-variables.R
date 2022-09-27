#################
### Variables ###
#################

# This code computes the answer to one plus one, change it so it computes two plus two:

1 + 1

# Attribute to `x` the value `2.5`, and compute the exponential of its squared value:

x <- ___
___

# Attribute the string `"100.3"` to the variable `x`, and the value 99.6 to the variable `y`:

x <- ___
y <- ___

# Assuming the `x` and `y` defined above, modify the following code so that it does not return an error:

floor(x) - ceiling(y)


################
### Booleans ###
################

# I defined two random variables `x` and `y`. Are the two variables equal? which one is smaller?

x <- runif(1)
y <- runif(1)


# I defined two random variables `x` and `y`. Using the `ifelse()`{.R} function, print "x is larger than y" or "x is smaller than y".

x <- runif(1)
y <- runif(1)
ifelse(test, yes, no)

# Without running the code, what do you think will be the output of this code:
cos(pi/2)==cos(3*pi/2)

# In fact, `.Machine$double.eps` is the smallest positive floating-point number x such that `1 + x != 1`. It depends on the machine (computer) you are running on:

.Machine$double.eps
(cos(pi / 2) - cos(3 * pi / 2)) > .Machine$double.eps
all.equal(cos(pi/2),cos(3*pi/2))


###############
### Strings ###
###############

# Save your name as a string in a variable, and print "My name is: yourname" using this variable.

name <- ___
print(___, ___)

# Replace all "e" by "A" in the following string:

x <- "aaaeebbbeebiieelakdceee"
gsub(___, ___, ___)

# Do the same using the `stringr` function `str_replace_all()` (take a look at the [cheatsheet](https://github.com/rstudio/cheatsheets/blob/main/strings.pdf)):

library(stringr)
x <- "aaaeebbbeebiieelakdceee"
str_replace_all(___, ___, ___)

# Find the index of all the `"e"` characters in the string, using base functions and `stringr` ones (take a look at the [cheatsheet](https://github.com/rstudio/cheatsheets/blob/main/strings.pdf) to find the good one):

x <- "aaaeebbbeebiieelakdceee"
gregexpr(___, ___)
library(stringr)
str____(___, ___)
