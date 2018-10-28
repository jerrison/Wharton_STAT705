

#### STAT 705 Fall 2018 Final Project
#### NAME: Jerrison Li Liu

#### Graded out of 100. 15 points for style and elegance.

#### Deliverables: There are 3 deliverables for this final project.
#### 1. R code that accompanies Q1 and Q2.
#### 2. A .RMD file for generating the report in Q3.
#### 3. The PDF or HTML file of the report that you make for Q3.


#### If in a question I refer to a function that we have not seen in class,
#### then use the help facility to find out about it.
#### Insert your answers under each question.
#### Submit your R code solutions to Canvas as a plain text file.

#### You may use any of the code published in the solutions to Assignment 5.


# Longsvale has undergone rapid development from a 18 block square to 36 blocks.
# The goal of these questions is to estimate the number of cars (level of
# effort) that need to be available in order to meet a pre-specified level of
# service. We will assume that there are at least as many cars as passengers
# waiting.

# This pre-specified level of service is that the average wait time for
# passengers is no longer than 4 minutes.


# As a reminder, here is the preamble about the town:
# Longsvale is an interesting town because it is laid out in a perfect city
# grid and has exactly 36 blocks in both the north and east directions. Roads
# going north-south are called Avenues, and roads east-west are called streets.
# The driverless car will only pick up and drop people off at street
# intersections.
# This means that every car and every passenger's location can be represented
# as a pair (i,j),
# i for the street they are on, and j for the avenue, where both i and j take
# integer values between 1 and 36.
# The city planners used the convention that the intersection at the south west
# corner of the grid is (1,1) and the intersection in the north east corner
# is (36,36).

# The city also operates its time on a very discrete level, only working in
# minute increments. A car can move one block in one minute.

#Q1. (41pts.) Write a function called "run.sim", that runs a simulation, where
# the function takes the following four arguments:
#    num.cars --- the number of cars initially available.
#    num.passengers --- the number of passengers initially waiting for a ride.
#    grid.size --- the size of the Aresville city grid (default to 36).
#    num.its --- the number of iterations in the Monte Carlo simulation.

# The function should return a one column matrix, with the number of rows equal
# to num.its.
# The elements in this matrix should be the average time that passengers wait
# to be picked up (where the average
# is taken over all passengers within an iteration).

# Because grid.size is now a variable you will want to add an extra argument to
# your "newpassenger" and "newcar"
# functions from Assignment 5, to reflect this fact.

# The problem you will face in this question is that in Assignment 5, the
# number of cars equalled the number of passengers,
# whereas now that is not necessarily true. If the number of passengers equals
# the number of cars then the
# distance matrix is square (the same number of rows as columns).
# The optimization function, "lp.assign" in fact requires a square matrix as
# input and will fail to converge otherwise.

# The trick here, when the number of cars does not equal the number of
# passengers, is to pad the distance matrix
# with *zeroes* (not NAs), so that it becomes square. If we have cars as rows
# and passengers as columns in the distance matrix,
# and there were 20 cars and 10 passengers, then you would need to add 10
# columns of 20 rows each to make the distance
# matrix square. Because these extra columns (phantom passengers) are
# constructed with all zero entries they don't change
# the solution to the optimization problem.
# Equivalently, you could create a distance matrix as square and full of
# zeroes, and then just compute the elements
# that correspond to actual passengers.

# Bottom line: you have to add in an extra step as compared to Assignment 5,
# where you ensure that the
# distance matrix is square if necessary, before calling "lp.assign".

# dist function to calculate manhattan distance
dist <- function(car.location, pass.location) {
    return(sum(abs(car.location - pass.location)))
}


# newcar function to create car instance
newcar <-
    function(CID = NULL,
             Status = NULL,
             Location = NULL,
             Destination = NULL,
             PID = NULL,
             grid.size = NULL) {
        if (is.null(CID)) {
            CID = paste(sample(c(LETTERS, 0:9), 10), sep = "", collapse = "")
        }
        if (is.null(Status)) {
            Status = "Waiting"
        }
        if (is.null(Location)) {
            Location = sample(1:grid.size, 2, replace = TRUE)
        }
        return(
            list(
                CID = CID,
                Status = Status,
                Location = Location,
                Destination = Destination,
                PID = PID
            )
        )
    }

# newpass function to create passenger instance
newpass <-
    function(PID = NULL,
             WaitTime = NULL,
             Location = NULL,
             Destination = NULL,
             grid.size = NULL) {
        if (is.null(PID)) {
            PID = paste(sample(c(LETTERS, 0:9), 10), sep = "", collapse = "")
        }
        if (is.null(WaitTime)) {
            WaitTime = 0
        }
        if (is.null(Location)) {
            Location = sample(1:grid.size, 2, replace = TRUE)
        }
        if (is.null(Destination)) {
            Destination = sample(1:grid.size, 2, replace = TRUE)
        }
        return(list(
            PID = PID,
            WaitTime = WaitTime,
            Location = Location,
            Destination = Destination
        ))
    }

#a. Check all the arguments to make sure that they are non-negative numerics.
# The functions "stopifnot" and "is.numeric"
# will help you do this.

