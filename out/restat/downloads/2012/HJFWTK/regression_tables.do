* this file runs most of the results for the regression analysis tables 

clear all
set mem 600m
set more off
use final_data_restat

* working adults in analysis only 
keep if age>=18 & age<=60 & hhmemb!=0 & stat_retire!=1 & stat_school!=1

local jobvars "age age2 eduyr pr3-pr9 male"
local jobvars_hh "age_head age_head2 eduyr_head i.province"
local jobvars_hh_fe "age_head age_head2"
local jobvars_fe "age age2"

*** Table 2 ***

xi: clogit selfemp reg2_treat regime2 `jobvars_hh_fe' if (treat==1 | alt_control==1), group(id) cluster(hhidc) nonest
xi: clogit selfemp reg2_treat regime2 `jobvars_hh_fe' if (treat==1 | control==1), group(id) cluster(hhidc) nonest

*** Table 3 ***

tab year, gen(yrdum)
gen treat_1989 = treat*yrdum1
gen treat_1991 = treat*yrdum2
gen treat_1993 = treat*yrdum3
gen treat_1997 = treat*yrdum4
gen treat_2000 = treat*yrdum5
gen treat_2004 = treat*yrdum6

sort id year  
foreach vv in alt_control control {
	xi: clogit selfemp treat_1991-treat_2004 yrdum2-yrdum6 `jobvars_hh_fe' if (treat==1 | `vv'==1), group(id) cluster(hhidc) nonest
}

*** Table 4 ***

* first step: propensity in 1989 (this is Appendix Table 12)*
logit treat age age2 eduyr pr3-pr9 male cadre if year==1989 & (treat==1 | control==1 | alt_control==1), cluster(hhidc)
predict xb
gen pscor89 = xb if year==1989
bysort id: egen pscor = max(pscor89)

sort id year
* columns 1-4 *
foreach var in alt_control control {
	xi: clogit selfemp reg2_treat regime2 i.regime2*pscor `jobvars_hh_fe' if (treat==1 | `var'==1),group(id) cluster(hhidc) nonest
	xi: clogit selfemp reg2_treat regime2 i.regime2*eduyr `jobvars_hh_fe' if (treat==1 | `var'==1),group(id) cluster(hhidc) nonest
}

* column 7-8 *
foreach var in selfemp {
	bysort regime2 id: egen `var'_p2 = max(`var')
}

foreach var in age eduyr age_head {
	bysort regime2 id: egen `var'_p2 = mean(`var')
}

sort regime2 id year
gen flag =1 if id!=id[_n-1] | regime2!=regime2[_n-1]
gen age2_p2 = age_p2^2
gen age_head2_p2 = age_head_p2^2

sort id year

xi: clogit selfemp_p2 reg2_treat regime2 age_head_p2 age_head2_p2 if flag==1 & (treat==1 | alt_control==1), group(id) cluster(hhidc) nonest	
xi: clogit selfemp_p2 reg2_treat regime2 age_head_p2 age_head2_p2 if flag==1 & (treat==1 | control==1), group(id) cluster(hhidc) nonest


*** Table 5 ***

gen treat_not = (treat==1 & (emp_state89==0 | (emp_state89==. & emp_state91==0) | (emp_state89==. & emp_state91==. & emp_state93==0))) if treat!=.
gen treat_yes = (treat==1 & (emp_state89==1 | (emp_state89==. & emp_state91==1) | (emp_state89==. & emp_state91==. & emp_state93==1))) if treat!=.

foreach var in treat_not treat_yes {
	gen reg2_`var' = regime2*`var'
}

sort hhidc year

gen reg2_treat_not_rent = reg2_treat_not*logrent_sub_pre
gen reg2_treat_yes_rent = reg2_treat_yes*logrent_sub_pre

gen emp_p = (emp_priv_restrict==1 | emp_lgcoll==1 | emp_smcoll==1) if emp!=.

xi: clogit emp_p reg2_treat_yes regime2 `jobvars_fe' if (treat_yes==1 | alt_control==1), group(id) cluster(hhidc) nonest
xi: clogit emp_p reg2_treat_yes reg2_treat_yes_rent regime2 `jobvars_fe' if (treat_yes==1 | alt_control==1), group(id) cluster(hhidc) nonest

xi: clogit stat_work reg2_treat_not reg2_treat_yes regime2 `jobvars_fe' if (treat==1 | alt_control==1), group(id) cluster(hhidc) nonest
xi: clogit stat_work reg2_treat_not reg2_treat_yes reg2_treat_not_rent reg2_treat_yes_rent regime2 `jobvars_fe' if (treat==1 | alt_control==1), group(id) cluster(hhidc) nonest
test reg2_treat_not reg2_treat_not_rent
test reg2_treat_yes reg2_treat_yes_rent


*** Table 6 ***

sort id year
xi: regress hrwage_growth reg2_treat i.year age_fd age2_fd if  emp_state[_n-1]==1 & (head==1 | spouse==1) & emp!=emp[_n-1]  & id==id[_n-1] & wage_growth_L>-400 & wage_growth_L<400, cluster(hhidc)

