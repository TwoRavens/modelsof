* Study 1: Bill counts from Lexis-Nexis


*************************
* import and clean up data
*************************

clear

*set your own working directory
cd “C:\ ”

import excel "study1.xlsx", sheet("Sheet1") firstrow

encode state, gen(stateid)
gen intros2 = intros/100

*************************
* Figure 1: bivariate scatter plot
*************************

graph set window fontface "Times New Roman"
gen yeartext = " '07" if year==2007
replace yeartext = " '09" if year==2009
replace yeartext = " '11" if year==2011
gen stateyear = abb + yeartext

graph twoway (lfitci billcount pctleg) (scatter billcount pctleg, mcolor(none) mlabel(stateyear) mlabsize(small)), graphregion(color(white) lcolor(white)) ylabel( , nogrid) legend(off) ytitle(Insurance Bills and Amendments, margin (medium) size (large)) xtitle(% Legislators with Insurance Experience, margin(medium) size(large)) 


*************************
* Table 1: Negative binomial results
*************************

nbreg billcount pctleg
estat ic
* predicted count described in text is difference of these two margins
margins, at(pctleg = 0)
margins, at(pctleg = 5) 

nbreg billcount pctleg i.year, exposure(intros2) vce(cluster stateid)
estat ic
* predicted count described in text is difference of these two margins

margins, at(pctleg = 0)
margins, at(pctleg = 5) 

nbreg billcount pctleg pctpop demcontrol lobby bowenprof i.year, exposure(intros2) vce(cluster stateid)
estat ic
* predicted count described in text is difference of these two margins
margins, at(pctleg = 0)
margins, at(pctleg = 5) 

*average number of bills/amendments considered by state legislatures mentioned in text
mean(billcount)

*****
* Figure 2
*****

*note: commands below give margins plotted in figure. Graphics created in “Figure 2.xlsx” file. 

nbreg billcount pctleg
margins, at(pctleg = (0(1)5)) 

nbreg billcount pctleg i.year, exposure(intros2) vce(cluster stateid)
margins, at(pctleg = (0(1)5)) 

nbreg billcount pctleg pctpop demcontrol lobby bowenprof i.year, exposure(intros2) vce(cluster stateid)
margins, at(pctleg = (0(1)5)) 


*************************
* Table A2: Negative binomial models for 2007 only with NCSL
*************************

merge 1:1 abb year using "50state_NCSL.dta"
gen intros3 = intros/100
gen newpct = pctleg
replace newpct = ncsl_pctleg if newpct==.
gen newdem=demcontrol
replace newdem=leg_cont if newdem==.
encode state, gen(stateid2)

*model 3 from table 1
nbreg billcount pctleg pctpop demcontrol lobby bowenprof i.year, exposure(intros2) vce(cluster stateid)
estat ic

* model 3 from table 1 using NCSL’s data on all 50 states 
nbreg billcount ncsl_pctleg pctpop newdem lobby legprof if abb!="NE", exposure(intros3) vce(cluster stateid2)
estat ic

*************************
* Table A3: replicating table 1 using alternatives to Negative Binomial Regression
*************************

*model 3 from table 1
nbreg billcount pctleg pctpop demcontrol lobby bowenprof i.year, exposure(intros2) vce(cluster stateid)
estat ic

* OLS version
*note: “intros2” variable is denoted “Control” in tablecolumn
regress billcount pctleg i.year intros2 pctpop demcontrol lobby bowenprof, vce(cluster stateid)

* poisson version
poisson billcount pctleg pctpop demcontrol lobby bowenprof i.year, exposure(intros2) vce(cluster stateid)
estat ic

* dropping potential outliers identified by R3
gen outliers = 0
replace outliers = 1 if state=="California" & year==2007
replace outliers = 1 if state=="New York" & (year==2007 | year==2009)

nbreg billcount pctleg pctpop demcontrol lobby bowenprof i.year if outliers!=1, exposure(intros2) vce(cluster stateid)
estat ic



*************************
* Table A4: replicating table 1 including lagged DV
*************************
nbreg billcount pctleg lagbillcount i.year, exposure(intros2) vce(cluster stateid)
estat ic

nbreg billcount pctleg pctpop demcontrol lobby bowenprof lagbillcount i.year, exposure(intros2) vce(cluster stateid)
estat ic