#b. The other thing to check, and stop if it is not true,
# is that the number of cars is greater than or equal to the number of
# passengers.

#c. Paste the code for your run.sim function. It will implicitly include your
# answers to parts a and b.

# Code:
# run.sim <-
#     function(num.cars,
#              num.passengers,
#              grid.size = 36,
#              num.its) {
#         stopifnot(
#             is.numeric(num.cars),
#             is.numeric(num.passengers),
#             is.numeric(grid.size),
#             is.numeric(num.its),
#             num.cars >= 0,
#             num.passengers >= 0,
#             grid.size >= 0,
#             num.its >= 0,
#             num.cars >= num.passengers
#         )

#         # create one column matrix to store average wait time calculation
#         avg.wait = matrix(data = rep(NA, num.its),
#                           nrow = num.its,
#                           ncol = 1)

#         for (k in 1:num.its) {
#             # generate list of passengers
#             pass.list <-
#                 replicate(num.passengers,
#                           newpass(grid.size = grid.size),
#                           simplify = FALSE)

#             # generate list of cars
#             car.list  <-
#                 replicate(num.cars, newcar(grid.size = grid.size),
#                           simplify = FALSE)

#             # create distance matrix with all zeroes and nrows = ncols = num.cars
#             dist.mat <- matrix(0, num.cars, num.cars)

#             # calculate distance between each car and passenger
#             for (i in 1:num.cars) {
#                 for (j in 1:num.passengers) {
#                     dist.mat[i, j] <-
#                         dist(car.list[[i]]$Location, pass.list[[j]]$Location)
#                 }
#             }

#             #             optimize by pairing each passenger to closest car
#             fm <- lp.assign(dist.mat)

#             #             store average passenger wait time to avg.wait matrix
#             avg.wait[k] <- sum(dist.mat * fm$solution) / num.passengers
#         }

#         return(avg.wait)

#     }

run.sim <-
    function(num.cars,
             num.passengers,
             grid.size = 36,
             num.its) {
        stopifnot(
            is.numeric(num.cars),
            is.numeric(num.passengers),
            is.numeric(grid.size),
            is.numeric(num.its),
            num.cars >= 0,
            num.passengers >= 0,
            grid.size >= 0,
            num.its >= 0,
            num.cars >= num.passengers
        )

        # create one column matrix to store average wait time calculation
        avg.wait = matrix(data = rep(NA, num.its),
                          nrow = num.its,
                          ncol = 1)

        for (k in 1:num.its) {
            # generate list of passengers
            pass.list <-
                replicate(num.passengers,
                          newpass(grid.size = grid.size),
                          simplify = FALSE)

            # generate list of cars
            car.list  <-
                replicate(num.cars, newcar(grid.size = grid.size),
                          simplify = FALSE)

            # create distance matrix with all zeroes and nrows = ncols = num.cars
            dist.mat <- matrix(0, num.cars, num.cars)

            # calculate distance between each car and passenger
            for (i in 1:num.cars) {
                for (j in 1:num.passengers) {
                    dist.mat[i, j] <-
                        dist(car.list[[i]]$Location, pass.list[[j]]$Location)
                }
            }

            #             optimize by pairing each passenger to closest car
            fm <- lp.assign(dist.mat)

            #             store average passenger wait time to avg.wait matrix
            avg.wait[k] <-
                sum(dist.mat * fm$solution) / num.passengers
        }

        return(avg.wait)

    }

# Run the function with these arguments and report the estimated mean waiting
# time for each:

#d. run.sim(num.cars = 20, num.passengers  = 20, grid.size = 36, num.its = 100)

# Code:
# library(lpSolve)
# print(
#     paste0(
#         "The average waiting time for the following call: ",
#         "run.sim(num.cars = 20, num.passengers  = 20, grid.size = 36, ",
#         "num.its = 100) is: ",
#         mean(
#             run.sim(
#                 num.cars = 20,
#                 num.passengers  = 20,
#                 grid.size = 36,
#                 num.its = 100
#             )
#         ),
#         " minutes."
#     )
# )

# Output:
# "The average waiting time for the following call: run.sim(num.cars = 20, num.passengers  = 20, grid.size = 36, num.its = 100) is: 9.099 minutes."

library(lpSolve)
print(
    paste0(
        "The average waiting time for the following call: ",
        "run.sim(num.cars = 20, num.passengers  = 20, grid.size = 36, ",
        "num.its = 100) is: ",
        mean(
            run.sim(
                num.cars = 20,
                num.passengers  = 20,
                grid.size = 36,
                num.its = 100
            )
        ),
        " minutes."
    )
)

#e. run.sim(num.cars = 40, num.passengers  = 20, grid.size = 36, num.its = 100)

# Code:
# print(
#     paste0(
#         "The average waiting time for the following call: ",
#         "run.sim(num.cars = 40, num.passengers  = 20, grid.size = 36, ",
#         "num.its = 100) is: ",
#         mean(
#             run.sim(
#                 num.cars = 40,
#                 num.passengers  = 20,
#                 grid.size = 36,
#                 num.its = 100
#             )
#         ),
#         " minutes."
#     )
# )

