
#### STAT 705 FALL 2018 ASSIGNMENT 3 (Functions)
#### NAME:

#### If in a question I refer to a function that we have not seen in class, 
#### then use the help facility to find out about it.
#### Insert your answers under each question.
#### Submit your solutions to Canvas as a plain text file.

#### OBJECTIVE: in this homework you will build a set of functions that can be used
#### to automatically identify outlier prone columns in a financial dataset. 

#### In this assignment you do NOT have to worry about missing values (NAs).
#### There is no need to accommodate NAs in your functions.

#### The data frame, stocks.df, in the .RData file called "hw3_2018.Rdata" contains the date (first column) and then the 
#### daily prices for 11 different stocks.

#### The first task is to create a new data frame that has just the daily returns for these stocks.
#### Recall that the daily return is defined as (price today - price yesterday)/price yesterday.

#### Q1. (20pts.)

#a. Write a function that takes a numeric vector and returns a vector of "returns".
# The returns will have a length of one less than the input vector. You do not need to pad the vector with a leading NA.
# At this point you do not have to check the argument passed to the function.
# Call the function "daily.ret" and paste the code that defines the function below.
# Code:
# daily.ret <- function(num_vector) {
#     return(diff(x = num_vector, lag = 1) / head(x = num_vector, n = -1))
daily.ret <- function(num_vector) {
    return(diff(x = num_vector, lag = 1) / head(x = num_vector, n = -1))
}

#b. Use your daily.ret function on the vector seq(10) and paste the output below.
# Call: daily.ret(num_vector = seq(10))
# Output: 1 0.5 0.333333333333333 0.25 0.2 0.166666666666667 0.142857142857143 0.125 0.111111111111111
daily.ret(num_vector = seq(10))

#c. Refine your  function so that if it is called with anything but a numeric argument
# it stops and produces an informative error message. 
# Use the "if" and "is.numeric" functions to achieve this goal. Paste the refined function below.
# Code: 
# daily.ret <- function(num_vector) {
#     if(!is.numeric(num_vector)) { # check if num_vector is numeric
#         stop("JL: input vector is not numeric")
#     }
#     return(diff(x = num_vector, lag = 1) / head(x = num_vector, n = -1))
# }
daily.ret <- function(num_vector) {
    if(!is.numeric(num_vector)) { # check if num_vector is numeric
        stop("JL: input vector is not numeric")
    }
    return(diff(x = num_vector, lag = 1) / head(x = num_vector, n = -1))
}

#d. Call the daily.ret function on the vector c(1,2,"hello", "world") and paste 
# the output below. 
# Call: daily.ret(c(1, 2, "hello", "world"))
# Output: 
# Error in daily.ret(c(1, 2, "hello", "world")): JL: input vector is not numeric
# Traceback:

# 1. daily.ret(c(1, 2, "hello", "world"))
# 2. stop("JL: input vector is not numeric")   # at line 13 of file <text>
# daily.ret(c(1, 2, "hello", "world"))

#e. Read in the .RData file called "hw3_2018.Rdata". It contains a data frame 
# called "stock.df".
# Using the "sapply" function (it will return a matrix here rather than a list), 
# sapply your daily.ret function to all the columns of the stock.df data frame
# (excluding the date column).
# The output will be a matrix, but you can store it as a data frame by applying
# the "as.data.frame" function to it.
# Store the daily returns in a new data frame called "returns.df"
# Call:
# load("/Users/jerrison/Wharton_MBA/Wharton_STAT705/data/hw3_2018.rdata")
# returns.df <- as.data.frame(x = sapply(X = stock.df[, 2:length(stock.df)],
#                                        FUN = daily.ret))
load("/Users/jerrison/Wharton_MBA/Wharton_STAT705/data/hw3_2018.rdata")
returns.df <- as.data.frame(x = sapply(X = stock.df[, 2:length(stock.df)],
                                       FUN = daily.ret))

