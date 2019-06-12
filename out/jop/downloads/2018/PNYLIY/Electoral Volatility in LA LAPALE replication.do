********************************************************************
*	"ELECTORAL VOLATILITY IN LATIN AMERICA"
*	This do file replicates all analyses in the paper and appendix
*	Created using Stata 13.2
*	Contact: Mollie J. Cohen (mollie.cohen@gmail.com)
*	Last updated: 1/23/2018
********************************************************************
* 	Key variables from LAPALE: efncand ncand typea typea2pct 
*	typea5pct typea7pct typeb typeb2pct typeb5pct typeb7pct totvol 
*	totvol2 totvol5 totvol7 
*	Key variables from WB/ IDB: inflalog, exratelog, growth
********************************************************************

*****************************************************
*	CREATING VOLATILITY, EFN MEASURES USING LAPALE	*
*****************************************************

/*
The code below calculates EFNC/EFNP and volatility by election type
to replicate: 
1) run the below code for presidential elections and save; 
2) re-import the LAPALE data and run the following code for legislative elections;
3) append saved presidential election data to leg. results
*/

*Read in LAPALE data with voteshares from excel file: FRAGMENTATION DATASET FOR LA 01192018
clear all
import excel using "/FRAGMENTATION DATASET FOR LA - 01192018.xlsx", first

set more off

*renaming variables to use lower case
rename COUNTRY country
rename YEAR year
*generating numerical country, election type variables
encode country, gen(pais)
rename TYPE type
encode type, gen(elec_type)
*recoding the numerical "type" variable into pres. and leg. dummies
gen pres_elec=0
replace pres_elec=1 if elec_type==2
gen leg_elec=0
replace leg_elec=1 if elec_type==1

*********************
** EFN CALCULATION **
*********************

*keep if leg_elec==1
keep if pres_elec==1
xtset pais year

*reshaping the data to long format
gen id=_n
reshape long vote_share, i(id) j(vote)

*denominator for the EFNP/EFNC calculation: sum(voteshare^2)
gen vote_sharesq=vote_share^2
bys pais year: egen efndenom=sum(vote_sharesq)
*creating the EFNP/EFNC variable: 1/[sum(voteshare^2)]
gen efncand=1/efndenom

*creating the number of parties variable - sum of all ptys. that win >1 vote
gen pty=0
bys pais year: replace pty=1 if vote_share>=0
replace pty=0 if vote_share==0
by pais year: egen ncand=sum(pty)

*******************************************
** VOLATILITY CALCULATIONS, NO THRESHOLD **
*******************************************

*PARTY REPLACEMENT VOLATILITY
*TYPE A [replacement]=[abs[sum(exiting parties(t-1))]+[sum(entering parties(t))]]/2

*indicators for entry, exit, or stable competition
*a party is considered to compete if it wins more than 0 votes
gen compete=0
replace compete=1 if vote_share>0
*if a party does not compete at time t-1, but does at time t, it has entered
gen enter=0
sort pais vote year
by pais vote: replace enter=1 if compete==1 & compete[_n-1]==0
*if a party competes at time t-1 but not at time t, it has exited
gen exit=0
by pais vote: replace exit=1 if compete[_n-1]==1 & compete==0
*parties that compete at time t-1 and time t are "stable"
gen stable=0
by pais vote: replace stable=1 if compete[_n-1]==1 & compete==1

*exit volatility - the share of votes won at t-1 by exiting parties
by pais vote: gen vtexit=vote_share[_n-1] if exit==1
bys pais year: egen sumexit=sum(vtexit)

*enter volatility - the share of votes won at time t by entering parties
bys pais vote: gen vtenter=vote_share if enter==1
bys pais year: egen sumenter=sum(vtenter)

*type a - no threshold
*sum of all votes for entering/ exiting parties; take the absolute value; divide by 2
gen enterexitvt=sumexit+sumenter
gen absenterexitvt=abs(enterexitvt)
gen typea=absenterexitvt/2

