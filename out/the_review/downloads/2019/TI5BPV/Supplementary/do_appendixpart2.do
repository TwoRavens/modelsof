**************************************************************************************************
******APPENDIX DO FILE FOR "OFFICE-SELLING, CORRUPTION AND LONG-TERM DEVELOPMENT IN PERU"*********
******BY JENNY GUARDADO, GEORGETOWN UNIVERSITY, jennyguardado@gmail.com***************************
******PART 2     *********************************************************************************
**************************************************************************************************
**************************************************************************************************

capture log close
clear 
cd  "C:\Users\jenny\Dropbox\Replication Office-selling\Supplementary"

log using app_part2, replace


***************************************************************************
*****Table A.14 Balance Table -- District Geographic Traits
***************************************************************************

use main_part2_2, clear

	local replace replace
	foreach var of varlist lz suitindex ldistlima centerxgd centerygd { 
	xi: reg `var' meanprice minpriceh, cluster(provincia)
	outreg2 meanprice minpriceh using tableA14.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}	

keep if minpriceh!=. & meanprice!=. 

	local replace append
	foreach var of varlist lz suitindex ldistlima centerxgd centerygd { 
	xi: reg `var' soldpc, cluster(provincia)
	outreg2 meanprice minpriceh using tableA14.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}	

	
***************************************************************************
*****Table A.15 Balance Table -- Provincial Historical Traits
***************************************************************************


use main_part2_2, clear

	local replace replace
	foreach var of varlist lreparto2 mine mita econactivity2 lind54 govreb_pre { 
	xi: reg `var' meanprice minpriceh, cluster(provincia)
	outreg2 meanprice minpriceh using tableA15.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}	

keep if minpriceh!=. & meanprice!=. 

	local replace append
	foreach var of varlist lreparto2 mine mita econactivity2 lind54 govreb_pre { 
	xi: reg `var' soldpc, cluster(provincia)
	outreg2 meanprice minpriceh using tableA15.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}	


***************************************************************************
*****Table A.16 Balance Table -- Population in 1572
***************************************************************************

use main_part2_2, clear

gen lpop1572 = log(pop1572)

	local replace replace
	foreach var of varlist lpop1572 ltrib_rate logtributario { 
	reg `var' meanprice minpriceh, cluster(provincia)
	outreg2 meanprice using tableA16.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}
	
keep if meanprice!=. & minpriceh!=. 
	
	local replace append
	foreach var of varlist lpop1572 ltrib_rate logtributario { 
	reg `var' soldpc, cluster(provincia)
	outreg2 soldpc using tableA16.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local append
	}
	
***************************************************************************
*****Table A.17 Balance Table -- 1572 Budget Administration
***************************************************************************
	
	local replace replace
	foreach var of varlist shpriest shcorreg shcaciq shencom { 
	reg `var' meanprice minpriceh, cluster(provincia)
	outreg2 meanprice using tableA17.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust)) 
	local replace
	}
	
keep if meanprice!=. & minpriceh!=. 

	local replace append
	foreach var of varlist shpriest shcorreg shcaciq shencom { 
	reg `var' soldpc, cluster(provincia)
	outreg2 soldpc using tableA17.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust)) 
	local append
	}

***************************************************************************
*****Table A.18 Balance Table -- 1572 Demographics
***************************************************************************

	local replace replace
	foreach var of varlist  perctribut percviejos percmuchachos percmujeres { 
	reg `var' meanprice minpriceh, cluster(provincia)
	outreg2 meanprice using tableA18.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust)) 
	local replace
	}
	
keep if meanprice!=. & minpriceh!=. 
	
	local replace append
	foreach var of varlist  perctribut percviejos percmuchachos percmujeres { 
	reg `var' soldpc, cluster(provincia)
	outreg2 soldpc using tableA18.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust)) 
	local append
	}	


***************************************************************************
*****Table A.19: Determinants of Average Province Prices 
***************************************************************************

use main_part1, clear

#delimit ;
collapse (mean) rprice1 (mean) gov_reb  z suitindex distlima 
rep50 lreparto2 wage mine mita econactivity2 lind54, by(provcode);
#delimit cr

gen lrprice1 = log(rprice1)
gen lwage = log(wage)
gen lz = log(z)
gen ldistlima = log(distlima)

