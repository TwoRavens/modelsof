
/******* BRFSS ********
clear
set more off

*Read in raw data

* 1991
use "1991 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa
destring iyear, replace
gen syear=1991
save "1991 BRFSS clean.dta", replace

* 1992
use "1992 BRFSS.dta"
keep _state iyear seatbelt sex _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa
destring iyear, replace
gen syear=1992
save "1992 BRFSS clean.dta", replace

* 1993
use "1993 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa 
destring iyear, replace
gen syear=1993
save "1993 BRFSS clean.dta", replace

* 1994
use "1994 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa 
destring iyear, replace
gen syear=1994
save "1994 BRFSS clean.dta", replace

* 1995
use "1995 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa 
destring iyear, replace
gen syear=1995
save "1995 BRFSS clean.dta", replace

* 1996 
use "1996 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa 
destring iyear, replace
gen syear=1996
save "1996 BRFSS clean.dta", replace

* 1997
use "1997 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa 
destring iyear, replace
gen syear=1997
save "1997 BRFSS clean.dta", replace

* 1998
use "1998 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa 
destring iyear, replace
gen syear=1998
save "1998 BRFSS clean.dta", replace

* 1999
use "1999 BRFSS.dta"
keep _state iyear sex _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa 
destring iyear, replace
gen syear=1999
save "1999 BRFSS clean.dta", replace

* 2000
use "2000 BRFSS.dta"
keep _state iyear sex _drnkmo nalcocc alcohol _finalwt drinkany drinkge5 drinkdri age orace hispanic employ drinkdri educa 
destring iyear, replace
gen syear=2000
save "2000 BRFSS clean.dta", replace

* 2001
use "2001 BRFSS.dta"
keep _state iyear sex _drnkmo alcdays avedrnk _finalwt drnkany2 drnk2ge5 age hispanc2 employ race2 _prace educa 
destring iyear, replace
gen syear=2001
save "2001 BRFSS clean.dta", replace

* 2002
use "2002 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo* alcday3 avedrnk _finalwt drnkany3 drnk2ge5 age hispanc2 employ race2 _prace drinkdri educa
destring iyear, replace
gen syear=2002
save "2002 BRFSS clean.dta", replace

* 2003
use "2003 BRFSS.dta"
keep _state iyear sex _drnkmo* alcday3 avedrnk _finalwt drnkany3 drnk2ge5 age hispanc2 employ race2 _prace educa
destring iyear, replace
gen syear=2003
save "2003 BRFSS clean.dta", replace

* 2004
use "2004 BRFSS.dta"
keep _state iyear sex _drnkmo* alcday3 avedrnk _finalwt drnkany3 drnk2ge5 age hispanc2 employ race2 _prace drinkdri educa
destring iyear, replace
gen syear=2004
save "2004 BRFSS clean.dta", replace

* 2005
use "2005 BRFSS.dta"
keep _state iyear sex _drnkmo* alcday4 avedrnk2 _finalwt drnkany4 drnk2ge5 age hispanc2 employ race2 _prace educa 
destring iyear, replace
gen syear=2005
save "2005 BRFSS clean.dta", replace

* 2006
use "2006 BRFSS.dta"
keep _state iyear sex seatbelt alcday4 avedrnk2 _drnkmo* _finalwt drnkany4 drnk3ge5 age hispanc2 employ race2 _prace drinkdri educa
destring iyear, replace
gen syear=2006
save "2006 BRFSS clean.dta", replace

* 2007
use "2007 BRFSS.dta"
keep _state iyear sex _drnkmo* alcday4 avedrnk2 _finalwt drnkany4 drnk3ge5 age hispanc2 employ race2 _prace educa
destring iyear, replace
gen syear=2007
save "2007 BRFSS clean.dta", replace

* 2008
use "2008 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo* alcday4 avedrnk2 _finalwt drnkany4 drnk3ge5 age hispanc2 employ race2 _prace drnkdri2 educa
destring iyear, replace
gen syear=2008
save "2008 BRFSS clean.dta", replace

* 2009
use "2009 BRFSS.dta"
keep _state iyear sex _drnkmo* alcday4 avedrnk2 _finalwt drnkany4 drnk3ge5 age hispanc2 employ race2 _prace educa
destring iyear, replace
gen syear=2009
save "2009 BRFSS clean.dta", replace

* 2010
use "2010 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo* alcday4 avedrnk2 _finalwt drnkany4 drnk3ge5 age hispanc2 employ race2 _prace drnkdri2 educa
destring iyear, replace
gen syear=2010
save "2010 BRFSS clean.dta", replace

* 2011
use "2011 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo* alcday5 avedrnk2 _llcpwt drnkany5 drnk3ge5 age hispanc2 employ race2 _prace educa
destring iyear, replace
gen syear=2011
save "2011 BRFSS clean.dta", replace

* 2012
use "2012 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo* alcday5 avedrnk2 _llcpwt drnkany5 drnk3ge5 age hispanc2 employ race2 _prace educa drnkdri2
destring iyear, replace
gen syear=2012
save "2012 BRFSS clean.dta", replace

* 2013
use "2013 BRFSS.dta"
keep _state iyear sex seatbelt _drnkmo* alcday5 avedrnk2 _llcpwt drnkany5 drnk3ge5 _age80 _hispanc employ1 _race educa
destring iyear, replace
gen syear=2013
save "2013 BRFSS clean.dta", replace


* Append data 1991-2013
use using "1991 BRFSS clean.dta", clear
append using "1992 BRFSS clean.dta"
append using "1993 BRFSS clean.dta"
append using "1994 BRFSS clean.dta"
append using "1995 BRFSS clean.dta"
append using "1996 BRFSS clean.dta"
append using "1997 BRFSS clean.dta"
append using "1998 BRFSS clean.dta"
append using "1999 BRFSS clean.dta"
append using "2000 BRFSS clean.dta"
append using "2001 BRFSS clean.dta"
append using "2002 BRFSS clean.dta"
append using "2003 BRFSS clean.dta"
append using "2004 BRFSS clean.dta"
append using "2005 BRFSS clean.dta"
append using "2006 BRFSS clean.dta"
append using "2007 BRFSS clean.dta"
append using "2008 BRFSS clean.dta"
append using "2009 BRFSS clean.dta"
append using "2010 BRFSS clean.dta"
append using "2011 BRFSS clean.dta"
append using "2012 BRFSS clean.dta"
append using "2013 BRFSS clean.dta"


* Years are coded in both 2-digit and 4-digit. Will change them all to 4 digit 
replace iyear=1991 if iyear==91
replace iyear=1992 if iyear==92
replace iyear=1993 if iyear==93
replace iyear=1994 if iyear==94
replace iyear=1995 if iyear==95
replace iyear=1996 if iyear==96
replace iyear=1997 if iyear==97
replace iyear=1998 if iyear==98

drop if iyear==2014

label var syear "Survey Year"

rename iyear year
rename _state state


*get rid of Geststate that aren't states (looking at you Puerto Rico and Guam)
drop if inrange(state,66,78)


* Adjust weighting variable to make it consistent (name changes in 2011)
replace _finalwt=_llcpwt if _finalwt==.
drop _llcpwt



* GENDER
gen male=1 if sex==1
replace male=0 if sex==2
label var male "Gender: male=1, female=0"

* Age
replace age=_age80 if year==2013
drop if age==7
drop if age==9
gen age_sq=age^2
label var age_sq "Age Squared"


keep if inrange(age,18,20) //sample restricted to those ages 18-20


* RACE
/*
_race
1 White only, non-Hispanic
2 Black only, non-Hispanic
3 American Indian or Alaskan Native only, Non-Hispanic
4 Asian only, non-Hispanic
5 Native Hawaiian or other Pacific Islander only, Non-Hispanic
6 Other race only, non-Hispanic
7 Multiracial, non-Hispanic
8 Hispanic
9 DonӴ know/Not sure/Refused
*/
gen race=1 if _race==1
replace race=2 if _race==2
replace race=4 if inrange(_race,3,7)
replace race=3 if _race==8
/*
orace
1 White
2 Black 
3 Asian, Pacific Islander
4 American Indian, Alaska Native
5 Other 
7 Don't know/Not sure 
9 Refused
*/
replace race=1 if orace==1 & (hispanic==2 )
replace race=2 if orace==2 & (hispanic==2 )
replace race=4 if inrange(orace,3,6) & (hispanic==2)
replace race=3 if hispanic==1 

