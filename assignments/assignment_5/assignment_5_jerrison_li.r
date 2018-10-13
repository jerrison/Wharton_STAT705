
#### STAT 405/705 FALL 2018 ASSIGNMENT 5 (Monte Carlo)
#### NAME: Jerrison Li Liu

#### If in a question I refer to a function that we have not seen in class, 
#### then use the help facility to find out about it.
#### Insert your answers under each question.
#### Submit your solutions to Canvas as a plain text file.


# The town of Longsvale is a target of opportunity for a driverless car, ride
# hailing service.
# It is an interesting town because it is laid out in a perfect city grid and 
# has exactly 
# 18 blocks in both the north and east directions. Roads going north-south are 
# called Avenues,
# and roads east-west are called streets.
# The driverless car will only pick up and drop people off at street 
# intersections.
# This means that every car and every passenger's location can be represented 
# as a pair (i,j),
# i for the street they are on, and j for the avenue, where both i and j take 
# integer values between 1 and 18.
# The city planners used the convention that the intersection at the south west 
# corner of the grid is (1,1)
# and the intersection in the north east corner is (18,18).

# The city also operates its time on a very discrete level, only working in 
# minute increments.
# A car can move one block in one minute.

#Q1. (4pts.) Write a function to return the distance in city blocks between a 
# car and a waiting passenger.
# The function should take two inputs, the car's location and the waiting 
# passenger's location.
# Paste your function below and print its output when called on the pair 
# car.location  = (3,7) and pass.location = (6,3).

# Code:
# block_distance <- function(car.location = c(1, 1), pass.location = c(1, 1)) {
# #     returns the manhattan distance between car.location and pass.location
#     return(abs(car.location[1] - pass.location[1]) +
#            abs(car.location[2] - pass.location[2]))
# }

# print(block_distance(car.location = c(3, 7), pass.location = c(6, 3)))

# Output:
# [1] 7

block_distance <- function(car.location = c(1, 1), pass.location = c(1, 1)) {
#     returns the manhattan distance between car.location and pass.location
    return(abs(car.location[1] - pass.location[1]) +
           abs(car.location[2] - pass.location[2]))
}

print(block_distance(car.location = c(3, 7), pass.location = c(6, 3)))

#Q2. (8 pts.) Write a function that creates a new car. A "new car" is just a 
# list. This list has named elements as follows:
# CID: a unique identifier for the car.
# Status: a text string that is either "Waiting", "En route to passenger" or 
# "En route to destination".
# Location: the coordinates of the car's current location.
# Destination: the coordinates of where the car is headed.
# PID: the id of the passenger that the car is either headed toward, or is 
# currently carrying. 
# Your function will need to take 5 arguments, one for each component of the 
# list. 
# Even though the arguments will typically take on their default values, by 
# incorporating these arguments
# you give the user the opportunity of overwriting the default values.

# By default, have Status set to "Waiting", Location set to a random 
# intersection and set Destination = NULL
# and PID = NULL. Think of NULL as a placeholder for something that is 
# currently empty/not set.
# Don't put quotes around the NULL. Like NA, it is special value in the R 
# language.
# A lazy way of creating a very likely unique CID would be 
# paste(sample(c(LETTERS,0:9),10),sep="",collapse="" ).

# Paste your function below and show what happens when you call it with all 
# default arguments, that is when you
# run the command "newcar()".

# By way of illustration, here's what my version of the function, called 
# "newcar", outputs when called with all default values:
# > newcar()
# $CID
# [1] "7IJMO9XVLK"
# 
# $Status
# [1] "Waiting"
# 
# $Location
# [1]  2 13
# 
# $Destination
# NULL
# 
# $PID
# NULL

# Code:
# newcar <- function(CID = paste(sample(c(LETTERS,0:9),10),sep="",collapse="" ),
#                   Status = "Waiting",
#                   Location = c(sample(x = 1:18, size = 1),
#                                sample(x = 1:18, size = 1)),
#                   Destination = NULL,
#                   PID = NULL) {
    