xi: reg lrprice1 lreparto2, r 

keep if e(sample)

#delimit ;
	local replace replace;
	foreach var of varlist lz suitindex ldistlima 
	lreparto2 lwage mine mita econactivity2 lind54 gov_reb{; 
	xi: reg lrprice1 `var' , r ;
	outreg2 using tableA19.tex, `replace'  pvalue bdec(3) tdec(3) nocons noni;
	local replace;
	};	
#delimit cr

***************************************************************************
*****Table A.20: All Coefficients from Table 5 Panel A of Main Text
***************************************************************************

use main_part2_1, clear

*Individual Level Data

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice minpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tableA20A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local replace
	}
	
	
*District Level Data

use main_part2_2, clear


	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using  tableA20A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local append
	}


***************************************************************************
*****Table A.21: Alternative Measures of Office Prices 
***************************************************************************

use main_part2_1, clear

*PANEL A

*Individual Level Data

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice meanpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice meanpriceh using tableA21A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local replace
	}
	
*District Level Data

use main_part2_2, clear

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice meanpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice meanpriceh using  tableA21A.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}

*PANEL B

use main_part2_1, clear

*Individual Level Data

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice firstpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice firstpriceh using tableA21B.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}
	
*District Level Data

use main_part2_2, clear

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice firstpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice firstpriceh using  tableA21B.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}

**************************************************************************************
*****Table A.22: Office Prices and Contemporary Development Outcomes: Adding Controls
**************************************************************************************

*PANEL A

use main_part2_1, clear

*Individual Level Data

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice minpriceh mita adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tableA22A.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}

*District Level Data

use main_part2_2, clear

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice minpriceh mita lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using  tableA22A.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}
			
	
*PANEL B	

use main_part2_1, clear

*Individual Level Data

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice minpriceh mine adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tableA22B.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}

	
*District Level Data

use main_part2_2, clear


	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice minpriceh mine lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using  tableA22B.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local append
	}
	
	
*PANEL C	

use main_part2_1, clear

*Individual Level Data

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice minpriceh bishop adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tableA22C.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}

	
*District Level Data

use main_part2_2, clear

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice minpriceh bishop lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using  tableA22C.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}	

	
*PANEL D
	
use main_part2_1, clear

*Individual Level Data

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice minpriceh wage adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tableA22D.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}

*District Level Data

use main_part2_2, clear

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice minpriceh wage lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using  tableA22D.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local append
	}	

		
*PANEL E
	
use main_part2_1, clear

*Individual Level Data

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice minpriceh ind54 adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tableA22E.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local replace
	}


*District Level Data

use main_part2_2, clear

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice minpriceh ind54 lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using  tableA22E.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local append
	}	

	
**************************************************************************************
*****Table A.23: Placebo Test
**************************************************************************************
	
use main_part2_1, clear

*Baseline

xi: reg lhhequiv meanprice minpriceh adults infants kids age male distlima suitindex z centerxgd centerygd, cluster(provincia)

keep if e(sample)

*creating 47 random groups

set seed 2001
gen random= runiform()
sum random, detail
gen randomdummy=1
forvalues i=1(1)47 {
replace randomdummy=`i' if random>=((`i'-1)/47) & random<=((`i')/47)
}

tab randomdummy

drop provcode
encode provincia, gen(provcode)
tab provcode, nolabel


forvalues i=1(1)47 {
gen placmeanprice`i' = meanprice if provcode == `i' 
}

forvalues i=1(1)47 {
egen tempmeanprice`i' = mean(placmeanprice`i') 
}

drop placmeanprice*

gen placmeanprice=.
forvalues i=1(1)47 {
replace placmeanprice = tempmeanprice`i' if randomdummy==`i'
}

drop tempmeanprice*

*****

forvalues i=1(1)47 {
gen placminhprice`i' = minpriceh if provcode == `i' 
}

forvalues i=1(1)47 {
egen tempminhprice`i' = mean(placminhprice`i') 
}

drop placminhprice*

gen placminhprice=.
forvalues i=1(1)47 {
replace placminhprice = tempminhprice`i' if randomdummy==`i'
}

drop tempminhprice*


xi: reg lhhequiv placmeanprice placminhprice adults infants kids age male distlima suitindex z centerxgd centerygd, cluster(provincia)
outreg2 placmeanprice placminhprice using tableA23.tex, replace pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust)) 

