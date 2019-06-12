log using "Log_Analysis_Schwander_PSRM.smcl", replace

**********************************************************************************************************
* Replication Code
* The spread of labor market vulnerability into the middle class
* Hanna Schwander
* Political Science Research and Methods
**********************************************************************************************************

* This script replicates the empirical results (tables and figures) based on the Labour Force Survey (LFS) 1992-2015
* The generation of the relevant variables is decribed in an additional file ("create_LSF_pooled.do").

* The script relies on the package grc1leg which needs first to be installed by typing "net install grc1leg" into stata

********************************************
* 1. LOAD DATA
********************************************

use "LSF_1992-2015_rec.dta", clear
********************************************
* 2. Figure in main text
********************************************

* FIGURE 1: The spread of part-time employment and temporary employment risks to the middle class

collapse (mean) m_tempinv = tempinv	  m_part = parttime, by(year) 
save "means_1992-2015.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_tempinv = tempinv m_part = parttime if education ==3, by(year)
rename m_tempinv hs_tempinv
rename m_part hs_part 
save "hsmeans_1992-2015.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_tempinv = tempinv m_part = parttime if hswomen==1, by(year)
rename m_tempinv hswomen_tempinv
rename m_part hswomen_part 

save "hswmeans_1992-2015.dta", replace


use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_tempinv = tempinv m_part = parttime if hsyoung==1, by(year)
rename m_tempinv hsyoung_tempinv
rename m_part hsyoung_part 


merge 1:1 year using "means_1992-2015.dta"
drop _merge
merge 1:1 year using "hsmeans_1992-2015.dta"
drop _merge
merge 1:1 year using "hswmeans_1992-2015.dta"
drop _merge 

save "allmeans_1992-2015.dta", replace


tsset year
tssmooth ma smooth_part=m_part, window(2 1 3)
tssmooth ma smooth_tempinv=m_tempinv, window(2 1 3)
tssmooth ma smooth_hspart=hs_part, window(2 1 3)
tssmooth ma smooth_hstempinv=hs_tempinv, window(2 1 3)
tssmooth ma smooth_hswomenpart=hswomen_part, window(2 1 3)
tssmooth ma smooth_hswomentempinv=hswomen_tempinv, window(2 1 3)
tssmooth ma smooth_hsyoungpart=hsyoung_part, window(2 1 3)
tssmooth ma smooth_hsyoungtempinv=hsyoung_tempinv, window(2 1 3)

gen part =smooth_part*100
gen hspart =smooth_hspart*100
gen hswomenpart =smooth_hswomenpart*100
gen hsyoungpart =smooth_hsyoungpart*100
gen temp =smooth_temp*100
gen hstemp =smooth_hstemp*100
gen hswomentemp =smooth_hswomentemp*100
gen hsyoungtemp =smooth_hsyoungtemp*100


la var part "Workforce"
la var temp "Workforce"
la var hspart "High-skilled"
la var hstemp "High-skilled"
la var hswomenpart "High-skilled women"
la var hswomentemp "High-skilled women"
la var hsyoungpart "High-skilled young adults"
la var hsyoungtemp "High-skilled young adults"


* Parttime employment		
twoway line part year  || ///
		line hsyoungpart year  || ///
		line hswomenpart year  ||, ///				
		legend( size(small) margin(zero) region(lpattern(blank)) bmargin(tiny) pos(6) row(2)) ///
		ytitle("% of total employment", size(medsmall) margin(zero)) ylabel(0(5)30, labsize(small)) /// 
		title("Part-time employment") xtitle("") xlabel(1990(5)2015, labsize(medsmall)) saving(part, replace) ///
		graphregion(fcolor(white)) scheme(lean2) aspectratio(0.8)

* Temporary employment		
twoway line temp year  || ///
		line hsyoungtemp year  || ///
		line hswomentemp year  ||, ///
		legend( size(small) margin(zero) region(lpattern(blank)) bmargin(tiny) pos(6) row(2)) ///
		ytitle("", size(medsmall) margin(zero)) ylabel(0(5)30, labsize(small)) /// 
		title("Temporary employment") xtitle("") xlabel(1990(5)2015, labsize(medsmall))saving(temp, replace) ///
		graphregion(fcolor(white)) scheme(lean2) aspectratio(0.8)

		
*** Add the two graphs to Figure 1	
	grc1leg "part" "temp", graphregion(fcolor(white))
	graph export "Fig_1_spread in the MC.eps", as(eps) replace


	
