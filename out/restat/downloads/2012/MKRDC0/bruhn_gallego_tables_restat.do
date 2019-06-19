clear
capture log close
set more off

use bruhn_gallego_data_restat, clear

*******************************;
* Good, Bad, and Ugly dummies *;
*******************************;

foreach x in 50 75{
egen lpopd_`x'=pctile(lpopd), p(`x')
}
egen lpopd_av=mean(lpopd)

foreach x in 50 75 av{
gen hlpopd_`x'=1 if lpopd>=lpopd_`x'
replace hlpopd_`x'=0 if lpopd<lpopd_`x'
gen ugly_`x'=1 if hlpopd_`x'==1 & egood==1
replace ugly_`x'=0 if ugly_`x'==.
gen egood2_`x'=1 if hlpopd_`x'==0 & egood==1
replace egood2_`x'=0 if egood2_`x'==.
}

sum egood2* ebad ugly*

***********;
* Table 1 *;
***********;

log using table1.txt, replace text
	
	tabstat yppp , by (country) stats(count mean sd min max)
	tabstat lyppp , by (country) stats(count mean sd min max)

log close

***********;
* Table 2 *;
***********;

log using table2.txt, replace text
	
	tabstat lyppp lpoverty lhealth lgini lschoolspk llit lseats egood2_50 ebad mining plantations ugly_50 enone lpopd temp_avg rainfall alti landlocked, stats(count mean sd min max) columns(stats)

log close

***********;
* Table 4 *;
***********;

egen country_n=group(country)
for num 1/17: g cdX=0 if country_n~=.
for num 1/17: replace cdX=1 if country_n==X

log using table4.txt, replace text

	foreach z in ebad enone mining plantations egood2_50 ugly_50{
	reg `z' lpopd temp* rain* alti* landlocked, cluster(lpopd)
	estimates store `z'_wofe
	test temp_ temp2 rainf rain2 alti alti2 
	reg `z' lpopd temp* rain* alti* landlocked cd2-cd17, cluster(lpopd)
	estimates store `z'_wfe
	test temp_ temp2 rainf rain2 alti alti2 
	}
      xml_tab ebad_wofe mining_wofe plantations_wofe egood2_50_wofe ugly_50_wofe enone_wofe using "tables.xls", replace below font("Times New Roman" 11) drop(_cons) stats(N r2_a) sheet("Table 4a")
      xml_tab ebad_wfe mining_wfe plantations_wfe egood2_50_wfe ugly_50_wfe enone_wfe using "tables.xls", append below font("Times New Roman" 11) drop(_cons) stats(N r2_a) sheet("Table 4b")

log close

***********;
* Table 5 *;
***********;

log using table5.txt, replace text

	areg lyppp egood2_50 ebad ugly_50, a(country) cluster(lpopd)
	estimates store reg1
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	areg lyppp lpopd, a(country) cluster(lpopd)
	estimates store reg2

	areg lyppp egood2_50 ebad ugly_50 lpopd , a(country) cluster(lpopd)
	estimates store reg3
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	areg lyppp egood2_50 ebad ugly_50 lpopd temp* rain*, a(country) cluster(lpopd)
	estimates store reg4
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	areg lyppp egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg5
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	areg lyppp egood2_50 mining plantations ugly_50 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg6
	test egood2_50=ugly_50
	test plantations=mining

	xml_tab reg1 reg2 reg3 reg4 reg5 reg6 using "tables.xls", below font("Times New Roman" 11) drop(_cons) stats(N r2_a) sheet("Table 5") append

log close
	
***********;
* Table 6 *;
***********;

log using table6.txt, replace text

	areg lpoverty egood2_50 ebad ugly_50, a(country) cluster(lpopd)
	estimates store reg1
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	areg lpoverty lpopd, a(country) cluster(lpopd)
	estimates store reg2

	areg lpoverty egood2_50 ebad ugly_50 lpopd , a(country) cluster(lpopd)
	estimates store reg3
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	areg lpoverty egood2_50 ebad ugly_50 lpopd temp* rain*, a(country) cluster(lpopd)
	estimates store reg4
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	areg lpoverty egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg5
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	xml_tab reg1 reg2 reg3 reg4 reg5 using "tables.xls", below font("Times New Roman" 11) drop(_cons) stats(N r2_a) sheet("Table 6") append