xi: reg schoolyears placmeanprice placminhprice adults infants kids age male distlima suitindex z centerxgd centerygd, cluster(provincia)
outreg2 placmeanprice placminhprice using tableA23.tex, append pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))


*DISTRICT LEVEL RESULTS

use main_part2_2, clear

reg toilethouse meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia)

keep if e(sample)

*creating 47 random groups

set seed 2001
gen random= runiform()
sum random, detail
gen randomdummy=1
forvalues i=1(1)47 {
replace randomdummy=`i' if random>=((`i'-1)/47) & random<=((`i')/47)
}

tab randomdummy

drop provcode
encode provincia, gen(provcode)
tab provcode, nolabel


forvalues i=1(1)47 {
gen placmeanprice`i' = meanprice if provcode == `i' 
}

forvalues i=1(1)47 {
egen tempmeanprice`i' = mean(placmeanprice`i') 
}

drop placmeanprice*

gen placmeanprice=.
forvalues i=1(1)47 {
replace placmeanprice = tempmeanprice`i' if randomdummy==`i'
}

drop tempmeanprice*

*****

forvalues i=1(1)47 {
gen placminhprice`i' = minpriceh if provcode == `i' 
}

forvalues i=1(1)47 {
egen tempminhprice`i' = mean(placminhprice`i') 
}

drop placminhprice*

gen placminhprice=.
forvalues i=1(1)47 {
replace placminhprice = tempminhprice`i' if randomdummy==`i'
}

drop tempminhprice*


reg toilethouse placmeanprice placminhprice lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
outreg2 placmeanprice placminhprice  using tableA23.tex, append pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))

reg mud placmeanprice placminhprice lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
outreg2 placmeanprice placminhprice  using tableA23.tex, append pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))

	
**************************************************************************************
*****Table A.24: Balance Table -- Geographic Traits (border districts)
**************************************************************************************

use main_part2_2, clear

	local replace replace
	foreach var of varlist lz suitindex ldistlima centerxgd centerygd { 
	xi: reg `var' meanprice minpriceh if border==1, cluster(provincia)
	outreg2 meanprice minpriceh using tableA24.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}	

keep if minpriceh!=. & meanprice!=. 

	local replace append
	foreach var of varlist lz suitindex ldistlima centerxgd centerygd { 
	xi: reg `var' soldpc if border==1, cluster(provincia)
	outreg2 meanprice minpriceh using tableA24.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}	


	
**************************************************************************************
*****Table A.25: Balance Table -- 1572 Population (border districts)
**************************************************************************************

use main_part2_2, clear

gen lpop1572 = log(pop1572)

	local replace replace
	foreach var of varlist lpop1572 ltrib_rate logtributario { 
	reg `var' meanprice minpriceh if border==1, cluster(provincia)
	outreg2 meanprice using tableA25.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust)) 
	local replace
	}
	
keep if meanprice!=. & minpriceh!=. 
	
	local replace append
	foreach var of varlist lpop1572 ltrib_rate logtributario { 
	reg `var' soldpc if border==1, cluster(provincia)
	outreg2 soldpc using tableA25.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	}
	
	
**************************************************************************************
*****Table A.26: Balance Table -- 1572 Budget Administration (border districts)
**************************************************************************************

	local replace replace
	foreach var of varlist shpriest shcorreg shcaciq shencom { 
	reg `var' meanprice minpriceh if border==1, cluster(provincia)
	outreg2 meanprice minpriceh using tableA26.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust)) 
	local replace
	}
	
keep if meanprice!=. & minpriceh!=. 

	local replace append
	foreach var of varlist shpriest shcorreg shcaciq shencom { 
	reg `var' soldpc if border==1, cluster(provincia)
	outreg2 soldpc using tableA26.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust)) 
	local append
	}

**************************************************************************************
*****Table A.27: Balance Table -- 1572 Demographics (border districts)
**************************************************************************************
	
	local replace replace
	foreach var of varlist  perctribut percviejos percmuchachos percmujeres { 
	reg `var' meanprice minpriceh if border==1, cluster(provincia)
	outreg2 meanprice using tableA27.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust), "R2",  e(r2)) 
	local replace
	}
	
	local replace append
	foreach var of varlist  perctribut percviejos percmuchachos percmujeres { 
	reg `var' soldpc if border==1, cluster(provincia)
	outreg2 soldpc using tableA27.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust), "R2",  e(r2)) 
	local append
	}	

	
