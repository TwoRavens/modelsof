** Replication code for "Misinformation and the Justification of Socially Undesirable Preferences"
** D.J. Flynn and Yanna Krupnikov
** Journal of Experimental Political Science

** Note: This file contains code necessary to replicate results presented in the appendix. Additional replication code (in Stata and R format) can be found in the other files included in this replication archive (see “FlynnKrupnikov_replication code.R” for a full list of results and their locations in the replication files). For an explanation of all files included in the replication archive, see "FlynnKrupnikov_README.docx" or contact the corresponding author at <d.j.flynn@dartmouth.edu>.

** Note: the read-in code below assumes that the dataset is saved to the directory "stata" that exists on the hard drive (insert your own working directory).
use "C:\stata\FlynnKrupnikov.dta"

**Table 3A1
mlogit fulltreat pid1
mlogit fulltreat white
mlogit fulltreat income
mlogit fulltreat gender
mlogit fulltreat blacklazy
mlogit fulltreat blackint
mlogit fulltreat prejsale

**Table 3A2
ksmirnov prejscale if fulltreat==1|fulltreat==2, by(fulltreat)
ksmirnov prejscale if fulltreat==1|fulltreat==3, by(fulltreat)
ksmirnov prejscale if fulltreat==1|fulltreat==4, by(fulltreat)
ksmirnov prejscale if fulltreat==1|fulltreat==5, by(fulltreat)
ksmirnov prejscale if fulltreat==1|fulltreat==6, by(fulltreat)
ksmirnov prejscale if fulltreat==1|fulltreat==7, by(fulltreat)
ksmirnov prejscale if fulltreat==1|fulltreat==8, by(fulltreat)
ksmirnov prejscale if fulltreat==2|fulltreat==3, by(fulltreat)
ksmirnov prejscale if fulltreat==2|fulltreat==4, by(fulltreat)
ksmirnov prejscale if fulltreat==2|fulltreat==5, by(fulltreat)
ksmirnov prejscale if fulltreat==2|fulltreat==6, by(fulltreat)
ksmirnov prejscale if fulltreat==2|fulltreat==7, by(fulltreat)
ksmirnov prejscale if fulltreat==2|fulltreat==8, by(fulltreat)
ksmirnov prejscale if fulltreat==3|fulltreat==4, by(fulltreat)
ksmirnov prejscale if fulltreat==3|fulltreat==5, by(fulltreat)
ksmirnov prejscale if fulltreat==3|fulltreat==6, by(fulltreat)
ksmirnov prejscale if fulltreat==3|fulltreat==7, by(fulltreat)
ksmirnov prejscale if fulltreat==3|fulltreat==8, by(fulltreat)
ksmirnov prejscale if fulltreat==4|fulltreat==5, by(fulltreat)
ksmirnov prejscale if fulltreat==4|fulltreat==6, by(fulltreat)
ksmirnov prejscale if fulltreat==4|fulltreat==7, by(fulltreat)
ksmirnov prejscale if fulltreat==4|fulltreat==8, by(fulltreat)
ksmirnov prejscale if fulltreat==5|fulltreat==6, by(fulltreat)
ksmirnov prejscale if fulltreat==5|fulltreat==7, by(fulltreat)
ksmirnov prejscale if fulltreat==5|fulltreat==8, by(fulltreat)
ksmirnov prejscale if fulltreat==6|fulltreat==7, by(fulltreat)
ksmirnov prejscale if fulltreat==6|fulltreat==8, by(fulltreat)
ksmirnov prejscale if fulltreat==7|fulltreat==8, by(fulltreat)

