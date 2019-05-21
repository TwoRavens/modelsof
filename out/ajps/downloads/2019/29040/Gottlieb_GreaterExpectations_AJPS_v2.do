* GENERAL INFO
	* Project: Greater Expectations: A Field Experiment to Improve Accountability in Mali
	* Created by: Jessica Gottlieb
	* Date created: January 2015
* DO FILE INFO
	* This .do file conducts all analyses and produces figures and tables.

************************************
* Clean variables for analysis of survey data
************************************

use "Survey_AJPS.dta", clear

* standardize outcome variables for H0
generate h0m1=0
replace h0m1=1 if responsibleschools=="2"
generate h0m2=0
replace h0m2=1 if responsibleclinics=="2"
generate h0m3=0
replace h0m3=1 if responsibletaxes=="2"
generate h0m4=0
replace h0m4=1 if responsiblewater=="2"
generate h0m5=0
replace h0m5=1 if responsibleconflict=="2"
generate h0m6=.
replace h0m6=1 if budget==2
replace h0m6=0 if budget==1
generate h0m7=.
replace h0m7=1 if budgetbig==1
replace h0m7=0 if budgetbig==2
destring notsecret, generate(h0m8)
replace h0m8=. if h0m8==88 | h0m8==0
replace h0m8=-h0m8
generate h0m9=.
replace h0m9=1 if retrovoting==1
replace h0m9=0 if retrovoting==2
generate h0m10=nprojectsfuture
generate h0m20=0
replace h0m20=1 if paybirthcert=="0"
destring   agreemultiparty  agreerespectauth  agreestrongopposition agreestrongchief  agreegenderequal, replace
generate h0m21=agreemultiparty
generate h0m22=7-agreerespectauth
generate h0m23=7-agreestrongchief
generate h0m24=agreegenderequal
generate h0m25=7-agreestrongopposition
generate h0m26=infoperform

foreach var of varlist h0m1 h0m2 h0m3 h0m4 h0m5 h0m6 h0m7 h0m8 h0m9 h0m10 h0m20 h0m21 h0m22 h0m23 h0m24 h0m25{
macro drop _mean _sd
su `var' if t==0
local mean = r(mean)
local sd = r(sd)
replace `var'=(`var'-`mean')/`sd'
}

egen indexexpectnew = rowmean(h0m1 h0m2 h0m3 h0m4 h0m5 h0m6 h0m7 h0m8 h0m9 h0m10 h0m20 h0m21 h0m22 h0m23 h0m24 h0m25)

generate t2hi=0
generate t2low=0
su indexi
replace t2hi=1 if t==2 & indexi>=`r(mean)'
replace t2low=1 if t==2 & indexi<`r(mean)'

* For analysis of Vignette A
generate wtanew=.
replace wtanew=10000 if a10000=="1"
replace wtanew=5000 if a5000=="1" 
replace wtanew=1000 if a1000=="1" 
replace wtanew=500 if a500=="1" 
replace wtanew=. if avote=="2"
generate wtanewusd=wtanew/500

************************************
* Analyses of survey data for tables and figures
************************************

* Table 1: Expectations index
qui xtmixed indexexpectnew t1 t2 i.enumerator i.block, ||cid: ||village:
estimates store E1
qui xtmixed indexexpectnew t1 t2hi t2low i.enumerator i.block, ||cid: ||village:
estimates store E2
estout1 E1 E2, style(tex) replace star(0.05 0.01) b(%9.3fc) se(%9.3f par) conslbl("Intercept") label stats(N) stfmt(%9.0f) keep(t1 t2 t2hi t2low _cons)  

* Table 2: Treatment effect on vote switching
generate switch=.
replace switch=0 if wtanewusd==. & vignette=="A" & avote=="1"
replace switch=1 if wtanewusd!=. & vignette=="A" & avote=="1"
tabulate switch t, col
qui xtmixed switch t1 t2 i.block i.enumerator, ||cid: ||village:
estimates store S1
estout1 S1, style(tex) star(0.05 0.01) replace b(%9.3fc) se(%9.3f par) conslbl("Intercept") label keep(t1 t2 _cons) stats(N) stfmt(%9.0f)

