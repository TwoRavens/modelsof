***********************************************************
** 	Replication Data for: "Changing Attitudes toward   	 **
**	Same-Sex Marriage", Political Behavior				 **
**  Author: Diana C. Mutz, Hye-Yon Lee					 **
**  Date: April 6 2018									 **
**														 **
**  Note. There are two datasets, one in long format, 	 **
**		  and the other in wide format. Main analysis	 **
**		  involving fixed effects uses long-format data, **
**		  but other analysis for supplemental materials	 **
**		  uses wide-format data.						 **
***********************************************************

set more off 
use "replication-data_gaymarriagepanel-long.dta", clear
xtset MNO wave

** For Table 1
ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 

gen nobs=e(N)
gen ngroups=e(N_clust)

/* adjusting z-values for person-specific fixed effects */
foreach v in conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_  nonchristian_ noreligion_ freqchurch_  education4_ w2 w3 {
	gen z_`v' = _b[`v']/_se[`v']
	gen adjz_`v' =  z_`v'/sqrt(nobs/ngroups)
	gen sigz_`v' =. 
	replace sigz_`v'= .05 if abs(adjz_`v') >= 1.96
	replace sigz_`v' = .01 if abs(adjz_`v') >= 2.58 
	replace sigz_`v' = .001 if abs(adjz_`v') >= 3.29
	} 

sum adjz_* //adjusted z-values reported in Table 1
sum sigz_* //significance level (.05, .01, .001)


** For Figure 1 
tab gaym_ wave, col


** For Figure 2-5
quietly ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 

