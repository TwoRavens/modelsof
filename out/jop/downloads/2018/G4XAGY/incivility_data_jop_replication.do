/* Analysis of "How Incivility on Partisan Media (De-)Polarizes the Electorate" */
/* Begun: Spring 2017 */ 
/* This Version: March 2018 */ 

/* Read in the Data */ 
use "JOP Civility Replication Data.dta", replace 

/* Create a log file of the output */ 
log using druckman_et_al_incivility_results

**********************
** Data Preparation ** 
**********************

/* Label treatment conditions */ 
label define trt 1 "Same Civil" 2 "Same Uncivil" 3 "Other Civil" 4 "Other Uncivil" 
label values partycondition trt 

/* Indicator for getting the civil treatment */ 
gen civil = 0 
replace civil = 1 if partycondition == 1 | partycondition == 3  
gen unciv_tr = 1 - 1*civil 
gen same_party = 0 
replace same_party = 1 if partycondition < 3 

/* Feeling Thermometers */ 
gen ft_same = demtherm if pid < 4 
replace ft_same = reptherm if pid > 4 
gen ft_other = reptherm if pid < 4 
replace ft_other = demtherm if pid > 4  

/* Ambivalence */ 
gen net_same = .  
replace net_same = favordem - unfavordem if pid < 4 
replace net_same = favorrep - unfavorrep if pid > 4 
gen net_other = .  
replace net_other = favordem - unfavordem if pid > 4 
replace net_other = favorrep - unfavorrep if pid < 4 

/* Trust */ 
gen trust_same = .  
replace trust_same = demtrust if pid < 4 
replace trust_same = reptrust if pid > 4 
gen trust_other = . 
replace trust_other = reptrust if pid < 4 
replace trust_other = demtrust if pid > 4 

/* Conflict Avoidant: Bottom 25% of the scale */ 
gen low_conf = 0 
replace low_conf = 1 if likeconf < 2.01 

/* Dummy variable for Democratic respondent */ 
gen dem = 0 
replace dem = 1 if pid < 4 

/* Dummy for Strong Partisans */ 
gen sp = 0 
replace sp = 1 if pid == 1 | pid == 7 

/* Knowledge Quiz */  
gen veto_correct = 0 
replace veto_correct = 1 if veto == 4 
gen crude_correct = 0 
replace crude_correct = 1 if export == 4
gen renew_correct = 0 
replace renew_correct = 1 if renew == 3 
gen maj_correct = 0 
replace maj_correct = 1 if partyhouse == 2 
gen law_correct = 0 
replace law_correct = 1 if court == 3 
gen vp_correct = 0 
replace vp_correct = 1 if vp == 1 
gen ban_correct = 0 
replace ban_correct = 1 if knowban == 1  
gen cons_correct = 0 
replace cons_correct = 1 if pconserv == 2 
gen know_import = 0 
replace know_import = 1 if mideast == 2 
alpha veto_correct crude_correct renew_correct maj_correct law_correct vp_correct ban_correct cons_correct know_import /* alpha = 0.67 */  
egen quiz = rsum(veto_correct crude_correct renew_correct maj_correct law_correct vp_correct ban_correct cons_correct know_import)

/* Attitudes */ 
alpha suppipe supoil 
/* alpha = 0.82, so combine */ 
egen pro_oil = rmean(suppipe supoil) 
gen party_oil = pro_oil if pid > 4 
replace party_oil = (-1*pro_oil)+8 if pid < 4 
/* Put on a [0,1] scale */ 
gen outcome7 = (-1/6) + (1/6)*party_oil  

**************
** Figure 1 **
**************

** Graph (built by reshape) ** 
** Start by making everything on the [0,1] scale ** 
gen outcome2 = ft_same/100  
gen outcome1 = (1/9)*net_same 
gen outcome4 = (1/9)*net_other  
gen outcome3 = (-1/4) + (1/4)*trust_same 
gen outcome6 = (-1/4) + (1/4)*trust_other 
gen outcome5 = ft_other/100  

/* Save this data (need to re-load it below) */ 
save "civility_working.dta", replace 

/* Reshape for loops */  
reshape long outcome, i(id) j(year) 

/* Run these commands if parmest & eclplot are not installed */ 
ssc install parmest 
ssc install eclplot   

