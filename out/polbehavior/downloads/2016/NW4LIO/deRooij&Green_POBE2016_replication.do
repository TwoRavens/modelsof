*****************************************************************************************************************
* Data for the replication of RADIO PUBLIC SERVICE ANNOUNCEMENTS AND VOTER PARTICIPATION AMONG NATIVE AMERICANS: 
*	EVIDENCE FROM TWO FIELD EXPERIMENTS
* Eline A. de Rooij and Donald P. Green
* Political Behavior (POBE)
* Date: July 8, 2016
*****************************************************************************************************************

* The following analyses were carried out using Stata/SE 14.1 for Windows (64-bit x86-64) 

* download .dta files into new personal folder and specify it as the working directory:
cd " " 
** NOTE: insert correct link to folder between " " 

* open data (from folder set as working directory):
use "deRooij&Green_POBE2016.dta"

* NOTE: "outcome" = change in absolute numbers of registered Native American voters who voted between 2008-2004 or between 2010-2006


**********************************************************************************
** TABLE 1 MANUSCRIPT: Descriptive statistics
**********************************************************************************

* create turnout variables:
gen turnout2000_na = v2000_na/total_regna
gen turnout2004_na = v2004_na/total_regna	
gen turnout2008p_na = v2008p_na/total_regna	
gen turnout2006_na = v2006_na/total_regna
gen turnout2008_na = v2008_na/total_regna

* descriptives for 2008 and 2010 experimental rounds:
sum total_regna natam_c2000 prop_natam_c2000 natam_station v2000_na v2004_na v2008p_na turnout2000_na turnout2004_na turnout2008p_na v2008_na change_0408 if exp_round==2008
sum total_regna natam_c2000 prop_natam_c2000 natam_station treatment_2008 v2006_na v2008_na turnout2006_na turnout2008_na v2010_na change_0610na if exp_round==2010


**********************************************************************************
** TABLE 1 MANUSCRIPT: Balance test
**********************************************************************************

* 2008:
logit treatment total_regna if exp_round==2008
logit treatment natam_c2000 if exp_round==2008
logit treatment prop_natam_c2000 if exp_round==2008
logit treatment natam_station if exp_round==2008
logit treatment v2000_na if exp_round==2008
logit treatment v2004_na if exp_round==2008
logit treatment v2008p_na if exp_round==2008
logit treatment turnout2000_na if exp_round==2008
logit treatment turnout2004_na if exp_round==2008
logit treatment turnout2008p_na if exp_round==2008

* 2010:
logit treatment total_regna if exp_round==2010
logit treatment natam_c2000 if exp_round==2010
logit treatment prop_natam_c2000 if exp_round==2010
logit treatment natam_station if exp_round==2010
logit treatment treatment_2008 if exp_round==2010
logit treatment v2006_na if exp_round==2010
logit treatment v2008_na if exp_round==2010
logit treatment turnout2006_na if exp_round==2010
logit treatment turnout2008_na if exp_round==2010


**********************************************************************************
** TABLE 2 MANUSCRIPT: Difference-in-totals estimation of the Intent-to-Treat (ITT) 
*	effect for Native American registered voters
* calculate Difference in votes for treatment, Difference in votes for control
*	Difference (between these), and Total Registered Native Americans
* prepare data for randomization inference in R for ITT, P-value and 95-% confidence interval
**********************************************************************************

* number of stations per state for each exp. round
bysort state_id: egen num_stations08=count(station_id) if exp_round==2008
bysort state_id: egen num_stations10=count(station_id) if exp_round==2010
* number of stations assigned to treatment per state for each exp. round
bysort state_id: egen num_treat08=total(treatment) if exp_round==2008
bysort state_id: egen num_treat10=total(treatment) if exp_round==2010
* number of stations assigned to treatment divided by the total number of stations in a state for each exp. round
gen pi=.
replace pi=num_treat08/num_stations08 if exp_round==2008
replace pi=num_treat10/num_stations10 if exp_round==2010
* NOT pi
gen npi=.
replace npi=1-(num_treat08/num_stations08) if exp_round==2008
replace npi=1-(num_treat10/num_stations10) if exp_round==2010

