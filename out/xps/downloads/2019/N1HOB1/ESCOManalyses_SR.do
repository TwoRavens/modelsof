* ANALYSIS REPLICATION FILE
	* Paper: Coethnicity and Corruption: Field Experimental Evidence from Public Officials in Malawi
	* Authors: Brigitte Seim and Amanda Lea Robinson
	* Journal: Journal of Experimental Political Science

* FILE INFO
	* This .do file performs analyses reported in the main paper and appendix.
	* Place this file in the same folder as the ESCOMdata_SR.dta data file and set that file as your working directory.
	
****************************************************************

* Produce a log file
*log using ESCOMlog_SR, replace

* Load cleaned data
clear 
set more off
use "ESCOMdata_SR.dta"

* Define control variables macro
global cov  numofficials  other_customers 

*************
* MAIN TEXT *
*************

* Statistics in-text

	* "As shown in Figure 1, corruption-free..."
	tab outcome coreg, col chi2 exact

* Table 1: Observations, coethnic interactions, and home region interactions by confederate
tabstat coreg inhomereg, by(region_ra) stat(n me)
bys region_ra: tabstat coreg inhomereg, by(ra) stat(n me)

* Figure 1: Corruption outcomes by coethnicity
    preserve
proportion outcome, over(coreg)
regsave
gen outcome=1 if strpos(var, "_prop_2:")
replace outcome=2 if strpos(var, "Bribe:")
replace outcome=3 if strpos(var, "Expedited:")
gen coreg=0 if strpos(var, "subpop_1")
replace coreg=1 if strpos(var, "subpop_2")
gen hi=coef+stderr
gen lo=coef-stderr
generate comb = outcome    if coreg == 0
replace  comb = outcome+4  if coreg == 1
twoway (bar coef comb if outcome==1, barw(0.7)) ///
       (bar coef comb if outcome==2, barw(0.7)) ///
       (bar coef comb if outcome==3, barw(0.7)) ///
       (rcap hi lo comb), ///
    legend(off) xscale(range(0.25 7.75))  ///
       xlabel( 1 `" "{bf:Regular Service}" "No Bribe" "Not Expedited"  "' ///
	   2 `" "{bf:Bribe}" "Bribe" "Expedited"  "'  3 `""{bf:Expedited}" "No Bribe" "Expedited"  "'  ///
        5 `" "{bf:Regular Service}" "No Bribe" "Not Expedited"  "' ///
	   6 `" "{bf:Bribe}" "Bribe" "Expedited"  "'  7 `""{bf:Expedited}" "No Bribe" "Expedited"  "'  ///
	   , labsize(vsmall) noticks) ///
       ytitle("") xtitle("") ///
    scheme(s2mono) graphregion(fcolor(white)) ///
    text(0.6 2  "Non-Coethnic Interactions", box size(small) place(c) margin(l+1 t+1 b+1 r+1) just(center) fcolor(white)) ///
    text(0.6 6  "Coethnic Interactions", box size(small) place(c) margin(l+1 t+1 b+1 r+1) just(center) fcolor(white)) 
    restore
	
* Table 2: Coethnicity and corruption outcomes in ESCOM interactions
eststo main1: mlogit outcome  coreg i.ses i.power , base(1) vce(robust) 
eststo main2: mlogit outcome coreg i.ses i.power  $cov, base(1) vce(robust)



*************
* APPENDIX *
*************	

* Statistics in-text

	* Section A.2:  No. of offices, minimum and maximum obs. per confederate, total no. of obs.
	tab eid	
	summ ra_eobs
	
	* Section A.3: Paragraph beginning with "When an ESCOM official interacts..."
	tab outcome
	tab corrupt
	summ bribe_amount
	summ bribe_amount if bribe_asked==1

	* Section A.4: Paragraph beginning with "Confederates coded the ethnicity and region of origin..."
	tab regused_told
	tab region_confidence
	
	* Section C: statistics in the second (n=6) and third (15% of interactions) paragraphs
	bys region_ra ra: tab coreg
	tab region_confidence
	
	* Section D: paragraph beginning "Overall, corruption was much more common..."
	tab bribe_asked
	tab corrupt
	
* Figure B.1 (Statitics): Decision Tree for ESCOM Officials
tab corrupt
tab bribe_asked if corrupt==1
summ bribe_amount if bribe_asked==1
	
* Table B.1: Summary Statistics for ESCOM Context
 summ ses power coreg expedited bribe_asked bribe_amount total $cov

