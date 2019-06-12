gen pid = DOV_XPARTY7
replace pid = 1 if (DOV_XPARTY7 <=3)
replace pid = 2 if (DOV_XPARTY7 ==4)
replace pid = 3 if (DOV_XPARTY7 >=5)

label define party 1 republican 2 independent 3 democrat
label values pid party

bysort pid: sum Q1 [iw=weight3]
bysort pid: sum Q2 [iw=weight3]
bysort pid: tab Q3B [iw=weight3]