/*
_prace
1 White
2 Black or African American
3 Asian
4 Native Hawaiian or other Pacific Islander
5 American Indian or Alaskan Native
6 Other race
7 No preferred race
8 Multiracial but preferred race not asked
77 DonӴ know/Not sure
99 Refused
*/
replace race=1 if _prace==1 & (hispanc2==2)
replace race=2 if _prace==2 & (hispanc2==2)
replace race=4 if inrange(_prace,3,8) & (hispanc2==2)
replace race=3 if hispanc2==1
label var race "Race: White Black Hispanic Other"


* EDUCATION

/*
** Normalize the EDUCATION variable because it changes over time (90-93 is 
consistent and 94-2009 is consistent)

The coding will be:
1: 8th grade or less
2: Some highschool
3: Highschool graduate
4: Some college or technical school
5: College graduate, techincal school graduate, or advanced degree
*/

gen educ=1 if inrange(educa,1,2) & inrange(syear,1991,1992)
replace educ=2 if educa==3  & inrange(syear,1991,1992)
replace educ=3 if inrange(educa,4,6)  & inrange(syear,1991,1992)
replace educ=4 if inrange(educa,7,8)  & inrange(syear,1991,1992)


replace educ=1 if inrange(educa,1,3) & inrange(syear,1993,2013)
replace educ=2 if educa==4  & inrange(syear,1993,2013)
replace educ=3 if educa==5  & inrange(syear,1993,2013)
replace educ=4 if educa==6  & inrange(syear,1993,2013)

