* ==============================================================================
* 	Risky business? 
*	Welfare state reforms and government support in Britain and Denmark 
*
*	Lee, Jensen, Arndt, and Wenzelburger 
* 	British Journal of Political Science 2017
*
* 	Replication Do File for: Online Appendix
*	May 15, 2017
* ==============================================================================
set scheme sol /* ado file available at: https://dl.dropbox.com/u/3011470/scheme_sol.zip */

********************************************************************************
*****					 *******************************************************
*****   UNITED KINGDOM   *******************************************************
*****					 *******************************************************
********************************************************************************
use uk_annual_final.dta, clear

	* drop new govt's support in transitional (elec) year as DV
	foreach i of var support* {
		replace `i' = . if uk_trans_y==2
		}
	* set controls
	global epiv_uk "cor_y2 l.gdpgrowth l.inflation l.unemp_ameco"

*======================
* Table A1
*======================
preserve
set more off
	keep if domain==1
	tsset party uk_yt
	xtreg support_y l.numdirecpos l.numdirecneg cor_y2 lab l.gdpgrowth l.inflation l.unemp_ameco, vce(robust)
	estimates store uk1
restore

preserve
set more off
	keep if domain==2
	tsset party uk_yt
	xtreg support_y l.numdirecpos l.numdirecneg cor_y2 lab l.gdpgrowth l.inflation l.unemp_ameco, vce(robust)
	estimates store uk2
restore

***** Table A1: Britain 

esttab uk1 uk2, mlabel ("Pension" "Unemp.") b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 


*======================
* Table A2
*======================
preserve
	keep if domain==1
	tsset party uk_yt
	set more off
		xtreg support_y l.numposall l.numnegall $epiv_uk, vce(cluster party) 
		estimates store uk1combined
restore

***** Table A2: Britain

esttab uk1combined, mlabel ("domains-combined") b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 

	
*======================
* Table A3
*======================
tab cor_y2, gen(cor_)

preserve
	keep if domain==1
	tsset party uk_yt
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg i.cor_y2 l.gdpgrowth l.inflation l.unemp_ameco, vce(cluster party)
		estimates store uk1dcor
		xtreg support_y l.numdirecpos l.numdirecneg cor_1 cor_2 l.gdpgrowth l.inflation l.unemp_ameco, vce(cluster party)
		estimates store uk1hon
restore

preserve
	keep if domain==2
	tsset party uk_yt
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg i.cor_y2 l.gdpgrowth l.inflation l.unemp_ameco, vce(cluster party)
		estimates store uk2dcor
		xtreg support_y l.numdirecpos l.numdirecneg cor_1 cor_2 l.gdpgrowth l.inflation l.unemp_ameco, vce(cluster party)
		estimates store uk2hon
restore

***** Table A3: Britain (models 1 to 4)

esttab uk1dcor uk1hon uk2dcor uk2hon, b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 
	

*======================
* Table C2
*======================
quietly tab year, gen(year_) // 1980 1986 1996 2012

preserve
	keep if domain==1
	tsset party uk_yt
	set more off
	xtreg support_y l.numdirecpos l.numdirecneg $epiv_uk year_35 year_41 year_51 year_67, vce(cluster party)
	estimates store uk1_ydummy
restore

preserve
	keep if domain==2
	tsset party uk_yt
	set more off
	xtreg support_y l.numdirecpos l.numdirecneg $epiv_uk year_35 year_41 year_51 year_67, vce(cluster party) 
	estimates store uk2_ydummy
restore

***** Table C2: Britain (models 1 and 2)

esttab uk1_ydummy uk2_ydummy, mlabel ("Pension" "Unemp.") b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 


*======================
* Table D1
*======================
* pension
preserve
	keep if domain==1
	tsset party uk_yt
	set more off
		* median
		xtreg support_y_med l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 
		estimates store uk1med
		* center value
		xtreg support_y_cen l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 
		estimates store uk1cen
restore

* unemployment
preserve
	keep if domain==2
	tsset party uk_yt
	set more off
		* median
		xtreg support_y_med l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 
		estimates store uk2medestore
		* center value
		xtreg support_y_cen l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 
		estimates store uk2cen
restore

***** Table D1: Britain (models 1 to 4)

esttab uk1med uk1cen uk2med uk2cen, mlabel ("Pension (Mean)" "Pension (Median)" "Pension (Midpoint)" "Unemp. (Mean)" "Unemp. (Median)" "Unemp. (Midpoint)") ///
	b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 

	
*======================
* Table E1
*======================
* common
preserve
gen year2=year
collapse (max) year elec_y support cor_y2 gdpgrowth inflation unemp_ameco, by(year2)
	tabstat year elec_y support cor_y2 gdpgrowth inflation unemp_ameco, ///
		s(mean sd min max count) c(s)
restore	

* pension reform
tabstat numdirecpos numdirecneg if domain==1, s(mean sd min max count) c(s)

* unemployment reform
tabstat numdirecpos numdirecneg if domain==2, s(mean sd min max count) c(s)





********************************************************************************
*****			  **************************************************************
*****   DENMARK   **************************************************************
*****			  **************************************************************
********************************************************************************

use dk_annual_final.dta, clear	

	* drop new govt's support in transitional (elec) year as DV
	foreach i of var cabsupport* {
		replace `i' = . if dk_trans_y_pm==2
		}
		replace cor_pm_y2=0 if year==2001&party=="V"
	* define bloc
	gen bloc2 =. 		// 1 RED = A, B, BCV (1968); 2 BLUE = C, V, AV (1978)
		replace bloc2 = 1 if party=="A"|party=="B"
		replace bloc2 = 2 if party=="C"|party=="V"|dk_yt_pm==26|dk_yt_pm==27 // = year 78 and 79
	gen bloc3 = bloc2 	// 1 RED = A, B; 2 BLUE = C, V; 3 CROSS = BCV (1968), AV (1978)
		replace bloc3 = 3 if dk_yt_pm==13|dk_yt_pm==14|dk_yt_pm==15|dk_yt_pm==16|dk_yt_pm==26|dk_yt_pm==27
	gen earlyelec = 0
		replace earlyelec=1 if year==1973|year==1975|year==1977|year==1979|year==1981|year==2007
	recode elec_y (.=0)
		label def bloc 1 "red" 2 "blue" 3 "cross"
		label val bloc2 bloc3 bloc 
	* set controls
	global epiv_dk "cor_pm_y2 l.gdpgrowth l.inflation l.unemprate_ameco numcabparty"


