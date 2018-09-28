# NITCAMP_matching

Algorithm to match mentees and mentors based on their preference lists.

###################################################################

Update on Sep 28, 2018

Added updated file NITCAMP_matching_v2.R

Not providing the Excel input files as these contain personal information of mentors and mentees. Please contact me  at vineetma@buffalo.edu for access to input data.

Will upload a sample dataset soon for testing.

Logic (changed from NITCAMP_matching.R described below):

- Read input data (mentors' and mentees' preferences) from Excel

- Convert the input data into an array format

- Sort mentee names in: (i) decreasing order of sum of mentor preferences (the inverse may result in mentees preferred more by mentors getting eliminated/not getting mentors). 

- Sort mentor names in: (i) increasing order of sum of mentee preferences (the inverse may result in mentors preferred more by mentees getting eliminated/not getting mentees).

- Read mentor capacity from mentor input data - that is, number of mentees each mentor can guide

- Initialize list of "unlocked" mentees (E), and list of "unlocked" mentors (M).

- Define a "large" number (larger than any mentee/mentor preference value) for scoring purposes.

- Start search. (Outer loop: For mentee e in E; inner loop: For mentor m in M). Limit search to mentees and mentors whose matching is not complete. Continue search until mentees' capacities (by default = 1) and mentors' capacities (variable from one mentor to another) are reached.

- Limit search to mentees and mentors whose matching is not complete

- Lock a mentee-mentor pair if neither can find a better match (from the unlocked mentors and mentees), subject to a tolerance that can be set as a parameter. Also, (i) add mentee "e" to mentor "m" list, (ii) assign large score, for locking the mentee, and (iii) remove locked mentee from the list of unlocked mentees.

- If the mentor has reached capacity limit, (i) assign large score, for locking the mentor, and (ii) remove locked mentor from the list of unlocked mentors.

- The tolerance parameter can be set to three recommended levels - "strict," "moderate," and "compromised." As these names suggest, "strict" will have strict (less) but higher quality matching, and "compromised" will have compromised (more) but lower quality matching. "Moderate" is a middle ground between the former two. 

- The final part of the code writes the matching list into a .CSV file.

######################################################################################################################################


(Old) R Code (NITCAMP_matching.R) for matching mentees' and mentors' preferences. Uses a sample data (sample_pref.xlsx).

Logic:

- Generate a sample dataset of mentee and mentor preferences (for demo)

- refer to "sample_pref.xlsx" for visualizing the sample dataset

- Sort mentee names in: (i) decreasing order of mentees' year in college (so as to give more importance to 4th and 3rd year students while matching) and (ii) increasing order of number of mentors who have preferred the mentee (the inverse may result in mentees preferred by less number of mentors getting eliminated/not getting mentors). 

- Sort mentor names in: (i) increasing order of number of mentees who have preferred the mentor (the inverse may result in mentors preferred by less number of mentees getting eliminated/not getting mentees).

- In the sample dataset, it is assumed that the mentees and mentors are already sorted. 

- Define mentor capacity - that is, number of mentees each mentor can guide

- Initialize list of "unlocked" mentees (E), and list of "unlocked" mentors (M).

- Define a "large" number (larger than any mentee/mentor preference value) for scoring purposes.

- Start search. (Outer loop: For mentee e in E; inner loop: For mentor m in M). Limit search to mentees and mentors whose matching is not complete. Continue search until mentees' capacities (by default = 1) and mentors' capacities (variable from one mentor to another) are reached.

- Limit search to mentees and mentors whose matching is not complete

- Lock a mentee-mentor pair if neither can find a better match (from the unlocked mentors and mentees). Also, (i) add mentee "e" to mentor "m" list, (ii) assign large score, for locking the mentee, and (iii) remove locked mentee from the list of unlocked mentees.

- If the mentor has reached capacity limit, (i) assign large score, for locking the mentor, and (ii) remove locked mentor from the list of unlocked mentors.









