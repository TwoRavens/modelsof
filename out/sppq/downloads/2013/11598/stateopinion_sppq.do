** 
** "New Measures of Partisanship, Ideology, and Policy Mood in the American States"
** Thomas M. Carsey (carsey@unc.edu) and Jeffrey J. Harden (jjharden@unc.edu)
** University of North Carolina at Chapel Hill
**
*************************************************************************************************************************************************************
**
** Master .do file created by Jeff Harden 
** Last update: 01/18/10
**
** PART I: Creating the new measures from the NAES and CCES data.
**
** The files used are: CCES 2006 version 11/14/07 ('cces06.dta') and CCES 2008 version 2/10/09, downloaded at 
** http://web.mit.edu/polisci/portl/cces/commoncontent.html 
** and the NAES datasets ('naes00.dta' and 'naes04.dta') on the CD that comes with:
**
**	 Romer, Daniel, Kate Kenski, Kenneth Winneg, Christopher Adasiewicz, and Kathleen Hall 
**		Jamieson. 2006. Capturing Campaign Dynamics 2000 & 2004: The National Annenberg Election Survey.
**		Philadelphia: University of Pennsylvania Press.
**
** PART II: Gathering existing measures from the EWM and BRFH data.
**
** The files used are EWM dataset ('ewm.dta'), downloaded at http://mypage.iu.edu/~wright1
** and the BRFH dataset ('brfh.dta'), downloaded at http://www.uky.edu/~rford/Home_files/page0005.htm
**
** PART III: Merging all the files together.
**
** Below are all of the commands used to create the measures in the paper. Place this .do file and all the files using the names listed above
** in the same folder and change the directory in line 31 to that folder.
**
*************************************************************************************************************************************************************

cd [DIRECTORY NAME HERE]

clear
set more off
set mem 300m

*************************************************************************************************************************************************************

** PART I
** Creating measures of state partisanship, ideology, and policy mood from the CCES 2006 and 2008.

** This set of commands generates a new party identification variable so that Democrats are the high value,  
** Independents are in the middle, and Republicans are the low value. 

use cces06.dta, clear
gen state = v1002
drop if state == "DC"
gen pid_cces06 = .
replace pid_cces06 = 3 if v3005 == 1
replace pid_cces06 = 2 if v3005 == 3
replace pid_cces06 = 1 if v3005 == 2
collapse (mean) pid_cces06 (semean) pid_se_cces06 = pid_cces06, by (state)
sort state
save pid_cces06.dta, replace

use cces08.dta, clear
gen statenumber = v206
drop if statenumber == 11
gen pid_cces08 = .
replace pid_cces08 = 3 if cc307 == 1
replace pid_cces08 = 2 if cc307 == 3
replace pid_cces08 = 1 if cc307 == 2
collapse (mean) pid_cces08 (semean) pid_se_cces08 = pid_cces08, by (statenumber)
gen state = ""
replace state =	"AL"	if statenumber == 	1
replace state =	"AK"	if statenumber == 	2
replace state =	"AZ"	if statenumber == 	4
replace state =	"AR"	if statenumber == 	5
replace state =	"CA"	if statenumber == 	6
replace state =	"CO"	if statenumber == 	8
replace state =	"CT"	if statenumber == 	9
replace state =	"DE"	if statenumber == 	10
replace state =	"FL"	if statenumber == 	12
replace state =	"GA"	if statenumber == 	13
replace state =	"HI"	if statenumber == 	15
replace state =	"ID"	if statenumber == 	16
replace state =	"IL"	if statenumber == 	17
replace state =	"IN"	if statenumber == 	18
replace state =	"IA"	if statenumber == 	19
replace state =	"KS"	if statenumber == 	20
replace state =	"KY"	if statenumber == 	21
replace state =	"LA"	if statenumber == 	22
replace state =	"ME"	if statenumber == 	23
replace state =	"MD"	if statenumber == 	24
replace state =	"MA"	if statenumber == 	25
replace state =	"MI"	if statenumber == 	26
replace state =	"MN"	if statenumber == 	27
replace state =	"MS"	if statenumber == 	28
replace state =	"MO"	if statenumber == 	29
replace state =	"MT"	if statenumber == 	30
replace state =	"NE"	if statenumber == 	31
replace state =	"NV"	if statenumber == 	32
replace state =	"NH"	if statenumber == 	33
replace state =	"NJ"	if statenumber == 	34
replace state =	"NM"	if statenumber == 	35
replace state =	"NY"	if statenumber == 	36
replace state =	"NC"	if statenumber == 	37
replace state =	"ND"	if statenumber == 	38
replace state =	"OH"	if statenumber == 	39
replace state =	"OK"	if statenumber == 	40
replace state =	"OR"	if statenumber == 	41
replace state =	"PA"	if statenumber == 	42
replace state =	"RI"	if statenumber == 	44
replace state =	"SC"	if statenumber == 	45
replace state =	"SD"	if statenumber == 	46
replace state =	"TN"	if statenumber == 	47
replace state =	"TX"	if statenumber == 	48
replace state =	"UT"	if statenumber == 	49
replace state =	"VT"	if statenumber == 	50
replace state =	"VA"	if statenumber == 	51
replace state =	"WA"	if statenumber == 	53
replace state =   "WV"	if statenumber == 	54
replace state =	"WI"	if statenumber == 	55
replace state =	"WY"	if statenumber == 	56
drop statenumber
sort state
save pid_cces08.dta, replace

