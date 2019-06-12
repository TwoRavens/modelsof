
***************************************
*********** ONLINE APPENDIX ***********
***************************************

************************************
*** ELECTION CYCLE FIXED EFFECTS ***
************************************

********
** US **
********
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

************
* TABLE A5 *
************

*SOTU
xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_, correlation(psar1)
outreg using TabA5, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using TabA5, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided mip_div_ rankcomp_div_ mip_rankcomp_div_, correlation(psar1)
outreg using TabA5, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

xtpcse speechshare_ rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided mip_div_ rankcomp_div_ mip_rankcomp_div_, correlation(psar1)
outreg using TabA5, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 4) merge

************
* TABLE A6 *
************

*LAWS
xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_, correlation(psar1)
outreg using TabA6, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_, correlation(psar1)
outreg using TabA6, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided mip_div_ congrankcomp_div_ mip_congrankcomp_div_, correlation(psar1)
outreg using TabA6, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

xtpcse milawsshare_ rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided mip_div_ congrankcomp_div_ mip_congrankcomp_div_, correlation(psar1)
outreg using TabA6, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 4) merge

********
** UK **
********
use BJPOLS_Data_UK.dta, clear
sort year majortopic
xtset majortopic year

************
* TABLE A7 *
************

*ACTS
xtpcse lawsshare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_, correlation(psar1)
outreg using TabA7, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse lawsshare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using TabA7, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse lawsshare_ rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using TabA7, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

************
* TABLE A8 *
************
use BJPOLS_Data_UK_Pooled.dta, clear
sort year newmajortopic
xtset newmajortopic year

*POOLED
xtpcse agendashare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_, correlation(psar1)
outreg using TabA8, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse agendashare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using TabA8, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse agendashare_ rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using TabA8, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

*************************
*** ROBUSTNESS CHECKS ***
*************************

************
* TABLE A9 *
************
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided mip_div_ rankcomp_div_ mip_rankcomp_div_, correlation(psar1)
outreg using TabA9, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Rank) replace

xtpcse speechshare_ i.pelectioncycle std_gov_lcompetence_ mipshare_int_ mip_stdcomp_ gov_vote vot_stdcomp_ divided mip_div_ stdcomp_div_ mip_stdcomp_div_, correlation(psar1)
outreg using TabA9, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Standardised) merge

xtpcse speechshare_ i.pelectioncycle gov_lead_lcompetence_ mipshare_int_ mip_leadcomp_ gov_vote vot_leadcomp_ divided mip_div_ leadcomp_div_ mip_leadcomp_div_, correlation(psar1)
outreg using TabA9, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Lead) merge

*************
* TABLE A10 *
*************
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided mip_div_ congrankcomp_div_ mip_congrankcomp_div_, correlation(psar1)
outreg using TabA10, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Rank) replace

xtpcse milawsshare_ i.electioncycle std_cong_lcompetence_ mipshare_int_ mip_congstdcomp_ cong_gov_vote vot_congstdcomp_ divided mip_div_ congstdcomp_div_ mip_congstdcomp_div_, correlation(psar1)
outreg using TabA10, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Standardised) merge

xtpcse milawsshare_ i.electioncycle cong_lead_lcompetence_ mipshare_int_ mip_congleadcomp_ cong_gov_vote vot_congleadcomp_ divided mip_div_ congleadcomp_div_ mip_congleadcomp_div_, correlation(psar1)
outreg using TabA10, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Lead) merge

*************
* TABLE A11 *
*************
use BJPOLS_Data_UK.dta, clear
sort year majortopic
xtset majortopic year

xtpcse lawsshare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using TabA11, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Rank) replace

xtpcse lawsshare_ i.electioncycle std_gov_lcompetence_ mipshare_int_ mip_stdcomp_ gov_vote vot_stdcomp_, correlation(psar1)
outreg using TabA11, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Standardised) merge

xtpcse lawsshare_ i.electioncycle gov_lead_lcompetence_ mipshare_int_ mip_leadcomp_ gov_vote vot_leadcomp_, correlation(psar1)
outreg using TabA11, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Lead) merge

*************
* TABLE A12 *
*************
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

*ALTERNATE DIVIDED GOVERNMENT MEASURE - HOUSE OR SENATE
gen divided1=sotuparty-house
replace divided1=divided1*-1 if divided1==-1

gen divided2=sotuparty-senate
replace divided2=divided2*-1 if divided2==-1

gen divided3=0
replace divided3=1 if divided1==1 | divided2==1

gen mip_div3_=mipshare_int_*divided3

* IN-PARTY
gen mip_rankcomp_div3_=mip_rankcomp_*divided3
gen rankcomp_div3_=rank_gov_lcompetence_*divided3

