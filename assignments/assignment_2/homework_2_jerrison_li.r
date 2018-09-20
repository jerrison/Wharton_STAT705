
#### STAT 705 FALL 2018 ASSIGNMENT 2
#### NAME: Jerrison Li

#### If in a question I refer to a function that we have not seen in class, 
#### then use the help facility to find out about it.
#### Insert your answers under each question.
#### Submit your solutions to Canvas as a plain text file.

#### Download the .Rdata file called "hw2_2018.Rdata" available on Canvas and read it in to R using R-studio.
#### This will bring all the objects you need for the homework straight into R-studio.

load(file = "hw2_2018.rdata")

#### Q1. (6pts. )You will have imported a list called "mystery.list".
#### Inspect the list and describe briefly in words what is in it.

#a. Description: 
# Answer: It seems like list of length 3, each of them consisting of 
# information about airports. The three airports are LHR: London Heathrow, PHL:
# Philadelphia, and IXC: Chandigarh. The information includes, full name, 
# country, annual number of passengers and annual number of flights.

#b. Use two different R syntaxes for extracting *just* the number of passengers 
# who fly through PHL (not the sub-list containing the number of passengers).

#b(i)
# Answer:
# Using $ sign: mystery.list$PHL$ANNUALSTATS$NUMPASSENGERS
# Output: 29585754
mystery.list$PHL$ANNUALSTATS$NUMPASSENGERS

#b(ii)
# Answer:
# Using brackets: mystery.list[[2]][[3]][[1]]
# Output: 29585754
mystery.list[[2]][[3]][[1]]

#c The country for Chandigarh is incorrect. It is in India. Write code to 
# correct this mistake in the list and then print the corrected list.
# Answer:
mystery.list$IXC$COUNTRY <- "India"
print(mystery.list$IXC)
# Output:
# $FULLNAME
# [1] "Chandigarh"

# $COUNTRY
# [1] "India"

# $ANNUALSTATS
# $ANNUALSTATS$NUMPASSENGERS
# [1] 2137739

# $ANNUALSTATS$NUMFLIGHTS
# [1] 18715

#d Write code to add the airport nearest your hometown to the list along with its relevant attributes, and print just this new 
#  element of the updated list (if you don't know the attributes, guess them!)
# Answer:
PTY <- list("FULLNAME"= "Tocumen International Airport",
           "COUNTRY"= "Panama",
           "ANNUALSTATS"= list("NUMPASSENGERS"= 15616065, 
                            "NUMFLIGHTS"= 10000))
mystery.list$PTY <- PTY
print(mystery.list$PTY)
# Output
# $FULLNAME
# [1] "Tocumen International Airport"

# $COUNTRY
# [1] "Panama"

# $ANNUALSTATS
# $ANNUALSTATS$NUMPASSENGERS
# [1] 15616065

# $ANNUALSTATS$NUMFLIGHTS
# [1] 10000


#### Q2 (20pts.)

#a. What is a key difference between a matrix and a data frame?
# Answer: 
# A matrix can only store columns of the same type whereas a data frame can 
# store column of different types.

# You will have read in a data frame called  "tsla.df" which contains information on the price of Tesla stock

#b How many rows and columns does this data frame have?
# Answer: 
# 252 rows and 4 columns
dim(tsla.df)

#c On which day was Tesla's stock price maximized? Show your code that identifies the day. 
#  The function "which.max" can be very useful.
# Answer:
# 9/18/2017
tsla.df$Date[which.max(tsla.df$ClosePrice)]

#d Create and add to the data frame a new column called "Return" that calculates 
# the daily relative return of Tesla stock. The Daily Return is defined as 
# (price today - price yesterday)/price yesterday.
# I suggest that you build this vector outside of the data frame, and when 
# complete, "cbind" it into the 
#  data frame. The first element in this "return" vector will have to be an NA 
# (without quotes) because there is no preceding day for it.
#  Provide your code that builds the return vector and the code that adds it 
# back into the data frame.
#  There are many ways to create this vector of returns, but you may want to 
# have a look at the "diff" function 
#  as an elegant way to perform the calculation. Use the "head" function to 
# print the first 5 rows of the data frame
#  that now includs the Retun variable.
# Output:
# Date	ClosePrice	Volume	DayOfWeek	Return
# 09/01/2017	355.40	3049500	6	NA
# 09/05/2017	349.59	3835100	3	-0.01634777
# 09/06/2017	344.53	4091400	4	-0.01447409
# 09/07/2017	350.61	4239200	5	0.01764719
# 09/08/2017	343.40	3263500	6	-0.02056413

Return <- c(NA,
            diff(x = tsla.df$ClosePrice, lag = 1)/head(tsla.df$ClosePrice,
                                                       n = -1))
tsla.df$Return <- Return
head(tsla.df, n = 5)

#e. What was Tesla's average daily return over this time period? To deal with 
# the NA, use the "na.rm" 
#   argument to the "mean" function.
# Answer: -0.000228439843793543
mean(tsla.df$Return, na.rm = TRUE)

#f. What was the standard deviation of Tesla's daily return over this time period?
# Answer: 0.0293739206974521
sd(tsla.df$Return, na.rm = TRUE)

#g. There is a column in the data frame called "DayOfWeek". It has been entered 
# numerically, 1 for Sunday etc. Turn "DayOfWeek" into an *unordered* factor and
# overwrite the old DayOfWeek variable in the data frame.
# Show your code that creates and inserts the factor day-of-week variable.
tsla.df$DayOfWeek <- factor(x = tsla.df$DayOfWeek, ordered = FALSE)

#h. The "by" command is useful for summarizing one variable over the levels of 
# a categorical/factor variable. Read about the "by" command using R's help 
# function.

