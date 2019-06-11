*===============================================================*
*Do-File: 
*Do State Responses to Automation Matter for Voters? *
*Research and Politics *
*ISSP FILE *

*January 25th 2019*
*===============================================================*

/*cd "SET WORKING DIRECTORY"*/

log using "RP.log", replace


use "ISSP_Combined.dta", clear

set more off



local table_1 1
local table_2 1
local figure_2a 1
local figure_2b 1
local supplementary 1

if `table_1'==1 {

*=========*
* Table 1 *
*=========*


mlogit pf3 
outreg2 using table_mnl1.xls , excel dec(2) stats(coef se ) replace


local indvar sex age nosec degree unemployed_all  i.cycle i.party_type
local context unemployment_rate i.prop 
local cv cy2

* Baseline
mlogit pf3 `indvar' `context' group_RTI2 [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl1.xls , excel dec(2) stats(coef se ) append 


* inactivity interaction

mlogit pf3 `indvar' `context' c.group_RTI2##c.m_inactive_rate_older    [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl1.xls , excel dec(2) stats(coef se ) append 

* public services interaction

mlogit pf3 `indvar' `context' c.group_RTI2##c.m_prog_gdp9002   [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl1.xls , excel dec(2) stats(coef se ) append 

* epl interaction

mlogit pf3 `indvar' `context' c.group_RTI2##c.m_epl_combined    [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl1.xls , excel dec(2) stats(coef se ) append
}

if `table_2'==1 {

*=========*
* Table 2 *
*=========*


reg vote_sd
outreg2 using table_fe.xls , excel dec(2) stats(coef se ) replace


foreach y of varlist vote_sd vote_rpopX  {

local indvar sex age nosec degree unemployed_all  i.year i.party_type
local context unemployment_rate gov_left1
local cv cy

* Baseline
areg  `y' `indvar' `context' group_RTI2  [pweight=weight] , a(ccode) cluster(`cv')
outreg2 using table_fe.xls , excel dec(2) stats(coef se ) append 

* inactivity interaction
areg  `y' `indvar' `context'  c.group_RTI2##c.inactive_rate_older  [pweight=weight] , a(ccode) cluster(`cv')
outreg2 using table_fe.xls , excel dec(2) stats(coef se ) append 

* public services interaction
areg  `y' `indvar' `context'  c.group_RTI2##c.prog_gdp9002  [pweight=weight] , a(ccode) cluster(`cv')
outreg2 using table_fe.xls , excel dec(2) stats(coef se ) append 


* epl interaction
areg  `y' `indvar' `context'  c.group_RTI2##c.epl_combined  [pweight=weight] , a(ccode) cluster(`cv')
outreg2 using table_fe.xls , excel dec(2) stats(coef se ) append

}

}

if `figure_2a'==1 {

*=========*
* Figure 2a *
*=========*
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_inactive_rate ///
unemployment_rate i.prop  ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins, dydx(group_RTI2) at  (  m_inactive_rate=(.15)   m_inactive_rate=(.5 )) predict(outcome(2)) post 
est store sd_full_inactive_dydx

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_prog_gdp9002 ///
unemployment_rate i.prop  ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins, dydx(group_RTI2)  at ( m_prog_gdp9002=(0.065)   m_prog_gdp9002=(0.115 )) predict(outcome(2)) post 
est store sd_full_inkind_dydx

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_epl_combined ///
unemployment_rate i.prop  ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins, dydx(group_RTI2)  at  ( m_epl_combined=(0.5) m_epl_combined=(2.8 )) predict(outcome(2)) post 
est store sd_full_epl_dydx

coefplot (sd_full_inactive_dydx,  msymbol(D) mlcolor(magenta) ciopts(lcolor(magenta)) ///
 lcolor(magenta) mfcolor(magenta*.3)) ///
(sd_full_inkind_dydx, msymbol(S) mfcolor(white) msize(large)) /// 
(sd_full_epl_dydx,  msize(large)), xline(0) ///
legend(order(2 "Inactivity" 4 "In-Kind Spending" 6 "EPL"))  ///
coeflabels(1._at = "Low Compensation" 2._at = "High Compensation") ///
title("Marginal Effect of Lowest to Highest Routine Exposure on Mainstream Left Vote", size(small)) graphregion(color(white)) name("highR", replace)
graph export "S_MARGINAL_MNL.eps", as(eps) preview(off) replace 
}

if `figure_2b'==1 {

