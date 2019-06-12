*******************************************************************************
*** Description: 	This document provides code for reproducing the 		***
***					figures of the paper, "Elections Activate Partisanship 	***
***					Across Countries,Ó which is authored by Shane P. Singh 	***
***					and Judd R. Thornton and appears in the American 		***
***					Political Science Review.	 							***
***					It also provides the code for reproducing the tables 	***
***					and figures in the appendix.							***
*******************************************************************************


**************
**************
*Set the Version and Install Any Needed User-Written Commands                                                                                                                                  
**************
**************
version 13.1
ssc install coefplot //*Install the coefplot command for "plotting regression coefficients and other results," authored by Ben Jann
ssc install labmask //*Install the labmask command for assigning "values or value labels of one variable as value labels to another," authored by Nicholas J. Cox
ssc install eclplot //*Install the eclplot command for creating plots of estimates with lower and upper bounds, authored by Roger Newson


**************
**************
*Set Working Folder to Where the Data Are Stored and Where the Figures Will Be Saved                                                                                                                         
**************
**************
cd "/Users/singh/Desktop/singh_thornton_APSR_replication/" //*edit this to align with your directory structure



**************
**************
*Open the Comparative Study of Electoral Systems (CSES) data, which also contains measures from the World Bank and Polity IV                                                                                                                         
**************
**************
use "singh_thornton_APSR_replication.dta", clear
	
	
	
**************
**************
*Figure 1                                                                                                                     
**************
**************
melogit partyID ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
coefplot, ///
	scheme(s1mono) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Probability of Having Partisan Attachment") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	ylabel(.35(.05).65) ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure 1.gph", replace)
	
	
	
**************
**************
*Support claim from text: "One who is interviewed the day after the election, for example, holds a partisan attachment with a predicted probability of 0.57, while, for someone who is interviewed 150 days after the election, the predicted probability is 0.43."                                                                                                                  
**************
**************
melogit partyID ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0 5.0106353)) predict(mu fixedonly)  //* get predicted values for 1 (e^0) and 150 (e^5.0106353) days after election



**************
**************
*Figure 2                                                                                                                     
**************
**************
meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1) fixedonly) post 
estimates store outcome1

meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2) fixedonly) post 
estimates store outcome2

meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3) fixedonly) post 
estimates store outcome3

coefplot ///
	(outcome1, recast(line) lwidth(*1) lcolor(red) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(red*.7))) ///
	(outcome2, recast(line) lwidth(*1) lcolor(black) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7))) ///
	(outcome3, recast(line) lwidth(*1) lcolor(blue) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(blue*.7))) ///
	,	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview", size(small))	///
	ytitle("Probability", size(small)) ylabel( , labsize(small)) ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400", labsize(small)) ///
	legend(order(2 "Weak Attachment" 4 "Moderate Attachment" 6 "Strong Attachment") rows(3) size(small)) ///
	saving("Figure 2.gph", replace)
	
	
	

**************
**************
*Figure 3                                                                                                                     
**************
**************	
mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, mle
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post
coefplot, ///
	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Marginal Effect of Copartisanship with Incumbent Party" "on Evaluations of Incumbent Party") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	ylabel(3(.5)5)   ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure 3.gph", replace)	
	
	
	
	
**************
**************
*Support claim from text: "[A]bout 84 percent of the respondents in our sample were interviewed solely by telephone or in person. For the other 16 percent, interviews were either done entirely by mail or conducted by mail in conjunction with a telephone or face-to-face interview."                                                                                                            
**************
**************	
tab phone_f2f if election_samp == 1 


	
**************
**************
*Figure A.1                                                                                                                      
**************
**************		
preserve

keep	A1016 A1017 A1018 ///
		B1016 B1017 B1018 ///
		C1016 C1017 C1018 ///
		A1026 A1027 A1028 ///
		B1026 B1027 B1028 ///
		C1026 C1027 C1028 ///
		country* cntry*  ///
		electiondate surveydate time_since_election election_samp

drop if electiondate == .
drop if surveydate == .
drop if time_since_election == .
drop if election_samp == .
		
bysort cntryyear: egen start_date = min(surveydate)
bysort cntryyear: egen end_date = max(surveydate)

format electiondate surveydate start_date end_date %td

collapse electiondate surveydate time_since_election start_date end_date election_samp, by(countryandyear_nohyphen)

rename surveydate mean_survey_date 
rename time_since_election mean_time_since_election

gen time_to_start = start_date - electiondate
gen time_to_end = end_date - electiondate

sort mean_time_since_election
egen order = rank(mean_time_since_election)

labmask order, val(countryandyear_nohyphen)