*2pct threshold - repeat operations for parties winning >2% of vote
bys pais year: egen sumexit2=sum(vtexit) if vtexit>=0.02
bys pais year: egen sumenter2=sum(vtenter) if vtenter>=0.02

gen enterexit2=sumexit2+sumenter2
gen absenterexit2=abs(enterexit2)
gen typea2pct=absenterexit2/2

*5pct threshold - repeat operations for parties winning >5% of vote
bys pais year: egen sumexit5=sum(vtexit) if vtexit>=0.05
bys pais year: egen sumenter5=sum(vtenter) if vtenter>=0.05

gen enterexit5=sumexit5+sumenter5
gen absenterexit5=abs(enterexit5)
gen typea5pct=absenterexit5/2

*7pct threshold - repeat operations for parties winning >7% of vote
bys pais year: egen sumexit7=sum(vtexit) if vtexit>=0.07
bys pais year: egen sumenter7=sum(vtenter) if vtenter>=0.07

gen enterexit7=sumexit7+sumenter7
gen absenterexit7=abs(enterexit7)
gen typea7pct=absenterexit7/2


**********************************************
**		VOLATILITY AMONG STABLE PARTIES		**
**********************************************

*repeats the above operations for only those parties competing stably over time
*absolute value of changing vote shares by party
sort pais vote year
bys pais vote: gen diffstable=vote_share-vote_share[_n-1] if stable==1
gen abstdiffstable=abs(diffstable)

*generating type b [stable party]: [abs[sum(voteshare(t-1)-voteshare(t))]]/2
bys pais year: egen sumstablevt=sum(abstdiffstable)
gen typeb=sumstablevt/2

*2pct threshold - repeat operations for parties winning >2% of vote
sort pais vote year
bys pais vote: gen diffstable2=vote_share-vote_share[_n-1] if stable==1 & vote_share>=.02
gen abstdiffstable2=abs(diffstable2)

bys pais year: egen sumstablevt2=sum(abstdiffstable2)
gen typeb2pct=sumstablevt2/2

*5pct threshold - repeat operations for parties winning >5% of vote
sort pais vote year
bys pais vote: gen diffstable5=vote_share-vote_share[_n-1] if stable==1 & vote_share>=.05
gen abstdiffstable5=abs(diffstable5)

bys pais year: egen sumstablevt5=sum(abstdiffstable5)
gen typeb5pct=sumstablevt5/2

*7pct threshold - repeat operations for parties winning >7% of vote
sort pais vote year
bys pais vote: gen diffstable7=vote_share-vote_share[_n-1] if stable==1 & vote_share>=.07
gen abstdiffstable7=abs(diffstable7)

bys pais year: egen sumstablevt7=sum(abstdiffstable7)
gen typeb7pct=sumstablevt7/2

corr typeb typeb2pct typeb5pct typeb7pct

*dropping constituent measures
drop vtexit vtenter diffstable diffstable5 abstdiffstable5 diffstable7 abstdiffstable7 efndenom sumexit sumenter enterexitvt absenterexitvt sumexit2 sumenter2 enterexit2 absenterexit2 sumexit5 sumenter5 enterexit5 absenterexit5 sumexit7 sumenter7 enterexit7 absenterexit7 sumstablevt sumstablevt2 sumstablevt5 sumstablevt7
drop  compete enter exit stable vote_sharesq
drop abstdiffstable diffstable2 abstdiffstable2

*carrying forward missing volatility values
gsort id - typea2pct
carryforward typea2pct, gen(typea2)
gsort id - typea5pct
carryforward typea5pct, gen(typea5)
gsort id - typea7pct
carryforward typea7pct, gen(typea7)
drop typea2pct typea5pct typea7pct

*reshaping and saving data in wide format
reshape wide pty vote_share, i(id) j(vote)

*save leg and pres data separately prior to appending
save "/pres_elec_wide_01232018.dta", replace