*=========*
* Figure 2b *
*=========*

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_inactive_rate ///
unemployment_rate i.prop  ///
i.party_type  i.cycle  if m_right_pop!=0 & sample1==1   [pweight=weight] , cluster(cy2) 
margins,   dydx(group_RTI2)at ( m_inactive_rate=(.15)  m_inactive_rate=(.5 )) predict(outcome(4)) post 
est store rpop_full_inactive_dydx


mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_prog_gdp9002 ///
unemployment_rate i.prop  ///
i.party_type   i.cycle if m_right_pop!=0 & sample1==1   [pweight=weight] , cluster(cy2) 
margins, dydx(group_RTI2) at (m_prog_gdp9002=(0.065)  m_prog_gdp9002=(0.115 )) predict(outcome(4)) post 
est store rpop_full_inkind_dydx


mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_epl_combined ///
unemployment_rate i.prop  ///
i.party_type  i.cycle  if m_right_pop!=0 & sample1==1   [pweight=weight] , cluster(cy2) 
margins, dydx(group_RTI2) at  ( m_epl_combined=(0.8)   m_epl_combined=(2.8 )) predict(outcome(4)) post 
est store rpop_full_epl_dydx

coefplot (rpop_full_inactive_dydx,  msymbol(D) mlcolor(magenta) ciopts(lcolor(magenta)) ///
lcolor(magenta) mfcolor(magenta*.3)) ///
(rpop_full_inkind_dydx, msymbol(S) mfcolor(white) msize(large)) /// 
(rpop_full_epl_dydx,  msize(large)), xline(0) ///
legend(order(2 "Inactivity" 4 "In-Kind Spending" 6 "EPL"))  ///
coeflabels(1._at = "Low Compensation" 2._at = "High Compensation") ///
title("Marginal Effect of Lowest to Highest Routine Exposure on Populist Vote", size(small)) graphregion(color(white)) name("highR", replace)
graph export "R_MARGINAL_MNL.eps", as(eps) preview(off) replace 


}

if `supplementary'==1 {


local mnl_restricted 		 1
local mnl_cycles			 1 
local mnl_occupation		 1 
local mnl_age			     1 
local random_effects		 1 
local graphs_levels		 	 1 

if `mnl_restricted'==1 {

mlogit pf3 
outreg2 using table_mnl2.xls , excel dec(2) stats(coef se ) replace


local indvar sex age nosec degree unemployed_all  i.cycle i.party_type
local context unemployment_rate  i.prop
local cv cy2

* Baseline
mlogit pf3 `indvar' `context' group_RTI [pweight=weight] if m_right_pop!=0 & sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl2.xls , excel dec(2) stats(coef se ) append 


* inactivity interaction

mlogit pf3 `indvar' `context' c.group_RTI##c.m_inactive_rate_older    [pweight=weight] if m_right_pop!=0 & sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl2.xls , excel dec(2) stats(coef se ) append 

* public services interaction

mlogit pf3 `indvar' `context' c.group_RTI##c.m_prog_gdp9002   [pweight=weight] if m_right_pop!=0 & sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl2.xls , excel dec(2) stats(coef se ) append 

* epl interaction

mlogit pf3 `indvar' `context' c.group_RTI##c.m_epl_combined    [pweight=weight] if m_right_pop!=0 & sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl2.xls , excel dec(2) stats(coef se ) append


}

if `mnl_cycles'==1 {

local sd_cycles 	1
local rpop_cycles	1
tab cycle, gen(c)


if `sd_cycles'==1 {
** Inactivity ** 

foreach y of varlist c1-c4 {
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_inactive_rate ///
unemployment_rate i.prop  ///
i.party_type     [pweight=weight] if `y'==1 & sample1==1, cluster(cy2) 
margins, dydx(group_RTI2) at  (m_inactive_rate=(.2)   m_inactive_rate=(.5 )) predict(outcome(2)) post 
est store sd_`y'_inactive_dydx
}

