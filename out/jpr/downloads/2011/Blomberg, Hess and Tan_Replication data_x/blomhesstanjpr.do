# delimit ; 

clear ;

/*set mem 31000m ; */
set mem 400m ;
set matsize 500 ;

use "U:\\BBlomberg\DATA\create\wvs_final1.dta" ;
replace kids = 0 if kids==. ;
gen sample =1 if x047cs>10 ;

qui tab countryname, gen(cc) ;
gen lny_r = ln(income_r) ;
gen lny_l = ln(income_l) ;
gen age = x003*100 ;
gen agesq = age*age*100 ;
gen religion = a006 ;
gen happy = a008 ;
gen utility = a170 ;
gen politics = e023 ;
gen sep11 = e212 ;
gen polviolence = e197 ;
gen work = a005 ;
gen polimportance = a004 ;
replace unem = 100*unem ;
gen gg = 0 if income_l==. ;
replace gg=1 if gg==. ;
gen noT = 1-T ;
gen peace_trust = noT*trust ;
gen T_vic = nr_kill+nr_wound;

keep trust nr* T T_vic W work polim edu age agesq bir kids mar fem unem reg_* yr* year x047cs lny_l lny_r x047 x048 cc* scodeno dy lny0 ivstlag lnop rgdpch  countryname s007 gg;

drop yr1 yr2 yr3 yr4 yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12 yr13 yr14 yr15 yr16 yr17 yr18 yr19 yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 yr29 yr30 yr31 yr32 yr33 yr34 yr35 yr36 yr37 yr38 yr39 yr40 yr43 yr44 ;

/* table II */

reg trust T W work polim edu age agesq bir kids mar fem unem reg_* yr* , cluster(x048) ;
mfx compute ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab1", replace se nolabel comma mfx nonotes noni    bracket  bdec(3) ctitle("Linear")   ;
probit trust T W work polim edu age agesq bir kids mar fem unem reg_* yr*  , cluster(x048) ;
mfx compute ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab1", append se nolabel comma mfx nonotes noni    bracket  bdec(3) ctitle("Probit")   ;
logit trust T W work polim edu age agesq bir kids mar fem unem reg_* yr* , cluster(x048)  ;
mfx compute ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab1", append se nolabel comma mfx nonotes noni    bracket  bdec(3) ctitle("Logit")   ;
probit trust T W work polim edu age agesq bir kids mar fem unem reg_* yr* cc* , cluster(x048) ;
mfx compute ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab1", append se nolabel comma mfx nonotes noni    bracket  bdec(3) ctitle("Prob F.E.")   ;



/* table III(i) */

xtreg lny_l trust T yr* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2", replace se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Basic")   ;
reg lny_l trust T W edu age agesq bir kids mar fem unem reg_* yr* if x047cs>10, cluster(x048);
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("No C.F.E.")   ;
xtreg lny_l trust T W edu age agesq bir kids mar fem unem reg_* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("No T.F.E.")   ;
xtreg lny_l trust T W edu age agesq bir kids mar fem unem yr* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("F.E.")   ;
xtreg lny_r trust T W edu age agesq bir kids mar fem unem yr* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Income PPP")   ;
ologit x047 trust T W edu age agesq bir kids mar fem unem yr* reg_* if x047cs>10,;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Income Decile")   ;




/* table III(ii) */

xtreg lny_l trust nr_cf yr* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2aa", replace se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Basic")   ;
reg lny_l trust nr_cf W edu age agesq bir kids mar fem unem reg_* yr* if x047cs>10, cluster(x048) ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2aa", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("No C.F.E.")   ;
xtreg lny_l trust nr_cf W edu age agesq bir kids mar fem unem reg_* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2aa", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("No T.F.E.")   ;
xtreg lny_l trust nr_cf W edu age agesq bir kids mar fem unem yr* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2aa", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("F.E.")   ;
xtreg lny_l trust T_vic W edu age agesq bir kids mar fem unem yr* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2aa", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("F.E.")   ;

xtreg lny_r trust nr_cf W edu age agesq bir kids mar fem unem yr* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2aa", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Income PPP")   ;
ologit x047 trust nr_cf W edu age agesq bir kids mar fem unem yr* reg_* if x047cs>10, ro ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab2aa", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Income Decile")   ;






/*table IV */