#   Using the "by" command, find which Day of the week had the highest average 
# daily return for Tesla stock.
#   Because the mean  for Friday will be NA due to the first day's return being 
# NA, you will need to pass
#   the "na.rm = TRUE" argument into the mean function when "by" applies it.
#   In the function syntax:
#   by(data, INDICES, FUN, ..., simplify = TRUE)
#   the three dots "..." is a special slot where you can pass in arguments to 
# the function FUN. 
#   This will allow you to find the mean daily return for Friday too. 
#   You need to write code to find the best day-of-the-week and then extract 
# the mean return in the best day-of-the-week.   

#   Code:
by(data = tsla.df$Return, INDICES = tsla.df$DayOfWeek,
   FUN = mean, na.rm = TRUE
   )
which.max(by(data = tsla.df$Return, INDICES = tsla.df$DayOfWeek,
   FUN = mean, na.rm = TRUE
   ))
by(data = tsla.df$Return, INDICES = tsla.df$DayOfWeek,
   FUN = mean, na.rm = TRUE
   )[which.max(by(data = tsla.df$Return, INDICES = tsla.df$DayOfWeek,
   FUN = mean, na.rm = TRUE
   ))]

#   Best day-of-the-week: 3, Tuesday
#   Average return in best day-of-the-week: 0.002809908



#### Q3 Regression (12pts.) 

#a Using the tsla.df data frame, run a regression of Tesla returns 
#  against daily volume and store the answer as a variable.
lm.out <- lm(Return ~ Volume, data = tsla.df)

#b Write code to extract the slope and intercept, RMSE and R^2 for the regression.
# Answer:
# slope: 8.863057e-10
# intercept: -0.006901303
# RMSE: 0.0291919
# R^2: 0.0163056
reg.summary <- summary(lm.out)
reg.slope <- reg.summary$coefficients[2, 1]
reg.intercept <- reg.summary$coefficients[1, 1]
reg.rmse <- reg.summary[['sigma']]
reg.r_squared <- reg.summary[['r.squared']]

print("slope:")
print(reg.slope)

print("intercept:")
print(reg.intercept)

print("rmse:")
print(reg.rmse)

print("r_squared:")
print(reg.r_squared)

#c Now add in the categorical variable, DayOfWeek, to the regression. Is Day of Week, in the presence of the
#  daily volume, a statistically significant predictor of Tesla's return?   
#  Show the code  you used to generate the relevant output as well as your conclusion.
# Output:
# 	Df	Sum Sq	Mean Sq	F value	Pr(>F)
# Volume	1	0.003517230	0.0035172297	4.0867086	0.04430901
# DayOfWeek	4	0.001330086	0.0003325215	0.3863605	0.81830964
# Residuals	245	0.210859489	0.0008606510	NA	NA

# Answer: Because the p-value of DayofWeek is so large, I conclude that
# DayofWeek is not statistically significant.
lm2.out <- lm(Return ~ Volume + DayOfWeek, data = tsla.df)
anova(lm2.out)

# reg2.summary

#d Finally, include in the regression the interaction between Volume and Day of Week. 
#  Is this interaction  term statistically significant? Again, post your code and state a conclusion.
# Output:
# 	Df	Sum Sq	Mean Sq	F value	Pr(>F)
# Volume	1	0.003517230	0.0035172297	4.2017782	0.04146403
# DayOfWeek	4	0.001330086	0.0003325215	0.3972392	0.81053517
# Volume:DayOfWeek	4	0.009122909	0.0022807271	2.7246186	0.03011001
# Residuals	241	0.201736580	0.0008370812	NA	NA
# Answer: Since the p-values of the interaction term have a p-value < 0.05, I
# conclude that the interaction term is statistically significant.

lm3.out <- lm(Return ~ Volume + DayOfWeek + Volume:DayOfWeek, data = tsla.df)
anova(lm3.out)

#### The lapply function
#### Q4. (12pts.) you will have read in a list called "gala.list". It contains the text based responses 
#### to a survey question that asked individuals what they liked "least" about a gala event.
#### The names in the list are respondent IDs (coerced to characters) and the associated element is the text response.

#a. Using repeated applications of the "lapply" command and "unlist" command, write R code to find
#   which respondent wrote the most words in their answer. Recall that "strsplit" will split a character string
#   and the "length" command will count how many elements there are in a vector. The command "which.max" will identify
#   the maximum element in a vector. Hint: you need to realize that "strsplit" itself returns a list structure.
#   To get things started, lapply(gala.list,strsplit," ") breaks each respondent's answer into distinct words
#   There are alternative approaches to doing this question, but I want you to use lapply.
# Answer:
# Individual 1590556744 wrote the most words

splitted_string <- lapply(X = gala.list, FUN = strsplit, " ")
unlisted_strings <- lapply(X = splitted_string, FUN = unlist)
word_count_by_individual <- lapply(X = unlisted_strings, FUN = length)
which.max(x = word_count_by_individual)


#b. Briefly explain each what each step in the code you wrote for part (a) does.  In particular, describe the 
#   data structure (vector, matrix, list, etc.) returned by each function you call.
# Answer: First, I used lapply to split the comments from each individual. This
# resulted in a list of list, with each element in the first level of list
# representing an individual and each individual's list of words from their
# comment. Next, I used lapply to unlist each individual's comment word list.
# This returned, a list of vectors. Each element represented an individual and
# each element had a vector inside it that represented their comment words.
# Then I used lapply and applied the lenght function. This returned a list of
# integers. Each element of the list represented an individual and each of them
# contained an integer that represented the lenght of the vector from the last
# step.
# Finally I used which.max to find which element of the list had the largest
# lenght.
