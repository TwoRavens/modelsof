** Issue Voting as a Constrained Choice Problem - Moral and Zhirnov (2017)
** Replication File (Appendix D: Comparisons between the Conditional Logistic and Constrained Choice Conditional Logistic Regressions)

clear all
* cd "/Users/mmoral/Dropbox/SUNY Binghamton PhD/Miscellaneous/-Issue Voting as a Constrained Choice Problem/AJPS Final/Replication/Analyses Code"
* cd "/home/andrei/Desktop/replication materials"

** Programs
prog drop _all

* Conditional logistic regression
program define condlog
	args todo b lnf
	tempvar deno vc
	mleval `vc'=`b', eq(1)
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc')) 
	mlsum `lnf'=`vc'-ln(`deno') if choice==1 
end

* Constrained choice conditional logistic regression 
program define cccl
	args todo b lnf
	tempvar deno vc cs
	mleval `vc'=`b', eq(1) 
	mleval `cs'=`b', eq(2) 
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc'-ln(1+exp(-`cs'))))
	mlsum `lnf'= (`vc'-ln(1+exp(-`cs'))-ln(`deno')) if choice==1
end

** Estimations
** Norway (1989)
use "NSD1989 v1.dta",clear

*Proximity model
ml model d0 condlog (choice=chprox*, nocons)
ml search
eststo m1a_Nor: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
mat b_m1a=(e(b))
estat ic
mat modelfit=r(S)

ml model d0 condlog (choice=chprox* constvar1 constvar2 constvar3, nocons)
ml search
eststo m1b_Nor: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m1b, 0)
ml model d0 cccl (choice=chprox*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m1c_Nor: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

* Directional model
ml model d0 condlog (choice=chdir*, nocons)
ml search
eststo m2a_Nor: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chdir* constvar1 constvar2 constvar3, nocons)
ml search
eststo m2b_Nor: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m2b, 0)
ml model d0 cccl (choice=chdir*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m2c_Nor: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

** United Kingdom (1987)
use "BES87 v1.dta",clear

* Proximity model
ml model d0 condlog (choice=chprox*, nocons)
ml search
eststo m1a_Gbr: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
mat b_m1a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chprox* constvar1 constvar2 constvar3, nocons)
ml search
eststo m1b_Gbr: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m1b, 0)
ml model d0 cccl (choice=chprox*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m1c_Gbr: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

* Directional model
ml model d0 condlog (choice=chdir*, nocons)
ml search
eststo m2a_Gbr: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chdir* constvar1 constvar2 constvar3, nocons)
ml search
eststo m2b_Gbr: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m2b, 0)
ml model d0 cccl (choice=chdir*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m2c_Gbr: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

** Ireland (2002)
use "IrNES02 v1.dta",clear

* Proximity model
ml model d0 condlog (choice=chprox*, nocons)
ml search
eststo m1a_Irl: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
mat b_m1a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chprox* constvar1 constvar2 constvar3, nocons)
ml search
eststo m1b_Irl: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m1b, 0)
ml model d0 cccl (choice=chprox*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m1c_Irl: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

* Directional model
ml model d0 condlog (choice=chdir*, nocons)
ml search
eststo m2a_Irl: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chdir* constvar1 constvar2 constvar3, nocons)
ml search
eststo m2b_Irl: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m2b, 0)
ml model d0 cccl (choice=chdir*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m2c_Irl: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

** Netherlands (1981)
use "DutchNES81 v1.dta",clear

* Proximity model
ml model d0 condlog (choice=chprox*, nocons)
ml search
eststo m1a_Nld: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
mat b_m1a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chprox* constvar1 constvar2 constvar3, nocons)
ml search
eststo m1b_Nld: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m1b, 0)
ml model d0 cccl (choice=chprox*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m1c_Nld: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

* Directional model
ml model d0 condlog (choice=chdir*, nocons)
ml search
eststo m2a_Nld: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chdir* constvar1 constvar2 constvar3, nocons)
ml search
eststo m2b_Nld: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m2b, 0)
ml model d0 cccl (choice=chdir*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m2c_Nld: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

** Sweden (1994)
use "SNES94 v1.dta",clear

* Proximity model
ml model d0 condlog (choice=chprox*, nocons)
ml search
eststo m1a_Swe: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
mat b_m1a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chprox* constvar1 constvar2 constvar3, nocons)
ml search
eststo m1b_Swe: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m1b, 0)
ml model d0 cccl (choice=chprox*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m1c_Swe: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

* Directional model
ml model d0 condlog (choice=chdir*, nocons)
ml search
eststo m2a_Swe: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2a=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

ml model d0 condlog (choice=chdir* constvar1 constvar2 constvar3, nocons)
ml search
eststo m2b_Swe: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2b=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

mat initial=(b_m2b, 0)
ml model d0 cccl (choice=chdir*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m2c_Swe: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2c=(e(b))
estat ic
mat modelfit=(modelfit\r(S))

** Table A6: Model Fit Statistics from Norway (1989) and United Kingdom (1987) Compared to the Irish (2002), Dutch (1981), and Swedish (1994) National Election Studies
mat list modelfit
clear
svmat modelfit,names(col)
local names: rownames (modelfit[j,]) 
gen case=word("`names'",_n)
gen type=substr(case,3,1) /* Extracts the model */
gen country=substr(case,5,.) /* Extract the countries */
replace country="1 Norway" if country=="Nor"
replace country="2 United Kingdom" if country=="Gbr"
replace country="3 Ireland" if country=="Irl"
replace country="4 Netherlands" if country=="Nld"
replace country="5 Sweden" if country=="Swe" 
gen proxdir="P" if substr(case,1,2)=="m1" /* Extract the model */
replace proxdir="D" if substr(case,1,2)=="m2"
drop ll0 N case
reshape wide ll df AIC BIC, i(country proxdir) j(type) string /* Reshapes and compares the model fit statistics */
gen check_ll1=(2*(llc-lla)>invchi2tail(dfc-dfa,0.05))
gen check_ll2=(2*(llc-lla)>invchi2tail(dfc-dfb,0.05))
gen checkmark_ll=check_ll1*check_ll2
gen check_AIC1=(AICa-AICc>6)
gen check_AIC2=(AICb-AICc>6)
gen checkmark_AIC=check_AIC1*check_AIC2
gen check_BIC1=(BICa-BICc>2)
gen check_BIC2=(BICb-BICc>2)
gen checkmark_BIC=check_BIC1*check_BIC2
drop check_* df*
rename (*a)(cl_*)
rename (*b)(clp_*)
rename (*c)(cccl_*)
reshape long checkmark_ cl_ clp_ cccl_,i(country proxdir) j(statistic) string /* Reshapes the data and makes the table */
reshape wide checkmark_ cl_ clp_ cccl_,i(country statistic) j(proxdir) string 
rename (cl_P clp_P cccl_P checkmark_P)(P1 P2 P3 P3_Fits_Best)
rename (cl_D clp_D cccl_D checkmark_D)(D1 D2 D3 D3_Fits_Best)
gen sorter=(statistic!="ll")
sort c country sorter statistic
drop sorter
order country statistic P1 P2 P3 P3_Fits_Best D1 D2 D3 D3_Fits_Best
export delimited "TableA6.csv",replace

** CSES
use "cses v1.dta", clear 

* Proximity model
levelsof D1004, local(levels) 
postutil clear
tempname mypost
postfile `mypost' str20(case) float(model k N parties loglike) using cses_p_simul, replace
foreach l of local levels {
use "cses v1.dta", clear
keep if D1004=="`l'"
clogit choice chprox1 constvar1 constvar2 constvar3, group(id)
matrix ini=(e(b), 0)
keep if e(sample)
egen number=sum(choice)
qui sum number, meanonly
local Np=(r(mean))
post `mypost' ("`l'") (2) (e(k)) (`Np') (e(N)/`Np') (e(ll))
clogit choice chprox1, group(id)
post `mypost' ("`l'") (1) (e(k)) (`Np') (e(N)/`Np') (e(ll))
ml model d0 cccl (choice=chprox1, nocons)(constvar1 constvar2 constvar3)
ml init ini, copy
ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
post `mypost' ("`l'") (3) (e(k)) (`Np') (e(N)/`Np') (e(ll)) 
}
postclose `mypost'
disp "Done!"

** Table A7: Estimates of Models P1, P2, and P3 with the CSES Data: Model Fit Statistics
use "cses v1.dta", clear 
keep D1004 country cses_year
tostring cses_year, replace
gen clabel=itrim(country+" ("+cses_year+")")
duplicates drop D1004, force
rename D1004 case
merge 1:m case using cses_p_simul
gen aic=-2*loglike + 2*k
gen bic=-2*loglike + k*log(N)
keep clabel model loglike aic bic k
reshape wide loglike aic bic k, i(clabel) j(model) 
gen checkmark_ll=(2*(loglike3-loglike2)>invchi2tail(k3-k2,0.05) & 2*(loglike3-loglike1)>invchi2tail(k3-k1,0.05))
gen checkmark_aic=(aic2-aic3 > 6 & aic1-aic3 > 6 )
gen checkmark_bic=(bic2-bic3 > 2 & bic1-bic3 > 2 )
keep clabel loglike1 loglike2 loglike3 checkmark_ll aic1 aic2 aic3 checkmark_aic bic1 bic2 bic3 checkmark_bic
order clabel loglike1 loglike2 loglike3 checkmark_ll aic1 aic2 aic3 checkmark_aic bic1 bic2 bic3 checkmark_bic
export delimited "TableA7.csv",replace

* Directional model
use "cses v1.dta", clear 
levelsof D1004, local(levels) 
postutil clear
tempname mypost
postfile `mypost' str20(case) float(model k N parties loglike) using cses_d_simul, replace
foreach l of local levels {
use "cses v1.dta", clear
keep if D1004=="`l'"
clogit choice chdir1 constvar1 constvar2 constvar3, group(id)
matrix ini=(e(b), 0)
keep if e(sample)
egen number=sum(choice)
qui sum number, meanonly
local Np=(r(mean))
post `mypost' ("`l'") (2) (e(k)) (`Np') (e(N)/`Np') (e(ll))
clogit choice chdir1, group(id) iterate(50)
post `mypost' ("`l'") (1) (e(k)) (`Np') (e(N)/`Np') (e(ll)) 
ml model d0 cccl (choice=chdir1, nocons)(constvar1 constvar2 constvar3)
ml init ini, copy
ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
post `mypost' ("`l'") (3) (e(k)) (`Np') (e(N)/`Np') (e(ll)) 
}
postclose `mypost'
disp "Done!"

** Table A8: Estimates of Models D1, D2, and D3 with the CSES Data: Model Fit Statistics
use "cses v1.dta", clear 
keep D1004 country cses_year
tostring cses_year, replace
gen clabel=itrim(country+" ("+cses_year+")")
duplicates drop D1004, force
rename D1004 case
merge 1:m case using cses_d_simul
gen aic=-2*loglike + 2*k
gen bic=-2*loglike + k*log(N)
keep clabel model loglike aic bic k
reshape wide loglike aic bic k, i(clabel) j(model) 
gen checkmark_ll=(2*(loglike3-loglike2)>invchi2tail(k3-k2,0.05) & 2*(loglike3-loglike1)>invchi2tail(k3-k1,0.05))
gen checkmark_aic=(aic2-aic3 > 6 & aic1-aic3 > 6 )
gen checkmark_bic=(bic2-bic3 > 2 & bic1-bic3 > 2 )
keep clabel loglike1 loglike2 loglike3 checkmark_ll aic1 aic2 aic3 checkmark_aic bic1 bic2 bic3 checkmark_bic
order clabel loglike1 loglike2 loglike3 checkmark_ll aic1 aic2 aic3 checkmark_aic bic1 bic2 bic3 checkmark_bic
export delimited "TableA8.csv",replace
