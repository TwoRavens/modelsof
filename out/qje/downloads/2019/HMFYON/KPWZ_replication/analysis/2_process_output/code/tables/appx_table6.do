* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Table 6
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the diff-in-diff results for within-firm inequality outcomes, using a balanced panel


*--------- APPENDIX TABLE 6 ---------*
   use "$data/dta/DID_vals.dta", clear
	
  local gap_balvars rat_m_bal rat_f_bal gap_gend_bal rat_inv_bal rat_noninv_bal gap_inv_bal wageq1_bal wageq4_bal gap_wageq14_bal
  
  keep `gap_balvars'
  order `gap_balvars'
  
  mkmat *, mat(tabgap_balpanel)
  matrix_to_txt, saving("$tables/appx_table6.txt") mat(tabgap_balpanel) title(<tab:appx_table6>) replace
  
