capture log close
clear

set matsize 800
set more off

local dir "data_Pinotti_RESTAT2012"
cd "$_dir"

log using results.log, replace
use individual_level_data, clear

********************************** INDIVIDUAL-LEVEL RESULTS **********************************

****** TABLE 1 *******
preserve
gen observations=1
collapse control trust pop2000 (sum) observations, by(codewb)
replace pop2000=pop2000*1000
list codewb observations pop2000 control trust
restore

****** TABLE 2 *******
ologit control trust [pw=weight], robust 
xi: ologit control trust i.codewb [pw=weight], robust cluster(codewb)
xi: ologit control trust age age2 female highincome lowincome highschool lowschool female i.codewb [pw=weight], robust cluster(codewb)
xi: ologit control trust insider age age2 female highincome lowincome highschool lowschool female i.codewb [pw=weight], robust cluster(codewb)
xi: ologit control trust burpol incumbent age age2 female highincome lowincome highschool lowschool female i.codewb [pw=weight], robust cluster(codewb)
xi: ologit control trust age age2 female highincome lowincome highschool lowschool female i.codewb [pw=weight] if insider==0, robust cluster(codewb)
xi: ologit control trust age age2 female highincome lowincome highschool lowschool female i.codewb [pw=weight] if insider==1, robust cluster(codewb)

* additional results: no weighting
ologit control trust, robust 
xi: ologit control trust i.codewb, robust cluster(codewb)
xi: ologit control trust age age2 female highincome lowincome highschool lowschool female i.codewb, robust cluster(codewb)
xi: ologit control trust insider age age2 female highincome lowincome highschool lowschool female i.codewb, robust cluster(codewb)
xi: ologit control trust burpol incumbent age age2 female highincome lowincome highschool lowschool female i.codewb, robust cluster(codewb)
xi: ologit control trust age age2 female highincome lowincome highschool lowschool female i.codewb if insider==0, robust cluster(codewb)
xi: ologit control trust age age2 female highincome lowincome highschool lowschool female i.codewb if insider==1, robust cluster(codewb)


****** FIGURE 1 *******
tab control if trust==0
tab control if trust==1

****** FIGURE 1 *******
tab control if burpol==1
tab control if incumbent==1
tab control if insider==0


********************************** CROSS-COUNTRY RESULTS **********************************
collapse control, by(codewb)
rename control demand_for_regulation

merge m:1 codewb using crosscountry
drop _m


****** TABLE 3 *******
pwcorr entry costs_of_procedures trust lngdp99 lnpop99 water_pollution unofficial_economy, sig
sum entry costs_of_procedures trust lngdp99 lnpop99 water_pollution unofficial_economy

****** TABLE 4 *******
reg entry trust, r
reg entry trust lngdp99, r
reg entry trust lngdp99 lnpop99, r
reg demand_for_regulation trust, r
reg demand_for_regulation trust lngdp99, r
reg demand_for_regulation trust lngdp99 lnpop99, r

****** TABLE 5 *******
reg costs_of_procedures trust, r
reg costs_of_procedures trust lngdp99, r
reg costs_of_procedures trust lngdp99 lnpop99, r
reg time_to_complete trust, r
reg time_to_complete trust lngdp99, r
reg time_to_complete trust lngdp99 lnpop99, r


****** TABLE 6 *******
reg water_pollution entry, r
reg water_pollution entry trust, r
gen reducedsample=e(sample)
reg water_pollution entry if reducedsample==1, r
reg water_pollution entry lngdp99, r
reg water_pollution entry trust lngdp99, r
reg unofficial_economy entry, r
reg unofficial_economy entry trust, r
replace reducedsample=e(sample)
reg unofficial_economy entry if reducedsample==1, r
reg unofficial_economy entry lngdp99, r
reg unofficial_economy entry trust lngdp99, r

****** TABLE 7 *******
ivreg2 water_pollution (entry=lnpop99), r first 
ivreg2 water_pollution lngdp99 (entry=lnpop99), r first 
ivreg2 unofficial_economy (entry=lnpop99), r first 
ivreg2 unofficial_economy lngdp99 (entry=lnpop99), r first 


****** FIGURE 3 ********
qui reg unofficial_economy trust
predict resshd, r
qui reg water_pollution trust
predict reswtr, r
qui reg entry trust
predict resprocs, r

twoway (scatter unofficial_economy entry) (lfit unofficial_economy entry), ytitle(Shadow Economy) ytitle(, margin(medium)) xtitle(Ln Number of Procedures) xtitle(, margin(medium)) legend(off) scheme(s1color)
graph copy shd, replace
twoway (scatter water_pollution entry) (lfit water_pollution entry), ytitle(Water Pollution) ytitle(, margin(medium)) xtitle(Ln Number of Procedures) xtitle(, margin(medium)) legend(off) scheme(s1color)
graph copy wtr, replace
twoway (scatter resshd resprocs) (lfit resshd resprocs), ytitle("Shadow Economy | TRUST") ytitle(, margin(medium)) xtitle("Ln Number of Procedures | TRUST") xtitle(, margin(medium)) legend(off) scheme(s1color)
graph copy shdres, replace
twoway (scatter reswtr resprocs) (lfit reswtr resprocs), ytitle("Water Pollution | TRUST") ytitle(, margin(medium)) xtitle("Ln Number of Procedures | TRUST") xtitle(, margin(medium)) legend(off) scheme(s1color)
graph copy wtrres, replace
graph combine shd wtr shdres wtrres
graph save figurebias, replace 