**************************************************************************************
*****Table A.28: Office Prices and 1754 Migrants and Foreigners
**************************************************************************************

use main_part2_2, clear

gen perc_orig = orig/tribut
gen perc_forast = forastero/tribut
replace tribut = log(tribut)

keep if minpriceh!=. & meanprice!=.

collapse (firstnm) perc_orig perc_forast tribut soldpc meanprice minpriceh (mean) z suitindex distlima centerxgd centerygd, by(provincia)

gen lz = log(z)
gen ldistlima = log(distlima)

 
	local replace replace
	foreach var of varlist perc_orig perc_forast tribut{ 
	reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, r
	outreg2 meanprice using tableA28.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni
	local replace
	}


**************************************************************************************
*****Table A.29: Office Prices and Contemporary Migration
**************************************************************************************

use main_part2_1, clear

collapse (mean) localborn, by(ubigeo)

sum localborn, det

gen migp25 = 0
replace migp25 = 1 if localborn<r(p25)
tab migp25

sum localborn, det

gen migp50 = 0
replace migp50 = 1 if localborn>r(p25) & localborn<=r(p50) 
tab migp50 

sum localborn, det

gen migp75 = 0
replace migp75 = 1 if localborn>r(p50) & localborn<=r(p75)
tab migp75

sum localborn, det

gen migp00 = 0
replace migp00 = 1 if localborn>r(p75)
tab migp00

keep ubigeo migp25 migp50 migp75 migp00

save mig_districts, replace

use main_part2_1, clear

merge m:1 ubigeo using mig_districts
drop _merge


*PANEL A
*Generating estimates excluding 1/4 of sample
	local replace append
	foreach sample of varlist migp25 migp50 migp75 migp00{
	reg lhhequiv meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd if `sample'==0, cluster(provincia)
	outreg2 meanprice minpriceh using tabA29A.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}



*TESTING COEFFICIENT DIFFERENCES
*household consumption (baseline, B= - 0.32)

	reg lhhequiv meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd
	est store regbase1

	foreach sample of varlist migp25 migp50 migp75 migp00{
	foreach var of varlist lhhequiv { 
	qui reg lhhequiv meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd if `sample'==0
	est store reg`sample'
	suest regbase1 reg`sample', vce(cluster provincia)
	test[regbase1_mean]meanprice = [reg`sample'_mean]meanprice
	}
}




*PANEL B
*Generating estimates excluding 1/4 of sample
	local replace append
	foreach sample of varlist migp25 migp50 migp75 migp00{
	reg schoolyears meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd if `sample'==0, cluster(provincia)
	outreg2 meanprice minpriceh using tabA29B.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local append
	}




*TESTING COEFFICIENT DIFFERENCES
*school years (baseline, B= -1.13)
	reg schoolyears meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd
	est store regbase2


*Generating estimates excluding 1/4 of sample
	local replace append
	foreach sample of varlist migp25 migp50 migp75 migp00{
	foreach var of varlist schoolyears { 
	reg schoolyears meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd if `sample'==0
	est store reg`sample'
	suest regbase2 reg`sample', vce(cluster provincia)
	test[regbase2_mean]meanprice = [reg`sample'_mean]meanprice
	local append
	}
}


*****************************************************************************************
***Table: A.30: TRUST IN THE POPULATION
*****************************************************************************************

use main_part2_1, clear

gen sum_trust = trust_jne + trust_onpe+ trust_distrit + trust_munic + trust_government + trust_police + trust_army + trust_judic + trust_paper + trust_radtv
 
gen trust1 = trust_distrit + trust_munic + trust_government 
gen trust2 = trust_jne + trust_onpe
gen trust3 = trust_police + trust_army + trust_judic
gen trust4 = trust_paper + trust_radtv

*trust results
	local replace replace
	foreach var of varlist sum_trust trust1 trust2 trust3 trust4 { 
	reg `var' meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tabA30.tex, `replace' pvalue bdec(3) tdec(3) nocons  noni adds("Clusters", e(N_clust))
	local replace
	}

log close