eclplot mean_time_since_election time_to_start time_to_end  order ///
	, estopts(msize(medsmall) mcolor(black)) ///
	  rplottype(rcap) ciopts(lcolor(black)) ///
	  ytitle("") ylabel(,grid) ///
	  xtitle("Days from Election Until Interview" "(Minimum, Mean, and Maximum)", size(large))   ///
	  horiz scheme(s1mono) xsize(3)  scale(.425) ylabel(1(1)86) ///
	  saving("Figure A1.gph", replace)	

restore
	
	
	
**************
**************
*Figure B.1                                                                                                                      
**************
**************	
melogit partyID ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election
predict re_*, reses(se_*)  remeans
gen predicted_slope = re_1 + _b[ln_time_since_election] //*add the estimated mean slope to the random effects to get country-year specific slopes

preserve
collapse predicted_slope se_1 re_1, by(countryandyear_nohyphen)
sum predicted_slope re_1
sort predicted_slope
egen order = rank(predicted_slope)
labmask order, val(countryandyear_nohyphen)
gen min95 = predicted_slope-(1.96*se_1)
gen max95 = predicted_slope+(1.96*se_1)

eclplot predicted_slope min95 max95  order ///
	, estopts(msize(medsmall) mcolor(black)) ///
	  rplottype(rcap) ciopts(lcolor(black)) ///
	  xline(0, lcolor(black*.8) lpattern(shortdash)) ytitle("") ylabel(,grid) ///
	  xtitle("Predicted Effect of Days From Election Until Interview (logged)" "on Latent Propensity to Have a Partisan Attachment", size(large))   ///
	  horiz scheme(s1mono) ysize(10) scale(.55) ylabel(1(1)86) 	///
	  saving("Figure B1.gph", replace)
	  
restore
	  
drop se_1 se_2 re_1 re_2 predicted_slope
		
	
	
**************
**************
*Figure B.2                                                                                                                    
**************
**************	
meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election 
predict re_*, reses(se_*)  remeans
gen predicted_slope = re_1 +  _b[ln_time_since_election] //*add the estimated mean slope to the random effects to get country-year specific slopes

preserve
collapse predicted_slope se_1, by(countryandyear_nohyphen)
sort predicted_slope
egen order = rank(predicted_slope)
labmask order, val(countryandyear_nohyphen)
gen min95 = predicted_slope-(1.96*se_1)
gen max95 = predicted_slope+(1.96*se_1)

eclplot predicted_slope min95 max95  order ///
	, estopts(msize(medsmall) mcolor(black)) ///
	  rplottype(rcap) ciopts(lcolor(black)) ///
	  xline(0, lcolor(black*.8) lpattern(shortdash)) ytitle("") ylabel(,grid) ///
	  xtitle("Predicted Effect of Days From Election Until Interview (logged)" "on Latent Strength of Partisan Attachment", size(large))   ///
	  horiz scheme(s1mono) ysize(10) scale(.55) ylabel(1(1)86) ///
	  saving("Figure B2.gph", replace)
	  
restore
	
drop se_1 se_2 re_1 re_2 predicted_slope
		
	
	
**************
**************
*Figure B.3                                                                                                                   
**************
**************	
estimates esample: election_samp partyID_inc eval_inc ln_time_since_election, replace
sum ln_time_since_election if e(sample)
gen ln_time_since_election_zero_mean =  ln_time_since_election-r(mean) //*do this and preceding two lines so can easily get the effect of copartisanship at the mean of ln_time_since_election
mixed eval_inc i.partyID_inc##c.ln_time_since_election_zero_mean if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, mle
predict re_*, reffects relevel(cntryyearnum)  
predict se_*, reses relevel(cntryyearnum)  

gen predicted_slope = re_1  + _b[eval_inc:1.partyID_inc]  //*add the estimated mean slope to the random effects to get country-year specific slopes 

preserve
collapse predicted_slope se_1, by(countryandyear_nohyphen)
sort predicted_slope
egen order = rank(predicted_slope)
labmask order, val(countryandyear_nohyphen)
gen min95 = predicted_slope-(1.96*se_1)
gen max95 = predicted_slope+(1.96*se_1)

eclplot predicted_slope min95 max95  order ///
	, estopts(msize(medsmall) mcolor(black)) ///
	  rplottype(rcap) ciopts(lcolor(black)) ///
	  ytitle("") ylabel(,grid) ///
	  xtitle("Pred. Effect of Copartisanship with the Inc. Party on Evals. of the" "Inc. Party at Mean of Days From Elec. Until Interview (logged)", size(large))   ///
	  horiz scheme(s1mono) ysize(10) scale(.55) ylabel(1(1)86) 	///
	  saving("Figure B3.gph", replace)

restore	  

drop re_1-se_3 predicted_slope ln_time_since_election_zero_mean



**************
**************
*Figure B.4                                                                                                                 
**************
**************	
mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, mle
predict re_*, reffects relevel(cntryyearnum)  
predict se_*, reses relevel(cntryyearnum)  

