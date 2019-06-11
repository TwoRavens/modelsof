* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Table 8
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the diff-in-diff results for earnings of officers/owners


*--------- APPENDIX TABLE 8 ---------*

   use "$data/dta/DID_vals.dta", clear

   local wage = " wage_off wage_sal rat_nonoffcomp"
   local pt_wage = " pt_wage_off pt_wage_sal pt_rat_nonoffcomp pt_wage_ownw2 pt_pay_own pt_wage_nonown"

   
   keep `wage' `pt_wage'
   order `wage' `pt_wage'

    mkmat *, mat(tabwage)
    mat li tabwage
    matrix_to_txt, saving("$tables/appx_table8.txt") mat(tabwage) title(<tab:appx_table8>) replace

  
