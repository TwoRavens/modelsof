clear
set more off

local thresh = "FL"

cd "~/Dropbox/RecordLinkage/CCESDIME_F/DATAHH/"

* Join: YouGov panelist only
insheet using "./V101.csv", clear
rename v101 V101
saveold V101.dta, replace

insheet using "./HHcontribmatch.csv", clear
rename v101 V101
keep V101
saveold "V101HH.dta", replace

* Load data which matches summary contributor data to CCES Ids
insheet using "./ccesdime.csv", clear
rename v101 V101

* Join in 2012 CCES, with validated vote
joinby V101 using "./CCES12_Common_VV.dta", unmatched(both)
replace zetaj = 0.0009 if zetaj == .

* Join: YouGov panelist only
joinby V101 using "./V101.dta"
drop _merge

* Join: YouGov panelist only
merge 1:1 V101 using "./V101HH.dta"

gen binned_2012amountRrep = 0
replace binned_2012amountRrep = 0 if CC417c == 0
replace binned_2012amountRrep = 1 if CC417c >= 1 & CC417c <= 25
replace binned_2012amountRrep = 2 if CC417c >= 26 & CC417c <= 50
replace binned_2012amountRrep = 3 if CC417c >= 51 & CC417c <= 100
replace binned_2012amountRrep = 4 if CC417c >= 101 & CC417c <= 200
replace binned_2012amountRrep = 5 if CC417c >= 201 & CC417c <= 300
replace binned_2012amountRrep = 6 if CC417c >= 301 & CC417c <= 500
replace binned_2012amountRrep = 7 if CC417c >= 501 & CC417c <= 1000
replace binned_2012amountRrep = 8 if CC417c >= 1001 & CC417c <= 2500
replace binned_2012amountRrep = 9 if CC417c >= 2500 & CC417c != .

cor binned_2012amountRrep binned_2012amountR
**cor CC417c totalamount12 
**plot CC417c totalamount12

* Code up whether merged
gen iscontributor = (_merge==3)
drop if _merge == 2
label var iscontributor "Is a contributor (matched to CCES case, 1=yes)"

*clean up ideology; don't know to moderate
recode ideo5 (6=3)
label var ideo5 "5 point ideology, 1=very lib, 5=very con, 3=mod/dk"

*clean up pid7, dk to indept.
replace pid7=4 if  pid7==8

*if a pid3 dk/etc, put that in pid7
replace pid7=4 if pid7==. & (pid3==3 | pid3==4 | pid3==5)
*partisans in pid3 to weak partisans in pid7
replace pid7=2 if pid7==. & pid3==1
replace pid7=6 if pid7==. & pid3==2

*Income to 0-15 scale, with DK=15
replace faminc =14 if faminc >14 & faminc~=97
replace faminc=15 if faminc==97
label define FAMINC 14 "$250,000 or more" 15 "DK/Refused", modify 

*Age
gen age=2012-birthyr
gen decades=int(age/10)
label var decades "Age in decades"

* Binned Amount for contributions, match to CCES amounts
label define amt12 0 "None" 1 "$1 to $25" 2 "$26 to $50" 3 "$51 to $100" 4 "$101 to $200" 5 "$201 to $300" 6 "$301 to $500" 7 "$501 to $1000"  8 "$1001 to $2500" 9 "Above $2500"
label values binned_2012amountR amt12
label var binned_2012amountR "Observed 2012 contributions in matched CF data"

gen binned_2012amountR_withmissing=binned_2012amountR
replace binned_2012amountR_withmissing=0 if binned_2012amountR_withmissing==.
label var binned_2012amountR_withmissing "Observed 2012 contributions in CF data, missing=0"

* Reported Amount, same category as CF data
recode CC417c (0=0 "None") (.=0) (1/25=1 "$1 to $25") (26/50=2 "$26 to $50") (51/100=3 "$51 to $100") (101/200=4 "$101 to $200") (201/300=5 "$201 to $300") (301/500=6 "$301 to $500") (501/1000=7 "$501 to $1000") (1001/2500=8 "$1001 to $2500") (nonmissing=9 "Above $2500") , gen(reported_2012amount)
label values  reported_2012amount amt12
label var reported_2012amount "Reported 2012 Contributions"

*Binary, dem/rep variable
gen isdem=.
replace isdem=1 if pid7==1 | pid7==2 | pid7==3
replace isdem=0 if pid7==5 | pid7==6 | pid7==7
label var isdem "Democrat (1=yes [incl. lean], 0=rep, .=else)"

* Ideology scale. All Policy items (but not roll calls)