gen predicted_slope = re_2  + _b[eval_inc:ln_time_since_election]   //*add the estimated mean slope to the random effects to get country-year specific slopes


preserve
collapse predicted_slope se_2, by(countryandyear_nohyphen)
sort predicted_slope
egen order = rank(predicted_slope)
labmask order, val(countryandyear_nohyphen)
gen min95 = predicted_slope-(1.96*se_2)
gen max95 = predicted_slope+(1.96*se_2)

eclplot predicted_slope min95 max95  order ///
	, estopts(msize(medsmall) mcolor(black)) ///
	  rplottype(rcap) ciopts(lcolor(black)) ///
	  ytitle("") ylabel(,grid) ///
	  xline(0, lcolor(black*.8) lpattern(shortdash)) ytitle("") ylabel(,grid) ///
	  xtitle("Pred. Effect of Days From Elec. Until Interview (logged) on Evals." "of the Inc. Party for Those Who Do Not Identify with the Inc. Party", size(large))   ///
	  horiz scheme(s1mono) ysize(10) scale(.55) ylabel(1(1)86) 	///
	  saving("Figure B4.gph", replace)

restore
	  
drop re_1-se_3 predicted_slope 
	

**************
**************
*Columns 2-5 of Table C.1                                                                                                               
**************
**************	
*Column 2 ("Main Estimation")
melogit partyID ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election 
estat ic

*Column 3 ("BHHH Algorithm")
melogit partyID ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election, technique(bhhh) 
estat ic

*Column 4 ("DFP Algorithm")
melogit partyID ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election, technique(dfp)  intpoints(11) difficult //*need 11 integration points and "difficult" option to achieve convergence
estat ic

*Column 5 ("BFGS Algorithm")
melogit partyID ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election, technique(bfgs) 
estat ic



**************
**************
*Columns 2-5 of Table C.2                                                                                                               
**************
**************	
*Column 2 ("Main Estimation")
meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election 
estat ic

*Column 3 ("BHHH Algorithm")
meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election, technique(bhhh)  intpoints(14) //*need 14 integration points to achieve convergence
estat ic

*Column 4 ("DFP Algorithm")
meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election, technique(dfp) intpoints(15) //*need 15 integration points to achieve convergence
estat ic

*Column 5 ("BFGS Algorithm")
meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election, technique(bfgs) 
estat ic



**************
**************
*Columns 2-4 of Table C.3                                                                                                               
**************
**************	
*Column 2 ("Main Estimation")
mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, mle
estat ic

*Column 3 ("DFP Algorithm")
mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, mle technique(dfp) 
estat ic

*Column 4 ("BFGS Algorithm")
mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, mle technique(bfgs) 
estat ic



**************
**************
*Figure D.1                                                                                                                
**************
**************	
mixed ln_time_since_election income educ age_10 urban voted polity GDPpercapita_PPP if election_samp == 1 || cntryyearnum: income educ age_10 urban voted
margins, dydx(*) post
margins, coeflegend
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash)) ///
	xtitle("Effect of Covariate on Predicted Days From Election Until Interview (logged)")	///
	recast(scatter) mcolor(black) msize(small) xsize(7)   ///
	ciopts(recast(rcap) lpattern(solid) lcolor(black)) ///
	coeflabel(coeflist ///
	income = "Income Quintile" ///	
	educ = "College Education" ///
	age_10 = "Age (Tens of Years)" ///
	urban = "City Size" /// 
	voted = "Electoral Participation" /// 
	polity = "Democratic Development" ///
	GDPpercapita_PPP = "Economic Development" ///
	) ///
	saving("Figure D1.gph", replace)
	
	
	
	
**************
**************
*Figure D.2                                                                                                                
**************
**************	
melogit partyID ln_time_since_election income educ age_10 urban voted polity GDPpercapita_PPP if election_samp == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
coefplot, ///
	scheme(s1mono) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Probability of Having Partisan Attachment") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	ylabel(.35(.05).65)   ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure D2.gph", replace)



**************
**************
*Figure D.3                                                                                                                
**************
**************	
meologit partyID_strength ln_time_since_election income educ age_10 urban voted polity GDPpercapita_PPP if election_samp == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1) fixedonly) post 
estimates store outcome1

meologit partyID_strength ln_time_since_election income educ age_10 urban voted polity GDPpercapita_PPP if election_samp == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2) fixedonly) post 
estimates store outcome2

meologit partyID_strength ln_time_since_election income educ age_10 urban voted polity GDPpercapita_PPP if election_samp == 1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3) fixedonly) post 
estimates store outcome3