*******************************************************************************************************************************
** 3. FIGURES IN THE APPENDIX
*******************************************************************************************************************************

*** Figure A.1: The spread of unemployment risk to the middle class in Western Europe
use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_unempl = unempl	, by(year) 
save "umeans_1992-2015.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_unempl = unempl if education ==3, by(year)
rename m_unempl hs_unempl
save "uhsmeans_1992-2015.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse(mean) m_unempl = unempl if hswomen==1, by(year)
rename m_unempl hswomen_unempl
save "uhswmeans_1992-2015.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_unempl = unempl if hsyoung==1, by(year)
rename m_unempl hsyoung_unempl
save "uhsymeans_1992-2015.dta", replace


use "umeans_1992-2015.dta", clear

merge 1:1 year using "uhsmeans_1992-2015.dta"
drop _merge
merge 1:1 year using "uhswmeans_1992-2015.dta"
drop _merge 
merge 1:1 year using "uhsymeans_1992-2015.dta"
drop _merge

save "UNallmeans_1992-2015.dta", replace


tsset year
tssmooth ma smooth_unempl=m_unempl, window(2 1 3)
tssmooth ma smooth_hsunempl=hs_unempl, window(2 1 3)
tssmooth ma smooth_hswomenunempl=hswomen_unempl, window(2 1 3)
tssmooth ma smooth_hsyoungunempl=hsyoung_unempl, window(2 1 3)

gen unempl =smooth_unempl*100
gen hsunempl =smooth_hsunempl*100
gen hswomenunempl =smooth_hswomenunempl*100
gen hsyoungunempl =smooth_hsyoungunempl*100

la var unempl "Workforce"
la var hsunempl "High-skilled"
la var hswomenunempl "High-skilled women"
la var hsyoungunempl "High-skilled young adults"



twoway line unempl year  || ///
		line hsyoungunempl year  || ///
		line hswomenunempl year  ||, ///
		legend( size(small) margin(zero) region(lpattern(blank))  pos(4) row(3)) ///
		ytitle("% of total employment", size(medsmall) margin(zero)) ylabel(0(5)15, labsize(medsmall)) /// 
		title("Unemployment") xtitle("") xlabel(1990(5)2015, labsize(medsmall))  ///
		graphregion(fcolor(white)) scheme(lean2) aspectratio(1)
graph export "Fig_A1_spread in the MC_UNEMPL.eps", as(eps) replace
		
		

*** Figure A.2/A.3: The spread of part-time / temporary employment risks to the middle class, per country

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_tempinv = tempinv	  m_part = parttime, by(year country) 
save "means_1992-2015CN.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_tempinv = tempinv m_part = parttime if education ==3, by(year country)
rename m_tempinv hs_tempinv
rename m_part hs_part 
save "hsmeans_1992-2015CN.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_tempinv = tempinv m_part = parttime if hswomen==1, by(year country)
rename m_tempinv hswomen_tempinv
rename m_part hswomen_part 
save "hswmeans_1992-2015CN.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_tempinv = tempinv m_part = parttime if hsyoung==1, by(year country)
rename m_tempinv hsyoung_tempinv
rename m_part hsyoung_part 
save "hsymeans_1992-2015CN.dta", replace


use "means_1992-2015CN.dta", clear
merge 1:1 year country using "hsmeans_1992-2015CN.dta"
drop _merge
merge 1:1 year country using "hswmeans_1992-2015CN.dta"
drop _merge 
merge 1:1 year country using "hsymeans_1992-2015CN.dta"
drop _merge

save "allmeans_1992-2015CN.dta", replace

encode country, gen(cnty_n)
tsset year cnty_n

tssmooth ma smooth_part=m_part, window(2 1 3)
tssmooth ma smooth_tempinv=m_tempinv, window(2 1 3)
tssmooth ma smooth_hspart=hs_part, window(2 1 3)
tssmooth ma smooth_hstempinv=hs_tempinv, window(2 1 3)
tssmooth ma smooth_hswomenpart=hswomen_part, window(2 1 3)
tssmooth ma smooth_hswomentempinv=hswomen_tempinv, window(2 1 3)
tssmooth ma smooth_hsyoungpart=hsyoung_part, window(2 1 3)
tssmooth ma smooth_hsyoungtempinv=hsyoung_tempinv, window(2 1 3)

