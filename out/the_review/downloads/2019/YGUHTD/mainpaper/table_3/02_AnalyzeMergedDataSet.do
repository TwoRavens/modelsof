set more off
window manage close graph _all
set scheme s1mono
local thresh = "FL"

cd "~/Dropbox/RecordLinkage/CCESDIME_F/DATAHH/"

*Matched contributors in CCES
use "./final_analysisHH.dta" if catalist_match==1, clear

qui gen validated_regd_demrep = 1*(PartyRegist == "Democratic.Party" | PartyRegist == "Republican.Party")
label var validated_regd_demrep "Validated party registration Dem or Rep"

*Only make comparisons in states with any party reg.
tabstat validated_regd_demrep, s(mean) by(StateAbbr)
qui egen party_reg_rate_in_state = mean(validated_regd_demrep), by(StateAbbr)
qui gen party_reg_state = 1*(party_reg_rate_in_state > .1)

*******
*
* This block prepares the data for the R Plots of Demographics differences
*
*******

*Shorten policy item labels to fit on graphs
foreach var of varlist CC320 CC321 CC324 CC325 CC326 CC327 CC328 CC329 {
 levelsof `var' , local(levels)
 foreach l of local levels {
  local templabel : label (`var') `l'
  local templabel=substr("`templabel'",1,15)
  label define `var' `l' "`templabel'", modify
 }
 label values `var' `var'
} 

label var faminc "Family Income: "
label var unionhh "Union: "
label var race "Race: "
label var educ "Education: "
label var decades "Age in decades: "
label var pew_religimp "Religion Importance: "
gen male=gender==1
label var male "Male"

* Create indicator variables from categories
foreach var of varlist faminc unionhh race educ decades pew_religimp {
 local tempvarlabel : var label `var'
 levelsof `var', local(levels)
 local ctr=1
  foreach lvl of local levels {
   if `ctr'~=1 {
    gen I_`var'_`ctr'=(`var'==`lvl') if `var'~=.
	local tempvallabel : label (`var') `lvl'
	label var I_`var'_`ctr' "`tempvarlabel'`tempvallabel'"
   }
  local ctr=`ctr'+1
 }
}

* Demographic Comparison of Contributors and Non-Contributors

gen iscontributord=iscontributor if isdem==1
gen iscontributorr=iscontributor if isdem==0
gen amountcontd=binned_2012amountR_withmissing if isdem==1
gen amountcontr=binned_2012amountR_withmissing if isdem==0
*Four-way classification, contributor by dem/rep.
gen iscont_pid = .
qui replace iscont_pid = 1 if iscontributord == 1
qui replace iscont_pid = 2 if iscontributord == 0
qui replace iscont_pid = 3 if iscontributorr == 1
qui replace iscont_pid = 4 if iscontributorr == 0
label var iscont_pid "Party ID by contributor"
label define iscont_pid 1 "Dem Donor" 2 "Dem Non-donor" 3 "Rep Donor" 4 "Rep Non-donor"
label values iscont_pid iscont_pid
tab iscont_pid [aweight = V103], miss
qui gen votetype_pid = .
qui replace votetype_pid = 1 if voted2012 == 1 & isdem == 1
qui replace votetype_pid = 2 if voted2012 == 0 & isdem == 1
qui replace votetype_pid = 3 if voted2012 == 1 & isdem == 0
qui replace votetype_pid = 4 if voted2012 == 0 & isdem == 0
label var votetype_pid "Party ID by 2012 turnout"
label define votetype_pid 1 "Dem voter" 2 "Dem non-voter" 3 "Rep voter" 4 "Rep non-voter"
label values votetype_pid votetype_pid

qui recode faminc (1/3=1) (4/6=2) (7/9=3) (10/14=4) (16/32=4) (else=.), gen(faminc2)
label define faminc2 1 "<$30,000" 2 "$30-60,000" 3 "$60-100,000" 4 ">$100,000"
label values faminc2 faminc2

*********************
*Table 1: summary of demographic and behavioral differences
*********************

*Variables: faminc2 educ decades pew_religimp race  voted2012congprim validated_regd_demrep
qui gen diff_incgt100 = (faminc2 == 4)
label var diff_incgt100 "Family income > $100K"
qui gen diff_educ4yr = (educ == 5 | educ == 6)
label var diff_educ4yr "Education 4-year college+"
qui gen diff_age50 = (age > 49)
label var diff_age50 "Age 50+"
qui gen diff_relig = (pew_religimp == 1)
label var diff_relig "Religion very important"
qui gen diff_racenonwhite = (race != 1)
label var diff_racenonwhite "Race not white"
qui gen diff_prim = voted2012congprim
label var diff_prim "Voted 2012 congressional primary"
qui gen diff_regd = validated_regd_demrep
qui replace diff_regd = . if party_reg_state == 0
label var diff_regd "Registered with major party in party registration state"
summ diff_*

**************************
*
* Table 02: Predicting ideology within party by contributor status
*
**************************

label var voted2012 "2012 General Vote"
label var voted2012congprim "2012 Cong. Primary Vote"
label var iscontributor "Is a Contributor"

gen ideofactorTEMP = 1 * ideofactor

*Set constant sample among reps
qui regress ideofactorTEMP voted2012 voted2012congprim zetaj I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* i.inputstate [aweight=w2]
cap gen useme=e(sample)
local templabel : var label ideofactor

eststo clear
eststo: tobit ideofactorTEMP zetaj voted2012 voted2012congprim if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
**summ ideofactor if e(sample)

eststo: tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
**summ ideofactor if e(sample)

eststo: tobit ideofactorTEMP zetaj voted2012 voted2012congprim if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust
**summ ideofactor if e(sample)

eststo: tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust
**summ ideofactor if e(sample)


esttab  using "table2HHfl.csv", keep(voted2012 voted2012congprim zetaj) cells(b(fmt(5)) se(par fmt(5))) replace

esttab using "Table2z.tex", ///
	booktabs not se label r2 obslast star( * 0.10 ** 0.05 *** 0.01) replace          ///
	title(\sc{Table 2 HH}) number ///
	mgroups("Rep" "Rep" "Dems" "Dems", pattern(1 1 1 1)                   ///
	prefix(\multicolumn{@span}{c}{) suffix(})   ///
	span erepeat(\cmidrule(lr){@span}))         ///
	keep(voted2012 voted2012congprim zetaj) ///
	alignment(D{.}{.}{-1}) page(dcolumn) nodep cells(b(star fmt(5)) se(par fmt(5))) addnotes("* \(p<0.1\), ** \(p<0.05\), *** \(p<0.01\)")
eststo clear

tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust

capture program drop boo
program boo, rclass
	tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1)
	est store a
	tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1)
	est store b
	suest a b
	lincom [b_model]_b[iscontributor] - [a_model]_b[zetaj] 
	return scalar diffse = r(estimate)