coefplot ///
	(outcome1, recast(line) lwidth(*1) lcolor(red) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(red*.7))) ///
	(outcome2, recast(line) lwidth(*1) lcolor(black) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7))) ///
	(outcome3, recast(line) lwidth(*1) lcolor(blue) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(blue*.7))) ///
	,	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview", size(small))	///
	ytitle("Probability", size(small)) ylabel( , labsize(small)) ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400", labsize(small)) ///
	legend(order(2 "Weak Attachment" 4 "Moderate Attachment" 6 "Strong Attachment") rows(3) size(small)) ///
	saving("Figure D3.gph", replace)

	

**************
**************
*Figure D.4                                                                                                                
**************
**************		
mixed eval_inc i.partyID_inc##c.ln_time_since_election income educ age_10 urban voted polity GDPpercapita_PPP if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, 
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post
coefplot, ///
	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Marginal Effect of Copartisanship with Incumbent Party" "on Evaluations of Incumbent Party") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	ylabel(3(.5)5)   ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7))	///
	saving("Figure D4.gph", replace)
	
	
	

**************
**************
*Figure E.1                                                                                                                
**************
**************		
*restrict sample to those interviewed by phone or face-to-face
gen election_samp_ph_f2f_only = election_samp
replace election_samp_ph_f2f_only = . if phone_f2f ~= 1

melogit partyID ln_time_since_election if election_samp_ph_f2f_only == 1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
coefplot, ///
	scheme(s1mono) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Probability of Having Partisan Attachment") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///			
	ylabel(.35(.05).65) ///
	yscale(range(.35 .65)) ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure E1.gph", replace)

drop election_samp_ph_f2f_only




**************
**************
*Figure E.2                                                                                                               
**************
**************		
*restrict sample to those interviewed by phone or face-to-face
gen election_samp_ph_f2f_only = election_samp
replace election_samp_ph_f2f_only = . if phone_f2f ~= 1

meologit partyID_strength ln_time_since_election if election_samp_ph_f2f_only == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1) fixedonly) post 
estimates store outcome1

meologit partyID_strength ln_time_since_election if election_samp_ph_f2f_only == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2) fixedonly) post 
estimates store outcome2

meologit partyID_strength ln_time_since_election if election_samp_ph_f2f_only == 1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3) fixedonly) post 
estimates store outcome3

coefplot ///
	(outcome1, recast(line) lwidth(*1) lcolor(red) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(red*.7))) ///
	(outcome2, recast(line) lwidth(*1) lcolor(black) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7))) ///
	(outcome3, recast(line) lwidth(*1) lcolor(blue) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(blue*.7))) ///
	,	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview", size(small))	///
	ytitle("Probability", size(small)) ylabel( , labsize(small)) ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400", labsize(small)) ///
	legend(order(2 "Weak Attachment" 4 "Moderate Attachment" 6 "Strong Attachment") rows(3) size(small)) ///
	saving("Figure E2.gph", replace)
	
drop election_samp_ph_f2f_only




**************
**************
*Figure E.3                                                                                                                
**************
**************		
*restrict sample to those interviewed by phone or face-to-face
gen election_samp_ph_f2f_only = election_samp
replace election_samp_ph_f2f_only = . if phone_f2f ~= 1

mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp_ph_f2f_only == 1 || cntryyearnum: partyID_inc ln_time_since_election 
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post
coefplot, ///
	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Marginal Effect of Copartisanship with Incumbent Party" "on Evaluations of Incumbent Party") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	ylabel(3(.5)5)   ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure E3.gph", replace)

drop election_samp_ph_f2f_only




**************
**************
*Figure F.1                                                                                                                
**************
**************
melogit placed_self  ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
coefplot, ///
	scheme(s1mono) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Probability of Providing Ideological Self-Placement") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7))	///
	saving("Figure F1.gph", replace)
	
	
	
**************
**************
*Figure F.2                                                                                                               
**************
**************
melogit placed_top2  ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
coefplot, ///
	scheme(s1mono) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Probability of Providing Ideological Placement" "for Top Two Parties") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure F2.gph", replace)





**************
**************
*Figure G.2                                                                                                               
**************
**************
gen elecs_within_two_years = 0
replace elecs_within_two_years = 1 if countryandyear_nohyphen == ///
"Canada 2004" | countryandyear_nohyphen == /// 
"Czech Republic 1996" | countryandyear_nohyphen == ///  
"Japan 2007" | countryandyear_nohyphen == ///  
"Netherlands 2002" | countryandyear_nohyphen == ///  
"Poland 2005" | countryandyear_nohyphen == ///  
"Slovakia 2010" | countryandyear_nohyphen == ///  
"Taiwan 2001" | countryandyear_nohyphen == ///  
"United States 1996" | countryandyear_nohyphen == ///  
"United States 2004" | countryandyear_nohyphen == /// 
"United States 2008"

gen elecs_USA = 0
replace elecs_USA = 1 if country == ///
"United States"

