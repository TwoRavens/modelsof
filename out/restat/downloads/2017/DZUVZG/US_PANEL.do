********************************************************************************
*** Stata code to replicate the US state panel results.
*** Date: 08/03/2017			
********************************************************************************

********************************************************************************
* PREAMBLE
********************************************************************************

clear
clear matrix
set more off
set matsize 800

* cd ".."

use US_PANEL, clear

********************************************************************************
* TABLE 1 
********************************************************************************

* National entry U rate (Panel A: 1, 3, 5)

#d	
	reg lncr iur_us_16to18 avgimmig grad black married prop_fem ct ct2 i.age 
		i.state i.year [pweight=population], vce(cluster cl);
		
	reg lnpcr iur_us_16to18 avgimmig grad black married prop_fem ct ct2 i.age 
		i.state i.year [pweight=population], vce(cluster cl);
		
	reg lnvcr iur_us_16to18 avgimmig grad black married prop_fem ct ct2 i.age 
		i.state i.year [pweight=population], vce(cluster cl);
		
* State entry U rate (Panel A: 2, 4, 6);
	
	reg lncr IUR_16to18 avgimmig grad black married prop_fem i.age i.state 
		i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnpcr IUR_16to18 avgimmig grad black married prop_fem i.age i.state 
		i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnvcr IUR_16to18 avgimmig grad black married prop_fem i.age i.state 
		i.year i.yob [pweight=population], vce(cluster cl);
		

* Mobility adjusted state entry U rate (Panel B: 2, 4, 6);


	reg lncr mobility_IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnpcr mobility_IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnvcr mobility_IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
#d cr

********************************************************************************
* TABLE 3
********************************************************************************

* State entry U rates, effects by labour market experience groups

#d
	
	reg lncr c.IUR_16to18#i.exp_group avgimmig grad black married prop_fem 
		i.age i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lncr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
						
	reg lnpcr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
					
	reg lnvcr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
						
#d cr

********************************************************************************
* TABLE A1
********************************************************************************

* Panel A: Basic specification
	
#d

	reg lnburglaryr IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lntheftr IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnarsonr IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnmurderr IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnraper IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnrobberyr IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lnassaultr IUR_16to18 avgimmig grad black married prop_fem i.age 
		i.state i.year i.yob [pweight=population], vce(cluster cl);
		
* Panel B: By labour market experience groups;

	reg lnburglaryr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
		
	reg lntheftr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
		
	reg lnarsonr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
		
	reg lnmurderr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
			
	reg lnraper c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
		
	reg lnrobberyr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
		
	reg lnassaultr c.IUR_16to18#i.exp_group i(2/4).exp1921_group#c.IUR_19to21 
		i(2/4).exp2224_group#c.IUR_22to24 i(2/4).exp2527_group#c.IUR_25to27 
		avgimmig grad black married prop_fem i.age i.state i.year i.yob 
		[pweight=population], vce(cluster cl);
		
#d cr
	
********************************************************************************
* TABLE A2
********************************************************************************

#d

	reg lncr IUR avgimmig grad black married prop_fem i.age i.state i.year 
		i.yob [pweight=population], vce(cluster cl);
		
	reg lncr IUR_16to18 avgimmig grad black married prop_fem i.age i.state 
		i.year i.yob [pweight=population], vce(cluster cl);
		
	reg lncr IUR IUR_age17 IUR_age18 1.age1921#c.IUR_19to21 
		1.age2224#c.IUR_22to24 1.age2527#c.IUR_25to27 avgimmig grad black 
		married prop_fem i.age i.state i.year i.yob [pweight=population] , 
		vce(cluster cl);
	
	test IUR+IUR_age17+IUR_age18=0;	
	test (1.age1921#c.IUR_19to21 = 0) (1.age2224#c.IUR_22to24 = 0) (1.age2527#c.IUR_25to27=0);
	
	reg lncr IUR_16to18 1.age1921#c.IUR_19to21 1.age2224#c.IUR_22to24 
		1.age2527#c.IUR_25to27 avgimmig grad black married prop_fem i.age i.state 
		i.year i.yob [pweight=population] , vce(cluster cl);
		