**Table 3A3
ksmirnov race if fulltreat==1|fulltreat==2, by(fulltreat)
ksmirnov race if fulltreat==1|fulltreat==3, by(fulltreat)
ksmirnov race if fulltreat==1|fulltreat==4, by(fulltreat)
ksmirnov race if fulltreat==1|fulltreat==5, by(fulltreat)
ksmirnov race if fulltreat==1|fulltreat==6, by(fulltreat)
ksmirnov race if fulltreat==1|fulltreat==7, by(fulltreat)
ksmirnov race if fulltreat==1|fulltreat==8, by(fulltreat)
ksmirnov race if fulltreat==2|fulltreat==3, by(fulltreat)
ksmirnov race if fulltreat==2|fulltreat==4, by(fulltreat)
ksmirnov race if fulltreat==2|fulltreat==5, by(fulltreat)
ksmirnov race if fulltreat==2|fulltreat==6, by(fulltreat)
ksmirnov race if fulltreat==2|fulltreat==7, by(fulltreat)
ksmirnov race if fulltreat==2|fulltreat==8, by(fulltreat)
ksmirnov race if fulltreat==3|fulltreat==4, by(fulltreat)
ksmirnov race if fulltreat==3|fulltreat==5, by(fulltreat)
ksmirnov race if fulltreat==3|fulltreat==6, by(fulltreat)
ksmirnov race if fulltreat==3|fulltreat==7, by(fulltreat)
ksmirnov race if fulltreat==3|fulltreat==8, by(fulltreat)
ksmirnov race if fulltreat==4|fulltreat==5, by(fulltreat)
ksmirnov race if fulltreat==4|fulltreat==6, by(fulltreat)
ksmirnov race if fulltreat==4|fulltreat==7, by(fulltreat)
ksmirnov race if fulltreat==4|fulltreat==8, by(fulltreat)
ksmirnov race if fulltreat==5|fulltreat==6, by(fulltreat)
ksmirnov race if fulltreat==5|fulltreat==7, by(fulltreat)
ksmirnov race if fulltreat==5|fulltreat==8, by(fulltreat)
ksmirnov race if fulltreat==6|fulltreat==7, by(fulltreat)
ksmirnov race if fulltreat==6|fulltreat==8, by(fulltreat)
ksmirnov race if fulltreat==7|fulltreat==8, by(fulltreat)


**Table 3B1
probit missing_prej c.cand_treat##c.corrtreat pid7 gender 
probit fav_missings c.cand_treat##c.corrtreat pid7 gender 
probit gov_missing c.cand_treat##c.corrtreat pid7 gender 
probit pres_missing c.cand_treat##c.corrtreat pid7 gender 
probit overall_missing c.cand_treat##c.corrtreat pid7 gender 
poisson missing_count c.cand_treat##c.corrtreat pid7 gender 

**Table 3C1
**Done in excel (see “FlynnKrupnikov_Table 3C1.xlsx”)

**Table 4A1
**All Participants
su favorable_dv if allcorr==0&cand_treat==1,d
su favorable_dv if allcorr==1&cand_treat==1,d
su favorable_dv if allcorr==0&cand_treat==2,d
su favorable_dv if allcorr==1&cand_treat==2,d
su favorable_dv if allcorr==0&cand_treat==3,d
su favorable_dv if allcorr==1&cand_treat==3,d
su favorable_dv if allcorr==0&cand_treat==4,d
su favorable_dv if allcorr==1&cand_treat==4,d

**Low Prej
su favorable_dv if allcorr==0&cand_treat==1&prejscale<=0.5,d
su favorable_dv if allcorr==1&cand_treat==1&prejscale<=0.5,d
su favorable_dv if allcorr==0&cand_treat==2&prejscale<=0.5,d
su favorable_dv if allcorr==1&cand_treat==2&prejscale<=0.5,d
su favorable_dv if allcorr==0&cand_treat==3&prejscale<=0.5,d
su favorable_dv if allcorr==1&cand_treat==3&prejscale<=0.5,d
su favorable_dv if allcorr==0&cand_treat==4&prejscale<=0.5,d
su favorable_dv if allcorr==1&cand_treat==4&prejscale<=0.5,d