#     car <- list(CID = CID,
#                 Status = Status,
#                 Location = Location,
#                 Destination = Destination,
#                 PID = PID)
#     return(car)
# }

# newcar()

# Output:
# $CID
# 'JLCEVZYMGI'
# $Status
# 'Waiting'
# $Location
# 4 14
# $Destination
# NULL
# $PID
# NULL


newcar <- function(CID = paste(sample(c(LETTERS,0:9),10),sep="",collapse="" ),
                  Status = "Waiting",
                  Location = c(sample(x = 1:18, size = 1),
                               sample(x = 1:18, size = 1)),
                  Destination = NULL,
                  PID = NULL) {
    
    car <- list(CID = CID,
                Status = Status,
                Location = Location,
                Destination = Destination,
                PID = PID)
    return(car)
}

newcar()

#Q3. (7 pts.) Write a function that creates a new passenger and call this 
# function "newpass". A passenger is again a list, but with these named elements:
# PID: a unique identifier for the passenger.
# WaitTime: an integer that records how long the passenger has been waiting in 
# minutes.
# Location: the coordinates of the passenger's current location.
# Destination: the coordinates of where the passenger is headed.

# By default, have WaitTime set to 0, Location set to a random intersection and 
# Destination set to a random intersection.
# You can create the PID with the same paste(sample(c(LETTERS,0:9),10),sep="",
# collapse="" ) code.

# Paste your function below and show what happens when you call it with all 
# default arguments, that is when you
# run the command "newpass()".

# Code:
# newpass <- function(PID = paste(sample(c(LETTERS,0:9),10), sep = "",
#                                 collapse = ""),
#                     WaitTime = 0,
#                     Location = c(sample(x = 1:18, size = 1),
#                                sample(x = 1:18, size = 1)),
#                     Destination = c(sample(x = 1:18, size = 1),
#                                     sample(x = 1:18, size = 1))) {
    
#     newpass <- list(PID = PID,
#                     WaitTime = WaitTime,
#                     Location = Location,
#                     Destination = Destination)
    
#     return(newpass)
# }

# newpass()

# Output:
# $PID
# 'UGP1Y35C6W'
# $WaitTime
# 0
# $Location
# 10 18
# $Destination
# 1 7

newpass <- function(PID = paste(sample(c(LETTERS,0:9),10), sep = "",
                                collapse = ""),
                    WaitTime = 0,
                    Location = c(sample(x = 1:18, size = 1),
                               sample(x = 1:18, size = 1)),
                    Destination = c(sample(x = 1:18, size = 1),
                                    sample(x = 1:18, size = 1))) {
    
    newpass <- list(PID = PID,
                    WaitTime = WaitTime,
                    Location = Location,
                    Destination = Destination)
    
    return(newpass)
}

newpass()

#Q4 (5 pts.) 
###### Set the random seed to your birthday number and include this in your 
# answer.
# Create two lists, one of 12 passengers and the other of 12 cars.
# Show the code you use to create the passenger and car lists but you don't 
# have to print the lists out. 

# Code:
# birthday_number = 19900601
# set.seed(seed = birthday_number)

# passenger_count = 12
# car_count = 12


# # create passenger list
# passenger_list <- list()
# for(i in 1:passenger_count) {
#     passenger_list[[i]] <- newpass()
# }

# # create car list
# car_list <- list()
# for(i in 1:car_count) {
#     car_list[[i]] <- newcar()
# }

birthday_number = 19900601
set.seed(seed = birthday_number)

passenger_count = 12
car_count = 12


# create passenger list
passenger_list <- list(length = passenger_count)
for(i in 1:passenger_count) {
    passenger_list[[i]] <- newpass()
}

# create car list
car_list <- list(length = car_count)
for(i in 1:car_count) {
    car_list[[i]] <- newcar()
}