margins, at(gayfriends_=(0 1)) atmeans 				//intergroup contact (figure 2)
margins, at(evangelical_christian_=(0 1)) atmeans   //evangelical christian (figure 3)
margins, at(freqchurch_=(1 6)) atmeans  	//church attendance (figure 4) 
margins, at(education4_=(1/4) atmeans				//education (figure 5)


**Figure 6 and Table E

/* mean change in predictors over time (w1 to w3) */
ttest  conservative7_=conservative7w1  if wave==3
ttest  republican7_=republican7w1 if wave==3
ttest  lgbtyou_ =lgbtyouw1 if wave==3
ttest  gayfriends_=gayfriendsw1 if wave==3 
ttest  freqchurch_=freqchurchw1 if wave==3
ttest  evangelical_christian_=evangelical_christianw1 if wave==3
ttest  education4_=education4w1  if wave==3 

/* computing change in predicted probability of supporting 
   same-sex marriage by mean change in each predictor over time 
   while all others holding constant at w1 means*/
   
*intergroup contact 	
quietly ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 
margins, at(conservative7_=4.179 republican7_=3.757 gayfriends_=(.635 .707) lgbtyou_=.0316 evangelical_christian_=.320 nonchristian_=.0588 noreligion_=.123 freqchurch_=3.310 education4_=2.782 w2=0 w3=0) predict(pr outcome(3)) post
	nlcom (diff: _b[2._at] - _b[1._at]), cformat(%8.3fc)

*frequench of church attendance 
quietly ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 
margins, at(conservative7_=4.179 republican7_=3.757 gayfriends_=.635 lgbtyou_=.0316 evangelical_christian_=.320 nonchristian_=.0588 noreligion_=.123 freqchurch=(3.310 3.179) education4_=2.782 w2=0 w3=0) predict(pr outcome(3)) post 
	nlcom (diff: _b[2._at] - _b[1._at]), cformat(%8.3fc)
	
*evangelical christian 
quietly ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 
margins, at(conservative7_=4.179 republican7_=3.757 gayfriends_=.635 lgbtyou_=.0316 evangelical_christian_=(.320 .306) nonchristian_=.0588 noreligion_=.123 freqchurch_=3.310 education4_=2.782 w2=0 w3=0) predict(pr outcome(3)) post 
	nlcom (diff: _b[2._at] - _b[1._at]), cformat(%8.3fc)

*education 	
quietly ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 
margins, at(conservative7_=4.179 republican7_=3.757 gayfriends_=.635 lgbtyou_=.0316 evangelical_christian_=.320 nonchristian_=.0588 noreligion_=.123 freqchurch_=3.310 education4_=(2.782 2.894) w2=0 w3=0) predict(pr outcome(3)) post 
	nlcom (diff: _b[2._at] - _b[1._at]), cformat(%8.3fc)
	
*ideology
quietly ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 
margins, at(conservative7_=(4.179 4.245) republican7_=3.757 gayfriends_=.635 lgbtyou_=.0316 evangelical_christian_=.320 nonchristian_=.0588 noreligion_=.123 freqchurch_=3.310 education4_=2.782 w2=0 w3=0) predict(pr outcome(3)) post 
	nlcom (diff: _b[2._at] - _b[1._at]), cformat(%8.3fc)
	
*party id
quietly ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 
margins, at(conservative7_=4.179 republican7_=(3.757 3.897) gayfriends_=.635 lgbtyou_=.0316 evangelical_christian_=.320 nonchristian_=.0588 noreligion_=.123 freqchurch_=3.310 education4_=2.782 w2=0 w3=0) predict(pr outcome(3)) post 
	nlcom (diff: _b[2._at] - _b[1._at]), cformat(%8.3fc)

*sexual orientation 
quietly ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3 [pweight=weight_3], vce(cluster MNO) 
margins, at(conservative7_=4.179 republican7_=3.757 gayfriends_=.635 lgbtyou_=(.0316 .0370) evangelical_christian_=.320 nonchristian_=.0588 noreligion_=.123 freqchurch_=3.310 education4_=2.782 w2=0 w3=0) predict(pr outcome(3)) post 
	nlcom (diff: _b[2._at] - _b[1._at]), cformat(%8.3fc)
	

** For Table G (unweighted data) 
ologit gaym_ conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_ nonchristian_ noreligion_ freqchurch_ education4_ w2 w3, vce(cluster MNO) 

gen nobs2=e(N)
gen ngroups2=e(N_clust)

/* adjusting z-values for person-specific fixed effects */
foreach v in conservative7_ republican7_ gayfriends_ lgbtyou_ evangelical_christian_  nonchristian_ noreligion_ freqchurch_  education4_ w2 w3 {
	gen z2_`v' = _b[`v']/_se[`v']
	gen adjz2_`v' =  z2_`v'/sqrt(nobs2/ngroups2)
	gen sigz2_`v' =. 
	replace sigz2_`v'= .05 if abs(adjz2_`v') >= 1.96
	replace sigz2_`v' = .01 if abs(adjz2_`v') >= 2.58 
	replace sigz2_`v' = .001 if abs(adjz2_`v') >= 3.29
	} 

sum adjz2_* //adjusted z-values reported in Table G
sum sigz2_* //significance level (.05, .01, .001)



/*Use wide-format data for below */
use "replication-data_gaymarriagepanelreplication-data_gaymarriagepanel-wide.dta", clear

** For Table C1
egen change_gaym12=diff(gaym_1 gaym_2) if gaym_1!=. & gaym_2!=.
tab change_gaym12
tab gaym_1 gaym_2
di (100+23+174)/1347
di (66+3+20)/1347

egen change_gaym23=diff(gaym_2 gaym_3) if gaym_2!=. & gaym_3!=.
tab change_gaym23
tab gaym_2 gaym_3
di (78+9+45)/1343
di (43+9+34)/1343

** For Table C2
sum conservative7_1-conservative7_3
ttest conservative7_1=conservative7_3
sum republican7_1-republican7_3
ttest republican7_1=republican7_3
sum lgbtyou_1-lgbtyou_3
ttest lgbtyou_1=lgbtyou_3
sum gayfriends_1-gayfriends_3
ttest gayfriends_1=gayfriends_3
sum freqchurch_1-freqchurch_3
ttest freqchurch_1=freqchurch_3
sum evangelical_1-evangelical_3
ttest evangelical_1=evangelical_3
sum noreligion_1-noreligion_3
ttest noreligion_1=noreligion_3
sum education4_1-education4_3
ttest education4_1=education4_3


