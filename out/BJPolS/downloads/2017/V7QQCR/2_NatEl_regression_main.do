
******************************************************************************
******************************************************************************

** National Elections and the Dynamics of International Negotiations - 2016 **

******************************************************************************
******************************************************************************


clear
use "EULO_NATEL.dta"


********************************
*** MAIN REGRESSION ANALYSIS ***
********************************


***1. *** 5% criterion - Regression with all countries, 60 days prior to close and non-close elections (large vs. small/medium states) *** 
******************************************************************************************************************************************

**1.1 Estimate Cox Model no TVCs**
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust nohr

**1.2 Run Grambsch & Therneau Test**
estat phtest, detail

**1.3 Estimate final Cox Model**
//Do not include as TVC: qmv
 
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) robust nohr

**1.4 Test of difference between large and small countries**
lincom lgpret5el60-smpret5el60


**1.5 Estimate Time Varying Coefficients and standard errors**

matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for large states close elections at 100 and 300 days**
gen coef_largec100 = el(bb,1,1) + (el(bb,1,12)*log(100))
gen coef_largec100_se = sqrt(el(vv,1,1) + ((log(100)^2)*el(vv,12,12)) + (2*log(100)*el(vv,12,1)))
gen W_largec100 = (coef_largec100 / coef_largec100_se)^2
gen pvallc1 = chi2tail(1, W_largec100)

gen coef_largec300 = el(bb,1,1) + (el(bb,1,12)*log(300))
gen coef_largec300_se = sqrt( el(vv,1,1) + ((log(300)^2)*el(vv,12,12)) + (2*log(300)*el(vv,12,1)))
gen W_largec300 = (coef_largec300 / coef_largec300_se)^2
gen pvallc3 = chi2tail(1, W_largec300)

gen coef_largec500 = el(bb,1,1) + (el(bb,1,12)*log(500))
gen coef_largec500_se = sqrt( el(vv,1,1) + ((log(500)^2)*el(vv,12,12)) + (2*log(500)*el(vv,12,1)))
gen W_largec500 = (coef_largec500 / coef_largec500_se)^2
gen pvallc5 = chi2tail(1, W_largec500)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen coef_smallc100 = el(bb,1,2) + (el(bb,1,13)*log(100))
gen coef_smallc100_se = sqrt( el(vv,2,2) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,2)))
gen W_smallc100 = (coef_smallc100 / coef_smallc100_se)^2
gen pvalsc1 = chi2tail(1, W_smallc100)

gen coef_smallc300 = el(bb,1,2) + (el(bb,1,13)*log(300))
gen coef_smallc300_se = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,2)))
gen W_smallc300 = (coef_smallc300 / coef_smallc300_se)^2
gen pvalsc3 = chi2tail(1, W_smallc300)

gen coef_smallc500 = el(bb,1,2) + (el(bb,1,13)*log(500))
gen coef_smallc500_se = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,2)))
gen W_smallc500 = (coef_smallc500 / coef_smallc500_se)^2
gen pvalsc5 = chi2tail(1, W_smallc500)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen coef_largen100 = el(bb,1,3) + (el(bb,1,14)*log(100))
gen coef_largen100_se = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,14,14)) + (2*log(100)*el(vv,14,3)))
gen W_largen100 = (coef_largen100 / coef_largen100_se)^2
gen pvalln1 = chi2tail(1, W_largen100)

gen coef_largen300 = el(bb,1,3) + (el(bb,1,14)*log(300))
gen coef_largen300_se = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,14,14)) + (2*log(300)*el(vv,14,3)))
gen W_largen300 = (coef_largen300 / coef_largen300_se)^2
gen pvalln3 = chi2tail(1, W_largen300)

gen coef_largen500 = el(bb,1,3) + (el(bb,1,14)*log(500))
gen coef_largen500_se = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,14,14)) + (2*log(500)*el(vv,14,3)))
gen W_largen500 = (coef_largen500 / coef_largen500_se)^2
gen pvalln5 = chi2tail(1, W_largen500)

**Test significance of coefficient for small states non-close elections at 100 and 300 days**
gen coef_smalln100 = el(bb,1,4) + (el(bb,1,15)*log(100))
gen coef_smalln100_se = sqrt( el(vv,4,4) + ((log(100)^2)*el(vv,15,15)) + (2*log(100)*el(vv,15,4)))
gen W_smalln100 = (coef_smalln100 / coef_smalln100_se)^2
gen pvalsn1 = chi2tail(1, W_smalln100)

