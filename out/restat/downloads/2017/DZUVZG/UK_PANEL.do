********************************************************************************
*** Stata code to replicate the UK regional panel results.
*** Date: 12/03/2017			
********************************************************************************

********************************************************************************
* PREAMBLE
********************************************************************************

clear
clear matrix
set more off
set matsize 800

* cd "..."

use UK_PANEL, clear

********************************************************************************
* TABLE 2 
********************************************************************************

* National entry U rate (Panel A: 1, 3, 5)

#d

regress lncr national_entry_urate ct ct2 i.year i.age i.region i.london#c.nonwhite i.london#c.immig
		i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);

regress lnpcr national_entry_urate ct ct2 i.year i.age i.region i.london#c.nonwhite i.london#c.immig
		i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);
		
regress lnvcr national_entry_urate ct ct2 i.year i.age i.region i.london#c.nonwhite i.london#c.immig
		i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);
		
		
* Regional entry U rate (Panel A: 2, 4, 6);


regress lncr urate_entry i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig
		i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);

regress lnpcr urate_entry i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig
		i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);

regress lnvcr urate_entry i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig
		i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);
		
		
* Regional entry U rate - Short v Long (Panel B: 2, 4, 6);


regress lncr urate_entry_sr urate_entry_lr i.year i.age i.region i.yob i.london#c.nonwhite
		i.london#c.immig i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);
		
regress lnpcr urate_entry_sr urate_entry_lr i.year i.age i.region i.yob i.london#c.nonwhite
		i.london#c.immig i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);
		
regress lnvcr urate_entry_sr urate_entry_lr i.year i.age i.region i.yob i.london#c.nonwhite
		i.london#c.immig i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);
		
		
#d cr

********************************************************************************
* TABLE 4
********************************************************************************

* Regional entry U rates, effects by labour market experience groups

#d
	
regress lncr c.urate_entry#i.exp_group i.year i.age i.region i.yob i.london#c.nonwhite
		i.london#c.immig i.london#c.degree i.london#c.married [pweight=population], 
		vce(cluster cl);
		
regress lncr c.urate_entry#i.exp_group i(2/4).exp_1921_group#c.u_1921 
		i(2/4).exp_2224_group#c.u_2224 i(2/4).exp_2527_group#c.u_2527
		i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig i.london#c.degree
		i.london#c.married [pweight=population], vce(cluster cl);
			
regress lnpcr c.urate_entry#i.exp_group i(2/4).exp_1921_group#c.u_1921 
		i(2/4).exp_2224_group#c.u_2224 i(2/4).exp_2527_group#c.u_2527
		i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig i.london#c.degree
		i.london#c.married [pweight=population], vce(cluster cl);
				
regress lnvcr c.urate_entry#i.exp_group i(2/4).exp_1921_group#c.u_1921 
		i(2/4).exp_2224_group#c.u_2224 i(2/4).exp_2527_group#c.u_2527
		i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig i.london#c.degree
		i.london#c.married [pweight=population], vce(cluster cl);

#d cr
			
********************************************************************************
* TABLE A3
********************************************************************************

#d

regress lncr u_16 i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig
		i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);
		
regress lncr u_1618 i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig
		i.london#c.degree i.london#c.married [pweight=population], vce(cluster cl);
		
regress lncr u_16 u_17 u_18 1.age1921#c.u_1921 1.age2224#c.u_2224 1.age2527#c.u_2527
		i.year i.age i.region i.yob i.london#c.nonwhite i.london#c.immig i.london#c.degree
		i.london#c.married [pweight=population], vce(cluster cl);

		test u_16+u_17+u_18=0;

regress lncr u_16 1.age1921#c.u_1921 1.age2224#c.u_2224 1.age2527#c.u_2527 i.year i.age
		i.region i.yob i.london#c.nonwhite i.london#c.immig i.london#c.degree i.london#c.married
		[pweight=population], vce(cluster cl);