** This set of commands generates a new three option ideology variable from the five option ideology variable
** with Liberals as the high value, Independents in the middle, and Republicans as the low value. 

use cces06.dta, clear
gen state = v1002
drop if state == "DC"
gen ideo_cces06 = .
replace ideo_cces06 = 3 if v2021 <= 2
replace ideo_cces06 = 2 if v2021 == 3
replace ideo_cces06 = 1 if v2021 == 4
replace ideo_cces06 = 1 if v2021 == 5
collapse (mean) ideo_cces06 (semean) ideo_se_cces06 = ideo_cces06, by (state)
sort state
save ideo_cces06.dta, replace

use cces08.dta, clear
gen statenumber = v206
drop if statenumber == 11
gen ideo_cces08 = .
replace ideo_cces08 = 3 if v243 <= 2
replace ideo_cces08 = 2 if v243 == 3
replace ideo_cces08 = 1 if v243 == 4
replace ideo_cces08 = 1 if v243 == 5
collapse (mean) ideo_cces08 (semean) ideo_se_cces08 = ideo_cces08, by (statenumber)
gen state = ""
replace state =	"AL"	if statenumber == 	1
replace state =	"AK"	if statenumber == 	2
replace state =	"AZ"	if statenumber == 	4
replace state =	"AR"	if statenumber == 	5
replace state =	"CA"	if statenumber == 	6
replace state =	"CO"	if statenumber == 	8
replace state =	"CT"	if statenumber == 	9
replace state =	"DE"	if statenumber == 	10
replace state =	"FL"	if statenumber == 	12
replace state =	"GA"	if statenumber == 	13
replace state =	"HI"	if statenumber == 	15
replace state =	"ID"	if statenumber == 	16
replace state =	"IL"	if statenumber == 	17
replace state =	"IN"	if statenumber == 	18
replace state =	"IA"	if statenumber == 	19
replace state =	"KS"	if statenumber == 	20
replace state =	"KY"	if statenumber == 	21
replace state =	"LA"	if statenumber == 	22
replace state =	"ME"	if statenumber == 	23
replace state =	"MD"	if statenumber == 	24
replace state =	"MA"	if statenumber == 	25
replace state =	"MI"	if statenumber == 	26
replace state =	"MN"	if statenumber == 	27
replace state =	"MS"	if statenumber == 	28
replace state =	"MO"	if statenumber == 	29
replace state =	"MT"	if statenumber == 	30
replace state =	"NE"	if statenumber == 	31
replace state =	"NV"	if statenumber == 	32
replace state =	"NH"	if statenumber == 	33
replace state =	"NJ"	if statenumber == 	34
replace state =	"NM"	if statenumber == 	35
replace state =	"NY"	if statenumber == 	36
replace state =	"NC"	if statenumber == 	37
replace state =	"ND"	if statenumber == 	38
replace state =	"OH"	if statenumber == 	39
replace state =	"OK"	if statenumber == 	40
replace state =	"OR"	if statenumber == 	41
replace state =	"PA"	if statenumber == 	42
replace state =	"RI"	if statenumber == 	44
replace state =	"SC"	if statenumber == 	45
replace state =	"SD"	if statenumber == 	46
replace state =	"TN"	if statenumber == 	47
replace state =	"TX"	if statenumber == 	48
replace state =	"UT"	if statenumber == 	49
replace state =	"VT"	if statenumber == 	50
replace state =	"VA"	if statenumber == 	51
replace state =	"WA"	if statenumber == 	53
replace state =   "WV"	if statenumber == 	54
replace state =	"WI"	if statenumber == 	55
replace state =	"WY"	if statenumber == 	56
drop statenumber
sort state
save ideo_cces08.dta, replace