*Scale policy items, using dummy variables for each categorical response. Does not include roll calls.
qui foreach var of varlist CC320 CC321 CC322_1 CC322_2 CC322_3 CC322_4 CC322_5 CC322_6 CC324 CC325 CC326 CC327 CC328 CC329 {
 local tempvarlabel : var label `var'
 di "working on `var' with label `tempvarlabel'"
 levelsof `var', local(levels) missing
 local ctr=1
 foreach value of local levels {
  local templabel : label (`var') `value'
  gen td_`var'_`ctr'=0
  replace td_`var'_`ctr'=1 if (`var'==`value')
  label var td_`var'_`ctr' "`tempvarlabel' = `templabel'"
  local ctr=`ctr'+1
  }
  drop td_`var'_1
 }

****log using "tables/SITable02_FactorCoefficientsforSITable02.txt", text replace
****outsum td_* using tables/SITable02_FactorAnalysisForIdeologyPolicyFactor.out, replace
factor td_* [aweight=V103], ipf
* Note: Need to paste these coefficients into the SITable02 file. Outreg doesn't work with factor
factor td_* [aweight=V103], ipf factors(1)
predict ideofactor
drop td_*
qui summ ideofactor
replace ideofactor = ((ideofactor-`r(min)')/(`r(max)'-`r(min)')-.5)*2
label var ideofactor "Ideological scale from policy items (-1=Lib, 1=Cons)"
****log close

*Scale non-binary policy items policy items, using dummy variables for each categorical response. Does not include roll calls.
qui foreach var of varlist CC320 CC321 CC324 CC325 CC327 CC328 CC329 {
 tab `var', missing gen(td_`var'_)
 drop td_`var'_1
}

factor td_* [aweight=V103], ipf factors(1)
predict ideofactornotbinary
drop td_*
qui summ ideofactornotbinary
replace ideofactornotbinary = ((ideofactornotbinary-`r(min)')/(`r(max)'-`r(min)')-.5)*2
label var ideofactornotbinary "Ideological scale from 7 non-binary policy items (-1=Lib, 1=Cons)"

*Scale FOREIGN policy items, using dummy variables for each categorical response
* restrict to cases that are less than half missing. This means need at least 4 items.

egen temp=rowmiss(CC414_*)
qui foreach var of varlist CC414_* {
 tab `var' if temp<4, missing gen(td_`var'_)
 drop td_`var'_1
}

factor td_* if temp<4 [aweight=V103], ipf factors(1)
predict foreignpolicyfactor if temp<4
drop td_* temp
qui summ foreignpolicyfactor
replace foreignpolicyfactor = ((foreignpolicyfactor-`r(min)')/(`r(max)'-`r(min)')-.5)*2
label var foreignpolicyfactor "Foreign Policy Scale from policy items (-1=Lib, 1=Cons)"

* Ideology scale. All Policy items (but not roll calls) WITHOUT IMMIGRATION
qui foreach var of varlist CC320 CC321 CC324 CC325 CC326 CC327 CC328 CC329 {
 tab `var', missing gen(td_`var'_)
 drop td_`var'_1
}

factor td_* [aweight=V103], ipf factors(1)
predict ideofactornoimmig
drop td_*
qui summ ideofactornoimmig
replace ideofactornoimmig = ((ideofactornoimmig-`r(min)')/(`r(max)'-`r(min)')-.5)*2
label var ideofactornoimmig "Ideological scale from policy items no immigration (-1=Lib, 1=Cons)"

* Ideology scale created using roll call votes

egen nummissrc=rowmiss(CC332*)
qui foreach var of varlist CC332* {
 tab `var', missing gen(td_`var'_)
 drop td_`var'_1
}

factor td_* if nummissrc<=5 [aweight=V103], ipf factors(1)
predict rollcallfactor
* This item has the wrong direction relative to the others, so flip it
table isdem, c(mean rollcallfactor)
replace rollcallfactor=rollcallfactor*-1
drop td_*
qui summ rollcallfactor
replace rollcallfactor = -1*((rollcallfactor-`r(min)')/(`r(max)'-`r(min)')-.5)*2
gen rollcallfactorint=int((rollcallfactor+1)*4.99)+1
label var rollcallfactor "Ideological scale from Roll Call votes (-1=Lib, 1=Cons)"
label var rollcallfactorint "Ideological scale from policy items 1-10, 1=Lib, 10=Cons"

regress rollcallfactor ideofactor [aweight=V103]
pwcorr ideofactor ideofactornotbinary ideofactornoimmig rollcallfactor [aweight=V103]

* Alternative ideology scale using number of extreme response to non-binary items with obvious ideological ends
gen extreme_response=0
* CC320 doesn't have extreme response at either end. Other items do
replace extreme_response=extreme_response+1 if CC320==1 | CC320==2
qui foreach var of varlist CC321 CC324 CC325 CC327 {
 summ `var'
 replace extreme_response=extreme_response+1 if `var'==`r(min)' | `var'==`r(max)'
 }
label var extreme_response "Number of extreme responses to 5 non-binary policy items"

gen voted2012=(e2012g~="MatchedNoVote") if catalist_match==1
label var voted2012 "Validated 2012 General Vote (1=yes, 0=no, .=unknown)"

gen voted2012congprim=(e2012congp~="") if catalist_match==1
label var voted2012congprim "Validated 2012 Cong. Primary Vote (1=yes, 0=no, .=unknown)"

* Code up measures of perceived ideological distance; Calculate absolute values for own placements/etc. to account for divergence measures

*Replace ideology placements of Not Sure with missing.
foreach var of varlist CC334* {
  qui replace `var' = . if `var' == 8
}

