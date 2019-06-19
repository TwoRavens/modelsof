clear
set matsize 800
set mem 100m
cd "D:\USB Key\Skilled Labour Demand\20111201"
use Sent_to_yi_20111213.dta
*******************************************************************************************************************
/*Commands for generating Figure 1*/
/*We obtain data on net exports from:
http://faculty.som.yale.edu/peterschott/sub_international.htm
and use data ``SIC87-level U.S. import and export data, 1972-2005 (SIC or NAICS x country x year; Stata format).''
These data are described by Peter K. Schott in 
http://faculty.som.yale.edu/peterschott/files/research/data/sic_naics_trade_20100504.pdf

The file's name is: xm_sic87_72_105_20100504.dta  */


clear
set mem 300m
use xm_sic87_72_105_20100504.dta, clear
keep wbcode year sic customs x vship
sort sic year
gen china_imports=0
replace china_imports=1 if wbcode=="CHN"
replace china_imports=china_imports*customs

gen lw_imports=0
replace lw_imports=1 if wbcode=="AFG" | wbcode=="ALB" | wbcode=="AGO" | wbcode=="ARM" | wbcode=="AZE" | wbcode=="BGD" 
replace lw_imports=1 if wbcode=="BEN" | wbcode=="BTN" | wbcode=="BFA" | wbcode=="BDI" | wbcode=="KHM" | wbcode=="CAF"
replace lw_imports=1 if wbcode=="TCD" | wbcode=="CHN" | wbcode=="COM" | wbcode=="COG" | wbcode=="GNQ" | wbcode=="ERI"
replace lw_imports=1 if wbcode=="ETH" | wbcode=="GMB" | wbcode=="GEO" | wbcode=="GHA" | wbcode=="GNB" | wbcode=="GIN"
replace lw_imports=1 if wbcode=="GUY" | wbcode=="HTI" | wbcode=="IND" | wbcode=="KEN" | wbcode=="LAO" | wbcode=="LSO"
replace lw_imports=1 if wbcode=="MDG" | wbcode=="MWI" | wbcode=="MDV" | wbcode=="MLI" | wbcode=="MRT" | wbcode=="MDA"
replace lw_imports=1 if wbcode=="MOZ" | wbcode=="NPL" | wbcode=="NER" | wbcode=="PAK" | wbcode=="RWA" | wbcode=="WSM"
replace lw_imports=1 if wbcode=="STP" | wbcode=="SLE" | wbcode=="SOM" | wbcode=="LKA" | wbcode=="VCT" | wbcode=="SDN"
replace lw_imports=1 if wbcode=="TGO" | wbcode=="UGA" | wbcode=="VNM" | wbcode=="YEM"
replace lw_imports=lw_imports*customs

collapse (sum) customs china_imports lw_imports x (mean) vship, by(sic year)
sort year

collapse (sum) customs china_imports lw_imports x vship, by(year)

gen imp=(customs)/(customs+vship-x)
label variable imp "Imp. penetration"
gen imp_china=(china_imports)/(customs+vship-x)
label variable imp_china "China imp. penetration"
gen imp_lw=(lw_imports)/(customs+vship-x)
label variable imp_lw "Low-wage imp. penetration"

twoway (tsline imp if year<2002, lpattern(solid)) (tsline imp_lw if year<2002, recast(connected) yaxis(2)) (tsline imp_china if year<2002, yaxis(2) lpattern(dash)), ytitle(Import penetration ratio (%)) ttitle(Year)
*******************************************************************************************************************
/*Commands for generating the Tables*/
/*The file's name is: REStat.dta  */
use REStat.dta
/**** Table 2 Summary Statistics ****/
/* skill measures */
sum cognitive_non interactive_non cognitive_rou manual_non manual_rou 
/* main variables */
sum ln_im_pen ln_nonlw_im_pen ln_nonchinaimpen if year>1971
/* controls */
sum ln_cap_emp ln_cap_prodh ln_equip_prodh ln_equip_emp ln_vship_emp ln_emp ln_vship if year>1971
/* IVs */
sum im_pen_uk 
sum mer if year>1970
/**** Table 2 Summary Statistics ****/




/*********************************************************** regressions ***********************************************************/
/**** Table 3 Panel C ****/
set more off
reg cognitive_non id* yr* L.ln_im_pen, robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*)  replace
reg interactive_non id* yr* L.ln_im_pen, robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
reg cognitive_rou id* yr* L.ln_im_pen, robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
reg manual_non id* yr* L.ln_im_pen, robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
reg manual_rou id* yr* L.ln_im_pen, robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
/**** Table 3 Panel C ****/

