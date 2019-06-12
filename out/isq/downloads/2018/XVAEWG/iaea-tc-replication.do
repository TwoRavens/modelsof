********************************************************************************
***Replication material for 
***Who Gets What from IOs?
***The Case of the International Atomic Energy Agency's 
***Technical Cooperation
********************************************************************************


clear
set more off

use iaea_tc_dataset


****Table 1: Amounts disburced for national projects through TC, 2004-2012
preserve 
format disburs_total disburs_tfc %9.0f
collapse (sum) disburs_total disburs_tfc tc_recipient , by(year)
sort year
list year disburs_total disburs_tfc tc_recipient
restore


****Figure 1: TC amounts to country-years during 2004-2012 period (histogram)

*Disbursements in thousands
gen disburs_tfc2 = disburs_tfc/1000
*hist disburs_tfc2, percent xtitle("Annual TC allocations (in thousand $ US)") ytitle("% of countries") lcolor(black) fcolor(gs13) graphregion(color(white))
drop disburs_tfc2

****Table 2: Summary statistics
sum tc_recipient log_disburs_tfc tc_recipient_sensitive tc_recipient_humanitarian log_gdp_lag log_pop_lag democracy_lag sumconfv412_lag us_distance_lag bog_lag elected_lag designated_lag ap_member_lag new_member_lag nsg_lag nw_lag rsa_country_lag rate_of_attainment_lag

****Table 3: Participation in TC (main results)

*BTSCS
btscs tc_recipient year ccode, g(since) lspline(1,4,7) failure
drop  _frstfl  _tuntilf 
rename _spline1 spline1
rename _spline2 spline2
rename _spline3 spline3
rename _prefail prefail

*Organizing controls
global controls "log_pop_lag democracy_lag  new_member_lag nsg nw rsa_c since spline*"

logit tc_recipient log_gdp_lag sumconfv412_lag us_distance_lag  bog_lag  ap_member_lag, cluster(ccode) robust
logit tc_recipient log_gdp_lag log_gdp_lag_sq sumconfv412_lag us_distance_lag  bog_lag  ap_member_lag $controls, cluster(ccode) robust
logit tc_recipient log_gdp_lag log_gdp_lag_sq sumconfv412_lag c.us_distance_lag##bog_lag  ap_member_lag  $controls, robust cluster(ccode)
logit tc_recipient log_gdp_lag log_gdp_lag_sq sumconfv412_lag c.us_distance_lag##ap_member_lag bog_lag   $controls, robust cluster(ccode)

****Figure 3: Average marginal effect of being in BOG on the likelihood of receiving TC with 95% confidence interval

qui logit tc_recipient c.log_gdp_lag##c.log_gdp_lag sumconfv412_lag c.us_distance_lag##i.bog_lag  ap_member_lag since spline*, robust cluster(ccode)
margins, dydx(bog_lag) at(us_distance_lag=(0(.05)1)) 
marginsplot, yline(0) recastci(rspike) scheme(s1mono) graphregion(color(white)) ytitle("Effect on Pr(TC RECIPIENT)") title("")

****Figure 4: Average marginal effect of AP on the likelihood of receiving TC with 95% confidence interval

qui logit tc_recipient c.log_gdp_lag##c.log_gdp_lag sumconfv412_lag c.us_distance_lag##ap_member_lag bog_lag since spline*, cluster(ccode) robust
margins, dydx(ap_member_lag) at(us_distance_lag=(0(.05)1)) 
marginsplot, yline(0) recastci(rspike) scheme(s1mono) graphregion(color(white)) ytitle("Effect on Pr(TC RECIPIENT)") title("")

****Table 4: Amounts of TC assistance

*Organizing controls
global controls2 "log_pop_lag democracy_lag new_member_lag nsg nw rate_of_attainment_lag"

