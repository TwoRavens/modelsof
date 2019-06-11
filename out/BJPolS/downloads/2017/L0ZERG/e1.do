log using e1

clear
use "symbols adults.dta"

set more off
drop if rep == 1

set seed 358395
sem (d <-  t  wl p)(p <-  t  wl)   
estat ic
estat teffects 

*** indirect and direct - winning/losing
cap program drop indireff
program indireff, rclass
sem (d <-  t  wl p)(p <-  t  wl)  
  estat teffects
  mat bi = r(indirect)
  mat bt = r(total)
  return scalar indir  = el(bi,1,3)
  return scalar total  = el(bt,1,3)
end 

set seed 358395
bootstrap r(indir) r(total), reps(1000): indireff 
estat bootstrap, percentile bc  

*** indirect and direct - treatment
cap program drop indireff
program indireff, rclass
sem (d <- wl  t  p)(p <- wl  t )  
  estat teffects
  mat bi = r(indirect)
  mat bt = r(total)
  return scalar indirect  = el(bi,1,3)
  return scalar total  = el(bt,1,3)
end

set seed 358395
bootstrap r(indirect) r(total), reps(1000): indireff
estat bootstrap, percentile bc  

*** randomization check
reg  t  gender interest ideology , robust
log close
