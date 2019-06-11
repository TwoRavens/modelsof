use data, clear



global control "pchaloff pchalneu defensiveallydum COW_contigdum rival pastconflict COW_sscore COW_parity jointdem peace peace2 peace3"


***************
*** Table 1 ***
***************

*** Model 1-(1): at least one contiguous defensive allies ***
probit COW_cwinit cowcontigdum relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table1, dec(3) word 2aster replace
margins, at(cowcontigdum=0 pchaloff=0 pchalneu=0 COW_contigdum=0 jointdem=0 (mean) _all)
margins, at(cowcontigdum=1 pchaloff=0 pchalneu=0 COW_contigdum=0 jointdem=0 (mean) _all)

*** Model 1-(2): number of contiguous defensive allies ***
probit COW_cwinit cowcontig relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table1, dec(3) word 2aster

*** Model 1-(3): average ln(intercapital distance) of defensive allies ***
probit COW_cwinit cowlndist relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table1, dec(3) word 2aster
sum cowlndist if e(sample)
dis exp(5.66249) /* mean = 287.86453 miles */
dis exp(5.66249 + 2.293836) /* mean+1sd = 5.63207+2.244959 ~~~ exp(5.63207+2.244959) = 2853.5697 miles */
margins, at(cowlndist=5.66249 pchaloff=0 pchalneu=0 COW_contigdum=0 jointdem=0 (mean) _all)
margins, at(cowlndist=7.956326 pchaloff=0 pchalneu=0 COW_contigdum=0 jointdem=0 (mean) _all)



***************
*** Table 2 ***
***************

*** Model 2-(1): defensive allies' absolute power ***
probit COW_cwinit cincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table2, dec(3) word 2aster replace

*** Model 2-(2): adjusted defensive allies' absolute power ***
probit COW_cwinit cincally_cowdist_lsg EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table2, dec(3) word 2aster

*** Model 2-(3): contiguous defensive allies' absolute power ***
probit COW_cwinit contigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table2, dec(3) word 2aster

*** Model 2-(4): noncontiguous defensive allies' absolute power ***
probit COW_cwinit noncontigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table2, dec(3) word 2aster

*** Model 2-(5): contiguous + noncontiguous defensive allies' absolute power ***
probit COW_cwinit contigcincally noncontigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table2, dec(3) word 2aster
* Substantive Effects 
sum contigcincally if e(sample)
prvalue, x(contigcincally=.0283124 pchaloff=0 pchalneu=0 COW_contigdum=0 jointdem=0) rest(mean)
prvalue, x(contigcincally=.0832445 pchaloff=0 pchalneu=0 COW_contigdum=0 jointdem=0) rest(mean)



***************
*** Table 3 ***
***************

probit COW_cwinit cowcontigdum lnyear contiglnyear relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table3, dec(3) word 2aster replace

probit COW_cwinit cowcontigdum yearcount contigyear relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table3, dec(3) word 2aster

probit COW_cwinit cowcontigdum ww3 contigww3 relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using table3, dec(3) word 2aster

probit COW_cwinit cowcontigdum ww3 contigww3 relcincally fpsimsrswvas $control if majally>0, robust cluster(dyadid)
outreg2 using table3, dec(3) word 2aster



****************
*** Figure 1 ***
****************

*** Simulation 1 ***

use data, clear
probit COW_cwinit cowcontigdum lnyear contiglnyear relcincally fpsimsrswvas $control, robust cluster(dyadid)
	sum relcincally if e(sample) 
	scalar relcincally=r(mean) 
	sum fpsimsrswvas if e(sample) 
	scalar fpsimsrswvas=r(mean) 
	sum pchaloff if e(sample), detail 	
	scalar pchaloff=r(p50) 
	sum pchalneu if e(sample), detail 	
	scalar pchalneu=r(p50) 
	sum defensiveallydum if e(sample), detail 	
	scalar defensiveallydum=r(mean) 
	sum COW_contigdum if e(sample), detail 	
	scalar COW_contigdum=r(p50) 
	sum rival if e(sample), detail 	
	scalar rival=r(p50) 
	sum pastconflict if e(sample), detail 	
	scalar pastconflict=r(p50) 
	sum COW_parity if e(sample) 
	scalar COW_parity=r(mean) 
	sum COW_sscore if e(sample) 
	scalar COW_sscore=r(mean) 	
	sum jointdem if e(sample), detail 	
	scalar jointdem=r(p50) 
	sum peace if e(sample) 
	scalar peace=r(mean) 
	sum peace2 if e(sample) 
	scalar peace2=r(mean) 
	sum peace3 if e(sample) 
	scalar peace3=r(mean) 

