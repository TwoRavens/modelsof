clear
set mem 150m
capture log close
log using ~/research/labor/logs/bootstrap.log, replace

/*================================================
 Program: bootstrap.do
 Author:  Avi Ebenstein
 Created: October 2007
 Purpose: Taiwan and US comparison BOLS-BIV bootstrapped standard error
=================================================*/

*********;
* Taiwan ;
*********;

use ~/abortion/datafiles/moms2000_taiwan_k2
keep if mage>=21 & mage<=35 & married & hage>=21 & hage<=50
gen minority=mrace~=0
gen treated=g2
drop if b1

*Step 1
quietly regress mworking k3 mage agefirst minority
gen bols=_b[k3]
quietly ivreg mworking (k3=treated) mage agefirst minority
gen biv=_b[k3]
mkmat bols in 1, matrix(bols)
mkmat biv in 1, matrix(biv)
matrix observe = bols-biv

*Step 2
capture program drop myboot
program define myboot, rclass
 preserve
  bsample
capture drop bols biv
quietly regress mworking k3 mage agefirst
gen bols=_b[k3]
quietly ivreg mworking (k3=treated) mage agefirst
gen biv=_b[k3]
matrix drop bols biv
mkmat bols in 1, matrix(bols)
mkmat biv in 1, matrix(biv)
matrix observe = biv
return scalar mydif = observe[1,1]
 restore
end

*Step 3
simulate mydif=r(mydif), reps(100) seed(613): myboot

*Step 4
bstat, stat(observe) n(100)

estat bootstrap, all

*********;
* US     ;
*********;

use ~/abortion/datafiles/moms2000_us_k2
keep if mage>=21 & mage<=35 & married & hage>=21 & hage<=50
gen minority=mrace~=1

gen treated=famtype2==1|famtype2==4

*Step 1
quietly regress mworking k3 mage agefirst minority
gen bols=_b[k3]
quietly ivreg mworking (k3=treated) mage agefirst minority
gen biv=_b[k3]
mkmat bols in 1, matrix(bols)
mkmat biv in 1, matrix(biv)
matrix observe = biv

*Step 2
capture program drop myboot
program define myboot, rclass
 preserve
  bsample
capture drop bols biv
quietly regress mworking k3 mage agefirst minority
gen bols=_b[k3]
quietly ivreg mworking (k3=treated) mage agefirst minority
gen biv=_b[k3]
matrix drop bols biv
mkmat bols in 1, matrix(bols)
mkmat biv in 1, matrix(biv)
matrix observe = biv
return scalar mydif = observe[1,1]
 restore
end

*Step 3
simulate mydif=r(mydif), reps(100) seed(613): myboot

*Step 4
bstat, stat(observe) n(100)

estat bootstrap, all