** This set of commands creates a policy mood variable from the following variables: views on abortion (v3019),
** for/against federal funding of stem cell research (v3063), views on affirmative action (v3027), 
** views on environment vs. economy (v3022), and immigration (v3069). 

use cces06.dta, clear
gen state = v1002
drop if state == "DC"
gen abortion = v3019
replace abortion = . if v3019 >= 5
gen stemcell = .
replace stemcell = 2 if v3063 == 1
replace stemcell = 1 if v3063 == 2
gen affaction = .
replace affaction = 7 if v3027 ==1
replace affaction = 6 if v3027 ==2
replace affaction = 5 if v3027 ==3
replace affaction = 4 if v3027 ==4
replace affaction = 3 if v3027 ==5
replace affaction = 2 if v3027 ==6
replace affaction = 1 if v3027 ==7
gen environment = .
replace environment = 1 if v3022 == 5
replace environment = 2 if v3022 == 4
replace environment = 3 if v3022 == 3
replace environment = 4 if v3022 == 2
replace environment = 5 if v3022 == 1
gen immigration = .
replace immigration = 2 if v3069 == 1
replace immigration = 1 if v3069 == 2
factor abortion stemcell environment affaction immigration, pcf
predict factor1
collapse (mean) factor1 (semean) mood_se_cces06 = factor1, by (state)
rename factor1 mood_cces06
sort state
save mood_cces06.dta, replace

use cces08.dta, clear 
gen statenumber = v206
drop if statenumber == 11
gen abortion = cc310
replace abortion = . if cc310 >= 5
gen stemcell = .
replace stemcell = 2 if cc316c == 1
replace stemcell = 1 if cc316c == 2
gen affaction = .
replace affaction = 4 if cc313 ==1
replace affaction = 3 if cc313 ==2
replace affaction = 2 if cc313 ==3
replace affaction = 1 if cc313 ==4
gen environment = .
replace environment = 1 if cc311 == 5
replace environment = 2 if cc311 == 4
replace environment = 3 if cc311 == 3
replace environment = 4 if cc311 == 2
replace environment = 5 if cc311 == 1
gen ch = .
replace ch = 1 if cc316e == 2
replace ch = 2 if cc316e == 1
factor abortion stemcell environment affaction ch, pcf
predict factor1
collapse (mean) factor1 (semean) mood_se_cces08 = factor1, by (state)
rename factor1 mood_cces08
gen state = ""
replace state =	"AL"	if statenumber == 	1
replace state =	"AK"	if statenumber == 	2
replace state =	"AZ"	if statenumber == 	4
replace state =	"AR"	if statenumber == 	5
replace state =	"CA"	if statenumber == 	6
replace state =	"CO"	if statenumber == 	8
replace state =	"CT"	if statenumber == 	9
replace state =	"DE"	if statenumber == 	10
replace state =	"FL"	if statenumber == 	12
replace state =	"GA"	if statenumber == 	13
replace state =	"HI"	if statenumber == 	15
replace state =	"ID"	if statenumber == 	16
replace state =	"IL"	if statenumber == 	17
replace state =	"IN"	if statenumber == 	18
replace state =	"IA"	if statenumber == 	19
replace state =	"KS"	if statenumber == 	20
replace state =	"KY"	if statenumber == 	21
replace state =	"LA"	if statenumber == 	22
replace state =	"ME"	if statenumber == 	23
replace state =	"MD"	if statenumber == 	24
replace state =	"MA"	if statenumber == 	25
replace state =	"MI"	if statenumber == 	26
replace state =	"MN"	if statenumber == 	27
replace state =	"MS"	if statenumber == 	28
replace state =	"MO"	if statenumber == 	29
replace state =	"MT"	if statenumber == 	30
replace state =	"NE"	if statenumber == 	31
replace state =	"NV"	if statenumber == 	32
replace state =	"NH"	if statenumber == 	33
replace state =	"NJ"	if statenumber == 	34
replace state =	"NM"	if statenumber == 	35
replace state =	"NY"	if statenumber == 	36
replace state =	"NC"	if statenumber == 	37
replace state =	"ND"	if statenumber == 	38
replace state =	"OH"	if statenumber == 	39
replace state =	"OK"	if statenumber == 	40
replace state =	"OR"	if statenumber == 	41
replace state =	"PA"	if statenumber == 	42
replace state =	"RI"	if statenumber == 	44
replace state =	"SC"	if statenumber == 	45
replace state =	"SD"	if statenumber == 	46
replace state =	"TN"	if statenumber == 	47
replace state =	"TX"	if statenumber == 	48
replace state =	"UT"	if statenumber == 	49
replace state =	"VT"	if statenumber == 	50
replace state =	"VA"	if statenumber == 	51
replace state =	"WA"	if statenumber == 	53
replace state =   "WV"	if statenumber == 	54
replace state =	"WI"	if statenumber == 	55
replace state =	"WY"	if statenumber == 	56
drop statenumber
sort state
save mood_cces08.dta, replace


