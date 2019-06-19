
local inout Census_Tax_Linkage\Data

use "`inout'\CensusTax_Education.dta", clear

keep if (year==1991 & census06==0) | (year==2006 & census06==1)

foreach i of numlist 2/7 {
	gen mean_totinc_`i'=mean_totinc^`i'
}

local csvars restrictivelaborlaw exemptions childlaborage
local schlvars logschlexp schlnum_pc teachnum_pc
local covars_1 mean_has_empinc mean_empinc mean_has_dues i.naics
local covars_2 mean_has_empinc mean_empinc mean_has_dues i.naics mean_totinc mean_totinc_*
local covars_3 mean_age i.sex mean_married i.province mean_has_empinc mean_empinc mean_has_dues i.naics mean_totinc mean_totinc_* mean_value mean_disability

*--------------
*1) First stage
*--------------

xi: reg hsgrad_plus entry exit `csvars' `schlvars' i.birth_pl*yearat14 i.yearat14, cl(grp)
xi: reg hsgrad_plus mandyrs `csvars' `schlvars' i.birth_pl*yearat14 i.yearat14, cl(grp)
xi: reg hsgrad_plus mandyrs `csvars' `schlvars' `covars_3' i.birth_pl*yearat14 i.yearat14, cl(grp)
xi: reg hsgrad_plus mandyrs `csvars' `schlvars' `covars_3' i.birth_pl*yearat14 i.birth_pl*yearat14sq i.yearat14, cl(grp)
predict hsgrad_plus_hat, xb

*---------------
*2) Second stage
*---------------

preserve
gen saverate_avg=(mean_rspnetcont+mean_penadj)/mean_totinc
*Control for outlier observations in the derived saving rate variable at 1st and 99th percentile
*Results are robust to other methods, such as truncation
summarize saverate_avg, detail
keep if saverate_avg>=r(p1) & saverate_avg<=r(p99)

xi: reg hsgrad_plus mandyrs `csvars' `schlvars' `covars_3' i.birth_pl*yearat14 i.yearat14, cl(grp)
xi: ivregress 2sls saverate_avg (hsgrad_plus = mandyrs) `csvars' `schlvars' `covars_1' i.birth_pl*yearat14 i.yearat14, cl(birth_pl)
xi: ivregress 2sls saverate_avg (hsgrad_plus = mandyrs) `csvars' `schlvars' `covars_2' i.birth_pl*yearat14 i.yearat14, cl(birth_pl)
xi: ivregress 2sls saverate_avg (hsgrad_plus = mandyrs) `csvars' `schlvars' `covars_3' i.birth_pl*yearat14 i.yearat14, cl(birth_pl)
xi: ivregress 2sls saverate_avg (hsgrad_plus = mandyrs) `csvars' `schlvars' `covars_3' i.birth_pl*yearat14 i.birth_pl*yearat14sq i.yearat14, cl(birth_pl)
restore

keep census06 id year hsgrad_plus_hat
save "`inout'\Predicted_Education.dta", replace

exit