* REPLICATION MATERIALS
*
*    "Does the presence of foreign troops affect stability in the host country?" 
*    Conditional acceptance at Foreign Policy Analysis 
*
*  

*
* Summary statistics (Table 1) for effective sample 
su unrest violent_mov nonviol_mov Lln_troop threshold Lprop5yr Ltrade Lcolony Ltroops_new n_ruleoflaw Lst1_gdp Lst2_gdp  dem1 dem2 Lcap1 Lcap2 Ltarget lnpop post_cw pk_troops D_ally Lagree if sample == 1
*
*


* Instructions for creating Figure 1:
* gen hosted = 1 if total_hosted != 0 & total_hosted != .
* sort st2 year
* by st2 year: egen host = max(hosted)
* sort st2 year
* by st2 year: keep if _n ==1
* collapse (sum) total_hosted host, by(year)
* gen year1 = year - 0.2
* gen year2 = year + 0.2
* replace total = total / 1000
* twoway (bar total_hosted year1 if year < 2008, barw(.3) yaxis(1) ) (bar host year2 if year < 2008, barw(.3) yaxis(2) ) 




* RESULTS TO REPORT:
* 


*
*
* NOTE on estimation technique: 
* Baseline models use xtivreg2, available at:
* findit xtivreg2
* xtivreg2 from http://fmwww.bc.edu/RePEc/bocode/x 
*
* 

* 
* Model 1
* [Baseline model]
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first fe i(dyadid)
*
*     NOTE: Other baseline models(not reported in main draft) 
*         Other instruments:
          xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  trade Lalliance), cluster(dyadid) first fe i(dyadid)
          xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  trade L.D_ally), cluster(dyadid) first fe i(dyadid)
*		  Counter instead of leagged variable:
          xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops counter counter2 counter3 (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first fe i(dyadid)
		  * Alternative estimator
          treatreg unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest, cluster(dyadid) treat(Ltroop = Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest Lagree L.D_ally)
*
* 
* Model 1: Substantive effects:
*    Note: xtivreg2 does not support margins. For ease of interpretation, run 
*          separate equations. Separate equations provide exactly the same 
*          coefficients. Allows interpretation of the change in predictions. 
*          (SEs are not corrected. These are not reported or interpreted.) 
   xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm1) fe i(dyadid)
est store m1
   *
   xtreg Lln_troop Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest Lagree L.D_ally, cluster(dyadid)  fe i(dyadid)
   capture drop xb
   predict xb, xb
   xtreg unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest xb, cluster(dyadid) fe i(dyadid)
   su xb, d
   margins, at(xb = (-.03 0 .05))
*
* 
*
* Also reported in Table 2 
* 
* Model 2 US-omitted
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  Lagree L.D_ally) if st1 != 2 , cluster(dyadid) first savefirst savefp(mm2) fe i(dyadid)
est store m2
* 
* Model 3 Threshold
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (threshold =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm3) fe i(dyadid)
est store m3
*
* Table 2 construction: 
* estout mm1Lln_troops m1 mm2Lln_troops m2 mm3threshold m3 using baseline1.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N))  style(tex) replace 



* REPORT (TABLE 3) 
* Model 4 Proportion 5yr
sort dyadid year
*by dyadid: gen prop5yr = (troop_bilateral + troop_bilateral[_n-1] + troop_bilateral[_n-2] + troop_bilateral[_n-3] + troop_bilateral[_n-4])/5 
*replace prop5yr = log(prop5yr+1)
*sort dyadid year
*by dyadid: gen Lprop5yr = L.prop5yr
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops  Lunrest (Lprop5yr =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm4) fe i(dyadid)
est store m4
* Model 5 Trade partner troops
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Ltrade =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm5) fe i(dyadid)
est store m5
* Model 6 Colonial ancestor troops
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lcolony =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm6) fe i(dyadid)
est store m6
*
* Table 3 construction:
* estout mm4Lprop5yr m4 mm5Ltrade m5 mm6Lcolony m6 using baseline2.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N))  style(tex) replace 