log close

***********;
* Table 7 *;
***********;

preserve 
log using table7.txt,replace text
	
	keep country lyppp lhealth lyear lpopd egood2_50 ebad ugly_50 temp* rain* alti* landlocked
	keep if lhealth~=.
	egen lhealth_mean=mean(lhealth)
	egen lhealth_sd=sd(lhealth)
	gen lhealth_norm=(lhealth-lhealth_mean)/lhealth_sd
	egen lyppp_mean=mean(lyppp)
	egen lyppp_sd=sd(lyppp)
	gen lyppp_norm=(lyppp-lyppp_mean)/lyppp_sd
	expand 2
	egen dummy_post=seq(), f(0) t(1)
	gen norm=lhealth_norm
	replace norm=lyppp_norm if dummy_post==1

	xi3: areg norm egood2_50*dummy_post ebad*dummy_post ugly_50*dummy_post lpopd*dummy_post lyear*dummy_post temp_*dummy_post temp2*dummy_post  rainf*dummy_post rain2*dummy_post alti*dummy_post alti2*dummy_post landlocked*dummy_post , a(country) cluster(lpopd)
	estimates store FIXED 
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50
	
	xml_tab FIXED using "tables.xls", below font("Times New Roman" 11) drop(_cons) stats(N r2_a) sheet("Table 7") append

	restore

log close

***********;
* Table 8 *;
***********;

log using table8.txt, replace text

	areg lyppp lpopd temp* rain* alti* landlocked if enone==0, a(country) cluster(lpopd)
	estimates store reg1	
	areg lyppp lpopd temp* rain* alti* landlocked if enone==1, a(country) cluster(lpopd)
	estimates store reg2
	xml_tab reg1 reg2 using "tables.xls", below font("Times New Roman" 11) stats(N r2_a) sheet("Table 8") append

log close

***********;
* Table 9 *;
***********;

log using table9.txt, replace text

	areg lgini egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg1
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50
	areg lschoolspk egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg2
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50
	areg llit egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg3
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50
	areg lseats egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg4
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50
	xml_tab reg1 reg2 reg3 reg4 using "tables.xls", below font("Times New Roman" 11) keep(egood2_50 ebad ugly_50 lpopd) stats(N r2_a) sheet("Table 9") append

log close

********************;
* Appendix Table 1 *;
********************;

 	forvalues z=1/17 {
 	areg lyppp egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked if cd`z'~=1, a(country) cluster(lpopd)
	estimates store reg`z'
	}
	xml_tab reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 reg10 reg11 reg12 reg13 reg14 reg15 reg16 reg17 using "tables.xls", below font("Times New Roman" 11) keep(egood2_50 ebad ugly_50 lpopd) stats(N r2_a) sheet("App T1a") append

	estimates clear

	areg lyppp egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked if country~="Guatemala" & country~="Honduras" & country~="Panama" & country~="Paraguay" & country~="Uruguay" & country~="Venezuela", a(country) cluster(lpopd)
	estimates store reg1
	xml_tab reg1 using "tables.xls", below font("Times New Roman" 11) keep(egood2_50 ebad ugly_50 lpopd) stats(N r2_a) sheet("App T1b") append

********************;
* Appendix Table 2 *;
********************;

log using app_table2.txt, replace text

	areg lyppp egood2_50 ebad ugly_50 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg1a
	test egood2_50=ebad
	test egood2_50=ugly_50
	test ebad=ugly_50

	areg lyppp egood2_av ebad ugly_av lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg2a
	test egood2_av=ebad
	test egood2_av=ugly_av
	test ebad=ugly_av

	areg lyppp egood2_75 ebad ugly_75 lpopd temp* rain* alti* landlocked, a(country) cluster(lpopd)
	estimates store reg3a
	test egood2_75=ebad
	test egood2_75=ugly_75
	test ebad=ugly_75

	xml_tab reg1a reg2a reg3a using "tables.xls", below font("Times New Roman" 11) drop(_cons) stats(N r2_a) sheet("App T2") append
	estimates clear 

log close

