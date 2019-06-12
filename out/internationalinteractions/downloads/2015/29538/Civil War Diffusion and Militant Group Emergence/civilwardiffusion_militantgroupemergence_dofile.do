

*open log file
log using "C:\Users\Chris\Dropbox\Dissertation\Data working directory2\civilwardiffusionmilitantorgs.txt", replace text



**************************************************************************************************************
**************************************************************************************************************
*
* CIVIL WAR DIFFUSION AND MILITANT GROUP EMERGENCE, 1960--2001 
*
* OCTOBER 2014
*
* SUBMISSION TO INTERNATIONAL INTERACTIONS
*
**************************************************************************************************************
**************************************************************************************************************

set more off


*load data
clear
use "C:\Users\Chris\Dropbox\Dissertation\Data working directory2\linebarger_civilwar_diffusion_emergence_of_militant_groups-v3.dta", clear


	
*---------------------------------------*		
* WAR ONSET REPLICATION	(TABLE 1)
*---------------------------------------*



**---- RESULTS TABLE 1 Buhaug and Gleditsch models with War Onset as DV----**

* M1 --- War onset DV; neighborhood conflict dummy as IV
logit allons3 ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall, nolog robust
	
	
*  M2 --- War onset DV; neighborhood conflict incidence as IV
logit allons3 neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall, nolog robust

	
	
	
	
	
*---------------------------------------*		
* MILITANT GROUP EMERGENCE (TABLE 2)
*---------------------------------------*


	

*goodness of fit tests for negative binomial
poisson groupformations ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1960 i.year if year > 1959, nolog irr robust
	poisgof
poisson groupformations neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1960 i.year if year > 1959, nolog irr robust 
	poisgof

	
	
*-----------------------*		
* MODELS 1 - 2	
*----------------------*


* M3 --- Buhaug and Gleditsch model, with group formation as DV; neighboring civil war as IV
nbreg groupformations ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1960 i.year if year > 1959, nolog irr robust
		*outreg2 using "C:\Users\Chris\Desktop\Results\researchnote-tab2", eform cti(irr) excel  replace

* M4 --- Buhaug and Gleditsch model, with group formation as DV; neighborhood conflict incidence as IV
nbreg groupformations neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1960 i.year if year > 1959, nolog irr robust 
		*outreg2 using "C:\Users\Chris\Desktop\Results\researchnote-tab2", eform cti(irr) excel 
	
	*Figure 1
	predict phat_groupformations_neighall
		gen where = -1.5
		gen pipe = "|"
		graph twoway (histogram neighall, percent ytitle(Percentage of Neighboring Conflict Incidence)  yscale(alt  axis(1)))  (scatter where neighall,  ms(none) mlabel(pipe) mlabpos(0))(qfitci phat_groupformations_neighall neighall, yaxis(2) ytitle("Expected Freq. of Group Emergence", axis(2))   yscale(alt axis(2)) clcolor(black) clwidth(medium) clpattern(dash) ciplot(rline) blwidth(vthin) blpattern(solid) legend(order(4 "Expected Freq. of Group Emergence" 3 "95% confidence intervals"  )))



*-----------------------*		
* MODELS 3 - 4 (TABLE 2)
*----------------------*


*goodness of fit tests for negative binomial	
poisson baademergencecount ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1968 i.year if year > 1959, nolog irr robust 
	poisgof
poisson baademergencecount neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1968 i.year if year > 1959, nolog irr robust 
	poisgof	
	
		
	
* M5 --- Buhaug and Gleditsch model, with BAAD formation as DV/ncivwar
nbreg baademergencecount ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1968 i.year if year > 1959, nolog irr robust 
		*outreg2 using "C:\Users\Chris\Desktop\Results\researchnote-tab2", eform cti(irr) excel 

* M6 --- Buhaug and Gleditsch model, with BAAD formation as DV/neighall
nbreg baademergencecount neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1968 i.year if year > 1959, nolog irr robust 
		*outreg2 using "C:\Users\Chris\Desktop\Results\researchnote-tab2", eform cti(irr) excel 

	
	
	
	
*---------------------------------------*		
* ANALYSIS USING BIVARIATE PROBIT	
*---------------------------------------*




*M7 --- probit model of persistence (ncivwar)
biprobit (selection: binarypersist = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop persistyears* py*) (outcome: allons3 = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop  py*) if year > 1959, robust		

		predict biprob1 if year > 1959, pmarg1 
		predict biprob2 if year > 1959, pmarg2 
	
		predict biprob00 if year > 1959, p00
		predict biprob01 if year > 1959, p01
		predict biprob10 if year > 1959	, p10
		predict biprob11 if year > 1959, p11	
		
		sum biprob*	
		
		
			
			
		
