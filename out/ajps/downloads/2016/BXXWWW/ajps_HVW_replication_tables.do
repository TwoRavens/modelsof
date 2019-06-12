* Replication file for Tables 1, 2, and 3, in Hitt, Volden, Wiseman, American Journal of Political Science, 2016 
* Scholar needs to import ajps_HVW_tables_replication.dta file into the same directory as this .do file before executing .do file
* ajps_HVW_tables_replication.dta is formated for Stata version 13

*Estimating Model 1.1

regress les seniority chair subchr, cluster(icpsr)

*Estimating Model 1.2

regress les leslag seniority state_leg state_leg_prof majority maj_leader min_leader speaker chair subchr power meddist female afam latino deleg_size votepct votepct_sq, cluster(icpsr)

*To estimate models in Table 2, we need to identify which members of the minority party are on the minority party side of the legislative median
*To generate this indicator variable, we begin by identifying the location of the legislative median in every congress

sort congress
by congress: sum dwnom1,d

*Having identified the median legislator in every congress, we now need to reorganize the data so that each row represents one bill that was introduced by each legislator

*Making one observation per bill introduced
sort thomas_num congress
expand all_bills
drop if all_bills==0
sort thomas_num congress
gen billobs=1
replace billobs=billobs[_n-1]+1 if congress==congress[_n-1] & thomas_num==thomas_num[_n-1]
label var billobs "Numbered observations for this member-Congress bill introductions"
*Creating indicator for action beyond committee (for dependent variable or conditional statement) 
gen dvabc=0
replace dvabc=1 if all_abc>=billobs
label var dvabc "1=bill received action beyond committee, 0 = not"
*Creating indicator for action passing House (for dependent variable or conditional statement)gen dvpass=0
gen dvpass=0
replace dvpass=1 if all_pass>=billobs
label var dvpass "1=bill passed House, 0 = not"
*Creating indicator for action becoming law (for dependent variable or conditional statement)gen dvlaw=0
gen dvlaw=0
replace dvlaw=1 if all_law>=billobs
label var dvlaw "1=bill became law, 0 = not"

*We now need to generate an indicator variable for minority party members that are located on the minority party side of the legislative median

sort congress
gen minsidemedian=0
label var minsidemedian "1 = minority side of median, 0 = majority side of median, . = majority member"
replace minsidemedian =1 if dwnom1>-0.047 & majority==0 & congress==93
replace minsidemedian =1 if dwnom1>-0.183 & majority==0 & congress==94
replace minsidemedian =1 if dwnom1>-0.1695 & majority==0 & congress==95
replace minsidemedian =1 if dwnom1>-0.139 & majority==0 & congress==96
replace minsidemedian =1 if dwnom1>-0.061 & majority==0 & congress==97
replace minsidemedian =1 if dwnom1>-0.126 & majority==0 & congress==98
replace minsidemedian =1 if dwnom1>-0.103 & majority==0 & congress==99
replace minsidemedian =1 if dwnom1>-0.126 & majority==0 & congress==100
replace minsidemedian =1 if dwnom1>-0.1315 & majority==0 & congress==101
replace minsidemedian =1 if dwnom1>-0.151 & majority==0 & congress==102
replace minsidemedian =1 if dwnom1>-0.158 & majority==0 & congress==103
replace minsidemedian =1 if dwnom1< 0.183 & majority==0 & congress==104
replace minsidemedian =1 if dwnom1< 0.1915 & majority==0 & congress==105
replace minsidemedian =1 if dwnom1< 0.158 & majority==0 & congress==106
replace minsidemedian =1 if dwnom1< 0.203 & majority==0 & congress==107
replace minsidemedian =1 if dwnom1< 0.261 & majority==0 & congress==108
replace minsidemedian =1 if dwnom1< 0.305 & majority==0 & congress==109
replace minsidemedian =1 if dwnom1>-0.177 & majority==0 & congress==110
replace minsidemedian =1 if dwnom1>-0.184 & majority==0 & congress==111
replace minsidemedian =1 if dwnom1< 0.458 & majority==0 & congress==112
replace minsidemedian =1 if dwnom1< 0.467 & majority==0 & congress==113

*We can now estimate the models in Tables 2 and 3
*Estimate Model 2.1

logit dvabc meddist if minsidemedian==1, cluster(icpsr)

*Estimate Model 2.2

logit dvabc meddist female afam latino seniority power votepct votepct_sq state_leg state_leg_prof min_leader deleg_size if minsidemedian==1, cluster(icpsr)

*Estimate Model 3.1

logit dvpass majority if dvabc==1, cluster(icpsr)

*Estimate Model 3.2

logit dvpass majority meddist female afam latino seniority chair subchr power speaker votepct votepct_sq state_leg state_leg_prof maj_leader min_leader deleg_size if dvabc==1, cluster (icpsr)

*Estimate Model 3.3

logit dvlaw majority if dvabc==1, cluster(icpsr)

*Estimate Model 3.4

logit dvlaw majority meddist female afam latino seniority chair subchr power speaker votepct votepct_sq state_leg state_leg_prof maj_leader min_leader deleg_size if dvabc==1, cluster (icpsr)







