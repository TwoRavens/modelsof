* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 7
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the entry/exit impacts table 



*--------- TABLE 7 ---------*


  use "$data/dta/DID_vals.dta", clear
 
  loc payvars rat_cht rat_stay rat_leave rat_ent wage_ent3 rat_stay_diff rat_leave_diff rat_ent_gain

  * adjust elasticities and mean outcome variables for "differenced" variables
  foreach vv in "rat_stay_diff" "rat_leave_diff" "rat_ent_gain"  {
	loc nondiff = subinstr(subinstr("`vv'","_diff","",1),"_gain","",1)
	cap replace `vv' = `nondiff' if variables == "Mean dep var"
	cap replace `vv' = 100 * ( `vv'[1] * (1 / `vv'[3]) ) if variables == "Elasticity"
  }
  
  keep `payvars'
  order `payvars'
  mkmat *, mat(tabpaypanel)

  matrix_to_txt, saving("$tables/table7.txt") mat(tabpaypanel) title(<tab:table7>) replace