*M8 --- biprobit model (neighall)
biprobit (selection: binarypersist = neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop persistyears* py*) (outcome: allons3 = neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop  py*) if year > 1959, robust
		

*---------------------------------------*		
* TABLE 5
*---------------------------------------*	
			
	biprobit (selection: binarypersist = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop persistyears* py*) (outcome: allons3 = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop  py*) if year > 1959, robust		
		margins, dydx(*) atmeans predict(p00) post   

	biprobit (selection: binarypersist = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop persistyears* py*) (outcome: allons3 = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop  py*) if year > 1959, robust		
		margins, dydx(*) atmeans predict(p10)  post
		
	biprobit (selection: binarypersist = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop persistyears* py*) (outcome: allons3 = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop  py*) if year > 1959, robust		
		margins, dydx(*) atmeans predict(p01)  post

	biprobit (selection: binarypersist = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop persistyears* py*) (outcome: allons3 = ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop  py*) if year > 1959, robust		
		margins, dydx(*) atmeans predict(p11)  post

		



*---------------------------------------**---------------------------------------**---------------------------------------*		
* SUPPLEMENTAL APPENDIX
*---------------------------------------**---------------------------------------**---------------------------------------*		


*Table 1

sum groupformations baademergencecount binarypersist allons3 neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop if year > 1959



*Figure 2 for Appendix 
* M4 --- Buhaug and Gleditsch model, with group formation as DV, neighborhood conflict incidence as IV
nbreg groupformations neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1960 i.year if year > 1959, nolog irr robust 
	sum neighlgdp neighpol polity2l polity2sq lgdp96l lnpop ttrend1960 if year > 1959
		graph twoway (histogram neighall, percent ytitle(Percentage of Neighboring Conflict Incidence)  yscale(alt  axis(1)))  (scatter where neighall,  ms(none) mlabel(pipe) mlabpos(0))(qfit phat_groupformations_neighall neighall if polity2l >=6 & neighlgdp >= 9.0, yaxis(2) ytitle("Expected Freq. of Group Emergence", axis(2))  )    (qfit phat_groupformations_neighall neighall if polity2l < 6 & neighlgdp < 9.0 , yaxis(2) yscale(alt axis(2) range(0 0.15))  legend(order(3 "Expected Freq. of Group Emergence in Democracies"   4 "Expected Freq. of Group Emergence in Non-Democracies"   )))



*---------------------------------------*
*ROBUSTNESS TESTS FOR RANDOM EFFECTS MODEL 
*---------------------------------------*



xtset ccode year

* M1 --- Buhaug and Gleditsch model, with group formation as DV/ncivwar
xtnbreg groupformations ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1960 i.year if year > 1959, nolog irr re
		*outreg2 using "C:\Users\Chris\Desktop\Results\researchnote-tab4", eform cti(irr) excel  replace

* M2 --- Buhaug and Gleditsch model, with group formation as DV/neighall
xtnbreg groupformations neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1960 i.year if year > 1959, nolog irr re 
		*outreg2 using "C:\Users\Chris\Desktop\Results\researchnote-tab4", eform cti(irr) excel  

* M3 --- Buhaug and Gleditsch model, with BAAD formation as DV/ncivwar
xtnbreg baademergencecount ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1968 i.year if year > 1967, nolog irr re 
		*outreg2 using "C:\Users\Chris\Desktop\Results\researchnote-tab4", eform cti(irr) excel  

* M4 --- Buhaug and Gleditsch model, with BAAD formation as DV/neighall
xtnbreg baademergencecount neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop ttrend1968 i.year if year > 1967, nolog irr re 
		*outreg2 using "C:\Users\Chris\Desktop\Results\researchnote-tab4", eform cti(irr) excel  

	
*---------------------------------------*
*SARTORI SELECTION MODEL
*---------------------------------------*

*requires SARTSEL package located at: http://faculty.wcas.northwestern.edu/aes797/

*code the Sartori DV
gen sartdv = .
replace sartdv = 0 if binarypersist == 0
replace sartdv = 1 if binarypersist == 1 & allons3 == 0
replace sartdv = 2 if (binarypersist ==1 & allons3 == 1)

*TABLE 3: coding of SARSEL DV
tab sartdv
sum sartdv

drop if year < 1960

*TABLE 4: analysis using selection
sartsel sartdv ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop  peaceall ,  corr(1)

	sartpred sartdv ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop peaceall   , corr(1) se(0)
	drop psel pcond 

 
sartsel sartdv neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop peaceall, corr(1)

	sartpred sartdv neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop peaceall , corr(1) se(0)
	drop psel pcond 
	
	


*Figure 1 of Appendix
collapse (sum) groupformations baademergencecount, by (year)
twoway (bar groupformations year ) if (year > 1959 & year < 2001)
twoway (bar baademergencecount year ) if (year > 1959 & year < 2001)
	
log close