gen coef_smalln300 = el(bb,1,4) + (el(bb,1,15)*log(300))
gen coef_smalln300_se = sqrt( el(vv,4,4) + ((log(300)^2)*el(vv,15,15)) + (2*log(300)*el(vv,15,4)))
gen W_smalln300 = (coef_smalln300 / coef_smalln300_se)^2
gen pvalsn3 = chi2tail(1, W_smalln300)

gen coef_smalln500 = el(bb,1,4) + (el(bb,1,15)*log(500))
gen coef_smalln500_se = sqrt( el(vv,4,4) + ((log(500)^2)*el(vv,15,15)) + (2*log(500)*el(vv,15,4)))
gen W_smalln500 = (coef_smalln500 / coef_smalln500_se)^2
gen pvalsn5 = chi2tail(1, W_smalln500)

**Test significance of coefficient for members at 100 and 300 days**
//Note QMV skipped in TVCs so vector entry for members jumps to 6, but not vector entry for tvc of members
gen coef_members100 = el(bb,1,6) + (el(bb,1,16)*log(100))
gen coef_members100_se = sqrt( el(vv,6,6) + ((log(100)^2)*el(vv,16,16)) + (2*log(100)*el(vv,16,6)))
gen W_members100 = (coef_members100 / coef_members100_se)^2
gen pvalm1 = chi2tail(1, W_members100)

gen coef_members300 = el(bb,1,6) + (el(bb,1,16)*log(300))
gen coef_members300_se = sqrt( el(vv,6,6) + ((log(300)^2)*el(vv,16,16)) + (2*log(300)*el(vv,16,6)))
gen W_members300 = (coef_members300 / coef_members300_se)^2
gen pvalm3 = chi2tail(1, W_members300)

gen coef_members500 = el(bb,1,6) + (el(bb,1,16)*log(500))
gen coef_members500_se = sqrt( el(vv,6,6) + ((log(500)^2)*el(vv,16,16)) + (2*log(500)*el(vv,16,6)))
gen W_members500 = (coef_members500 / coef_members500_se)^2
gen pvalm5 = chi2tail(1, W_members500)

**Test significance of coefficient for cooperation at 100 and 300 days**
gen coef_cooperation100 = el(bb,1,7) + (el(bb,1,17)*log(100))
gen coef_cooperation100_se = sqrt( el(vv,7,7) + ((log(100)^2)*el(vv,17,17)) + (2*log(100)*el(vv,17,7)))
gen W_cooperation100 = (coef_cooperation100 / coef_cooperation100_se)^2
gen pvalcoop1 = chi2tail(1, W_cooperation100)

gen coef_cooperation300 = el(bb,1,7) + (el(bb,1,17)*log(300))
gen coef_cooperation300_se = sqrt( el(vv,7,7) + ((log(300)^2)*el(vv,17,17)) + (2*log(300)*el(vv,17,7)))
gen W_cooperation300 = (coef_cooperation300 / coef_cooperation300_se)^2
gen pvalcoop3 = chi2tail(1, W_cooperation100)

gen coef_cooperation500 = el(bb,1,7) + (el(bb,1,17)*log(500))
gen coef_cooperation500_se = sqrt( el(vv,7,7) + ((log(500)^2)*el(vv,17,17)) + (2*log(500)*el(vv,17,7)))
gen W_cooperation500 = (coef_cooperation500 / coef_cooperation500_se)^2
gen pvalcoop5 = chi2tail(1, W_cooperation100)

**Test significance of coefficient for codecision at 100 and 300 days**
gen coef_codecision100 = el(bb,1,8) + (el(bb,1,18)*log(100))
gen coef_codecision100_se = sqrt( el(vv,8,8) + ((log(100)^2)*el(vv,18,18)) + (2*log(100)*el(vv,18,8)))
gen W_codecision100 = (coef_codecision100  / coef_codecision100_se)^2
gen pvalcod1 = chi2tail(1, W_codecision100)

gen coef_codecision300 = el(bb,1,8) + (el(bb,1,18)*log(300))
gen coef_codecision300_se = sqrt( el(vv,8,8) + ((log(300)^2)*el(vv,18,18)) + (2*log(300)*el(vv,18,8)))
gen W_codecision300 = (coef_codecision300 / coef_codecision300_se)^2
gen pvalcoP3 = chi2tail(1, W_codecision300)

