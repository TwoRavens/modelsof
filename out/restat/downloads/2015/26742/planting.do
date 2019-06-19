*** PLANTING SEASON ***

version 11
clear all

set memory 50m
set matsize 800
set more off

use OPS_quantities, clear

gen cl = 10000 * prov_32_id + year      /* cluster variable */
drop if year < 2001                     /* no conflict before 2001 */


/* spring only */
cap drop spring
gen spring = 0
replace spring = 1 if province == "Bamyan"
replace spring = 1 if province == "Samangan"
replace spring = 1 if province == "Sari Pul"
replace spring = 1 if province == "Ghazni"
replace spring = 1 if province == "Khost"
replace spring = 1 if province == "Paktika"
replace spring = 1 if province == "Paktya" /* could be fall */
replace spring = 1 if province == "Parwan"
replace spring = 1 if province == "Day Kundi" /* included in Ghor */
replace spring = 1 if province == "Ghor"
replace spring = 1 if province == "Badghis"

/* autumn and spring */
cap drop both 
gen both = 0
replace both = 1 if province == "Badakshan"
replace both = 1 if province == "Takhar"
replace both = 1 if province == "Kapisa"
replace both = 1 if province == "Baghlan"
replace both = 1 if province == "Jawzjan"
replace both = 1 if province == "Logar"
replace both = 1 if province == "Wardak"
replace both = 1 if province == "Hirat"

local fallp l.cas_dc9+l.cas_dc10+l.cas_dc11 /* fall planting */
local springp cas_dc1+cas_dc2+cas_dc3       /* spring planting */
local contrfs cas_dc1+cas_dc2+cas_dc3       /* control fall, short */
local contrfl cas_dc1+cas_dc2+cas_dc3+cas_dc4+cas_dc5 /* control fall, long */
local contrss cas_dc4+cas_dc5+cas_dc6       /* control spring, short */
local contrsl cas_dc4+cas_dc5+cas_dc6+cas_dc7+cas_dc8 /* control spring, long */

/* casualties in planting season */
cap drop cas_dc_plant*
gen cas_dc_plant_1 = (`fallp') * (1-spring) * (1-both)
gen cas_dc_plant_2 = (`springp') * spring * (1-both)
gen cas_dc_plant_3 = (`fallp') * both
forvalues i = 1/3 {
  gen cas_dc_plant_`i'_pos = .
  replace cas_dc_plant_`i'_pos = cas_dc_plant_`i' > 0 if cas_dc_plant_`i' !=.
}
gen cas_dc_plant =  cas_dc_plant_1 + cas_dc_plant_2 + cas_dc_plant_3
gen cas_dc_plant_pos = cas_dc_plant_1_pos + cas_dc_plant_2_pos + cas_dc_plant_3_pos

/* short and long control group */
foreach v in "s" "l" {
  cap drop cas_dc_contr_`v'*
  gen cas_dc_contr_`v'_1 = (`contrf`v'') * (1-spring) * (1-both)
  gen cas_dc_contr_`v'_2 = (`contrs`v'') * (spring + both)
  forvalues i = 1/2 {
    gen cas_dc_contr_`v'_`i'_pos = cas_dc_contr_`v'_`i' > 0
  }
  gen cas_dc_contr_`v'_pos = cas_dc_contr_`v'_1_pos + cas_dc_contr_`v'_2_pos
}

/* treatment group before planting season */
local beforef1 l.cas_dc3+l.cas_dc4+l.cas_dc5
local beforef2 l.cas_dc6+l.cas_dc7+l.cas_dc8
local befores1 l.cas_dc7+l.cas_dc8+l.cas_dc9
local befores2 l.cas_dc10+l.cas_dc11+l.cas_dc12