#f Add a column named "DATE" at the *start* of the returns.df data frame that has the date of the daily returns. 
#  Print the column names of this data frame below. 
# Call: returns.df <- cbind(DATE = stock.df$Date[2:length(stock.df$Date)],
#                     returns.df)
# print(colnames(returns.df))
# Output:  [1] "DATE" "AMZN" "BP"   "CALA" "CVX"  "GBTC" "GERN" "GPRO" "JPM"  "MNKD"
# [11] "TSLA" "XOM"
returns.df <- cbind(DATE = stock.df$Date[2:length(stock.df$Date)],
                    returns.df)
print(colnames(returns.df))

#g Using either the apply (or sapply) and mean function, write code to find the
# mean daily return for each stock and 
# print these means (you need to show your code, and cut and paste the results 
# of the print statement).  
# Call: print(sapply(X = returns.df[2:length(returns.df)], FUN = mean))
# Output:
#          AMZN            BP          CALA           CVX          GBTC 
#  0.0028983734  0.0009700299 -0.0035623699  0.0003260614  0.0033998966 
#          GERN          GPRO           JPM          MNKD          TSLA 
#  0.0048968531 -0.0019336444  0.0010160846  0.0020154994 -0.0005588027 
#           XOM 
#  0.0003619135 
print(sapply(X = returns.df[2:length(returns.df)], FUN = mean))

#### Q2. (15pts.) Financial returns are well known to often be heavy tailed 
# ("fat tailed") compared to a normal distribution.
#### One numerical measure of just how heavy tailed a distribution is, is
# called the "excess kurtosis".

#a.  Write a function in R that takes a single numeric vector argument, call it 
# y, and finds the excess kurtosis of the vector.
# The definition of excess kurtosis we will use is in the document 
# "kurtosis.pdf" in the Assignments folder on Canvas.
# You R code should *not* use  a for loop in the calculation.
# Call your function "kurtosis" and cut and paste your function here.
# If you have your function defined correctly calling kurtosis(y = seq(10)) 
# should return -1.2.
# Call: kurtosis
# Output: 
# function (y) 
# {
#     n <- length(y)
#     sample_mean <- mean(x = y)
#     sample_sd <- sd(x = y)
#     summation <- sum(sapply(X = y, FUN = function(y) {
#         ((y - sample_mean)/sample_sd)^4
#     }))
#     return(((n * (n + 1))/((n - 1) * (n - 2) * (n - 3))) * summation - 
#         ((3 * (n - 1)^2)/((n - 2) * (n - 3))))
# }
kurtosis <- function(y) {
    n <- length(y)
    sample_mean <- mean(x = y)
    sample_sd <- sd(x = y)
    summation <- sum(sapply(X = y, FUN = function(y) {
        ((y - sample_mean)/sample_sd)^4
    }))
    return( ((n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))) * summation -
           ((3 * (n - 1)^2) / ((n - 2) * (n - 3))) )
}

kurtosis

#b.  Use your kurtosis function with the following vector and print the result:
# Call: kurtosis(y = my.vec)
# Output: 1.17475978639633

my.vec <- c(2.10921657, -0.89218616, -0.23085193,  0.39297494,  1.09767915,
            -0.13936090, -0.36960242, -0.02307942)
kurtosis(y = my.vec)

#c.  Refine your kurtosis function, so that if it is called with anything other
# than a numeric argument
# it stops and produces an informative error message. Use the "if" and 
# "is.numeric" functions to achieve this goal.
# Cut and paste your refined function here and show the results of calling it 
# with the argument kurtosis(y = letters).
# Call:
# kurtosis <- function(y) {
#     if(!is.numeric(x = y)) {
#         stop("JL: input vector is not numeric")
#     }
#     n <- length(y)
#     sample_mean <- mean(x = y)
#     sample_sd <- sd(x = y)
#     summation <- sum(sapply(X = y, FUN = function(y) {
#         ((y - sample_mean)/sample_sd)^4
#     }))
#     return( ((n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))) * summation -
#            ((3 * (n - 1)^2) / ((n - 2) * (n - 3))) )
# }