* number of registered natam voters in total, per exp. round and per state in each exp. round
egen Treg = total(total_regna)
egen Treg08 = total(total_regna) if exp_round==2008
egen Treg10 = total(total_regna) if exp_round==2010
bysort state_id: egen Treg_state08 = total(total_regna) if exp_round==2008
bysort state_id: egen Treg_state10 = total(total_regna) if exp_round==2010

* total number of additional natam voters in treatment and control, taking account of different probabilities of selection into treatment/control in each state and exp. round
* Yi as "outcome" (change_0610na for 2010 exp. and change_0408 for 2008 exp.)
gen Yt=outcome/pi if treatment==1
gen Yc=outcome/npi if treatment==0
* totals across states/exp. rounds; and per exp. round
egen YTt=total(Yt)
egen YTc=total(Yc)
egen YTt08=total(Yt) if exp_round==2008
egen YTc08=total(Yc) if exp_round==2008
egen YTt10=total(Yt) if exp_round==2010
egen YTc10=total(Yc) if exp_round==2010
* totals per state for each exp. round
bysort state_id: egen YTt_state08 = total(Yt) if exp_round==2008
bysort state_id: egen YTc_state08 = total(Yc) if exp_round==2008
bysort state_id: egen YTt_state10 = total(Yt) if exp_round==2010
bysort state_id: egen YTc_state10 = total(Yc) if exp_round==2010

* ITT total, per exp. round and per state for each exp. round
gen ITT= (YTt-YTc)/Treg
* ITT = .019
gen ITT08= (YTt08-YTc08)/Treg08
* ITT = .017
gen ITT10= (YTt10-YTc10)/Treg10
* ITT = .020
gen ITT_state08= (YTt_state08-YTc_state08)/Treg_state08
gen ITT_state10= (YTt_state10-YTc_state10)/Treg_state10

* differences between treatment and control groups in number of additional natam voters
gen diff_all=YTt-YTc
gen diff_all08=YTt08-YTc08
gen diff_all10=YTt10-YTc10
gen diff08=YTt_state08-YTc_state08
gen diff10=YTt_state10-YTc_state10

* values for TABLE 2, columns 1-4:
mean YTt08 YTc08 diff_all08 Treg08
mean YTt10 YTc10 diff_all10 Treg10
mean YTt YTc diff_all Treg

* change variables from float to long for analysis in R
recast long state_id state_yr

* All stations 2008 and 2010
sort state_yr
save "All stations 2008 and 2010.dta"


**********************************************************************************
** TABLE A.9 IN APPENDIX: OLS regression of outcome on treatment assignment
**********************************************************************************

* 2008 and 2010 separately:
bysort exp_round: regress outcome treatment i.state_id 

* 2008 and 2010 combined:
regress outcome treatment i.exp_round i.state_id 


**********************************************************************************
** TABLE A.10 IN APPENDIX: 2SLS regression of outcome on contact
**********************************************************************************

* 2008 and 2010 separately:
bysort exp_round: ivregress 2sls outcome i.state_id (contact = treatment)

* 2008 and 2010 combined:
ivregress 2sls outcome i.exp_round i.state_id (contact = treatment)


**********************************************************************************
** TABLE A.11 IN APPENDIX: OLS regression of outcome on treatment assignment
*	non-Native and Native radio stations separately 
**********************************************************************************

* non-Native stations:
** 2008 and 2010 separately:
bysort exp_round: regress outcome treatment i.state_id if natam_station==0
* 2008 and 2010 combined:
regress outcome treatment i.exp_round i.state_id if natam_station==0

* Native stations:
** 2008 and 2010 separately:
bysort exp_round: regress outcome treatment i.state_id if natam_station==1
* 2008 and 2010 combined:
regress outcome treatment i.exp_round i.state_id if natam_station==1


