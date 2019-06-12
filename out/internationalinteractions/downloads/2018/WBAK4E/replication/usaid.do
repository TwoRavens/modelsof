*In order to replicate the following results, you need to download SFA2tier package first*
clear*
set memory 1500m

*Chang you working directory here*
cd "C:\Users\Harry\Desktop\replication"
*Tell stata where you saved SFA2tier package*
adopath + "D:\stata11\ado\personal"
*If 'logout' is not installed on your computer, run 'ssc install logout' first*

use usaid.dta

*TABLE2 Model3: Extended Two-Tiered SFA *
SFA2tier  useaid gdppc pop civil pi polity imports ally manpower agree term coldwar terr Ford Carter Reagan BushS Clinton Obama rg2 rg3 rg4 rg5,  ///
sigmaw(gdppc pop civil pi polity imports ally manpower agree term coldwar terr) search robust 
version 9
ml max, difficult

*TABLE2 Model3: Sigma_u and Sigma_v*
*TABLE7 Decomposition for Extended Two-Tiered SFA*
SFA2tier_sigs

*TABLE3 AIC and BIC for Extended Two-Tiered SFA*
estat ic

*TABLE5 Distribution of Baragaining Power: Extended Two-Tiered SFA*
SFA2tier_eff
replace uw_diff_exp = -uw_diff_exp	
	
    foreach v of varlist u_hat w_hat uw_diff *_exp{
      replace `v' = `v'*100
    }
 
logout, save (Table5A) excel replace:   ///
        tabstat w_hat_exp u_hat_exp uw_diff_exp,  ///
        s(mean sd p25 p50 p75) f(%6.2f) c(s) save			   

*TABLE6: List Countries by Mean Net Surplus*
logout, save (Table6) excel replace:   ///		
bysort countryname: tabstat w_hat_exp u_hat_exp uw_diff_exp, ///
s(mean sd p25 p50 p75) f(%6.2f) c(s)
		
*TABLE4 Substantive Effect*
gen polity1=polity
gen pi1=pi
gen civil1=civil
gen ally1=ally
gen coldwar1=coldwar

replace polity1=0 if polity<5
replace polity1=1 if polity>=5
replace pi1=0 if pi==1 
replace pi1=0 if pi==2
replace pi1=0 if pi==3 
replace pi1=1 if pi==4
replace pi1=1 if pi==5 
		   
logout, save (Table4_1) excel replace:   ///		
bysort civil1: tabstat w_hat_exp u_hat_exp uw_diff_exp, ///
           s(mean sd p25 p50 p75) f(%6.2f) c(s)
ttest uw_diff_exp, by(civil1)
		   
logout, save (Table4_2) excel replace:   ///		
bysort pi1: tabstat w_hat_exp u_hat_exp uw_diff_exp, ///
           s(mean sd p25 p50 p75) f(%6.2f) c(s)			   
ttest uw_diff_exp, by(pi1)	
	
logout, save (Table4_3) excel replace:   ///		
bysort polity1: tabstat w_hat_exp u_hat_exp uw_diff_exp, ///
           s(mean sd p25 p50 p75) f(%6.2f) c(s)
ttest uw_diff_exp, by(polity1)
		   
logout, save (Table4_4) excel replace:   ///		
bysort ally1: tabstat w_hat_exp u_hat_exp uw_diff_exp, ///
           s(mean sd p25 p50 p75) f(%6.2f) c(s)
ttest uw_diff_exp, by(ally1)		   
		   
drop  u_hat w_hat uw_diff u_hat_exp w_hat_exp uw_diff_exp uw_diff_exp2


*TABLE2 Model2: Two-Tiered SFA Basic*
SFA2tier useaid gdppc pop civil pi polity imports ally manpower agree term coldwar terr Ford Carter Reagan BushS Clinton Obama rg2 rg3 rg4 rg5 , search robust 
version 9
ml max, difficult

*TABLE2 Model2: Sigma_u Sigma_v and Sigma_w*
*TABLE7 Decomposition: Two-Tiered SFA Basic*
SFA2tier_sigs

*TABLE3 AIC and BIC for Two-Tiered SFA Basic*
estat ic

*TABLE5 Distribution of Baragaining Power: Two-Tiered SFA Basic*
SFA2tier_eff
replace uw_diff_exp = -uw_diff_exp	
	
    foreach v of varlist u_hat w_hat uw_diff *_exp{
      replace `v' = `v'*100
    }
 
logout, save (Table5B) excel replace:   ///
        tabstat w_hat_exp u_hat_exp uw_diff_exp,  ///
        s(mean sd p25 p50 p75) f(%6.2f) c(s) save	

drop  u_hat w_hat uw_diff u_hat_exp w_hat_exp uw_diff_exp uw_diff_exp2
	   
*TABLE2 Model1: Linear Regression*
reg useaid gdppc pop civil pi polity imports ally manpower agree term coldwar terr Ford Carter Reagan BushS Clinton Obama rg2 rg3 rg4 rg5, robust

*TABLE3 AIC and BIC for Linear Regression*
estat ic

*TABLE1: Descriptive Statistics*
summarize useaid gdppc pop civil pi polity imports ally manpower agree term coldwar terr Ford Carter Reagan BushS Clinton BushJ Obama rg1 rg2 rg3 rg4 rg5  if e(sample)
			
*TABLE3 LR TEST: Two-Tiered SFA Basic v.s. Extended Two-Tiered SFA*
SFA2tier  useaid gdppc pop civil pi polity imports ally manpower agree term coldwar terr Ford Carter Reagan BushS Clinton Obama rg2 rg3 rg4 rg5,  ///
sigmaw(gdppc pop civil pi polity imports ally manpower agree term coldwar terr) search 
version 9
qui ml max, difficult
est store m3
SFA2tier useaid gdppc pop civil pi polity imports ally manpower agree term coldwar terr Ford Carter Reagan BushS Clinton Obama rg2 rg3 rg4 rg5, search
version 9
qui ml max, difficult
est store m2
lrtest m2 m3

*TABLE3 LR TEST: Linear Regression v.s. Two-Tiered SFA Extended*
constraint define 1 [sigma_u]_cons = 0
constraint define 2 [sigma_w]_cons = 0  
local xx "gdppc pop civil pi polity imports ally manpower agree term coldwar terr Ford Carter Reagan BushS Clinton Obama rg2 rg3 rg4 rg5 "
ml model lf SFA2tier_KP05_extend_ll (useaid: useaid = `xx') ///
               (sigma_v:) (sigma_u:) (sigma_w:), constraint(1 2)
qui ml check 
qui ml search
qui ml max, difficult
est store m1
lrtest m1 m3

drop  _sigu _sigw _est_m3 _est_m2 _est_m1

*TABLE6 Average Annual Aid Flows to Russia, Lebanon, Israel, South Korea, Germany and Argentina*
keep if ccode==160|ccode==255|ccode==666|ccode==365|ccode==732|ccode==660
table countryname, contents(mean eaidc)

exit