**High Prej
su favorable_dv if allcorr==0&cand_treat==1&prejscale>0.5,d
su favorable_dv if allcorr==1&cand_treat==1&prejscale>0.5,d
su favorable_dv if allcorr==0&cand_treat==2&prejscale>0.5,d
su favorable_dv if allcorr==1&cand_treat==2&prejscale>0.5,d
su favorable_dv if allcorr==0&cand_treat==3&prejscale>0.5,d
su favorable_dv if allcorr==1&cand_treat==3&prejscale>0.5,d
su favorable_dv if allcorr==0&cand_treat==4&prejscale>0.5,d
su favorable_dv if allcorr==1&cand_treat==4&prejscale>0.5,d

**Table 4A2
**All Participants
su vote_dv if allcorr==0&cand_treat==1,d
su vote_dv if allcorr==1&cand_treat==1,d
su vote_dv if allcorr==0&cand_treat==2,d
su vote_dv if allcorr==1&cand_treat==2,d
su vote_dv if allcorr==0&cand_treat==3,d
su vote_dv if allcorr==1&cand_treat==3,d
su vote_dv if allcorr==0&cand_treat==4,d
su vote_dv if allcorr==1&cand_treat==4,d

**Low Prej
su vote_dv if allcorr==0&cand_treat==1&prejscale<=0.5,d
su vote_dv if allcorr==1&cand_treat==1&prejscale<=0.5,d
su vote_dv if allcorr==0&cand_treat==2&prejscale<=0.5,d
su vote_dv if allcorr==1&cand_treat==2&prejscale<=0.5,d
su vote_dv if allcorr==0&cand_treat==3&prejscale<=0.5,d
su vote_dv if allcorr==1&cand_treat==3&prejscale<=0.5,d
su vote_dv if allcorr==0&cand_treat==4&prejscale<=0.5,d
su vote_dv if allcorr==1&cand_treat==4&prejscale<=0.5,d

**High Prej
su vote_dv if allcorr==0&cand_treat==1&prejscale>0.5,d
su vote_dv if allcorr==1&cand_treat==1&prejscale>0.5,d
su vote_dv if allcorr==0&cand_treat==2&prejscale>0.5,d
su vote_dv if allcorr==1&cand_treat==2&prejscale>0.5,d
su vote_dv if allcorr==0&cand_treat==3&prejscale>0.5,d
su vote_dv if allcorr==1&cand_treat==3&prejscale>0.5,d
su vote_dv if allcorr==0&cand_treat==4&prejscale>0.5,d
su vote_dv if allcorr==1&cand_treat==4&prejscale>0.5,d

**Table 4A3
**All Participants
su govern_dv if allcorr==0&cand_treat==1,d
su govern_dv if allcorr==1&cand_treat==1,d
su govern_dv if allcorr==0&cand_treat==2,d
su govern_dv if allcorr==1&cand_treat==2,d
su govern_dv if allcorr==0&cand_treat==3,d
su govern_dv if allcorr==1&cand_treat==3,d
su govern_dv if allcorr==0&cand_treat==4,d
su govern_dv if allcorr==1&cand_treat==4,d

**Low Prej
su govern_dv if allcorr==0&cand_treat==1&prejscale<=0.5,d
su govern_dv if allcorr==1&cand_treat==1&prejscale<=0.5,d
su govern_dv if allcorr==0&cand_treat==2&prejscale<=0.5,d
su govern_dv if allcorr==1&cand_treat==2&prejscale<=0.5,d
su govern_dv if allcorr==0&cand_treat==3&prejscale<=0.5,d
su govern_dv if allcorr==1&cand_treat==3&prejscale<=0.5,d
su govern_dv if allcorr==0&cand_treat==4&prejscale<=0.5,d
su govern_dv if allcorr==1&cand_treat==4&prejscale<=0.5,d

