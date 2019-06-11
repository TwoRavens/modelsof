insheet using 20071036_Data.csv, comma clear
save Data.dta, replace

*Treatment administered in blocks by solicitors 

use Data.dta, clear

*Their prep code
gen give = 1 if donation > 0
replace give = 0 if give==.
gen small_gift = 1 if usg==1 | csg==1 
replace small_gift = 0 if small_gift==.
gen large_gift = 1 if ulg==1 | clg==1
replace large_gift = 0 if large_gift==.
gen warm_vcm = warm_list*vcm 
gen warm_small = warm_list*small_gift
gen warm_large = warm_list*large_gift
gen prior_VCM = 1 if priortreat < 3
replace prior_VCM = 0 if prior_VCM==.
gen prior_Lotto = 1 if priortreat > 2
replace prior_Lotto = 0 if prior_Lotto==.
gen warm_pVCM = warm_list*prior_VCM
gen warm_pLotto = warm_list*prior_Lotto


*There is an error in the presentation of their regressions.  They describe the constant as a VCM coefficient. It is a constant, so that 
*small_gift and large_gift coefficients are changes relative to VCM (rather than absolute levels).
*Then, however, enter warm_list interacted with VCM, small_gift and large_gift, so that now these coefficients represent absolute level rather than dif relative to VCM.
*Since describe VCM as baseline in table, will treat it as control.
*Then, in warm_list interaction tables, change variables so that warm_list entered by itself, and then warm_small and warm_large entered as difference relative to this.
*Warm_list by itself is then a non-experimental effect (in baseline VCM conditions), and test the other two for experimental effects. 

*Table 3 - Rounding errors on coefficients in one regression

local j = 1
xtreg donation small_gift large_gift warm_list, i(id) fe

xtreg donation small_gift large_gift warm_vcm warm_small warm_large, i(id) fe
xtreg donation small_gift large_gift warm_small warm_large warm_list, i(id) fe

xtreg donation small_gift large_gift warm_pVCM warm_pLotto, i(id) fe

*Table 4 - Rounding errors on coefficients and s.e.

xtreg give small_gift large_gift warm_list, i(id) fe

xtreg give small_gift large_gift warm_vcm warm_small warm_large, i(id) fe
xtreg give small_gift large_gift warm_small warm_large warm_list, i(id) fe

xtreg give small_gift large_gift warm_pVCM warm_pLotto, i(id) fe

*Table 5 does not concern these treatment variables - looking at prior treatment effect on difference between current and prior donations

*Shift to areg, executes faster and since they don't cluster, no difference in coef. or s.e.

*Table 3 
areg donation small_gift large_gift warm_list, absorb(id) 
areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id) 
areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id) 
	
*Table 4 
areg give small_gift large_gift warm_list, absorb(id) 
areg give small_gift large_gift warm_small warm_large warm_list, absorb(id) 
areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id) 

save DatLLLPR, replace