** For Table D 
gen gaym_12=gaym_1+gaym_2
	
reg conservative7_3 gaym_2 gaym_12
reg republican7_3 gaym_2 gaym_12
logit lgbtyou_3 gaym_2 gaym_12
logit gayfriends_3 gaym_2 gaym_12
reg freqchurch_3 gaym_2 gaym_12
logit evangelical_christian_3 gaym_2 gaym_12
logit noreligion_3 gaym_2 gaym_12
regress education4_3 gaym_2 gaym_12


** For Table F
tab PPGENDER_3
tab ppagecat_3
tab PPETHM_3
tab PPEDUCAT_3
tab PPINCIMP_3

svyset [pweight=weight_3]
svy: tab PPGENDER_3
svy: tab ppagecat_3 
svy: tab PPETHM_3
svy: tab PPEDUCAT_3
svy: tab PPINCIMP_3


** For Table H 
sem ///
(gaym_1 <-  gayfriends_1@a republican7_1@b conservative7_1@c freqchurch_1@e evangelical_christian_1@f nonchristian_1@h noreligion_1@i education4_1@j Alpha E1@1) (gaym_2 <-  gayfriends_2@a republican7_2@b conservative7_2@c freqchurch_2@e evangelical_christian_2@f nonchristian_2@h noreligion_2@i education4_2@j Alpha E2@1) (gaym_3 <-  gayfriends_3@a republican7_3@b conservative7_3@c freqchurch_3@e evangelical_christian_3@f nonchristian_3@h noreligion_3@i education4_3@j Alpha@1), ///
var(e.gaym_1@0 e.gaym_2@0 e.gaym_3@0) cov(E1*(Alpha E2 republican7_* conservative7_* education4_*  gayfriends_1 freqchurch_1 evangelical_christian_1  nonchristian_1 noreligion_1)@0) cov(E2*(Alpha E1 republican7_* conservative7_* education4_*  gayfriends_1 freqchurch_1 evangelical_christian_1  nonchristian_1 noreligion_1 gayfriends_2 freqchurch_2 evangelical_christian_2 nonchristian_2 noreligion_2)@0) 



** Data Cleaning and Recoding (with the original data) 

