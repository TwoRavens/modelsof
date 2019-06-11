* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Table 3
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the diff-in-diff results for closely held firms



*--------- APPENDIX TABLE 3 ---------*
   use "$data/dta/DID_vals.dta", clear
	
  loc pt_basicvars pt_posemp pt_lnemp_cop pt_rev_emp pt_va_emp pt_ebitd_emp pt_wb_emp pt_s1_emp pt_lcomp_emp pt_rat_broad pt_avg_tax

     * adjust elasticities and mean outcome variables for "differenced" variables
      foreach vv in "rat_stay_diff" "rat_leave_diff" "rat_ent_gain" "wage_sep_gain" "pt_rat_stay_diff" "pt_rat_leave_diff" "pt_rat_ent_gain" "pt_wage_sep_gain" {
        loc nondiff = subinstr(subinstr("`vv'","_diff","",1),"_gain","",1)
        cap replace `vv' = `nondiff' if variables == "Mean dep var"
        cap replace `vv' = 100 * ( `vv'[1] * (1 / `vv'[3]) ) if variables == "Elasticity"
      }
      
      foreach vv in "pt_lnemp_cop"{
        cap replace `vv' = . if variables == "Elasticity"
      }
      
      keep `pt_basicvars'
      order `pt_basicvars'
      mkmat *, mat(tabbasicpt)

	  
  mat tabcloselyheld = tabbasicpt 
  
  matrix_to_txt, saving("$tables/appx_table3.txt") mat(tabcloselyheld) title(<tab:appx_table3>) replace
