
* Main models, reestimated using Fixed Effects
* Multiple Overimputation correction for Gini measurement error
* AJPS reviewer 4 request
* D.S., Mannheim 7 Oct 2014


set more off

set seed 63521


/* Microdata */
use "../Data.dta", clear

replace Rgdp = Rgdp/10000
replace incdist = incdist/10000
recode rincd (1 2=1)(3=2)(4=3)(5=4)
replace age = age/10

merge m:1 region using "../GiniData.dta"
drop _merge

/* replace Rgini with 5 overimputed data sets */
forvalues i =1/5{
  replace Rgini = RGini`i' if _mi_m==`i'
}

/* center macro vars */
forvalues i = 1/5 {
  foreach v in Rgini Ruerate Rforeign Rgdp Rtech {
    qui sum `v' if _mi_m==`i'
    replace `v' = (`v'-`r(mean)') if _mi_m==`i'
  }
}




  
/* M1: redistribution eq. */

/* M1a: country FE. */
mi est, cmdok: cmp (rincd= c.incdist##c.Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass skillshg skillssp Rforeign Ruerate Rtech Rgdp i.cntryn), ind(5) nolr robust

/* M1b: year FE. */
mi est, cmdok: cmp (rincd= c.incdist##c.Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass skillshg skillssp Rforeign Ruerate Rtech Rgdp i.year), ind(5) nolr robust

/* M1c: country and year FE. */
mi est, cmdok: cmp (rincd= c.incdist##c.Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass skillshg skillssp Rforeign Ruerate Rtech Rgdp i.cntryn i.year), ind(5) nolr robust




/* M2: redistribution and fear eqs. */

/* M2a: country FE */
mi est, cmdok: cmp (rincd= c.incdist##c.Rgini fear c.fear#c.incdist age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass skillshg skillssp Ruerate Rtech Rgdp Rforeign i.cntryn) (fear=incdist Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass victim Rgdp Rforeign i.cntryn), ind(5 5) nolr

/* M2b: time FE */
mi est, cmdok: cmp (rincd= c.incdist##c.Rgini fear c.fear#c.incdist age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass skillshg skillssp Ruerate Rtech Rgdp Rforeign i.year) (fear=incdist Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass victim Rgdp Rforeign i.year), ind(5 5) nolr

/* M2c: country and time FE */
mi est, cmdok: cmp (rincd= c.incdist##c.Rgini fear c.fear#c.incdist age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass skillshg skillssp Ruerate Rtech Rgdp Rforeign i.cntryn i.year) (fear=incdist Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass victim Rgdp Rforeign i.cntryn i.year), ind(5 5) nolr

