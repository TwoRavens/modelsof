/*
Replication File for:
Lily Tsai and Yiqng Xu. "Outspoken Insiders: Political Connections and Citizen Participation in Authoritarian China"
*/

clear all
set more off


/* Table 1. Complaint-Making: Urban */
use insider_urban, clear
global covar = "edu ccp govoff age age2 male hukou"
foreach var of varlist compgov comp_off   {
   qui logit `var' govconn i.distrid, cl(distrid)
   margins, dydx(govconn)
   sum `var' if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)

   qui logit `var' govconn $covar i.distrid, cl(distrid)
   margins, dydx(govconn $covar)
   sum `var' if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }
* comparison with education
global covar = "hschool college ccp govoff age age2 male hukou"
qui logit compgov govconn $covar i.distrid, cl(distrid)
margins, dydx(govconn $covar)

/* Table 2. Complaint-Making: Rural */
use insider_rural, clear
global covar = "eduyr ccp leader age age2 male"
foreach var of varlist compl compl_vill {
   qui logit `var' govconn i.v_id,cl(v_id)
   margins, dydx(govconn)
   sum `var' if e(sample)
   disp e(r2_p) " clusters " e(N_clust)

   qui logit `var' govconn $covar i.v_id,cl(v_id)
   margins, dydx(govconn $covar)
   sum `var' if e(sample)
   disp e(r2_p) " clusters " e(N_clust)
   }

* comparison with education
global covar = "pschool mschool hschool ccp leader age age2 male"
qui logit compl govconn $covar i.v_id, cl(v_id)
margins, dydx(govconn $covar)


/* Table 3. Satisfaction */

* urban
cap erase out.txt
cap erase out.xml
use insider_urban, clear
global covar = "edu ccp govoff age age2 male hukou"
use insider_urban, clear
foreach var of varlist sat_general sat_living sat_avg {
 qui areg `var' govconn $covar, a(distrid) cl(distrid)
 outreg2 using out.xml, excel dec(3) keep(govconn) nocons 
 sum `var' if e(sample)
 unique distrid if e(sample)
}

* rural
cap erase out.txt
cap erase out.xml
use insider_rural, clear
global covar = "eduyr ccp leader age age2 male"
foreach var of varlist sat_vill sat_town sat_pub {
   qui areg `var' govconn $covar, a(v_id) cl(v_id)
   outreg2 using out.xml, excel dec(3) keep(govconn) nocons 
   sum `var' if e(sample)
   unique v_id if e(sample)
   } 


/* for matching in Table 4 */

* urban
use insider_urban, clear
replace age = age*10
g agebin=0
replace agebin=1 if inrange(age,31,40)
replace agebin=2 if inrange(age,41,50)
replace agebin=3 if inrange(age,51,100)
tab agebin, g(ageb)
keep compgov govconn edu college hschool ccp govoff age age2 ageb* male hukou distrid
keep if mi(compgov, govconn, edu, college, hschool, ccp, govoff, age, male, hukou)==0
sum
saveold match_urban, replace version(11)

* rural 
use insider_rural, clear
replace age = age *10 
g agebin=0
replace agebin=1 if inrange(age,41,50)
replace agebin=2 if inrange(age,51,60)
replace agebin=3 if inrange(age,61,100)
tab agebin, g(ageb)
keep compl govconn eduyr pschool mschool hschool ccp leader age age2 ageb* male v_id
order compl govconn eduyr pschool mschool hschool ccp leader age age2 ageb* male v_id
keep if mi(compl, govconn, eduyr, pschool, mschool, hschool, ccp, leader, age, male)==0
sum
saveold  match_rural, replace version(11)


/* Figures 1  */

* Content of Complaints
use insider_urban, clear
tab issue
/*
1 Public Safety
2 Transportation
3 Utilities
4 Food and Drug Safety
5 Air Pollution
6 Community Environment
7 Public Health
8 Licenses, Permits, and Certificates
9 Right infringement
10 Misc.
*/


* Civic vs. private interests
use insider_urban, clear
tab concernme govconn
tab concernme
tab concernme if govconn == 1
tab concernme if govconn == 0
 

*************************************************
* Appendix
*************************************************


/* Appendix Table 1: Discriptive Statistics */

* urban
use insider_urban, clear
tab govconn
tabstat sat_avg compgov comp_off age edu ccp hfinc male hukou whitec govoff, by(govconn) s(mean) 

* rural
use insider_rural, clear
tab govconn
tabstat sat_pub compl compl_vill age eduyr ccp hasset male leader nonagr, by(govconn) s(mean) 

/* Appendix Table 2: Linear Regression */

* urban
cap erase out.txt
cap erase out.xml
use insider_urban, clear
global covar = "edu ccp govoff age age2 male hukou"

foreach var of varlist compgov   {
   qui areg `var' govconn, a(distrid) cl(distrid)
   outreg2 using "out.xml", excel dec(3) keep(govconn) nocons 
   unique distrid if e(sample)
   sum `var' if e(sample)

   qui areg `var' govconn $covar, a(distrid) cl(distrid)
   outreg2 using "out.xml", excel dec(3) keep(govconn $covar) nocons 
   unique distrid if e(sample)
   sum `var' if e(sample)
}

* rural
cap erase out.txt
cap erase out.xml
use insider_rural, clear
global covar = "eduyr ccp leader age age2 male"
foreach var of varlist compl   {
   qui areg `var' govconn, a(v_id) cl(v_id)
   outreg2 using out.xml, excel dec(3) keep(govconn) nocons 
   unique v_id if e(sample)
   sum `var' if e(sample)
   
   qui areg `var' govconn $covar, a(v_id) cl(v_id)
   outreg2 using out.xml, excel dec(3) keep(govconn $covar) nocons 
   unique v_id if e(sample)
   sum `var' if e(sample)
   }

/* Appendix Table 3: Additional Controls -- Urban */

*Trust, occupation, income, hukou
use insider_urban, clear
global covar = "edu ccp govoff age age2 male hukou"
foreach xvar of varlist trust whitec hfinc {
   qui logit compgov govconn `xvar' $covar i.distrid, cl(distrid)
   margins, dydx(govconn `xvar')
   sum compgov if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }

qui logit compgov govconn trust whitec hfinc $covar i.distrid, cl(distrid)
margins, dydx(govconn trust whitec hfinc)
sum compgov if e(sample)
disp "R-squared " e(r2_p) " clusters " e(N_clust)


/* Appendix Table 4: Additional Controls -- Rural */

* Trust, occupation, family asset
use insider_rural, clear
global covar = "eduyr ccp leader age age2 male"
foreach xvar of varlist trust nonagr hasset {
   qui logit compl govconn `xvar' $covar i.v_id, cl(v_id)
   margins, dydx(govconn `xvar')
   sum compl if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }
qui logit compl govconn trust nonagr hasset $covar i.v_id, cl(v_id)
margins, dydx(govconn trust nonagr hasset)
sum compl if e(sample)
disp "R-squared " e(r2_p) " clusters " e(N_clust)

/* Appendix Table 5: Political Knowledge  */

* ubran
use insider_urban, clear
global covar = "edu ccp govoff age age2 male hukou"
foreach var of varlist govfile mayor email {
   qui logit `var' govconn $covar i.distrid, cl(distrid)
   margins, dydx(govconn)
   sum `var' if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }

* rural
use insider_rural, clear
global covar = "eduyr ccp leader age age2 male"
foreach var of varlist xiangzhang governor newspaper {
   qui logit `var' govconn $covar i.v_id, cl(v_id)
   margins, dydx(govconn)
   sum `var' if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }

 /* Appendix Table 6: Access -- Urban */
use insider_urban, clear
global covar = "edu ccp govoff age age2 male hukou"
foreach var of varlist backdoor dealgov pullstring {
   qui logit `var' govconn $covar i.distrid, cl(distrid)
   margins, dydx(govconn)
   sum `var' if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }

/* Appendix Table 7: Access -- Rural */
use insider_rural, clear
global covar = "eduyr ccp leader age age2 male"
foreach var of varlist welcome* {
   qui logit `var' govconn $covar i.v_id, cl(v_id)
   margins, dydx(govconn)
   sum `var' if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }

/* Appendix Table 8: Perception of Government */

* urban
use insider_urban, clear
global covar = "edu ccp govoff age age2 male hukou"
foreach var of varlist privil rfee rfine corrupt {
   qui logit `var' govconn $covar i.distrid, cl(distrid)
   margins, dydx(govconn)
   sum `var' if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }


* rural
use insider_rural, clear
global covar = "eduyr ccp leader age age2 male"
foreach var of varlist belief* {
   qui logit `var' govconn $covar i.v_id, cl(v_id)
   margins, dydx(govconn)
   sum `var' if e(sample)
   disp "R-squared " e(r2_p) " clusters " e(N_clust)
   }



