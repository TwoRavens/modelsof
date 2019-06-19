
clear
capture log close
clear all
version 10.1

log using randreplication.log, replace
use family_years_for_tables.dta
sum total_spending log_total_spending three_month_spending
gen any_initial = 0 if three_month_spending==0
replace any_initial = 1 if three_month_spending>0 & three_month_spending!=.


********************************************************************************************************************
* Table 6
********************************************************************************************************************

regress any_initial sticker_price share_hitting_mde share_hit_coins demeaned_start_month* demeaned_site*, cluster(ifamily)
ivreg any_initial sticker_price (share_hitting_mde share_hit_coins = sim_instr1 share_hit_coins_v1) demeaned_start_month* demeaned_site*, cluster(ifamily)
regress log_total_spending sticker_price share_hitting_mde share_hit_coins demeaned_start_month* demeaned_site*, cluster(ifamily)
ivreg log_total_spending sticker_price (share_hitting_mde share_hit_coins = sim_instr1 share_hit_coins_v1) demeaned_start_month* demeaned_site*, cluster(ifamily)
regress total_spending sticker_price share_hitting_mde share_hit_coins demeaned_start_month* demeaned_site*, cluster(ifamily)
ivreg total_spending sticker_price (share_hitting_mde share_hit_coins = sim_instr1 share_hit_coins_v1) demeaned_start_month* demeaned_site*, cluster(ifamily)

**************************************
* TABLE A9 
******************************************************


	table plan_group, c(freq mean hit_mde mean eoy_price)


********************************************************************************************************************
* Table A10
*********************************************************************************************************************

table plan_group, c(freq mean total_spending mean log_total_spending)

*end

