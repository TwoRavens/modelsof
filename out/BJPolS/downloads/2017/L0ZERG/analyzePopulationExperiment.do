log using popexp
clear
use "populationExperiment.dta"

* randomization check
reg t i.gender , robust
reg t i.edu  , robust
reg t i.civil  , robust
reg t i.age , robust



set seed 358395
sem (d1 <-  t  wl p1)(p1 <-  t  wl)   
estat ic
estat teffects 

*** indirect and direct - winning/losing
cap program drop indireff
program indireff, rclass
sem (d1 <-  t  wl p1)(p1 <-  t  wl)  
  estat teffects
  mat bi = r(indirect)
  mat bt = r(total)d2
  return scalar indir  = el(bi,1,3)
  return scalar total  = el(bt,1,3)
end 

set seed 358395
bootstrap r(indir) r(total), reps(1000): indireff 
estat bootstrap, percentile bc  

*** indirect and direct - treatment
cap program drop indireff
program indireff, rclass
sem (d1 <- wl  t  p1)(p1 <- wl  t )  
  estat teffects
  mat bi = r(indirect)
  mat bt = r(total)
  return scalar indirect  = el(bi,1,3)
  return scalar total  = el(bt,1,3)
end

set seed 358395
bootstrap r(indirect) r(total), reps(1000): indireff
estat bootstrap, percentile bc  


********
******** ROBUSTNESS CHECKS
********

set seed 358395
sem (d2 <-  t  wl p2)(p2 <-  t  wl)   
estat ic
estat teffects 

*** indirect and direct - winning/losing
cap program drop indireff
program indireff, rclass
sem (d2 <-  t  wl p2)(p2 <-  t  wl)  
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
sem (d2 <- wl  t  p2)(p2 <- wl  t )  
  estat teffects
  mat bi = r(indirect)
  mat bt = r(total)
  return scalar indirect  = el(bi,1,3)
  return scalar total  = el(bt,1,3)
end

set seed 358395
bootstrap r(indirect) r(total), reps(1000): indireff
estat bootstrap, percentile bc  

log close
