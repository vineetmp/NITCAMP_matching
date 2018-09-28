# NITCAMP mentor-mentee matching process - code
# Author: Vineet Payyapalli
# Created: Sep 8, 2018
# Last updated: Sep 28, 2018
rm(list = ls())
library(readxl)

# read mentee responses
mentees <- read_excel("NITCAMP 2018 mentee pref.xlsx")
mentees <- mentees[, c(2, 5:7)] # select only required columns
colnames(mentees) <- c("name", "pref1", "pref2", "pref3")
# cleaning mentor names
mentees[mentees == "None of the above"] <- "Mentor #0: None"
for (i in 1:nrow(mentees)) {
  for (j in 2:ncol(mentees)) {
    mentees[i, j] <- strsplit(mentees[[i, j]], ": ")[[1]][2]
  }
}
# removing duplicate responses - need to later check whether to select 1st or later occurrences of same mentee
mentees <- mentees[!duplicated(mentees$name), ]

# read mentor responses
mentors <- read_excel("NITCAMP 2018 mentor pref.xlsx")
mentors <- mentors[, c(2,5:ncol(mentors))] # select only required columns
mentors[is.na(mentors)] <- "None"
names(mentors)[1:2] <- c("name", "capacity")

n.e <- nrow(mentees) # number of mentees
n.m <- nrow(mentors) # number of mentors

e.names <- mentees$name # mentees' names
m.names <- mentors$name # mentors' names

m.cap <- mentors$capacity # mentor capacity - that is, number of students each mentor can guide

# low score, to be assigned to mentees/mentors not selected. Also, sorting (later) is done in the decreasing order, so zeros get least priority.
no.score <- 1000 
x <- array(no.score, c(n.e+2, n.m+1, 2)) # initialize score array
# preference layers (two layers in a 3-D array) - e for mentee prefs, m for mentor prefs
pref.layers <- c("e", "m") 
dimnames(x) <- list(c(e.names, "mentor_cap", "mentee_score"), c(m.names, "mentor_score"), pref.layers)

# converting mentees' preference scores to an array format
e.temp <- array(no.score, c(n.e+2, n.m+1))
for (i in 1:nrow(mentees)) {
  for (j in 2:ncol(mentees)) {
    mentor.temp <- match(mentees[[i, j]], m.names)
    if (mentees[[i, j]] != "None" & !is.na(mentor.temp)) {
      e.temp[i, mentor.temp] <- j-1
    }
  }
}
# write.csv(e.temp, "e_temp.csv")

# converting mentors' preference scores to an array format
m.temp <- array(no.score, c(n.e+2, n.m+1))
for (i in 1:nrow(mentors)) {
  for (j in 3:ncol(mentors)) {
    mentee.temp <- match(mentors[[i, j]], e.names)
    if (mentors[[i, j]] != "None" & !is.na(mentee.temp)) {
      m.temp[mentee.temp, i] <- j-2
    }
  }
}
# write.csv(m.temp, "m_temp.csv")

# saving both preference arrays into the initial array
x[, , 1] <- e.temp
x[, , 2] <- m.temp

# to help in sorting scores
x[n.e+2, , ] <- 0
x[, n.m+1, ] <- 0

x[n.e+1, , ] <- c(m.cap, no.score) # adding one row with mentor caps
# calculate mean score of mentors, based on mentees' preferences
for (m in 1:n.m) {
  x[n.e+2, m, 1] <- mean(x[1:n.e, m, 1][x[1:n.e, m, 1] != no.score])
}

# calculate mean score of mentees, based on mentors' preferences
for (e in 1:n.e) {
  x[e, n.m+1, 2] <- mean(x[e, 1:n.m, 2][x[e, 1:n.m, 2] != no.score])
}

# making sure the mentor score, mentor capacity rows are identical in both layers
x[(n.e+1):(n.e+2), , 2] <- x[(n.e+1):(n.e+2), , 1]
# making sure the mentee score column is identical in both layers
x[, n.m+1, 1] <- x[, n.m+1, 2]

x[is.na(x)] <- 0

# sorting rows in the decreasing order of mentee scores (column)
for (i in 1:2) {
  temp <- x[1:n.e, , i]
  temp <- temp[order(temp[, n.m+1], decreasing = T), ]
  x[1:n.e, , i] <- temp
}
dimnames(x)[[1]] <- c(dimnames(temp)[[1]], "mentor_cap", "mentee_score")