**High Prej
su govern_dv if allcorr==0&cand_treat==1&prejscale>0.5,d
su govern_dv if allcorr==1&cand_treat==1&prejscale>0.5,d
su govern_dv if allcorr==0&cand_treat==2&prejscale>0.5,d
su govern_dv if allcorr==1&cand_treat==2&prejscale>0.5,d
su govern_dv if allcorr==0&cand_treat==3&prejscale>0.5,d
su govern_dv if allcorr==1&cand_treat==3&prejscale>0.5,d
su govern_dv if allcorr==0&cand_treat==4&prejscale>0.5,d
su govern_dv if allcorr==1&cand_treat==4&prejscale>0.5,d

**Table 4A4
**All Participants
su president_dv if allcorr==0&cand_treat==1,d
su president_dv if allcorr==1&cand_treat==1,d
su president_dv if allcorr==0&cand_treat==2,d
su president_dv if allcorr==1&cand_treat==2,d
su president_dv if allcorr==0&cand_treat==3,d
su president_dv if allcorr==1&cand_treat==3,d
su president_dv if allcorr==0&cand_treat==4,d
su president_dv if allcorr==1&cand_treat==4,d

**Low Prej
su president_dv if allcorr==0&cand_treat==1&prejscale<=0.5,d
su president_dv if allcorr==1&cand_treat==1&prejscale<=0.5,d
su president_dv if allcorr==0&cand_treat==2&prejscale<=0.5,d
su president_dv if allcorr==1&cand_treat==2&prejscale<=0.5,d
su president_dv if allcorr==0&cand_treat==3&prejscale<=0.5,d
su president_dv if allcorr==1&cand_treat==3&prejscale<=0.5,d
su president_dv if allcorr==0&cand_treat==4&prejscale<=0.5,d
su president_dv if allcorr==1&cand_treat==4&prejscale<=0.5,d

**High Prej
su president_dv if allcorr==0&cand_treat==1&prejscale>0.5,d
su president_dv if allcorr==1&cand_treat==1&prejscale>0.5,d
su president_dv if allcorr==0&cand_treat==2&prejscale>0.5,d
su president_dv if allcorr==1&cand_treat==2&prejscale>0.5,d
su president_dv if allcorr==0&cand_treat==3&prejscale>0.5,d
su president_dv if allcorr==1&cand_treat==3&prejscale>0.5,d
su president_dv if allcorr==0&cand_treat==4&prejscale>0.5,d
su president_dv if allcorr==1&cand_treat==4&prejscale>0.5,d

**Table 4A5
**All Participants
su leader_dv if allcorr==0&cand_treat==1,d
su leader_dv if allcorr==1&cand_treat==1,d
su leader_dv if allcorr==0&cand_treat==2,d
su leader_dv if allcorr==1&cand_treat==2,d
su leader_dv if allcorr==0&cand_treat==3,d
su leader_dv if allcorr==1&cand_treat==3,d
su leader_dv if allcorr==0&cand_treat==4,d
su leader_dv if allcorr==1&cand_treat==4,d

**Low Prej
su leader_dv if allcorr==0&cand_treat==1&prejscale<=0.5,d
su leader_dv if allcorr==1&cand_treat==1&prejscale<=0.5,d
su leader_dv if allcorr==0&cand_treat==2&prejscale<=0.5,d
su leader_dv if allcorr==1&cand_treat==2&prejscale<=0.5,d
su leader_dv if allcorr==0&cand_treat==3&prejscale<=0.5,d
su leader_dv if allcorr==1&cand_treat==3&prejscale<=0.5,d
su leader_dv if allcorr==0&cand_treat==4&prejscale<=0.5,d
su leader_dv if allcorr==1&cand_treat==4&prejscale<=0.5,d