* MAJORITY PARTY
gen mip_congrankcomp_div3_=mip_congrankcomp_*divided3
gen congrankcomp_div3_=rank_cong_lcompetence_*divided3

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided3 mip_div3_ rankcomp_div3_ mip_rankcomp_div3_, correlation(psar1)
outreg using TabA12, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", SOTU) replace

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided3 mip_div3_ congrankcomp_div3_ mip_congrankcomp_div3_, correlation(psar1)
outreg using TabA12, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Laws) merge

*************
* TABLE A13 *
*************
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided mip_div_ rankcomp_div_ mip_rankcomp_div_ if tin(1970,2012), correlation(psar1)
outreg using TabA13, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", SOTU) replace

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided mip_div_ congrankcomp_div_ mip_congrankcomp_div_ if tin(1970,2012), correlation(psar1)
outreg using TabA13, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Laws) merge

*************
* TABLE A14 *
*************
use BJPOLS_Data_UK.dta, clear
sort year majortopic
xtset majortopic year

xtpcse ma_legispeechshare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_, correlation(psar1)
outreg using TabA14, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse ma_legispeechshare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using TabA14, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse ma_legispeechshare_ rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using TabA14, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

*************
* TABLE A15 *
*************
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

* LOW/HIGH SALIENCE ISSUES 

** SOTU **

* MIP: CUT-POINT 

drop if majortopic==12

sum mipshare_int_, detail

* MEDIAN = 3.2 / MEAN = 8.0

by majortopic: sum mipshare_int_

gen low=0
replace low=1 if majortopic==3 | majortopic==4 | majortopic==5 | majortopic==6 | majortopic==7 | majortopic==8 | majortopic==11 | majortopic==2 | majortopic==9 | majortopic==10

gen high=0
replace high=1 if majortopic==1  

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ gov_vote vot_rankcomp_ divided rankcomp_div_ if low==1, correlation(psar1) 
outreg using TabA15, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Low salience) replace

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ gov_vote vot_rankcomp_ divided rankcomp_div_ if high==1, correlation(psar1) 
outreg using TabA15, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", High salience) merge

xi: arima speechshare_ i.pelectioncycle rank_gov_lcompetence_ gov_vote vot_rankcomp_ divided rankcomp_div_ if high==1, arima(1,0,0)
outreg using TabA15, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", High salience) merge

predict pr1 if e(sample) 
corr speechshare_ pr1 if e(sample) 
di r(rho)^2

*************
* TABLE A16 *
*************
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

** LAWS **
gen low=0
replace low=1 if majortopic==3 | majortopic==4 | majortopic==5 | majortopic==6 | majortopic==7 | majortopic==8 | majortopic==11 | majortopic==2 | majortopic==9 | majortopic==10

gen high=0
replace high=1 if majortopic==1  

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ cong_gov_vote vot_congrankcomp_ divided congrankcomp_div_ if low==1, correlation(psar1)
outreg using TabA16, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Low salience) replace

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ cong_gov_vote vot_congrankcomp_ divided congrankcomp_div_ if high==1, correlation(psar1)
outreg using TabA16, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", High salience) merge

xi: arima milawsshare_ i.electioncycle rank_cong_lcompetence_ cong_gov_vote vot_congrankcomp_ divided congrankcomp_div_ if high==1, arima(1,0,0)
outreg using TabA16, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", High salience) merge

predict pr1 if e(sample) 
corr speechshare_ pr1 if e(sample) 
di r(rho)^2

*************
* TABLE A17 *
*************
use BJPOLS_Data_UK_Pooled.dta, clear
sort year newmajortopic
xtset newmajortopic year

drop if newmajortopic==12 | newmajortopic==24

gen low=0
replace low=1 if newmajortopic==3 | newmajortopic==4 | newmajortopic==5 | newmajortopic==6 | newmajortopic==7 | newmajortopic==8 | newmajortopic==11 | newmajortopic==2 | newmajortopic==9 | newmajortopic==10
replace low=1 if newmajortopic==15 | newmajortopic==16 | newmajortopic==17 | newmajortopic==18 | newmajortopic==19 | newmajortopic==20 | newmajortopic==23 | newmajortopic==14 | newmajortopic==21 | newmajortopic==22

gen high=0
replace high=1 if newmajortopic==1  
replace high=1 if newmajortopic==13  

*POOLED
xtpcse agendashare_ rank_gov_lcompetence_ gov_vote vot_rankcomp_ if low==1, correlation(psar1)
outreg using TabA17, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Low salience) replace

xtpcse agendashare_ rank_gov_lcompetence_ gov_vote vot_rankcomp_ if high==1, correlation(psar1)
outreg using TabA17, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", High salience) merge

*************
* TABLE A18 *
*************
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ if divided==1, correlation(psar1) 
outreg using TabA18, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Divided government) replace

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ if divided==0, correlation(psar1) 
outreg using TabA18, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Unified government) merge

*************
* TABLE A19 *
*************
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ if divided==1, correlation(psar1)
outreg using TabA19, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Divided government) replace

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ if divided==0, correlation(psar1)
outreg using TabA19, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Unified government) merge