** This set of commands merges all CCES variables into one file.

use mood_cces06.dta, clear
merge state using pid_cces06.dta ideo_cces06.dta pid_cces08 ideo_cces08 mood_cces08, unique sort
drop _*
order state pid_cces06 pid_se_cces06 pid_cces08 pid_se_cces08 ideo_cces06 ideo_se_cces06 ideo_cces08 ideo_se_cces08 mood_cces06 mood_se_cces06 mood_cces08 mood_se_cces08   
sort state
save measures_cces0608.dta, replace

** Creating measures of state partisanship and ideology from the NAES 2000.

** This set of commands generates a new party identification variable so that Democrats are the high value,  
** Independents are in the middle, and Republicans are the low value.

use naes00.dta, clear
gen state = cst
drop if state == "DC"
gen pid_naes00 = .
replace pid_naes00 = 3 if cv01 == 2
replace pid_naes00 = 2 if cv01 == 3
replace pid_naes00 = 1 if cv01 == 1
collapse (mean) pid_naes00 (semean) pid_se_naes00 = pid_naes00, by (state)
sort state
save pid_naes00.dta, replace

** This set of commands generates a new three option ideology variable from the five option ideology variable
** with Liberals as the high value, Independents in the middle, and Republicans as the low value.

use naes00.dta, clear
gen state = cst
drop if state == "DC"
gen ideo_naes00 = .
replace ideo_naes00 = 1 if cv04 == 1
replace ideo_naes00 = 1 if cv04 == 2
replace ideo_naes00 = 2 if cv04 == 3
replace ideo_naes00 = 3 if cv04 == 4
replace ideo_naes00 = 3 if cv04 == 5
collapse (mean) ideo_naes00 (semean) ideo_se_naes00 = ideo_naes00, by (state)
sort state
save ideo_naes00.dta, replace

** This set of commands merges both NAES 2000 variables into one file.

use ideo_naes00.dta, clear
merge state using pid_naes00.dta, unique sort
drop _*
order state pid_naes00 pid_se_naes00 ideo_naes00 ideo_se_naes00
sort state
save measures_naes00.dta, replace

** Creating measures of state partisanship and ideology from the NAES 2004.

** This set of commands generates a new party identification variable so that Democrats are the high value,  
** Independents are in the middle, and Republicans are the low value.

use naes04.dta, clear
gen state = cst
drop if state == "DC"
gen pid_naes04 = .
replace pid_naes04 = 3 if cma01 == 2
replace pid_naes04 = 2 if cma01 == 3
replace pid_naes04 = 1 if cma01 == 1
collapse (mean) pid_naes04 (semean) pid_se_naes04 = pid_naes04, by (state)
sort state
save pid_naes04.dta, replace

** This set of commands generates a new three option ideology variable from the five option ideology variable
** with Liberals as the high value, Independents in the middle, and Republicans as the low value.

use naes04.dta, clear
gen state = cst
drop if state == "DC"
gen ideo_naes04 = .
replace ideo_naes04 = 1 if cma06 == 1
replace ideo_naes04 = 1 if cma06 == 2
replace ideo_naes04 = 2 if cma06 == 3
replace ideo_naes04 = 3 if cma06 == 4
replace ideo_naes04 = 3 if cma06 == 5
collapse (mean) ideo_naes04 (semean) ideo_se_naes04 = ideo_naes04, by (state)
sort state
save ideo_naes04.dta, replace

** This set of commands creates a policy mood variable from the following variables: favor abortion bans (cce01), favor spending on defense (ccd03), 
** favor restricting immigration (ccd82), Iraq War worth it(ccd21) 