lab var educ "Education level"
lab define educ 1 "LTHS" 2 "HS" 3 "Some college" 4 "College or Advanced"


* State Linear Time Trend (yearly)
generate trend=.
replace trend=1 if year==1991
replace trend=2 if year==1992
replace trend=3 if year==1993
replace trend=4 if year==1994
replace trend=5 if year==1995
replace trend=6 if year==1996
replace trend=7 if year==1997
replace trend=8 if year==1998
replace trend=9 if year==1999
replace trend=10 if year==2000
replace trend=11 if year==2001
replace trend=12 if year==2002
replace trend=13 if year==2003
replace trend=14 if year==2004
replace trend=15 if year==2005
replace trend=16 if year==2006
replace trend=17 if year==2007
replace trend=18 if year==2008
replace trend=19 if year==2009
replace trend=20 if year==2010
replace trend=21 if year==2011
replace trend=22 if year==2012
replace trend=23 if year==2013
label var trend "Linear Time Trend"


* EMPLOYMENT
* (employment = individual is employed for wages and not self employed)
gen employed=1 if employ==1 | employ1==1
replace employed=0 if inrange(syear,1991,1992) & inrange(employ,2,7)
replace employed=0 if inrange(syear,1993,2012) & inrange(employ,2,8)
replace employed=0 if inrange(employ1,2,8)
label var employed "Employment: =1 if employed for wages, =0 if unemployed"



* DRINKING
* Generate "anyalcohol": had any drinks in last 30 days
gen anyalcohol=.
replace anyalcohol=1 if drinkany==1
replace anyalcohol=0 if drinkany==2
replace anyalcohol=0 if drnkany2==2
replace anyalcohol=1 if drnkany2==1
replace anyalcohol=0 if drnkany3==2
replace anyalcohol=0 if drnkany4==2
replace anyalcohol=0 if drnkany5==2
replace anyalcohol=1 if drnkany3==1
replace anyalcohol=1 if drnkany4==1
replace anyalcohol=1 if drnkany5==1
label var anyalcohol "Respondent has drank at least one drink in last 30 days"

* Generate "bingedrinks_days": binge drink frequency in last 30 days
gen bingedrinks_days=.
replace bingedrinks_days=drinkge5 if inrange(drinkge5,1,76)
replace bingedrinks_days=0 if anyalcohol==0 & bingedrinks_days==.
replace bingedrinks_days=0 if drinkge5==88
replace bingedrinks_days=drnk2ge5 if inrange(drnk2ge5,1,76)
replace bingedrinks_days=0 if drnk2ge5==88
replace bingedrinks_days=drnk3ge5 if inrange(drnk3ge5,1,76)
replace bingedrinks_days=0 if drnk3ge5==88
label var bingedrinks_days "Respondent's binge drink frequency in the last month"