*********************************************************
*	STOP AND REPEAT THE ABOVE CODE FOR LEG. ELECTIONS	*
*	THEN APPEND FILES FOR THE COMPLETE DATASET			*
*********************************************************

save "/leg_elec_wide_01232018.dta", replace
append using "/pres_elec_wide_01232018.dta"
save "/LAPALE_01232018.dta", replace

*********************************
*		cleaning up data		*
*********************************

*********************************************************
*	this section reorders, renames, and drops variables *
*	to make the condensed dataset used for analysis		*
*********************************************************

*reordering variables, dropping unneeded variables from reshapem and renaming variables
*the following creates a clean dataset that includes voteshares	
order id-country, alphabetic
drop pty1-pty99
order pais, first
order year elec_type pres_elec leg_elec, after(pais)
sort pais year elec_type
gen typea2pct=typea2
gen typea5pct=typea5
gen typea7pct=typea7
order typea2pct typea5pct typea7pct , after(typea)

drop typea2 typea5 typea7

*	generating measures of total volatility - replacement+stable	*
gen totvol=typea+typeb
gen totvol2=typea2pct+typeb2pct
gen totvol5=typea5pct+typeb5pct
gen totvol7=typea7pct+typeb7pct

order totvol totvol2 totvol5 totvol7, after(typeb7pct)
order id, last

*the following creates a reduced dataset excluding voteshares

drop vote_share1-vote_share99

save "/LAPALE_01232018_wide_novt.dta", replace

*********************************************
*	Set up for analysis presented in paper	*
*********************************************

*Merging election month/ year data with economic indicators from the world bank
use "/LAPALE_01232018_wide_novt.dta", clear
*merge election months
merge m:m pais year using "/months for merge.dta"
order month, after(year)
drop _merge
*merge inflation [from WB, 2016]
merge m:1 year pais using "/inflation_wb.dta"
drop _merge
*merge gdp per capita [from WB, 2016]
merge m:1 year pais using "/gdp growth per capita_wb.dta"
drop if month==.
drop _merge
*merge exchange rate [from IDB, ECLAC office, 2016]
merge m:1 year pais using "/exhange rate_idbeclac.dta"
drop if month==.
drop _merge

* dropping irrelevant observations
drop seriesname countrycode countryname
replace exrate=. if exrate==0

* using lagged variables as baseline
gen ninflation=inflationlag
gen growth=gdpper_growlag
gen nexrate=exratelag

*replacing with same year economic indicators if election in October-December
replace ninflation=inflation if month>=10
replace growth=gdpper_grow if month>=10
replace nexrate=exrate if month>=10

*generating logged variables for large values
gen inflalog=ln(ninflation)
gen exratelog=ln(nexrate)

**********************************************************************

/*
The below code replicates analyses in the paper body and appendix tables
Please see notes to locate analysis in the text
*/

*	correlation matrices	*

*To replicate appendix table A4
corr inflalog exratelog growth

*coefficients reported in fn. 3
corr typea typea2pct typea5pct typea7pct typeb typeb2pct typeb5pct typeb7pct 

*	Regression analyses		*

*Stepwise & complete results for the whole time period 
*presented in able 1; also appendix tables A5 & A6
reg typea efn inflalog  year i.pais if leg_elec==0, vce(cluster pais)
eststo pres1
reg typea efn growth  year i.pais if leg_elec==0 , vce(cluster pais)
eststo pres3
reg typea efn exratelog  year i.pais if leg_elec==0, vce(cluster pais)
eststo pres4
reg typea efn inflalog growth exratelog year i.pais if leg_elec==0, vce(cluster pais)
eststo pres5

estout pres1 pres3 pres4 pres5 using prestypea.xls, 	///
			cells(b(star fmt(%9.3f)) se(par)) nobaselevels               ///
             stats(pr2 N, fmt(2) labels( N))   starlevels(+ 0.10 * 0.05 ** 0.01)   ///
             legend label collabels(none) varlabels(_cons Constant) replace 