/* Graph for In-Party Incivility */ 
qui parmby "regr outcome unciv_tr if same_party == 1", by(year) saving(myfile, replace) 
u myfile, clear 
keep if parm=="unciv_tr" 
list year estimate min95 max95 p, sepby(year) noo 
eclplot estimate min95 max95 year, horizontal ytitle("") xline(0, lcolor(black)) ///
	ylabel(2 "In-Party FT" 5 "Out-Party FT" 1 "In-Party Net Favorability" 4 "Out-Party Net Favorability" /// 
	3 "In-Party Trust" 6 "Out-Party Trust") title("Difference between Civility Conditions," "In-Party Media") /// 
	graphregion(color(white)) bgcolor(white)
graph export fig1_inparty.pdf, replace  
	
/* Graph for Out-Party Incivility */ 
/* Reload the data (clear the graph-specific data) */ 
clear 
use "civility_working.dta"
reshape long outcome, i(id) j(year) 

qui parmby "regr outcome unciv_tr if same_party == 0", by(year) saving(myfile, replace) 
u myfile, clear 
keep if parm=="unciv_tr" 
list year estimate min95 max95 p, sepby(year) noo 
eclplot estimate min95 max95 year, horizontal ytitle("") xline(0, lcolor(black)) ///
	ylabel(2 "In-Party FT" 5 "Out-Party FT" 1 "In-Party Net Favorability" 4 "Out-Party Net Favorability" ///
	3 "In-Party Trust" 6 "Out-Party Trust") title("Difference between Civility Conditions," "Out-Party Media") ///
	graphregion(color(white)) bgcolor(white)
graph export fig1_outparty.pdf, replace 

**************
** Figure 2 ** 
**************

/* Reload the data (clear the graph-specific data) */ 
clear 
use "civility_working.dta"

