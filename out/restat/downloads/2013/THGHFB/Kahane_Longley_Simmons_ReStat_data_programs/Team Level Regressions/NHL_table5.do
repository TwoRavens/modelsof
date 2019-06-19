# delimit ;
		
log using NHL_table5.log, replace;	

u NHL_team_data;			

tsset team season;

set more off;


***Produces Table 5 Regression Results***;


**win_pct**;

xtreg win_pct w_c_ppg w_c_pmpg w_c_plumipg  save co_winpct_2  
hhi rel_euro_shr   new_nhl draft_1, fe robust;


xtreg win_pct rel_payroll rel_payroll_sq co_winpct_2  
hhi rel_euro_shr   new_nhl draft_1, fe robust;




**pts_pct**;

xtreg pts_pct w_c_ppg w_c_pmpg w_c_plumipg  save co_winpct_2  
hhi rel_euro_shr   new_nhl draft_1, fe robust;


xtreg pts_pct rel_payroll rel_payroll_sq co_winpct_2  
hhi rel_euro_shr   new_nhl draft_1, fe robust;




**gfga**;

xtreg gfga w_c_ppg w_c_pmpg w_c_plumipg  save co_winpct_2  
hhi rel_euro_shr   new_nhl draft_1, fe robust;


xtreg gfga rel_payroll rel_payroll_sq co_winpct_2  
hhi rel_euro_shr   new_nhl draft_1, fe robust;