*************************
* Table A5: year-by-year replication of bivariate model
*************************
nbreg billcount pctleg if year==2007 
estat ic

nbreg billcount pctleg if year==2009
estat ic

nbreg billcount pctleg if year==2011 
estat ic





* Study 2: Stata – Percent of Bills Sponsored by Insurance Professionals

*************************
* Table 2
*************************

use "allbills.dta", clear
gen insurer_exclusivecategories = 0
replace insurer_exclusivecategories = 4 if commmember_insurer==1
replace insurer_exclusivecategories = 3 if commchair_insurer==1
replace insurer_exclusivecategories = 2 if cospon_insurer==1
replace insurer_exclusivecategories = 1 if primspon_insurer==1

tab insurer_exclusivecategories

use "pooled_data.dta", clear
gen CHwhite = 0
replace CHwhite = 1 if race=="White" 
replace CHwhite = 1 if race=="white" 
replace CHwhite = 1 if race=="white " 

egen terms = rowtotal(senate1993 senate1994 senate1995 senate1996 senate1997 senate1998 senate1999 senate2000 senate2001 senate2002 senate2003 senate2004 senate2005 senate2006 senate2007 senate2008 senate2009 senate2010 house1993 house1994 house1995 house1996 house1997 house1998 house1999 house2000 house2001 house2002 house2003 house2004 house2005 house2006 house2007 house2008 house2009 house2010)

tab CHINSURER if senate2011==1 | senate2012==1 | house2011==1 | house2012==1
tab CHINSURER if (senate2011==1 | senate2012==1 | house2011==1 | house2012==1) & party=="R"
tab CHINSURER if (senate2011==1 | senate2012==1 | house2011==1 | house2012==1) & CHwhite==1
tab CHINSURER if (senate2011==1 | senate2012==1 | house2011==1 | house2012==1) & (gender=="Male" | gender=="male" | gender=="male ") 
tab CHINSURER if (senate2011==1 | senate2012==1 | house2011==1 | house2012==1) & terms>=10



* Study 3: Stata – Bill Classification Cross Tab


*************************
* Table 3: cross-tabs of insurance professionals by bill direction
*************************

import excel "LASSO_output.xlsx", sheet("Sheet1") firstrow clear
merge 1:1 docid using "allbills.dta"

encode(predictedclass), gen(pred)

tab pred involved_insurer, col 
tab pred involved_insurer if pred!=3, col 
ttest pred if pred!=3, by(involved)

* row totals
tab pred involved_insurer if pred!=3, row 


*************************
* Table A6: direction of introduced bills by sponsors’ professional backgrounds in human coded data
*************************

gen codedclass = class
tab codedclass involved_insurer if codedclass!=2, col
ttest codedclass if codedclass!=2, by(involved_insurer )


tab codedclass involved_insurer , col all exact

*************************
* Table 4: percent bills introduced by insurance professionals
*************************

drop _merge
merge 1:1 docid using "study3_regression.dta", generate(_merge2)

keep if _merge == 3

gen pro = .
replace pro = 0 if predictedclass == "0"
replace pro = 1 if predictedclass == "1"

encode(state), gen(stateno)
gen inv = involved_insurer
gen gop = .
replace gop = 1 if party == "R"
replace gop = 0 if party == "D" | party == "I"
gen pctunin = pctnohealthinsurance
gen pci = percapitaincome/10000
gen termlimit = 0
replace termlimit = 1 if state == "az" | state == "ca" | state == "co" | state == "fl" | state == "mi" | state == "ne"
gen pctins = pctemployedfinanceinsurance
gen female = .
replace female = 1 if gender == "Female" | gender == "female"
replace female = 0 if gender == "male" | gender == "Male" | gender == "male " | gender == "male"
gen white = .
replace white = 1 if race == "White" | race == "white" | race == "white "
replace white = 0 if race == "Black" | race == "black" | race == "black " | race == "Hispanic" | race == "Latino" | race == "hispanic" | race == "latino" | race == "asian" | race == "native"
destring tenure, gen(tenure2011)


logit pro i.inv
estat ic
margins, at(inv==0)
margins, at(inv==1)
logit pro i.inv i.gop pci pctins pctunin female white tenure2011 
estat ic
margins, at(inv==0)
margins, at(inv==1)
logit pro i.inv##i.gop pci pctins pctunin female white tenure2011 
estat ic
