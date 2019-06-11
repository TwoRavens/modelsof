
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data05-voterecord.log", replace


***************************************************************
* Generation of UN voting dataset for COW states system members
***************************************************************

* Programme:	msim-data05-voterecord.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file cleans data on voting in the UN General Assembly and merges it with the State System Membership dataset (msim-data01a-sysmemb.dta), 
* The latter is based on the system version of the COW State System Membership List (v2004.1).
* The resulting sample includes all COW state system members that were also UN members between 1946 and 2004.
* The input dataset for UN voting is the United Nations General Assembly Voting dataset collected by Voeten and Merdzanovic 
* (http://hdl.handle.net/1902.1/12379 UNF:3:Hpf6qOkDdzzvXF9m66yLTg== V1 [Version])


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off
set memory 500m


* Prepare and generate additional voting dataset variables
**********************************************************

* Open the voting dataset
insheet using "Datasets\Source\Voeten UN voting\undata1_63longarchive.tab", clear
sort rcid date ccode

* Rename and label variables
rename rcid rccode_orig
label var rccode_orig "Roll call code (UNGA voting, v1)"
label var session "Session number"
label var unres "Resolution code"
label var ccode "Country code (UNGA voting, v1)"
rename cnt cabb_un
label var cabb_un "Country abbreviation (UNGA voting, v1)"

* Generate voting date variable
rename date date_old
generate date = date(date_old, "YMD")
format date %td
label var date "Date"
drop date_old

* Generate year variable
generate year = year(date)
label var year "Year"

* Generate month variable
generate month = month(date)
label var month "Month"

* Generate day variable
generate day = day(date)
label var day "Day"

* Generate type of vote variable
rename vote votetype
label var votetype "Type of vote"
label def votetypel 1 "1 Yes" 2 "2 Abstain" 3 "3 No" 8 "8 Absent" 9 "9 Non-member"
label val votetype votetypel

* Check type of vote variable
tab votetype, m
list rccode_orig-day if votetype == 11 | votetype == 5
* Observations with undefined values are in the years 2006 and 2007
* They are not part of the sample used for this analysis


* Correct country coding discrepancies between UN voting and COW system membership data
***************************************************************************************

* Germany
* Check whether there are any observations incorrectly coded with the pre-1990 country code
sort year
by year: tab votetype if date >= td(3oct1990) & ccode == 260
by year: tab votetype if date >= td(3oct1990) & ccode == 255
* Country code is 260 after 1990, but should be 255
tab year if date >= td(3oct1990) & ccode == 260
* Recode voting data country code to post-1990 COW country code
replace ccode = 255 if date >= td(3oct1990) & ccode == 260
* In COW system membership data, Germany receives code 260 from 1990 onwards

* Yemen
* Check whether there are any observations incorrectly coded with the pre-1990 country code
sort year
by year: tab votetype if date >= td(22may1990) & ccode == 678
by year: tab votetype if date >= td(22may1990) & ccode == 679
* Country code is 678 after 1990, but should be 679
tab year if date >= td(22may1990) & ccode == 678
* Recode voting data country code to post-1990 COW country code
replace ccode = 679 if date >= td(22may1990) & ccode == 678
* In COW system membership data, Yemen receives code 679 from 1990 onwards

* Czech republic
* Check whether Czech republic received country code of Czechoslowakia after 1992
sort year
by year: tab votetype if date >= td(01jan1993) & ccode == 315
* Czechoslovakia does not exist anymore after 1992
* The vote variable shows only 'absent' or 'non-member' after 1992
* Drop observations for Czechoslovakia after 1992
tab year if date >= td(01jan1993) & ccode == 315
drop if date >= td(01jan1993) & ccode == 315

* Syria
* Syria was part of Egypt between 1958 and 1961
* Check whether Seria country code appears between 1958 and 1961
sort year
by year: tab votetype if date >= td(01feb1958) & date < td(29sep1961) & ccode == 652
sort unres ccode
list unres date ccode votetype if date >= td(01feb1958) & date < td(29sep1961) & (ccode == 651 | ccode == 652)
* Syria and Egypt could not have voted for the same resolution in 1960, so delete Syria data
tab year if date >= td(01feb1958) & date < td(29sep1961) & ccode == 652
drop if date >= td(01feb1958) & date < td(29sep1961) & ccode == 652

* Taiwan
* Taiwan is not recognized as independent country in COW data before 1949
* Check if Taiwan appears in voting data before 1949
sort year
by year: tab votetype if date < td(08dec1949) & ccode == 713
by year: tab votetype if date < td(08dec1949) & ccode == 710
* China is coded as 'non-member' for this period
* Drop China observations as non-members and recode Taiwan votes as China votes
tab year if date < td(08dec1949) & ccode == 710
drop if date < td(08dec1949) & ccode == 710
tab year if date < td(08dec1949) & ccode == 713
replace ccode = 710 if date < td(08dec1949) & ccode == 713
tab year if date < td(08dec1949) & ccode == 710
by year: tab votetype if date < td(08dec1949) & ccode == 710

* China
* China takes over UN seat from Taiwan in 1971
tab year if year < 1949 & ccode == 71
sort year
by year: tab votetype if date >= td(25oct1971) & ccode == 713
by year: tab votetype if date >= td(25oct1971) & ccode == 710
* Taiwan observations incorrectly hold votes of China in 1972 and 1973
* Drop 'non-member' observations of China in 1972 and 1973
tab year if (year == 1972 | year == 1973) & ccode == 710
drop if (year == 1972 | year == 1973) & ccode == 710
* Recode Taiwan observations as China observations for 1972 and 1973
tab year if (year == 1972 | year == 1973) & ccode == 713
replace ccode = 710 if (year == 1972 | year == 1973) & ccode == 713
by year: tab votetype if date >= td(25oct1971) & ccode == 710

* Correct country codes for new UN members that have an incorrect COW country code in voting data
* Kiribati (946, 1999-)
replace ccode = 946 if ccode == 970
* Nauru (970, 1999-)
replace ccode = 970 if ccode == 971
* Tonga (955, 1999-)
replace ccode = 955 if ccode == 972
* Tuvalu (947, 2000-)
replace ccode = 947 if ccode == 973
* East Timor (860, 2002-)
replace ccode = 860 if ccode == 855


* Merge the voting data with COW system membership data
*******************************************************

* Prepare system membership data for merge
preserve
	use "Datasets\Derived\msim-data01a-sysmemb.dta", clear
	sort year ccode
	save "Datasets\Derived\msim-data01a-sysmemb.dta", replace
restore

* Merge the datasets
sort year ccode
merge year ccode using "Datasets\Derived\msim-data01a-sysmemb.dta", uniqusing


* Check which observations were in system membership data but not in voting data
********************************************************************************

* Examine merge variable
tab _merge, m
tab year if _merge == 2

* Drop observations with years later than 2004
drop if year > 2004
* COW system membership data is only up-to-date until 2004

* Drop observations with years earlier than 1946
drop if year < 1946
* No UN votes before 1946

* Drop observations in year 1964
drop if year == 1964
* There were no recorded votes during this year

* Drop observations for Vietnam (COW code 817, 1954-1975)
drop if ccode == 817
* No voting data for this country because it was not a member of the UN during that time period

* Drop those observations that resulted from some countries changing status during a year
list year votetype ccode cabb cabb_un if _merge == 2
* Germany and Yemen were included twice in the COW system membership data in 1990,
* once under their pre-unification code and once under their post-unification code 
drop if year == 1990 & (ccode == 260 | ccode == 678)
* Taiwan is only recognized as a separate state by COW data in 1949 and was not member
* of the UN anymore in 1972 and 1973
drop if _merge == 2 & cabb == "TAW"
* Syria formed a union with Egypt in 1958
drop if _merge == 2 & cabb == "SYR"


* Check which observations were in voting data but not in system membership data
********************************************************************************

* Examine merge variable
tab _merge, m
tab year if _merge == 1

* Drop cases that were definitely not UN members (according to both sources)
drop if votetype == 9 & _merge == 1

* Drop observations for Belarus and Ukraine before their independence in 1991
drop if cabb_un == "BLR" & year < 1991 & _merge == 1
drop if cabb_un == "UKR" & year < 1991 & _merge == 1

* Drop observations for India before its independence in 1947
drop if cabb_un == "IND" & year == 1946

* Examine remaining inconsistencies
sort year
by year: tab cabb_un votetype if _merge == 1, m

* Check remaining inconsistencies (Source: http://www.un.org/en/members [accessed on 18 June 2009])
* Saint Lucia became a UN member in 1979, so 1977 entry must be incorrect
drop if cabb_un == "SLU" & year == 1977
* Jamaica and Trinidad and Tobago became UN members in 1962, so 1961 entry must be incorrect
drop if (cabb_un == "JAM" | cabb_un == "TRI") & year == 1961
* Macedonia became a UN member in 1993, so 1992 entry must be incorrect
drop if cabb_un == "MAC" & year == 1992
* East Timor became a UN member in 2002, so 2001 entry must be incorrect
drop if cabb_un == "ETR" & year == 2001


* Further corrections, deletion of variables and observations, and generation of new variables
**********************************************************************************************

* Correct country abbreviation in voting data
replace cabb_un = "ETM" if cabb_un == "ETR" & ccode == 860
replace cabb_un = "FIJ" if cabb_un == "FJI" & ccode == 950
replace cabb_un = "GMY" if cabb_un == "GFR" & ccode == 255
replace cabb_un = "KIR" if cabb_un == "KBI" & ccode == 946
replace cabb_un = "ROM" if cabb_un == "RUM" & ccode == 360
replace cabb_un = "CHN" if cabb_un == "TAW" & ccode == 710
replace cabb_un = "YAR" if cabb_un == "YEM" & ccode == 678
assert cabb_un == cabb

* Drop redundant variables
drop cabb_un _merge

* Drop non-member state observations
tab votetype, m
drop if votetype == 9

* Generate running number as roll call vote identification variable
sort date rccode_orig
egen rccode = group(date rccode_orig)
label var rccode "Roll call code (running number)"

* Save dataset
order session rccode rccode_orig unres date day month year cabb ccode votetype 
sort rccode ccode
compress
save "Datasets\Derived\msim-data05-voterecord.dta", replace


* Exit do-file
log close
exit