coefplot sd_c1_inactive_dydx sd_c2_inactive_dydx sd_c3_inactive_dydx sd_c4_inactive_dydx, xline(0) ///
xline(0) legend(order(1 "1995-2000" 3 "2000-2005" 5 "2005-2010" 7 "2010-2015")) ///
coeflabels(1._at = "Low Compensation"  2._at = "High Compensation",  labsize(small)) ///
title("By Levels of Inactivity", size(medium)) ///
 graphregion(color(white)) ///
name (s_inac_cyc, replace)
graph export "S_CYCLE_INAC.eps", as(eps) preview(off) replace



** In Kind ** 

foreach y of varlist c1-c4 {

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_prog_gdp9002 ///
unemployment_rate i.prop  ///
 i.party_type [pweight=weight] if `y'==1 & sample1==1, cluster(cy2) 
margins, dydx(group_RTI2) at  (m_prog_gdp9002=(0.065)  m_prog_gdp9002=(0.115 )) predict(outcome(2)) post 
est store sd_`y'_inkind_dydx

}

 coefplot sd_c1_inkind_dydx sd_c2_inkind_dydx sd_c3_inkind_dydx sd_c4_inkind_dydx, xline(0) ///
xline(0) legend(order(1 "1995-2000" 3 "2000-2005" 5 "2005-2010" 7 "2010-2015")) ///
coeflabels(1._at = "Low Compensation"  2._at = "High Compensation",  labsize(small) ) ///
title("By Levels In Kind", size(medium)) ///
 graphregion(color(white)) ///
name (s_inkind_cyc, replace)
graph export "S_CYCLE_INKIND.eps", as(eps) preview(off) replace

** EPL **
foreach y of varlist c1-c4 {
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_epl_combined ///
unemployment_rate i.prop  ///
 i.party_type     [pweight=weight] if `y'==1 & sample1==1, cluster(cy2) 
margins, dydx(group_RTI2) at  (m_epl_combined=(0.8)   m_epl_combined=(2.8 )) predict(outcome(2)) post 
est store sd_`y'_epl_dydx
}
coefplot sd_c1_epl_dydx sd_c2_epl_dydx  sd_c3_epl_dydx sd_c4_epl_dydx, xline(0) ///
xline(0) legend(order(1 "1995-2000" 3 "2000-2005" 5 "2005-2010" 7 "2010-2015")) ///
coeflabels(1._at = "Low Compensation"  2._at = "High Compensation",  labsize(small)  ) ///
title("By Levels of EPL", size(medium)) graphregion(color(white)) ///
name (s_epl_cyc, replace)
graph export "S_CYCLE_EPL.eps", as(eps) preview(off) replace


graph combine s_inac_cyc s_inkind_cyc s_epl_cyc, graphregion(color(white)) ///
title("Marginal Effect of Routine on Left Vote")
graph export "S_CYCLE_COMB.eps", as(eps) preview(off) replace

}



if `rpop_cycles'==1 {
** Inactivity ** 

foreach y of varlist c1-c4 {
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_inactive_rate ///
unemployment_rate i.prop  ///
i.party_type     [pweight=weight] if `y'==1 & sample1==1, cluster(cy2) 
margins, dydx(group_RTI2) at  (m_inactive_rate=(.2)   m_inactive_rate=(.5 )) predict(outcome(4)) post 
est store rpop_`y'_inactive_dydx
}

coefplot rpop_c1_inactive_dydx rpop_c2_inactive_dydx rpop_c3_inactive_dydx rpop_c4_inactive_dydx, xline(0) ///
xline(0) legend(order(1 "1995-2000" 3 "2000-2005" 5 "2005-2010" 7 "2010-2015")) ///
coeflabels(1._at = "Low Compensation"  2._at = "High Compensation",  labsize(small)  ) ///
title("By Levels of Inactivity", size(medium)) graphregion(color(white)) ///
name (r_inac_cyc, replace)
graph export "R_CYCLE_INAC.eps", as(eps) preview(off) replace



** In Kind ** 

foreach y of varlist c1-c4 {

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_prog_gdp9002 ///
unemployment_rate i.prop  ///
 i.party_type [pweight=weight] if `y'==1 & sample1==1, cluster(cy2) 
