# NITCAMP mentor-mentee matching process - code
# Author: Vineet Payyapalli
# Created: Sep 8, 2018
# Last updated: Sep 9, 2018
rm(list = ls())

# Step 0 (for demo): generating a sample dataset of mentee and mentor preferences
# refer to "sample_pref.xlsx" for visualizing the sample dataset
e.names <- c("e2", "e1", "e3", "e5", "e6", "e4", "e7") # mentees
# e.names should be in: 
# (i) decreasing order of mentees' year in college (so as to give more importance to 4th and 3rd year students while matching)
# (ii) increasing order of number of mentors who have preferred the mentee (the inverse may result in mentees preferred by less number of mentors getting eliminated/not getting mentors) 
m.names <- c("m4", "m3", "m1", "m2") # mentors
# m.names should be in: 
# (i) increasing order of number of mentees who have preferred the mentor (the inverse may result in mentors preferred by less number of mentees getting eliminated/not getting mentees) 
pref.layers <- c("e", "m") # preferences
n.e <- length(e.names)
n.m <- length(m.names)
# preference values
x.values <- c(2, 3, 10, 3, 10, 10, 2, 1, 10, 3, 10, 2, 3, 1, 10, 1, 2, 2, 3, 1, 3, 3, 2, 1, 1, 1, 2, 10, 
              10, 2, 10, 10, 10, 10, 1, 2, 10, 4, 10, 10, 1, 3, 10, 1, 2, 6, 4, 3, 5, 10, 10, 10, 2, 1, 3, 10)
x <- array(x.values, c(7, 4, 2))
x
dimnames(x) <- list(e.names, m.names, pref.layers)
x.copy <- x # backup
m.cap <- c(2, 1, 3, 1) # mentor capacity - that is, number of students each mentor can guide

## Step 1: Defining variables
E <- 1:n.e # list of "unlocked" mentees
M <- 1:n.m # list of "unlocked" mentors
n.n <- max(n.e, n.m) + 1 # "large" number (larger than any mentee/mentor preference value) for scoring purposes
match <- list() # create empty list to store matched values
names(match) <- m.names
for (m in M) { # add one empty list for each mentor
  match[[m]] <- list()
}
counter = 0

## Step 2: Matching  
while (length(E) > 0 & length(M) > 0) { # limit search to mentees and mentors whose matching is not complete
  flag = F
  counter = counter + 1
  print(paste0("search # ", counter))
  for (e in E) { 
    # print (paste0("checking mentee ", e))
    for (m in M) {
      # print (paste0("checking mentor ", m))
      # lock a mentee-mentor pair if neither can find a better match (from the unlocked mentors and mentees)
      if (x[e, m, 1] == min(x[e, , 1]) & x[e, m, 2] == min(x[, m, 2])) {
        match[[m]][[length(match[[m]]) + 1]] <- e.names[e] # add mentee "e" to mentor "m" list 
        x[e, , ] <- n.n # assign large score, for locking the mentee 
        E <- E[-(which(E==e))] # remove locked mentee from the list of unlocked mentees
        print(paste("mentee", e, "is matched,", length(E), "more mentees remaining", sep = " "))
        if (length(match[[m]]) == m.cap[m]) { # check if mentor has reached capacity limit
          x[, m, ] <- n.n # assign large score, for locking the mentor
          M <- M[-(which(M==m))] # remove locked mentor from the list of unlocked mentors
          print(paste("mentor", m, "has reached full capacity."))
        }
        print(paste("mentor", m, "is matched,", length(M), "more mentors remaining", sep = " "))
        flag = T # flag to break outer for loop
        break # break inner for loop
      }
    }
    if (flag) {break} # break outer for loop only along with inner one
  }
}


