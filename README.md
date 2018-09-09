# NITCAMP_matching
Algorithm to match mentees and mentors based on their preference lists.

R Code (NITCAMP_matching.R) for matching mentees' and mentors' preferences. Uses a sample data (sample_pref.xlsx).

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