margins, dydx(group_RTI2) at  (m_prog_gdp9002=(0.065)  m_prog_gdp9002=(0.115 )) predict(outcome(4)) post 
est store rpop_`y'_inkind_dydx

}

 coefplot rpop_c1_inkind_dydx rpop_c2_inkind_dydx rpop_c3_inkind_dydx rpop_c4_inkind_dydx, xline(0) ///
xline(0) legend(order(1 "1995-2000" 3 "2000-2005" 5 "2005-2010" 7 "2010-2015")) ///
coeflabels(1._at = "Low Compensation"  2._at = "High Compensation",  labsize(small) ) ///
title("By Levels of In Kind", size(medium)) graphregion(color(white)) ///
name (r_inkind_cyc, replace)
graph export "R_CYCLE_INKIND.eps", as(eps) preview(off) replace

** EPL **
foreach y of varlist c1-c4 {
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_epl_combined ///
unemployment_rate i.prop  ///
 i.party_type     [pweight=weight] if `y'==1 & sample1==1 , cluster(cy2) 
margins, dydx(group_RTI2) at  (m_epl_combined=(0.8)   m_epl_combined=(2.8 )) predict(outcome(2)) post 
est store rpop_`y'_epl_dydx

}
coefplot rpop_c1_epl_dydx rpop_c2_epl_dydx rpop_c3_epl_dydx rpop_c4_epl_dydx, xline(0) ///
xline(0) legend(order(1 "1995-2000" 3 "2000-2005" 5 "2005-2010" 7 "2010-2015")) ///
coeflabels(1._at = "Low Compensation"  2._at = "High Compensation",  labsize(small)  ) ///
title("By Levels of EPL", size(medium)) graphregion(color(white)) ///
name (r_epl_cyc, replace)
graph export "R_CYCLE_EPL.eps", as(eps) preview(off) replace

graph combine r_inac_cyc r_inkind_cyc r_epl_cyc, graphregion(color(white)) ///
title("Marginal Effect of Routine on Populist Vote")
graph export "R_CYCLE_COMB.eps", as(eps) preview(off) replace

}
}
if `mnl_occupation'==1 {
gen farmer=1 if isco_2==61
replace farmer=0 if isco_2!=61

gen teacher=1 if isco_2==23
replace teacher=0 if isco_2!=23

gen asst_teacher=1 if isco_2==33
replace asst_teacher=0 if isco_2!=33

gen group_RTI3=group_RTI2
replace group_RTI3=0 if farmer==1 | teacher==1 
replace group_RTI3=0 if asst_teacher==1


mlogit pf3 
outreg2 using table_mnl1_occ.xls , excel dec(2) stats(coef se ) replace


local indvar sex age nosec degree unemployed_all farmer teacher asst_teacher i.party_type i.cycle 
local context unemployment_rate i.prop 
local cv cy2

* Baseline
mlogit pf3 `indvar' `context' group_RTI3 [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl1_occ.xls , excel dec(2) stats(coef se ) append 


* inactivity interaction

mlogit pf3 `indvar' `context' c.group_RTI##c.m_inactive_rate_older    [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl1_occ.xls , excel dec(2) stats(coef se ) append 

* public services interaction

mlogit pf3 `indvar' `context' c.group_RTI##c.m_prog_gdp9002   [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl1_occ.xls , excel dec(2) stats(coef se ) append 

* epl interaction

mlogit pf3 `indvar' `context' c.group_RTI##c.m_epl_combined    [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl1_occ.xls , excel dec(2) stats(coef se ) append
}