* propensity score approach (Appendix Table 12)
xi: logit treat `jobvars' cadre if year==1989 & (treat==1 | alt_control==1), cluster(hhidc)
predict xb2

gen pscore89 = xb2 if year==1989
bysort id: egen pscore = max(pscore89)
drop xb2 pscore89
gen reg2_pscore = regime2*pscore

sort id year
xi: regress hrwage_growth reg2_treat i.year age_fd age2_fd reg2_pscore if  emp_state[_n-1]==1 & (head==1 | spouse==1) & emp!=emp[_n-1]  & id==id[_n-1] & wage_growth_L>-400 & wage_growth_L<400, cluster(hhidc)

* adding rent subsidy
gen reg2_pscore_rent_L = reg2_pscore*rent_sub_pre
gen reg2_treat_rent_L = reg2_treat*rent_sub_pre

xi: regress wage_growth_L reg2_treat_rent_L reg2_treat i.year age_fd age2_fd  if emp!=emp[_n-1] & emp_state[_n-1]==1 & (head==1 | spouse==1) & id==id[_n-1] & wage_growth_L>-400 & wage_growth_L<400, cluster(hhidc)
test reg2_treat reg2_treat_rent_L

xi: regress wage_growth_L reg2_treat_rent_L reg2_treat reg2_pscore reg2_pscore_rent_L i.year age_fd age2_fd  if emp!=emp[_n-1] & emp_state[_n-1]==1 & (head==1 | spouse==1) & id==id[_n-1] & wage_growth_L>-400 & wage_growth_L<400, cluster(hhidc)
test reg2_treat reg2_treat_rent_L

***	Table 7	 ***
gen reg2_treathh_apprec = reg2_treathh*urb_housprice1_appr_since
gen reg2_treat_apprec = reg2_treat*urb_housprice1_appr_since

sort id year
* column 1-2 *
foreach var in alt_control control {
	xi: clogit selfemp reg2_treat_apprec reg2_treat urb_housprice1_appr_since regime2 `jobvars_fe' if (treat==1 | `var'==1) & year<2004, group(id) robust cluster(province)
	test reg2_treat_apprec reg2_treat
}

bysort hhidc: egen one_pos = max(logprod_assets)
foreach var in alt_control control {
	sort hhidc year

	xi: clogit pos_asset reg2_treathh_apprec reg2_treathh urb_housprice1_appr_since regime2 age_head age_head2 if (treathh==1 | `var'hh==1) & year<2004 & (hhidc!=hhidc[_n-1] | year!=year[_n-1]), group(hhidc) robust cluster(province)
	test reg2_treathh_apprec reg2_treathh

	xi: areg logprod_assets reg2_treathh_apprec reg2_treathh urb_housprice1_appr_since regime2 age_head age_head2 if (treathh==1 | `var'hh==1) & year<2004 & (hhidc!=hhidc[_n-1] | year!=year[_n-1]) & one_pos>0, absorb(hhidc) robust cluster(province)
	test reg2_treathh_apprec reg2_treathh
}

*** Table 8 ***

gen restrict = 1 if (smbiz_own93==1 | selfemp_hh93==1)
gen all = 1
sort hhidc year
foreach vum in restrict all {
		foreach var in  alt_control control {
			xi:areg logprod_assets reg2_treathh regime2 age_head age_head2 if (treathh==1 | `var'hh==1) & `vum'==1 & (hhidc!=hhidc[_n-1] | year!=year[_n-1]), absorb(hhidc)
	}
}

*** Appendix Table 9 ***
gen logrent_subsidy_amt = log(rent_subsidy_amt+1)

xi: regress logwage_broad treat cadre age age2 i.year eduyr male i.province if (treat==1 | alt_control==1) & year<=1993, cluster(hhidc)
xi: regress logwage_broad treat cadre age age2 i.year eduyr male i.occ i.province if (treat==1 | alt_control==1) & year<=1993, cluster(hhidc)
sort hhidc year id
xi: regress logrent_subsidy_amt  logwage_broadhh age age2 cadre i.year eduyr i.province if (treathh==1 | alt_controlhh==1) & year<=1993 & (hhidc!=hhidc[_n-1] | year!=year[_n-1]) & (treat==1 | control==1 | alt_control==1), cluster(hhidc)
xi: areg logrent_subsidy_amt logwage_broadhh age age2 cadre i.year if (treathh==1 | alt_controlhh==1) & year<=1993 & (hhidc!=hhidc[_n-1] | year!=year[_n-1]) & (treat==1 | control==1 | alt_control==1), absorb(hhidc) cluster(hhidc)


*** Appendix Table 10 ***
sort id year
foreach vv in alt_control control{
	xi: clogit apt_own reg2_treat regime2 `jobvars_hh_fe' if (treat==1 | `vv'==1), group(id) cluster(hhidc) nonest
}

*** Appendix Table 11 ***

sort hhidc year 
foreach vv in alt_controlhh controlhh {
	xi: clogit move_remodel reg2_treathh regime2 `jobvars_hh_fe' if (treathh==1 | `vv'==1) & (hhidc!=hhidc[_n-1] | year!=year[_n-1]) , group(hhidc) cluster(hhidc) nonest
}