gen abs_selfplace=abs(CC334A-4)
label var abs_selfplace "Absolute value of self placement ideology (0-3)"

xtile ideoquants=ideofactor [aweight=V103], nquantiles(10) 
label var ideoquants "Quantile of Estimated Ideology"

summ foreignpolicyfactor [aweight=V103], detail
gen abs_fpfactor=abs(foreignpolicyfactor-`r(p50)')
label var abs_fpfactor "Absolute Value Foreign Policy Ideology (0-1.54)"

gen abs_ideo=abs(ideofactor)
gen abs_ideo2=abs_ideo^2
label var abs_ideo "Absolute Value of Estimated Ideology (0-1)"
label var abs_ideo2 "Squared: Absolute Value of Estimated Ideology (0-1)"

gen divg_romn_obam = abs(CC334D - CC334C)
label variable divg_romn_obam "Absolute perceived difference in Romney/Obama ideology"
gen divg_parties = abs(CC334F - CC334E)
label variable divg_parties "Absolute perceived difference in Dem/Rep ideology"
gen own_extreme=abs(CC334A-4)
label variable own_extreme "Absolute perceived own extremity ideology"

pwcorr divg_parties divg_romn_obam

* So let's just take averages here
gen avgdem=(CC334C+CC334E)/2
gen avgrep=(CC334D+CC334F)/2

* distance to farther
gen dist_far=max(abs(avgdem-CC334A),abs(avgrep-CC334A))
label var dist_far "Distance to farther party (0-6)"

* distance to near
gen dist_closer=min(abs(avgdem-CC334A),abs(avgrep-CC334A))
label var dist_closer "Distance to closer party (0-6)"

* distance between parties
gen dist_between = abs(avgdem-avgrep)
label var dist_between "Distance between parties (0-6)"

* quadratic loss (spatial model)
gen quadloss= dist_far^2 - dist_closer^2 
label var quadloss "Dist Far^2 - Dist Closer^2"

gen linearloss=dist_far-dist_closer
label var linearloss "Dist Far - Dist Closer"

* Some robustness for spatial model coding. Instead of using average placement of both candidates and parties, use one or the other

gen cand_dist_far=max(abs(CC334C-CC334A),abs(CC334D-CC334A))
label var cand_dist_far "Distance to farther party's candidate (0-6)" 
gen cand_dist_closer=min(abs(CC334C-CC334A),abs(CC334D-CC334A))
label var cand_dist_closer "Distance to closer party's candidate (0-6)"
gen cand_dist_between = abs(CC334C-CC334D)
label var cand_dist_between "Distance between parties' candidates (0-6)"
gen cand_quadloss=cand_dist_far^2 - cand_dist_closer^2 
label var cand_quadloss "Candidate measure, Dist Far^2 - Dist Closer^2"

gen party_dist_far=max(abs(CC334E-CC334A),abs(CC334F-CC334A))
label var party_dist_far "Distance to farther party (0-6)" 
gen party_dist_closer=min(abs(CC334E-CC334A),abs(CC334F-CC334A))
label var party_dist_closer "Distance to closer party (0-6)"
gen party_dist_between = abs(CC334E-CC334F)
label var party_dist_between "Distance between parties (0-6)"
gen party_quadloss=party_dist_far^2 - party_dist_closer^2 
label var party_quadloss "Party measure, Dist Far^2 - Dist Closer^2"

* For contributors, make an alternative weight which is by amount
**gen dolweight=V103
**replace dolweight=dolweight*(1+ binned_2012amountR)
**label var dolweight "Adjusted weight for contributors"

* High interest, high education.
gen higheduc_highint = (newsint < 2 & newsint != .) & (educ == 5 | educ == 6)
label var higheduc_highint "High political interest AND B.A. or higher educ"


gen aux = 1
egen gid3 = group(V101)
bys gid3: egen aux2 = sum(aux)

gen w2 = (1/aux2) * V103

drop aux aux2
compress
saveold "./final_analysisHH.dta", replace