/* Out-Party Incivility, Interacted with Conflict Aversion */ 
foreach i of numlist 1/6{
	reg outcome`i' unciv_tr##low_conf if same_party == 0  
	margins, dydx(unciv_tr) over(low_conf) post 
	parmest, format(estimate min95 max95) saving(m`i', replace)  
}
use m1, clear 
foreach num of numlist 2/6{
	append using m`num'
}
save int_est.dta, replace  
drop if parm=="0o.low_conf" /* drop those terms generated by margins that don't need to be plotted */ 
drop if parm=="1o.low_conf"  
encode parm, gen(name) 
label define mg_lab 2 "Conflict Avoidant" 1 "Conflict Seeking" 
label values name mg_lab  
egen year = seq(), f(1) t(7) b(2) /* indicate which results go with which outcome variable */ 
save int_est.dta, replace 
eclplot estimate min95 max95 year, horizontal eplottype(scatter) rplottype(rcap) supby(name, spaceby(.25)) ///
		ytitle("") xline(0, lcolor(black)) ylabel(2 "In-Party FT" 5 "Out-Party FT" 1 "In-Party Net Favorability" ///
		4 "Out-Party Net Favorability" 3 "In-Party Trust" 6 "Out-Party Trust") ///
		title("Difference between Civility Conditions," "Out-Party Media") ///
		graphregion(color(white)) bgcolor(white) estopts1(msymbol(triangle)) estopts2(msymbol(diamond)) ciopts2(lpattern(dash))
graph export fig2_outparty.pdf, replace 		
		
/* Reload the data (clear the graph-specific data) */ 
clear 
use "civility_working.dta"
		
/* In-Party Incivility, Interacted with Conflict Aversion  */ 
foreach i of numlist 1/6{
	reg outcome`i' unciv_tr##low_conf if same_party == 1 
	margins, dydx(unciv_tr) over(low_conf) post 
	parmest, format(estimate min95 max95) saving(n`i', replace)  
}

use n1, clear 
foreach num of numlist 2/6{
	append using n`num'
}
save int_est2.dta, replace  
drop if parm=="0o.low_conf" /* drop those terms generated by margins that don't need to be plotted */ 
drop if parm=="1o.low_conf"  
encode parm, gen(name) 
label define mg_lab 2 "Conflict Avoidant" 1 "Conflict Seeking" 
label values name mg_lab  
egen year = seq(), f(1) t(7) b(2) /* indicate which results go with which outcome variable */ 
save int_est2.dta, replace 
eclplot estimate min95 max95 year, horizontal eplottype(scatter) rplottype(rcap) supby(name, spaceby(.25)) ///
		ytitle("") xline(0, lcolor(black)) ylabel(2 "In-Party FT" 5 "Out-Party FT" 1 "In-Party Net Favorability" ///
		4 "Out-Party Net Favorability" 3 "In-Party Trust" 6 "Out-Party Trust") ///
		title("Difference between Civility Conditions," "In-Party Media") ///
		graphregion(color(white)) bgcolor(white) estopts1(msymbol(triangle)) estopts2(msymbol(diamond)) ciopts2(lpattern(dash))
graph export fig2_inparty.pdf, replace  
		
********************************
** Materials for the Appendix **
********************************		

/* Reload the data (clear the graph-specific data) */ 
clear 
use "civility_working.dta"

/* Manipulation Check: Civility (Table A3)  */ 
reg uncivil unciv_tr if pid != 4 
outreg2 using civility.doc, dec(2) 
reg uncivil unciv_tr same_party if pid != 4 
outreg2 using civility.doc, dec(2) 
reg uncivil same_party##unciv_tr if pid != 4
outreg2 using civility.doc, dec(2) 
test 1.unciv_tr + 1.same_party#1.unciv_tr = 0
reg uncivil same_party##unciv_tr##dem if pid!= 4 
outreg2 using civility.doc, dec(2) 

/* Manipulation Check: Politeness (Table A4) */ 
reg polite unciv_tr if pid != 4 
outreg2 using polite.doc, dec(2) 
reg polite unciv_tr same_party if pid != 4 
outreg2 using polite.doc, dec(2) 
reg polite same_party##unciv_tr if pid != 4
outreg2 using polite.doc, dec(2) 
reg polite same_party##unciv_tr##dem if pid!= 4 
outreg2 using polite.doc, dec(2) 


/* Incivility Effects, In-Party/Out-Party Sources (Tables A5-A10) */ 
foreach i of numlist 1/6{
	reg outcome`i' unciv_tr if same_party == 0 
	outreg2 using other_party_base.doc, dec(2)  
	reg outcome`i' unciv_tr if same_party == 1 
	outreg2 using same_party_base.doc, dec(2) 
	reg outcome`i' unciv_tr##low_conf if same_party == 0 
	outreg2 using other_party_conf.doc, dec(2) 
	reg outcome`i' unciv_tr##low_conf if same_party == 1 
	outreg2 using same_party_conf.doc, dec(2) 
	reg outcome`i' unciv_tr##c.likeconflict if same_party == 0 
	outreg2 using other_party_cont.doc, dec(2) 
	reg outcome`i' unciv_tr##c.likeconflict if same_party == 1 
	outreg2 using same_party_cont.doc, dec(2) 
} 

/* Regressions Results, Split by Party (Tables A11-A22) */ 
/* For Democrats */ 
foreach i of numlist 1/6{
	reg outcome`i' unciv_tr if same_party == 0 & pid < 4 
	outreg2 using other_party_base_dem.doc, dec(2)  
	reg outcome`i' unciv_tr if same_party == 1 & pid < 4 
	outreg2 using same_party_base_dem.doc, dec(2) 
	reg outcome`i' unciv_tr##low_conf if same_party == 0 & pid < 4 
	outreg2 using other_party_conf_dem.doc, dec(2) 
	reg outcome`i' unciv_tr##low_conf if same_party == 1 & pid < 4 
	outreg2 using same_party_conf_dem.doc, dec(2) 
	reg outcome`i' unciv_tr##c.likeconflict if same_party == 0 & pid < 4
	outreg2 using other_party_cont_dem.doc, dec(2) 
	reg outcome`i' unciv_tr##c.likeconflict if same_party == 1 & pid < 4 
	outreg2 using same_party_cont_dem.doc, dec(2) 
} 
/* For Republicans */ 
foreach i of numlist 1/6{
	reg outcome`i' unciv_tr if same_party == 0 & pid > 4 
	outreg2 using other_party_base_rep.doc, dec(2)  
	reg outcome`i' unciv_tr if same_party == 1 & pid > 4 
	outreg2 using same_party_base_rep.doc, dec(2) 
	reg outcome`i' unciv_tr##low_conf if same_party == 0 & pid > 4 
	outreg2 using other_party_conf_rep.doc, dec(2) 
	reg outcome`i' unciv_tr##low_conf if same_party == 1 & pid > 4 
	outreg2 using same_party_conf_rep.doc, dec(2) 
	reg outcome`i' unciv_tr##c.likeconflict if same_party == 0 & pid > 4
	outreg2 using other_party_cont_rep.doc, dec(2) 
	reg outcome`i' unciv_tr##c.likeconflict if same_party == 1 & pid > 4 
	outreg2 using same_party_cont_rep.doc, dec(2) 
} 

/* Results for Independents (Tables A23-A24) */ 

/* Recode DVs so they're D/R, rather than in/out */ 
gen net_dem = favordem - unfavordem 
gen net_rep = favorrep - unfavorrep 

reg net_dem unciv_tr if pid == 4 & condition < 3 
outreg2 using indep_msnbc.doc, dec(2) 
reg demtherm unciv_tr if pid == 4 & condition < 3 
outreg2 using indep_msnbc.doc, dec(2) 
reg demtrust unciv_tr if pid == 4 & condition < 3 
outreg2 using indep_msnbc.doc, dec(2) 
reg net_rep unciv_tr if pid == 4 & condition < 3 
outreg2 using indep_msnbc.doc, dec(2) 
reg reptherm unciv_tr if pid == 4 & condition < 3 
outreg2 using indep_msnbc.doc, dec(2) 
reg reptrust unciv_tr if pid == 4 & condition < 3 
outreg2 using indep_msnbc.doc, dec(2) 

reg net_dem unciv_tr if pid == 4 & condition > 2 
outreg2 using indep_fox.doc, dec(2) 
reg demtherm unciv_tr if pid == 4 & condition > 2 
outreg2 using indep_fox.doc, dec(2) 
reg demtrust unciv_tr if pid == 4 & condition > 2 
outreg2 using indep_fox.doc, dec(2) 
reg net_rep unciv_tr if pid == 4 & condition > 2 
outreg2 using indep_fox.doc, dec(2) 
reg reptherm unciv_tr if pid == 4 & condition > 2  
outreg2 using indep_fox.doc, dec(2) 
reg reptrust unciv_tr if pid == 4 & condition > 2 
outreg2 using indep_fox.doc, dec(2) 

/* Interactive Effects for Independents (Tables A25 - A26) */ 
reg net_dem unciv_tr##low_conf if pid == 4 & condition < 3 
outreg2 using indep_msnbc_int.doc, dec(2) 
reg demtherm unciv_tr##low_conf if pid == 4 & condition < 3 
outreg2 using indep_msnbc_int.doc, dec(2) 
reg demtrust unciv_tr##low_conf if pid == 4 & condition < 3 
outreg2 using indep_msnbc_int.doc, dec(2) 
reg net_rep unciv_tr##low_conf if pid == 4 & condition < 3 
outreg2 using indep_msnbc_int.doc, dec(2) 
reg reptherm unciv_tr##low_conf if pid == 4 & condition < 3 
outreg2 using indep_msnbc_int.doc, dec(2) 
reg reptrust unciv_tr##low_conf if pid == 4 & condition < 3 
outreg2 using indep_msnbc_int.doc, dec(2) 

reg net_dem unciv_tr##low_conf if pid == 4 & condition > 2 
outreg2 using indep_fox_int.doc, dec(2) 
reg demtherm unciv_tr##low_conf if pid == 4 & condition > 2 
outreg2 using indep_fox_int.doc, dec(2) 
reg demtrust unciv_tr##low_conf if pid == 4 & condition > 2 
outreg2 using indep_fox_int.doc, dec(2) 
reg net_rep unciv_tr##low_conf if pid == 4 & condition > 2 
outreg2 using indep_fox_int.doc, dec(2) 
reg reptherm unciv_tr##low_conf if pid == 4 & condition > 2  
outreg2 using indep_fox_int.doc, dec(2) 
reg reptrust unciv_tr##low_conf if pid == 4 & condition > 2 
outreg2 using indep_fox_int.doc, dec(2)

/* Hetergeneous Treatement Effects: Partisan Strength & Knowledge (Tables A27-A30) */ 
foreach i of numlist 1/6{
	reg outcome`i' unciv_tr##sp if same_party == 1 
	outreg2 using same_party_pstrength.doc, dec(2) 
	reg outcome`i' unciv_tr##c.quiz if same_party == 1 
	outreg2 using same_party_quiz.doc, dec(2) 
}

foreach i of numlist 1/6{
	reg outcome`i' unciv_tr##sp if same_party == 0 
	outreg2 using other_party_pstrength.doc, dec(2) 
	reg outcome`i' unciv_tr##c.quiz if same_party == 0 
	outreg2 using other_party_quiz.doc, dec(2) 
}


/* Effects on Issue Positions (Table A31) */ 
reg outcome7 unciv_tr if same_party == 0 
outreg2 using issues.doc, dec(2) 
reg outcome7 unciv_tr##low_conf if same_party == 0 
outreg2 using issues.doc, dec(2) 
reg outcome7 unciv_tr if same_party == 1 
outreg2 using issues.doc, dec(2) 
reg outcome7 unciv_tr##low_conf if same_party == 1 
outreg2 using issues.doc, dec(2) 

/* Close the log */ 
log off 
