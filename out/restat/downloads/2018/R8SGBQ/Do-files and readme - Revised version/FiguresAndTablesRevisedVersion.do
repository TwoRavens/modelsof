********************************************************************************

********************************************************************************
**THIS DO-FILE CREATES FIGURES AND TABLES BASED ON THE FIRM PANEL DATASET
**Small Firm Death in Developing Countries - Revised Version (Re-submitted to ReSTat on March 23, 2018)
**March 23, 2018
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note: Change the directory to the folder “Do-files and readme” on your computer before running this do-file.

********************************************************************************

********************************************************************************

clear all
*TO DO: change directory 
/*EXAMPLE:
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Do-files and readme - Revised version"
*/

set more off


********************************************************************************
**FIGURES

********************************************************************************
**Figure 1. Firm death rates over different time horizons

use "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_RH.dta", clear

twoway	(rcap lowb_deathrate uppb_deathrate years  if surveyname=="BENINFORM", lcolor(gs5)) || (scatter deathrate years if survey=="BENINFORM", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="EGYPTMACROINS", lcolor(gs5)) || (scatter deathrate years if survey=="EGYPTMACROINS", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="GHANAFLYP", lcolor(gs5)) || (scatter deathrate years if survey=="GHANAFLYP", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="IFLS", lcolor(gs5)) || (scatter deathrate years if survey=="IFLS", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="KENYAGETAHEAD", lcolor(gs5)) || (scatter deathrate years if survey=="KENYAGETAHEAD", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="MALAWIFORM", lcolor(gs5)) || (scatter deathrate years if survey=="MALAWIFORM", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="MXFLS", lcolor(gs5) ) || (scatter deathrate years if survey=="MXFLS", mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="NGLSMS-ISA", lcolor(gs5)) || (scatter deathrate years if survey=="NGLSMS-ISA", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="NGYOUWIN", lcolor(gs5)) || (scatter deathrate years if survey=="NGYOUWIN", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="SLKFEMBUSTRAINING", lcolor(gs5)) || (scatter deathrate years if survey=="SLKFEMBUSTRAINING", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="SLKINFORMALITY", lcolor(gs5)) || (scatter deathrate years if survey=="SLKINFORMALITY", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="SLLSE", lcolor(gs5)) || (scatter deathrate years if survey=="SLLSE", mlabel(countrylabel) mcolor(gs5) mlabcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="SLMS", lcolor(gs5)) || (scatter deathrate years if survey=="SLMS", mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="TOGOINF",lcolor(gs5)) || (scatter deathrate years if survey=="TOGOINF", mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="TTHAI", lcolor(gs5)) || (scatter deathrate years if survey=="TTHAI", mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="UGWINGS", lcolor(gs5)) || (scatter deathrate years if survey=="UGWINGS", mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5))  ///
		(qfit deathrate years, lcolor(gs10)) ///
		, legend(off) xtick(0(0.5)17) xlabel(0(1)17) ytitle(Death rate) xtitle(Years since baseline) graphregion(fcolor(white)) name(F1_1)

