


********************************************************************************************************
*THIS DO-FILE REPLICATES APPENDIX TABLE 1 IN:                                                  			   
* PATRICIA FUNK: 							                       	
* "HOW ACCURATE ARE SURVEYED PREFERENCES FOR PUBLIC POLICIES? EVIDENCE FROM
* A UNIQUE INSTITUTIONAL SETUP"                                                                                         
********************************************************************************************************

global data ="[your path]"

clear all
set more off
set matsize 2000


use "$data\VOX_prepared", clear 

preserve


recode German 0=. if votenr==371
recode Italian 0=. if votenr==371
recode French 0=. if votenr==371



keep  female prot cath age2039 age4059 age60plus highedu German Italian French survey_bias  survey_biasabs turnoutgap cooprate  ShareSPSurvey ShareCVPSurvey ShareFDPSurvey ShareSVPSurvey shareleersurvey important votenr

collapse  female prot cath age2039 age4059 age60plus highedu German Italian French survey_bias  survey_biasabs turnoutgap cooprate  ShareSPSurvey ShareCVPSurvey ShareFDPSurvey ShareSVPSurvey shareleersurvey important, by(votenr)

drop votenr

summarize

restore


