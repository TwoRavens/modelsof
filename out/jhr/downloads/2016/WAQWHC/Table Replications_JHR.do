***Table 1 Summary Stats
sum serf_overall serf_educ serf_health serf_housing serf_food serf_work dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst if dummy_el~=. & serf_overall~=.

*******MAIN TABLES
****Table 2 - Effect of Constitutional provision on SERF Index
reg serf_overall dummy_el dummy_dp, robust
reg serf_overall dummy_el dummy_dp length_dumel length_const, robust
reg serf_overall dummy_el dummy_dp judicial_independence length_dumel length_const, robust
reg serf_overall dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos, robust
reg serf_overall dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst, robust
reg serf_overall dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst africa asia latam, robust

***Table 3 -- Education component
reg serf_educ dummy_el dummy_dp, robust
reg serf_educ dummy_el dummy_dp length_dumel length_const, robust
reg serf_educ dummy_el dummy_dp judicial_independence length_dumel length_const, robust
reg serf_educ dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos, robust
reg serf_educ dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst, robust
reg serf_educ dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst africa asia latam, robust

***Table 4 -- health
reg serf_health dummy_el dummy_dp, robust
reg serf_health dummy_el dummy_dp length_dumel length_const, robust
reg serf_health dummy_el dummy_dp judicial_independence length_dumel length_const, robust
reg serf_health dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos, robust
reg serf_health dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst, robust
reg serf_health dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst africa asia latam, robust

***Table 5 -- food
reg serf_food dummy_el dummy_dp, robust
reg serf_food dummy_el dummy_dp length_dumel length_const, robust
reg serf_food dummy_el dummy_dp judicial_independence length_dumel length_const, robust
reg serf_food dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos, robust
reg serf_food dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst, robust
reg serf_food dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst africa asia latam, robust

***Appendix A1 Table 6 -- housing
reg serf_housing dummy_el dummy_dp, robust
reg serf_housing dummy_el dummy_dp length_dumel length_const, robust
reg serf_housing dummy_el dummy_dp judicial_independence length_dumel length_const, robust
reg serf_housing dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos, robust
reg serf_housing dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst, robust
reg serf_housing dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst africa asia latam, robust

***Appendix A1 Table 7 -- work
reg serf_work dummy_el dummy_dp, robust
reg serf_work dummy_el dummy_dp length_dumel length_const, robust
reg serf_work dummy_el dummy_dp judicial_independence length_dumel length_const, robust
reg serf_work dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos, robust
reg serf_work dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst, robust
reg serf_work dummy_el dummy_dp judicial_independence length_dumel length_const democ1 ngos landlock lat_abst africa asia latam, robust

***Toronto DATA
***Appendix A2 Table 8 -- SERF
reg serf_overall justiciable aspirational, robust
reg serf_overall justiciable aspirational length_const length_just, robust
reg serf_overall justiciable aspirational judicial_independence  length_const length_just, robust
reg serf_overall justiciable aspirational judicial_independence  length_const length_just democ1 ngos , robust
reg serf_overall justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst, robust
reg serf_overall justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst africa asia latam, robust

***Table 9 - educ
reg serf_educ justiciable aspirational, robust
reg serf_educ justiciable aspirational  length_const length_just, robust
reg serf_educ justiciable aspirational judicial_independence  length_const length_just, robust
reg serf_educ justiciable aspirational judicial_independence  length_const length_just democ1 ngos , robust
reg serf_educ justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst, robust
reg serf_educ justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst africa asia latam, robust

***Table 10 - health
reg serf_health justiciable aspirational, robust
reg serf_health justiciable aspirational  length_const length_just, robust
reg serf_health justiciable aspirational judicial_independence  length_const length_just, robust
reg serf_health justiciable aspirational judicial_independence  length_const length_just democ1 ngos , robust
reg serf_health justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst, robust
reg serf_health justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst africa asia latam, robust

***Table 11 - housing
reg serf_housing justiciable aspirational, robust
reg serf_housing justiciable aspirational  length_const length_just, robust
reg serf_housing justiciable aspirational judicial_independence  length_const length_just, robust
reg serf_housing justiciable aspirational judicial_independence  length_const length_just democ1 ngos , robust
reg serf_housing justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst, robust
reg serf_housing justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst africa asia latam, robust

***Table 12 - food
reg serf_food justiciable aspirational, robust
reg serf_food justiciable aspirational  length_const length_just, robust
reg serf_food justiciable aspirational judicial_independence  length_const length_just, robust
reg serf_food justiciable aspirational judicial_independence  length_const length_just democ1 ngos , robust
reg serf_food justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst, robust
reg serf_food justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst africa asia latam, robust

***Table 13 - work
reg serf_work justiciable aspirational, robust
reg serf_work justiciable aspirational  length_const length_just, robust
reg serf_work justiciable aspirational judicial_independence  length_const length_just, robust
reg serf_work justiciable aspirational judicial_independence  length_const length_just democ1 ngos , robust
reg serf_work justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst, robust
reg serf_work justiciable aspirational judicial_independence  length_const length_just democ1 ngos  landlock lat_abst africa asia latam, robust