twoway	(rcap lowb_deathrate uppb_deathrate years  if surveyname=="BENINFORM" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="BENINFORM" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="EGYPTMACROINS" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="EGYPTMACROINS" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="GHANAFLYP" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="GHANAFLYP" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="IFLS" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="IFLS" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="KENYAGETAHEAD" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="KENYAGETAHEAD" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="MALAWIFORM" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="MALAWIFORM" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="MXFLS"& years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="MXFLS" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="NGLSMS-ISA" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="NGLSMS-ISA" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="NGYOUWIN" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="NGYOUWIN" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="SLKFEMBUSTRAINING" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="SLKFEMBUSTRAINING" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="SLKINFORMALITY" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="SLKINFORMALITY" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="SLLSE" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="SLLSE" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="SLMS" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="SLMS" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="TOGOINF" & years<=5,lcolor(gs5)) || (scatter deathrate years if survey=="TOGOINF" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="TTHAI" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="TTHAI" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(rcap lowb_deathrate uppb_deathrate years  if surveyname=="UGWINGS" & years<=5, lcolor(gs5)) || (scatter deathrate years if survey=="UGWINGS" & years<=5, mlabel(countrylabel) mlabcolor(gs5) mcolor(gs5)) ///
		(lfit deathrate years if years<=5, lcolor(gs10)) ///
		, legend(off) xtick(0(0.1)5) xlabel(0(0.5)5) ytitle(Death rate) xtitle(Years since baseline) graphregion(fcolor(white)) name(F1_2)


graph combine F1_1 F1_2, col(2) graphregion(fcolor(white))
graph save "Figures/Figure1", replace

***Predicted relationship between firm death and time

*Regression for the fitted line:
regress deathrate years c.years#c.years, cluster(surveyname)
mat coeff=e(b)
mat list coeff
*Half-life:
local a=coeff[1,2]
local b=coeff[1,1]
local c=coeff[1,3]-0.5

dis (-`b' + sqrt(`b'^2-4*`a'*`c')) / (2*`a')


*Regression for horizon of up to five years
regress deathrate years if years<=5, cluster(surveyname)
mat coeff=e(b)
mat list coeff
*Half-life:
local a=coeff[1,2]
local b=coeff[1,1]

dis (0.5 - `a') / `b'

regress uppb_deathrate years if years<=5, cluster(surveyname)
regress lowb_deathrate years if years<=5, cluster(surveyname)


********************************************************************************
**Figure 2. Death rates by per capita GDP

use "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_RH.dta", clear
keep if year<=3

g stdzd_deathrate=deathrate/years		
g stdzd_lowb_deathrate=lowb_deathrate/years		
g stdzd_uppb_deathrate=uppb_deathrate/years	

g log_pcGDP=log(GDPpc)

graph twoway	scatter stdzd_deathrate log_pcGDP, mcolor(gs5) mlabel(countrylabel) mlabcolor(gs5) || lfit stdzd_deathrate log_pcGDP, lcolor(gs10) ///
				, ytitle(Standardized (annual) death rate) xtitle(Per capita GDP (in 2015 US$)) legend(off) graphregion(fcolor(white))
graph save "Figures/Figure2", replace


********************************************************************************
**Figure 3. Relationship between Firm Death Rate and Firm Age

use "CombinedMaster_RH.dta", clear

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

*for Uganda, only the study participants who opened a business, have an id, and they are those we want to have in the regression, so I drop the others
drop if country=="Uganda" & firmid=="."

*generate id that is unique (for Thailand and Nigeria) to be able to reshape the data:
g firmidfrs=firmid
replace firmidfrs=firmid+"-"+survey if country=="Thailand" | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012"))

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

*replace profit outliers to missing
levelsof surveyname , local(svyname) 
foreach x of local svyname{
forvalues i=1/17{
su profits if (surveyname=="`x'" & wave==`i' ), detail
replace profits=. if (surveyname=="`x'" & wave==`i'  ) & (profits>r(p99) | profits<r(p1))
}
}

gen anypaidemployee=cond(employees>0,1,0) if employees~=.

keep 	firmidfrs firmid survey surveyname country ///
		survival* anyfirm* attrit* ///
		agefirm employees totalworkers sector1234 ///
		mfj ownerage ownertertiary raven educyears ///
		pcGDP subsgroup ///
		wageworker laborincome retired married ///
		expenses sales  profits ///
		urban pcexpend childunder5 childaged5to12 adult65andover familyill ownerill  

reshape long survival anyfirm attrit, i(firmidfrs) j(period) string

g years=0.25 if period=="_3mths"
replace years=0.5 if period=="_6mths"
replace years=0.75 if period=="_9mths"
replace years=1 if period=="_1yr"
replace years=1.25 if period=="_1p25yrs"
replace years=1.5 if period=="_18mths"
replace years=1.75 if period=="_1p75yrs"
replace years=2 if period=="_2yrs"
replace years=2.5 if period=="_30mths"
replace years=3 if period=="_3yrs"
replace years=3.5 if period=="_3p5yrs"
replace years=4 if period=="_4yrs"
replace years=4.5 if period=="_4p5yrs"
replace years=5 if period=="_5yrs"
replace years=5.5 if period=="_5p5yrs"
replace years=6 if period=="_6yrs"
replace years=7 if period=="_7yrs"
replace years=8 if period=="_8yrs"
replace years=9 if period=="_9yrs"
replace years=10 if period=="_10yrs"
replace years=11 if period=="_11yrs"
replace years=12 if period=="_12yrs"
replace years=13 if period=="_13yrs"
replace years=14 if period=="_14yrs"
replace years=15 if period=="_15yrs"
replace years=16 if period=="_16yrs"
replace years=17 if period=="_17yrs"

drop period

g died=1-survival

*drop if survival==.

g logprofits=log(profits+1)

foreach var of varlist	agefirm employees totalworkers sector1234 ///
						mfj ownerage ownertertiary raven ///
						wageworker laborincome retired married ///
						expenses sales profits logprofits ///
						urban pcexpend childunder5 childaged5to12 adult65andover familyill ownerill{
g d_`var'=(`var'==.)
replace `var'=0 if `var'==.
}

replace sector1234=1 if d_sector1234==1

g yearssquared=years^2

egen surveydummy=group(surveyname)

probit died years  i.surveydummy agefirm ///
			i.d_agefirm if years<=5, cluster (firmid) 
margins, dydx(*) post


****** Regression similar to Haltiwanger et al. (2013, ReStat)
* Predicted values with no size controls

sum agefirm, de
gen age0=agefirm<1
gen age1to2=agefirm>=1 & agefirm<3
gen age3to4=agefirm>=3 & agefirm<5
gen age5to6=agefirm>=5 & agefirm<7
gen age7to8=agefirm>=7 & agefirm<9
gen age9to10=agefirm>=9 & agefirm<11
gen age11to12=agefirm>=11 & agefirm<13
gen age13to15=agefirm>=13 & agefirm<16
gen age16plus=agefirm>=16 & agefirm~=.


******************* New Figure 3A - Firm Death and Firm Age Relationship 
xi: reg died age0 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared i.surveydummy if agefirm~=., noc cluster(firmid) r 
sum died if age0==1 & years==1 & e(sample)

matrix agefig1 = J(9, 3, .)
matrix coln agefig1 = beta l95 u95
matrix rown agefig1 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix agefig1[1,1] = _b[age0]+(r(mean)-_b[age0])
matrix agefig1[2,1] = _b[age1to2] + (r(mean)-_b[age0])
matrix agefig1[3,1] = _b[age3to4] + (r(mean)-_b[age0])
matrix agefig1[4,1] = _b[age5to6] + (r(mean)-_b[age0])
matrix agefig1[5,1] = _b[age7to8] + (r(mean)-_b[age0])
matrix agefig1[6,1] = _b[age9to10] + (r(mean)-_b[age0])
matrix agefig1[7,1] = _b[age11to12] + (r(mean)-_b[age0])
matrix agefig1[8,1] = _b[age13to15] + (r(mean)-_b[age0])
matrix agefig1[9,1] = _b[age16plus] + (r(mean)-_b[age0])

mat V=e(V) 
matrix agefig1[1,2] = agefig1[1,1]+1.96*sqrt(V[1,1])
matrix agefig1[2,2] = agefig1[2,1]+1.96*sqrt(V[2,2])
matrix agefig1[3,2] = agefig1[3,1]+1.96*sqrt(V[3,3])
matrix agefig1[4,2] = agefig1[4,1]+1.96*sqrt(V[4,4])
matrix agefig1[5,2] = agefig1[5,1]+1.96*sqrt(V[5,5])
matrix agefig1[6,2] = agefig1[6,1]+1.96*sqrt(V[6,6])
matrix agefig1[7,2] = agefig1[7,1]+1.96*sqrt(V[7,7])
matrix agefig1[8,2] = agefig1[8,1]+1.96*sqrt(V[8,8])
matrix agefig1[9,2] = agefig1[9,1]+1.96*sqrt(V[9,9])

matrix agefig1[1,3] = agefig1[1,1]-1.96*sqrt(V[1,1])
matrix agefig1[2,3] = agefig1[2,1]-1.96*sqrt(V[2,2])
matrix agefig1[3,3] = agefig1[3,1]-1.96*sqrt(V[3,3])
matrix agefig1[4,3] = agefig1[4,1]-1.96*sqrt(V[4,4])
matrix agefig1[5,3] = agefig1[5,1]-1.96*sqrt(V[5,5])
matrix agefig1[6,3] = agefig1[6,1]-1.96*sqrt(V[6,6])
matrix agefig1[7,3] = agefig1[7,1]-1.96*sqrt(V[7,7])
matrix agefig1[8,3] = agefig1[8,1]-1.96*sqrt(V[8,8])
matrix agefig1[9,3] = agefig1[9,1]-1.96*sqrt(V[9,9])

matrix list agefig1
coefplot (matrix(agefig1[,1]), ci((agefig1[,2] agefig1[,3]))), ytitle(Annual Firm Death Rate) xtitle("Firm Age (Years)") vertical recast(connected) scheme(s1mono) ciopts(recast(rcap)) title("A. Death Over 1 Year") name(F3A)

******** Figure 3B: Firm Death and Age Relationship Over Time
foreach var of varlist age0-age16plus {
gen `var'_years=`var'*years
gen `var'_years2=`var'*yearssquared
}
#delimit ;
xi: reg died age0 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared i.surveydummy 
 age1to2_years age3to4_years age5to6_years age7to8_years age9to10_years age11to12_years age13to15_years age16plus_years
age1to2_years2 age3to4_years2 age5to6_years2 age7to8_years2 age9to10_years2 age11to12_years2 age13to15_years2 age16plus_years2
if agefirm~=., cluster(firmid) r noc;
#delimit cr
sum died if age0==1 & years==1 & e(sample)

* Firm death rate at year 1, centered at age 0 mean, so can ignore years and years squared term
matrix ageyear1 = J(9, 1, .)
matrix coln ageyear1 = beta 
matrix rown ageyear1 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix ageyear1[1,1] = _b[age0]+(r(mean)-_b[age0])
matrix ageyear1[2,1] = _b[age1to2] + (r(mean)-_b[age0])+_b[age1to2_years]+_b[age1to2_years2]
matrix ageyear1[3,1] = _b[age3to4] + (r(mean)-_b[age0])+_b[age3to4_years]+_b[age3to4_years2]
matrix ageyear1[4,1] = _b[age5to6] + (r(mean)-_b[age0])+_b[age5to6_years]+_b[age5to6_years2]
matrix ageyear1[5,1] = _b[age7to8] + (r(mean)-_b[age0])+_b[age7to8_years]+_b[age7to8_years2]
matrix ageyear1[6,1] = _b[age9to10] + (r(mean)-_b[age0])+_b[age9to10_years]+_b[age9to10_years2]
matrix ageyear1[7,1] = _b[age11to12] + (r(mean)-_b[age0])+_b[age11to12_years]+_b[age11to12_years2]
matrix ageyear1[8,1] = _b[age13to15] + (r(mean)-_b[age0])+_b[age13to15_years]+_b[age13to15_years2]
matrix ageyear1[9,1] = _b[age16plus] + (r(mean)-_b[age0])+_b[age16plus_years]+_b[age16plus_years2]
matrix list ageyear1

* Firm death rate at year 2, so use n-1 = 1 year since year 1 with year terms
matrix ageyear2 = J(9, 1, .)
matrix coln ageyear2 = beta 
matrix rown ageyear2 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix ageyear2[1,1] = _b[age0]+(r(mean)-_b[age0])+1*_b[years]+1*_b[yearssquared]
matrix ageyear2[2,1] = _b[age1to2] + (r(mean)-_b[age0])+_b[age1to2_years]*1+_b[age1to2_years2]*1+1*_b[years]+1*_b[yearssquared]
matrix ageyear2[3,1] = _b[age3to4] + (r(mean)-_b[age0])+_b[age3to4_years]*1+_b[age3to4_years2]*1+1*_b[years]+1*_b[yearssquared]
matrix ageyear2[4,1] = _b[age5to6] + (r(mean)-_b[age0])+_b[age5to6_years]*1+_b[age5to6_years2]*1+1*_b[years]+1*_b[yearssquared]
matrix ageyear2[5,1] = _b[age7to8] + (r(mean)-_b[age0])+_b[age7to8_years]*1+_b[age7to8_years2]*1+1*_b[years]+1*_b[yearssquared]
matrix ageyear2[6,1] = _b[age9to10] + (r(mean)-_b[age0])+_b[age9to10_years]*1+_b[age9to10_years2]*1+1*_b[years]+1*_b[yearssquared]
matrix ageyear2[7,1] = _b[age11to12] + (r(mean)-_b[age0])+_b[age11to12_years]*1+_b[age11to12_years2]*1+1*_b[years]+1*_b[yearssquared]
matrix ageyear2[8,1] = _b[age13to15] + (r(mean)-_b[age0])+_b[age13to15_years]*1+_b[age13to15_years2]*1+1*_b[years]+1*_b[yearssquared]
matrix ageyear2[9,1] = _b[age16plus] + (r(mean)-_b[age0])+_b[age16plus_years]*1+_b[age16plus_years2]*1+1*_b[years]+1*_b[yearssquared]
matrix list ageyear2

* Firm death rate at year 5, so use n-1 = 4 years since year 1 with year terms
matrix ageyear5 = J(9, 1, .)
matrix coln ageyear5 = beta 
matrix rown ageyear5 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix ageyear5[1,1] = _b[age0]+(r(mean)-_b[age0])+4*_b[years]+16*_b[yearssquared]
matrix ageyear5[2,1] = _b[age1to2] + (r(mean)-_b[age0])+_b[age1to2_years]*4+_b[age1to2_years2]*16+4*_b[years]+16*_b[yearssquared]
matrix ageyear5[3,1] = _b[age3to4] + (r(mean)-_b[age0])+_b[age3to4_years]*4+_b[age3to4_years2]*16+4*_b[years]+16*_b[yearssquared]
matrix ageyear5[4,1] = _b[age5to6] + (r(mean)-_b[age0])+_b[age5to6_years]*4+_b[age5to6_years2]*16+4*_b[years]+16*_b[yearssquared]
matrix ageyear5[5,1] = _b[age7to8] + (r(mean)-_b[age0])+_b[age7to8_years]*4+_b[age7to8_years2]*16+4*_b[years]+16*_b[yearssquared]
matrix ageyear5[6,1] = _b[age9to10] + (r(mean)-_b[age0])+_b[age9to10_years]*4+_b[age9to10_years2]*16+4*_b[years]+16*_b[yearssquared]
matrix ageyear5[7,1] = _b[age11to12] + (r(mean)-_b[age0])+_b[age11to12_years]*4+_b[age11to12_years2]*16+4*_b[years]+16*_b[yearssquared]
matrix ageyear5[8,1] = _b[age13to15] + (r(mean)-_b[age0])+_b[age13to15_years]*4+_b[age13to15_years2]*16+4*_b[years]+16*_b[yearssquared]
matrix ageyear5[9,1] = _b[age16plus] + (r(mean)-_b[age0])+_b[age16plus_years]*4+_b[age16plus_years2]*16+4*_b[years]+16*_b[yearssquared]
matrix list ageyear5

* Firm death rate at year 10, so use n-1 = 9 years since year 1 with year terms
matrix ageyear10 = J(9, 1, .)
matrix coln ageyear10 = beta 
matrix rown ageyear10 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix ageyear10[1,1] = _b[age0]+(r(mean)-_b[age0])+9*_b[years]+81*_b[yearssquared]
matrix ageyear10[2,1] = _b[age1to2] + (r(mean)-_b[age0])+_b[age1to2_years]*9+_b[age1to2_years2]*81+9*_b[years]+81*_b[yearssquared]
matrix ageyear10[3,1] = _b[age3to4] + (r(mean)-_b[age0])+_b[age3to4_years]*9+_b[age3to4_years2]*81+9*_b[years]+81*_b[yearssquared]
matrix ageyear10[4,1] = _b[age5to6] + (r(mean)-_b[age0])+_b[age5to6_years]*9+_b[age5to6_years2]*81+9*_b[years]+81*_b[yearssquared]
matrix ageyear10[5,1] = _b[age7to8] + (r(mean)-_b[age0])+_b[age7to8_years]*9+_b[age7to8_years2]*81+9*_b[years]+81*_b[yearssquared]
matrix ageyear10[6,1] = _b[age9to10] + (r(mean)-_b[age0])+_b[age9to10_years]*9+_b[age9to10_years2]*81+9*_b[years]+81*_b[yearssquared]
matrix ageyear10[7,1] = _b[age11to12] + (r(mean)-_b[age0])+_b[age11to12_years]*9+_b[age11to12_years2]*81+9*_b[years]+81*_b[yearssquared]
matrix ageyear10[8,1] = _b[age13to15] + (r(mean)-_b[age0])+_b[age13to15_years]*9+_b[age13to15_years2]*81+9*_b[years]+81*_b[yearssquared]
matrix ageyear10[9,1] = _b[age16plus] + (r(mean)-_b[age0])+_b[age16plus_years]*9+_b[age16plus_years2]*81+9*_b[years]+81*_b[yearssquared]
matrix list ageyear10

#delimit ;
coefplot (matrix(ageyear1[,1])) (matrix(ageyear2[,1])) (matrix(ageyear5[,1])) (matrix(ageyear10[,1])), ytitle("Firm Death Rate")
 xtitle("Firm Age (Years)") vertical recast(connected) scheme(s1mono) legend(label(2 "1 Year") label(4 "2 Years") 
 label(6 "5 Years") label(8 "10 Years")) ciopts(recast(rcap)) title("B. Death Over Different Time Horizons") offset(0) name(F3B);
 #delimit cr

* test that no interaction of age terms with years
#delimit ;
xi: reg died age0 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared i.surveydummy 
 age1to2_years age3to4_years age5to6_years age7to8_years age9to10_years age11to12_years age13to15_years age16plus_years
age1to2_years2 age3to4_years2 age5to6_years2 age7to8_years2 age9to10_years2 age11to12_years2 age13to15_years2 age16plus_years2
if agefirm~=., cluster(firmid) r noc;
test age1to2_years==age3to4_years==age5to6_years==age7to8_years==age9to10_years==age11to12_years==age13to15_years==age16plus_years==
age1to2_years2==age3to4_years2==age5to6_years2==age7to8_years2==age9to10_years2==age11to12_years2==age13to15_years2==age16plus_years2==0;
#delimit cr

graph combine F3A F3B, ysize(2) graphregion(fcolor(white))
graph save "Figures/Figure3", replace


********************************************************************************
**Figure 4. Relationship between Firm Death Rate and Firm Size (Employees)

* Distribution of number of employees
tab employees

**** Size Controls
gen size0=employees==0
gen size1=employees==1
gen size2=employees==2
gen size3to5=employees>=3 & employees<=5
gen size6plus=employees>=6 & employees~=.

gen size3=employees==3
gen size4=employees==4
gen size5=employees==5

*** Not age-adjusted ****
xi: reg died size0 size1 size2 size3 size4 size5 size6plus years yearssquared i.surveydummy if employees~=., cluster(firmid) noc
sum died if size0==1 & years==1 & e(sample)
gen size1sample=1 if e(sample)

matrix sizefig1 = J(7, 3, .)
matrix coln sizefig1 = beta l95 u95
matrix rown sizefig1 = "0" "1" "2" "3" "4" "5" "6+"
matrix sizefig1[1,1] = _b[size0]+(r(mean)-_b[size0])
matrix sizefig1[2,1] = _b[size1] + (r(mean)-_b[size0])
matrix sizefig1[3,1] = _b[size2] + (r(mean)-_b[size0])
matrix sizefig1[4,1] = _b[size3] + (r(mean)-_b[size0])
matrix sizefig1[5,1] = _b[size4] + (r(mean)-_b[size0])
matrix sizefig1[6,1] = _b[size5] + (r(mean)-_b[size0])
matrix sizefig1[7,1] = _b[size6plus] + (r(mean)-_b[size0])

mat V=e(V) 
matrix sizefig1[1,2] = sizefig1[1,1]+1.96*sqrt(V[1,1])
matrix sizefig1[2,2] = sizefig1[2,1]+1.96*sqrt(V[2,2])
matrix sizefig1[3,2] = sizefig1[3,1]+1.96*sqrt(V[3,3])
matrix sizefig1[4,2] = sizefig1[4,1]+1.96*sqrt(V[4,4])
matrix sizefig1[5,2] = sizefig1[5,1]+1.96*sqrt(V[5,5])
matrix sizefig1[6,2] = sizefig1[6,1]+1.96*sqrt(V[6,6])
matrix sizefig1[7,2] = sizefig1[7,1]+1.96*sqrt(V[7,7])

matrix sizefig1[1,3] = sizefig1[1,1]-1.96*sqrt(V[1,1])
matrix sizefig1[2,3] = sizefig1[2,1]-1.96*sqrt(V[2,2])
matrix sizefig1[3,3] = sizefig1[3,1]-1.96*sqrt(V[3,3])
matrix sizefig1[4,3] = sizefig1[4,1]-1.96*sqrt(V[4,4])
matrix sizefig1[5,3] = sizefig1[5,1]-1.96*sqrt(V[5,5])
matrix sizefig1[6,3] = sizefig1[6,1]-1.96*sqrt(V[6,6])
matrix sizefig1[7,3] = sizefig1[7,1]-1.96*sqrt(V[7,7])
matrix list sizefig1

**** Age-adjusted ***********
foreach var of varlist age0-age16plus {
gen `var'_size0=`var'*size0
gen `var'_size1=`var'*size1
gen `var'_size2=`var'*size2
gen `var'_size3=`var'*size3
gen `var'_size4=`var'*size4
gen `var'_size5=`var'*size5
gen `var'_size6plus=`var'*size6plus
}

#delimit ;
xi: reg died age0_size0 age0_size1 age0_size2 age0_size3 age0_size4 age0_size5 age0_size6plus 
age1to2_size0 age1to2_size1 age1to2_size2 age1to2_size3 age1to2_size4 age1to2_size5 age1to2_size6plus 
 age3to4_size0 age3to4_size1 age3to4_size2 age3to4_size3 age3to4_size4 age3to4_size5 age3to4_size6plus 
age5to6_size0 age5to6_size1 age5to6_size2 age5to6_size3 age5to6_size4 age5to6_size5 age5to6_size6plus 
 age7to8_size0 age7to8_size1 age7to8_size2 age7to8_size3 age7to8_size4 age7to8_size5 age7to8_size6plus 
 age9to10_size0 age9to10_size1 age9to10_size2 age9to10_size3 age9to10_size4 age9to10_size5 age9to10_size6plus 
 age11to12_size0 age11to12_size1 age11to12_size2 age11to12_size3 age11to12_size4 age11to12_size5 age11to12_size6plus 
 age13to15_size0 age13to15_size1 age13to15_size2 age13to15_size3 age13to15_size4 age13to15_size5 age13to15_size6plus 
age16plus_size0 age16plus_size1 age16plus_size2 age16plus_size3 age16plus_size4 age16plus_size5 age16plus_size6plus 
years yearssquared i.surveydummy if agefirm~=. & employees~=., cluster(firmid) r noc; 
#delimit cr

* get weights across different size categories
sum age0 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus if e(sample)
* use these in age-weighted calculations, and again center at true mean for age0 at 1 year
sum died if size0==1 & years==1 & size1sample==1

matrix sizefig2 = J(7, 1, .)
matrix coln sizefig2 = beta 
matrix rown sizefig2 = "0" "1" "2" "3" "4" "5" "6+"
*matrix sizefig2[1,1] = r(mean)
matrix sizefig2[1,1]= _b[age0_size0]*0.162+_b[age1to2_size0]*0.147+_b[age3to4_size0]*0.122+_b[age5to6_size0]*0.099+_b[age7to8_size0]*0.072+_b[age9to10_size0]*0.087+_b[age11to12_size0]*0.045+_b[age13to15_size0]*0.068+_b[age16plus_size0]*0.198+(r(mean)-(_b[age0_size0]*0.162+_b[age1to2_size0]*0.147+_b[age3to4_size0]*0.122+_b[age5to6_size0]*0.099+_b[age7to8_size0]*0.072+_b[age9to10_size0]*0.087+_b[age11to12_size0]*0.045+_b[age13to15_size0]*0.068+_b[age16plus_size0]*0.198))
matrix sizefig2[2,1] =  _b[age0_size1]*0.162+_b[age1to2_size1]*0.147+_b[age3to4_size1]*0.122+_b[age5to6_size1]*0.099+_b[age7to8_size1]*0.072+_b[age9to10_size1]*0.087+_b[age11to12_size1]*0.045+_b[age13to15_size1]*0.068+_b[age16plus_size1]*0.198+(r(mean)-(_b[age0_size0]*0.162+_b[age1to2_size0]*0.147+_b[age3to4_size0]*0.122+_b[age5to6_size0]*0.099+_b[age7to8_size0]*0.072+_b[age9to10_size0]*0.087+_b[age11to12_size0]*0.045+_b[age13to15_size0]*0.068+_b[age16plus_size0]*0.198))
matrix sizefig2[3,1] = _b[age0_size2]*0.162+_b[age1to2_size2]*0.147+_b[age3to4_size2]*0.122+_b[age5to6_size2]*0.099+_b[age7to8_size2]*0.072+_b[age9to10_size2]*0.087+_b[age11to12_size2]*0.045+_b[age13to15_size2]*0.068+_b[age16plus_size2]*0.198+(r(mean)-(_b[age0_size0]*0.162+_b[age1to2_size0]*0.147+_b[age3to4_size0]*0.122+_b[age5to6_size0]*0.099+_b[age7to8_size0]*0.072+_b[age9to10_size0]*0.087+_b[age11to12_size0]*0.045+_b[age13to15_size0]*0.068+_b[age16plus_size0]*0.198))
matrix sizefig2[4,1] = _b[age0_size3]*0.162+_b[age1to2_size3]*0.147+_b[age3to4_size3]*0.122+_b[age5to6_size3]*0.099+_b[age7to8_size3]*0.072+_b[age9to10_size3]*0.087+_b[age11to12_size3]*0.045+_b[age13to15_size3]*0.068+_b[age16plus_size3]*0.198+(r(mean)-(_b[age0_size0]*0.162+_b[age1to2_size0]*0.147+_b[age3to4_size0]*0.122+_b[age5to6_size0]*0.099+_b[age7to8_size0]*0.072+_b[age9to10_size0]*0.087+_b[age11to12_size0]*0.045+_b[age13to15_size0]*0.068+_b[age16plus_size0]*0.198))
matrix sizefig2[5,1] = _b[age0_size4]*0.162+_b[age1to2_size4]*0.147+_b[age3to4_size4]*0.122+_b[age5to6_size4]*0.099+_b[age7to8_size4]*0.072+_b[age9to10_size4]*0.087+_b[age11to12_size4]*0.045+_b[age13to15_size4]*0.068+_b[age16plus_size4]*0.198+(r(mean)-(_b[age0_size0]*0.162+_b[age1to2_size0]*0.147+_b[age3to4_size0]*0.122+_b[age5to6_size0]*0.099+_b[age7to8_size0]*0.072+_b[age9to10_size0]*0.087+_b[age11to12_size0]*0.045+_b[age13to15_size0]*0.068+_b[age16plus_size0]*0.198))
matrix sizefig2[6,1] = _b[age0_size5]*0.162+_b[age1to2_size5]*0.147+_b[age3to4_size5]*0.122+_b[age5to6_size5]*0.099+_b[age7to8_size5]*0.072+_b[age9to10_size5]*0.087+_b[age11to12_size5]*0.045+_b[age13to15_size5]*0.068+_b[age16plus_size5]*0.198+(r(mean)-(_b[age0_size0]*0.162+_b[age1to2_size0]*0.147+_b[age3to4_size0]*0.122+_b[age5to6_size0]*0.099+_b[age7to8_size0]*0.072+_b[age9to10_size0]*0.087+_b[age11to12_size0]*0.045+_b[age13to15_size0]*0.068+_b[age16plus_size0]*0.198))
matrix sizefig2[7,1] = _b[age0_size6plus]*0.162+_b[age1to2_size6plus]*0.147+_b[age3to4_size6plus]*0.122+_b[age5to6_size6plus]*0.099+_b[age7to8_size6plus]*0.072+_b[age9to10_size6plus]*0.087+_b[age11to12_size6plus]*0.045+_b[age13to15_size6plus]*0.068+_b[age16plus_size6plus]*0.198+(r(mean)-(_b[age0_size0]*0.162+_b[age1to2_size0]*0.147+_b[age3to4_size0]*0.122+_b[age5to6_size0]*0.099+_b[age7to8_size0]*0.072+_b[age9to10_size0]*0.087+_b[age11to12_size0]*0.045+_b[age13to15_size0]*0.068+_b[age16plus_size0]*0.198))

coefplot (matrix(sizefig1[,1]), ci((sizefig1[,2] sizefig1[,3]))) (matrix(sizefig2[,1])), ytitle(Annual Firm Death Rate) xtitle("Firm Size (Employees)") vertical recast(connected) scheme(s1mono) offset(0) legend(label(2 "Unadjusted") label(4 "Age-Adjusted")) ciopts(recast(rcap))
graph save "Figures/Figure4.gph", replace

*** Correlation of firm size and firm age
corr agefirm employees if agefirm<=16 & employees<=10


********************************************************************************
**Figure 5. Relationship between Firm Death Rate and Firm Profitability

for num 1/10: gen profX=cond(subsgroup==X,1,0) if subsgroup~=.

xi: reg died prof1 prof2 prof3 prof4 prof5 prof6 prof7 prof8 prof9 prof10 years yearssquared i.surveydummy if  subsgroup~=., cluster(firmid) noc
sum died if prof1==1 & years==1 & e(sample)

matrix proffig1 = J(10, 3, .)
matrix coln proffig1 = beta l95 u95
matrix rown proffig1 = "<$1" "$1-$2" "$2-$3" "$3-$4" "$4-$5" "$5-$6" "$6-$7" "$7-$8" "$8-$9" "$9-$10"
matrix proffig1[1,1] = _b[prof1]+(r(mean)-_b[prof1])
matrix proffig1[2,1] = _b[prof2] + (r(mean)-_b[prof1])
matrix proffig1[3,1] = _b[prof3] + (r(mean)-_b[prof1])
matrix proffig1[4,1] = _b[prof4] + (r(mean)-_b[prof1])
matrix proffig1[5,1] = _b[prof5] + (r(mean)-_b[prof1])
matrix proffig1[6,1] = _b[prof6] + (r(mean)-_b[prof1])
matrix proffig1[7,1] = _b[prof7] + (r(mean)-_b[prof1])
matrix proffig1[8,1] = _b[prof8] + (r(mean)-_b[prof1])
matrix proffig1[9,1] = _b[prof9] + (r(mean)-_b[prof1])
matrix proffig1[10,1] = _b[prof10] + (r(mean)-_b[prof1])

mat V=e(V) 
matrix proffig1[1,2] = proffig1[1,1]+1.96*sqrt(V[1,1])
matrix proffig1[2,2] = proffig1[2,1]+1.96*sqrt(V[2,2])
matrix proffig1[3,2] = proffig1[3,1]+1.96*sqrt(V[3,3])
matrix proffig1[4,2] = proffig1[4,1]+1.96*sqrt(V[4,4])
matrix proffig1[5,2] = proffig1[5,1]+1.96*sqrt(V[5,5])
matrix proffig1[6,2] = proffig1[6,1]+1.96*sqrt(V[6,6])
matrix proffig1[7,2] = proffig1[7,1]+1.96*sqrt(V[7,7])
matrix proffig1[8,2] = proffig1[8,1]+1.96*sqrt(V[8,8])
matrix proffig1[9,2] = proffig1[9,1]+1.96*sqrt(V[9,9])
matrix proffig1[10,2] = proffig1[10,1]+1.96*sqrt(V[10,10])

matrix proffig1[1,3] = proffig1[1,1]-1.96*sqrt(V[1,1])
matrix proffig1[2,3] = proffig1[2,1]-1.96*sqrt(V[2,2])
matrix proffig1[3,3] = proffig1[3,1]-1.96*sqrt(V[3,3])
matrix proffig1[4,3] = proffig1[4,1]-1.96*sqrt(V[4,4])
matrix proffig1[5,3] = proffig1[5,1]-1.96*sqrt(V[5,5])
matrix proffig1[6,3] = proffig1[6,1]-1.96*sqrt(V[6,6])
matrix proffig1[7,3] = proffig1[7,1]-1.96*sqrt(V[7,7])
matrix proffig1[8,3] = proffig1[8,1]-1.96*sqrt(V[8,8])
matrix proffig1[9,3] = proffig1[9,1]-1.96*sqrt(V[9,9])
matrix proffig1[10,3] = proffig1[10,1]-1.96*sqrt(V[10,10])

matrix list proffig1
coefplot (matrix(proffig1[,1]), ci((proffig1[,2] proffig1[,3]))), ytitle(Annual Firm Death Rate) xtitle("Firm Daily Profits (US dollars)") vertical recast(connected) scheme(s1mono) ciopts(recast(rcap))
* graph save "NewFigures\Figure4.gph", replace

*** does the firm profit relationship vary with firm age?
 foreach var of varlist age0-age16plus {
for num 1/10: gen `var'_profX=`var'*profX
}

#delimit ;
xi: reg died age0_prof1 age0_prof2 age0_prof3 age0_prof4 age0_prof5 age0_prof6 age0_prof7 age0_prof8 age0_prof9 age0_prof10
age1to2_prof1 age1to2_prof2 age1to2_prof3 age1to2_prof4 age1to2_prof5 age1to2_prof6 age1to2_prof7 age1to2_prof8 age1to2_prof9 age1to2_prof10
age3to4_prof1 age3to4_prof2 age3to4_prof3 age3to4_prof4 age3to4_prof5 age3to4_prof6 age3to4_prof7 age3to4_prof8 age3to4_prof9 age3to4_prof10
age5to6_prof1 age5to6_prof2 age5to6_prof3 age5to6_prof4 age5to6_prof5 age5to6_prof6 age5to6_prof7 age5to6_prof8 age5to6_prof9 age5to6_prof10
 age7to8_prof1 age7to8_prof2 age7to8_prof3 age7to8_prof4 age7to8_prof5 age7to8_prof6 age7to8_prof7 age7to8_prof8 age7to8_prof9 age7to8_prof10
 age9to10_prof1 age9to10_prof2 age9to10_prof3 age9to10_prof4 age9to10_prof5 age9to10_prof6 age9to10_prof7 age9to10_prof8 age9to10_prof9 age9to10_prof10
  age11to12_prof1 age11to12_prof2 age11to12_prof3 age11to12_prof4 age11to12_prof5 age11to12_prof6 age11to12_prof7 age11to12_prof8 age11to12_prof9 age11to12_prof10
 age13to15_prof1 age13to15_prof2 age13to15_prof3 age13to15_prof4 age13to15_prof5 age13to15_prof6 age13to15_prof7 age13to15_prof8 age13to15_prof9 age13to15_prof10
 age16plus_prof1 age16plus_prof2 age16plus_prof3 age16plus_prof4 age16plus_prof5 age16plus_prof6 age16plus_prof7 age16plus_prof8 age16plus_prof9 age16plus_prof10
years yearssquared i.surveydummy if agefirm~=. & ownerage>=15 & subsgroup~=., cluster(firmid) r noc; 
#delimit cr

* get weights across different prof categories
sum age0 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus if e(sample)
* use these in age-weighted calculations, and again center at true mean for age0 at 1 year
sum died if prof1==1 & years==1 & e(sample)

matrix proffig2 = J(10, 1, .)
matrix coln proffig2 = beta 
matrix rown proffig2 = "<$1" "$1-$2" "$2-$3" "$3-$4" "$4-$5" "$5-$6" "$6-$7" "$7-$8" "$8-$9" "$9-$10"
matrix proffig2[1,1] =  _b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[2,1] = _b[age0_prof2]*0.162+_b[age1to2_prof2]*0.147+_b[age3to4_prof2]*0.122+_b[age5to6_prof2]*0.099+_b[age7to8_prof2]*0.072+_b[age9to10_prof2]*0.087+_b[age11to12_prof2]*0.045+_b[age13to15_prof2]*0.068+_b[age16plus_prof2]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[3,1] = _b[age0_prof3]*0.162+_b[age1to2_prof3]*0.147+_b[age3to4_prof3]*0.122+_b[age5to6_prof3]*0.099+_b[age7to8_prof3]*0.072+_b[age9to10_prof3]*0.087+_b[age11to12_prof3]*0.045+_b[age13to15_prof3]*0.068+_b[age16plus_prof3]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[4,1] = _b[age0_prof4]*0.162+_b[age1to2_prof4]*0.147+_b[age3to4_prof4]*0.122+_b[age5to6_prof4]*0.099+_b[age7to8_prof4]*0.072+_b[age9to10_prof4]*0.087+_b[age11to12_prof4]*0.045+_b[age13to15_prof4]*0.068+_b[age16plus_prof4]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[5,1] = _b[age0_prof5]*0.162+_b[age1to2_prof5]*0.147+_b[age3to4_prof5]*0.122+_b[age5to6_prof5]*0.099+_b[age7to8_prof5]*0.072+_b[age9to10_prof5]*0.087+_b[age11to12_prof5]*0.045+_b[age13to15_prof5]*0.068+_b[age16plus_prof5]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[6,1] = _b[age0_prof6]*0.162+_b[age1to2_prof6]*0.147+_b[age3to4_prof6]*0.122+_b[age5to6_prof6]*0.099+_b[age7to8_prof6]*0.072+_b[age9to10_prof6]*0.087+_b[age11to12_prof6]*0.045+_b[age13to15_prof6]*0.068+_b[age16plus_prof6]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[7,1] = _b[age0_prof7]*0.162+_b[age1to2_prof7]*0.147+_b[age3to4_prof7]*0.122+_b[age5to6_prof7]*0.099+_b[age7to8_prof7]*0.072+_b[age9to10_prof7]*0.087+_b[age11to12_prof7]*0.045+_b[age13to15_prof7]*0.068+_b[age16plus_prof7]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[8,1] = _b[age0_prof8]*0.162+_b[age1to2_prof8]*0.147+_b[age3to4_prof8]*0.122+_b[age5to6_prof8]*0.099+_b[age7to8_prof8]*0.072+_b[age9to10_prof8]*0.087+_b[age11to12_prof8]*0.045+_b[age13to15_prof8]*0.068+_b[age16plus_prof8]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[9,1] = _b[age0_prof9]*0.162+_b[age1to2_prof9]*0.147+_b[age3to4_prof9]*0.122+_b[age5to6_prof9]*0.099+_b[age7to8_prof9]*0.072+_b[age9to10_prof9]*0.087+_b[age11to12_prof9]*0.045+_b[age13to15_prof9]*0.068+_b[age16plus_prof9]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix proffig2[10,1] = _b[age0_prof10]*0.162+_b[age1to2_prof10]*0.147+_b[age3to4_prof10]*0.122+_b[age5to6_prof10]*0.099+_b[age7to8_prof10]*0.072+_b[age9to10_prof10]*0.087+_b[age11to12_prof10]*0.045+_b[age13to15_prof10]*0.068+_b[age16plus_prof10]*0.198+(r(mean)-(_b[age0_prof1]*0.162+_b[age1to2_prof1]*0.147+_b[age3to4_prof1]*0.122+_b[age5to6_prof1]*0.099+_b[age7to8_prof1]*0.072+_b[age9to10_prof1]*0.087+_b[age11to12_prof1]*0.045+_b[age13to15_prof1]*0.068+_b[age16plus_prof1]*0.198))
matrix list proffig2
 
coefplot (matrix(proffig1[,1]), ci((proffig1[,2] proffig1[,3]))) (matrix(proffig2[,1])), ytitle(Annual Firm Death Rate) xtitle("Firm Daily Profits (US dollars)") vertical recast(connected) scheme(s1mono) ciopts(recast(rcap)) offset(0) legend(label(2 "Unadjusted") label(4 "Age-Adjusted"))
graph save "Figures/Figure5.gph", replace


********************************************************************************
**Figure 6. Firm Death Rate-Firm Age Relationship by Business Sector

* generate interactions of firm age with sector
* retail
gen sect1=cond(sector==1,1,0) if sector~=.
* manufacturing
gen sect2=cond(sector==2,1,0) if sector~=.
* services
gen sect3=cond(sector==3,1,0) if sector~=.
foreach var of varlist age0-age16plus {
gen `var'_sect1=`var'*sect1
gen `var'_sect2=`var'*sect2
gen `var'_sect3=`var'*sect3
}
 
 #delimit ;
xi: reg died age0_sect1 age1to2_sect1 age3to4_sect1 age5to6_sect1 age7to8_sect1 age9to10_sect1 age11to12_sect1 age13to15_sect1 age16plus_sect1
 age0_sect2 age1to2_sect2 age3to4_sect2 age5to6_sect2 age7to8_sect2 age9to10_sect2 age11to12_sect2 age13to15_sect2 age16plus_sect2
 age0_sect3 age1to2_sect3 age3to4_sect3 age5to6_sect3 age7to8_sect3 age9to10_sect3 age11to12_sect3 age13to15_sect3 age16plus_sect3
years yearssquared i.surveydummy if agefirm~=. & sector<=3, noc cluster(firmid) r ;
#delimit cr
sum died if age0_sect1==1 & years==1 & e(sample)

matrix agefigs1 = J(9, 3, .)
matrix coln agefigs1 = beta l95 u95
matrix rown agefigs1 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix agefigs1[1,1] = _b[age0_sect1]+(r(mean)-_b[age0_sect1])
matrix agefigs1[2,1] = _b[age1to2_sect1] + (r(mean)-_b[age0_sect1])
matrix agefigs1[3,1] = _b[age3to4_sect1] + (r(mean)-_b[age0_sect1])
matrix agefigs1[4,1] = _b[age5to6_sect1] + (r(mean)-_b[age0_sect1])
matrix agefigs1[5,1] = _b[age7to8_sect1] + (r(mean)-_b[age0_sect1])
matrix agefigs1[6,1] = _b[age9to10_sect1] + (r(mean)-_b[age0_sect1])
matrix agefigs1[7,1] = _b[age11to12_sect1] + (r(mean)-_b[age0_sect1])
matrix agefigs1[8,1] = _b[age13to15_sect1] + (r(mean)-_b[age0_sect1])
matrix agefigs1[9,1] = _b[age16plus_sect1] + (r(mean)-_b[age0_sect1])

mat V=e(V) 
matrix agefigs1[1,2] = agefigs1[1,1]+1.96*sqrt(V[1,1])
matrix agefigs1[2,2] = agefigs1[2,1]+1.96*sqrt(V[2,2])
matrix agefigs1[3,2] = agefigs1[3,1]+1.96*sqrt(V[3,3])
matrix agefigs1[4,2] = agefigs1[4,1]+1.96*sqrt(V[4,4])
matrix agefigs1[5,2] = agefigs1[5,1]+1.96*sqrt(V[5,5])
matrix agefigs1[6,2] = agefigs1[6,1]+1.96*sqrt(V[6,6])
matrix agefigs1[7,2] = agefigs1[7,1]+1.96*sqrt(V[7,7])
matrix agefigs1[8,2] = agefigs1[8,1]+1.96*sqrt(V[8,8])
matrix agefigs1[9,2] = agefigs1[9,1]+1.96*sqrt(V[9,9])

matrix agefigs1[1,3] = agefigs1[1,1]-1.96*sqrt(V[1,1])
matrix agefigs1[2,3] = agefigs1[2,1]-1.96*sqrt(V[2,2])
matrix agefigs1[3,3] = agefigs1[3,1]-1.96*sqrt(V[3,3])
matrix agefigs1[4,3] = agefigs1[4,1]-1.96*sqrt(V[4,4])
matrix agefigs1[5,3] = agefigs1[5,1]-1.96*sqrt(V[5,5])
matrix agefigs1[6,3] = agefigs1[6,1]-1.96*sqrt(V[6,6])
matrix agefigs1[7,3] = agefigs1[7,1]-1.96*sqrt(V[7,7])
matrix agefigs1[8,3] = agefigs1[8,1]-1.96*sqrt(V[8,8])
matrix agefigs1[9,3] = agefigs1[9,1]-1.96*sqrt(V[9,9])
matrix list agefigs1

matrix agefigs2 = J(9, 3, .)
matrix coln agefigs2 = beta l95 u95
matrix rown agefigs2 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix agefigs2[1,1] = _b[age0_sect2]+(r(mean)-_b[age0_sect1])
matrix agefigs2[2,1] = _b[age1to2_sect2] + (r(mean)-_b[age0_sect1])
matrix agefigs2[3,1] = _b[age3to4_sect2] + (r(mean)-_b[age0_sect1])
matrix agefigs2[4,1] = _b[age5to6_sect2] + (r(mean)-_b[age0_sect1])
matrix agefigs2[5,1] = _b[age7to8_sect2] + (r(mean)-_b[age0_sect1])
matrix agefigs2[6,1] = _b[age9to10_sect2] + (r(mean)-_b[age0_sect1])
matrix agefigs2[7,1] = _b[age11to12_sect2] + (r(mean)-_b[age0_sect1])
matrix agefigs2[8,1] = _b[age13to15_sect2] + (r(mean)-_b[age0_sect1])
matrix agefigs2[9,1] = _b[age16plus_sect2] + (r(mean)-_b[age0_sect1])

mat V=e(V) 
matrix agefigs2[1,2] = agefigs2[1,1]+1.96*sqrt(V[10,10])
matrix agefigs2[2,2] = agefigs2[2,1]+1.96*sqrt(V[11,11])
matrix agefigs2[3,2] = agefigs2[3,1]+1.96*sqrt(V[12,12])
matrix agefigs2[4,2] = agefigs2[4,1]+1.96*sqrt(V[13,13])
matrix agefigs2[5,2] = agefigs2[5,1]+1.96*sqrt(V[14,14])
matrix agefigs2[6,2] = agefigs2[6,1]+1.96*sqrt(V[15,15])
matrix agefigs2[7,2] = agefigs2[7,1]+1.96*sqrt(V[16,16])
matrix agefigs2[8,2] = agefigs2[8,1]+1.96*sqrt(V[17,17])
matrix agefigs2[9,2] = agefigs2[9,1]+1.96*sqrt(V[18,18])

matrix agefigs2[1,3] = agefigs2[1,1]-1.96*sqrt(V[10,10])
matrix agefigs2[2,3] = agefigs2[2,1]-1.96*sqrt(V[11,11])
matrix agefigs2[3,3] = agefigs2[3,1]-1.96*sqrt(V[12,12])
matrix agefigs2[4,3] = agefigs2[4,1]-1.96*sqrt(V[13,13])
matrix agefigs2[5,3] = agefigs2[5,1]-1.96*sqrt(V[14,14])
matrix agefigs2[6,3] = agefigs2[6,1]-1.96*sqrt(V[15,15])
matrix agefigs2[7,3] = agefigs2[7,1]-1.96*sqrt(V[16,16])
matrix agefigs2[8,3] = agefigs2[8,1]-1.96*sqrt(V[17,17])
matrix agefigs2[9,3] = agefigs2[9,1]-1.96*sqrt(V[18,18])
matrix list agefigs2

matrix agefigs3 = J(9, 3, .)
matrix coln agefigs3 = beta l95 u95
matrix rown agefigs3 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix agefigs3[1,1] = _b[age0_sect3]+(r(mean)-_b[age0_sect1])
matrix agefigs3[2,1] = _b[age1to2_sect3] + (r(mean)-_b[age0_sect1])
matrix agefigs3[3,1] = _b[age3to4_sect3] + (r(mean)-_b[age0_sect1])
matrix agefigs3[4,1] = _b[age5to6_sect3] + (r(mean)-_b[age0_sect1])
matrix agefigs3[5,1] = _b[age7to8_sect3] + (r(mean)-_b[age0_sect1])
matrix agefigs3[6,1] = _b[age9to10_sect3] + (r(mean)-_b[age0_sect1])
matrix agefigs3[7,1] = _b[age11to12_sect3] + (r(mean)-_b[age0_sect1])
matrix agefigs3[8,1] = _b[age13to15_sect3] + (r(mean)-_b[age0_sect1])
matrix agefigs3[9,1] = _b[age16plus_sect3] + (r(mean)-_b[age0_sect1])

mat V=e(V) 
matrix agefigs3[1,2] = agefigs3[1,1]+1.96*sqrt(V[19,19])
matrix agefigs3[2,2] = agefigs3[2,1]+1.96*sqrt(V[20,20])
matrix agefigs3[3,2] = agefigs3[3,1]+1.96*sqrt(V[21,21])
matrix agefigs3[4,2] = agefigs3[4,1]+1.96*sqrt(V[22,22])
matrix agefigs3[5,2] = agefigs3[5,1]+1.96*sqrt(V[23,23])
matrix agefigs3[6,2] = agefigs3[6,1]+1.96*sqrt(V[24,24])
matrix agefigs3[7,2] = agefigs3[7,1]+1.96*sqrt(V[25,25])
matrix agefigs3[8,2] = agefigs3[8,1]+1.96*sqrt(V[26,26])
matrix agefigs3[9,2] = agefigs3[9,1]+1.96*sqrt(V[27,27])

matrix agefigs3[1,3] = agefigs3[1,1]-1.96*sqrt(V[19,19])
matrix agefigs3[2,3] = agefigs3[2,1]-1.96*sqrt(V[20,20])
matrix agefigs3[3,3] = agefigs3[3,1]-1.96*sqrt(V[21,21])
matrix agefigs3[4,3] = agefigs3[4,1]-1.96*sqrt(V[22,22])
matrix agefigs3[5,3] = agefigs3[5,1]-1.96*sqrt(V[23,23])
matrix agefigs3[6,3] = agefigs3[6,1]-1.96*sqrt(V[24,24])
matrix agefigs3[7,3] = agefigs3[7,1]-1.96*sqrt(V[25,25])
matrix agefigs3[8,3] = agefigs3[8,1]-1.96*sqrt(V[26,26])
matrix agefigs3[9,3] = agefigs3[9,1]-1.96*sqrt(V[27,27])
matrix list agefigs3


#delimit ;
coefplot (matrix(agefigs1[,1]), ci((agefigs1[,2] agefigs1[,3]))) (matrix(agefigs2[,1]), ci((agefigs2[,2] agefigs2[,3])))
(matrix(agefigs3[,1]), ci((agefigs3[,2] agefigs3[,3])))
, ytitle(Annual Firm Death Rate) xtitle("Firm Age (Years)") vertical recast(connected) scheme(s1mono) offset(0.1) legend(label(2 "Retail")  
label(4 "Manufacturing") label(6 "Services")) ciopts(recast(rcap));
#delimit cr
graph save "Figures/Figure6.gph", replace
 
 * test equality of impacts by sector
 test age0_sect1==age0_sect2==age0_sect3
 test age1to2_sect1==age1to2_sect2==age1to2_sect3, accum 
 test age3to4_sect1==age3to4_sect2==age3to4_sect3, accum 
 test age5to6_sect1==age5to6_sect2==age5to6_sect3, accum 
 test age7to8_sect1==age7to8_sect2==age7to8_sect3, accum 
 test age9to10_sect1==age9to10_sect2==age9to10_sect3, accum 
 test age11to12_sect1==age11to12_sect2==age11to12_sect3, accum 
 test age13to15_sect1==age13to15_sect2==age13to15_sect3, accum 
 test age16plus_sect1==age16plus_sect2==age16plus_sect3, accum

 
******************************************************************************** 
**Figure 7. Firm Death Rate-Firm Age Relationship by Gender of the Business Owner 

gen male=cond(mfj==0,1,0) if mfj<=1
gen female=cond(mfj==1,1,0) if mfj<=1

foreach var of varlist age0-age16plus {
gen `var'_male=`var'*male
gen `var'_female=`var'*female
}
 
 #delimit ;
xi: reg died age0_male age1to2_male age3to4_male age5to6_male age7to8_male age9to10_male age11to12_male age13to15_male age16plus_male
 age0_female age1to2_female age3to4_female age5to6_female age7to8_female age9to10_female age11to12_female age13to15_female age16plus_female
years yearssquared i.surveydummy if agefirm~=. & mfj<=1, noc cluster(firmid) r ;
#delimit cr
sum died if age0_male==1 & years==1 & e(sample)

matrix agefigs1 = J(9, 3, .)
matrix coln agefigs1 = beta l95 u95
matrix rown agefigs1 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix agefigs1[1,1] = _b[age0_male]+(r(mean)-_b[age0_male])
matrix agefigs1[2,1] = _b[age1to2_male] + (r(mean)-_b[age0_male])
matrix agefigs1[3,1] = _b[age3to4_male] + (r(mean)-_b[age0_male])
matrix agefigs1[4,1] = _b[age5to6_male] + (r(mean)-_b[age0_male])
matrix agefigs1[5,1] = _b[age7to8_male] + (r(mean)-_b[age0_male])
matrix agefigs1[6,1] = _b[age9to10_male] + (r(mean)-_b[age0_male])
matrix agefigs1[7,1] = _b[age11to12_male] + (r(mean)-_b[age0_male])
matrix agefigs1[8,1] = _b[age13to15_male] + (r(mean)-_b[age0_male])
matrix agefigs1[9,1] = _b[age16plus_male] + (r(mean)-_b[age0_male])

mat V=e(V) 
matrix agefigs1[1,2] = agefigs1[1,1]+1.96*sqrt(V[1,1])
matrix agefigs1[2,2] = agefigs1[2,1]+1.96*sqrt(V[2,2])
matrix agefigs1[3,2] = agefigs1[3,1]+1.96*sqrt(V[3,3])
matrix agefigs1[4,2] = agefigs1[4,1]+1.96*sqrt(V[4,4])
matrix agefigs1[5,2] = agefigs1[5,1]+1.96*sqrt(V[5,5])
matrix agefigs1[6,2] = agefigs1[6,1]+1.96*sqrt(V[6,6])
matrix agefigs1[7,2] = agefigs1[7,1]+1.96*sqrt(V[7,7])
matrix agefigs1[8,2] = agefigs1[8,1]+1.96*sqrt(V[8,8])
matrix agefigs1[9,2] = agefigs1[9,1]+1.96*sqrt(V[9,9])

matrix agefigs1[1,3] = agefigs1[1,1]-1.96*sqrt(V[1,1])
matrix agefigs1[2,3] = agefigs1[2,1]-1.96*sqrt(V[2,2])
matrix agefigs1[3,3] = agefigs1[3,1]-1.96*sqrt(V[3,3])
matrix agefigs1[4,3] = agefigs1[4,1]-1.96*sqrt(V[4,4])
matrix agefigs1[5,3] = agefigs1[5,1]-1.96*sqrt(V[5,5])
matrix agefigs1[6,3] = agefigs1[6,1]-1.96*sqrt(V[6,6])
matrix agefigs1[7,3] = agefigs1[7,1]-1.96*sqrt(V[7,7])
matrix agefigs1[8,3] = agefigs1[8,1]-1.96*sqrt(V[8,8])
matrix agefigs1[9,3] = agefigs1[9,1]-1.96*sqrt(V[9,9])
matrix list agefigs1

matrix agefigs2 = J(9, 3, .)
matrix coln agefigs2 = beta l95 u95
matrix rown agefigs2 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix agefigs2[1,1] = _b[age0_female]+(r(mean)-_b[age0_male])
matrix agefigs2[2,1] = _b[age1to2_female] + (r(mean)-_b[age0_male])
matrix agefigs2[3,1] = _b[age3to4_female] + (r(mean)-_b[age0_male])
matrix agefigs2[4,1] = _b[age5to6_female] + (r(mean)-_b[age0_male])
matrix agefigs2[5,1] = _b[age7to8_female] + (r(mean)-_b[age0_male])
matrix agefigs2[6,1] = _b[age9to10_female] + (r(mean)-_b[age0_male])
matrix agefigs2[7,1] = _b[age11to12_female] + (r(mean)-_b[age0_male])
matrix agefigs2[8,1] = _b[age13to15_female] + (r(mean)-_b[age0_male])
matrix agefigs2[9,1] = _b[age16plus_female] + (r(mean)-_b[age0_male])

mat V=e(V) 
matrix agefigs2[1,2] = agefigs2[1,1]+1.96*sqrt(V[10,10])
matrix agefigs2[2,2] = agefigs2[2,1]+1.96*sqrt(V[11,11])
matrix agefigs2[3,2] = agefigs2[3,1]+1.96*sqrt(V[12,12])
matrix agefigs2[4,2] = agefigs2[4,1]+1.96*sqrt(V[13,13])
matrix agefigs2[5,2] = agefigs2[5,1]+1.96*sqrt(V[14,14])
matrix agefigs2[6,2] = agefigs2[6,1]+1.96*sqrt(V[15,15])
matrix agefigs2[7,2] = agefigs2[7,1]+1.96*sqrt(V[16,16])
matrix agefigs2[8,2] = agefigs2[8,1]+1.96*sqrt(V[17,17])
matrix agefigs2[9,2] = agefigs2[9,1]+1.96*sqrt(V[18,18])

matrix agefigs2[1,3] = agefigs2[1,1]-1.96*sqrt(V[10,10])
matrix agefigs2[2,3] = agefigs2[2,1]-1.96*sqrt(V[11,11])
matrix agefigs2[3,3] = agefigs2[3,1]-1.96*sqrt(V[12,12])
matrix agefigs2[4,3] = agefigs2[4,1]-1.96*sqrt(V[13,13])
matrix agefigs2[5,3] = agefigs2[5,1]-1.96*sqrt(V[14,14])
matrix agefigs2[6,3] = agefigs2[6,1]-1.96*sqrt(V[15,15])
matrix agefigs2[7,3] = agefigs2[7,1]-1.96*sqrt(V[16,16])
matrix agefigs2[8,3] = agefigs2[8,1]-1.96*sqrt(V[17,17])
matrix agefigs2[9,3] = agefigs2[9,1]-1.96*sqrt(V[18,18])
matrix list agefigs2

#delimit ;
coefplot (matrix(agefigs1[,1]), ci((agefigs1[,2] agefigs1[,3]))) (matrix(agefigs2[,1]), ci((agefigs2[,2] agefigs2[,3])))
, ytitle(Annual Firm Death Rate) xtitle("Firm Age (Years)") vertical recast(connected) scheme(s1mono) ciopts(recast(rcap)) offset(0.1) legend(label(2 "Males") 
label(4 "Females"));
 graph save "Figures/Figure7.gph", replace;
 #delimit cr

* test of equality by gender
test age0_male==age0_female
test age1to2_male==age1to2_female, accum
test age3to4_male==age3to4_female, accum
test age5to6_male==age5to6_female, accum
test age7to8_male==age7to8_female, accum
test age9to10_male==age9to10_female, accum
test age11to12_male==age11to12_female, accum
test age13to15_male==age13to15_female, accum
test age16plus_male==age16plus_female, accum


******************************************************************************** 
**Figure 8. Relationship between Firm Death Rate and Age of Business Owner

* Define owner age groups
gen oage1=ownerage>=15 & ownerage<20
gen oage2=ownerage>=20 & ownerage<25
gen oage3=ownerage>=25 & ownerage<30
gen oage4=ownerage>=30 & ownerage<35
gen oage5=ownerage>=35 & ownerage<40
gen oage6=ownerage>=40 & ownerage<45
gen oage7=ownerage>=45 & ownerage<50
gen oage8=ownerage>=50 & ownerage<55
gen oage9=ownerage>=55 & ownerage<60
gen oage10=ownerage>=60 & ownerage~=.

xi: reg died oage1 oage2 oage3 oage4 oage5 oage6 oage7 oage8 oage9 oage10 years yearssquared i.surveydummy if  ownerage>=15 & ownerage~=., cluster(firmid) noc
sum died if oage1==1 & years==1 & e(sample)

matrix oagefig1 = J(10, 3, .)
matrix coln oagefig1 = beta l95 u95
matrix rown oagefig1 = "15-19" "20-24" "25-29" "30-34" "35-39" "40-44" "45-49" "50-54" "55-59" "60+"
matrix oagefig1[1,1] = _b[oage1]+(r(mean)-_b[oage1])
matrix oagefig1[2,1] = _b[oage2] + (r(mean)-_b[oage1])
matrix oagefig1[3,1] = _b[oage3] + (r(mean)-_b[oage1])
matrix oagefig1[4,1] = _b[oage4] + (r(mean)-_b[oage1])
matrix oagefig1[5,1] = _b[oage5] + (r(mean)-_b[oage1])
matrix oagefig1[6,1] = _b[oage6] + (r(mean)-_b[oage1])
matrix oagefig1[7,1] = _b[oage7] + (r(mean)-_b[oage1])
matrix oagefig1[8,1] = _b[oage8] + (r(mean)-_b[oage1])
matrix oagefig1[9,1] = _b[oage9] + (r(mean)-_b[oage1])
matrix oagefig1[10,1] = _b[oage10] + (r(mean)-_b[oage1])

mat V=e(V) 
matrix oagefig1[1,2] = oagefig1[1,1]+1.96*sqrt(V[1,1])
matrix oagefig1[2,2] = oagefig1[2,1]+1.96*sqrt(V[2,2])
matrix oagefig1[3,2] = oagefig1[3,1]+1.96*sqrt(V[3,3])
matrix oagefig1[4,2] = oagefig1[4,1]+1.96*sqrt(V[4,4])
matrix oagefig1[5,2] = oagefig1[5,1]+1.96*sqrt(V[5,5])
matrix oagefig1[6,2] = oagefig1[6,1]+1.96*sqrt(V[6,6])
matrix oagefig1[7,2] = oagefig1[7,1]+1.96*sqrt(V[7,7])
matrix oagefig1[8,2] = oagefig1[8,1]+1.96*sqrt(V[8,8])
matrix oagefig1[9,2] = oagefig1[9,1]+1.96*sqrt(V[9,9])
matrix oagefig1[10,2] = oagefig1[10,1]+1.96*sqrt(V[10,10])

matrix oagefig1[1,3] = oagefig1[1,1]-1.96*sqrt(V[1,1])
matrix oagefig1[2,3] = oagefig1[2,1]-1.96*sqrt(V[2,2])
matrix oagefig1[3,3] = oagefig1[3,1]-1.96*sqrt(V[3,3])
matrix oagefig1[4,3] = oagefig1[4,1]-1.96*sqrt(V[4,4])
matrix oagefig1[5,3] = oagefig1[5,1]-1.96*sqrt(V[5,5])
matrix oagefig1[6,3] = oagefig1[6,1]-1.96*sqrt(V[6,6])
matrix oagefig1[7,3] = oagefig1[7,1]-1.96*sqrt(V[7,7])
matrix oagefig1[8,3] = oagefig1[8,1]-1.96*sqrt(V[8,8])
matrix oagefig1[9,3] = oagefig1[9,1]-1.96*sqrt(V[9,9])
matrix oagefig1[10,3] = oagefig1[10,1]-1.96*sqrt(V[10,10])

**** Age-adjusted figure
foreach var of varlist age0-age16plus {
for num 1/10: gen `var'_oageX=`var'*oageX
}

#delimit ;
xi: reg died age0_oage1 age0_oage2 age0_oage3 age0_oage4 age0_oage5 age0_oage6 age0_oage7 age0_oage8 age0_oage9 age0_oage10
age1to2_oage1 age1to2_oage2 age1to2_oage3 age1to2_oage4 age1to2_oage5 age1to2_oage6 age1to2_oage7 age1to2_oage8 age1to2_oage9 age1to2_oage10
age3to4_oage1 age3to4_oage2 age3to4_oage3 age3to4_oage4 age3to4_oage5 age3to4_oage6 age3to4_oage7 age3to4_oage8 age3to4_oage9 age3to4_oage10
age5to6_oage1 age5to6_oage2 age5to6_oage3 age5to6_oage4 age5to6_oage5 age5to6_oage6 age5to6_oage7 age5to6_oage8 age5to6_oage9 age5to6_oage10
 age7to8_oage1 age7to8_oage2 age7to8_oage3 age7to8_oage4 age7to8_oage5 age7to8_oage6 age7to8_oage7 age7to8_oage8 age7to8_oage9 age7to8_oage10
 age9to10_oage1 age9to10_oage2 age9to10_oage3 age9to10_oage4 age9to10_oage5 age9to10_oage6 age9to10_oage7 age9to10_oage8 age9to10_oage9 age9to10_oage10
  age11to12_oage1 age11to12_oage2 age11to12_oage3 age11to12_oage4 age11to12_oage5 age11to12_oage6 age11to12_oage7 age11to12_oage8 age11to12_oage9 age11to12_oage10
 age13to15_oage1 age13to15_oage2 age13to15_oage3 age13to15_oage4 age13to15_oage5 age13to15_oage6 age13to15_oage7 age13to15_oage8 age13to15_oage9 age13to15_oage10
 age16plus_oage1 age16plus_oage2 age16plus_oage3 age16plus_oage4 age16plus_oage5 age16plus_oage6 age16plus_oage7 age16plus_oage8 age16plus_oage9 age16plus_oage10
years yearssquared i.surveydummy if agefirm~=. & ownerage>=15 & ownerage~=., cluster(firmid) r noc; 
#delimit cr

* get weights across different oage categories
sum age0 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus if e(sample)
* use these in age-weighted calculations, and again center at true mean for age0 at 1 year
sum died if oage1==1 & years==1 & e(sample)

matrix oagefig2 = J(10, 1, .)
matrix coln oagefig2 = beta 
matrix rown oagefig2 = "15-19" "20-24" "25-29" "30-34" "35-39" "40-44" "45-49" "50-54" "55-59" "60+"
matrix oagefig2[1,1] =  _b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[2,1] = _b[age0_oage2]*0.162+_b[age1to2_oage2]*0.147+_b[age3to4_oage2]*0.122+_b[age5to6_oage2]*0.099+_b[age7to8_oage2]*0.072+_b[age9to10_oage2]*0.087+_b[age11to12_oage2]*0.045+_b[age13to15_oage2]*0.068+_b[age16plus_oage2]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[3,1] = _b[age0_oage3]*0.162+_b[age1to2_oage3]*0.147+_b[age3to4_oage3]*0.122+_b[age5to6_oage3]*0.099+_b[age7to8_oage3]*0.072+_b[age9to10_oage3]*0.087+_b[age11to12_oage3]*0.045+_b[age13to15_oage3]*0.068+_b[age16plus_oage3]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[4,1] = _b[age0_oage4]*0.162+_b[age1to2_oage4]*0.147+_b[age3to4_oage4]*0.122+_b[age5to6_oage4]*0.099+_b[age7to8_oage4]*0.072+_b[age9to10_oage4]*0.087+_b[age11to12_oage4]*0.045+_b[age13to15_oage4]*0.068+_b[age16plus_oage4]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[5,1] = _b[age0_oage5]*0.162+_b[age1to2_oage5]*0.147+_b[age3to4_oage5]*0.122+_b[age5to6_oage5]*0.099+_b[age7to8_oage5]*0.072+_b[age9to10_oage5]*0.087+_b[age11to12_oage5]*0.045+_b[age13to15_oage5]*0.068+_b[age16plus_oage5]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[6,1] = _b[age0_oage6]*0.162+_b[age1to2_oage6]*0.147+_b[age3to4_oage6]*0.122+_b[age5to6_oage6]*0.099+_b[age7to8_oage6]*0.072+_b[age9to10_oage6]*0.087+_b[age11to12_oage6]*0.045+_b[age13to15_oage6]*0.068+_b[age16plus_oage6]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[7,1] = _b[age0_oage7]*0.162+_b[age1to2_oage7]*0.147+_b[age3to4_oage7]*0.122+_b[age5to6_oage7]*0.099+_b[age7to8_oage7]*0.072+_b[age9to10_oage7]*0.087+_b[age11to12_oage7]*0.045+_b[age13to15_oage7]*0.068+_b[age16plus_oage7]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[8,1] = _b[age0_oage8]*0.162+_b[age1to2_oage8]*0.147+_b[age3to4_oage8]*0.122+_b[age5to6_oage8]*0.099+_b[age7to8_oage8]*0.072+_b[age9to10_oage8]*0.087+_b[age11to12_oage8]*0.045+_b[age13to15_oage8]*0.068+_b[age16plus_oage8]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[9,1] = _b[age0_oage9]*0.162+_b[age1to2_oage9]*0.147+_b[age3to4_oage9]*0.122+_b[age5to6_oage9]*0.099+_b[age7to8_oage9]*0.072+_b[age9to10_oage9]*0.087+_b[age11to12_oage9]*0.045+_b[age13to15_oage9]*0.068+_b[age16plus_oage9]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))
matrix oagefig2[10,1] = _b[age0_oage10]*0.162+_b[age1to2_oage10]*0.147+_b[age3to4_oage10]*0.122+_b[age5to6_oage10]*0.099+_b[age7to8_oage10]*0.072+_b[age9to10_oage10]*0.087+_b[age11to12_oage10]*0.045+_b[age13to15_oage10]*0.068+_b[age16plus_oage10]*0.198+(r(mean)-(_b[age0_oage1]*0.162+_b[age1to2_oage1]*0.147+_b[age3to4_oage1]*0.122+_b[age5to6_oage1]*0.099+_b[age7to8_oage1]*0.072+_b[age9to10_oage1]*0.087+_b[age11to12_oage1]*0.045+_b[age13to15_oage1]*0.068+_b[age16plus_oage1]*0.198))

matrix list oagefig2
coefplot (matrix(oagefig1[,1]), ci((oagefig1[,2] oagefig1[,3]))) (matrix(oagefig2[,1])), ytitle(Annual Firm Death Rate) xtitle("Age of Owner") vertical recast(connected) scheme(s1mono) legend(label(2 "Unadjusted") label(4 "Firm-Age-Adjusted")) offset(0) ciopts(recast(rcap))
graph save "Figures/Figure8.gph", replace

corr ownerage agefirm if ownerage>=15 & ownerage<=70 & agefirm<=30


******************************************************************************** 
**Figure 9. Relationship between Firm Death and Education of Firm Owner

sum educyears, de
gen educ0=educyears==0
gen educ1to6=educyears>=1 & educyears<=6
gen educ7to9=educyears>=7 & educyears<=9
gen educ10=educyears==10
gen educ11=educyears==11
gen educ12=educyears==12
gen educ13plus=educyears>=13 & educyears~=.


xi: reg died educ0 educ1to6 educ7to9 educ10 educ11 educ12 educ13plus years yearssquared i.surveydummy if educyears~=., noc cluster(firmid) r 
sum died if educ0==1 & years==1 & e(sample)

matrix educfig1 = J(7, 3, .)
matrix coln educfig1 = beta l95 u95
matrix rown educfig1 = "0" "1to6" "7to9" "10" "11" "12" "13+"
matrix educfig1[1,1] = _b[educ0]+(r(mean)-_b[educ0])
matrix educfig1[2,1] = _b[educ1to6] + (r(mean)-_b[educ0])
matrix educfig1[3,1] = _b[educ7to9] + (r(mean)-_b[educ0])
matrix educfig1[4,1] = _b[educ10] + (r(mean)-_b[educ0])
matrix educfig1[5,1] = _b[educ11] + (r(mean)-_b[educ0])
matrix educfig1[6,1] = _b[educ12] + (r(mean)-_b[educ0])
matrix educfig1[7,1] = _b[educ13plus] + (r(mean)-_b[educ0])


mat V=e(V) 
matrix educfig1[1,2] = educfig1[1,1]+1.96*sqrt(V[1,1])
matrix educfig1[2,2] = educfig1[2,1]+1.96*sqrt(V[2,2])
matrix educfig1[3,2] = educfig1[3,1]+1.96*sqrt(V[3,3])
matrix educfig1[4,2] = educfig1[4,1]+1.96*sqrt(V[4,4])
matrix educfig1[5,2] = educfig1[5,1]+1.96*sqrt(V[5,5])
matrix educfig1[6,2] = educfig1[6,1]+1.96*sqrt(V[6,6])
matrix educfig1[7,2] = educfig1[7,1]+1.96*sqrt(V[7,7])

matrix educfig1[1,3] = educfig1[1,1]-1.96*sqrt(V[1,1])
matrix educfig1[2,3] = educfig1[2,1]-1.96*sqrt(V[2,2])
matrix educfig1[3,3] = educfig1[3,1]-1.96*sqrt(V[3,3])
matrix educfig1[4,3] = educfig1[4,1]-1.96*sqrt(V[4,4])
matrix educfig1[5,3] = educfig1[5,1]-1.96*sqrt(V[5,5])
matrix educfig1[6,3] = educfig1[6,1]-1.96*sqrt(V[6,6])
matrix educfig1[7,3] = educfig1[7,1]-1.96*sqrt(V[7,7])


matrix list educfig1
coefplot (matrix(educfig1[,1]), ci((educfig1[,2] educfig1[,3]))), ytitle(Annual Firm Death Rate) xtitle("Education of Owner (Years)") vertical recast(connected) scheme(s1mono) ciopts(recast(rcap)) 
graph save "Figures/Figure9.gph", replace

test educ0==educ1to6==educ7to9==educ10==educ11==educ12==educ13plus

preserve

********************************************************************************
**Figure 10. Sensitivity of Age and Time Horizon Relationships to Considering Exit from Self-Employment Instead of Firm Death

gen selfemp=1-anyfirm
xi: reg selfemp age0 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared i.surveydummy if agefirm~=., noc cluster(firmid) r 
sum selfemp if age0==1 & years==1 & e(sample)

matrix agefig3 = J(9, 3, .)
matrix coln agefig3 = beta l95 u95
matrix rown agefig3 = "0" "1to2" "3to4" "5to6" "7to8" "9to10" "11to12" "13to15" "16+"
matrix agefig3[1,1] = _b[age0]+(r(mean)-_b[age0])
matrix agefig3[2,1] = _b[age1to2] + (r(mean)-_b[age0])
matrix agefig3[3,1] = _b[age3to4] + (r(mean)-_b[age0])
matrix agefig3[4,1] = _b[age5to6] + (r(mean)-_b[age0])
matrix agefig3[5,1] = _b[age7to8] + (r(mean)-_b[age0])
matrix agefig3[6,1] = _b[age9to10] + (r(mean)-_b[age0])
matrix agefig3[7,1] = _b[age11to12] + (r(mean)-_b[age0])
matrix agefig3[8,1] = _b[age13to15] + (r(mean)-_b[age0])
matrix agefig3[9,1] = _b[age16plus] + (r(mean)-_b[age0])

mat V=e(V) 
matrix agefig3[1,2] = agefig3[1,1]+1.96*sqrt(V[1,1])
matrix agefig3[2,2] = agefig3[2,1]+1.96*sqrt(V[2,2])
matrix agefig3[3,2] = agefig3[3,1]+1.96*sqrt(V[3,3])
matrix agefig3[4,2] = agefig3[4,1]+1.96*sqrt(V[4,4])
matrix agefig3[5,2] = agefig3[5,1]+1.96*sqrt(V[5,5])
matrix agefig3[6,2] = agefig3[6,1]+1.96*sqrt(V[6,6])
matrix agefig3[7,2] = agefig3[7,1]+1.96*sqrt(V[7,7])
matrix agefig3[8,2] = agefig3[8,1]+1.96*sqrt(V[8,8])
matrix agefig3[9,2] = agefig3[9,1]+1.96*sqrt(V[9,9])

matrix agefig3[1,3] = agefig3[1,1]-1.96*sqrt(V[1,1])
matrix agefig3[2,3] = agefig3[2,1]-1.96*sqrt(V[2,2])
matrix agefig3[3,3] = agefig3[3,1]-1.96*sqrt(V[3,3])
matrix agefig3[4,3] = agefig3[4,1]-1.96*sqrt(V[4,4])
matrix agefig3[5,3] = agefig3[5,1]-1.96*sqrt(V[5,5])
matrix agefig3[6,3] = agefig3[6,1]-1.96*sqrt(V[6,6])
matrix agefig3[7,3] = agefig3[7,1]-1.96*sqrt(V[7,7])
matrix agefig3[8,3] = agefig3[8,1]-1.96*sqrt(V[8,8])
matrix agefig3[9,3] = agefig3[9,1]-1.96*sqrt(V[9,9])

matrix list agefig3
coefplot (matrix(agefig1[,1]), ci((agefig1[,2] agefig1[,3]))) (matrix(agefig3[,1]), ci((agefig3[,2] agefig3[,3]))), ytitle(Annual Firm Death Rate) xtitle("Firm Age (Years)") vertical recast(connected) scheme(s1mono) ciopts(recast(rcap)) title("A. Death Over 1 Year by Firm Age") legend(label(2 "Firm Died") label(4 "No longer self-employed")) offset(0) name(F10A)
 
***** Firm death over time horizon *****
gen year1=years>0 & years<=0.5
gen year2=years>0.5 & years<=1
gen year3=years>1 & years<=1.5
gen year4=years>1.5 & years<=2
gen year5=years>2 & years<=3
gen year6=years>3 & years<=4
gen year7=years>4 & years<=5
gen year8=years>5 & years<=6
gen year9=years>6 & years<=7
gen year10=years>7 & years<=10
gen year11=years>10 & years~=.  

* keep sample same
gen samp1=died~=. & selfemp~=. & years~=.

* cumulative death rate for original firm dying
xi: reg died year1 year2 year3 year4 year5 year6 year7 year8 year9 year10 year11 i.surveydummy if years~=. & samp1==1, noc cluster(firmid) r 
sum died if year1==1 & e(sample)

matrix yearfig1 = J(11, 3, .)
matrix coln yearfig1 = beta l95 u95
matrix rown yearfig1 = "<=0.5" "0.5to1" "1to1.5" "1.5to2" "3" "4" "5" "6" "7" "7to10" "11+"
matrix yearfig1[1,1] = _b[year1]+(r(mean)-_b[year1])
matrix yearfig1[2,1] = _b[year2] + (r(mean)-_b[year1])
matrix yearfig1[3,1] = _b[year3] + (r(mean)-_b[year1])
matrix yearfig1[4,1] = _b[year4] + (r(mean)-_b[year1])
matrix yearfig1[5,1] = _b[year5] + (r(mean)-_b[year1])
matrix yearfig1[6,1] = _b[year6] + (r(mean)-_b[year1])
matrix yearfig1[7,1] = _b[year7] + (r(mean)-_b[year1])
matrix yearfig1[8,1] = _b[year8] + (r(mean)-_b[year1])
matrix yearfig1[9,1] = _b[year9] + (r(mean)-_b[year1])
matrix yearfig1[10,1] =_b[year10] + (r(mean)-_b[year1])
matrix yearfig1[11,1] =_b[year11] + (r(mean)-_b[year1])

mat V=e(V) 
matrix yearfig1[1,2] = yearfig1[1,1]+1.96*sqrt(V[1,1])
matrix yearfig1[2,2] = yearfig1[2,1]+1.96*sqrt(V[2,2])
matrix yearfig1[3,2] = yearfig1[3,1]+1.96*sqrt(V[3,3])
matrix yearfig1[4,2] = yearfig1[4,1]+1.96*sqrt(V[4,4])
matrix yearfig1[5,2] = yearfig1[5,1]+1.96*sqrt(V[5,5])
matrix yearfig1[6,2] = yearfig1[6,1]+1.96*sqrt(V[6,6])
matrix yearfig1[7,2] = yearfig1[7,1]+1.96*sqrt(V[7,7])
matrix yearfig1[8,2] = yearfig1[8,1]+1.96*sqrt(V[8,8])
matrix yearfig1[9,2] = yearfig1[9,1]+1.96*sqrt(V[9,9])
matrix yearfig1[10,2] = yearfig1[10,1]+1.96*sqrt(V[10,10])
matrix yearfig1[11,2] = yearfig1[11,1]+1.96*sqrt(V[11,11])

matrix yearfig1[1,3] = yearfig1[1,1]-1.96*sqrt(V[1,1])
matrix yearfig1[2,3] = yearfig1[2,1]-1.96*sqrt(V[2,2])
matrix yearfig1[3,3] = yearfig1[3,1]-1.96*sqrt(V[3,3])
matrix yearfig1[4,3] = yearfig1[4,1]-1.96*sqrt(V[4,4])
matrix yearfig1[5,3] = yearfig1[5,1]-1.96*sqrt(V[5,5])
matrix yearfig1[6,3] = yearfig1[6,1]-1.96*sqrt(V[6,6])
matrix yearfig1[7,3] = yearfig1[7,1]-1.96*sqrt(V[7,7])
matrix yearfig1[8,3] = yearfig1[8,1]-1.96*sqrt(V[8,8])
matrix yearfig1[9,3] = yearfig1[9,1]-1.96*sqrt(V[9,9])
matrix yearfig1[10,3] = yearfig1[10,1]-1.96*sqrt(V[10,10])
matrix yearfig1[11,3] = yearfig1[11,1]-1.96*sqrt(V[11,11])
matrix list yearfig1

* cumulative death rate for no longer self-employed
xi: reg selfemp year1 year2 year3 year4 year5 year6 year7 year8 year9 year10 year11 i.surveydummy if years~=. & samp1==1, noc cluster(firmid) r 
sum selfemp if year1==1 & e(sample)

matrix yearfig2 = J(11, 3, .)
matrix coln yearfig2 = beta l95 u95
matrix rown yearfig2 = "<=0.5" "0.5to1" "1to1.5" "1.5to2" "3" "4" "5" "6" "7" "7to10" "11+"
matrix yearfig2[1,1] = _b[year1]+(r(mean)-_b[year1])
matrix yearfig2[2,1] = _b[year2] + (r(mean)-_b[year1])
matrix yearfig2[3,1] = _b[year3] + (r(mean)-_b[year1])
matrix yearfig2[4,1] = _b[year4] + (r(mean)-_b[year1])
matrix yearfig2[5,1] = _b[year5] + (r(mean)-_b[year1])
matrix yearfig2[6,1] = _b[year6] + (r(mean)-_b[year1])
matrix yearfig2[7,1] = _b[year7] + (r(mean)-_b[year1])
matrix yearfig2[8,1] = _b[year8] + (r(mean)-_b[year1])
matrix yearfig2[9,1] = _b[year9] + (r(mean)-_b[year1])
matrix yearfig2[10,1] =_b[year10] + (r(mean)-_b[year1])
matrix yearfig2[11,1] =_b[year11] + (r(mean)-_b[year1])

mat V=e(V) 
matrix yearfig2[1,2] = yearfig2[1,1]+1.96*sqrt(V[1,1])
matrix yearfig2[2,2] = yearfig2[2,1]+1.96*sqrt(V[2,2])
matrix yearfig2[3,2] = yearfig2[3,1]+1.96*sqrt(V[3,3])
matrix yearfig2[4,2] = yearfig2[4,1]+1.96*sqrt(V[4,4])
matrix yearfig2[5,2] = yearfig2[5,1]+1.96*sqrt(V[5,5])
matrix yearfig2[6,2] = yearfig2[6,1]+1.96*sqrt(V[6,6])
matrix yearfig2[7,2] = yearfig2[7,1]+1.96*sqrt(V[7,7])
matrix yearfig2[8,2] = yearfig2[8,1]+1.96*sqrt(V[8,8])
matrix yearfig2[9,2] = yearfig2[9,1]+1.96*sqrt(V[9,9])
matrix yearfig2[10,2] = yearfig2[10,1]+1.96*sqrt(V[10,10])
matrix yearfig2[11,2] = yearfig2[11,1]+1.96*sqrt(V[11,11])

matrix yearfig2[1,3] = yearfig2[1,1]-1.96*sqrt(V[1,1])
matrix yearfig2[2,3] = yearfig2[2,1]-1.96*sqrt(V[2,2])
matrix yearfig2[3,3] = yearfig2[3,1]-1.96*sqrt(V[3,3])
matrix yearfig2[4,3] = yearfig2[4,1]-1.96*sqrt(V[4,4])
matrix yearfig2[5,3] = yearfig2[5,1]-1.96*sqrt(V[5,5])
matrix yearfig2[6,3] = yearfig2[6,1]-1.96*sqrt(V[6,6])
matrix yearfig2[7,3] = yearfig2[7,1]-1.96*sqrt(V[7,7])
matrix yearfig2[8,3] = yearfig2[8,1]-1.96*sqrt(V[8,8])
matrix yearfig2[9,3] = yearfig2[9,1]-1.96*sqrt(V[9,9])
matrix yearfig2[10,3] = yearfig2[10,1]-1.96*sqrt(V[10,10])
matrix yearfig2[11,3] = yearfig2[11,1]-1.96*sqrt(V[11,11])
matrix list yearfig2

coefplot (matrix(yearfig1[,1]), ci((yearfig1[,2] yearfig1[,3])))  (matrix(yearfig2[,1]), ci((yearfig2[,2] yearfig2[,3]))), ytitle(Cumulative Firm Death Rate) xtitle("Time Horizon (Years)") vertical recast(connected) scheme(s1mono) ciopts(recast(rcap)) title("B. Death by Time Horizon") legend(label(2 "Firm Died") label(4 "No longer self-employed")) offset(0) name(F10B)

graph combine F10A F10B, ysize(2) graphregion(fcolor(white))
graph save "Figures/Figure10", replace

********************************************************************************
**TABLES

********************************************************************************
**Table 2. Summary statistics on firms

use "CombinedMaster_RH.dta", clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

*for Uganda, only the study participants who opened a business, have an id, and they are those we want to have in the regression, so I drop the others
drop if country=="Uganda" & firmid=="."

*generate id that is unique (for Thailand and Nigeria) to be able to reshape the data:
g firmidfrs=firmid
replace firmidfrs=firmid+"-"+survey if country=="Thailand" | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012"))

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

*replace profit outliers to missing
levelsof surveyname , local(svyname) 
foreach x of local svyname{
forvalues i=1/17{
su profits if (surveyname=="`x'" & wave==`i' ), detail
replace profits=. if (surveyname=="`x'" & wave==`i'  ) & (profits>r(p99) | profits<r(p1))
}
}

gen anypaidemployee=cond(employees>0,1,0) if employees~=.

mat y = J(11,6,.)	
local j=1
foreach var of varlist female ownerage ownertertiary agefirm sales profits anypaidemployee employees retail manuf services {
sum `var', de
mat y[`j',1]=r(N)
mat y[`j',2]=r(mean)
mat y[`j',3]=r(sd)
mat y[`j',4]=r(p10)
mat y[`j',5]=r(p50)
mat y[`j',6]=r(p90)
local j=`j'+1
}
mat rownames y = female ownerage ownertertiary agefirm sales profits anypaidemployee employees retail manuf services
mat colnames y = "Nobs" "Mean" "SD" "10th" "Median" "90th"

mat2txt, matrix(y) saving("Tables/Table2_PanelA.xls") replace


local i=1

foreach var1 of varlist retail manuf services {

mat y`i' = J(8,6,.)	
local j=1
foreach var of varlist female ownerage ownertertiary agefirm sales profits anypaidemployee employees {
sum `var' if `var1'==1, de
mat y`i'[`j',1]=r(N)
mat y`i'[`j',2]=r(mean)
mat y`i'[`j',3]=r(sd)
mat y`i'[`j',4]=r(p10)
mat y`i'[`j',5]=r(p50)
mat y`i'[`j',6]=r(p90)
local j=`j'+1
}
mat rownames y`i' = female ownerage ownertertiary agefirm sales profits anypaidemployee employees
mat colnames y`i' = "Nobs" "Mean" "SD" "10th" "Median" "90th"

local i=`i'+1
}

mat2txt, matrix(y1) format(%12.2fc) saving("Tables/Table2_PanelB.xls.") replace

mat2txt, matrix(y2) format(%12.2fc) saving("Tables/Table2_PanelC.xls") replace

mat2txt, matrix(y3) format(%12.2fc) saving("Tables/Table2_PanelD.xls") replace


********************************************************************************
**Table 3. Multivariate Correlates of Firm Death

restore

gen ownerage2=ownerage^2
gen d_educyears=educyears==.
gen ednyears=educyears
replace ednyears=0 if d_educyears==1
gen topcodeemp=employees
replace topcodeemp=10 if employees>10 & employees~=.

* scale age squared 
replace ownerage2=ownerage2/1000

*** column 1: OLS *************************
#delimit ;
xi: reg died age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared 
topcodeemp  logprofits d_logprofits sect1 sect2 ownerage ownerage2 female ednyears d_educyears 
i.surveydummy if agefirm~=., cluster(firmid) r;
outreg2 using "Tables/Table3.xls", replace excel label ctitle((1)) drop(_Isurveydum* d_*);
#delimit cr
*** Column 2 and 3: Bounds - assume all attrit are dead, or all are alive
cap drop died1 died2
gen died1=died
replace died1=1 if attrit~=. & died==.
gen died2=died
replace died2=0 if attrit~=. & died==.
#delimit ;
xi: reg died1 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared 
topcodeemp  logprofits d_logprofits sect1 sect2 ownerage ownerage2 female ednyears d_educyears 
i.surveydummy if agefirm~=., cluster(firmid) r;
outreg2 using "Tables/Table3.xls", append excel label ctitle((2)) drop(_Isurveydum* d_*);
xi: reg died2 age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared 
topcodeemp  logprofits d_logprofits sect1 sect2 ownerage ownerage2 female ednyears d_educyears 
i.surveydummy if agefirm~=., cluster(firmid) r;
outreg2 using "Tables/Table3.xls", append excel label ctitle((3)) drop(_Isurveydum* d_*);
*** Column 4: Any Business Operating
#delimit ;
cap drop selfemp;
gen selfemp=1-anyfirm;
#delimit ;
xi: reg selfemp age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared 
topcodeemp  logprofits d_logprofits sect1 sect2 ownerage ownerage2 female ednyears d_educyears 
i.surveydummy if agefirm~=., cluster(firmid) r;
outreg2 using "Tables/Table3.xls", append excel label ctitle((4)) drop(_Isurveydum* d_*);
#delimit cr


*** Robustness to Functional Form (Probit) **********************
#delimit ;
probit died age1to2 age3to4 age5to6 age7to8 age9to10 age11to12 age13to15 age16plus years yearssquared 
topcodeemp  logprofits d_logprofits sect1 sect2 ownerage ownerage2 female ednyears d_educyears 
i.surveydummy if agefirm~=., cluster(firmid) r;
margins, dydx(*) post;
outreg2 using "Tables/Table3.xls", append excel label ctitle((5)) drop(_Isurveydum* d_*);
#delimit cr
erase "Tables/Table3.txt"

********************************************************************************
**Table 4. Cause of firm death and main activity of owner after firm death

use CombinedMaster_RH, clear
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"
							
g reasonclosure_4yrs=.
g reasonclosure_4p5yrs=.
							
foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs 3p5yrs 4yrs 4p5yrs 5yrs 5p5yrs 6yrs 8yrs 10yrs 11yrs 15yrs{

replace reasonclosure_`p'=1 if reasonforclosure_`p'==1 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=2 if reasonforclosure_`p'==2 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=4 if reasonforclosure_`p'==3 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=3 if reasonforclosure_`p'==4 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=10 if reasonforclosure_`p'==5 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=9 if reasonforclosure_`p'==6 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=5 if reasonforclosure_`p'==12 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"

label values reasonclosure_`p' closereason

*Only for closures we count (I checked and results do not change if we look at all closures)
g reasonclosure_blbus_`p'=reasonclosure_`p'*(1-survival_`p')
replace reasonclosure_blbus_`p'=. if reasonclosure_blbus_`p'==0

g mainactivityafterblbus_`p'=mainactivity_`p'*(1-survival_`p')
replace mainactivityafterblbus_`p'=. if mainactivityafterblbus_`p'==0
}

*I EXCLUDE EGYPT BECAUSE THE CODING IS DIFFERENT

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

*for Uganda, only the study participants who opened a business, have an id, and they are those we want to have in the regression, so I drop the others
drop if country=="Uganda" & firmid=="."

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

keep reasonclosure_blbus_* mainactivityafterblbus_* surveyname
g fakeidforreshape=_n
reshape long reasonclosure_blbus mainactivityafterblbus, i(fakeidforreshape) j(p) string
label values reasonclosure_blbus closereason
label values  mainactivityafterblbus mainactivity
logout, save("Tables/Table4_Cols1-2.xls") excel replace: tab reasonclosure_blbus if surveyname!="EGYPTMACROINS"

logout, save("Tables/Table4_Cols3-8.xls") excel replace: tab reasonclosure_blbus mainactivityafterblbus if surveyname!="EGYPTMACROINS", m

erase "Tables/Table4_Cols1-2.txt"
erase "Tables/Table4_Cols3-8.txt"


********************************************************************************
**Table 5. Changes in Labor Earnings Associated with Firm Death

use "Preparation of Data for Figures/Data for figures/laborincome_diedsurvivedint_clr.dta", clear

g sclrgroups=1 if newsurvival==1
replace sclrgroups=2 if newsurvival==0 & newreasonclosure==1
replace sclrgroups=3 if (newreasonclosure==2 | newreasonclosure==3)
replace sclrgroups=4 if (newreasonclosure==4 | newreasonclosure==10)

g mainactivitygroups=0 if newsurvival==1
replace mainactivitygroups=newmainactivity if mainactivitygroups!=0

egen svyname = group(surveyname)
egen countrydummy=group(country)

g newdeath=1-newsurvival

g logprofits=log(profits+1)

g changeinlaborincome=laborincome_ - profits

g changeinlaborincomelogs=loglaborincome - logprofits

foreach var of varlist changeinlaborincome changeinlaborincomelogs{
su `var', detail
replace `var'=. if `var'<= `r(p1)' |  `var'>= `r(p99)'
}

reg changeinlaborincome newdeath  i.svyname, cluster(firmid)
outreg2 using "Tables/Table5_PanelA.xls", excel replace dec(4)	

g makingaloss=(sclrgroups==2)
g illnessfamily=(sclrgroups==3)
g betteropportunities=(sclrgroups==4)

reg changeinlaborincome newdeath i.svyname if (makingaloss==1 | newsurvival==1), cluster(firmid)
outreg2 using "Tables/Table5_PanelA.xls", excel append dec(4)	

reg changeinlaborincome newdeath i.svyname if (illnessfamily==1 | newsurvival==1), cluster(firmid)
outreg2 using "Tables/Table5_PanelA.xls", excel append dec(4)	
	
reg changeinlaborincome newdeath i.svyname if (betteropportunities==1 | newsurvival==1), cluster(firmid)
outreg2 using "Tables/Table5_PanelA.xls", excel append dec(4)	

g died=0 if newdeath==0
replace died=1 if	(surveyname=="BENINFORM" & ((newwave==2 & survival_1yr==0) | (newwave==3 & survival_1yr==1 & survival_2yrs==0))) ///
				|   (surveyname=="KENYAGETAHEAD" & ((newwave==2 & survival_1yr==0) | (newwave==3 & survival_1yr==1 & survival_30mths==0))) ///
				|	(surveyname=="MALAWIFORM" & ((newwave==2 & survival_1yr==0) | (newwave==3 & survival_1yr==1 & survival_1p75yrs==0) | (newwave==4 & survival_1yr==1 & survival_1p75yrs==1 & survival_3yrs==0) | (newwave==5 & survival_1yr==1 & survival_1p75yrs==1 & survival_3yrs==1 & survival_3p5yrs==0))) ///
				|	(surveyname=="NGYOUWIN" & ((newwave==2 & survival_1yr==0) | (newwave==3 & survival_1yr==1 & survival_1p75yrs==0) | (newwave==4 & survival_1yr==1 & survival_1p75yrs==1 & survival_3p5yrs==0)))	///
				|	(surveyname=="SLKFEMBUSTRAINING" & ((newwave==2 & survival_3mths==0)  | (newwave==3 & survival_1yr==0)  | (newwave==4 & survival_1yr==1 & survival_1p75yrs==0))) ///
				|	(surveyname=="SLLSE" & ((newwave==2 & survival_6mths==0) | (newwave==3 & survival_1yr==0) | (newwave==4 & survival_6mths==1 & survival_18mths==0) | (newwave==5 & survival_1yr==1 & survival_2yrs==0) | (newwave==6 & survival_18mths==1 & survival_30mths==0) | (newwave==7 & survival_2yrs==1 & survival_3yrs==0) | (newwave==8 & survival_30mths==1 & survival_3p5yrs==0) | (newwave==9 & survival_3yrs==1 & survival_4yrs==0) | (newwave==10 & survival_3p5yrs==1 & survival_4p5yrs==0) | (newwave==11 & survival_4p5yrs==1 & survival_5p5yrs==0))) ///
				| 	(surveyname=="SLMS" & ((newwave==2 & survival_3mths==0) | (newwave==3 & survival_6mths==0) | (newwave==4 & survival_9mths==0) | (newwave==5 & survival_1yr==0) | (newwave==6 & survival_3mths==1 & survival_1p25yrs==0) |  (newwave==7 & survival_6mths==1 & survival_18mths==0) |  (newwave==8 & survival_9mths==1 & survival_1p75yrs==0) |  (newwave==9 & survival_1yr==1 & survival_2yrs==0) |  (newwave==10 & survival_18mths==1 & survival_30mths==0) | (newwave==11 & survival_2yrs==1 & survival_3yrs==0)))
				

replace died=2 if	(surveyname=="BENINFORM" & (newwave==3 & survival_1yr==0 & survival_2yrs==0)) ///
				|	(surveyname=="MALAWIFORM" & ((newwave==3 & survival_1yr==0 & survival_1p75yrs==0) | (newwave==4 & survival_1yr==1 & survival_1p75yrs==0 & survival_3yrs==0) | (newwave==5 & survival_1yr==1 & survival_1p75yrs==1 & survival_3yrs==0 & survival_3p5yrs==0))) ///
				|	(surveyname=="NGYOUWIN" & ((newwave==3 & survival_1yr==0 & survival_1p75yrs==0) | (newwave==4 & survival_1yr==1 & survival_1p75yrs==0 & survival_3p5yrs==0))) ///
				|	(surveyname=="SLKFEMBUSTRAINING" & ((newwave==4 & survival_3mths==1 & survival_1yr==0 & survival_1p75yrs==0))) ///
				|	(surveyname=="SLLSE" & ((newwave==4 & survival_6mths==0 & survival_18mths==0) | (newwave==5 & survival_1yr==0 & survival_2yrs==0) | (newwave==6 & survival_6mths==1 & survival_18mths==0 & survival_30mths==0) | (newwave==7 & survival_1yr==1 & survival_2yrs==0 & survival_3yrs==0) | (newwave==8 &  survival_18mths==1 & survival_30mths==0 & survival_3p5yrs==0) | (newwave==9 & survival_2yrs==1 & survival_3yrs==0 & survival_4yrs==0) | (newwave==10 & survival_30mths==1 & survival_3p5yrs==0 & survival_4p5yrs==0) | (newwave==11 & survival_3p5yrs==1 & survival_4p5yrs==0 & survival_5p5yrs==0))) ///
				| 	(surveyname=="SLMS" & ((newwave==6 & survival_3mths==0 & survival_1p25yrs==0) |  (newwave==7 & survival_6mths==0 & survival_18mths==0) |  (newwave==8 & survival_9mths==0 & survival_1p75yrs==0) |  (newwave==9 & survival_1yr==0 & survival_2yrs==0) |  (newwave==10 & survival_6mths==1 & survival_18mths==0 & survival_30mths==0) | (newwave==11 & survival_1yr==1 & survival_2yrs==0 & survival_3yrs==0)))
								
replace died=3 if	(surveyname=="MALAWIFORM" & ((newwave==4 & survival_1yr==0 & survival_1p75yrs==0 & survival_3yrs==0) | (newwave==5 & survival_1yr==1 & survival_1p75yrs==0 & survival_3yrs==0 & survival_3p5yrs==0))) ///
				|	(surveyname=="NGYOUWIN" & (newwave==4 & survival_1yr==0 & survival_1p75yrs==0 & survival_3p5yrs==0)) ///
				|	(surveyname=="SLLSE" & ((newwave==6 & survival_6mths==0 & survival_18mths==0 & survival_30mths==0) | (newwave==7 & survival_1yr==0 & survival_2yrs==0 & survival_3yrs==0) | (newwave==8 &  survival_18mths==0 & survival_30mths==0 & survival_3p5yrs==0) | (newwave==9 & survival_2yrs==0 & survival_3yrs==0 & survival_4yrs==0) | (newwave==10 & survival_30mths==0 & survival_3p5yrs==0 & survival_4p5yrs==0) | (newwave==11 & survival_3p5yrs==0 & survival_4p5yrs==0 & survival_5p5yrs==0))) ///
				| 	(surveyname=="SLMS" & ((newwave==10 & survival_6mths==0 & survival_18mths==0 & survival_30mths==0) | (newwave==11 & survival_1yr==0 & survival_2yrs==0 & survival_3yrs==0)))
								
reg changeinlaborincome i.died i.svyname, cluster(firmid)
outreg2 using "Tables/Table5_PanelB.xls", excel replace dec(4)	
							
reg changeinlaborincome i.died i.svyname if (makingaloss==1 | newsurvival==1), cluster(firmid)
outreg2 using "Tables/Table5_PanelB.xls", excel append dec(4)	

reg changeinlaborincome i.died i.svyname if (illnessfamily==1 | newsurvival==1), cluster(firmid)
outreg2 using "Tables/Table5_PanelB.xls", excel append dec(4)	

reg changeinlaborincome i.died i.svyname if (betteropportunities==1 | newsurvival==1), cluster(firmid)
outreg2 using "Tables/Table5_PanelB.xls", excel append dec(4)	

erase "Tables/Table5_PanelA.txt"
erase "Tables/Table5_PanelB.txt"


********************************************************************************
**APPENDIX

********************************************************************************
**Table A.2 Firm death rates over different time horizons, pooled sample and individual surveys
use "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_RH.dta", clear

*For survey specific death rates and bounds over different time horizons
keep surveyname deathrate lowb_deathrate uppb_deathrate years
replace surveyname="NGLSMSISA" if surveyname=="NGLSMS-ISA"
reshape wide deathrate lowb_deathrate uppb_deathrate, i(years) j(surveyname) string

export excel using "Appendix Tables and Figures/TableA2.xls", firstrow(variables) replace

*For pooled death rates and bounds
use "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_RH.dta", clear
keep died survived missing *totalfirmobs years
collapse (sum) died survived missing b_totalfirmobs totalfirmobs, by(years)

g deathrate=died/(died+survived)
g lowb_deathrate=died/(died+survived+missing)
g uppb_deathrate=(died+missing)/(died+survived+ missing)

keep deathrate lowb_deathrate uppb_deathrate years

export excel using "Appendix Tables and Figures/TableA2_pooled.xls", firstrow(variables) replace


********************************************************************************
**Table A.5 Attrition and missing information on survival by follow-up horizon
use CombinedMaster_RH, clear

g baseline=(substr(survey,1,2)=="BL")
keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

*for Uganda, only the study participants who opened a business, have an id, and they are those we want to have in the regression, so I drop the others
drop if country=="Uganda" & firmid=="."

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

*Attrition rates
matrix A=J(27,3,.)
mat rownames A= 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs 3p5yrs 4yrs 4p5yrs 5yrs 5p5yrs 6yrs 7yrs 8yrs 9yrs 10yrs 11yrs 12yrs 13yrs 14yrs 15yrs 16yrs 17yrs
mat colnames A= Attrited MissSurv AllMissings
local j=1

foreach x in _3mths _6mths _9mths _1yr _1p25yrs _18mths _1p75yrs _2yrs _30mths _3yrs _3p5yrs _4yrs _4p5yrs _5yrs _5p5yrs _6yrs _7yrs _8yrs _9yrs _10yrs _11yrs _12yrs _13yrs _14yrs _15yrs _16yrs _17yrs{
bysort surveyname: egen inround`x'=total(survival`x'), m
g actualattrit`x'=attrit`x'
replace actualattrit`x'=0 if attrit`x'==1 & survival`x'!=.
su actualattrit`x' if inround`x'!=.
mat A[`j',1]=`r(mean)'
g missingsurvival`x'=(survival`x'==. & inround`x'!=. & attrit`x'==0)
su missingsurvival`x' if inround`x'!=.
mat A[`j',2]=`r(mean)'
g allmissings`x'= actualattrit`x'
replace allmissings`x'=1 if missingsurvival`x'==1 
su allmissings`x' if inround`x'!=.
mat A[`j',3]=`r(mean)'
local j=`j'+1
}

clear
svmat2 A, n(col) rnames(variable)

order variable

rename variable fuperiod

export excel using "Appendix Tables and Figures/TableA5.xls", firstrow(variables) replace


********************************************************************************
**Table A.6 Reason for closure by gender and
**Table A.7 Gender of owner by reason of closure
use CombinedMaster_RH, clear
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"
							
g reasonclosure_4yrs=.
g reasonclosure_4p5yrs=.
							
foreach p in 3mths 6mths 9mths 1yr 1p25yrs 18mths 1p75yrs 2yrs 30mths 3yrs 3p5yrs 4yrs 4p5yrs 5yrs 5p5yrs 6yrs 8yrs 10yrs 11yrs 15yrs{

replace reasonclosure_`p'=1 if reasonforclosure_`p'==1 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=2 if reasonforclosure_`p'==2 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=4 if reasonforclosure_`p'==3 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=3 if reasonforclosure_`p'==4 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=10 if reasonforclosure_`p'==5 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=9 if reasonforclosure_`p'==6 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"
replace reasonclosure_`p'=5 if reasonforclosure_`p'==12 & country=="Sri Lanka" & surveyname=="SLLSE" & survey=="BL-2008"

label values reasonclosure_`p' closereason

*Only for closures we count (I checked and results do not change if we look at all closures)
g reasonclosure_blbus_`p'=reasonclosure_`p'*(1-survival_`p')
replace reasonclosure_blbus_`p'=. if reasonclosure_blbus_`p'==0

}

*I EXCLUDE EGYPT BECAUSE THE CODING IS DIFFERENT

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

*for Uganda, only the study participants who opened a business, have an id, and they are those we want to have in the regression, so I drop the others
drop if country=="Uganda" & firmid=="."

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

drop if surveyname=="TTHAI" | surveyname=="NGLSMS-ISA"

keep reasonclosure_blbus_*  surveyname female
g fakeidforreshape=_n
reshape long reasonclosure_blbus, i(fakeidforreshape) j(p) string
label values reasonclosure_blbus closereason

logout, save("Appendix Tables and Figures/TablesA6andA7.xls") excel replace: tab reasonclosure_blbus female if surveyname!="EGYPTMACROINS", m

erase "Appendix Tables and Figures/TablesA6andA7.txt"


********************************************************************************
**Figure A.1 Comparison of our firm death rates to those reported in existing literature
clear
import excel "Preparation of Data for Figures/Data for figures/FirmDeathRatesExistingLiterature.xlsx", sheet("A1 for Stata") firstrow
append using "Preparation of Data for Figures/Data for figures/Combdeathrates_uncond_RH.dta"

g fromotherstudies=(study!="")

twoway	scatter deathrate years if fromotherstudies==1 & years<=10, mcolor(gs5) || ///
		scatter deathrate years if fromotherstudies==0 & years<=10, mcolor(gs10) msymbol(Dh) || ///
		(qfit deathrate years if fromotherstudies==0 & years<=10, lcolor(gs10)) ///
		, legend(off) xtick(0(0.5)10) xlabel(0(1)10) ytitle(Death rate) xtitle(Years since baseline) graphregion(fcolor(white))

graph save "Appendix Tables and Figures/FigureA1", replace

********************************************************************************
**Figure A.2 Reopening rate over different horizons for firms that closed within 1 year

local p_4="1yr" 
local p_5="1p25yrs" 
local p_6="18mths" 
local p_7="1p75yrs" 
local p_8="2yrs" 
local p_9="30mths" 
local p_10="3yrs" 
local p_11="3p5yrs" 
local p_12="4yrs" 
local p_13="4p5yrs"
local p_14="5yrs" 
local p_15="5p5yrs" 
local p_16="6yrs" 
local p_17="7yrs" 
local p_18="8yrs" 
local p_19="9yrs" 
local p_20="10yrs" 
local p_21="11yrs" 
local p_22="12yrs" 
local p_23="13yrs" 
local p_24="14yrs" 
local p_25="15yrs" 
local p_26="16yrs" 
local p_27="17yrs"

forvalues j=4/27{				
			
use "Preparation of Data for Figures/Data for figures/CombinedMaster_RH_for_opnewfirm", clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

levelsof surveyname if survival_1yr!=. & survival_`p_`j''!=., local(svyname) 

foreach x of local svyname{ 

use "Preparation of Data for Figures/Data for figures/CombinedMaster_RH_for_opnewfirm", clear

*keep only the baseline observations, i.e. drop the observations that are purely follow-up observations
*and for data coming from IEs: keep only observations from the control groups

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

keep if baseline==1 

*drop observations coming from IE data that are not from the control group
drop if control==0

replace surveyname="IFLS" if country=="Indonesia"
replace surveyname="MXFLS" if country=="Mexico"
replace surveyname="NGLSMS-ISA" if country=="Nigeria" & surveyname=="" 
replace surveyname="TTHAI" if country=="Thailand"
replace surveyname="UGWINGS" if country=="Uganda" 

count if survival_1yr==0 & surveyname=="`x'" & operatingnewfirm_`p_`j''==1
mat help1=`r(N)'
count if survival_1yr==0 & surveyname=="`x'" & operatingnewfirm_`p_`j''==0
mat help1=help1, `r(N)'
count if survival_1yr==0 & surveyname=="`x'" & operatingnewfirm_`p_`j''==.
mat help1=help1, `r(N)'
mat reopeningrates=help1[1,1] , help1[1,2] , help1[1,3] 
mat colnames reopeningrates=openednew remclosed missing

svmat reopeningrates, names(col)

keep openednew-missing
keep in 1

g b_totalfirmobs=openednew+remclosed+missing

g totalfirmobs=openednew+remclosed

g dperiod="1yr"

g operiod="`p_`j''"

g surveyname="`x'"

save "Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_`p_`j''_`x'.dta", replace
}
}

use "Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_17yrs_TTHAI.dta",clear
append using 	"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_16yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_15yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_14yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_13yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_12yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_11yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_11yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_10yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_10yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_9yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_8yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_7yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_6yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_6yrs_SLKFEMBUSTRAINING.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_5p5yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_5p5yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_5yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_5yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_4p5yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_4yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_4yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3p5yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3p5yrs_NGYOUWIN.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3p5yrs_MALAWIFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3yrs_MALAWIFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_30mths_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_30mths_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_30mths_KENYAGETAHEAD.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_2yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_2yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_2yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_2yrs_BENINFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p75yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p75yrs_SLKFEMBUSTRAINING.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p75yrs_NGYOUWIN.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p75yrs_MALAWIFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_18mths_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_18mths_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p25yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p25yrs_GHANAFLYP.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_SLKFEMBUSTRAINING.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_NGYOUWIN.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_MALAWIFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_KENYAGETAHEAD.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_GHANAFLYP.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_BENINFORM.dta"
				
				
g years=1 if operiod=="1yr"
replace years=1.25 if operiod=="1p25yrs"
replace years=1.5 if operiod=="18mths"
replace years=1.75 if operiod=="1p75yrs"
replace years=2 if operiod=="2yrs"
replace years=2.5 if operiod=="30mths"
replace years=3 if operiod=="3yrs"
replace years=3.5 if operiod=="3p5yrs"
replace years=4 if operiod=="4yrs"
replace years=4.5 if operiod=="4p5yrs"
replace years=5 if operiod=="5yrs"
replace years=5.5 if operiod=="5p5yrs"
replace years=6 if operiod=="6yrs"
replace years=7 if operiod=="7yrs"
replace years=8 if operiod=="8yrs"
replace years=9 if operiod=="9yrs"
replace years=10 if operiod=="10yrs"
replace years=11 if operiod=="11yrs"
replace years=12 if operiod=="12yrs"
replace years=13 if operiod=="13yrs"
replace years=14 if operiod=="14yrs"
replace years=15 if operiod=="15yrs"
replace years=16 if operiod=="16yrs"
replace years=17 if operiod=="17yrs"
				
				
g reopeningrate=openednew/(openednew+remclosed)
g lowb_reopeningrate=openednew/(openednew+remclosed+missing)
g uppb_reopeningrate=(openednew+missing)/(openednew+remclosed+ missing)
				
save "Preparation of Data for Figures/Data for figures/reopening_clsd1yr_ALLbysurvey", replace
				

foreach x in TTHAI MALAWIFORM BENINFORM KENYAGETAHEAD NGYOUWIN{
twoway	(rcap lowb_reopeningrate uppb_reopeningrate years if survey=="`x'" & years<=3.5, lcolor(gs5)) || (scatter reopeningrate years if survey=="`x'" & years<=3.5, mcolor(gs5)) ///
		, legend(off) xtick(1(0.5)3.5) xlabel(1(1)3.5) title("`x'", color(black)) ytitle() xtitle(Years since baseline) graphregion(fcolor(white)) name(reop`x') 
		}

graph combine reopTTHAI reopMALAWIFORM reopBENINFORM reopKENYAGETAHEAD reopNGYOUWIN,  ycommon /*title("Reopening rate over different horizons, closure after 1 year")*/ graphregion(fcolor(white))

graph save "Appendix Tables and Figures/FigureA2", replace

foreach x in 	"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_17yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_16yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_15yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_14yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_13yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_12yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_11yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_11yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_10yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_10yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_9yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_8yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_7yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_6yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_6yrs_SLKFEMBUSTRAINING.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_5p5yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_5p5yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_5yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_5yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_4p5yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_4yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_4yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3p5yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3p5yrs_NGYOUWIN.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3p5yrs_MALAWIFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_3yrs_MALAWIFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_30mths_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_30mths_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_30mths_KENYAGETAHEAD.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_2yrs_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_2yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_2yrs_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_2yrs_BENINFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p75yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p75yrs_SLKFEMBUSTRAINING.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p75yrs_NGYOUWIN.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p75yrs_MALAWIFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_18mths_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_18mths_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p25yrs_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1p25yrs_GHANAFLYP.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_TTHAI.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_SLMS.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_SLLSE.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_SLKFEMBUSTRAINING.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_NGYOUWIN.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_MALAWIFORM.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_KENYAGETAHEAD.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_GHANAFLYP.dta" ///
				"Preparation of Data for Figures/Data for figures/Comb_cond_z_1yr_1yr_BENINFORM.dta"{
erase "`x'"
}


********************************************************************************
**Figure A.3 Annual Entry and Exit rates in Townsend Thai data, by survey year

use "CombinedMaster_RH.dta", clear

keep if country=="Thailand"

bysort firmid: egen minsvyyear=min(surveyyear)
bysort firmid: replace minsvyyear=minsvyyear==surveyyear

g newfirm=agefirm<=1 & minsvyyear==1

mat ees=J(17,5,.)
forvalues t=1997/2013{
local i=`t'-1996
local tp1=`t'+1

mat ees[`i',1]=`t'

*Entry, exit and survival (and attrition) from t to t+1
*exit
quietly count if surveyyear==`t' & survival_1yr==0 
mat ees[`i',2]=`r(N)'

*survival
quietly count if surveyyear==`t' & survival_1yr==1 
mat ees[`i',3]=`r(N)'

*entry of new firms (1 year or younger in t+1)
quietly count if surveyyear==`tp1' & newfirm==1 
mat ees[`i',4]=`r(N)'

*entry of new firms of owners who closed
quietly count if surveyyear==`t' & newfirmstarted_1yr==1 
mat ees[`i',4]=ees[`i',4]+`r(N)'

*attrition
quietly count if surveyyear==`t' & attrit_1yr==1 
mat ees[`i',5]=`r(N)'
}

mat colnames ees = t exit survival entry attrition

clear
svmat ees, names(col) 

egen total=rowtotal(exit-attrition)

foreach var in exit survival entry attrition{
g p`var'=`var'/total
su p`var'
}

graph hbar exit-attrition, percent stack over(t, gap(40)) blabel(bar,position(center) format(%3.1f) color(white) size(vsmall)) legend(label(1 "exit") label(2 "survival") label(3 "entry") label(4 "attrition")) title("Entry, Exit and Survival from t to t+1")
graph save "Appendix Tables and Figures/FigureA3", replace

********************************************************************************
**Figure A.4 Entry rates and Exit rates are correlated in Townsend Thai data
twoway scatter pentry pexit || lfit pentry pexit, legend(off) ytitle(Entry rate) xtitle(Exit rate) scheme(s1mono)
graph save "Appendix Tables and Figures/FigureA4", replace

reg pentry pexit