reg typeb efn inflalog  year i.pais if leg_elec==0 , vce(cluster pais)
eststo pres6
reg typeb efn growth  year i.pais if leg_elec==0 , vce(cluster pais)
eststo pres8
reg typeb efn exratelog  year i.pais if leg_elec==0 , vce(cluster pais)
eststo pres9
reg typeb efn inflalog growth exratelog year i.pais if leg_elec==0, vce(cluster pais)
eststo pres10

estout pres6 pres8 pres9 pres10 using prestypeb.xls, 	///
			cells(b(star fmt(%9.3f)) se(par)) nobaselevels               ///
             stats(pr2 N, fmt(2) labels( N))   starlevels(+ 0.10 * 0.05 ** 0.01)   ///
             legend label collabels(none) varlabels(_cons Constant) replace 

reg typea efn inflalog  year i.pais if leg_elec==1 , vce(cluster pais)
eststo leg1
reg typea efn growth  year i.pais if leg_elec==1 , vce(cluster pais)
eststo leg3
reg typea efn exratelog  year i.pais if leg_elec==1 , vce(cluster pais)
eststo leg4
reg typea efn inflalog growth exratelog year i.pais if leg_elec==1, vce(cluster pais)
eststo leg5

estout leg1 leg3 leg4 leg5 using legtypea.xls, 	///
			cells(b(star fmt(%9.3f)) se(par)) nobaselevels               ///
             stats(pr2 N, fmt(2) labels( N))   starlevels(+ 0.10 * 0.05 ** 0.01)   ///
             legend label collabels(none) varlabels(_cons Constant) replace 

reg typeb efn inflalog  year i.pais if leg_elec==1 , vce(cluster pais)
eststo leg6
reg typeb efn growth  year i.pais if leg_elec==1 , vce(cluster pais)
eststo leg8
reg typeb efn exratelog  year i.pais if leg_elec==1 , vce(cluster pais)
eststo leg9
reg typeb efn inflalog growth exratelog year i.pais if leg_elec==1, vce(cluster pais)
eststo leg10

estout leg6 leg8 leg9 leg10 using legtypeb.xls, 	///
			cells(b(star fmt(%9.3f)) se(par)) nobaselevels               ///
             stats(pr2 N, fmt(2) labels( N))   starlevels(+ 0.10 * 0.05 ** 0.01)   ///
             legend label collabels(none) varlabels(_cons Constant) replace 
			 
*	 REMMER REPLICATION		*

reg typea efn inflalog exratelog growth year if leg_elec==1 & year>=1980 & year<1990, vce(cluster pais)
eststo rem1
reg typea efn inflalog exratelog growth year if leg_elec==0 & year>=1980 & year<1990, vce(cluster pais)
eststo rem2

reg typeb efn inflalog exratelog growth year if leg_elec==1 & year>=1980 & year<1990, vce(cluster pais)
eststo rem3
reg typeb efn inflalog exratelog growth year if leg_elec==0 & year>=1980 & year<1990, vce(cluster pais)
eststo rem4


*	Table 1: complete models: Remmer replication and complete 1978-2016 models	*
*	Note: run the above models to generate the table below	

estout rem1 rem2 rem3 rem4 leg5 pres5 leg10 pres10 using table1.xls, 	///
			cells(b(star fmt(%9.3f)) se(par)) nobaselevels               ///
             stats(pr2 N, fmt(2) labels( N))   starlevels(+ 0.10 * 0.05 ** 0.01)   ///
             legend label collabels(none) varlabels(_cons Constant) replace 


*	The below code creates the figure	*

gen decade=.
replace decade=1980 if year>=1980 & year<1990
replace decade=1990 if year>=1990 & year<2000
replace decade=2000 if year>=2000 & year<2010 
replace decade=2010 if year>=2010

*	panel 1
graph box typea typeb, over(decade) by(leg_elec) scheme(s1mono)
*	panel 2
graph box typea7pct typeb7pct, over(decade) by(leg_elec) scheme(s1mono)