use naes04.dta, clear
gen state = cst
drop if state == "DC"
gen abortion = .
replace abortion = 1 if cce01 == 1
replace abortion = 2 if cce01 == 2
replace abortion = 3 if cce01 == 5
replace abortion = 4 if cce01 == 3
replace abortion = 5 if cce01 == 4
gen defense = ccd03
replace defense = . if ccd03 >= 5
gen immigration = ccd82
replace immigration = . if ccd82 >= 5
gen iraq = .
replace iraq = 1 if ccd21 == 1
replace iraq = 2 if ccd21 == 2
factor abortion defense immigration iraq, pcf
predict factor1
collapse (mean) factor1 (semean) mood_se_naes04 = factor1, by (state)
rename factor1 mood_naes04
sort state
save mood_naes04.dta, replace

** This set of commands merges all three NAES 2004 variables into one file.

use mood_naes04.dta, clear
merge state using pid_naes04 ideo_naes04 mood_naes04, unique sort
drop _*
order state pid_naes04 pid_se_naes04 ideo_naes04 ideo_se_naes04 mood_naes04 mood_se_naes04
sort state
save measures_naes04.dta, replace

** This set of commands merges the CCES and NAES measures into one file.

use measures_naes00.dta, clear
merge state using measures_naes04 measures_cces0608, unique sort
drop _*
order state pid* ideo* mood*
sort state
save cces_naes.dta, replace

*************************************************************************************************************************************************************

** PART II
** Gathering EWM party identification and ideology measures, creating a 1999-2003 average weighted by frequency in each year.
** This set of commands is for party identification.

use ewm.dta, clear
keep if year >= 1999
drop if stateid == 9
gen republicans = (wtd_pty1/100) * wtd_kntpty
gen independents = (wtd_pty2/100) * wtd_kntpty
gen democrats = (wtd_pty3/100) * wtd_kntpty
gen rep_code = republicans * -100
gen dem_code = democrats * 100
gen state_mean = (rep_code + dem_code)/kntpty
collapse (mean) state_mean [fweight = kntpty], by (stateid)
rename state_mean pid_ewm
decode stateid, gen(state)
drop stateid
sort state
save pid_ewm.dta, replace

** This set of commands is for ideology.

use ewm.dta, clear
keep if year >= 1999
drop if stateid == 9
gen conservatives = (wtd_id3/100) * wtd_kntid
gen moderates = (wtd_id2/100) * wtd_kntid
gen liberals = (wtd_id1/100) * wtd_kntid
gen cons_code = conservatives * -100
gen lib_code = liberals * 100
gen state_mean = (cons_code + lib_code)/kntid
collapse (mean) state_mean [fweight = kntid], by (stateid)
rename state_mean ideo_ewm
decode stateid, gen(state)
drop stateid
sort state
save ideo_ewm.dta, replace

** Gathering BRFH citizen ideology measure.
** This set of commands is for the citizen ideology measure.

use brfh.dta, clear
capture drop state
capture gen state = "XX"
capture replace state = "AL" if statename == "Alabama"
capture replace state = "AK" if statename == "Alaska"
capture replace state = "AZ" if statename == "Arizona"
capture replace state = "AR" if statename == "Arkansas"
capture replace state = "CA" if statename == "California"
capture replace state = "CO" if statename == "Colorado"
capture replace state = "CT" if statename == "Connecticut"
capture replace state = "DE" if statename == "Delaware"
capture replace state = "DE" if statename == "Deleware"
capture replace state = "FL" if statename == "Florida"
capture replace state = "GA" if statename == "Georgia"
capture replace state = "HI" if statename == "Hawaii"
capture replace state = "ID" if statename == "Idaho"
capture replace state = "IL" if statename == "Illinois"
capture replace state = "IN" if statename == "Indiana"
capture replace state = "IA" if statename == "Iowa"
capture replace state = "KS" if statename == "Kansas"
capture replace state = "KY" if statename == "Kentucky"
capture replace state = "LA" if statename == "Louisiana"
capture replace state = "ME" if statename == "Maine"
capture replace state = "MD" if statename == "Maryland"
capture replace state = "MA" if statename == "Massachusetts"
capture replace state = "MI" if statename == "Michigan"
capture replace state = "MN" if statename == "Minnesota"
capture replace state = "MS" if statename == "Mississippi"
capture replace state = "MO" if statename == "Missouri"
capture replace state = "MT" if statename == "Montana"
capture replace state = "NE" if statename == "Nebraska"
capture replace state = "NV" if statename == "Nevada"
capture replace state = "NH" if statename == "New Hampshire"
capture replace state = "NJ" if statename == "New Jersey"
capture replace state = "NM" if statename == "New Mexico"
capture replace state = "NY" if statename == "New York"
capture replace state = "NC" if statename == "North Carolina"
capture replace state = "ND" if statename == "North Dakota"
capture replace state = "OH" if statename == "Ohio"
capture replace state = "OK" if statename == "Oklahoma"
capture replace state = "OR" if statename == "Oregon"
capture replace state = "PA" if statename == "Pennsylvania"
capture replace state = "RI" if statename == "Rhode Island"
capture replace state = "SC" if statename == "South Carolina"
capture replace state = "SD" if statename == "South Dakota"
capture replace state = "TN" if statename == "Tennessee"
capture replace state = "TX" if statename == "Texas"
capture replace state = "UT" if statename == "Utah"
capture replace state = "VT" if statename == "Vermont"
capture replace state = "VA" if statename == "Virginia"
capture replace state = "WA" if statename == "Washington"
capture replace state = "WV" if statename == "West Virginia"
capture replace state = "WI" if statename == "Wisconsin"
capture replace state = "WY" if statename == "Wyoming"
drop if state == "XX"
save brfh.dta, replace