**********************************************************************************
** TABLE A.12 IN APPENDIX: 2SLS regression of outcome on contact
*	non-Native and Native radio stations separately 
**********************************************************************************

* non-Native stations:
** 2008 and 2010 separately:
bysort exp_round: ivregress 2sls outcome i.state_id (contact = treatment) if natam_station==0
* 2008 and 2010 combined:
ivregress 2sls outcome i.exp_round i.state_id (contact = treatment) if natam_station==0

* Native stations:
** 2008 and 2010 separately:
bysort exp_round: ivregress 2sls outcome i.state_id (contact = treatment) if natam_station==1
* 2008 and 2010 combined:
ivregress 2sls outcome i.exp_round i.state_id (contact = treatment) if natam_station==1


**********************************************************************************
** TABLES A.13 and A.14 IN APPENDIX: Difference-in-totals estimation of the 
*	Intent-to-Treat (ITT) effect by state 
* calculate Difference in votes for treatment, Difference in votes for control
*	Difference (between these), and Total Registered Native Americans per state
* randomization inference in R for ITT, P-value and 95-% confidence interval
**********************************************************************************

* values for TABLE A.13, columns 1-4:
mean YTt_state08 YTc_state08 diff08 Treg_state08, over(state_id)

* values for TABLE A.14, columns 1-4:
mean YTt_state10 YTc_state10 diff10 Treg_state10, over(state_id)


**********************************************************************************
** TABLE A.15 IN APPENDIX: Difference-in-totals estimation of the Intent-to-Treat
* 	(ITT) effect for Native American registered voters, by non-Native and 
*	Native stations separately 
* calculate Difference in votes for treatment, Difference in votes for control
*	Difference (between these), and Total Registered Native Americans 
* prepare data for randomization inference in R
**********************************************************************************

* clear data:
clear

* open data (from folder set as working directory):
use "deRooij&Green_POBE2016.dta"

** Non-native stations:
keep if natam_station==0

* number of non-native stations per state for each exp. round
bysort state_id: egen num_nnstations08=count(station_id) if exp_round==2008
bysort state_id: egen num_nnstations10=count(station_id) if exp_round==2010
* number of stations assigned to treatment per state for each exp. round
bysort state_id: egen num_nntreat08=total(treatment) if exp_round==2008
bysort state_id: egen num_nntreat10=total(treatment) if exp_round==2010
* number of stations assigned to treatment divided by the total number of stations in a state for each exp. round
gen pi=.
replace pi=num_nntreat08/num_nnstations08 if exp_round==2008
replace pi=num_nntreat10/num_nnstations10 if exp_round==2010
* NOT pi
gen npi=.
replace npi=1-(num_nntreat08/num_nnstations08) if exp_round==2008
replace npi=1-(num_nntreat10/num_nnstations10) if exp_round==2010
* number of registered natam voters in total, per exp. round and per state in each exp. round
gen Ytnn=outcome/pi if treatment==1
gen Ycnn=outcome/npi if treatment==0
* drop those that have pi of 0 or 1
drop if pi==0 
drop if pi==1
egen Treg_nnstation08 = total(total_regna) if exp_round==2008
egen YTt_nnstation08 = total(Ytnn) if exp_round==2008
egen YTc_nnstation08 = total(Ycnn) if exp_round==2008
egen Treg_nnstation10 = total(total_regna) if exp_round==2010
egen YTt_nnstation10 = total(Ytnn) if exp_round==2010
egen YTc_nnstation10 = total(Ycnn) if exp_round==2010

gen ITT_nnstation08=(YTt_nnstation08-YTc_nnstation08)/Treg_nnstation08
gen ITT_nnstation10=(YTt_nnstation10-YTc_nnstation10)/Treg_nnstation10

gen diff_nnstation08=YTt_nnstation08-YTc_nnstation08
gen diff_nnstation10=YTt_nnstation10-YTc_nnstation10

