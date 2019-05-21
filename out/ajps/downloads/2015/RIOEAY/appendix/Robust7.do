

set more off

set seed 63521

use "../Data.dta", clear

replace Rgdp = Rgdp/10000
replace incdist = incdist/10000
recode rincd (1 2=1)(3=2)(4=3)(5=4)
replace age = age/10


merge m:1 region using "../GiniData.dta"
drop _merge
forvalues i =1/5{
  replace Rgini = RGini`i' if _mi_m==`i'
}

forvalues i = 1/5 {
  foreach v in Rgini Ruerate Rforeign Rgdp Rtech {
    qui sum `v' if _mi_m==`i'
    replace `v' = (`v'-`r(mean)') if _mi_m==`i'
  }
}


replace iscoco=. if iscoco==100|iscoco>=66666
gen temp = string(iscoco)
gen isco1d = substr(temp,1,1)
drop temp

gen skill=.
replace skill=0.66 if isco1d=="1"
replace skill=0.70 if isco1d=="2"
replace skill=1.11 if isco1d=="3"
replace skill=0.70 if isco1d=="4"
replace skill=0.58 if isco1d=="5"
replace skill=2.05 if isco1d=="6"
replace skill=1.89 if isco1d=="7"
replace skill=3.41 if isco1d=="8"
replace skill=1.84 if isco1d=="9"



program m1_est, eclass properties(mi)
bootstrap, clu(region cntry) rep(100): cmp (rincd= c.incdist##c.Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass Rforeign Ruerate Rtech Rgdp skill), ind(5) nolr qui
end

/* Rgini average marginal effect for the rich */
program m1_rgini, eclass properties(mi)
 version 12
 args categ
 m1_est
 margins, predict(pr outcome(`categ')) dydx(Rgini) force at(incdist = 3) vsquish noatlegend post
end

mi est: m1_rgini 4 


program m2_est, eclass properties(mi)
bootstrap, clu(region cntry) rep(100): cmp (rincd= c.incdist##c.Rgini fear c.fear#c.incdist age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass Rforeign Ruerate Rtech Rgdp skill) (fear=incdist Rgini age female eduyrs transue transnlf hhmmb lowsup smempl whcol blcol noclass victim Rgdp Rforeign), ind(5 5) nolr qui
end

/* Rgini average marginal effect for the rich */
program m2_rgini, eclass properties(mi)
 version 12
 args categ
 m2_est
 margins, predict(eq(#1) pr outcome(`categ')) dydx(Rgini) force at(incdist = 3) vsquish noatlegend post
end

mi est: m2_rgini 4 

/* marginal effect of fear (calculated via discrete prob. difference, 3->4) */
program m2_fear, eclass properties(mi)
 version 12
 args categ
 m2_est
 margins, predict(eq(#1) pr outcome(`categ')) force at(incdist = 3 fear=3) at(incdist = 3 fear=4) vsquish noatlegend post
end

mi est (diff21:_b[2._at]-_b[1._at]): m2_fear 4