*Figure 2: Effect on price of vote
preserve
collapse (mean) wtanewusd if vignette=="A", by(cid block t)
collapse (mean) meanwtanew = wtanewusd (sd) sdwtanew = wtanewusd (count) n=wtanewusd, by(t)
generate hiwta = meanwtanew + invttail(n-1,0.05)*(sdwtanew/sqrt(2*n))
generate lowta = meanwtanew - invttail(n-1,0.05)*(sdwtanew/sqrt(2*n))
twoway (bar meanwtanew t, barwidth(.8)) (rcap hiwta lowta t), scale(1.2) xlabel(0 1 2, noticks) ///
xtitle("Treatment Group") ytitle("Price of vote for poor performer (USD)") ///
scheme(s2mono) graphregion(fcolor(white))  ///
legend( order(1 "Group mean" 2 "5% Statistical Significance Bar") ) 
*graph save "Graphs\Figure2", replace
*graph export "Graphs/Figure2.pdf", replace
*graph export "Graphs/Figure2.eps", replace
restore

xtmixed wtanewusd t1 t2 i.block i.enumerator if vignette=="A", ||cid: ||village:

* Table 3: Effect on voting criteria
generate bvote0=bvote if btype==1
generate bvote1=bvote if btype==2
generate bvote2=bvote if btype==3
preserve
collapse (mean) bvote* , by(cid t1 t2 t block)
ttest bvote1==bvote0 if t==0
ttest bvote1==bvote0 if t==1
ttest bvote1==bvote0 if t==2
ttest bvote2==bvote0 if t==0
ttest bvote2==bvote0 if t==1
ttest bvote2==bvote0 if t==2
generate diff1=bvote1-bvote0
generate diff2=bvote2-bvote0
generate diff3=bvote2-bvote1
drop cid t1 t2 bvote bvoteshare
reshape wide diff1 diff2 diff3 bvote0 bvote1 bvote2, i(block) j(t)
ttest diff10==diff11
ttest diff10==diff12
ttest diff11==diff12
ttest diff20==diff21
ttest diff20==diff22
ttest diff21==diff22
restore

xtmixed bvote i.t##i.btype i.block i.enumerator, ||cid: ||village:

