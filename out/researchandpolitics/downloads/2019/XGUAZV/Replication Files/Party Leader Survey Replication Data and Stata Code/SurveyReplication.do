* Open data file
use "~\surveyReplication.dta", clear

* Create indicator for if they answered at least one of the ranking questions
gen answered1 = 1 if lazarq1theyhaveafriendorcolleagu != "" | lazarq1theyarepartofasocialclubo != "" | lazarq1theyarepartofalabororbusi != "" | lazarq1theyarepartofsomeotherpro != "" | lazarq1theyarefinanciallywelloff != "" | lazarq1theyareenticedbymatchingf != "" | lazarq1theytendtodonateregularly != "" | lazarq1other != ""

* Create party variable (1=Democrat, 0=Republican)
gen dem = 1 if party == 1
replace dem = 0 if party == 2

* Commands to generate numeric dummy variables for whether a response is
* ranked in the top 3 for the respondent.
gen pnet1b = 1 if lazarq1theyhaveafriendorcolleag != ""
replace pnet1 = 0 if pnet1 != 1 & answered1 == 1
gen porg2 = 1 if lazarq1theyarepartofasocialclubo != ""
replace porg2 = 0 if porg2 != 1 & answered1 == 1
gen porg3 = 1 if lazarq1theyarepartofalabororbus != ""
replace porg3 = 0 if porg3 != 1 & answered1 == 1
gen pgrp4 = 1 if lazarq1theyarepartofsomeotherpr != ""
replace pgrp4 = 0 if pgrp4 != 1 & answered1 == 1
gen prch5 = 1 if lazarq1theyarefinanciallywell != ""
replace prch5 = 0 if prch5 != 1 & answered1 == 1
gen pmtc6 = 1 if lazarq1theyareenticedbymatch != ""
replace pmtc6 = 0 if pmtc6 != 1 & answered1 == 1
gen pdon7 = 1 if lazarq1theytendtodonateregul != ""
replace pdon7 = 0 if pdon7 != 1 & answered1 == 1
gen poth8 = 1 if lazarq1other != ""
replace poth8 = 0 if poth8 != 1 & answered1 == 1

* Replication code for Figure 2
* Overall proportions named in top-3
sum pnet1 porg2 porg3 pgrp4 prch5 pmtc6 pdon7 poth8
* t-test results
ttest pnet1, by(dem) unequal
ttest porg2, by(dem) unequal
ttest porg3, by(dem) unequal
ttest pgrp4, by(dem) unequal
ttest prch5, by(dem) unequal
ttest pmtc6, by(dem) unequal
ttest pdon7, by(dem) unequal
ttest poth8, by(dem) unequal

* Regress responses against population density measures
* Note: This analysis is is for Figure 1.
* It is withheld from replication because it would potentially identify respondents in violation of IRB requirements for survey.
* To replicate, please contact rkennedy@uh.edu to make arrangements to visit Duke University and conduct replication on site.
* Commands to merge population density data with original survey data on the basis of county.
* Open merge file, save as Stata 12 format
use13 C:\Users\nwc8\Desktop\pdinfo.dta
drop state
save "C:\Users\nwc8\Desktop\pdinfo12.dta"
* Open NPSL dataset, merge in merge file
use C:\Users\nwc8\Desktop\NSPL-3-30-15.dta 
replace fips = "" if fips == "000NA"
destring fips, replace
merge m:1 fips using "C:\Users\nwc8\Desktop\pdinfo12.dta"
* Regression reports for Figure 1
reg pnet1 pd
reg porg2 pd
reg porg3 pd
reg pgrp4 pd
reg prch5 pd
reg pmtc6 pd
reg pdon7 pd
reg poth8 pd

reg pnet1 pd20
reg porg2 pd20
reg porg3 pd20
reg pgrp4 pd20
reg prch5 pd20
reg pmtc6 pd20
reg pdon7 pd20
reg poth8 pd20




