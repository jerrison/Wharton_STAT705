#### Simulation case study

set.seed(19390910) # Set the seed for reproducibility

#### Define constants
n.infringers <- 1000   # The number of infringers in the population
n.weeks <- 52          # The number of weeks in the study
max.notice <- 3        # The maximum notices that a user can get before we stop sending them more notices
isp.mode <- TRUE       # If TRUE, we model n notices sent from the ISP to infringer.
# If FALSE, we model n notices sent to the ISP (there could be multiple notices to the same user).
pass.through.rate <- 1 # The probability that a sent notice is actually received by the user


# Deterrence probabilities
theta <- c(0.0,0.1,0.25,0.1) # The probability that a given notice number stops infringement [starts at 0 notices]
theta <- c(theta,rep(0.0,(n.weeks + 1) - length(theta))) # This pads it out with zeroes. Notices past 3 are not sent to the user

effort <- seq(10,50,5) # Explore different levels of effort (notices per week)

# A container to keep infringer counts by week and level of effort.
results.container <- matrix(rep(NA,n.weeks * length(effort)),ncol=length(effort))
rownames(results.container) <- paste("Week_",seq(n.weeks),sep="")
colnames(results.container) <- paste("Effort_",effort,sep="")

#Row 1 is special as everyone is infringing
results.container[1,] <- rep(n.infringers,length(effort))

### The outer loop, looking at different effort levels
for(k in effort){
  
  # Initialize results containers
  z <- matrix(rep(0, n.infringers * n.weeks),ncol=n.weeks) #Infringement status
  y <- matrix(rep(0, n.infringers * n.weeks),ncol=n.weeks) #Notice received status
  x <- matrix(rep(0, n.infringers * n.weeks),ncol=n.weeks) #Notice sent status
  
  
  #### Assumption on capture probabilities. How likely is an individual to be captured?
  #### het.* contains the capture probabilities
  
  #### Equal capture probabilities is the het.1 scenario
  het.1 <- rep(k/n.infringers,n.infringers)
  #### Beta model
  alpha <- 2
  het.2 <- rbeta(n.infringers,alpha,(alpha-0.002)/0.002)
  alpha <- .1
  het.3 <- rbeta(n.infringers,alpha,(alpha-0.002)/0.002)
  
  # By definition, in week 1 everyone is infringing 
  z[,1] <- 1
  
  #Choose the heterogeneity 1 scenario
  het <- het.1
  
  # Loop over the weeks
  for(i in 1:51){
    
    # Decide who gets seen
    #### Prepare to draw a sample of infringers.
    #### Only those infringing (z == 1) can be seen.
    
    
    #### Sort users by infringement status to make it easier to follow progress
    sort.vec <- order(z[,i],decreasing=TRUE) #Put the current infringers at the top of the matrix
    x <- x[sort.vec,]
    y <- y[sort.vec,]
    z <- z[sort.vec,]
    het <- het[sort.vec]
    
    # Calculate how many notices have been sent so far to each user (cumsum by row).
    # The x vector contains notices that were sent to the user
    
    if(i == 1){
      sent.so.far <- rep(0,dim(x)[1])
    } else {
      if(i == 2){
        sent.so.far <- apply(x[,c(1:(i-1)),drop=FALSE],1,cumsum)
      } else {
        sent.so.far <- t(apply(x[,c(1:(i-1)),drop=FALSE],1,cumsum))[,i-1]
      }
    }
    
    # Identify those users who are still infringing and still eligible to get a notice
    if(isp.mode){
      notice.elig <- (z[,i] == 1) & (sent.so.far < max.notice) # Only eligible if haven't reached the max # of notices
    } else{
      notice.elig <- (z[,i] == 1)
    }
    
    #### How many infringers do we have to choose from to send a notice to?
    num.inf <- sum(notice.elig)
    
    if(num.inf == 0){chosen <- c()}
    if(num.inf == 1){chosen <- c(1:n.infringers)[notice.elig]}
    if(num.inf > 1){
      
      # "isp mode" matters because isps can be more accurate with who they send notices too. 
      # The scanning vendor  isn't as well informed, so can generate multiple notices to the same person
      # and doesn't know how how many prior notices that person has had.
      
      if(isp.mode){
        # Who gets a notice is random, but the probabilities don't have to be uniform 
        # The effort level (k) determines the number of infringers identified
        chosen <- sample(c(1:n.infringers)[notice.elig], min(k,num.inf), replace = FALSE, prob = het[notice.elig])
      } else{
        #### Sample with replacement as the same user may be identified more than once by the vendor doing the scanning.
        chosen <- sample(c(1:n.infringers)[notice.elig], min(k,num.inf), replace = TRUE, prob = het[notice.elig])
        #### But then, a duplicate user can receive at most a single notice 
        chosen <- unique(chosen)
      }
    } 
    
    #### Update the infringers who get sent a notice
    x[chosen,i] <- 1
    
    #### Update the infringers receiving a notice
    #### Your chances of getting the notice depend on the pass through rate
    y[,i] <- rbinom(dim(x)[1],1,pass.through.rate) * x[,i]
    
    
    #### Now define z in the next time period
    #### There are three cases
    
    #### 1. If you were not infringing, then you continue to not infringe
    z[z[,i] == 0,(i+1)] <- 0
    
    #### 2. If you were infringing and did not receive a notice, 
    #### then you continue to infringe 
    z[(z[,i] == 1) & (y[,i] == 0),(i+1)] <- 1
    
    #### If you were infringing and were sent a notice,
    #### then you continue to infringe with probability 
    #### depending on the number of notices you have seen (not been sent) 
    
    #### Update the number of notices seen by each infringer
    if(i == 1){
      seen.so.far <- apply(y[,c(1:i),drop=FALSE],1,cumsum)
    } else {
      seen.so.far <- t(apply(y[,c(1:i),drop=FALSE],1,cumsum))[,i]
    }
    
    #### 3. If you are infringing and receive a notice, you will stop with the given probability 
    inf.and.receive <- (z[,i] == 1) & (y[,i] == 1)
    
    z[inf.and.receive,(i+1)] <- 
      rbinom(
        dim(y[inf.and.receive,,drop=FALSE])[1],
        1,
        (1 - theta[seen.so.far + 1][inf.and.receive])
      ) 
    
    # Keep track of iterations
    if(i%%10 == 0){
      cat("Number of infringers on iteration",i+1, "is",sum(z[,i+1]),"\n")
    }
	
	#Update the results container
	results.container[(i+1),match(k,effort)] <- sum(z[,i+1])
	
  } #End weeks loop
  
  print(paste("The number of infringers at one year is ",sum(z[,n.weeks]),"with effort",k))
} #End effort loop









