* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Table 7
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the diff-in-diff results for within-firm inequality outcomes for stayers only


*--------- APPENDIX TABLE 7 ---------*
   use "$data/dta/DID_vals.dta", clear
	
  local gap_stayvars wage_stayersm wage_stayersf wage_stay_gendiff rat_stay_inv rat_stay_noninv gap_stayers_inv

  keep `gap_stayvars'
  order `gap_stayvars'
  mkmat *, mat(tabgap_staypanel)
  matrix_to_txt, saving("$tables/appx_table7.txt") mat(tabgap_staypanel) title(<tab:appx_table7>) replace
   