use data, clear
probit COW_cwinit cowcontigdum yearcount contigyear relcincally fpsimsrswvas $control, robust cluster(dyadid)
drawnorm b1-b18, n(10000) means(e(b)) cov(e(V)) clear 
postutil clear 
postfile mypost hatprob lowprobhat highprobhat using sim2, replace 

forvalues yearcount = 1(1)185 { 
{
   gen xb0 = b1*(0) + b2*(`yearcount') + b3*(0*`yearcount') + b4*relcincally + b5*fpsimsrswvas + b6*pchaloff + b7*pchalneu + b8*defensiveallydum + b9*COW_contigdum + b10*rival + b11*pastconflict + b12*COW_sscore + b13*COW_parity + b14*jointdem + b15*peace + b16*peace2 + b17*peace3 + b18*1
   gen xb1 = b1*(1) + b2*(`yearcount') + b3*(1*`yearcount') + b4*relcincally + b5*fpsimsrswvas + b6*pchaloff + b7*pchalneu + b8*defensiveallydum + b9*COW_contigdum + b10*rival + b11*pastconflict + b12*COW_sscore + b13*COW_parity + b14*jointdem + b15*peace + b16*peace2 + b17*peace3 + b18*1
   
   gen pr0 = normal(xb0) 
   gen pr1 = normal(xb1) 
   gen diff = 100* ( ((pr1 - pr0)/pr0) - 1 )    
   egen diffhat = mean(diff)    
   _pctile diff, p(2.5,97.5) 
   scalar lowprobhat = r(r1) 
   scalar highprobhat = r(r2)  
   scalar hatprob = diffhat   
   post mypost (hatprob) (lowprobhat) (highprobhat) 
}
   drop xb* pr* diff*
   display "." _c 
}       
postclose mypost 

use sim2, clear
gen yearcount = _n

twoway (line hatprob lowprobhat highprobhat yearcount if yearcount<=185, ///
	clpattern(solid dash dash) ///
	yline(0, lpattern(solid) lwidth(vvthin)) ///
	yaxis(1) ylabel(#4)), ///
	ytitle("Effect of Alliance Contiguity: % Change in Pr(MID)", size(3.5)) ///
	xtitle(" ") yscale(titlegap(*+10)) ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	legend(off) scheme(s1mono) saving(sim2, replace)

	
*** Simulation 2 ***

use data, clear
probit COW_cwinit cowcontigdum ww3 contigww3 relcincally fpsimsrswvas $control, robust cluster(dyadid)
drawnorm b1-b18, n(10000) means(e(b)) cov(e(V)) clear 
postutil clear 
postfile mypost hatprob lowprobhat highprobhat using sim3, replace 

forvalues ww2 = 0(1)1 { 
{
   gen xb0 = b1*(0) + b2*(`ww2') + b3*(0*`ww2') + b4*relcincally + b5*fpsimsrswvas + b6*pchaloff + b7*pchalneu + b8*defensiveallydum + b9*COW_contigdum + b10*rival + b11*pastconflict + b12*COW_sscore + b13*COW_parity + b14*jointdem + b15*peace + b16*peace2 + b17*peace3 + b18*1
   gen xb1 = b1*(1) + b2*(`ww2') + b3*(1*`ww2') + b4*relcincally + b5*fpsimsrswvas + b6*pchaloff + b7*pchalneu + b8*defensiveallydum + b9*COW_contigdum + b10*rival + b11*pastconflict + b12*COW_sscore + b13*COW_parity + b14*jointdem + b15*peace + b16*peace2 + b17*peace3 + b18*1
   
   gen pr0 = normal(xb0) 
   gen pr1 = normal(xb1) 
   gen diff = 100* ( ((pr1 - pr0)/pr0) - 1 )    
   egen diffhat = mean(diff)    
   _pctile diff, p(2.5,97.5) 
   scalar lowprobhat = r(r1) 
   scalar highprobhat = r(r2)  
   scalar hatprob = diffhat   
   post mypost (hatprob) (lowprobhat) (highprobhat) 
}
   drop xb* pr* diff*
   display "." _c 
}       
postclose mypost 

use sim3, clear
gen ww2 = _n-1

eclplot hatprob lowprobhat highprobhat ww2, ///
	xscale(range(-1 1)) ciopts(blcolor(black))  estopts(msize(small)) ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	ytitle("Effect of Alliance Contiguity: % Change in Pr(MID)", size(2.8)) scheme(s1mono) ///
	xlabel(1 "Pre-WWII"  2 "Post-WWII" , labsize(2.8)) ///
	xtitle(" ") yscale(titlegap(*+10)) ///
	saving(sim3, replace)
	

graph combine sim2.gph sim3.gph, ycommon saving(simtotal, replace)	
graph export simtotal.tif, replace width(4000)













*************************************************
*** Robustness A: Politically Relevant Dyads ***
*************************************************
use data, clear

probit COW_cwinit cowcontigdum relcincally fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA1, dec(3) word 2aster replace

probit COW_cwinit cowcontig relcincally fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA1, dec(3) word 2aster

probit COW_cwinit cowlndist relcincally fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA1, dec(3) word 2aster


probit COW_cwinit cincally EU_cap1 fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA2, dec(3) word 2aster replace

probit COW_cwinit cincally_cowdist_lsg EU_cap1 fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA2, dec(3) word 2aster

probit COW_cwinit contigcincally EU_cap1 fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA2, dec(3) word 2aster

probit COW_cwinit noncontigcincally EU_cap1 fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA2, dec(3) word 2aster

probit COW_cwinit noncontigcincally contigcincally EU_cap1 fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA2, dec(3) word 2aster


probit COW_cwinit cowcontigdum lnyear contiglnyear relcincally fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA3, dec(3) word 2aster replace

probit COW_cwinit cowcontigdum yearcount contigyear relcincally fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA3, dec(3) word 2aster

probit COW_cwinit cowcontigdum ww3 contigww3 relcincally fpsimsrswvas $control if EU_pol_rel==1, robust cluster(dyadid)
outreg2 using tableA3, dec(3) word 2aster

probit COW_cwinit cowcontigdum ww3 contigww3 relcincally fpsimsrswvas $control if EU_pol_rel==1 & majally>0, robust cluster(dyadid)
outreg2 using tableA3, dec(3) word 2aster





*************************************
*** Robustness B: High-level MIDs ***
*************************************
probit COW_cwinit_high cowcontigdum relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB1, dec(3) word 2aster replace

probit COW_cwinit_high cowcontig relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB1, dec(3) word 2aster

probit COW_cwinit_high cowlndist relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB1, dec(3) word 2aster


probit COW_cwinit_high cincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB2, dec(3) word 2aster replace

probit COW_cwinit_high cincally_cowdist_lsg EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB2, dec(3) word 2aster

probit COW_cwinit_high contigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB2, dec(3) word 2aster

probit COW_cwinit_high noncontigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB2, dec(3) word 2aster

probit COW_cwinit_high noncontigcincally contigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB2, dec(3) word 2aster


probit COW_cwinit_high cowcontigdum lnyear contiglnyear relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB3, dec(3) word 2aster replace

probit COW_cwinit_high cowcontigdum yearcount contigyear relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB3, dec(3) word 2aster

probit COW_cwinit_high cowcontigdum ww3 contigww3 relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableB3, dec(3) word 2aster

probit COW_cwinit_high cowcontigdum ww3 contigww3 relcincally fpsimsrswvas $control if majally>0, robust cluster(dyadid)
outreg2 using tableB3, dec(3) word 2aster







**********************************************
*** Robustness C: Different Tipping Points ***
**********************************************
probit COW_cwinit cowcontigdum ww1 contigww1 relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableC1, dec(3) word 2aster replace

probit COW_cwinit cowcontigdum ww1 contigww1 relcincally fpsimsrswvas $control if year<1939, robust cluster(dyadid)
outreg2 using tableC1, dec(3) word 2aster 

probit COW_cwinit cowcontigdum ww2 contigww2 relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableC1, dec(3) word 2aster




***************************
*** Table D1: ln(power) ***
***************************

gen lnrelcincally = ln(relcincally)

probit COW_cwinit cowcontigdum lnrelcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableD1, dec(3) word 2aster replace

probit COW_cwinit cowcontig lnrelcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableD1, dec(3) word 2aster

probit COW_cwinit cowlndist lnrelcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableD1, dec(3) word 2aster


***************************
*** Table D2: ln(power) ***
***************************

gen lncincally = ln(cincally+1)
gen lncincally_cowdist_lsg = ln(cincally_cowdist_lsg+1)
gen lncontigcincally = ln(contigcincally+1)
gen lnnoncontigcincally = ln(noncontigcincally+1)

probit COW_cwinit lncincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableD2, dec(3) word 2aster replace

probit COW_cwinit lncincally_cowdist_lsg EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableD2, dec(3) word 2aster

probit COW_cwinit lncontigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableD2, dec(3) word 2aster

probit COW_cwinit lnnoncontigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableD2, dec(3) word 2aster

probit COW_cwinit lncontigcincally lnnoncontigcincally EU_cap1 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableD2, dec(3) word 2aster





************************************************************************
*** Robustness E: Controlling for Nuclear Age and Nuclear Allies     ***
************************************************************************

probit COW_cwinit cowcontigdum EU_cap2 fpsimsrswvas nukeallydum $control if year>=1945, robust cluster(dyadid)
outreg2 using tableE1, dec(3) word 2aster replace

probit COW_cwinit cowcontig EU_cap2 fpsimsrswvas nukeallydum $control if year>=1945, robust cluster(dyadid)
outreg2 using tableE1, dec(3) word 2aster

probit COW_cwinit cowlndist EU_cap2 fpsimsrswvas nukeallydum $control if year>=1945, robust cluster(dyadid)
outreg2 using tableE1, dec(3) word 2aster


*****************************************
*** Robustness F: Ballastic Missiles  ***
*****************************************

gen contigdum_ballastic = cowcontigdum * ballastically

probit COW_cwinit cowcontigdum ballastically contigdum_ballastic relcincally_cowdist_lsg fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableF1, dec(3) word 2aster replace


**********************************
*** Table G1: Selection Effect ***
**********************************

probit COW_cwinit cowlndist relcincally fpsimsrswvas $control if cowlndist>0, robust cluster(dyadid)
outreg2 using tableG1, dec(3) word 2aster replace

*** Compared with original models ***
probit COW_cwinit cowlndist relcincally fpsimsrswvas $control, robust cluster(dyadid)




**************************************
*** Table H1: US Troops Deployment ***
**************************************

tsset dyadid year
probit COW_cwinit cowcontigdum troops relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableH1, dec(3) word 2aster replace
probit COW_cwinit cowcontigdum L.troops relcincally fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableH1, dec(3) word 2aster
probit COW_cwinit cowcontigdum troops relcincally fpsimsrswvas $control if usally==1, robust cluster(dyadid)
outreg2 using tableH1, dec(3) word 2aster
probit COW_cwinit cowcontigdum L.troops relcincally fpsimsrswvas $control if usally==1, robust cluster(dyadid)
outreg2 using tableH1, dec(3) word 2aster





*************************************
*** Table I1:  Bivariate Analysis ***
*************************************

probit COW_cwinit cowcontigdum peace peace2 peace3, robust
outreg2 using tableI1, dec(3) word 2aster replace

probit COW_cwinit cowcontig peace peace2 peace3, robust
outreg2 using tableI1, dec(3) word 2aster

probit COW_cwinit cowlndist peace peace2 peace3, robust
outreg2 using tableI1, dec(3) word 2aster





***********************************
*** Table J1: Safe Neighborhood ***
***********************************

probit COW_cwinit cowcontigdum relcincally fpsimsrswvas fpsimsrswvas_neighbor $control, robust cluster(dyadid)
outreg2 using tableJ1, dec(3) word 2aster replace

probit COW_cwinit cowcontig relcincally fpsimsrswvas fpsimsrswvas_neighbor $control, robust cluster(dyadid)
outreg2 using tableJ1, dec(3) word 2aster

probit COW_cwinit cowcontig_neighbor relcincally fpsimsrswvas fpsimsrswvas_neighbor $control, robust cluster(dyadid)
outreg2 using tableJ1, dec(3) word 2aster




*******************************************************
*** Table K1: Distance Adjusted Relative Capability ***
*******************************************************

probit COW_cwinit cowcontigdum relcincally_cowdist_lsg2 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableK1, dec(3) word 2aster replace

probit COW_cwinit cowcontig relcincally_cowdist_lsg2 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableK1, dec(3) word 2aster

probit COW_cwinit cowlndist relcincally_cowdist_lsg2 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableK1, dec(3) word 2aster


*********************************************************
*** Table K2: Considering Challenger's Alliance Power ***
*********************************************************

probit COW_cwinit cowcontigdum relcincally_chal fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableK2, dec(3) word 2aster replace

probit COW_cwinit cowcontig relcincally_chal fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableK2, dec(3) word 2aster

probit COW_cwinit cowlndist relcincally_chal fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableK2, dec(3) word 2aster



******************************************************
*** Table L1: Target Power (Omitting power parity) ***
******************************************************

probit COW_cwinit cincally EU_cap1 EU_cap2 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableL1, dec(3) word 2aster replace

probit COW_cwinit cincally_cowdist_lsg EU_cap1 EU_cap2 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableL1, dec(3) word 2aster

probit COW_cwinit contigcincally EU_cap1 EU_cap2 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableL1, dec(3) word 2aster

probit COW_cwinit noncontigcincally EU_cap1 EU_cap2 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableL1, dec(3) word 2aster

probit COW_cwinit contigcincally noncontigcincally EU_cap1 EU_cap2 fpsimsrswvas $control, robust cluster(dyadid)
outreg2 using tableL1, dec(3) word 2aster



****************************************
*** Table M1: Peacetime coordination ***
****************************************

probit COW_cwinit cowcontigdum relcincally fpsimsrswvas milinst $control, robust cluster(dyadid)
outreg2 using tableM2, dec(3) word 2aster replace

probit COW_cwinit cowcontig relcincally fpsimsrswvas milinst $control, robust cluster(dyadid)
outreg2 using tableM2, dec(3) word 2aster

probit COW_cwinit cowlndist relcincally fpsimsrswvas milinst $control, robust cluster(dyadid)
outreg2 using tableM2, dec(3) word 2aster







***************************
*** Robust N: Model Fit ***
***************************

use data, clear
probit COW_cwinit cowcontig relcincally fpsimsrswvas $control, robust cluster(dyadid)
keep if e(sample)
count
save esample, replace

use esample, clear
set seed 12345
generate random = runiform()
sort random
gen cross = _n
gen crossid = .
replace crossid = 1 if cross <= 58212
replace crossid = 2 if (cross > 58212) & (cross <= (2*58212))
replace crossid = 3 if (cross > (2*58212)) & (cross <= (3*58212))
replace crossid = 4 if (cross > (3*58212)) & (cross <= (4*58212))
replace crossid = 5 if (cross > (4*58212)) & (cross <= (5*58212))
replace crossid = 6 if (cross > (5*58212)) & (cross <= (6*58212))
replace crossid = 7 if (cross > (6*58212)) & (cross <= (7*58212))
replace crossid = 8 if (cross > (7*58212)) & (cross <= (8*58212))
replace crossid = 9 if (cross > (8*58212)) & (cross <= (9*58212))
replace crossid = 10 if (cross > (9*58212)) & (cross <= (582126))
saveold crossvalid, replace version(11)

forvalues i = 1/10 {	
	use crossvalid, clear
	keep if crossid==`i'
	save out`i', replace
	use crossvalid, clear
	drop if crossid==`i'
	saveold in`i', replace version(11)
}

forvalues i = 1/10 {	
	use in`i', clear
	quietly probit COW_cwinit relcincally fpsimsrswvas $control, robust cluster(dyadid)
	use out`i', clear
	predict pr, pr
	predict xb, xb
	keep pr xb COW_cwinit
	saveold base_crossout`i', replace version(11)
}


forvalues i = 1/10 {	
	use in`i', clear
	quietly probit COW_cwinit cowcontig relcincally fpsimsrswvas $control, robust cluster(dyadid)
	use out`i', clear
	predict pr, pr
	predict xb, xb
	keep pr xb COW_cwinit
	saveold full_crossout`i', replace version(11)
}


*** R code using the cross-validatin outcomes for both fully specified and baseline models ***
/*
rm(list=ls())
set.seed(1777)
library(PRROC)
data <- read.dta("full_crossout1.dta", convert.underscore=FALSE)
attach(data)
fg <- pr[COW_cwinit == 1]
bg <- pr[COW_cwinit == 0]
roc.curve(scores.class0 = fg, scores.class1 = bg, curve = T)
pr.curve(scores.class0 = fg, scores.class1 = bg, curve = T)
*/

/* 

fully specified models ( auc / pr ) 
(1) 0.8860916 / 0.07803194
(2) 0.8982045 / 0.09364623
(3) 0.9163853 / 0.07213169
(4) 0.9122144 / 0.09178729
(5) 0.9022229 / 0.09420393
(6) 0.9205386 / 0.118784
(7) 0.867361  / 0.094791
(8) 0.9043719 / 0.08726075
(9) 0.8978211 / 0.1082611
(10) 0.8875899 / 0.09261863
mean: 0.89928012 / 0.093151656

baseline models (auc / pr)
(1) 0.8803517 / 0.07790457
(2) 0.8864958 / 0.09450126
(3) 0.9178312 / 0.07292255
(4) 0.9169143 / 0.09070817
(5) 0.8986453 / 0.09305694
(6) 0.9111622 / 0.1160295
(7) 0.8660542  / 0.09346537
(8) 0.9087771 / 0.09069152
(9) 0.9039644 / 0.1058435
(10) 0.8837407 / 0.09529999
mean: 0.89739369 / 0.093042337

*/

use data, clear

probit COW_cwinit relcincally fpsimsrswvas $control, robust cluster(dyadid)
estat ic

probit COW_cwinit cowcontig relcincally fpsimsrswvas $control, robust cluster(dyadid)
estat ic