cap drop cas_dc_before*
forvalues j = 1/2 {
  cap drop cas_dc_before_plant*
  gen cas_dc_before_plant_1 = (`beforef`j'') * (1-spring) * (1-both)
  gen cas_dc_before_plant_2 = (`befores`j'') * spring * (1-both)
  gen cas_dc_before_plant_3 = (`beforef`j'') * both
  forvalues i = 1/3 {
    gen cas_dc_before_plant_`i'_pos = .
    replace cas_dc_before_plant_`i'_pos = cas_dc_before_plant_`i' > 0 if cas_dc_before_plant_`i' !=.
  }
  gen cas_dc_before_plant =  cas_dc_before_plant_1 + cas_dc_before_plant_2 + cas_dc_before_plant_3
  gen cas_dc_before`j' = cas_dc_before_plant_1_pos + cas_dc_before_plant_2_pos + cas_dc_before_plant_3_pos
}

eststo clear
eststo: quietly xi: xtreg q cas_dc_before2 i.ye, fe $stderr nonest
quietly su cas_dc_before2
estadd scalar MEAN `r(mean)'
eststo: quietly xi: xtreg q cas_dc_plant_pos i.ye, fe $stderr nonest
quietly su cas_dc_plant_pos
estadd scalar MEAN `r(mean)'
eststo: quietly xi: xtreg q cas_dc_contr_s_pos i.ye if year > 2001, fe $stderr nonest
quietly su cas_dc_contr_s_pos if year > 2001
estadd scalar MEAN `r(mean)'
eststo: quietly xi: xtreg q cas_dc_contr_l_pos i.ye if year > 2001, fe $stderr nonest
quietly su cas_dc_contr_l_pos if year > 2001
estadd scalar MEAN `r(mean)'
eststo: quietly xi: xtreg q cas_dc_before2 cas_dc_plant_pos cas_dc_contr_s_pos i.ye, fe $stderr nonest
eststo: quietly xi: xtreg q cas_dc_before2 cas_dc_plant_pos cas_dc_contr_l_pos i.ye, fe $stderr nonest
estadd FE: *
estadd YFE: *
esttab using tables_figs/hostile_dc_plant.tex, /// 
  $lab $out2 stats(MEAN FE YFE r2 N, fmt(a 0 0 3 0) /// 
  labels("Mean cas." "District FE" "Year FE" "R$^{2}$" "N" ))


*** Same table for lagged casualties ***
eststo clear
eststo: quietly xi: xtreg q l.cas_dc_before2 i.ye, fe $stderr nonest
quietly su cas_dc_before2
estadd scalar MEAN `r(mean)'
eststo: quietly xi: xtreg q l.cas_dc_plant_pos i.ye, fe $stderr nonest
quietly su cas_dc_plant_pos
estadd scalar MEAN `r(mean)'
eststo: quietly xi: xtreg q l.cas_dc_contr_s_pos i.ye if year > 2002, fe $stderr nonest
quietly su cas_dc_contr_s_pos if year > 2001
estadd scalar MEAN `r(mean)'
eststo: quietly xi: xtreg q l.cas_dc_contr_l_pos i.ye if year > 2002, fe $stderr nonest
quietly su cas_dc_contr_l_pos if year > 2001
estadd scalar MEAN `r(mean)'
eststo: quietly xi: xtreg q l.cas_dc_before2 l.cas_dc_plant_pos l.cas_dc_contr_s_pos i.ye, fe $stderr nonest
eststo: quietly xi: xtreg q l.cas_dc_before2 l.cas_dc_plant_pos l.cas_dc_contr_l_pos i.ye, fe $stderr nonest
estadd FE: *
estadd YFE: *
esttab using tables_figs/hostile_dc_plant_lag.tex,  $out2 stats(FE YFE r2 N, fmt(0 0 3 0) ///
  labels("District FE" "Year FE" "R$^{2}$" "N" )) ///
  varlabels(L.cas_dc_before2 "Casualties, shortly before planting season" ///
            L.cas_dc_plant_pos "Casualties, planting season" ///
			L.cas_dc_contr_s_pos "Casualties, after planting season (short window)" ///
			L.cas_dc_contr_l_pos "Casualties, after planting season (long window)")

  
  
  