#Q5 (5 pts.) Create a distance matrix that contains how far each car is 
# initially from each passenger 
# (use your Q1 function to do this).
# Print out and paste the distance matrix below. 

# Code:
# distance_matrix <- matrix(data = NA,
#                           nrow = length(passenger_list),
#                           ncol = length(car_list))

# row_names <- list()
# col_names <- list()

# for(i in 1:nrow(distance_matrix)) {
#     row_names[[i]] <- car_list[[i]]$CID
#     col_names[[i]] <- passenger_list[[i]]$PID
#     for(j in 1:ncol(distance_matrix)) {
#         distance_matrix[i, j] <- block_distance(car_list[[i]]$Location,
#                                                 passenger_list[[j]]$Location)
#     }
# }

# rownames(distance_matrix) <- row_names
# colnames(distance_matrix) <- col_names

# print(distance_matrix)

# Output:
#            QYP9G1AFB3 XV7ZH14O9R L9UW7NRZ42 QT0UA4FNZ5 FU3EP5X9B6 A9NQIR46E1
# FJ084S6UQB         12         13         12         10         16         10
# QG645YJOTF         12         13          0          4         16         10
# TCREUF1LK4         14         11         10          8         14         12
# WNGXVDMB0S          5         20          9         11         23          5
# 3IKSOEYUZR          7         26         13         17         29          5
# QEJ01HU6LP         20          5          8          4          8         18
# 9C6ZXNVRGO         27          4         15         11          3         25
# 1YUFM05XZR         16         17         10         12         18         14
# 1M9P2DO8IZ         20          9          8          4          8         18
# 9IYFDLGAQZ         19          6         11          9         11         17
# S7FKLQEG68         14         11          2          2         14         12
# TGCZYAV3I7         17         10          5          5         11         15
#            AL2HN71JGR RVSU9PBFTG ABZ91U4WPD 6RW8ZAL4NE M7X5D3T0EC YFT089C6HQ
# FJ084S6UQB         11          6         17         10         10         17
# QG645YJOTF          3          6         17          2          4          7
# TCREUF1LK4          9          6         15          8          8         15
# WNGXVDMB0S         10          3         24          7         11         14
# 3IKSOEYUZR         16          9         30         11         17         20
# QEJ01HU6LP          5         12          9         10          4          7
# 9C6ZXNVRGO         12         19          2         17         11          8
# 1YUFM05XZR         11         16         19         12         12          9
# 1M9P2DO8IZ          5         12          9         10          4          3
# 9IYFDLGAQZ         10         11         10          9          9         16
# S7FKLQEG68          1          6         15          4          2          5
# TGCZYAV3I7          4          9         12          7          5          2


distance_matrix <- matrix(data = NA,
                          nrow = length(passenger_list),
                          ncol = length(car_list))

row_names <- list()
col_names <- list()

for(i in 1:nrow(distance_matrix)) {
    row_names[[i]] <- car_list[[i]]$CID
    col_names[[i]] <- passenger_list[[i]]$PID
    for(j in 1:ncol(distance_matrix)) {
        distance_matrix[i, j] <- block_distance(car_list[[i]]$Location,
                                                passenger_list[[j]]$Location)
    }
}

rownames(distance_matrix) <- row_names
colnames(distance_matrix) <- col_names

print(distance_matrix)

#Q6 (4 pts.) Focusing now just on passenger 1, identify which car is closest to 
# them and how long the
# passenger needs to wait in order to be picked up by this closest car.
# Show the code that you used to do this and paste both the car ID and the 
# passenger waiting time below.

# Code:
# print(paste("Closest car to passenger 1:",
#             car_list[[which.min(distance_matrix[, 1])[[1]]]]$CID))

# print(paste("Passenger 1 waiting time:",
#             distance_matrix[which.min(distance_matrix[, 1]), 1],
#             "minutes."))

# Output:
# [1] "Closest car to passenger 1: XM81Y034QU"
# [1] "Passenger 1 waiting time: 2 minutes."