gen elecs_NED2002 = 0
replace elecs_NED2002 = 1 if countryandyear_nohyphen == ///
"Netherlands 2002" 

melogit partyID ln_time_since_election if election_samp == 1 & elecs_within_two_years~=1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
estimates store no_elecs_within_two_years

melogit partyID ln_time_since_election if election_samp == 1 & elecs_USA~=1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
estimates store no_elecs_USA

melogit partyID ln_time_since_election if election_samp == 1 & elecs_NED2002~=1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
estimates store no_elecs_NED2002

melogit partyID ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
estimates store withall

coefplot  	(no_elecs_within_two_years, recast(line) lwidth(*1.5) lcolor(blue) lpattern(solid) ciopts(color(blue*.7) recast(rline) lwidth(thin) lpattern(dash))) /// 
			(no_elecs_USA, recast(line) lwidth(*1.5) lcolor(green) lpattern(solid) ciopts(color(green*.7) recast(rline) lwidth(thin) lpattern(dash))) ///  
			(no_elecs_NED2002, recast(line) lwidth(*1.5) lcolor(red) lpattern(solid) ciopts(color(red*.7) recast(rline) lwidth(thin) lpattern(dash))) ///
			(withall, recast(line) lwidth(*1.5) lcolor(black) lpattern(solid) ciopts(color(black*.7) recast(rline) lwidth(thin) lpattern(dash))), ///
 			scheme(s1mono) grid(none) vertical aspect(1) scale(.9) ///
			xtitle("Days From Election Until Interview")	///
			ytitle("Probability of Having Partisan Attachment") ///
			xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400")  ///
			ylabel(.35(.05).65) ///
			yscale(range(.35 .65)) ///
			legend(order(2 "w/o Surveys w/ Election in Two Years" 4 "w/o Surveys from USA" 6 "w/o Netherlands 2002 Survey" 8 "All Surveys") rows(4) size(vsmall)) ///
			xscale(range(-1 50)) addplot(pci	  .60 .95 .55 .95   /// 
												  .45 49.20 .38 49.20 ///
			, lwidth(vthick) lcolor(white)) ///
			saving("Figure G2.gph", replace)

			
drop elecs_within_two_years	elecs_USA elecs_NED2002
			

			
**************
**************
*Figure G.3                                                                                                               
**************
**************
gen elecs_within_two_years = 0
replace elecs_within_two_years = 1 if countryandyear_nohyphen == ///
"Canada 2004" | countryandyear_nohyphen == /// 
"Czech Republic 1996" | countryandyear_nohyphen == ///  
"Japan 2007" | countryandyear_nohyphen == ///  
"Netherlands 2002" | countryandyear_nohyphen == ///  
"Poland 2005" | countryandyear_nohyphen == ///  
"Slovakia 2010" | countryandyear_nohyphen == ///  
"Taiwan 2001" | countryandyear_nohyphen == ///  
"United States 1996" | countryandyear_nohyphen == ///  
"United States 2004" | countryandyear_nohyphen == /// 
"United States 2008"

gen elecs_USA = 0
replace elecs_USA = 1 if country == ///
"United States"

gen elecs_NED2002 = 0
replace elecs_NED2002 = 1 if countryandyear_nohyphen == ///
"Netherlands 2002" 


meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_within_two_years~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1) fixedonly) post 
estimates store outcome1_no_elecs_2_years

meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_within_two_years~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2) fixedonly) post 
estimates store outcome2_no_elecs_2_years

meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_within_two_years~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3) fixedonly) post 
estimates store outcome3_no_elecs_2_years


meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_USA~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1) fixedonly) post 
estimates store outcome1_no_elecs_USA

meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_USA~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2) fixedonly) post 
estimates store outcome2_no_elecs_USA

meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_USA~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3) fixedonly) post 
estimates store outcome3_no_elecs_USA

	
meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_NED2002~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1) fixedonly) post 
estimates store outcome1_no_elecs_NED2002

meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_NED2002~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2) fixedonly) post 
estimates store outcome2_no_elecs_NED2002

meologit partyID_strength ln_time_since_election if election_samp == 1 & elecs_NED2002~=1 || cntryyearnum: ln_time_since_election, 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3) fixedonly) post 
estimates store outcome3_no_elecs_NED2002


meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1) fixedonly) post 
estimates store outcome1withall

meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2) fixedonly) post 
estimates store outcome2withall

meologit partyID_strength ln_time_since_election if election_samp == 1 || cntryyearnum: ln_time_since_election
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3) fixedonly) post 
estimates store outcome3withall
	