*======================
* Table A1
*======================
gen red = 0
replace red = 1 if bloc2==1
label var red "Red Block"
	
preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg cor_pm_y2 red l.gdpgrowth l.inflation l.unemprate_ameco numcabparty, vce(robust)
		estimates store dk1red
restore

preserve
	keep if domain==2
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg cor_pm_y2 red l.gdpgrowth l.inflation l.unemprate_ameco numcabparty, vce(robust)
		estimates store dk2red
restore

***** Table A1: Denmark

esttab dk1red dk2red, se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 


*======================
* Table A2
*======================
preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numposall l.numnegall $epiv_dk, vce(cluster bloc3) 
		estimates store dk1combine
restore

***** Table A2: Denmark

esttab dk1combine, mlabel ("domains-combined") b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 


*======================
* Table A3
*======================
quietly tab cor_pm_y2, gen(cor_)

preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg i.cor_pm_y2 l.gdpgrowth l.inflation l.unemprate_ameco numcabparty, vce(cluster bloc3) 
		estimates store dk1dcor
		xtreg cabsupport_y l.numdirecpos l.numdirecneg cor_1 cor_2 l.gdpgrowth l.inflation l.unemprate_ameco numcabparty, vce(cluster bloc3) 
		estimates store dk1hon
restore

preserve
	keep if domain==2
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg i.cor_pm_y2 l.gdpgrowth l.inflation l.unemprate_ameco numcabparty, vce(cluster bloc3) 
		estimates store dk2dcor
		xtreg cabsupport_y l.numdirecpos l.numdirecneg cor_1 cor_2 l.gdpgrowth l.inflation l.unemprate_ameco numcabparty, vce(cluster bloc3) 
		estimates store dk2hon
restore

***** Table A3: Denmark (models 7 and 8)

esttab dk1dcor dk1hon dk2dcor dk2hon, b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 


*======================
* Table A4
*======================
preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg, vce(cluster bloc3)
		estimates store dk1
		xtreg cabsupport_y l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		estimates store dk2
restore

preserve
	replace support_y = . if cabsupport_y==.
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg, vce(cluster bloc3)
		estimates store dkpm1
		xtreg support_y l.numdirecpos l.numdirecneg cor_pm_y2 l.gdpgrowth l.inflation l.unemprate_ameco, vce(cluster bloc3) 
		estimates store dkpm2
restore

***** Table A4

esttab dk1 dk2 dkpm1 dkpm2, mlabel ("Pension" "Pension" "Pension" "Pension") b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 

	
*======================
* Table C2
*======================
quietly tab year, gen(year_)

preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg $epiv_dk year_23 year_27 year_37 year_39 year_42 year_50 , vce(cluster bloc3)
		estimates store dk1_ydummy
restore

preserve
	keep if domain==2
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg $epiv_dk year_23 year_27 year_37 year_39 year_42 year_50 , vce(cluster bloc3) 
		estimates store dk2_ydummy
restore

***** Table C2: Denmark (models 3 and 4)

esttab dk1_ydummy dk2_ydummy, mlabel ("Pension" "Unemp.") b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label 


*======================
* Table D1
*======================
* pension
preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		* median
		xtreg cabsupport_y_med l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		estimates store dk1med
		* center value
		xtreg cabsupport_y_cen l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		estimates store dk1cen
restore
	
* unemployment
preserve
	keep if domain==2
	tsset bloc3 dk_yt_pm
	set more off
		* median
		xtreg cabsupport_y_med l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		estimates store dk2med
		*center value
		xtreg cabsupport_y_cen l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		estimates store dk2cen
restore

***** Table D1: Denmark (models 5 to 8)

esttab dk1med dk1cen dk2med dk2cen, mlabel ("Pension (Mean)" "Pension (Median)" "Pension (Midpoint)" "Unemp. (Mean)" "Unemp. (Median)" "Unemp. (Midpoint)") ///
	b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label


*======================
* Table E2
*======================
* common
preserve
	gen year2=year
	replace elec_y = . if elec_y==0
	collapse (max) year elec_y cabsupport_y cor_pm_y2 numcabparty gdpgrowth inflation unemprate_ameco, by(year2)
	tabstat year elec_y cabsupport_y cor_pm_y2 numcabparty gdpgrowth inflation unemprate_ameco, ///
		s(mean sd min max count) c(s)
restore	

* pension reform
tabstat numdirecpos numdirecneg if domain==1, s(mean sd min max count) c(s)

* unemployment reform
tabstat numdirecpos numdirecneg if domain==2, s(mean sd min max count) c(s)




*\END