gen coef_codecision500 = el(bb,1,8) + (el(bb,1,18)*log(500))
gen coef_codecision500_se = sqrt( el(vv,8,8) + ((log(500)^2)*el(vv,18,18)) + (2*log(500)*el(vv,18,8)))
gen W_codecision500 = (coef_codecision500 / coef_codecision500_se)^2
gen pvalcod5 = chi2tail(1, W_codecision500)

**Test significance of coefficient for directive at 100 and 300 days**
gen coef_directive100 = el(bb,1,9) + (el(bb,1,19)*log(100))
gen coef_directive100_se = sqrt( el(vv,9,9) + ((log(100)^2)*el(vv,19,19)) + (2*log(100)*el(vv,19,9)))
gen W_directive100 = (coef_directive100 / coef_directive100_se)^2
gen pvaldir1 = chi2tail(1, W_directive100)

gen coef_directive300 = el(bb,1,9) + (el(bb,1,19)*log(300))
gen coef_directive300_se = sqrt( el(vv,9,9) + ((log(300)^2)*el(vv,19,19)) + (2*log(300)*el(vv,19,9)))
gen W_directive300 = (coef_directive300 / coef_directive300_se)^2
gen pvaldir3 = chi2tail(1, W_directive300)

gen coef_directive500 = el(bb,1,9) + (el(bb,1,19)*log(500))
gen coef_directive500_se = sqrt( el(vv,9,9) + ((log(500)^2)*el(vv,19,19)) + (2*log(500)*el(vv,19,9)))
gen W_directive500 = (coef_directive500 / coef_directive500_se)^2
gen pvaldir5 = chi2tail(1, W_directive500)

**Test significance of coefficient for backlog at 100 and 300 days**
gen coef_backlog100 = el(bb,1,10) + (el(bb,1,20)*log(100))
gen coef_backlog100_se = sqrt( el(vv,10,10) + ((log(100)^2)*el(vv,20,20)) + (2*log(100)*el(vv,20,10)))
gen W_backlog100 = (coef_backlog100 / coef_backlog100_se)^2
gen pvalbac1 = chi2tail(1, W_backlog100)

gen coef_backlog300 = el(bb,1,10) + (el(bb,1,20)*log(300))
gen coef_backlog300_se = sqrt( el(vv,10,10) + ((log(300)^2)*el(vv,20,20)) + (2*log(300)*el(vv,20,10)))
gen W_backlog300 = (coef_backlog300 / coef_backlog300_se)^2
gen pvalbac3 = chi2tail(1, W_backlog300)

gen coef_backlog500 = el(bb,1,10) + (el(bb,1,20)*log(500))
gen coef_backlog500_se = sqrt( el(vv,10,10) + ((log(500)^2)*el(vv,20,20)) + (2*log(500)*el(vv,20,10)))
gen W_backlog500 = (coef_backlog500 / coef_backlog500_se)^2
gen pvalbac5 = chi2tail(1, W_backlog500)

**Test significance of coefficient for August at 100 and 300 days**
gen coef_Aug100 = el(bb,1,11) + (el(bb,1,21)*log(100))
gen coef_Aug100_se = sqrt( el(vv,11,11) + ((log(100)^2)*el(vv,21,21)) + (2*log(100)*el(vv,21,11)))
gen W_Aug100 = (coef_Aug100 / coef_Aug100_se)^2
gen pvalAug1 = chi2tail(1, W_Aug100)

gen coef_Aug300 = el(bb,1,11) + (el(bb,1,21)*log(300))
gen coef_Aug300_se = sqrt( el(vv,11,11) + ((log(300)^2)*el(vv,21,21)) + (2*log(300)*el(vv,21,11)))
gen W_Aug300 = (coef_Aug300 / coef_Aug300_se)^2
gen pvalAug3 = chi2tail(1, W_Aug300)

gen coef_Aug500 = el(bb,1,11) + (el(bb,1,21)*log(500))
gen coef_Aug500_se = sqrt( el(vv,11,11) + ((log(500)^2)*el(vv,21,21)) + (2*log(500)*el(vv,21,11)))
gen W_Aug500 = (coef_Aug500 / coef_Aug500_se)^2
gen pvalAug5 = chi2tail(1, W_Aug500)

