/****** CPS data *******

clear
set more off
*set the appropriate path here:

*CPS Outgoing Rotation Groups 1991-2013: raw data
use  "morg91.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr89 gradeat gradecp marital
save org91, replace
use  "morg92.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr89 grade92 marital
save org92, replace
use  "morg93.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr89 grade92 marital
save org93, replace
use  "morg94.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org94, replace
use  "morg95.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org95, replace
use  "morg96.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org96, replace
use  "morg97.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org97, replace
use  "morg98.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org98, replace
use  "morg99.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org99, replace
use  "morg00.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org00, replace
use  "morg01.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org01, replace
use  "morg02.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org02, replace
use  "morg03.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org03, replace
use  "morg04.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org04, replace
use  "morg05.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org05, replace
use  "morg06.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org06, replace
use  "morg07.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org07, replace
use  "morg08.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org08, replace
use  "morg09.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org09, replace
use  "morg10.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse hourslw lfsr94 grade92 marital
save org10, replace
use  "morg11.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse lfsr94 grade92 marital
save org11, replace
use  "morg12.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse lfsr94 grade92 marital
save org12, replace
use  "morg13.dta" , clear
keep year stfips  weight earnwt sex race  ethnic state age paidhre earnhre earnwke uhourse lfsr94 grade92 marital
save org13, replace

use org91, clear
append using org92
append using org93
append using org94
append using org95
append using org96
append using org97
append using org98
append using org99
append using org00
append using org01
append using org02
append using org03
append using org04
append using org05
append using org06
append using org07
append using org08
append using org09
append using org10
append using org11
append using org12
append using org13

*the race/ethnic, labor force status variables are generated using codes from CERP uniform data extracts programs
/* Race and ethnicity */

gen byte wbho=1 if race==1 & 1989<= year  &  year <=2002
replace wbho=2 if race==2  & 1989<= year  &  year <=2002
replace wbho=4 if 3<=race & race<=5  & 1989<= year  &  year <=2002
replace wbho=3 if 1<=ethnic & ethnic<=7  & 1989<= year  &  year <=2002
replace wbho=1 if race==1 & 2003<= year  &  year <=2013  /* white only */
replace wbho=2 if race==2 & 2003<= year  &  year <=2013  /* black only */
replace wbho=2 if (race==6 /* black-white */ | race==10  /* black-AI */ | race==11 /* black-asian */ | race==12 /* black-HP */ | race==15 /* W-B-AI */ | race==16 /* W-B-A */ | race==19 /* W-B-AI-A */ )& 2003<= year  &  year <=2013
replace wbho=4 if (race==4 | race==5 /* asian & hawaiian/pacific islander */ | race==8 /* white-asian */ | race==9 /* white-HP */ | race==13 /* AI-Asian */ | race==14 /* asian-HP */ | race==17 /* W-AI-A */ | race==18 )/* W-A-HP */  & 2003<= year  &  year <=2013
replace wbho=4 if (race==3 /* AI only */ | race==7 /* white-AI */ | race==20 /* 2 or 3 races */ | race==21 /* 4 or 5 races */ ) & 2003<= year  &  year <=2013
replace wbho=3 if 1<=ethnic & ethnic<=7 /* hispanic */  & 2003<= year  &  year <=2013
lab var wbho "Race"
lab define wbho 1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
lab var wbho wbho
notes wbho: Racial and ethnic categories are mutually exclusive
/* Labor-market status */
gen byte lfstat=1 if (lfsr89==1 | lfsr89==2)  & 1990<= year  &  year <=1993
replace lfstat=2 if 3<=lfsr89 & lfsr89<=4  & 1990<= year  &  year <=1993
replace lfstat=3 if 5<=lfsr89 & lfsr89<=7  & 1990<= year  &  year <=1993

replace lfstat=1 if (lfsr94==1 | lfsr94==2)  & 1994<= year &  year <=2013
replace lfstat=2 if 3<=lfsr94 & lfsr94<=4  & 1994<= year &  year <=2013
replace lfstat=3 if 5<=lfsr94 & lfsr94<=7  & 1994<= year &  year <=2013
lab var lfstat "Labor-force status"
lab def lfstat 1 "Employed" 2 "Unemployed" 3 "NILF"
*gen hourly wage var
gen w_no_no=earnhre/100 if paidhre==1
replace w_no_no= earnwke/uhourse if paidhre==2
lab var w_no_no "Wage, tc 500, bt 2.13"
replace w_no_no=2.13 if w_no_no>0 & w_no_no<2.13
replace w_no_no=500 if w_no_no>500 & w_no_no<2900

*merge controls
ren state statecensus
ren stfips state
merge m:1 state year using "controls19912013.dta"
drop _merge