* Table S2: Experimental sample balance test
replace pop09=pop09/1000
preserve
collapse (mean) nvillages majparty incumbentmayor povertyindex arrondissement periurban ELG06 pop09, by(cid t t1 t2)
replace t1=. if t==2
replace t2=. if t==1
foreach var of varlist nvillages majparty incumbentmayor povertyindex arrondissement periurban ELG06 pop09 {
cap ttest `var', by(t1)
local `var'diff1 = `r(mu_2)' - `r(mu_1)'
local `var'se1 = `r(se)' 
cap ttest `var', by(t2)
local `var'diff2 = `r(mu_2)' - `r(mu_1)'
local `var'se2 = `r(se)' 
di as text "`var'" " & " as result  %8.3f `r(mu_1)' " & " %8.3f ``var'diff1' " & " %8.3f ``var'diff2' " & " "63" "\\" " &  & " "("%8.3f ``var'se1' ")" " & " "(" %8.3f ``var'se2' ")" " & " "\\"
}
hotelling nvillages majparty incumbentmayor povertyindex arrondissement periurban ELG06 pop09, by(t1)
hotelling nvillages majparty incumbentmayor povertyindex arrondissement periurban ELG06 pop09, by(t2)
restore

* Table S3: Restitution balance test
replace pop09=pop09/1000
preserve 
collapse (mean) nvillages majparty incumbentmayor povertyindex arrondissement periurban ELG06 pop09, by(cid restitution)
foreach var of varlist nvillages majparty incumbentmayor povertyindex arrondissement periurban ELG06 pop09 {
cap ttest `var', by(restitution)
local `var'diff = `r(mu_2)' - `r(mu_1)'
local `var'se = `r(se)' 
di as text "`var'" " & " as result  %8.3f `r(mu_1)' " & " %8.3f ``var'diff'  "\\" " &  & " "("%8.3f ``var'se' ")"   "\\"
}
hotelling nvillages majparty incumbentmayor povertyindex arrondissement periurban ELG06 pop09, by(rest)
restore

* Table S4: Knowledge of public goods
replace cprojectsother=lower(cprojectsother)
generate know_well=0
replace know_well=1 if strpos(cprojects, "1") | strpos(cprojectsother, "pui") | strpos(cprojectsother, "buit") | strpos(cprojectsother, "eau") | strpos(cprojectsother, "cau") 
replace know_well=0 if pg_well!=1
generate know_clinic=0
replace know_clinic=1 if strpos(cprojects, "2") | strpos(cprojects, "8")
replace know_clinic=0 if pg_clinic!=1
generate know_school=0
replace know_school=1 if strpos(cprojects, "3") | strpos(cprojectsother, "ecole") | strpos(cprojectsother, "alpha") | strpos(cprojectsother, "class")
replace know_school=0 if pg_school!=1
generate know_vaccin=0
replace know_vaccin=1 if strpos(cprojects, "5") & pg_vaccin==1
replace know_vaccin=0 if pg_vaccin!=1
generate know_garden=0
replace know_garden=1 if strpos(cprojects, "7") | strpos(cprojectsother, "jardin") | strpos(cprojectsother, "fardin") | strpos(cprojectsother, "marai")
replace know_garden=0 if pg_garden!=1
generate know_road=0
replace know_road=1 if strpos(cprojects, "4") | strpos(cprojectsother, "piste")
replace know_road=0 if pg_road!=1
generate know_grain=0
replace know_grain=1 if strpos(cprojects, "6") | strpos(cprojectsother, "moulin")
replace know_grain=0 if pg_grain!=1
egen know_all=rowtotal(know_*)

egen pg_all=rowtotal( pg_well pg_clinic pg_school pg_market pg_vaccin pg_garden pg_road pg_grain pg_center pg_mosque)

generate know_none=0
replace know_none=1 if cprojects=="0"
preserve
collapse (sum) know_none, by(vid)
rename know_none no_pg
sort vid
tempfile t1
save `t1'
restore
merge vid using `t1'

xtmixed know_all t1 t2 i.enumerator i.block, ||cid: ||village:
estimates store M1
estout1 M1, style(tex) star(0.05 0.01) replace b(%9.3fc) se(%9.3f par) conslbl("Intercept") label keep(t1 t2 _cons)stats(N r2)

* Table S5: Heterogeneous effects on vote
generate wtanewusd1=wtanewusd
replace wtanewusd1=40 if wtanewusd==. & avote=="1"
foreach var in leader woman school01{
generate `var'_t1=`var'*t1
generate `var'_t2=`var'*t2
}
set more off
xtmixed wtanewusd1 t1 t2 i.block if vignette=="A", ||cid: ||village:
estimates store M2
xtmixed wtanewusd1 t1 t2 leader leader_t1 leader_t2 i.block, ||cid: ||village:
estimates store M3
xtmixed wtanewusd1 t1 t2 woman woman_t1 woman_t2 i.block, ||cid: ||village:
estimates store M4
xtmixed wtanewusd1 t1 t2 school01 school01_t1 school01_t2 i.block, ||cid: ||village:
estimates store M5
estout1 M2 M3 M4 M5, style(tex) star(0.05 0.01) replace b(%9.3fc) se(%9.3f par) conslbl("Intercept") label keep(t1 t2 leader leader_t1 leader_t2 woman woman_t1 woman_t2 school01 school01_t1 school01_t2 _cons)stats(N r2)

************************************
* Analyses of restitution data for tables 
************************************

* Table 4: Effect on challenges during town hall
use "Restitutions_AJPS", clear
generate secondrestitution=.
replace secondrestitution=1 in 368/381
sort cid
merge cid using "Commune data.dta"
table _merge
drop if _merge==2
replace cid=25571 if secondrestitution==1
collapse (sum) challengecomplaint if prefet!=1, by(cid t nvillages)
table t
generate tc=.
replace tc=0 if t==0
replace tc=1 if t==1
replace tc=1 if t==2

ttest challengecomplaint if t!=2, by(t)
ttest challengecomplaint if t!=1, by(t)
ttest challengecomplaint, by(tc)

program mydiff, rclass
	su challengecomplaint if t==1, meanonly
	local mean_t = r(mean)
	su challengecomplaint if t==0, meanonly
	return scalar diff = `mean_t' - r(mean)
end
permute t r(diff), reps(1000): mydiff

program drop mydiff
program mydiff, rclass
	su challengecomplaint if t==2, meanonly
	local mean_t = r(mean)
	su challengecomplaint if t==0, meanonly
	return scalar diff = `mean_t' - r(mean)
end
permute t r(diff), reps(1000): mydiff

program drop mydiff
program mydiff, rclass
	su challengecomplaint if tc==1, meanonly
	local mean_t = r(mean)
	su challengecomplaint if t==0, meanonly
	return scalar diff = `mean_t' - r(mean)
end
permute t r(diff), reps(1000): mydiff
