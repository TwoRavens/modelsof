clear 
# delimit cr
set memory 100m
cap log close
set more off

*household information on need to see [Readme.txt] 


/*table 2*/
sum hage hedu hfemale hdcount  hfarm hworkm adv sigma mlambda alpha close20 ctnarea  tsownarea ownland fasspc fcount fcount01

gen alphas1 = 1 if alpha <=1 
replace alphas1= 0 if alpha> 1 

tab village, gen(vd)

/****************table 3**************/

reg sigma hage hedu hfemale hofficial religion asspc p_agri ownland   vd*, vce(clu village)
reg mlambda hage hedu hfemale hofficial asspc p_agri ownland  religion vd*, vce(clu village) 
reg alpha hage hedu hfemale hofficial asspc p_agri ownland  religion vd*, vce(clu village)

gen alphas1 = 1 if alpha <=1 
replace alphas1= 0 if alpha> 1

gen ageexp= (hage- 13) /* decide to drop those who are below age 33, they start family after 1993 */
save temp1.dta, replace


/**************Table 4 **********/
/* simplistic model */
stset dur_a

streg ageexp hedu  hofficial adult28 close20  hfemale  ownland vd* if ageexp>20, dist(weibull) robust nohr
	outreg2 ageexp hedu  hofficial adult28 close20  hfemale  ownland using "C:\data\data\GMCOTTON\outreg\table4", /*
	*/ replace se title(Table 4: Determinants of Technology Adoption with Time Invariant Variables)/*
	*/ addnote(All regressions include village fixed effect.)  slow(3000) excel dec(3)

streg sigma  ageexp hedu  hofficial adult28 close20  hfemale  ownland  vd* if ageexp>20, dist(weibull) robust 
outreg2  sigma ageexp hedu  hofficial adult28 close20  hfemale  ownland  using "C:\data\data\GMCOTTON\outreg\table4", append   se   dec(3)

streg mlambda ageexp hedu  hofficial adult28 close20  hfemale  ownland  vd* if ageexp>20, dist(weibull) robust 
outreg2  mlambda ageexp hedu  hofficial adult28 close20  hfemale  ownland using "C:\data\data\GMCOTTON\outreg\table4", append dec(3) se   

streg sigma mlambda ageexp hedu  hofficial adult28 close20  hfemale  ownland vd* if ageexp>20, dist(weibull) robust 
outreg2  sigma mlambda ageexp hedu  hofficial adult28 close20  hfemale  ownland using "C:\data\data\GMCOTTON\outreg\table4", append dec(3) se 

streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 vd* if ageexp>20,  dist(weibull) robust 
outreg2  sigma mlambda ageexp hedu  hofficial adult28 close20  hfemale  ownland using "C:\data\data\GMCOTTON\outreg\table4", append dec(3) se 

streg sigma mlambda alphas1 ageexp hfemale ownland hedu hofficial adult28 close20  vd* if ageexp>20,  dist(weibull) robust
outreg2 sigma mlambda alphas1 ageexp hfemale ownland hedu hofficial adult28 close20   using "C:\data\data\GMCOTTON\outreg\table4", append dec(3) se ctitle (alpha)

/***************table 5***********************/


streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 fcount01 vd* if ageexp>20,  dist(weibull) robust
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 fcount01  using "C:\data\data\GMCOTTON\outreg\table5", replace dec(3) se ctitle (alphas)

streg sigma mlambda alphas1 ageexp hfemale ownland hedu hofficial adult28 close20 fcount01 vd* if ageexp>20,  dist(weibull) robust
outreg2 sigma mlambda alphas1 ageexp hfemale ownland hedu hofficial adult28 close20 fcount01  using "C:\data\data\GMCOTTON\outreg\table5", append dec(3) se ctitle (alpha)

streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 index01 vd* if ageexp>20,  dist(weibull) robust
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 index01 using "C:\data\data\GMCOTTON\outreg\table5", append dec(3) se ctitle (alphas)

