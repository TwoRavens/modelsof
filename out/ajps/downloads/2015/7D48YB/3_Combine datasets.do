* This file combines election results with the cleaned CCES dataset
* for use in Study 3 of Broockman & Ryan, Preaching
* to the Choir (AJPS). Analysis was conducted on State/SE 13.1 for 
* Mac (64-bit Intel)

cd "~/Dropbox/Broockman-Ryan/Outpartisan Communication/DATA/Final Replication Files/Study3"

use "cces_2008_working.dta", clear

merge m:1 state district using "house2006.dta"

drop if _merge==1 // DC voters

* The next section deals with some special cases.

* MA-5 Special eleciton 
replace hdemvotes = 54363 if state=="Massachusetts" & district==5
replace hrepvotes = 47770 if state=="Massachusetts" & district==5
replace hdemwinperc = .032277 if state=="Massachusetts" & district==5

* OH-5 Special election
replace hdemvotes = 42229 if state=="Ohio" & district==5
replace hrepvotes = 56114 if state=="Ohio" & district==5
replace hdemwinperc = -.0705 if state=="Ohio" & district==5

* IL-14 Special election
replace hdemvotes = 52205 if state=="Illinois" & district==5
replace hrepvotes = 47180 if state=="Illinois" & district==5
replace hdemwinperc = .02528 if state=="Illinois" & district==5

* IN-7 Special election
replace hdemvotes = 45668 if state=="Indiana" & district==5
replace hrepvotes = 36415 if state=="Indiana" & district==5
replace hdemwinperc = .05636 if state=="Indiana" & district==5

* LA-6 Special election
replace hdemvotes = 49703 if state=="Louisiana" & district==6
replace hrepvotes = 46746 if state=="Louisiana" & district==6
replace hdemwinperc = .015329 if state=="Louisiana" & district==6

* MS-1 Special election
replace hdemvotes = 58037 if state=="Mississippi" & district==1
replace hrepvotes = 49877 if state=="Mississippi" & district==1
replace hdemwinperc = .0378 if state=="Mississippi" & district==1

* Margin of victory
gen margin = abs(hdemwinperc)

* Own party margin of victory
gen rspartywinperc = hdemwinperc if rdem == 1
replace rspartywinperc = -1 * hdemwinperc if rdem == 0
gen rspartywon = rspartywinperc > 0

* Encoded variable for districts
encode distname, gen(distencoded)

* Retain variables to be used for analysis
keep contact rspartywon rspartywin distname distencoded margin ///
	pknowl* church churchmr churchmiss dempidstr dempidstrmr dempidstrmiss ///
	reppidstr reppidstrmr reppidstrmiss age agemr ///
	actscale* followpol followpolmr followpolmiss incomecat incomecatmr ///
	incomecatmiss donategen*

* Order variables the same way as codebook
order contact rspartywon rspartywin distname distencoded margin ///
	pknowl* church* dempidstr* reppidstr* age* actscale* followpol* income* donategen*
	
save "cces_2008_working_merged.dta", replace
outsheet using "cces_2008_working_merged.csv", names comma replace