/**** Table 3 Panel A & Table 7: Reduced-form****/
set more off
foreach skills in cognitive_non interactive_non cognitive_rou manual_non manual_rou {
ivreg2 `skills' id* yr* (L.ln_im_pen = L.im_pen_uk), robust bw(2) first ffirst savefirst saverf
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
estimates clear
}
/**** Table 3 Panel A & Table 7: Reduced-form ****/

/**** Table 3 Panel B ****/
set more off
foreach skills in cognitive_non interactive_non cognitive_rou manual_non manual_rou {
ivreg2 `skills' id* yr* (L.ln_im_pen = L.mer), robust bw(2) first ffirst savefirst saverf
outreg2 using results, bdec(4) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat), "Anderson-Rubin chi-sqared test", e(archi2), "p-value of Anderson-Rubin chi-sqared test" ,e(archi2p))
outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
estimates clear
}
/**** Table 3 Panel B ****/

/**** Table 4 Panel A ****/
set more off
foreach skills in cognitive_non interactive_non cognitive_rou manual_non manual_rou {
ivreg2 `skills' id* yr* L2.ln_cap_emp (L.ln_im_pen = L.im_pen_uk) , robust bw(2) first ffirst savefirst
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
estimates clear
}
/**** Table 4 Panel A ****/

/**** Table 4 Panel B ****/
set more off
foreach skills in cognitive_non interactive_non cognitive_rou manual_non manual_rou {
ivreg2 `skills' id* yr* L2.ln_cap_emp (L.ln_im_pen = L.mer) , robust bw(2) first ffirst savefirst
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat), "Anderson-Rubin chi-sqared test", e(archi2), "p-value of Anderson-Rubin chi-sqared test" ,e(archi2p))
outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
estimates clear
}
/**** Table 4 Panel B ****/

/**** Table 4 Panel C: alternative capital-to-labor measurs ****/
foreach skills in cognitive_non interactive_non cognitive_rou manual_non manual_rou {
    /*alternative cap-to-labor ratio*/
	ivreg2 `skills' (L.ln_im_pen=L.im_pen_uk) L2.ln_equip_emp yr* id*, first ffirst robust bw(2)
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))	
	ivreg2 `skills' (L.ln_im_pen=L.im_pen_uk) L2.ln_cap_prodh yr* id*, first ffirst robust bw(2)
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))	
	ivreg2 `skills' (L.ln_im_pen=L.im_pen_uk) L2.ln_equip_prodh yr* id*, first ffirst robust bw(2)
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))	
}
	
/**** Table 4 Panel C: alternative capital-to-labor measurs ****/

/**** Table 5 exclude china ****/
set more off
foreach skills in cognitive_non interactive_non cognitive_rou manual_non manual_rou {
	ivreg2 `skills' (L.ln_nonchinaimpen= L.im_pen_nochina_uk) yr* id*, first ffirst robust bw(2) savefirst
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
	outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
	estimates clear
	ivreg2 `skills' (L.ln_nonchinaimpen=L.mer) yr* id*, first ffirst robust bw(2) savefirst
	outreg2 using results, bdec(4) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat), "Anderson-Rubin chi-sqared test", e(archi2), "p-value of Anderson-Rubin chi-sqared test" ,e(archi2p))	
	outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
	estimates clear
	ivreg2 `skills' (L.ln_nonchinaimpen2 L.ln_china_im_pen= L.im_pen_nochina_uk  L.im_pen_china_uk) yr* id*, first ffirst robust bw(2) savefirst
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
	outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
	estimates clear
}

/**** Table 5 exclude china ****/


