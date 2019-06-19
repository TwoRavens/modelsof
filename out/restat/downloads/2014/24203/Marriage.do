clear all
set more off
set memo 500m
set matsize 800
capture log close


cd ~/Crime

log using marriage.log, text replace

********************************************************************************************

* Table 8: Marriage

********************************************************************************************

use Marriage.dta, clear


********************************************************************************************

* Panel I: Un-weighted

********************************************************************************************

eststo: xi: reg  unmarr_mal_rate lratio  i.id_prov i.category,  r cluster(id_prov)  

eststo: xi: reg  div_mal_rate lratio  i.id_prov i.category,  r cluster(id_prov)  
eststo: xi: reg  unmarr_fem_rate lratio  i.id_prov i.category,  r cluster(id_prov)  
eststo: xi: reg  div_fem_rate lratio  i.id_prov i.category,  r cluster(id_prov)  

esttab using County.tex, label se ar2 keep(lratio) title(Sex Ratios and Marital Status. County-level tabulations, 2000 Census. OLS.) /*
      */ addnote("Source: Tabulations of the 2000 Census, full sample, at the county level.") replace
eststo clear 



eststo: xi: reg  unmarr_mal_rate lratio urb_rate mino_rate  ill_rate potable  imm_rate i.id_prov i.category,  r cluster(id_prov)  

eststo: xi: reg  div_mal_rate lratio urb_rate mino_rate  ill_rate potable  imm_rate i.id_prov i.category,  r cluster(id_prov)  

eststo: xi: reg  unmarr_fem_rate lratio urb_rate mino_rate  ill_rate potable  imm_rate i.id_prov i.category,  r cluster(id_prov)  

eststo: xi: reg  div_fem_rate lratio urb_rate mino_rate  ill_rate potable  imm_rate i.id_prov i.category,  r cluster(id_prov)  

esttab using County.tex, label se ar2 keep(lratio) title(Sex Ratios and Marital Status. County-level tabulations, 2000 Census. OLS.) /*
    */ addnote("Source: Tabulations of the 2000 Census, full sample, at the county level.") append
eststo clear 



********************************************************************************************

* Panel II: Weighted

********************************************************************************************

eststo: xi: reg  unmarr_mal_rate lratio  i.id_prov i.category [fw=pop],  r cluster(id_prov)   

eststo: xi: reg  div_mal_rate lratio  i.id_prov i.category [fw=pop],  r cluster(id_prov)  

eststo: xi: reg  unmarr_fem_rate lratio  i.id_prov i.category [fw=pop],  r cluster(id_prov)  

eststo: xi: reg  div_fem_rate lratio  i.id_prov i.category [fw=pop],  r cluster(id_prov)  

esttab using County.tex, label se ar2 keep(lratio) title(Sex Ratios and Marital Status. County-level tabulations, 2000 Census. OLS.) /*
       */ addnote("Source: Tabulations of the 2000 Census, full sample, at the county level.")  append
eststo clear 



eststo: xi: reg  unmarr_mal_rate lratio urb_rate mino_rate  ill_rate potable  imm_rate i.id_prov i.category [fw=pop],  r cluster(id_prov)  

eststo: xi: reg  div_mal_rate lratio urb_rate mino_rate  ill_rate potable  imm_rate i.id_prov i.category [fw=pop],  r cluster(id_prov)  

eststo: xi: reg  unmarr_fem_rate lratio urb_rate mino_rate  ill_rate potable  imm_rate i.id_prov i.category [fw=pop],  r cluster(id_prov)  

eststo: xi: reg  div_fem_rate lratio urb_rate mino_rate  ill_rate potable  imm_rate i.id_prov i.category [fw=pop],  r cluster(id_prov)  

esttab using County.tex, label se ar2 keep(lratio) title(Sex Ratios and Marital Status. County-level tabulations, 2000 Census. OLS.) /*
    */ addnote("Source: Tabulations of the 2000 Census, full sample, at the county level.") append
eststo clear 

log close

exit, clear