print(paste("Closest car to passenger 1:",
            car_list[[which.min(distance_matrix[, 1])[[1]]]]$CID))

print(paste("Passenger 1 waiting time:",
            distance_matrix[which.min(distance_matrix[, 1]), 1],
            "minutes."))


##################################################################################
# More generally you need to assign cars to all passengers. In Operations 
# Research this is called the "Assignment Problem".
# There is a package for R called "lpSolve" which solves the assignment problem.
# Install the lpSolve package.
# If your distance matrix is called dist.mat, you assign cars to passengers in 
# an optimal fashion with the command
# fm <- lp.assign(dist.mat)
# Now fm$solution gives you a matrix that shows which car was assigned to each 
# passenger.

#Q7 (10 pts.) Run a Monte Carlo simulation with 10000 replications that 
# estimates  
# the average waiting time that passengers experience under this optimal 
# allocation.
# It's useful to realize that waiting time will just be equal to the initial 
# distance 
# between the car and the waiting passenger, because of the assumption that a 
# car can drive one block in one minute.
# For each iteration generate a new set of 12 passengers and a new set of 12 
# cars.
# Show your simulation code together with the average waiting time.

# Code:
# set.seed(birthday_number)

# num_runs = 10000
# passenger_count = 12
# car_count = 12
# total_waiting_time = 0

# for(i in 1:num_runs){

#     # create passenger list
#     passenger_list <- list(length = passenger_count)
#     for(i in 1:passenger_count) {
#         passenger_list[[i]] <- newpass()
#     }

#     # create car list
#     car_list <- list(length = car_count)
#     for(i in 1:car_count) {
#         car_list[[i]] <- newcar()
#     }
    
    
#     distance_matrix <- matrix(data = NA,
#                           nrow = length(passenger_list),
#                           ncol = length(car_list))

#     for(i in 1:nrow(distance_matrix)) {
#         row_names[[i]] <- car_list[[i]]$CID
#         col_names[[i]] <- passenger_list[[i]]$PID
#         for(j in 1:ncol(distance_matrix)) {
#             distance_matrix[i, j] <- block_distance(car_list[[i]]$Location,
#                                                     passenger_list[[j]]$Location)
#         }
#     }
    
#     fm <- lp.assign(distance_matrix)
#     total_waiting_time = total_waiting_time + fm$objval
# }

# average_waiting_time = total_waiting_time / (num_runs * passenger_count)
# print(paste("Average waiting time is", average_waiting_time, "minutes"))

# Output:
# "Average waiting time is 5.295525 minutes"

set.seed(birthday_number)

num_runs = 10000
passenger_count = 12
car_count = 12
total_waiting_time = 0

for(i in 1:num_runs){

    # create passenger list
    passenger_list <- list(length = passenger_count)
    for(i in 1:passenger_count) {
        passenger_list[[i]] <- newpass()
    }

    # create car list
    car_list <- list(length = car_count)
    for(i in 1:car_count) {
        car_list[[i]] <- newcar()
    }
    
    
    distance_matrix <- matrix(data = NA,
                          nrow = length(passenger_list),
                          ncol = length(car_list))

    for(i in 1:nrow(distance_matrix)) {
        row_names[[i]] <- car_list[[i]]$CID
        col_names[[i]] <- passenger_list[[i]]$PID
        for(j in 1:ncol(distance_matrix)) {
            distance_matrix[i, j] <- block_distance(car_list[[i]]$Location,
                                                    passenger_list[[j]]$Location)
        }
    }
    
    fm <- lp.assign(distance_matrix)
    total_waiting_time = total_waiting_time + fm$objval
}

average_waiting_time = total_waiting_time / (num_runs * passenger_count)
print(paste("Average waiting time is", average_waiting_time, "minutes"))