end

bootstrap diffse=r(diffse), reps(2500) : boo

capture program drop boo
program boo, rclass
	tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1)
	est store a
	tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1)
	est store b
	suest a b
	lincom [b_model]_b[iscontributor] - [a_model]_b[zetaj] 
	return scalar diffse = r(estimate)
end

bootstrap diffse=r(diffse), reps(2500) : boo

qui tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
margins, at(zetaj = 1) atmeans
matrix rep1zM = r(b)
scalar rep1z = rep1zM[1,1]
matrix r1zM = r(V)
scalar r1z = r1zM[1,1]

qui tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust
margins, at(zetaj = 1) atmeans
matrix dem1zM = r(b)
scalar dem1z = dem1zM[1,1]
matrix d1zM = r(V)
scalar d1z = d1zM[1,1]

qui tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
margins, at(iscontributor = 1) atmeans
matrix rep1oM = r(b)
scalar rep1o = rep1oM[1,1]
matrix r1oM = r(V)
scalar r1o = r1oM[1,1]

qui tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust
margins, at(iscontributor = 1) atmeans
matrix dem1oM = r(b)
scalar dem1o = dem1oM[1,1]
matrix d1oM = r(V)
scalar d1o = d1oM[1,1]

****

qui tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
margins, at(zetaj = 0) atmeans
matrix rep0zM = r(b)
scalar rep0z = rep0zM[1,1]
matrix r0zM = r(V)
scalar r0z = r0zM[1,1]

qui tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust
margins, at(zetaj = 0) atmeans
matrix dem0zM = r(b)
scalar dem0z = dem0zM[1,1]
matrix d0zM = r(V)
scalar d0z = d0zM[1,1]

qui tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
margins, at(iscontributor = 0) atmeans
matrix rep0oM = r(b)
scalar rep0o = rep0oM[1,1]
matrix r0oM = r(V)
scalar r0o = r0oM[1,1]

qui tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust
margins, at(iscontributor = 0) atmeans
matrix dem0oM = r(b)
scalar dem0o = dem0oM[1,1]
matrix d0oM = r(V)
scalar d0o = d0oM[1,1]

****