**Test difference between large and small countries at 100, 300 and 500 days**
gen hyp2100 = coef_largec100 - coef_smallc100
gen hyp2100_se = sqrt((el(vv,1,1) + ((log(100)^2)*el(vv,12,12)) + (2*log(100)*el(vv,12,1))) + ///
(el(vv,2,2) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,2))) - 2*(el(vv,1,2)+log(100)*el(vv,1,13)+log(100)*el(vv,2,12)+(log(100)^2)*el(vv,12,13)))
gen W_hyp2100 = (hyp2100 / hyp2100_se)^2
gen pvalhyp21 = chi2tail(1, W_hyp2100)

gen hyp2300 = coef_largec300 - coef_smallc300
gen hyp2300_se = sqrt((el(vv,1,1) + ((log(300)^2)*el(vv,12,12)) + (2*log(300)*el(vv,12,1))) + ///
(el(vv,2,2) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,2))) - 2*(el(vv,1,2)+log(300)*el(vv,1,13)+log(300)*el(vv,2,12)+(log(300)^2)*el(vv,12,13)))
gen W_hyp2300 = (hyp2300 / hyp2300_se)^2
gen pvalhyp23 = chi2tail(1, W_hyp2300)

gen hyp2500 = coef_largec500 - coef_smallc500
gen hyp2500_se = sqrt((el(vv,1,1) + ((log(500)^2)*el(vv,12,12)) + (2*log(500)*el(vv,12,1))) + ///
(el(vv,2,2) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,2))) - 2*(el(vv,1,2)+log(500)*el(vv,1,13)+log(500)*el(vv,2,12)+(log(500)^2)*el(vv,12,13)))
gen W_hyp2500 = (hyp2500 / hyp2500_se)^2
gen pvalhyp25 = chi2tail(1, W_hyp2500)

save "Output\NATEL_output.dta", replace

*Large states close elections time-varying*
disp coef_largec100 coef_largec100_se
disp coef_largec300 coef_largec300_se
disp coef_largec500 coef_largec500_se
*Small states close elections time-varying*
disp coef_smallc100 coef_smallc100_se
disp coef_smallc300 coef_smallc300_se
disp coef_smallc500 coef_smallc500_se
*Large states non-close elections time-varying*
disp coef_largen100 coef_largen100_se
disp coef_largen300 coef_largen300_se
disp coef_largen500 coef_largen500_se
*Small states non-close elections time-varying*
disp coef_smalln100 coef_smalln100_se
disp coef_smalln300 coef_smalln300_se
disp coef_smalln500 coef_smalln500_se
*Test of size conjecture*
disp hyp2100 hyp2100_se
disp hyp2300 hyp2300_se
disp hyp2500 hyp2500_se


**Estimate Time Varying Coefficients for graph**
gen Time = _n
gen coef_lgpret = .
gen coef_lgpret_se = .
gen coef_smpret = .
gen coef_smpret_se = .
gen coef_lgprent = .
gen coef_lgprent_se = .
gen coef_smprent = .
gen coef_smprent_se = .

matrix bb = get(_b)
matrix vv = get(VCE)

quietly {
forvalues x = 1/1500 {

	replace coef_lgpret = el(bb,1,1) + (el(bb,1,12)*log(`x')) in `x'
	replace coef_lgpret_se = sqrt( el(vv,1,1) + ((log(`x')^2)*el(vv,12,12)) + (2*log(`x')*el(vv,12,1)) ) in `x'
	replace coef_smpret = el(bb,1,2) + (el(bb,1,13)*log(`x')) in `x'
	replace coef_smpret_se = sqrt( el(vv,2,2) + ((log(`x')^2)*el(vv,13,13)) + (2*log(`x')*el(vv,13,2)) ) in `x'
	replace coef_lgprent = el(bb,1,3) + (el(bb,1,14)*log(`x')) in `x'
	replace coef_lgprent_se = sqrt( el(vv,3,3) + ((log(`x')^2)*el(vv,14,14)) + (2*log(`x')*el(vv,14,3)) ) in `x'
	replace coef_smprent = el(bb,1,4) + (el(bb,1,15)*log(`x')) in `x'
	replace coef_smprent_se = sqrt( el(vv,4,4) + ((log(`x')^2)*el(vv,15,15)) + (2*log(`x')*el(vv,15,4)) ) in `x'

}
}
//

drop case_id - duration
drop if Time>1500

save "Output\NATEL_output.dta", replace