use brfh.dta, clear
keep if year == 2000
sort state
rename citi6006 ideo_brfh00
keep state ideo_brfh00
save ideo_brfh00.dta, replace

use brfh.dta, clear
keep if year == 2004 
sort state
rename citi6006 ideo_brfh04
keep state ideo_brfh04
save ideo_brfh04.dta, replace

use brfh.dta, clear
keep if year == 2006 
sort state
rename citi6006 ideo_brfh06
keep state ideo_brfh06
save ideo_brfh06.dta, replace

merge state using ideo_brfh00.dta ideo_brfh04.dta
drop _*
order state ideo_brfh00 ideo_brfh04 ideo_brfh06
sort state
save ideo_brfh.dta, replace

*************************************************************************************************************************************************************

** PART III
** This set of commands merges the CCES/NAES file with the EWM and BRFH data.

use cces_naes.dta, clear
merge state using pid_ewm.dta ideo_ewm.dta ideo_brfh.dta
drop _*
sort state

label variable state "state postal code"
label variable pid_naes00 "mean state party ID 2000"
label variable pid_naes04 "mean state party ID 2004"
label variable pid_cces06 "mean state party ID 2006"
label variable pid_cces08 "mean state party ID 2008"
label variable pid_ewm "EWM party ID 1999-2003"
label variable ideo_naes00 "mean state ideology 2000"
label variable ideo_naes04 "mean state ideology 2004"
label variable ideo_cces06 "mean state ideology 2006"
label variable ideo_cces08 "mean state ideology 2008"
label variable ideo_ewm "EWM ideology 1999-2003"
label variable ideo_brfh00 "BRFH citizen ideology 2000"
label variable ideo_brfh04 "BRFH citizen ideology 2004"
label variable ideo_brfh06 "BRFH citizen ideology 2006"
label variable mood_naes04 "mean state policy mood 2004"
label variable mood_cces06 "mean state policy mood 2006"
label variable mood_cces08 "mean state policy mood 2008"
label variable pid_se_naes00 "standard error of pid_naes00"
label variable pid_se_naes04 "standard error of pid_naes04"
label variable pid_se_cces06 "standard error of pid_cces06"
label variable pid_se_cces08 "standard error of pid_cces08"
label variable ideo_se_naes00 "standard error of ideo_naes00"
label variable ideo_se_naes04 "standard error of ideo_naes04"
label variable ideo_se_cces06 "standard error of ideo_cces06"
label variable ideo_se_cces08 "standard error of ideo_cces08"
label variable mood_se_naes04 "standard error of mood_naes04"
label variable mood_se_cces06 "standard error of mood_cces06"
label variable mood_se_cces08 "standard error of mood_cces08"

*order state pid_naes00 pid_se_naes00 pid_naes04 pid_se_naes04 pid_cces06 pid_se_cces06 pid_cces08 pid_se_cces08 pid_ewm ideo_naes00 ideo_se_naes00 ideo_naes04 ideo_se_naes04 ideo_cces06 ideo_se_cces06 ideo_ewm ideo_brfh00 ideo_brfh04 ideo_brfh06 mood_naes04 mood_se_naes04 mood_cces06 mood_se_cces06 
order state pid* ideo* mood*
save stateopinion_sppq.dta, replace

*************************************************************************************************************************************************************
*************************************************************************************************************************************************************