#Q8 (7 pts.) Redo the Monte Carlo simulation in Q7 to estimate the probability 
# that at least one 
# of the 12 passengers arrives at his or her destination before the last of the 
# 12 
# passengers is first picked up. Occasionally  you will create a passenger 
# whose origin and destination are the same.
# Treat this as a passenger error with the app used for ordering the car -- 
# that is, they will still wait to be picked up
# and their journey time will be zero.

# Code:
# set.seed(birthday_number)

# num_runs = 10000
# passenger_count = 12
# car_count = 12
# success = 0

# for(run in 1:num_runs) {
    
#     # create passenger list
#     passenger_list <- list(length = passenger_count)
#     for(i in 1:passenger_count) {
#         passenger_list[[i]] <- newpass()
#     }

#     # create car list
#     car_list <- list(length = car_count)
#     for(i in 1:car_count) {
#         car_list[[i]] <- newcar()
#     }

#     # distance between car and passenger
#     distance_matrix <- matrix(data = NA,
#                               nrow = length(passenger_list),
#                               ncol = length(car_list))

#     for(i in 1:nrow(distance_matrix)) {
#         row_names[[i]] <- car_list[[i]]$CID
#         col_names[[i]] <- passenger_list[[i]]$PID
#         for(j in 1:ncol(distance_matrix)) {
#             distance_matrix[i, j] <- block_distance(car_list[[i]]$Location,
#                                                     passenger_list[[j]]$Location)
#         }
#     }    
    
#     fm <- lp.assign(distance_matrix)
    
#     # create passenger wait time plus travel time vector
#     wait_travel_time <- vector(mode = "integer", length = passenger_count)
#     for(i in 1:passenger_count) {
#         wait_travel_time[i] <- 
#         (distance_matrix[which(round(fm$solution) == 1)][i]
#         + block_distance(passenger_list[[i]]$Location,
#                          passenger_list[[i]]$Destination))
#         }
    
#     if(min(wait_travel_time) < 
#        max(distance_matrix[which(round(fm$solution) == 1)])) {
#         success = success + 1
#     }
    
# }

# print(paste("The probability that least one of the 12 passengers arrives at ",
#             "his or her destination before the last of the 12 passengers is ",
#             "first picked up is",
#             success / num_runs))

# Output:
# "The probability that least one of the 12 passengers arrives at his or her 
# destination before the last of the 12 passengers is first picked up is 0.8503"

set.seed(birthday_number)

num_runs = 10000
passenger_count = 12
car_count = 12
success = 0

for(run in 1:num_runs) {
    
    # create passenger list
    passenger_list <- list(length = passenger_count)
    for(i in 1:passenger_count) {
        passenger_list[[i]] <- newpass()
    }

    # create car list
    car_list <- list(length = car_count)
    for(i in 1:car_count) {
        car_list[[i]] <- newcar()
    }

    
    # distance between car and passenger
    distance_matrix <- matrix(data = NA,
                              nrow = length(passenger_list),
                              ncol = length(car_list))

    for(i in 1:nrow(distance_matrix)) {
        row_names[[i]] <- car_list[[i]]$CID
        col_names[[i]] <- passenger_list[[i]]$PID
        for(j in 1:ncol(distance_matrix)) {
            distance_matrix[i, j] <- block_distance(car_list[[i]]$Location,
                                                    passenger_list[[j]]$Location)
        }
    }    
    
    fm <- lp.assign(distance_matrix)
    
    # create passenger wait time plus travel time vector
    wait_travel_time <- vector(mode = "integer", length = passenger_count)
    for(i in 1:passenger_count) {
        wait_travel_time[i] <- 
        (distance_matrix[which(round(fm$solution) == 1)][i]
        + block_distance(passenger_list[[i]]$Location,
                         passenger_list[[i]]$Destination))
        }
    
    if(min(wait_travel_time) < 
       max(distance_matrix[which(round(fm$solution) == 1)])) {
        success = success + 1
    }
    
}

print(paste("The probability that least one of the 12 passengers arrives at",
            "his or her destination before the last of the 12 passengers is",
            "first picked up is",
            success / num_runs))