* Generate "bingedrinks": had 5 or more drinks on a single occasion in the last month
gen bingedrinks=.
replace bingedrinks=1 if inrange(drinkge5,1,76)
replace bingedrinks=0 if anyalcohol==0 & bingedrinks==.
replace bingedrinks=0 if drinkge5==88
replace bingedrinks=1 if inrange(drnk2ge5,1,76)
replace bingedrinks=0 if drnk2ge5==88
replace bingedrinks=1 if inrange(drnk3ge5,1,76)
replace bingedrinks=0 if drnk3ge5==88
label var bingedrinks "Respondent has had more than 5 drinks at least one occasion in the last month"

* Generate "freqbinge": Frequent binge drinking - 5 or more drinks on 3 or more occasion in the last month
gen freqbinge=.
replace freqbinge=0 if anyalcohol==0
replace freqbinge=0 if drinkge5==88
replace freqbinge=1 if inrange(drinkge5,3,76)
replace freqbinge=0 if drnk2ge5==88
replace freqbinge=1 if inrange(drnk2ge5,3,76)
replace freqbinge=0 if drnk3ge5==88
replace freqbinge=1 if inrange(drnk3ge5,3,76)
replace freqbinge=0 if inrange(drinkge5,1,2)
replace freqbinge=0 if inrange(drnk2ge5,1,2)
replace freqbinge=0 if inrange(drnk3ge5,1,2)
label var freqbinge "Frequent binge drinking: >=5 per month having >=5 drinkgs per occcasion"

* Generate "drunkdrive": Number of times individual has driven after having too much to drink in the last month. Note, coded as zero if they have reported consuming zero drinks in the last month
gen drunkdrive=0 if anyalcohol==0 & (inrange(syear,1991,2000) | syear==2002 | syear==2004 | syear==2006 | syear==2008 | syear==2010)
replace drunkdrive=0 if (drinkdri==88 | drnkdri2==88)
replace drunkdrive=1 if inrange(drinkdri,1,76)
replace drunkdrive=1 if inrange(drnkdri2,1,76)
label var drunkdrive "Driven drunk at least once in the last month"


* Generate "drunkdrive_fre": Number of times individual has driven after having too much to drink in the last month. Note, coded as zero if they have reported consuming zero drinks in the last month
gen drunkdrive_fre=0 if anyalcohol==0 & (inrange(syear,1991,2000) | syear==2002 | syear==2004 | syear==2006 | syear==2008 | syear==2010)
replace drunkdrive_fre=0 if (drinkdri==88 | drnkdri2==88)
replace drunkdrive_fre=drinkdri if inrange(drinkdri,1,76)
replace drunkdrive_fre=drnkdri2 if inrange(drnkdri2,1,76)
label var drunkdrive_fre "Driven drunk frequency in the last month"

****Calculated drinks/month

gen drinkmo=_drnkmo if inrange(_drnkmo,0,2280)
replace drinkmo=0 if _drnkmo==8888
replace drinkmo=_drnkmo2 if inrange(_drnkmo2,0,2280)
replace drinkmo=_drnkmo3 if inrange(_drnkmo3,0,2280)
replace drinkmo=_drnkmo4 if inrange(_drnkmo4,0,2280)
label var drinkmo "Unconditional # of drinks (calculated)"


* Slim down the data set to just what we need for means table and regressions
drop if year<1991
drop if year>2013
merge m:1 state year using  "controls19912013.dta"
drop if _merge==2
drop _merge

merge m:1 year state using "fars.dta", keepus(nonDUI_1620)
ge lnorate1620 = ln(nonDUI_1620/pop1620)
replace lnorate1620 = ln(0.1/pop1620) if nonDUI_1620==0
drop if _merge==2
drop _merge

*log of nominal Min wage
gen lnmw=ln( mw2)

save "BRFSS Clean Coded Dropped.dta", replace
*/