gen part =smooth_part*100
gen hspart =smooth_hspart*100
gen hswomenpart =smooth_hswomenpart*100
gen hsyoungpart =smooth_hsyoungpart*100
gen temp =smooth_temp*100
gen hstemp =smooth_hstemp*100
gen hswomentemp =smooth_hswomentemp*100
gen hsyoungtemp =smooth_hsyoungtemp*100


la var part "Workforce"
la var temp "Workforce"
la var hspart "High-skilled"
la var hstemp "High-skilled"
la var hswomenpart "High-skilled women"
la var hswomentemp "High-skilled women"
la var hsyoungpart "High-skilled young adults"
la var hsyoungtemp "High-skilled young adults"




twoway line part year  || ///
		line hsyoungpart year  || ///
		line hswomenpart year  ||, by(country, title(Part-time employment, size(medium))) ///
		legend( size(small) margin(zero) region(lpattern(blank)) bmargin(tiny) pos(6) row(2)) ///
		ytitle("% of total employment", size(medsmall) margin(zero)) ylabel(0(10)30, labsize(medsmall)) /// 
		title("") xtitle("") xlabel(1990(10)2015, labsize(medsmall)) saving(partCN, replace) ///
		graphregion(fcolor(white)) scheme(lean2) aspectratio(0.7)
graph export "FIG_A2_PART_CN.eps", as(eps) replace

		
twoway line temp year  || ///
		line hsyoungtemp year  || ///
		line hswomentemp year  ||,  by(country, title(Temporary employment, size(medium))) ///
		legend( size(small) margin(zero) region(lpattern(blank)) bmargin(tiny) pos(6) row(2)) ///
		ytitle("% of total employment", size(medsmall) margin(zero)) ylabel(0(10)30, labsize(medsmall)) /// 
		title("") xtitle("") xlabel(1990(10)2015, labsize(medsmall))saving(tempCN, replace) ///
		graphregion(fcolor(white)) scheme(lean2) aspectratio(0.7)
graph export "FIG_A3_TEMP_CN.eps", as(eps) replace
		
save "allmeans_1992-2015CN.dta", replace


*** Figure A.4: The spread of unemployment risks to the middle class, per country

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_unempl = unempl	, by(year country) 
save "umeans_1992-2015CN.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_unempl = unempl if education ==3, by(year country)
rename m_unempl hs_unempl
save "uhsmeans_1992-2015CN.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse(mean) m_unempl = unempl if hswomen==1, by(year country)
rename m_unempl hswomen_unempl
save "uhswmeans_1992-2015CN.dta", replace

use "LSF_1992-2015_rec.dta", clear
collapse (mean) m_unempl = unempl if hsyoung==1, by(year country)
rename m_unempl hsyoung_unempl
save "uhsymeans_1992-2015CN.dta", replace


use "umeans_1992-2015CN.dta", clear

merge 1:1 year country using "uhsmeans_1992-2015CN.dta"
drop _merge
merge 1:1 year country using "uhswmeans_1992-2015CN.dta"
drop _merge 
merge 1:1 year country using "uhsymeans_1992-2015CN.dta"
drop _merge

save "UNallmeans_1992-2015CN.dta", replace

encode country, gen(cnty_n)

tsset year cnty_n
tssmooth ma smooth_unempl=m_unempl, window(2 1 3)
tssmooth ma smooth_hsunempl=hs_unempl, window(2 1 3)
tssmooth ma smooth_hswomenunempl=hswomen_unempl, window(2 1 3)
tssmooth ma smooth_hsyoungunempl=hsyoung_unempl, window(2 1 3)

gen unempl =smooth_unempl*100
gen hsunempl =smooth_hsunempl*100
gen hswomenunempl =smooth_hswomenunempl*100
gen hsyoungunempl =smooth_hsyoungunempl*100

la var unempl "Workforce"
la var hsunempl "High-skilled"
la var hswomenunempl "High-skilled women"
la var hsyoungunempl "High-skilled young adults"

twoway line unempl year  || ///
		line hsyoungunempl year  || ///
		line hswomenunempl year  ||, by(country, title(Unemployment, size(medium)))  ///
		legend( size(small) margin(zero) region(lpattern(blank))  pos(3) row(2)) ///
		ytitle("% of total employment", size(small) margin(zero)) ylabel(0(5)15, labsize(small)) /// 
		title("") xtitle("") xlabel(1990(10)2020, labsize(small))  ///
		graphregion(fcolor(white)) scheme(lean2) aspectratio(0.9)
	
graph export "FIG_A4_spread in the MC_UNEMPL_CN.eps", as(eps) replace
		
log close