* Figure B.2: Bribe Amounts in ESCOM Context
hist bribe_amount, percent	///
	scheme(s2mono) graphregion(fcolor(white))  ///
	ytitle ("Percent of ESCOM Interactions with Expedited Service", size(small))	
	
* Table B.2:Covariate Balance by Socioeconomic Status Assignment
estpost ttest $cov, by(ses)

* Table B.3:Covariate Balance by Political Connections Assignment
estpost ttest $cov, by(power)

* Table B.2:Covariate Balance by Coethnicity Assignment
estpost ttest $cov, by(coreg)

* Table C.1: Coethnicity and dichotomous indicators of corruption outcomes in ESCOM interactions
eststo corrupt: logit corrupt coreg i.ses i.power  $cov  ,  vce(robust)	
eststo bribe: logit bribe_asked coreg i.ses i.power  $cov ,  vce(robust)

* Table C.2: Coethnicity and corruption outcomes in ESCOM interactions, adjusting for confederate effects
eststo fe: femlogit outcome coreg ses power  $cov , base(1) group(ra) robust
qui gsem (0.outcome <- i.coreg i.ses i.power $cov  RI0[ra]) ///
     (2.outcome <- i.coreg i.ses i.power $cov  RI2[ra]), mlogit vce(robust)
est sto re 
est r re

* Table C.3: Coethnicity and corruption outcomes in ESCOM interactions, accounting for confidence in the coding of ethnicity
eststo noconf1: mlogit outcome i.coreg i.ses i.power $cov if noconf_reg==0, base(1) vce(robust)  
eststo noconf2: mlogit outcome i.coreg##i.noconf_reg i.ses i.power $cov , base(1) vce(robust) 
	
* Table C.4: Coethnicity and corruption outcomes in ESCOM interactions, using randomized inference to approximate exact p-values	
preserve
do ESCOMri_SR.do
restore	
	
* Table C.5: Coethnicity and corruption outcomes in ESCOM interactions, generalized maximum entropy model	
eststo gmlogit1: gmemultinomial outcome ses power coreg , base(1) 
eststo gmlogit2: gmemultinomial outcome ses power coreg $cov , base(1) 	
	
* Table Table C.6 (see R code in ESCOMbayesian_SR.R) 

* Figures C.1-C.4 (see R code in ESCOMbayesian_SR.R) 

* Table F.1: Results of Pre-Specified Analyses in ESCOM Context
global cov numofficials superior_official	
eststo bribepaid_e: qui reg bribe_asked ses power coreg $cov
eststo bribeamount_e: qui reg bribe_amount ses power coreg $cov
eststo expedited_e: qui reg expedited ses power coreg $cov

	*H14(b): Matched ethnicity will increase the likelihood of soliciting a bribe.
	ttest bribe_asked, by(coreg)
    est r bribepaid_e
	ttest bribe_asked, by(coeth)
	reg bribe_asked ses power coeth $cov
	
	*H15: Matched ethnicity will decrease the amount of the bribe solicited.
	ttest bribe_amount, by(coreg)
	est r bribeamount_e
	ttest bribe_amount, by(coeth)
	reg bribe_amount ses power coeth $cov
	
	*H16: Matched ethnicity will have no effect on the likelihood that expedited ///
	      *service is offered without a bribe.
	ttest expedited, by(coreg)
	est r expedited_e
	ttest expedited, by(coeth)
	reg expedited ses power coeth $cov

	*H17: Political connections will decrease the likelihood of soliciting a bribe.
	ttest bribe_asked, by(power)
	est r bribepaid_e 
	
	*H18: Political connections will decrease the amount of the bribe solicited.
	ttest bribe_amount, by(power)
	est r bribeamount_e

	*H19: Political connections will increase the likelihood that expedited service /// 
	     *is offered without a bribe.
	ttest expedited, by(power)	
	est r expedited_e
	
	*H20: High SES will increase the likelihood of soliciting a bribe.
	ttest bribe_asked, by(ses)
	est r bribepaid_e 

	*H21: High SES will increase the amount of the bribe solicited.
	ttest bribe_amount, by(ses)
	est r bribeamount_e

	*H22: High SES will decrease the likelihood that expedited service is offered /// 
		  *without a bribe.
	ttest expedited, by(ses)
	est r expedited_e
	

* Close log and convert log file
*log close
*translate ESCOMlog_SR.smcl ESCOMlog_SR.pdf, replace
	
	
	
	