/**** Table 6 exclude low-wage countries ****/
set more off
foreach skills in cognitive_non interactive_non cognitive_rou manual_non manual_rou {
	ivreg2 `skills' (L.ln_nonlw_im_pen= L.im_pen_nolowwage_uk) yr* id*, robust bw(2) savefirst
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
	outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
	estimates clear
	ivreg2 `skills' (L.ln_nonlw_im_pen=L.mer) yr* id*, first ffirst robust bw(2) savefirst
	outreg2 using results, bdec(4) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat), "Anderson-Rubin chi-sqared test", e(archi2), "p-value of Anderson-Rubin chi-sqared test" ,e(archi2p))
	outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
	estimates clear
	ivreg2 `skills' (L.ln_nonlw_im_pen2 L.ln_lw_im_pen= L.im_pen_nolowwage_uk  L.im_pen_lowwage_uk) yr* id*, robust bw(2) savefirst
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
	outreg2 [_ivreg2_*] using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
	estimates clear
}
/**** Table 6 exclude low-wage countries ****/

/**** Table 7: Reduced-form ****/
/**** they are from Table 3 Panel A ****/
/**** Table 7: Reduced-form ****/

/**** Table 8 ****/
set more off
xi: xtabond2  cognitive_non L.( cognitive_non ln_im_pen) i.year, gmm( cognitive_non, lag(2 5)) iv(i.year) iv(L.im_pen_uk) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2   interactive_non L.(  interactive_non ln_im_pen) i.year, gmm(  interactive_non, lag(2 5)) iv(i.year) iv(L.im_pen_uk) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2    cognitive_rou L.(  cognitive_rou ln_im_pen) i.year, gmm(  cognitive_rou, lag(2 5)) iv(i.year) iv(L.im_pen_uk) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2   manual_non L.(   manual_non ln_im_pen) i.year, gmm(   manual_non, lag(2 5)) iv(i.year) iv(L.im_pen_uk) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2    manual_rou L.(   manual_rou ln_im_pen) i.year, gmm(   manual_rou, lag(2 5)) iv(i.year) iv(L.im_pen_uk) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2  cognitive_non L.( cognitive_non ln_im_pen) i.year, gmm( cognitive_non, lag(2 5)) iv(i.year) iv(L.mer) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2   interactive_non L.(  interactive_non ln_im_pen) i.year, gmm(  interactive_non, lag(2 5)) iv(i.year) iv(L.mer) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2    cognitive_rou L.(  cognitive_rou ln_im_pen) i.year, gmm(  cognitive_rou, lag(2 5)) iv(i.year) iv(L.mer) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2   manual_non L.(   manual_non ln_im_pen) i.year, gmm(   manual_non, lag(2 5)) iv(i.year) iv(L.mer) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
xi: xtabond2    manual_rou L.(   manual_rou ln_im_pen) i.year, gmm(   manual_rou, lag(2 5)) iv(i.year) iv(L.mer) noleveleq robust
outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) 
/**** Table 8 ****/

/**** Table 9: additional controls ****/
foreach skills in cognitive_non interactive_non cognitive_rou manual_non manual_rou {
	ivreg2 `skills' (L.ln_im_pen=L.im_pen_uk) L2.ln_emp yr* id*, first ffirst robust bw(2)
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
	ivreg2 `skills' (L.ln_im_pen=L.im_pen_uk) L2.ln_vship yr* id*, first ffirst robust bw(2)
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
	ivreg2 `skills' (L.ln_im_pen=L.im_pen_uk) L2.ln_vship_emp yr* id*, first ffirst robust bw(2)
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
}
/**** Table 9: additional controls ****/

/**** Table 10: pairwise correlation ****/
/* ratio = the ratio of non-production workers to production workers: gen ratio=(emp-prode)/prode */
pwcorr ratio cognitive_non interactive_non cognitive_rou manual_non manual_rou
/**** Table 10: pairwise correlation ****/

/**** Table 11: non-production/production workers ratio****/
	ivreg2 ratio (L.ln_im_pen=L.im_pen_uk) yr* id*, first ffirst robust bw(2)
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
	ivreg2 ratio (L.ln_im_pen=L.mer) yr* id*, first ffirst robust bw(2)
	outreg2 using results, bdec(3) rdec(3) tdec(3) bracket symb(***,**,*) addstat ("2nd-stage F-test", e(F), "Under id test: Kleibergen-Paap rk LM statistic", e(idstat), "Under id test: Kleibergen-Paap rk LM statistic p-value", e(idp), "Weak id test: Kleibergen-Paap rk Wald F statistic",e(widstat))
/**** Table 11: non-production/production workers ratio****/



/**** Table 12: 1st-stage ****/
/**** Column 1 is from the estimation results of Table 3 Panel A ****/
/**** Column 2 is from the estimation results of Table 3 Panel B ****/
/**** Column 3 is from the estimation results of Table 4 Panel B ****/
/**** Column 4 is from the estimation results of Table 4 Panel B ****/
/**** Table 12: 1st-stage ****/