reg log_disburs_tfc log_disburs_tfc_lag log_gdp_lag sumconfv412_lag us_distance_lag  bog_lag  ap_member_lag if tc_recipient==1, cluster(ccode) robust
reg log_disburs_tfc log_disburs_tfc_lag log_gdp_lag log_gdp_lag_sq sumconfv412_lag us_distance_lag  bog_lag  ap_member_lag $controls2 if tc_recipient==1, cluster(ccode) robust
reg log_disburs_tfc log_disburs_tfc_lag log_gdp_lag sumconfv412_lag c.us_distance_lag##i.bog_lag  ap_member_lag $controls2 if tc_recipient==1, cluster(ccode) robust
reg log_disburs_tfc log_disburs_tfc_lag log_gdp_lag sumconfv412_lag c.us_distance_lag##i.ap_member_lag bog_lag $controls2 if tc_recipient==1, cluster(ccode) robust
reg log_disburs_tfc log_disburs_tfc_lag log_gdp_lag sumconfv412_lag c.us_distance_lag##i.elected_lag c.us_distance_lag##i.designated_lag  ap_member_lag $controls2 if tc_recipient==1, cluster(ccode) robust

*substantive effects
reg log_disburs_tfc log_disburs_tfc_lag log_gdp_lag sumconfv412_lag c.us_distance_lag##i.elected_lag c.us_distance_lag##i.designated_lag  ap_member_lag $controls2 if tc_recipient==1, cluster(ccode) robust
margins, dydx(designated_lag) at(us_distance_lag=0.75) 
margins, dydx(designated_lag) at(us_distance_lag=0.60) 

reg log_disburs_tfc log_disburs_tfc_lag log_gdp_lag sumconfv412_lag c.us_distance_lag##i.ap_member_lag bog_lag $controls2 if tc_recipient==1, cluster(ccode) robust
margins, dydx(ap_member_lag) at(us_distance_lag=0.90) 
margins, dydx(ap_member_lag) at(us_distance_lag=0.40) 

****Table 5: Areas of Assistance

*BTSCS
btscs tc_recipient_sensitive year ccode, g(since_sensitive) nspline(3) failure
drop  _frstfl  _tuntilf 
rename _prefail prefail_sensitive
rename _spline1 sensitive_spline1
rename _spline2 sensitive_spline2
rename _spline3 sensitive_spline3

btscs tc_recipient_humanitarian year ccode, g(since_human) nspline(3) failure
drop  _frstfl  _tuntilf 
rename _prefail prefail_human
rename _spline1 human_spline1
rename _spline2 human_spline2
rename _spline3 human_spline3

global controls3 "log_pop_lag democracy_lag new_member_lag nsg nw rsa_c"

logit tc_recipient_sensitive log_gdp_lag sumconfv412_lag us_distance_lag bog_lag  ap_member_lag since_sensitive  sensitive_s*, cluster(ccode) robust
logit tc_recipient_sensitive c.log_gdp_lag sumconfv412_lag us_distance_lag  bog_lag  ap_member_lag $controls3 since_sensitive  sensitive_s*, cluster(ccode) robust
logit tc_recipient_sensitive c.log_gdp_lag##c.log_gdp_lag sumconfv412_lag us_distance_lag  bog_lag  ap_member_lag $controls3 since_sensitive  sensitive_s*, cluster(ccode) robust

logit tc_recipient_humanitarian log_gdp_lag sumconfv412_lag us_distance_lag bog_lag  ap_member_lag since_human  human_s*, cluster(ccode) robust
logit tc_recipient_humanitarian c.log_gdp_lag sumconfv412_lag us_distance_lag  bog_lag  ap_member_lag $controls3 since_human  human_s*, cluster(ccode) robust
logit tc_recipient_humanitarian c.log_gdp_lag##c.log_gdp_lag sumconfv412_lag us_distance_lag  bog_lag  ap_member_lag $controls3 since_human  human_s*, cluster(ccode) robust

****Table 6: Robustness checks -- excluding countries close to the US ideal point

*Organizing controls
global controls "log_pop_lag democracy_lag  new_member_lag nsg nw rsa_c since spline*"

sum us_distance_lag, de

logit tc_recipient log_gdp_lag log_gdp_lag_sq sumconfv412_lag c.us_distance_lag##bog_lag  ap_member_lag  $controls if us_distance_lag>.67, robust cluster(ccode)
logit tc_recipient log_gdp_lag log_gdp_lag_sq sumconfv412_lag c.us_distance_lag##ap_member_lag bog_lag   $controls if us_distance_lag>.67, robust cluster(ccode)