merge m:1 year state using "fars.dta", keepus(nonDUI_1620)
ge lnorate1620 = ln(nonDUI_1620/pop1620)
replace lnorate1620 = ln(0.1/pop1620) if nonDUI_1620==0
drop if _merge==2
drop _merge


*log of nominal Min wage
gen lnmw=ln( mw2)

*gen age squared
gen age_sq=age*age
label var age_sq "Age squared"
*gen male
gen male=1 if sex==1
replace male=0 if sex==2
label var male "Male"

*gen marital status
gen married=1 if inrange(marital,1,3)
replace married=0 if inrange(marital,4,7)

gen widowed=1 if marital==4
replace widowed=0 if inlist(marital,1,2,3,5,6,7)

gen divorced=1 if marital==5|marital==6
replace divorced=0 if inlist(marital,1,2,3,4,7)

gen single=1 if marital==7
replace single=0 if inrange(marital,1,6)

*educ categories
gen byte educ=1 if 1<=gradeat & gradeat<=11 & (1979<=year & year<=1991)
replace educ=1 if gradeat==12 & gradecp==2 & (1979<=year & year<=1991) /* didn't complete 12th */
replace educ=2 if gradeat==12 & gradecp==1 & (1979<=year & year<=1991) /* completed 12th */
replace educ=3 if 13<=gradeat & gradeat<=15 & (1979<=year & year<=1991)
replace educ=3 if gradeat==16 & gradecp==2 & (1979<=year & year<=1991) /* didn't complete college */
replace educ=4 if gradeat==16 & gradecp==1 & (1979<=year & year<=1991) /* completed college */
replace educ=4 if gradeat==17 & (1979<=year & year<=1991) /* "completed 4 or 5 years college" */
replace educ=4 if 18<=gradeat & gradeat~=. & (1979<=year & year<=1991)

replace educ=1 if 31<=grade92 & grade92<=37 & 1992<=year
replace educ=2 if 38<=grade92 & grade92<=39 & 1992<=year /* includes "no diploma" */
replace educ=3 if 40<=grade92 & grade92<=42 & 1992<=year
replace educ=4 if grade92==43 & 1992<=year
replace educ=4 if 44<=grade92 & grade92<=46 & 1992<=year

lab var educ "Education level"
lab define educ 1 "LTHS" 2 "HS" 3 "Some college" 4 "College or Advanced"

*gen hourly wage, conditional on employment
gen cwage=log(w_no_no) if w_no_no>0&w_no_no<2900
label var cwage "Ln(Hourly Wage|Employment)"
*gen employment
gen empl=1 if lfstat==1
replace empl=0 if inrange(lfstat,2,3)
label var empl "Employment"

*gen usual weekly hours (unemployed and NILF individuals are assigned 0 hours)
gen uhours= uhourse
replace uhours=0 if missing(uhourse)&inrange(lfstat,2,3)
label var uhours "Usual Weekly Hours"
*gen usual hours, conditional on employment
gen cuhours=uhours if uhours>0&uhours<=99
label var cuhours "Usual Hours|Employment"

*gen usual weekly earnings
gen wkearn=earnwke
replace wkearn=0 if missing(earnwke)&inrange(lfstat,2,3)
label var wkearn "Usual Weekly Earnings"
*gen usual weekly earnings, conditional employment
gen cwkearn=earnwke if earnwke>0&earnwke<=2884.61
label var cwkearn "Usual Weekly Earnings|Employment"


*gen linear time trend
* State Linear Time Trend (yearly)
generate t=.
replace t=1 if year==1991
replace t=2 if year==1992
replace t=3 if year==1993
replace t=4 if year==1994
replace t=5 if year==1995
replace t=6 if year==1996
replace t=7 if year==1997
replace t=8 if year==1998
replace t=9 if year==1999
replace t=10 if year==2000
replace t=11 if year==2001
replace t=12 if year==2002
replace t=13 if year==2003
replace t=14 if year==2004
replace t=15 if year==2005
replace t=16 if year==2006
replace t=17 if year==2007
replace t=18 if year==2008
replace t=19 if year==2009
replace t=20 if year==2010
replace t=21 if year==2011
replace t=22 if year==2012
replace t=23 if year==2013
label var t "Linear Time Trend"

keep if inrange(age,16,20)

compress

gen wkearn_2013=wkearn*(229.324/cpi)
gen w_no_no_2013=w_no_no*(229.324/cpi)

*indicators for sample restriction
gen earnings_ind=0 if inrange(empl,0,1)
replace earnings_ind=1 if inrange(cuhours,0.0001,100) & inrange(cwage,0.0001,10000) & inrange(cwkearn,0.0001,10000)
gen empl_ind=1 if inrange(wkearn,0,10000) & inrange(uhours,0,100)


save "mw-drive-controls-org9113-clean", replace
*/