if `mnl_age'==1 {

set more off
mlogit pf3 
outreg2 using table_mnl3.xls , excel dec(2) stats(coef se ) replace


local indvar  age sex  nosec degree unemployed_all  i.cycle i.party_type group_RTI
local context unemployment_rate i.prop 
local cv cy2

* Baseline
mlogit pf3 `indvar' `context'  i.age_groups3 [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl3.xls , excel dec(2) stats(coef se ) append 


* inactivity interaction

mlogit pf3 `indvar' `context' i.age_groups3##c.m_inactive_rate_older    [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl3.xls , excel dec(2) stats(coef se ) append 

* public services interaction

mlogit pf3 `indvar' `context' i.age_groups3##c.m_prog_gdp9002   [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl3.xls , excel dec(2) stats(coef se ) append 

* epl interaction

mlogit pf3 `indvar' `context' i.age_groups3##c.m_epl_combined    [pweight=weight] if sample1==1, base(3) cluster(`cv')
outreg2 using table_mnl3.xls , excel dec(2) stats(coef se ) append
}
if `random_effects'==1 {
*=========*
* Mixed *
*=========*

mixed vote_sd || ccode:, var vce(robust)
outreg2 using table_rel.xls , excel dec(2) stats(coef se ) replace

foreach y of varlist vote_sd vote_rpopX  {

local indvar sex age nosec degree unemployed_all  i.year i.party_type
local context unemployment_rate gov_left1 i.prop
local cv cy

* Baseline
mixed  `y' `indvar' `context' group_RTI2  [pweight=weight]  || ccode:, var vce(robust)
outreg2 using table_rel.xls , excel dec(2) stats(coef se ) append 


* inactivity interaction
mixed  `y' `indvar' `context'  c.group_RTI2##c.inactive_rate_older  [pweight=weight]   || ccode:, var vce(robust)
outreg2 using table_rel.xls , excel dec(2) stats(coef se ) append 

* public services interaction
mixed  `y' `indvar' `context'  c.group_RTI2##c.prog_gdp9002  [pweight=weight]   || ccode:, var vce(robust)
outreg2 using table_rel.xls , excel dec(2) stats(coef se ) append 


* epl interaction
mixed  `y' `indvar' `context'  c.group_RTI2##c.epl_combined  [pweight=weight]  || ccode:, var vce(robust)
outreg2 using table_rel.xls , excel dec(2) stats(coef se ) append

}


}
if `graphs_levels'==1 {

local sd_levels 	1
local rpop_levels	1


if `sd_levels'==1 {

** Inactivity ** 
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_inactive_rate ///
unemployment_rate i.prop  ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(0) m_inactive_rate=(.15)   m_inactive_rate=(.5 )) predict(outcome(2)) post 
est store sd_full_inactive_low


mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_inactive_rate ///
unemployment_rate i.prop  ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(1) m_inactive_rate=(.15)   m_inactive_rate=(.5 )) predict(outcome(2)) post 
est store sd_full_inactive_high


** In Kind **

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_prog_gdp9002 ///
unemployment_rate i.prop  ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=0  m_prog_gdp9002=(0.065)   m_prog_gdp9002=(0.115 )) predict(outcome(2)) post 
est store sd_full_inkind_low

set more off
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_prog_gdp9002 ///
unemployment_rate i.prop  ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=1  m_prog_gdp9002=(0.065)   m_prog_gdp9002=(0.115 )) predict(outcome(2)) post 
est store sd_full_inkind_high

** EPL ** 
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_epl_combined ///
unemployment_rate i.prop ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(0) m_epl_combined=(0.5) m_epl_combined=(2.8 )) predict(outcome(2)) post 
est store sd_full_epl_low


set more off
mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_epl_combined ///
unemployment_rate i.prop ///
i.cycle i.party_type  if sample1==1 & cycle>=5 & cycle<=8    [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(1) m_epl_combined=(0.5) m_epl_combined=(2.8 )) predict(outcome(2)) post 
est store sd_full_epl_high


  coefplot (sd_full_inactive_low,  msymbol(D) mlcolor(magenta) ciopts(lcolor(magenta)) ///
 lcolor(magenta) mfcolor(magenta*.3)) ///
(sd_full_inkind_low, msymbol(S) mfcolor(white) msize(large)) /// 
(sd_full_epl_low,  msize(large)), xline(0) ///
  xline(0) legend(order(2 "Inactivity" 4 "Spending" 6 "EPL")) ///
  coeflabels(1._at = "Low Compensation" 2._at = "High Compensation") ///
  title("Low Routine Voters", size(medium)) graphregion(color(white)) name("LowS", replace)
graph export "S_LOW_FULL_MNL.eps", as(eps) preview(off) replace 

  coefplot (sd_full_inactive_high,  msymbol(D) mlcolor(magenta) ciopts(lcolor(magenta)) ///
 lcolor(magenta) mfcolor(magenta*.3)) ///
(sd_full_inkind_high, msymbol(S) mfcolor(white) msize(large)) /// 
(sd_full_epl_high,  msize(large)), xline(0) ///
  legend(order(2 "Inactivity" 4 "Spending" 6 "EPL"))  ///
  coeflabels(1._at = "Low Compensation" 2._at = "High Compensation") ///
  title("High Routine Voters", size(medium)) graphregion(color(white)) name("highS", replace)
graph export "S_High_FULL_MNL.eps", as(eps) preview(off) replace 


graph combine LowS highS, xcommon graphregion(color(white)) title("Predicted Mainstream Left Vote", size(medium))
graph export "S_FULL_MNL.eps", as(eps) preview(off) replace 


}

if `rpop_levels'==1 {