# sorting columns in the decreasing order of mentor scores (row)
for (i in 1:2) {
  temp <- x[, 1:n.m, i]
  temp <- temp[, order(temp[n.e+2, ], decreasing = T)]
  x[, 1:n.m, i] <- temp
}
dimnames(x)[[2]] <- c(dimnames(temp)[[2]], "mentor_score")

# write.csv(x[, , 1], "mentee_scores.csv")
# write.csv(x[, , 2], "mentor_scores.csv")

x.copy <- x # backup 

m.cap <- x[n.e+1, 1:n.m, 1] # mentor capacity - that is, number of students each mentor can guide

x.e <- x[, , 1]
x.m <- x[, , 2]

# write.csv(x.e, "x_e.csv")
# write.csv(x.m, "x_m.csv")

# remove score and capacity columns
x <- x[1:n.e, 1:n.m, ]

e.names <- dimnames(x)[[1]][1:n.e] # mentees' names
m.names <- dimnames(x)[[2]][1:n.m] # mentors' names

E <- 1:n.e # list of "unlocked" mentees
M <- 1:n.m # list of "unlocked" mentors
match <- list() # create empty list to store matched values
for (m in M) { # add one empty list for each mentor
  match[[m]] <- list()
}
names(match) <- m.names
counter = 0


## Matching  
tol <- 1 # this is the tolerance level. Reasonable values are 0, 1, 2. (use "==" when tol=0, and "<=" when tol = 1 or 2) )
# the tolerance level indicates a compromise level while searching for the match
# tolerance level 0 will yield (strict) less but higher quality matching
# tolerance level 2 will yield (compromised) more but lower quality matching
while (length(E) > 0 & length(M) > 0 & counter <= 200) { # limit search to mentees and mentors whose matching is not complete
  flag = F
  counter = counter + 1
  print(paste0("search # ", counter))
  for (m in M) { 
    # print (paste0("checking mentee ", e))
    for (e in E) {
      # print (paste0("checking mentor ", m))
      # lock a mentee-mentor pair if neither can find a better match (from the unlocked mentors and mentees)
      if (x[e, m, 1] <= (min(x[e, , 1])+tol) & x[e, m, 1] != no.score & 
          x[e, m, 2] <= (min(x[, m, 2])+tol) & x[e, m, 2] != no.score) {
        match[[m]][[length(match[[m]]) + 1]] <- paste0(e.names[e], 
                                                       " (e_pref = ", x[e, m, 1], 
                                                       ", m_pref = ", x[e, m, 2], ")") # add mentee "e" to mentor "m" list 
        x[e, , ] <- no.score # assign highest score, for locking the mentee 
        E <- E[-(which(E==e))] # remove locked mentee from the list of unlocked mentees
        print(paste("mentee", e, "(", e.names[e], ")", "is matched,", length(E), "more mentees remaining", sep = " "))
        if (length(match[[m]]) == m.cap[m]) { # check if mentor has reached capacity limit
          x[, m, ] <- no.score # assign smallest score, for locking the mentor
          M <- M[-(which(M==m))] # remove locked mentor from the list of unlocked mentors
          print(paste("mentor", m, "has reached full capacity."))
        }
        print(paste("mentor", m, "(", m.names[m], ")", "is matched,", length(M), "more mentors remaining", sep = " "))
        flag = T # flag to break outer for loop
        break # break inner for loop
      }
    }
    if (flag) {break} # break outer for loop only along with inner one
  }
}

# convert result to a dataframe and save as .CSV file
match.array <- array("", list(n.m, max(m.cap)+2))
dimnames(match.array) <- list(m.names, c("mentor", "capactiy", paste0("mentee_", seq(1, max(m.cap), by = 1))))
for (i in 1:n.m) {
  if (length(match[[i]]) != 0) {
    match.array[i, 3:(length(match[[i]])+2)] <- unlist(match[[i]])
  }
}
match.df <- as.data.frame(match.array, stringsAsFactors = F)
match.df$mentor <- rownames(match.df)
rownames(match.df) <- 1:nrow(match.df)
match.df$capactiy <- m.cap
write.csv(match.df, "NITCAMP_matching_v1.csv")