**High Prej
su leader_dv if allcorr==0&cand_treat==1&prejscale>0.5,d
su leader_dv if allcorr==1&cand_treat==1&prejscale>0.5,d
su leader_dv if allcorr==0&cand_treat==2&prejscale>0.5,d
su leader_dv if allcorr==1&cand_treat==2&prejscale>0.5,d
su leader_dv if allcorr==0&cand_treat==3&prejscale>0.5,d
su leader_dv if allcorr==1&cand_treat==3&prejscale>0.5,d
su leader_dv if allcorr==0&cand_treat==4&prejscale>0.5,d
su leader_dv if allcorr==1&cand_treat==4&prejscale>0.5,d


**In the 4B and 4C tables, DID code, created and provided by Jason Barabas, originally used in Jerit, Barabas and Clifford (2013)

**Table 4B1**
**Low Prej
**Same Party
ttest favorable_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
ttest favorable_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest favorable_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest favorable_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest favorable_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
ttest favorable_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest favorable_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest favorable_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*


**High Prej
**Same Party
ttest favorable_dv if cand_treat==1&prejscale>0.5, by(allcorr)
ttest favorable_dv if cand_treat==2&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest favorable_dv if cand_treat==1&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest favorable_dv if cand_treat==2&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest favorable_dv if cand_treat==3&prejscale>0.5, by(allcorr)
ttest favorable_dv if cand_treat==4&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest favorable_dv if cand_treat==3&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest favorable_dv if cand_treat==4&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*


**Table 4B2**
**Low Prej
**Same Party
ttest vote_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
ttest vote_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest vote_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest vote_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest vote_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
ttest vote_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest vote_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest vote_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*


**High Prej
**Same Party
ttest vote_dv if cand_treat==1&prejscale>0.5, by(allcorr)
ttest vote_dv if cand_treat==2&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest vote_dv if cand_treat==1&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest vote_dv if cand_treat==2&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest vote_dv if cand_treat==3&prejscale>0.5, by(allcorr)
ttest vote_dv if cand_treat==4&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest vote_dv if cand_treat==3&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest vote_dv if cand_treat==4&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Table 4B3
**Low Prej
**Same Party
ttest govern_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
ttest govern_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest govern_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest govern_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest govern_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
ttest govern_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest govern_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest govern_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*


**High Prej
**Same Party
ttest govern_dv if cand_treat==1&prejscale>0.5, by(allcorr)
ttest govern_dv if cand_treat==2&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest govern_dv if cand_treat==1&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest govern_dv if cand_treat==2&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest govern_dv if cand_treat==3&prejscale>0.5, by(allcorr)
ttest govern_dv if cand_treat==4&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest govern_dv if cand_treat==3&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest govern_dv if cand_treat==4&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Table 4B4
**Low Prej
**Same Party
ttest president_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
ttest president_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest president_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest president_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest president_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
ttest president_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest president_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest president_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*


**High Prej
**Same Party
ttest president_dv if cand_treat==1&prejscale>0.5, by(allcorr)
ttest president_dv if cand_treat==2&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest president_dv if cand_treat==1&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest president_dv if cand_treat==2&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest president_dv if cand_treat==3&prejscale>0.5, by(allcorr)
ttest president_dv if cand_treat==4&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest president_dv if cand_treat==3&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest president_dv if cand_treat==4&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Table 4B5
**Low Prej
**Same Party
ttest leader_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
ttest leader_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest leader_dv if cand_treat==1&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest leader_dv if cand_treat==2&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest leader_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
ttest leader_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest leader_dv if cand_treat==3&prejscale<=0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest leader_dv if cand_treat==4&prejscale<=0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*


**High Prej
**Same Party
ttest leader_dv if cand_treat==1&prejscale>0.5, by(allcorr)
ttest leader_dv if cand_treat==2&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest leader_dv if cand_treat==1&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest leader_dv if cand_treat==2&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
ttest leader_dv if cand_treat==3&prejscale>0.5, by(allcorr)
ttest leader_dv if cand_treat==4&prejscale>0.5, by(allcorr)
*DID comparison 
*Comparison 1: 
ttest leader_dv if cand_treat==3&prejscale>0.5, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest leader_dv if cand_treat==4&prejscale>0.5, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Table 4C1
**Favorability
**Same Party
*DID comparison 
*Comparison 1: 
ttest favorable_dv if allcorr==1&prejscale>0.5&cand_treat<3, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest favorable_dv if allcorr==0&prejscale>0.5&cand_treat<3, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

