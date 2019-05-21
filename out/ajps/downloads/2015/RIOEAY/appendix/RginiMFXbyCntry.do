
/*
Calculates inequality MFX by country 
using both pooled and country-specific definitions of
rich and poor

D.S. Dec 19 2014                      
*/




set more off
set seed 63521


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



* Postfile for estimates
postfile pfile type cntryn coefPoor sePoor coefRich seRich coefDiff seDiff using RginiMFXbyCntry, replace





/* M1: redistribution eq */
program m1_est, eclass properties(mi)
cmp (rincd= c.incdist##c.Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass skillshg skillssp Rforeign Ruerate Rtech Rgdp), ind(5) nolr qui
end


/* 
Rgini average marginal effect for low (_at 1) and high (_at 2) income individuals 
Argument 1: county numeric ID
*/
program m1_rgini, eclass properties(mi)
 version 12
 args cntryn
 m1_est
  margins, predict(eq(#1) pr outcome(4)) dydx(Rgini) force at(incdist = -2.5) at(incdist = 3) vsquish noatlegend post, if cntryn==`cntryn'
end

program m1_run 
  args cntryn
  mi est: m1_rgini `cntryn'
  mat B = r(table)
  scalar coefPoor = B[1,1]
  scalar coefRich = B[1,2]
  scalar sePoor = B[2,1]
  scalar seRich = B[2,2]
  mi est (diff21:_b[2._at]-_b[1._at]): m1_rgini `cntryn'
  mat B = r(table)
  scalar coefDiff = B[1,1]
  scalar seDiff = B[2,1]
  post pfile (1) (cntryn) (coefPoor) (sePoor) (coefRich) (seRich) (coefDiff) (seDiff)
end


* Run...
forvalues c = 1(1)14 {
    m1_run `c'    
}





/* Redefine programs to use country specific definitions
    of rich and poor */

program drop m1_rgini m1_run

program m1_rgini, eclass properties(mi)
 version 12
 args cntryn
 m1_est
 tabstat incdist if cntryn==`cntryn', stat(p10 p90) save
 mat R = r(StatTotal)
 local low = R[1,1]
 local hi = R[2,1]
  margins, predict(eq(#1) pr outcome(4)) dydx(Rgini) force at(incdist = `low') at(incdist = `hi') vsquish noatlegend post, if cntryn==`cntryn'
end

program m1_run 
  args cntryn
  mi est: m1_rgini `cntryn'
  mat B = r(table)
  scalar coefPoor = B[1,1]
  scalar coefRich = B[1,2]
  scalar sePoor = B[2,1]
  scalar seRich = B[2,2]
  mi est (diff21:_b[2._at]-_b[1._at]): m1_rgini `cntryn'
  mat B = r(table)
  scalar coefDiff = B[1,1]
  scalar seDiff = B[2,1]
  post pfile (2) (cntryn) (coefPoor) (sePoor) (coefRich) (seRich) (coefDiff) (seDiff)
end


* Run...
forvalues c = 1(1)14 {
    m1_run `c'    
}


postclose pfile

use RginiMFXbyCntry, clear
saveold RginiMFXbyCntry, replace