drop if dt_finish_1==.
drop if tm_finish_2==.
drop if tm_finish_3==.

	**support for same-sex marriage (response var) 
	gen gaym_1=4-POS1_1 if POS1_1>=1
	gen gaym_2=4-POS1_2 if POS1_2>=1
	gen gaym_3=4-POS1_3 if POS1_3>=1
	label define gaymarriage 1"No support" ///
	2"Support civil unions" ///
	3"Support gay marriage" //
	label values gaym_* gaymarriage
		
	**party affiliation
	gen republican7_1=8-XPARTY7_UPDATED_1
	gen republican7_2=8-partyid7_2
	gen republican7_3=8-xParty7_3 if xParty7_3<8

	**political ideology 
	gen conservative7_1=IDEOLOGY_UPDATED_1 if IDEOLOGY_UPDATED_1>0
	gen conservative7_2=ppp10012_2 if ppp10012_2>0
	gen conservative7_3=xIdeo_3 if xIdeo_3 <8

	**education
	gen education4_1=PPEDUCAT_1
	gen education4_2=PPEDUCAT_2
	gen education4_3=PPEDUCAT_3
	
	**intergroup contact
	recode pppa0042_1 (1/3=1) (4=0) (else=.), gen(gayfriends_1)
	recode ppp20064_2 (1=1) (2=0) (else=.), gen(gayfriends_2) 
	recode RE14_3 (0=0) (1=1) (else=.), gen(gayfriends_3) 
	
	**sexual orientation
	recode pppa0043_1 (1=1) (2=0) (else=.), gen(lgbtyou_1)
	recode ppp0043_2 (1=1) (2=0) (else=.), gen(lgbtyou_2)
	recode pppa_lgb_3 (1=1) (2=0) (3=1) (else=.), gen(lgbtyou_3) 
	
	*religion
	clonevar religion_1=pppa0046_1 if pppa0046_1>0
	clonevar religion_2=ppp20070_2 if ppp20070_2>0
	clonevar religion_3=xRel1_3 if xRel1_3 <14
	recode pppa0306_1 (1=1) (2=0) (else=.), gen(evangelical_1)
	recode ppp20071_2 (1=1) (2=0) (else=.), gen(evangelical_2)
	recode ppp20071_3 (1=1) (2=0) (else=.), gen(evangelical_3)

		*no religion
		foreach x in 1 2 3 {
			recode religion_`x' (13=1) (else=0), gen(noreligion_`x')
			}

		*non-christian
		foreach x in 1 2 {
			recode religion_`x' (5 6 7 8 12=1) (else=0), gen(nonchristian_`x')
			}	/* for w1, w2: Jewish(5) Muslim(6) Hindu(7) Buddhist(8) 
				Other Non-Christian(12)	*/
		recode religion_3 (5 6 8 9 10 12=1) (else=0), gen(nonchristian_3)	
		/* for w3: Jewish(5) Muslim(6) Hindu(8) Buddhist(9) Unitarian(10) 
		Other Non-Christian(12)	*/

	foreach x in 1 2 3 {
		replace evangelical_`x'=. if noreligion_`x'==1
		replace evangelical_`x'=. if nonchristian_`x'==1
			}	//question non-applicable for nonchristians and nones
	
		*christian denomination
		foreach x in 1 2 {
			recode religion_`x' (1 2 3 4 9 10 11=1) (else=0), gen(christian_`x') 
			}	/* for w1, w2: Baptist(1) Protestant(2) Catholic(3) Mormon(4) 
				Pentecostal(9) Eastern Orthodox(10) Other Christian(11) */ 
		recode religion_3 (1 2 3 4 7 11=1) (else=0), gen(christian_3)
				/* for w3: Catholic(1) Protestant(2) Jehovah's(3) Mormon(4) 
				Orthodox Church(7) Other Christian religion(11) */

		*evangelical christian: christian denomination + evangelical identification 
		foreach x in 1 2 3 {
			gen evangelical_christian_`x'=0
			replace evangelical_christian_`x'=1 if christian_`x'==1 & evangelical_`x'==1
			}	
		
		*mainline christian: christian denomination + non-evangelical identification 
		foreach x in 1 2 3 {
			gen mainline_christian_`x'=0
			replace mainline_christian_`x'=1 if christian_`x'==1 & evangelical_`x'==0
			}	
			
	*church attendance
	gen freqchurch_1=7-pppa0048_1 if pppa0048_1>0
	gen freqchurch_2=7-ppp20072_2 if ppp20072_2>0
	gen freqchurch_3=7-xRel2_3 if xRel2_3<7
	
	foreach x in 1 2 3 {
		replace freqchurch_`x'=1 if religion_`x'==13
		}	//religious nones' church attendance "never" 
	
	label define freqchurch 1"Never" 2"< Once a year" 3"A few times a year" ///
	4"Once or twice a month" 5"Once a week" 6"> Once a week" 
	label values freqchurch_* freqchurch

gen republican7w1=republican7_1
gen conservative7w1=conservative7_1
gen education4w1=education4_1
gen gayfriendsw1=gayfriends_1
gen lgbtyouw1=lgbtyou_1
gen evangelicalw1=evangelical_1
gen religionw1=religion_1
gen noreligionw1=noreligion_1
gen nonchristianw1=nonchristian_1
gen evangelical_christianw1=evangelical_christian_1
gen mainline_christianw1=mainline_christian_1
gen freqchruchw1=freqchurch_1
	
save "replication-data_gaymarriagepanel-wide.dta", replace

/* converting to long form */ 
reshape long gaym_ republican7_ conservative7_ education4_ gayfriends_ lgbtyou_ evangelical_ noreligion_ nonchristian_ evangelical_christian_ mainline_christian_ freqchurch_ , i(MNO) j(wave)
save "replication-data_gaymarriagepanel-long.dta", replace