*DID comparison 
**Other Party
*Comparison 1: 
ttest favorable_dv if allcorr==1&prejscale>0.5&cand_treat>2, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest favorable_dv if allcorr==0&prejscale>0.5&cand_treat>2, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Vote
**Same Party
*DID comparison 
*Comparison 1: 
ttest vote_dv if allcorr==1&prejscale>0.5&cand_treat<3, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest vote_dv if allcorr==0&prejscale>0.5&cand_treat<3, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

*DID comparison 
**Other Party
*Comparison 1: 
ttest vote_dv if allcorr==1&prejscale>0.5&cand_treat>2, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest vote_dv if allcorr==0&prejscale>0.5&cand_treat>2, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**President
**Same Party
*DID comparison 
*Comparison 1: 
ttest president_dv if allcorr==1&prejscale>0.5&cand_treat<3, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest president_dv if allcorr==0&prejscale>0.5&cand_treat<3, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

*DID comparison 
**Other Party
*Comparison 1: 
ttest president_dv if allcorr==1&prejscale>0.5&cand_treat>2, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest president_dv if allcorr==0&prejscale>0.5&cand_treat>2, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Governor
**Same Party
*DID comparison 
*Comparison 1: 
ttest govern_dv if allcorr==1&prejscale>0.5&cand_treat<3, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest govern_dv if allcorr==0&prejscale>0.5&cand_treat<3, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

*DID comparison 
**Other Party
*Comparison 1: 
ttest govern_dv if allcorr==1&prejscale>0.5&cand_treat>2, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest govern_dv if allcorr==0&prejscale>0.5&cand_treat>2, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Leadership
**Same Party
*DID comparison 
*Comparison 1: 
ttest leader_dv if allcorr==1&prejscale>0.5&cand_treat<3, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest leader_dv if allcorr==0&prejscale>0.5&cand_treat<3, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

*DID comparison 
**Other Party
*Comparison 1: 
ttest leader_dv if allcorr==1&prejscale>0.5&cand_treat>2, by(black)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest leader_dv if allcorr==0&prejscale>0.5&cand_treat>2, by(black)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*


**Table 4D1
**Favorability 
**Same Party
*DID comparison 
*Comparison 1: 
ttest favorable_dv if cand_treat==1&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest favorable_dv if cand_treat==2&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
*DID comparison 
*Comparison 1: 
ttest favorable_dv if cand_treat==3&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest favorable_dv if cand_treat==4&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Vote
**Same Party
*DID comparison 
*Comparison 1: 
ttest vote_dv if cand_treat==1&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest vote_dv if cand_treat==2&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
*DID comparison 
*Comparison 1: 
ttest vote_dv if cand_treat==3&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest vote_dv if cand_treat==4&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Governor
**Same Party
*DID comparison 
*Comparison 1: 
ttest govern_dv if cand_treat==1&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest govern_dv if cand_treat==2&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
*DID comparison 
*Comparison 1: 
ttest govern_dv if cand_treat==3&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest govern_dv if cand_treat==4&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**President
**Same Party
*DID comparison 
*Comparison 1: 
ttest president_dv if cand_treat==1&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest president_dv if cand_treat==2&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
*DID comparison 
*Comparison 1: 
ttest president_dv if cand_treat==3&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest president_dv if cand_treat==4&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Leader
**Same Party
*DID comparison 
*Comparison 1: 
ttest leader_dv if cand_treat==1&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest leader_dv if cand_treat==2&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Different Party
*DID comparison 
*Comparison 1: 
ttest leader_dv if cand_treat==3&prejscale>0.5&weakpid==1, by(allcorr)
return list
gen BL_N = r(N_1)+r(N_2)
gen BL_EFF=r(mu_1)-r(mu_2) 
gen BL_SD=sqrt(BL_N)*(r(se))
*Comparison 2: 
ttest leader_dv if cand_treat==4&prejscale>0.5&weakpid==1, by(allcorr)
gen white_N = r(N_1)+r(N_2)
gen white_EFF=r(mu_1)-r(mu_2) 
gen white_SD=sqrt(white_N)*(r(se))
*DID:
ttesti `=BL_N[1]' `=BL_EFF[1]' `=BL_SD[1]' `=white_N[1]' `=white_EFF[1]' `=white_SD[1]'
drop BL_* white_*

