gen pid = pid7
replace pid = 1 if (pid7 <=3)
replace pid = 2 if (pid7 ==4)
replace pid = 3 if (pid7 >=5)

label define party 1 democrat 2 independent 3 republican
label values pid party

bysort pid: tab exclusion c911 [aw=weight], row
bysort pid: tab exclusion muslim [aw=weight], row