# kurtosis(y = letters)

# Output:
# Error in kurtosis(y = letters): JL: input vector is not numeric
# Traceback:

# 1. kurtosis(y = letters)
# 2. stop("JL: input vector is not numeric")   # at line 9 of file <text>

kurtosis <- function(y) {
    if(!is.numeric(x = y)) {
        stop("JL: input vector is not numeric")
    }
    n <- length(y)
    sample_mean <- mean(x = y)
    sample_sd <- sd(x = y)
    summation <- sum(sapply(X = y, FUN = function(y) {
        ((y - sample_mean)/sample_sd)^4
    }))
    return( ((n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))) * summation -
           ((3 * (n - 1)^2) / ((n - 2) * (n - 3))) )
}

# kurtosis(y = letters)

#d.  Given the definition of excess kurtosis, it does not make sense to use 
# this function unless the length of the
# input vector is strictly greater than three. Add another argument check to 
# your kurtosis function,
# that stops and outputs an error message if the length of the input vector y, 
# is less than four.
# Cut and paste your improved kurtosis function here and show the results of 
# calling it with the argument, kurtosis(y = seq(3)).
# New function:
# kurtosis <- function(y) {
#     if(!is.numeric(x = y)) {
#         stop("JL: input vector is not numeric")
#     }
#     if(length(x = y) < 4) {
#         stop("JL: input vector length is less than 4")
#     }
#     n <- length(y)
#     sample_mean <- mean(x = y)
#     sample_sd <- sd(x = y)
#     summation <- sum(sapply(X = y, FUN = function(y) {
#         ((y - sample_mean)/sample_sd)^4
#     }))
#     return( ((n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))) * summation -
#            ((3 * (n - 1)^2) / ((n - 2) * (n - 3))) )
# }

# Call: 
# kurtosis(y = seq(3))

# Output:
# Error in kurtosis(y = seq(3)): JL: input vector length is less than 4
# Traceback:

# 1. kurtosis(y = seq(3))
# 2. stop("JL: input vector length is less than 4")   # at line 16 of file <text>

kurtosis <- function(y) {
    if(!is.numeric(x = y)) {
        stop("JL: input vector is not numeric")
    }
    if(length(x = y) < 4) {
        stop("JL: input vector length is less than 4")
    }
    n <- length(y)
    sample_mean <- mean(x = y)
    sample_sd <- sd(x = y)
    summation <- sum(sapply(X = y, FUN = function(y) {
        ((y - sample_mean)/sample_sd)^4
    }))
    return( ((n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))) * summation -
           ((3 * (n - 1)^2) / ((n - 2) * (n - 3))) )
}

# kurtosis(y = seq(3))

#e.  Add a logical argument called "excess" to your kurtosis function, that 
# defaults to TRUE.
# When excess = TRUE the function should return the excess kurtosis as before,
# but when excess = FALSE is should return the excess kurtosis + 3.
# You can review Class 6, slide 23 to see how I returned a value that depended 
# on a logical condition.
# Cut and paste your refined function here and show the results of calling it 
# with the arguments
# kurtosis(y = seq(10), excess = FALSE)

# Refined function:
# kurtosis <- function(y, excess = TRUE) {
#     if(!is.numeric(x = y)) {
#         stop("JL: input vector is not numeric")
#     }
#     if(length(x = y) < 4) {
#         stop("JL: input vector length is less than 4")
#     }
#     n <- length(y)
#     sample_mean <- mean(x = y)
#     sample_sd <- sd(x = y)
#     summation <- sum(sapply(X = y, FUN = function(y) {
#         ((y - sample_mean)/sample_sd)^4
#     }))
#     excess_kurtosis = ( ((n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))) * 
#                        summation -
#                        ((3 * (n - 1)^2) / ((n - 2) * (n - 3))) )
    
