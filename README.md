<h1>NITCAMP_matching</h1>

This dev branch currently has some ideas and work in progress.

<h2>Discrete optimization model:</h2>

<h3>Define sets:</h3>

M = {1, 2, 3, ..., i, ..., m}; set of mentees`

N = {1, 2, 3, ..., j, ..., n}; set of mentors`

Condition: m >= n

<h3>Define vars:</h3>

x_ij = 1 if mentee i is matched with mentor j

x_ij = 0 otherwise

<h3>Define constants:</h3>

c_j = Capacity of mentor j

p_ij = Preference score of mentee i on mentee j

q_ij = Preference score of mentor j on mentee i

<h3>Objective:</h3>

Minimize sum_ij (p_ij*q_ij*x_ij)

<h3>Subject to constraints:</h3>

sum_i x_ij <= c_j for all j

sum_j x_ij <= 1 for all i