dis abs(rep1z) + abs(dem1z)
dis sqrt(r1z + d1z)
dis abs(rep1o) + abs(dem1o)
dis sqrt(r1o + d1o)
dis abs(rep0z) + abs(dem0z)
dis sqrt(r0z + d0z)
dis abs(rep0o) + abs(dem0o)
dis sqrt(r0o + d0o)




**summ ideofactor if e(sample)

tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
tobit ideofactorTEMP zetaj voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust


tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==0 & useme==1 [aweight=w2], ll(-1) ul(1) robust
tobit ideofactorTEMP iscontributor voted2012 voted2012congprim I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if isdem==1 & useme==1 [aweight=w2], ll(-1) ul(1) robust

mean ideofactorTEMP if isdem == 1 
mean ideofactorTEMP if isdem == 0 

----

drop useme

**************************
*
* Table 03: Predicting the decision to contribute. Spatial models
*  Also includes code for SI Table 06 (Correlation coefficients for spatial model analysis)
*
**************************

qui regress zetaj quadloss abs_selfplace dist_between I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* [aweight=w2] 
gen useme=e(sample)
summ iscontributor if useme==1
local rmean=`r(mean)'
local rdv=`r(sd)'
local templabel : var label iscontributor

* Correlation coefficients for Spatial model. SI Table 06.
log using "SITable06_CorrelationCoefficientsSpatialAnalysis.out", replace text

	* Everyone
	pwcorr quadloss abs_selfplace dist_closer dist_between if useme==1 [aweight=V103], sig

	* Democrats
	pwcorr quadloss abs_selfplace dist_closer dist_between if useme==1 & isdem==1 [aweight=V103], sig

	* Republicans
	pwcorr quadloss abs_selfplace dist_closer dist_between if useme==1 & isdem==0 [aweight=V103], sig

log close

gen posterior = zetaj
replace posterior = 0.0004 if zetaj == .

label var quadloss "dist farther"
label var abs_selfplace "absolute"
label var dist_closer "closer party"
label var dist_between "between"

* Basic model, pooled partisans.
eststo: regress zetaj quadloss I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 [aweight=w2], robust 

* Basic model, Dems.
eststo: regress zetaj quadloss I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 & isdem==1 [aweight=w2], robust 
summ iscontributor if e(sample)
local rmean=`r(mean)'
local rdv=`r(sd)'

* Basic model, Reps.
eststo: regress zetaj quadloss I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 & isdem==0 [aweight=w2], robust 
summ iscontributor if e(sample)
local rmean=`r(mean)'
local rdv=`r(sd)'

* With self placement
eststo: regress zetaj quadloss abs_selfplace I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 & isdem==1 [aweight=w2], robust 
summ iscontributor if e(sample)
local rmean=`r(mean)'
local rdv=`r(sd)'

eststo: regress zetaj quadloss abs_selfplace I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 & isdem==0 [aweight=w2], robust 
summ iscontributor if e(sample)
local rmean=`r(mean)'
local rdv=`r(sd)'

* With distance to closer
eststo: regress zetaj quadloss dist_closer I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 & isdem==1 [aweight=w2], robust 
summ iscontributor if e(sample)
local rmean=`r(mean)'
local rdv=`r(sd)'

eststo: regress zetaj quadloss dist_closer I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 & isdem==0 [aweight=w2], robust 
summ iscontributor if e(sample)
local rmean=`r(mean)'
local rdv=`r(sd)'

esttab  using "table3HHfl.csv", keep(quadloss abs_selfplace dist_closer) cells(b(fmt(5)) se(par fmt(5))) replace

esttab using "Table3FL.tex", ///
	booktabs not se label r2 obslast star( * 0.10 ** 0.05 *** 0.01) replace          ///
	title(\sc{Table 2 HH}) number ///
	mgroups(, pattern(1 1 1 1 1 1 1 1)                   ///
	prefix(\multicolumn{@span}{c}{) suffix(})   ///
	span erepeat(\cmidrule(lr){@span}))         ///
	keep(quadloss abs_selfplace dist_closer) ///
	alignment(D{.}{.}{-1}) page(dcolumn) nodep cells(b(star fmt(5)) se(par fmt(5))) addnotes("* \(p<0.1\), ** \(p<0.05\), *** \(p<0.01\)")
eststo clear
---

* Basic model, pooled partisans.
regress iscontributor quadloss I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 [aweight=w2], robust 
regress iscontributor quadloss I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 & isdem==1 [aweight=w2], robust 
regress iscontributor quadloss I_faminc* I_unionhh* male I_race* I_educ* I_decades* I_pew_religimp* if useme==1 & isdem==0 [aweight=w2], robust 


outsheet V101 zetaj using histodat.csv, comma replace

