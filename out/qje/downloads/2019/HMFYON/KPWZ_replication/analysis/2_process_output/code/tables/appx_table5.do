* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Table 5
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the diff-in-diff results for within-firm inequality outcomes


*--------- APPENDIX TABLE 5 ---------*
   use "$data/dta/DID_vals.dta", clear
	
  loc gapvars rat_m rat_f gap_gend rat_inv rat_noninv gap_inv wageq1 wageq4 gap_wageq14

  keep `gapvars'
  order `gapvars'
  
  mkmat *, mat(tabgappanel)
  matrix_to_txt, saving("$tables/appx_table5.txt") mat(tabgappanel) title(<tab:appx_table5>) replace
  