streg sigma mlambda alphas1 ageexp hfemale ownland hedu hofficial adult28 close20 index01 vd* if ageexp>20,  dist(weibull) robust
outreg2 sigma mlambda alphas1 ageexp hfemale ownland hedu hofficial adult28 close20 index01  using "C:\data\data\GMCOTTON\outreg\table5", append dec(3) se ctitle (alpha)

use temp1.dta, clear
egen top13index01=pctile(index01), p(66.6)
keep if index01>top13index
streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20  vd* if ageexp>20,  dist(weibull) robust nohr
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 using "C:\data\data\GMCOTTON\outreg\table5", append dec(3) se ctitle (top1_3)
sum index01, detail
*keep top 25% 
keep if index01>=.73
streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20  vd* if ageexp>20,  dist(weibull) robust nohr
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 using "C:\data\data\GMCOTTON\outreg\table5", append dec(3) se ctitle (top1_4)




//***********Table 6 robustness check other concerns *****************/
use temp1, clear

use temp1, clear
drop if yradopt<1997
gen dur_new = yradopt-1996
stset dur_new
streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 vd* if ageexp>20,  dist(weibull) robust
outreg2  sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 using "C:\data\data\GMCOTTON\outreg\table6", replace se   title(Table 10: Determinants of Technology Adoption) ctitle(lawbreaker) 

use temp1, clear
drop if noswitch==1
stset dur_a 
streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 vd* if ageexp>20,  dist(weibull) robust 
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20  using "C:\data\data\GMCOTTON\outreg\table6", append dec(3) se  ctitle (neverswitch)

stset dur_a
streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20  vd* if ageexp>20 ,  dist(weibull) vce(cluster village)
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20  using "C:\data\data\GMCOTTON\outreg\table6", append dec(3) se ctitle(village) 

stset dur_p
streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 vd* if ageexp>20,  dist(weibull) robust 
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20  using "C:\data\data\GMCOTTON\outreg\table6", append dec(3) se ctitle(Province 1st) 

stset dur_c 
streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 vd* if ageexp>20,  dist(weibull) robust 
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20  using "C:\data\data\GMCOTTON\outreg\table6", append dec(3) se ctitle(County 1st) 

stset dur_a
stcox sigma mlambda alpha ageexp hfemale  ownland hedu hofficial adult28 close20 vd* if ageexp>20,  robust 
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20  using "C:\data\data\GMCOTTON\outreg\table6", append dec(3) se ctitle(timing2001) 

/*original*/
use temp1, clear
stset dur_a 
streg sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 vd* if ageexp>20,  dist(weibull) robust 
outreg2 sigma mlambda alpha ageexp hfemale ownland hedu hofficial adult28 close20 using "C:\data\data\GMCOTTON\outreg\table6", append dec(3) se ctitle(original) 

/*************table 7***************/

use temp1, clear
streg  r2 r3 r4 r5 r6 r7 r8 r9  r10 r11 r12 r13 r14 r15 r16 r17 r18 ageexp hedu  hofficial adult28 close20  hfemale ownland vd* if ageexp>20,  dist(weibull) robust
outreg2  r2 r3 r4 r5 r6 r7 r8 r9  r10 r11 r12 r13 r14 r15 r16 r17 r18 ageexp hedu  hofficial adult28 close20  hfemale ownland using "C:\data\data\GMCOTTON\outreg\table7", append dec(3) se ctitle (alpha)

streg  sigma mlambda alpha r2 r3 r4 r5 r6 r7 r8 r9  r10 r11 r12 r13 r14 r15 r16 r17 r18 ageexp hedu  hofficial adult28 close20  hfemale ownland vd* if ageexp>20,  dist(weibull)
estimates store full

streg  sigma mlambda alpha ageexp hedu  hofficial adult28 close20  hfemale ownland vd* if ageexp>20,  dist(weibull)
estimates store short
lrtest full