xtreg lny_l trust T W edu age agesq bir kids mar fem unem yr* if x047cs>10, fe ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab3", replace se nolabel comma nonotes noni    bracket  bdec(3) ctitle("OLS")   ;
qreg lny_l trust T W edu age agesq bir kids mar fem unem yr* reg_*  if x047cs>10, quantile(.1) ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab3", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Q=.1")   ;
qreg lny_l trust T W edu age agesq bir kids mar fem unem yr* reg_*  if x047cs>10, quantile(.25) ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab3", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Q=.25")   ;
qreg lny_l trust T W edu age agesq bir kids mar fem unem yr* reg_*  if x047cs>10, quantile(.5) ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab3", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Q=.5")   ;
qreg lny_l trust T W edu age agesq bir kids mar fem unem yr* reg_*  if x047cs>10, quantile(.75) ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab3", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Q=.75")   ;
qreg lny_l trust T W edu age agesq bir kids mar fem unem yr* reg_*  if x047cs>10, quantile(.9) ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab3", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Q=.9")   ;

/* Table V */

clear ;
clear mata ;
clear matrix ;
use "U:\\BBlomberg\DATA\create\wvs_final1.dta" ;
replace kids = 0 if kids==. ;
gen sample =1 if x047cs>10 ;
qui tab countryname, gen(cc) ;
gen lny_r = ln(income_r) ;
gen lny_l = ln(income_l) ;
gen age = x003 ;
gen agesq = age*age ;
gen religion = a006 ;
gen happy = a008 ;
gen utility = a170 ;
gen politics = e023 ;
gen sep11 = e212 ;
gen polviolence = e197 ;
gen work = a005 ;
gen polimportance = a004 ;



keep trust T W work polim edu age agesq bir kids mar fem unem reg_* yr* year x047cs lny_l lny_r x047 cc* scodeno dy lny0 ivstlag lnop rgdpch  ;

drop yr1 yr2 yr3 yr4 yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12 yr13 yr14 yr15 yr16 yr17 yr18 yr19 yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 yr29 yr30 yr31 yr32 yr33 yr34 yr35 yr36 yr37 yr38 yr39 yr40 yr43 yr44 ;


qui ivregress 2sls lny_l (trust=work polim ) T edu age agesq yr* reg_* if x047cs>10, ro ;
qui estat over ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab4", replace se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Basic")  addstat(Sargan,  `r(score)',p, `r(p_score)' ) adec(2,3)   ;
qui ivregress 2sls lny_l (trust=work polim ) T W edu age agesq bir kids mar fem unem reg_* yr*  if x047cs>10, ro ;
qui estat over ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab4", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("No C.F.E.")  addstat(Sargan,  `r(score)',p, `r(p_score)' ) adec(2,3)  ;
qui ivregress 2sls lny_l (trust=work polim ) T W edu age agesq bir kids mar fem unem reg_* if x047cs>10, ro ;
qui estat over ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab4", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("No T.F.E.")  addstat(Sargan,  `r(score)',p, `r(p_score)' ) adec(2,3)  ;
qui ivregress 2sls lny_l (trust=work polim ) T W edu age agesq bir kids mar fem unem reg_* yr* if x047cs>10, ro ;
qui estat over ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab4", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("F.E.")  addstat(Sargan,  `r(score)',p, `r(p_score)' ) adec(2,3)  ;
qui ivregress 2sls lny_r (trust=work polim ) T W edu age agesq bir kids mar fem unem yr* reg_* if x047cs>10, ro ;
qui estat over ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab4", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Income PPP")  addstat(Sargan,  `r(score)',p, `r(p_score)' ) adec(2,3)  ;
qui ivregress 2sls x047 (trust=work polim ) T W edu age agesq bir kids mar fem unem yr* reg_* if x047cs>10, ro ;
qui estat over ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab4", append se nolabel comma nonotes noni    bracket  bdec(3) ctitle("Income Decile")  addstat(Sargan,  `r(score)',p, `r(p_score)' ) adec(2,3)  ;

/* table VI */

drop if lny_l==. ;
gen vv = 1 if x047cs>10 ;
gen ii = vv*lny_l*trust*work*polim*T*W*edu*age*agesq*bir*kids*mar*fem*unem*reg_eap*reg_eca*reg_mena*reg_sa*reg_we*reg_na*reg_ssa*reg_lac*year ;
drop if ii==. ;


program IVQRestimates ;
reg trust work polim T W edu age agesq bir kids mar fem unem reg_* yr* , robust ;
predict double IVt , xb ;
sqreg lny_l IVt T W edu age agesq bir kids mar fem unem reg_* yr* , quantiles(10 25 50 75 90) ;
end ;
bootstrap "IVQRestimates" _b , reps(50) dots ;
outreg2 using "U:\\BBlomberg\DATA\create\trusttab5", replace se nolabel comma nonotes noni    bracket  bdec(3)  ;