* combining two experimental rounds:
egen Treg_nnstation = total(total_regna) 
egen YTt_nnstation = total(Ytnn)
egen YTc_nnstation = total(Ycnn)
gen ITT_nnstation=(YTt_nnstation-YTc_nnstation)/Treg_nnstation
gen diff_nnstation=YTt_nnstation-YTc_nnstation

* values for TABLE A.15, columns 1-4 Non-native stations:
mean YTt_nnstation08 YTc_nnstation08 diff_nnstation08 Treg_nnstation08
mean YTt_nnstation10 YTc_nnstation10 diff_nnstation10 Treg_nnstation10
mean YTt_nnstation YTc_nnstation diff_nnstation Treg_nnstation

* change variables from float to long for analysis in R
recast long state_id state_yr

sort state_yr
save "Nonnative stations 2008 and 2010.dta"

* clear data:
clear

* open data (from folder set as working directory):
use "deRooij&Green_POBE2016.dta"

** Native stations:
keep if natam_station==1

* number of native stations per state for each exp. round
bysort state_id: egen num_nastations08=count(station_id) if exp_round==2008
bysort state_id: egen num_nastations10=count(station_id) if exp_round==2010
* number of stations assigned to treatment per state for each exp. round
bysort state_id: egen num_natreat08=total(treatment) if exp_round==2008
bysort state_id: egen num_natreat10=total(treatment) if exp_round==2010
* number of stations assigned to treatment divided by the total number of stations in a state for each exp. round
gen pi=.
replace pi=num_natreat08/num_nastations08 if exp_round==2008
replace pi=num_natreat10/num_nastations10 if exp_round==2010
* NOT pi
gen npi=.
replace npi=1-(num_natreat08/num_nastations08) if exp_round==2008
replace npi=1-(num_natreat10/num_nastations10) if exp_round==2010
* number of registered natam voters in total, per exp. round and per state in each exp. round
gen Ytna=outcome/pi if treatment==1
gen Ycna=outcome/npi if treatment==0
* drop those that have pi of 0 or 1
drop if pi==0 
drop if pi==1
egen Treg_nastation08 = total(total_regna) if exp_round==2008
egen YTt_nastation08 = total(Ytna) if exp_round==2008
egen YTc_nastation08 = total(Ycna) if exp_round==2008
egen Treg_nastation10 = total(total_regna) if exp_round==2010
egen YTt_nastation10 = total(Ytna) if exp_round==2010
egen YTc_nastation10 = total(Ycna) if exp_round==2010

gen ITT_nastation08=(YTt_nastation08-YTc_nastation08)/Treg_nastation08
gen ITT_nastation10=(YTt_nastation10-YTc_nastation10)/Treg_nastation10

gen diff_nastation08=YTt_nastation08-YTc_nastation08
gen diff_nastation10=YTt_nastation10-YTc_nastation10

* combining two experimental rounds:
egen Treg_nastation = total(total_regna) 
egen YTt_nastation = total(Ytna)
egen YTc_nastation = total(Ycna)
gen ITT_nastation=(YTt_nastation-YTc_nastation)/Treg_nastation
gen diff_nastation=YTt_nastation-YTc_nastation

* values for TABLE A.15, columns 1-4 Native stations:
mean YTt_nastation08 YTc_nastation08 diff_nastation08 Treg_nastation08
mean YTt_nastation10 YTc_nastation10 diff_nastation10 Treg_nastation10
mean YTt_nastation YTc_nastation diff_nastation Treg_nastation

* change variables from float to long for analysis in R
recast long state_id state_yr

sort state_yr
save "Native stations 2008 and 2010.dta"


**********************************************************************************
** TABLE A.16 IN APPENDIX: Difference-in-totals estimation of the Intent-to-Treat
* 	(ITT) effect for radio station coverage area
* values in columns 1-3 are equal to those in TABLE 2 in the Manuscript and TABLE A.15
* randomization inference in R for ITT, P-value and 95-% confidence interval
**********************************************************************************