#     if(excess == TRUE) {
#         return(excess_kurtosis)
#     }
#     return(excess_kurtosis + 3)
    
# }

# Call:
# kurtosis(y = seq(10), excess = FALSE)

# Output:
# 1.8

kurtosis <- function(y, excess = TRUE) {
    if(!is.numeric(x = y)) {
        stop("JL: input vector is not numeric")
    }
    if(length(x = y) < 4) {
        stop("JL: input vector length is less than 4")
    }
    n <- length(y)
    sample_mean <- mean(x = y)
    sample_sd <- sd(x = y)
    summation <- sum(sapply(X = y, FUN = function(y) {
        ((y - sample_mean)/sample_sd)^4
    }))
    excess_kurtosis = ( ((n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))) * 
                       summation -
                       ((3 * (n - 1)^2) / ((n - 2) * (n - 3))) )
    
    if(excess == TRUE) {
        return(excess_kurtosis)
    }
    return(excess_kurtosis + 3)
    
}

kurtosis(y = seq(10), excess = FALSE)

#### Q3. (15pts.) Applying the "kurtosis" function you wrote in Q2 to the 
# numeric columns of "returns.df" you created in Q1. 

#### Below you will apply the "kurtosis" function you just wrote, to the 
# numeric columns of "returns.df". 
#### You can identify the numeric columns with the built in R command 
# "is.numeric".
#### It plays the role here of the "is.dichotomous" function we created in 
# class.
#### You can use the "sapply" command (a special version of lapply) on the data 
# frame to identify the numeric columns.
#### It returns a vector rather than a list which can save time having to 
# "unlist" the result.
#### Note: if you try to use "apply" on the data frame, apply will first coerce
# the data frame to a matrix, which can
#### only contain one variable type, which will be character, so is.numeric 
# would report
#### all FALSE which is not what you want.


#a. Write code to extract just the numeric columns of returns.df into their own 
# new data frame, called justnum.df
# Your code needs to identify the numeric columns programatically.
# Paste the code that you used for the extraction and programatically report 
# how many columns you extracted.

# Call:
# numeric_cols <- sapply(X = returns.df, FUN = is.numeric)
# justnum.df <- returns.df[, numeric_cols]
# print(paste("Extracted", sum(numeric_cols), "numeric columns from returns.df"))

# Output:
# "Extracted 11 numeric columns from returns.df"

numeric_cols <- sapply(X = returns.df, FUN = is.numeric)
justnum.df <- returns.df[, numeric_cols]
print(paste("Extracted", sum(numeric_cols), "numeric columns from returns.df"))

#b. Paste the code needed to apply the kurtosis function to the justnum.df data
# frame (use the default value for the excess argument). 
# Print the output from the kurtosis command when applied to the numeric 
# columns. Use either sapply or the apply command, no looping allowed. 

# Call:
# print(sapply(X = justnum.df, FUN = kurtosis))

# Output:
#      AMZN        BP      CALA       CVX      GBTC      GERN      GPRO       JPM 
# 13.839662  1.729705  7.565025  2.978323  2.044382  8.270739  4.528455  2.300904 
#      MNKD      TSLA       XOM 
# 42.082549  4.292236  4.286294 

print(sapply(X = justnum.df, FUN = kurtosis))

#c. Write code to programatically identify which stock has the highest kurtosis
# in the justnum.df data frame. That is, your code needs to find
# the stock with the maximum kurtosis and print both the stock name and its 
# excess kurtosis value.

# Call:
# print(sort(x = sapply(X = justnum.df, FUN = kurtosis), decreasing = TRUE)[1])

# Output:
#     MNKD 
# 42.08255 

print(sort(x = sapply(X = justnum.df, FUN = kurtosis), decreasing = TRUE)[1])