* REPORT (TABLE 4) 
* Model 7 New deployments 
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Ltroops_new =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm7) fe i(dyadid)
est store m7
* Model 8 Past failures
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops past_failures Lunrest (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm8) fe i(dyadid)
est store m8
* Model 9 Non-dem
gen dems = 1 if dem1 == 1 & dem2 == 1 
replace dems = 0 if dems == .
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  Lagree L.D_ally) if dems == 0, cluster(dyadid) first savefirst savefp(mm9) fe i(dyadid)
est store m9
* Model 10 Dem
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  Lagree L.D_ally) if dems == 1, cluster(dyadid) first savefirst savefp(mm10) fe i(dyadid)
est store m10
*
* Table 4 construction:
* estout mm7Ltroops_new m7 mm8Lln_troops m8 mm9Lln_troops m9 mm10Lln_troops m10 using robust1.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N))  style(tex) replace 



* REPORT (TABLE 5) 
* Forms of unrest
* Model 11 Violence
xtivreg2 violent_mov Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lviolent (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm11) fe i(dyadid)
est store m11
   xtreg Lln_troop Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lviolent Lagree L.D_ally, cluster(dyadid)  fe i(dyadid)
   capture drop xb
   predict xb, xb
   xtreg violent_mov Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lviolent xb, cluster(dyadid) fe i(dyadid)
   su xb, d
   margins, at(xb = (-.03 0 .05)) 
* M0del 12 Nonviolence
xtivreg2 nonviol_mov Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lnonvio (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm12) fe i(dyadid)
est store m12
   xtreg Lln_troop Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lnonvio Lagree L.D_ally, cluster(dyadid)  fe i(dyadid)
   capture drop xb
   predict xb, xb
   xtreg nonviol_mov Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lnonvio xb, cluster(dyadid) fe i(dyadid)
   su xb, d
   margins, at(xb = (-.03 0 .05)) 
*
* Table 5 construction:
* estout mm11Lln_troops m11 mm12Lln_troops m12  using robust2.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N))  style(tex) replace 



* REPORT (TABLE 6)
* Model 13 
xtivreg2 n_ruleoflaw Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(mm13) fe i(dyadid)
est store m13
*
* Table 5 construction (a):
* estout mm13Lln_troops m13 using ruleoflaw1.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N))  style(tex) replace 

* Model 14
xtreg unrest n_ruleoflaw Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest, cluster(dyadid) fe i(dyadid)
est store m14
*
* Table 5 construction (b):
* estout m14 using ruleoflaw2.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N))  style(tex) replace 




* UNREPORTED ROBUSTNESS CHECKS:
*
*
*
* Additional robustness checks:

* Do troops increase repression? 
xtivreg2 latentmean Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(memo1)  fe i(dyadid)
est store memo1
estout memo1Lln_troops memo1 using memo1.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N)) style(tex)  replace 

xtreg latentmean Lln_troops Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest, cluster(dyadid) fe i(dyadid)
est store memo2
* estout  memo2 using memo2.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N)) style(tex)  replace 
*
 

* Peace-time deployments
* Troops deployed in years without active unrest
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (troopspeace2 =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(memo3) fe i(dyadid)
est store memo3
* Troops deployed in years without active MIDs
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest (troopspeace=  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(memo4) fe i(dyadid)
est store memo4
* estout memo3troopspeace2 memo3 memo4troopspeace memo4 using memo3.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N)) style(tex)  replace 
*


* Alternative approach from Wooldridge: 
* Probit predicting troop deployments
probit troop Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest Lagree L.D_ally, cluster(dyadid)
* Calculate inverse Mills
predict p1, xb
gen phi=(1/sqrt(2*_pi))*exp(-(p1^2/2))
gen capphi=normal(p1)
gen invmills=phi/capphi
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop post_cw pk_troops Lunrest invmills (Lln_troop =  Lagree L.D_ally), cluster(dyadid) first savefirst savefp(memo5)  fe i(dyadid)
est store memo5 
* estout memo5Lln_troops memo5 using memo4.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N)) style(tex)  replace 
* 


* Cold War Interaction
gen Lln_troop_cw = post_cw * Lln_troop
gen agree_cw = Lagree * post_cw
gen ally_cw = D_ally * post_cw
xtivreg2 unrest Lst1_gdp Lst2_gdp Ltarget dem1 dem2 Lcap1 Lcap2 lnpop pk_troops post_cw Lunrest (Lln_troops Lln_troop_cw =  Lagree LD_ally agree_cw ally_cw) if st1 != 2, cluster(dyadid) first savefirst savefp(memo6) fe i(dyadid)
est store memo6
* estout memo6Lln_troops memo6 using memo5.txt, starlevels(* .05 ** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N ll bic, fmt( %9.0f %9.2f) labels(N)) style(tex)  replace 
* 