coefplot  	(outcome1_no_elecs_2_years, recast(line) lwidth(*1.5) lcolor(blue) lpattern(solid) ciopts(color(blue*.7) recast(rline) lwidth(thin) lpattern(dash))) /// 
			(outcome1_no_elecs_USA, recast(line) lwidth(*1.5) lcolor(green) lpattern(solid) ciopts(color(green*.7) recast(rline) lwidth(thin) lpattern(dash))) ///  
			(outcome1_no_elecs_NED2002, recast(line) lwidth(*1.5) lcolor(red) lpattern(solid) ciopts(color(red*.7) recast(rline) lwidth(thin) lpattern(dash))) ///
			(outcome1withall, recast(line) lwidth(*1.5) lcolor(black) lpattern(solid) ciopts(color(black*.7) recast(rline) lwidth(thin) lpattern(dash))), ///
		scheme(s1color) grid(none) vertical aspect(1) ///
		xtitle("Days From Election Until Interview", size(small))	///
		ytitle("Probability", size(small)) ylabel( , labsize(small)) ///
		title("Weak Attachment", size(medsmall)) ///
		xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400", labsize(small)) ///
			legend(order(2 "w/o Surveys w/ Election in Two Years" 4 "w/o Surveys from USA" 6 "w/o Netherlands 2002 Survey" 8 "All Surveys") rows(4) size(tiny)) ///
		xscale(range(-1 50)) addplot(pci	.60 .95 .10 .95   /// 
											.60 48.95 .10 48.95 ///
			, lwidth(vthick) lcolor(white)) ///
		name(weak, replace)	

		
coefplot  	(outcome2_no_elecs_2_years, recast(line) lwidth(*1.5) lcolor(blue) lpattern(solid) ciopts(color(blue*.7) recast(rline) lwidth(thin) lpattern(dash))) /// 
			(outcome2_no_elecs_USA, recast(line) lwidth(*1.5) lcolor(green) lpattern(solid) ciopts(color(green*.7) recast(rline) lwidth(thin) lpattern(dash))) ///  
			(outcome2_no_elecs_NED2002, recast(line) lwidth(*1.5) lcolor(red) lpattern(solid) ciopts(color(red*.7) recast(rline) lwidth(thin) lpattern(dash))) ///
			(outcome2withall, recast(line) lwidth(*1.5) lcolor(black) lpattern(solid) ciopts(color(black*.7) recast(rline) lwidth(thin) lpattern(dash))), ///
		scheme(s1color) grid(none) vertical aspect(1)  ///
		xtitle("Days From Election Until Interview", size(small))	///
		ytitle("Probability", size(small)) ylabel( , labsize(small)) ///
		title("Moderate Attachment", size(medsmall)) ///
		xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400", labsize(small)) ///
			legend(order(2 "w/o Surveys w/ Election in Two Years" 4 "w/o Surveys from USA" 6 "w/o Netherlands 2002 Survey" 8 "All Surveys") rows(4) size(tiny)) ///
		xscale(range(-1 50)) addplot(pci	.60 .95 .10 .95   /// 
											.60 48.95 .10 48.95 ///
			, lwidth(vthick) lcolor(white)) ///
		name(moderate, replace)	
	

coefplot  	(outcome3_no_elecs_2_years, recast(line) lwidth(*1.5) lcolor(blue) lpattern(solid) ciopts(color(blue*.7) recast(rline) lwidth(thin) lpattern(dash))) /// 
			(outcome3_no_elecs_USA, recast(line) lwidth(*1.5) lcolor(green) lpattern(solid) ciopts(color(green*.7) recast(rline) lwidth(thin) lpattern(dash))) ///  
			(outcome3_no_elecs_NED2002, recast(line) lwidth(*1.5) lcolor(red) lpattern(solid) ciopts(color(red*.7) recast(rline) lwidth(thin) lpattern(dash))) ///
			(outcome3withall, recast(line) lwidth(*1.5) lcolor(black) lpattern(solid) ciopts(color(black*.7) recast(rline) lwidth(thin) lpattern(dash))), ///
		scheme(s1color) grid(none) vertical aspect(1)  ///
		xtitle("Days From Election Until Interview", size(small))	///
		ytitle("Probability", size(small)) ylabel( , labsize(small)) ///
		title("Strong Attachment", size(medsmall)) ///
		xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400", labsize(small)) ///3
			legend(order(2 "w/o Surveys w/ Election in Two Years" 4 "w/o Surveys from USA" 6 "w/o Netherlands 2002 Survey" 8 "All Surveys") rows(4) size(tiny)) ///
		xscale(range(-1 50)) addplot(pci	.60 .95 .10 .95   /// 
											.60 48.95 .10 48.95 ///
			, lwidth(vthick) lcolor(white)) ///
		name(strong, replace)	
	
	
grc1leg weak moderate strong ///
	, rows(1) xcommon ycommon  graphregion(margin(zero)) scheme(s1mono)  iscale(.71)   
gr_edit .legend.yoffset = 11
gr_edit .legend.xoffset = 3

