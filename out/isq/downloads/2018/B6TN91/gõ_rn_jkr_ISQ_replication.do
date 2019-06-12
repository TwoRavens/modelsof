
* REPLICATION DATA FOR GUDRUN ØSTBY, RAGNHILD NORDÅS & JAN KETIL RØD
* REGIONAL INEQUALITIES AND CIVIL CONFLICT IN SUB-SAHARAN AFRICA 
* INTERNATIONAL STUDIES QUARTERLY

set more off

*** TABLE 1
* Model 1
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline*, robust cl(gwno)

* Model 2 
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff  ///
  peaceyrs _spline* asset, robust cl(gwno) 

* Model 3
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* education, robust cl(gwno) 



*** TABLE 2
* Model 4
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* rdrgas, robust cl(gwno)

* Model 5
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* rdrged, robust cl(gwno) 

* Model 6
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* rdrgas_c rdrgas2_c, robust cl(gwno) 

* Model 7
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* rdrged_c rdrged2_c, robust cl(gwno) 
 


*** TABLE 3
* Model 8
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* asset_gini, robust cl(gwno) 

* Model 9
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* education_gini, robust cl(gwno) 

* Model 10
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* elf_reg, robust cl(gwno)

* Model 11
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
  peaceyrs _spline* education_gini asset_gini elf_reg, robust cl(gwno) 



*** TABLE 4
* Model 12
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* dia_sec rdrgas_c rdrgas_dia, robust cl(gwno)

* Model 13
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* peton_use  rdrgas_c rdrgas_pet, robust cl(gwno)

* Model 14
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* nr_c  rdrgas_c rdrgas_nr, robust cl(gwno) 



*** FIGURE 2
capture drop b1-b13
capture drop b14
capture drop plo phi
capture drop pavg
capture drop ageaxis
capture drop pi
estsimp logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff ///
peaceyrs _spline* rdrgas_c rdrgas2_c, robust cl(gwno)
generate plo = .
generate pavg = .
generate phi = .
generate ageaxis = _n - 9 in 1/28
setx mean
local a = -8
while `a' <= 19 {
	local b = (`a' - 2)/10
	local b_sq = `b'^2
	setx rdrgas_c `b' rdrgas2_c `b_sq'
	simqi, prval(1) genpr(pi)
	_pctile pi, p(10,50,90)
	replace plo = r(r1) if ageaxis==`a'
	replace pavg = r(r2) if ageaxis==`a'
	replace phi = r(r3) if ageaxis==`a'
	drop pi
	local a = `a' + 1
}
sort ageaxis
capture drop ageaxislbl
gen ageaxislbl=ageaxis/10
graph twoway (scatter pavg ageaxislbl, connect(l) s(i) lwidth(medthick)) (rcap plo phi ageaxislbl), ///
xtitle("Regional Relative Deprivation (Assets)") ytitle("pr(Conflict Onset)/Year ") legend( off)



*** FIGURE 3
capture drop nr_X_rdrgas_c 
gen nr_X_rdrgas_c = nr * rdrgas_c
capture drop b1-b13
capture drop nrplo nrphi nrpavg
capture drop ageaxis
capture drop pi
estsimp logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff peaceyrs _spline* ///
nr rdrgas_c nr_X, robust cl(gwno)
generate nrplo = .
generate nrpavg = .
generate nrphi = .
generate ageaxis = _n - 9 in 1/23
setx mean 
local a = -8
while `a' <= 19 {
	local b = (`a' - 2)/10
	setx rdrgas_c `b' nr 1 nr_X `b'
	simqi, prval(1) genpr(pi)
	_pctile pi, p(10,50,90)
	replace nrplo = r(r1) if ageaxis==`a'
	replace nrpavg = r(r2) if ageaxis==`a'
	replace nrphi = r(r3) if ageaxis==`a'
	drop pi
	local a = `a' + 1
}
sort ageaxis

capture drop b1-b13
capture drop no_nrplo no_nrphi no_nrpavg
capture drop ageaxis
capture drop pi
estsimp logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff peaceyrs _spline* ///
nr rdrgas_c nr_X, robust cl(gwno)
generate no_nrplo = .
generate no_nrpavg = .
generate no_nrphi = .
generate ageaxis = _n - 9 in 1/28
setx mean 
local a = -8
while `a' <= 19 {
	local b = (`a' - 2)/10
	setx rdrgas_c `b' nr 0 nr_X 0
	simqi, prval(1) genpr(pi)
	_pctile pi, p(10,50,90)
	replace no_nrplo = r(r1) if ageaxis==`a'
	replace no_nrpavg = r(r2) if ageaxis==`a'
	replace no_nrphi = r(r3) if ageaxis==`a'
	drop pi
	local a = `a' + 1
}
sort ageaxis

capture drop ageaxislbl
gen ageaxislbl=ageaxis/10
version 9

capture drop var7*

gen byte var75 = 0.4 in 1
gen byte var76 = 10 in 1
gen str30 var77 = "Natural Resources" in 1
replace var76 = 0.3 in 2
replace var75 = 1.1 in 2
replace var77 = "No Natural Resources" in 2

for X in varlist nrp* no_nrp*: replace X = X*100

graph twoway (scatter no_nrpavg ageaxislbl, connect(l) s(i) lwidth(medthick) lpattern(dash)) ///
(scatter nrpavg ageaxislbl, connect(l) s(i) lwidth(medthick)) (rcap nrplo nrphi ageaxislbl) ///
(rcap no_nrplo no_nrphi ageaxislbl), xtitle("Relative Deprivation (Asset)") ytitle("pr(Conflict Onset)/Year ") ///
legend( label(1 "with Natural Resources") label(2 "without Natural Resources") label(3 "90% CI for Nat. Res.") ///
label(4 "90% CI for No Nat. Res."))
graph twoway (scatter no_nrpavg ageaxislbl, connect(l) s(i) lwidth(medthick)) (scatter nrpavg ageaxislbl, ///
connect(l) s(i) lwidth(medthick)) (rcap nrplo nrphi ageaxislbl) (rcap no_nrplo no_nrphi ageaxislbl) ///
(scatter var76 var75, s(i) mlabel(var77) legend(off)), xtitle("Regional Relative Deprivation (Assets)") ///
ytitle("pr(Conflict Onset)/Year ") legend( label(1 "with Natural Resources") label(2 "without Natural Resources") ///
label(3 "90% CI for Nat. Res.") label(4 "90% CI for No Nat. Res."))

version 7
graph nrplo nrphi no_nr* ageaxis, s(iiii) c(||||)
version 9



*** APPENDIX B
sum onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd dia_sec peton_use pop_use_ln ethdiff nr asset ///
education rdrgas rdrged asset_gini education_gini elf_reg




























