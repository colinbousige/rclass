# # # # # # # # # # 
# Exercise 1
# # # # # # # # # # 

# Write a function that computes the geometric mean of two values, sqrt(a*b).
# - Make it so that the second parameter has a default value of 1
# - Add error handling: 
#    - check that the provided parameters are numeric, exit with a meaningful error message otherwise
#    - check that the provided parameters have the same length or of length 1:
#       - if at least one parameter has length 1, show a warning message but continue with the function
#       - exit with a meaningful error message otherwise
# Hint: see `warning("Message")` and `stop("Message")`
geom_mean <- function(___, ___){
    if(___){
        ___
    }
    ___
    return(___)
}
# Test it:
geom_mean("a", 2)
geom_mean(1, 2)
geom_mean(1:2, 2)
geom_mean(1:2, 2:3)

# # # # # # # # # # 
# Exercise 2
# # # # # # # # # # 

# Create the sinus cardinal function, returning:
#  f(x) = sin(x)/x for x ≠ 0, and f(0) = 1.
# Hint: 
# - use a tolerance
# - the function needs to be vectorized
# - add error handling: x needs to be a numerical vector or exit with a meaningful message.

sinc <- function(x){
    ___    
}

# Test it:
x <- seq(-pi,pi,.01)
plot(x, sinc(x))

# # # # # # # # # # 
# Exercise 3
# # # # # # # # # # 

# Write a function that will have two parameters: `filename` and `plot`.
# - `filename` is the path to a file of the type of `Data/ATG.txt` (give this as default)
# - `plot` is a boolean, defaulting to FALSE
# - add error handling: 
#     - `plot` needs to be a boolean (is.logical()?) or exit
#     - `filename` needs to lead to an existing file or exit (file.exists()?)
# If `plot` is FALSE, the function returns a tibble with only the following columns:
# - the read temperature (Tr column)
# - the weight (Value column)
# - filtered to contain only times at which the temperature is increasing
# If `plot` is TRUE, the function does the above operations and then outputs a nice plot of the weight as a function of the measured temperature, with proper labels, etc.
# 
# Also, add the proper function documentation. Place the cursor inside the function, 
# then go to Code > Insert Roxygen Skeleton and fill the fields.

read_ATG <- function(___, ___){
    ___
}

# Test it:
read_ATG()
read_ATG(plot=TRUE)