graph save "Figure G3", replace

drop elecs_within_two_years	elecs_USA elecs_NED2002
			
	
	
**************
**************
*Figure G.4                                                                                                               
**************
**************	
gen elecs_within_two_years = 0
replace elecs_within_two_years = 1 if countryandyear_nohyphen == ///
"Canada 2004" | countryandyear_nohyphen == /// 
"Czech Republic 1996" | countryandyear_nohyphen == ///  
"Japan 2007" | countryandyear_nohyphen == ///  
"Netherlands 2002" | countryandyear_nohyphen == ///  
"Poland 2005" | countryandyear_nohyphen == ///  
"Slovakia 2010" | countryandyear_nohyphen == ///  
"Taiwan 2001" | countryandyear_nohyphen == ///  
"United States 1996" | countryandyear_nohyphen == ///  
"United States 2004" | countryandyear_nohyphen == /// 
"United States 2008"

gen elecs_USA = 0
replace elecs_USA = 1 if country == ///
"United States"

gen elecs_NED2002 = 0
replace elecs_NED2002 = 1 if countryandyear_nohyphen == ///
"Netherlands 2002" 


mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 & elecs_within_two_years~=1 || cntryyearnum: partyID_inc ln_time_since_election, mle
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post
estimates store no_elecs_within_two_years

mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 & elecs_USA~=1 || cntryyearnum: partyID_inc ln_time_since_election, mle
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post
estimates store no_elecs_USA

mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 & elecs_NED2002~=1 || cntryyearnum: partyID_inc ln_time_since_election, mle
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post
estimates store no_elecs_NED2002

mixed eval_inc i.partyID_inc##c.ln_time_since_election if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, mle
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post
estimates store withall


coefplot  	(no_elecs_within_two_years, recast(line) lwidth(*1.5) lcolor(blue) lpattern(solid) ciopts(color(blue*.7) recast(rline) lwidth(thin) lpattern(dash))) /// 
			(no_elecs_USA, recast(line) lwidth(*1.5) lcolor(green) lpattern(solid) ciopts(color(green*.7) recast(rline) lwidth(thin) lpattern(dash))) ///  
			(no_elecs_NED2002, recast(line) lwidth(*1.5) lcolor(red) lpattern(solid) ciopts(color(red*.7) recast(rline) lwidth(thin) lpattern(dash))) ///
			(withall, recast(line) lwidth(*1.5) lcolor(black) lpattern(solid) ciopts(color(black*.7) recast(rline) lwidth(thin) lpattern(dash))), ///
 			scheme(s1mono) grid(none) vertical aspect(1) scale(.9) ///
			xtitle("Days From Election Until Interview")	///
			ytitle("Marg. Effect of Copartisanship with Inc. Party" "on Evaluations of Incumbent Party") ///
			xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400")  ///
			ylabel(3(.5)5)   ///
			legend(order(2 "w/o Surveys w/ Election in Two Years" 4 "w/o Surveys from USA" 6 "w/o Netherlands 2002 Survey" 8 "All Surveys") rows(4) size(vsmall)) ///
			xscale(range(-1 50)) addplot(pci	  3.0 .95 4.5 .95   /// 
												  3.0 49.20 4.5 49.20 ///
			, lwidth(vthick) lcolor(white)) ///
			saving("Figure G4.gph", replace)
				
		
drop elecs_within_two_years elecs_USA  elecs_NED2002
	
	
	
			
**************
**************
*Figure H.1                                                                                                              
**************
**************		
melogit partyID ln_time_since_election  if election_samp == 1 || cntryyearnum: ln_time_since_election, cov(unstructured)
margins, at(ln_time_since_election = (0(.125)6)) predict(mu fixedonly) post 
coefplot, ///
	scheme(s1mono) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Probability of Having Partisan Attachment") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	ylabel(.35(.05).65) ///
	yscale(range(.35 .65)) ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure H1.gph", replace)
			
	
	
**************
**************
*Figure H.2                                                                                                            
**************
**************	
meologit partyID_strength ln_time_since_election  if election_samp == 1 || cntryyearnum: ln_time_since_election, cov(unstructured)
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1) fixedonly) post 
estimates store outcome1

meologit partyID_strength ln_time_since_election  if election_samp == 1 || cntryyearnum: ln_time_since_election, cov(unstructured)
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2) fixedonly) post 
estimates store outcome2

meologit partyID_strength ln_time_since_election  if election_samp == 1 || cntryyearnum: ln_time_since_election, cov(unstructured)
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3) fixedonly) post 
estimates store outcome3