**Table 4E1
**Low Prejudice
ttest favorable_dv if cand_treat==1&prejscale<=0.5, by(attributed)
ttest favorable_dv if cand_treat==2&prejscale<=0.5, by(attributed)
ttest favorable_dv if cand_treat==3&prejscale<=0.5, by(attributed)
ttest favorable_dv if cand_treat==4&prejscale<=0.5, by(attributed)

ttest vote_dv if cand_treat==1&prejscale<=0.5, by(attributed)
ttest vote_dv if cand_treat==2&prejscale<=0.5, by(attributed)
ttest vote_dv if cand_treat==3&prejscale<=0.5, by(attributed)
ttest vote_dv if cand_treat==4&prejscale<=0.5, by(attributed)

ttest govern_dv if cand_treat==1&prejscale<=0.5, by(attributed)
ttest govern_dv if cand_treat==2&prejscale<=0.5, by(attributed)
ttest govern_dv if cand_treat==3&prejscale<=0.5, by(attributed)
ttest govern_dv if cand_treat==4&prejscale<=0.5, by(attributed)

ttest president_dv if cand_treat==1&prejscale<=0.5, by(attributed)
ttest president_dv if cand_treat==2&prejscale<=0.5, by(attributed)
ttest president_dv if cand_treat==3&prejscale<=0.5, by(attributed)
ttest president_dv if cand_treat==4&prejscale<=0.5, by(attributed)

ttest leader_dv if cand_treat==1&prejscale<=0.5, by(attributed)
ttest leader_dv if cand_treat==2&prejscale<=0.5, by(attributed)
ttest leader_dv if cand_treat==3&prejscale<=0.5, by(attributed)
ttest leader_dv if cand_treat==4&prejscale<=0.5, by(attributed)

**High Prejudice
ttest favorable_dv if cand_treat==1&prejscale>0.5, by(attributed)
ttest favorable_dv if cand_treat==2&prejscale>0.5, by(attributed)
ttest favorable_dv if cand_treat==3&prejscale>0.5, by(attributed)
ttest favorable_dv if cand_treat==4&prejscale>0.5, by(attributed)

ttest vote_dv if cand_treat==1&prejscale>0.5, by(attributed)
ttest vote_dv if cand_treat==2&prejscale>0.5, by(attributed)
ttest vote_dv if cand_treat==3&prejscale>0.5, by(attributed)
ttest vote_dv if cand_treat==4&prejscale>0.5, by(attributed)

ttest govern_dv if cand_treat==1&prejscale>0.5, by(attributed)
ttest govern_dv if cand_treat==2&prejscale>0.5, by(attributed)
ttest govern_dv if cand_treat==3&prejscale>0.5, by(attributed)
ttest govern_dv if cand_treat==4&prejscale>0.5, by(attributed)

ttest president_dv if cand_treat==1&prejscale>0.5, by(attributed)
ttest president_dv if cand_treat==2&prejscale>0.5, by(attributed)
ttest president_dv if cand_treat==3&prejscale>0.5, by(attributed)
ttest president_dv if cand_treat==4&prejscale>0.5, by(attributed)