# Output:
# [1] "The average waiting time for the following call: run.sim(num.cars = 40, num.passengers  = 20, grid.size = 36, num.its = 100) is: 4.216 minutes."

print(
    paste0(
        "The average waiting time for the following call: ",
        "run.sim(num.cars = 40, num.passengers  = 20, grid.size = 36, ",
        "num.its = 100) is: ",
        mean(
            run.sim(
                num.cars = 40,
                num.passengers  = 20,
                grid.size = 36,
                num.its = 100
            )
        ),
        " minutes."
    )
)


#f. run.sim(num.cars = 60, num.passengers  = 20, grid.size = 36, num.its = 100)

# Code:
# print(
#     paste0(
#         "The average waiting time for the following call: ",
#         "run.sim(num.cars = 60, num.passengers  = 20, grid.size = 36, ",
#         "num.its = 100) is: ",
#         mean(
#             run.sim(
#                 num.cars = 60,
#                 num.passengers  = 20,
#                 grid.size = 36,
#                 num.its = 100
#             )
#         ),
#         " minutes."
#     )
# )

# Output:
# [1] "The average waiting time for the following call: run.sim(num.cars = 60, num.passengers  = 20, grid.size = 36, num.its = 100) is: 3.256 minutes."

print(
    paste0(
        "The average waiting time for the following call: ",
        "run.sim(num.cars = 60, num.passengers  = 20, grid.size = 36, ",
        "num.its = 100) is: ",
        mean(
            run.sim(
                num.cars = 60,
                num.passengers  = 20,
                grid.size = 36,
                num.its = 100
            )
        ),
        " minutes."
    )
)


#Q2. (16 pts.) We now assume that there are 20 passengers waiting, the grid
# size is 36 and num.its = 1000.
#    Explore the average passenger wait time as the
#    number of cars varies between 20 and 70 in increments of 5.
#    As you *develop* your code it will be a good idea to work with a num.its
# much smaller than 1000,
#    but the final results should use 1000.

#a. Create an empty container to hold the results of all the simulations.
#   This should be a matrix of dimensions num.its by 11.
#   Provide columns names for this matrix that describe the level of effort
# associated with each column.
#   Show the code you used to create this matrix.

# Code:
# num.its <- 1000

# # effort.levels = number of cars
# effort.levels <- seq(from = 20, to = 70, by = 5)

# wait.times <-
#     matrix(data = NA,
#            nrow = num.its,
#            ncol = length(effort.levels))

# # column names reflect number of cars for that iteration
# colnames(wait.times) <- effort.levels

num.its <- 1000

# effort.levels = number of cars
effort.levels <- seq(from = 20, to = 70, by = 5)

wait.times <-
    matrix(data = NA,
           nrow = num.its,
           ncol = length(effort.levels))

# column names reflect number of cars for that iteration
colnames(wait.times) <- effort.levels

#b. Set the random number seed to your birthday seed and show the code.

# Code:
# birthday = 19900601
# set.seed(birthday)

birthday = 19900601
set.seed(birthday)

#c. Use a for loop to execute the run.sim command as the number of cars varies.
#   Each pass through the loop should populate one column of the results
# container.
#   Show the code that implements the for loop.

# Code:
# for (i in 1:length(effort.levels)) {
#     wait.times[, i] <-
#         run.sim(
#             num.cars = effort.levels[i],
#             num.passengers = 20,
#             grid.size = 36,
#             num.its = num.its
#         )
# }

for (i in 1:length(effort.levels)) {
    wait.times[, i] <-
        run.sim(
            num.cars = effort.levels[i],
            num.passengers = 20,
            grid.size = 36,
            num.its = num.its
        )
}

#d. Estimate the mean wait time for each level of effort (number of cars)
#   and print them below.

# Code:
# print(apply(X = wait.times, 2, FUN = mean))

# Output:
# 20      25      30      35      40      45      50      55      60      65
# 8.75300 6.54150 5.49205 4.82700 4.30045 3.96700 3.67235 3.45540 3.27105 3.12790
#      70
# 2.95880

print(apply(X = wait.times, 2, FUN = mean))

#e. Use the "write.csv" command to save the results container to disk and paste
# the command
#   you used to do it below.

# Code:
# write.csv(wait.times, file = paste0("wait_times_20_to_70_by_5_with_",
#                                     num.its,
#                                     "_its.csv"),
#           row.names = FALSE)

write.csv(
    wait.times,
    file = paste0("wait_times_20_to_70_by_5_with_",
                  num.its,
                  "_its.csv"),
    row.names = FALSE
)

# Q3. Knitting PDF file from Rmarkdown file

library(knitr)
library(rmarkdown)

my.location <-
    "/Users/jerrison/Wharton_MBA/Wharton_STAT_705/assignments/final/"
my.infile <- "final_project.Rmd"
my.outfile <- "final_project_q3.pdf"

render(
    input = paste0(my.location, my.infile),
    output_format = "pdf_document",
    output_file = paste0(my.location, my.outfile)
)