coefplot ///
	(outcome1, recast(line) lwidth(*1) lcolor(red) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(red*.7))) ///
	(outcome2, recast(line) lwidth(*1) lcolor(black) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7))) ///
	(outcome3, recast(line) lwidth(*1) lcolor(blue) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(blue*.7))) ///
	,	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview", size(small))	///
	ytitle("Probability", size(small)) ylabel( , labsize(small)) ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400", labsize(small)) ///
	legend(order(2 "Weak Attachment" 4 "Moderate Attachment" 6 "Strong Attachment") rows(3) size(small)) ///
	saving("Figure H2.gph", replace)
			
			
			
**************
**************
*Figure H.3                                                                                                            
**************
**************
mixed eval_inc i.partyID_inc##c.ln_time_since_election  if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, cov(unstructured)
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post
coefplot, ///
	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Marginal Effect of Copartisanship with Incumbent Party" "on Evaluations of Incumbent Party") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	ylabel(3(.5)5)   ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure H3.gph", replace)
			


			
**************
**************
*Table H.1                                                                                                              
**************
**************
*the covariance parameters shown in the table are displayed at the bottom of the output for each model
melogit partyID ln_time_since_election  if election_samp == 1 || cntryyearnum: ln_time_since_election, cov(unstructured)

meologit partyID_strength ln_time_since_election  if election_samp == 1 || cntryyearnum: ln_time_since_election, cov(unstructured)

mixed eval_inc i.partyID_inc##c.ln_time_since_election  if  election_samp == 1 || cntryyearnum: partyID_inc ln_time_since_election, cov(unstructured)


	
		
**************
**************
*Figure I.1                                                                                                              
**************
**************	
logit partyID ln_time_since_election i.cntryyearnum if election_samp == 1 
margins, at(ln_time_since_election = (0(.125)6)) predict(pr) post 
coefplot, ///
	scheme(s1mono) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Probability of Having Partisan Attachment") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") ///
	ylabel(.35(.05).65) ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure I1.gph", replace)
					
		
		
**************
**************
*Figure I.2                                                                                                              
**************
**************	
ologit partyID_strength ln_time_since_election i.cntryyearnum if election_samp == 1   
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(1)) post 
estimates store outcome1

ologit partyID_strength ln_time_since_election i.cntryyearnum if election_samp == 1   
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(2)) post 
estimates store outcome2

ologit partyID_strength ln_time_since_election i.cntryyearnum if election_samp == 1 
margins, at(ln_time_since_election = (0(.125)6)) predict(outcome(3)) post 
estimates store outcome3

coefplot ///
	(outcome1, recast(line) lwidth(*1) lcolor(red) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(red*.7))) ///
	(outcome2, recast(line) lwidth(*1) lcolor(black) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7))) ///
	(outcome3, recast(line) lwidth(*1) lcolor(blue) ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(blue*.7))) ///
	,	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview", size(small))	///
	ytitle("Probability", size(small)) ylabel( , labsize(small)) ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400", labsize(small)) ylabel(.1(.1).6, labsize(small)) ///
	legend(order(2 "Weak Attachment" 4 "Moderate Attachment" 6 "Strong Attachment") rows(3) size(small)) ///
	saving("Figure I2.gph", replace)
					
		
**************
**************
*Figure I.3                                                                                                             
**************
**************	
reg eval_inc i.partyID_inc##c.ln_time_since_election i.cntryyearnum if election_samp == 1 
margins, dydx(partyID_inc) at(ln_time_since_election = (0(.125)6)) post

coefplot, ///
	scheme(s1color) grid(none) vertical aspect(1) ///
	xtitle("Days From Election Until Interview")	///
	ytitle("Marginal Effect of Copartisanship with Incumbent Party" "on Evaluations of Incumbent Party") ///
	xlabel(1 "1" 13.8755033 "5" 22.66440161 "15" 32.29618404 "50"  41.08508235 "150" 48.93171638 "400") /// 
	ylabel(3(.5)5) ///
	recast(line) lwidth(*1) lcolor(black) ///
	ciopts(recast(rline) lwidth(vthin)  lpattern(dash) lcolor(black*.7)) ///
	saving("Figure I3.gph", replace)
					
					
					
					
					


************************************************************* 
***************************************************   ******* 
***********************************************   /~\   *****
********************************************   _- `~~~', ****
******************************************  _-~       )  ****
***************************************  _-~          |  ****
************************************  _-~            ;   ****
**************************  __---___-~              |   THANKS FOR REPLICATING!
***********************   _~   ,,                  ;  `,,  **
*********************  _-~    /P'                  |  ,'  ;**
*******************  _~      '                    `~'   ; ***
************   __---;                                 ,' ****
********   __~~  ___                                ,' ******
*****  _-~~   -~~ _                               ,' ********
***** `-_         _                              ; **********
*******  ~~----~~~   ;                          ; ***********
*********  /          ;                        ; ************
*******  /             ;                      ; *************
*****  /                `                    ; **************
***  /                                      ; ***************
*                                            ****************


					