** Inactive ** 

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_inactive_rate ///
unemployment_rate i.prop  ///
i.party_type  i.cycle   if m_right_pop!=0 & sample1==1  [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(0) m_inactive_rate=(.2)   m_inactive_rate=(.5 )) predict(outcome(4)) post 
est store rpop_full_inactive_low

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_inactive_rate ///
unemployment_rate i.prop  ///
i.party_type i.cycle   if m_right_pop!=0 & sample1==1   [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(1) m_inactive_rate=(.15)  m_inactive_rate=(.5 )) predict(outcome(4)) post 
est store rpop_full_inactive_high


** In Kind ** 

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_prog_gdp9002 ///
unemployment_rate i.prop  ///
i.party_type  i.cycle  if m_right_pop!=0 & sample1==1  [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(0) m_prog_gdp9002=(0.065)  m_prog_gdp9002=(0.115 )) predict(outcome(4)) post 
est store rpop_full_inkind_low

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_prog_gdp9002 ///
unemployment_rate i.prop  ///
i.party_type  i.cycle  if m_right_pop!=0 & sample1==1   [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(1) m_prog_gdp9002=(0.065)  m_prog_gdp9002=(0.115 )) predict(outcome(4)) post 
est store rpop_full_inkind_high


** EPL ** 

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_epl_combined ///
unemployment_rate i.prop  ///
i.party_type i.cycle   if m_right_pop!=0 & sample1==1  [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(0) m_epl_combined=(0.8)   m_epl_combined=(2.8 )) predict(outcome(4)) post 
est store rpop_full_epl_low

mlogit pf3 sex age nosec degree  ///
unemployed_all     ///
c.group_RTI2##c.m_epl_combined ///
unemployment_rate i.prop  ///
i.party_type  i.cycle  if m_right_pop!=0 & sample1==1   [pweight=weight] , cluster(cy2) 
margins,  at  ( group_RTI2=(1) m_epl_combined=(0.8)   m_epl_combined=(2.8 )) predict(outcome(4)) post 
est store rpop_full_epl_high


  coefplot (rpop_full_inactive_low,  msymbol(D) mlcolor(magenta) ciopts(lcolor(magenta)) ///
 lcolor(magenta) mfcolor(magenta*.3)) ///
(rpop_full_inkind_low, msymbol(S) mfcolor(white) msize(large)) /// 
(rpop_full_epl_low,  msize(large)), xline(0) ///
  xline(0) legend(order(2 "Inactivity" 4 "Spending" 6 "EPL")) ///
  coeflabels(1._at = "Low Compensation" 2._at = "High Compensation") ///
  title("Low Routine Voters", size(medium)) graphregion(color(white)) name("LowR", replace)
graph export "R_LOW_FULL_MNL.eps", as(eps) preview(off) replace 

  coefplot (rpop_full_inactive_high,  msymbol(D) mlcolor(magenta) ciopts(lcolor(magenta)) ///
 lcolor(magenta) mfcolor(magenta*.3)) ///
(rpop_full_inkind_high, msymbol(S) mfcolor(white) msize(large)) /// 
(rpop_full_epl_high,  msize(large)), xline(0) ///
  xline(0) legend(order(2 "Inactivity" 4 "Spending" 6 "EPL")) ///
  coeflabels(1._at = "Low Compensation" 2._at = "High Compensation") ///
  title("High Routine Voters", size(medium)) graphregion(color(white)) name("highR", replace)
graph export "R_High_FULL_MNL.eps", as(eps) preview(off) replace 


graph combine LowR highR, xcommon graphregion(color(white)) title("Predicted Right Populist Vote", size(medium))
graph export "R_FULL_MNL.eps", as(eps) preview(off) replace 

}

}

}