ttest leader_dv if cand_treat==1&prejscale>0.5, by(attributed)
ttest leader_dv if cand_treat==2&prejscale>0.5, by(attributed)
ttest leader_dv if cand_treat==3&prejscale>0.5, by(attributed)
ttest leader_dv if cand_treat==4&prejscale>0.5, by(attributed)

**Table 4E2**
**Low Prejudice
ttest favorable_dv if cand_treat==1&prejscale<=0.5, by(unattributed)
ttest favorable_dv if cand_treat==2&prejscale<=0.5, by(unattributed)
ttest favorable_dv if cand_treat==3&prejscale<=0.5, by(unattributed)
ttest favorable_dv if cand_treat==4&prejscale<=0.5, by(unattributed)

ttest vote_dv if cand_treat==1&prejscale<=0.5, by(unattributed)
ttest vote_dv if cand_treat==2&prejscale<=0.5, by(unattributed)
ttest vote_dv if cand_treat==3&prejscale<=0.5, by(unattributed)
ttest vote_dv if cand_treat==4&prejscale<=0.5, by(unattributed)

ttest govern_dv if cand_treat==1&prejscale<=0.5, by(unattributed)
ttest govern_dv if cand_treat==2&prejscale<=0.5, by(unattributed)
ttest govern_dv if cand_treat==3&prejscale<=0.5, by(unattributed)
ttest govern_dv if cand_treat==4&prejscale<=0.5, by(unattributed)

ttest president_dv if cand_treat==1&prejscale<=0.5, by(unattributed)
ttest president_dv if cand_treat==2&prejscale<=0.5, by(unattributed)
ttest president_dv if cand_treat==3&prejscale<=0.5, by(unattributed)
ttest president_dv if cand_treat==4&prejscale<=0.5, by(unattributed)

ttest leader_dv if cand_treat==1&prejscale<=0.5, by(unattributed)
ttest leader_dv if cand_treat==2&prejscale<=0.5, by(unattributed)
ttest leader_dv if cand_treat==3&prejscale<=0.5, by(unattributed)
ttest leader_dv if cand_treat==4&prejscale<=0.5, by(unattributed)

**High Prejudice
ttest favorable_dv if cand_treat==1&prejscale>0.5, by(unattributed)
ttest favorable_dv if cand_treat==2&prejscale>0.5, by(unattributed)
ttest favorable_dv if cand_treat==3&prejscale>0.5, by(unattributed)
ttest favorable_dv if cand_treat==4&prejscale>0.5, by(unattributed)

ttest vote_dv if cand_treat==1&prejscale>0.5, by(unattributed)
ttest vote_dv if cand_treat==2&prejscale>0.5, by(unattributed)
ttest vote_dv if cand_treat==3&prejscale>0.5, by(unattributed)
ttest vote_dv if cand_treat==4&prejscale>0.5, by(unattributed)

ttest govern_dv if cand_treat==1&prejscale>0.5, by(unattributed)
ttest govern_dv if cand_treat==2&prejscale>0.5, by(unattributed)
ttest govern_dv if cand_treat==3&prejscale>0.5, by(unattributed)
ttest govern_dv if cand_treat==4&prejscale>0.5, by(unattributed)

ttest president_dv if cand_treat==1&prejscale>0.5, by(unattributed)
ttest president_dv if cand_treat==2&prejscale>0.5, by(unattributed)
ttest president_dv if cand_treat==3&prejscale>0.5, by(unattributed)
ttest president_dv if cand_treat==4&prejscale>0.5, by(unattributed)

ttest leader_dv if cand_treat==1&prejscale>0.5, by(unattributed)
ttest leader_dv if cand_treat==2&prejscale>0.5, by(unattributed)
ttest leader_dv if cand_treat==3&prejscale>0.5, by(unattributed)
ttest leader_dv if cand_treat==4&prejscale>0.5, by(unattributed)


