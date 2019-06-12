
******************************************************************************
******************************************************************************

** National Elections and the Dynamics of International Negotiations - 2016 **

******************************************************************************
******************************************************************************



************************
*** ROBUSTNESS TESTS ***
************************



***1. *** Regression with continous closeness variable [TABLE A1 IN APPENDIX]*** 
********************************************************************************

**Prepare dataset for continuous regression with additional data from polls (creates new dataset)**
clear
do 5_NatEl_continuous_dataset.do
use "EULO_NATEL_cont.dta"

**1.1 Estimate Cox Model no TVCs**
stcox prelclose qmv members cooperation codecision directive backlog100 Aug2 if date>date("01-01-1976","DMY"), nohr robust

**1.2 Run Grambsch & Therneau Test**
estat phtest, detail

**1.3 Estimate final Cox Model**
//Do not include as TVC: qmv prelclose

stcox prelclose qmv members cooperation codecision directive backlog100 Aug2 if date>date("01-01-1976","DMY"), ///
tvc(members cooperation codecision directive backlog100 Aug2) texp(ln(_t)) nohr robust

//Note: File with continuous data very large so erased after running regression to save disk space
erase "EULO_NATEL_cont.dta"

******************************************************************************************

use "EULO_NATEL.dta"

***2. *** 5% criterion based on poll data - only big countries - [TABLE A2 IN APPENDIX]*** 
******************************************************************************************

**2.1 Estimate Cox Model no TVCs**
stcox precpoll prencpoll qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**2.2 Run Grambsch & Therneau Test**
estat phtest, detail

**2.3 Estimate final Cox Model**
//Do not include as TVC: precpoll, prencpoll, qmv
stcox precpoll prencpoll qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust


***3. *** 5% criterion based on poll data - all countries - [TABLE A3 IN APPENDIX] *** 
**************************************************************************************

**3.1 Estimate Cox Model no TVCs**
stcox lgprecpoll smprecpoll lgprencpoll smprencpoll qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**3.2 Run Grambsch & Therneau Test**
estat phtest, detail

**3.3 Estimate final Cox Model**
//Do not include as TVC: lgprecpoll smprencpoll qmv
stcox lgprecpoll smprecpoll lgprencpoll smprencpoll qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(smprecpoll lgprencpoll members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

**3.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)
//matrix list e(V)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen coef_smallc100 = el(bb,1,2) + (el(bb,1,12)*log(100))
gen coef_smallc100_se = sqrt(el(vv,2,2) + ((log(100)^2)*el(vv,12,12)) + (2*log(100)*el(vv,12,2)))
gen W_smallc100 = (coef_smallc100 / coef_smallc100_se)^2
gen pvalsc1 = chi2tail(1, W_smallc100)

gen coef_smallc300 = el(bb,1,2) + (el(bb,1,12)*log(300))
gen coef_smallc300_se = sqrt( el(vv,2,2) + ((log(300)^2)*el(vv,12,12)) + (2*log(300)*el(vv,12,2)))
gen W_smallc300 = (coef_smallc300 / coef_smallc300_se)^2
gen pvalsc3 = chi2tail(1, W_smallc300)

gen coef_smallc500 = el(bb,1,2) + (el(bb,1,12)*log(500))
gen coef_smallc500_se = sqrt( el(vv,2,2) + ((log(500)^2)*el(vv,12,12)) + (2*log(500)*el(vv,12,2)))
gen W_smallc500 = (coef_smallc500 / coef_smallc500_se)^2
gen pvalsc5 = chi2tail(1, W_smallc500)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen coef_largen100 = el(bb,1,3) + (el(bb,1,13)*log(100))
gen coef_largen100_se = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,3)))
gen W_largen100 = (coef_largen100 / coef_largen100_se)^2
gen pvalln1 = chi2tail(1, W_largen100)

gen coef_largen300 = el(bb,1,3) + (el(bb,1,13)*log(300))
gen coef_largen300_se = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,3)))
gen W_largen300 = (coef_largen300 / coef_largen300_se)^2
gen pvalln3 = chi2tail(1, W_largen300)

gen coef_largen500 = el(bb,1,3) + (el(bb,1,13)*log(500))
gen coef_largen500_se = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,3)))
gen W_largen500 = (coef_largen500 / coef_largen500_se)^2
gen pvalln5 = chi2tail(1, W_largen500)

*Large states close elections time-varying*
disp coef_smallc100 coef_smallc100_se
disp coef_smallc300 coef_smallc300_se
disp coef_smallc500 coef_smallc500_se
*Large states non-close elections time-varying*
disp coef_largen100 coef_largen100_se
disp coef_largen300 coef_largen300_se
disp coef_largen500 coef_largen500_se



***4. *** Regression with all countries individually - [TABLE A4 IN APPENDIX] *** 
*********************************************************************************

**4.1 Estimate Cox Model no TVCs**
// Sweden, Ireland, Slovakia, Estonia, Bulgaria excluded as no close elections at 5% in the time period considered.
// Czech Republic, Hungary, Latvia, Malta, Romania, Bulgaria excluded as no non-close elections at 5% in the time period considered.
stcox depret5el60 frpret5el60 ukpret5el60 itpret5el60 sppret5el60 ndpret5el60 bepret5el60 grpret5el60 ptpret5el60 aupret5el60 dkpret5el60 ///
fnpret5el60 lupret5el60 plpret5el60 czpret5el60 hupret5el60 ltpret5el60 svpret5el60 lvpret5el60 cypret5el60 mapret5el60 ropret5el60 ///
deprent5el60 frprent5el60 ukprent5el60 itprent5el60 spprent5el60 ndprent5el60 beprent5el60 grprent5el60 ptprent5el60 swprent5el60 auprent5el60 ///
dkprent5el60 fnprent5el60 irprent5el60 luprent5el60 plprent5el60 skprent5el60 ltprent5el60 svprent5el60 esprent5el60 cyprent5el60 buprent5el60 ///
qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, nohr robust

**4.2 Run Grambsch & Therneau Test**
estat phtest, detail
*/
**4.3 Estimate final Cox Model**
// Do not include as TVC: depret5el60, frpret5el60, ukpret5el60, ptpret5el60, dkpret5el60, aupret5el60, fnpret5el60, lupret5el60, plpret5el60 
// czpret5el60, hupret5el60, lvpret5el60, 
// ukprent5el60 spprent5el60,  beprent5el60 dkprent5el60 fnprent5el60, irprent5el60, ltprent5el60 svprent5el60, qmv
// Sweden, Ireland, Slovakia, Estonia, Bulgaria excluded as no close elections at 5% in the time period considered.
// Czech Republic, Hungary, Latvia, Malta, Romania excluded as no non-close elections at 5% in the time period considered.

stcox depret5el60 frpret5el60 ukpret5el60 itpret5el60 sppret5el60 ndpret5el60 bepret5el60 grpret5el60 ptpret5el60 aupret5el60 dkpret5el60 ///
fnpret5el60 lupret5el60 plpret5el60 czpret5el60 hupret5el60 ltpret5el60 svpret5el60 lvpret5el60 cypret5el60 mapret5el60 ropret5el60 ///
deprent5el60 frprent5el60 ukprent5el60 itprent5el60 spprent5el60 ndprent5el60 beprent5el60 grprent5el60 ptprent5el60 swprent5el60 auprent5el60 ///
dkprent5el60 fnprent5el60 irprent5el60 luprent5el60 plprent5el60 skprent5el60 ltprent5el60 svprent5el60 esprent5el60 cyprent5el60 buprent5el60 ///
qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(itpret5el60 ndpret5el60 bepret5el60 ltpret5el60 svpret5el60 cypret5el60 mapret5el60 ropret5el60 deprent5el60 frprent5el60 itprent5el60 ///
ndprent5el60 grprent5el60 ptprent5el60 auprent5el60 luprent5el60 esprent5el60 cyprent5el60 ///
members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust



***5. *** Interaction with country size for close and non-close elections - [TABLE A5 IN APPENDIX] *** 
******************************************************************************************************

**5.1 Estimate Cox Model no TVCs**
stcox tel_size ntel_size qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, nohr robust

**5.2 Run Grambsch & Therneau Test**
estat phtest, detail

**5.3 Estimate final Cox Model **
//Do not include as TVC: qmv
stcox tel_size ntel_size qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(tel_size ntel_size members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

**5.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for close elections at 100, 300 and 500 days**
gen coef_tel_size100 = el(bb,1,1)+(el(bb,1,10)*log(100))
gen se_tel_size100 = sqrt(el(vv,1,1) + ((log(100)^2)*el(vv,10,10)) + (2*log(100)*el(vv,10,1)))
gen W_tel_size100 = (coef_tel_size100 / se_tel_size100)^2
gen pval_tel_size100 = chi2tail(1, W_tel_size100)

gen coef_tel_size300 = el(bb,1,1) + (el(bb,1,10)*log(300))
gen se_tel_size300 = sqrt(el(vv,1,1) + ((log(300)^2)*el(vv,10,10)) + (2*log(300)*el(vv,10,1)))
gen W_tel_size300 = (coef_tel_size300 / se_tel_size300)^2
gen pval_tel_size300 = chi2tail(1, W_tel_size300)

gen coef_tel_size500 = el(bb,1,1) + (el(bb,1,10)*log(500))
gen se_tel_size500 = sqrt(el(vv,1,1) + ((log(500)^2)*el(vv,10,10)) + (2*log(500)*el(vv,10,1)))
gen W_tel_size500 = (coef_tel_size500 / se_tel_size500)^2
gen pval_tel_size500 = chi2tail(1, W_tel_size500)

**Test significance of coefficient for non-close elections at 100, 300 and 500 days**
gen coef_ntel_size100 = el(bb,1,2) + (el(bb,1,11)*log(100))
gen se_ntel_size100 = sqrt(el(vv,2,2) + ((log(100)^2)*el(vv,11,11)) + (2*log(100)*el(vv,11,2)))
gen W_ntel_size100 = (coef_ntel_size100 / se_ntel_size100)^2
gen pval_ntel_size100 = chi2tail(1, W_ntel_size100)

gen coef_ntel_size300 = el(bb,1,2) + (el(bb,1,11)*log(300))
gen se_ntel_size300 = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,11,11)) + (2*log(300)*el(vv,11,2)))
gen W_ntel_size300 = (coef_ntel_size300 / se_ntel_size300)^2
gen pval_ntel_size300 = chi2tail(1, W_ntel_size300)

gen coef_ntel_size500 = el(bb,1,2) + (el(bb,1,11)*log(500))
gen se_ntel_size500 = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,11,11)) + (2*log(500)*el(vv,11,2)))
gen W_ntel_size500 = (coef_ntel_size500 / se_ntel_size500)^2
gen pval_ntel_size500 = chi2tail(1, W_ntel_size500)

*Close elections time-varying*
disp coef_tel_size100 se_tel_size100
disp coef_tel_size300 se_tel_size300
disp coef_tel_size500 se_tel_size500
*Non-close elections time-varying*
disp coef_ntel_size100 se_ntel_size100
disp coef_ntel_size300 se_ntel_size300
disp coef_ntel_size500 se_ntel_size500



***6. *** Close and non-close interacted with voting weights - [TABLE A6 IN APPENDIX] *** 
*****************************************************************************************

**6.1 Estimate Cox Model no TVCs**
stcox tel_vw ntel_vw qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, nohr robust

**6.2 Run Grambsch & Therneau Test**
estat phtest, detail

**6.3 Estimate final Cox Model **
//Do not include as TVC: 
stcox tel_vw ntel_vw qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(tel_vw ntel_vw qmv members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

**6.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for close elections at 100, 300 and 500 days**
gen coef_tel_vw100 = el(bb,1,1) + (el(bb,1,10)*log(100))
gen se_tel_vw100 = sqrt(el(vv,1,1) + ((log(100)^2)*el(vv,10,10)) + (2*log(100)*el(vv,10,1)))
gen W_tel_vw100 = (coef_tel_vw100 / se_tel_vw100)^2
gen pval_tel_vw100 = chi2tail(1, W_tel_vw100)

gen coef_tel_vw300 = el(bb,1,1) + (el(bb,1,10)*log(300))
gen se_tel_vw300 = sqrt(el(vv,1,1) + ((log(300)^2)*el(vv,10,10)) + (2*log(300)*el(vv,10,1)))
gen W_tel_vw300 = (coef_tel_vw300 / se_tel_vw300)^2
gen pval_tel_vw300 = chi2tail(1, W_tel_vw300)

gen coef_tel_vw500 = el(bb,1,1) + (el(bb,1,10)*log(500))
gen se_tel_vw500 = sqrt(el(vv,1,1) + ((log(500)^2)*el(vv,10,10)) + (2*log(500)*el(vv,10,1)))
gen W_tel_vw500 = (coef_tel_vw500 / se_tel_vw500)^2
gen pval_tel_vw500 = chi2tail(1, W_tel_vw500)

**Test significance of coefficient for non-close elections at 100, 300 and 500 days**
gen coef_ntel_vw100 = el(bb,1,2) + (el(bb,1,11)*log(100))
gen se_ntel_vw100 = sqrt(el(vv,2,2) + ((log(100)^2)*el(vv,11,11)) + (2*log(100)*el(vv,11,2)))
gen W_ntel_vw100 = (coef_ntel_vw100 / se_ntel_vw100)^2
gen pval_ntel_vw100 = chi2tail(1, W_ntel_vw100)

gen coef_ntel_vw300 = el(bb,1,2) + (el(bb,1,11)*log(300))
gen se_ntel_vw300 = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,11,11)) + (2*log(300)*el(vv,11,2)))
gen W_ntel_vw300 = (coef_ntel_vw300 / se_ntel_vw300)^2
gen pval_ntel_vw300 = chi2tail(1, W_ntel_vw300)

gen coef_ntel_vw500 = el(bb,1,2) + (el(bb,1,11)*log(500))
gen se_ntel_vw500 = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,11,11)) + (2*log(500)*el(vv,11,2)))
gen W_ntel_vw500 = (coef_ntel_vw500 / se_ntel_vw500)^2
gen pval_ntel_vw500 = chi2tail(1, W_ntel_vw500)


*Close elections time-varying*
disp coef_tel_vw100 se_tel_vw100
disp coef_tel_vw300 se_tel_vw300
disp coef_tel_vw500 se_tel_vw500
*Non-close elections time-varying*
disp coef_ntel_vw100 se_ntel_vw100
disp coef_ntel_vw300 se_ntel_vw300
disp coef_ntel_vw500 se_ntel_vw500



***7. *** Close vs. non-close elections all countries - 60 days prior to elections - [TABLE A7 IN APPENDIX] *** 
***************************************************************************************************************

**7.1 Estimate Cox Model no TVCs**
stcox pretel60 prentel60 qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**7.2 Run Grambsch & Therneau Test**
estat phtest, detail

**7.3 Estimate final Cox Model **
//Do not include as TVC: lgpretNRel60 smpretNRel60 qmv
stcox pretel60 prentel60 qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(pretel60 prentel60 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

**7.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for large states close elections at 100, 300 and 500 days**
gen tcoef_100 = el(bb,1,1) + (el(bb,1,10)*log(100))
gen tcoef_100_se = sqrt(el(vv,1,1) + ((log(100)^2)*el(vv,10,10)) + (2*log(100)*el(vv,10,1)))
gen tW_100 = (tcoef_100 / tcoef_100_se)^2
gen tpval1 = chi2tail(1, tW_100)

gen tcoef_300 = el(bb,1,1) + (el(bb,1,10)*log(300))
gen tcoef_300_se = sqrt( el(vv,1,1) + ((log(300)^2)*el(vv,10,10)) + (2*log(300)*el(vv,10,1)))
gen tW_300 = (tcoef_300 / tcoef_300_se)^2
gen tpval3 = chi2tail(1, tW_300)

gen tcoef_500 = el(bb,1,1) + (el(bb,1,10)*log(500))
gen tcoef_500_se = sqrt( el(vv,1,1) + ((log(500)^2)*el(vv,10,10)) + (2*log(500)*el(vv,10,1)))
gen tW_500 = (tcoef_500 / tcoef_500_se)^2
gen tpval5 = chi2tail(1, tW_500)

**Test significance of coefficient for large states close elections at 100, 300 and 500 days**
gen ntcoef_100 = el(bb,1,2) + (el(bb,1,11)*log(100))
gen ntcoef_100_se = sqrt(el(vv,2,2) + ((log(100)^2)*el(vv,11,11)) + (2*log(100)*el(vv,11,2)))
gen ntW_100 = (ntcoef_100 / ntcoef_100_se)^2
gen ntpval1 = chi2tail(1, ntW_100)

gen ntcoef_300 = el(bb,1,2) + (el(bb,1,11)*log(300))
gen ntcoef_300_se = sqrt( el(vv,2,2) + ((log(300)^2)*el(vv,11,11)) + (2*log(300)*el(vv,11,2)))
gen ntW_300 = (ntcoef_300 / ntcoef_300_se)^2
gen ntpval3 = chi2tail(1, ntW_300)

gen ntcoef_500 = el(bb,1,2) + (el(bb,1,11)*log(500))
gen ntcoef_500_se = sqrt( el(vv,2,2) + ((log(500)^2)*el(vv,11,11)) + (2*log(500)*el(vv,11,2)))
gen ntW_500 = (ntcoef_500 / ntcoef_500_se)^2
gen ntpval5 = chi2tail(1, ntW_500)

*Close elections time-varying*
disp tcoef_100 tcoef_100_se
disp tcoef_300 tcoef_300_se
disp tcoef_500 tcoef_500_se
*Non-close elections time-varying*
disp ntcoef_100 ntcoef_100_se
disp ntcoef_300 ntcoef_300_se
disp ntcoef_500 ntcoef_500_se



***8. *** Regression with 30 days prior to close and non-close elections instead of 60 - [TABLE A9 IN APPENDIX] *** 
*******************************************************************************************************************

**8.1 Estimate Cox Model no TVCs**
stcox lgpret5el30 smpret5el30 lgprent5el30 smprent5el30 qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**8.2 Run Grambsch & Therneau Test**
estat phtest, detail

**8.3 Estimate final Cox Model **
//Do not include as TVC: smprent5el30, qmv
// Large includes: Germany, France, UK, Italy, Spain
stcox lgpret5el30 smpret5el30 lgprent5el30 smprent5el30 qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(lgpret5el30 smpret5el30 lgprent5el30 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

// Test of difference between large and small countries //
lincom lgpret5el30-smpret5el30
lincom lgprent5el30-smprent5el30

**8.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for large states close elections at 100 and 300 days**
gen D30coef_largec100 = el(bb,1,1) + (el(bb,1,12)*log(100))
gen D30coef_largec100_se = sqrt(el(vv,1,1) + ((log(100)^2)*el(vv,12,12)) + (2*log(100)*el(vv,12,1)))
gen D30W_largec100 = (D30coef_largec100 / D30coef_largec100_se)^2
gen D30pvallc1 = chi2tail(1, D30W_largec100)

gen D30coef_largec300 = el(bb,1,1) + (el(bb,1,12)*log(300))
gen D30coef_largec300_se = sqrt( el(vv,1,1) + ((log(300)^2)*el(vv,12,12)) + (2*log(300)*el(vv,12,1)))
gen D30W_largec300 = (D30coef_largec300 / D30coef_largec300_se)^2
gen D30pvallc3 = chi2tail(1, D30W_largec300)

gen D30coef_largec500 = el(bb,1,1) + (el(bb,1,12)*log(500))
gen D30coef_largec500_se = sqrt( el(vv,1,1) + ((log(500)^2)*el(vv,12,12)) + (2*log(500)*el(vv,12,1)))
gen D30W_largec500 = (D30coef_largec500 / D30coef_largec500_se)^2
gen D30pvallc5 = chi2tail(1,D30W_largec500)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen D30coef_smallc100 = el(bb,1,2) + (el(bb,1,13)*log(100))
gen D30coef_smallc100_se = sqrt( el(vv,2,2) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,2)))
gen D30W_smallc100 = (D30coef_smallc100 / D30coef_smallc100_se)^2
gen D30pvalsc1 = chi2tail(1, D30W_smallc100)

gen D30coef_smallc300 = el(bb,1,2) + (el(bb,1,13)*log(300))
gen D30coef_smallc300_se = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,2)))
gen D30W_smallc300 = (D30coef_smallc300 / D30coef_smallc300_se)^2
gen D30pvalsc3 = chi2tail(1, D30W_smallc300)

gen D30coef_smallc500 = el(bb,1,2) + (el(bb,1,13)*log(500))
gen D30coef_smallc500_se = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,2)))
gen D30W_smallc500 = (D30coef_smallc500 / D30coef_smallc500_se)^2
gen D30pvalsc5 = chi2tail(1, D30W_smallc500)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen D30coef_largen100 = el(bb,1,3) + (el(bb,1,14)*log(100))
gen D30coef_largen100_se = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,14,14)) + (2*log(100)*el(vv,14,3)))
gen D30W_largen100 = (D30coef_largen100 / D30coef_largen100_se)^2
gen D30pvalln1 = chi2tail(1, D30W_largen100)

gen D30coef_largen300 = el(bb,1,3) + (el(bb,1,14)*log(300))
gen D30coef_largen300_se = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,14,14)) + (2*log(300)*el(vv,14,3)))
gen D30W_largen300 = (D30coef_largen300 / D30coef_largen300_se)^2
gen D30pvalln3 = chi2tail(1, D30W_largen300)

gen D30coef_largen500 = el(bb,1,3) + (el(bb,1,14)*log(500))
gen D30coef_largen500_se = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,14,14)) + (2*log(500)*el(vv,14,3)))
gen D30W_largen500 = (D30coef_largen500 / D30coef_largen500_se)^2
gen D30pvalln5 = chi2tail(1, D30W_largen500)

**Test significance of coefficient for small states non-close elections at 100 and 300 days**
gen D30coef_smalln100 = el(bb,1,4) + (el(bb,1,15)*log(100))
gen D30coef_smalln100_se = sqrt( el(vv,4,4) + ((log(100)^2)*el(vv,15,15)) + (2*log(100)*el(vv,15,4)))
gen D30W_smalln100 = (D30coef_smalln100 / D30coef_smalln100_se)^2
gen D30pvalsn1 = chi2tail(1, D30W_smalln100)

gen D30coef_smalln300 = el(bb,1,4) + (el(bb,1,15)*log(300))
gen D30coef_smalln300_se = sqrt( el(vv,4,4) + ((log(300)^2)*el(vv,15,15)) + (2*log(300)*el(vv,15,4)))
gen D30W_smalln300 = (D30coef_smalln300 / D30coef_smalln300_se)^2
gen D30pvalsn3 = chi2tail(1, D30W_smalln300)

gen D30coef_smalln500 = el(bb,1,4) + (el(bb,1,15)*log(500))
gen D30coef_smalln500_se = sqrt( el(vv,4,4) + ((log(500)^2)*el(vv,15,15)) + (2*log(500)*el(vv,15,4)))
gen D30W_smalln500 = (D30coef_smalln500 / D30coef_smalln500_se)^2
gen D30pvalsn5 = chi2tail(1, D30W_smalln500)

*Large states close elections time-varying*
disp D30coef_largec100 D30coef_largec100_se
disp D30coef_largec300 D30coef_largec300_se
disp D30coef_largec500 D30coef_largec500_se
*Small states close elections time-varying*
disp D30coef_smallc100 D30coef_smallc100_se
disp D30coef_smallc300 D30coef_smallc300_se
disp D30coef_smallc500 D30coef_smallc500_se
*Large states non-close elections time-varying*
disp D30coef_largen100 D30coef_largen100_se
disp D30coef_largen300 D30coef_largen300_se
disp D30coef_largen500 D30coef_largen500_se
*Small states non-close elections time-varying*
disp D30coef_smalln100 D30coef_smalln100_se
disp D30coef_smalln300 D30coef_smalln300_se
disp D30coef_smalln500 D30coef_smalln500_se



***9. *** Normalised closeness, based on elections prior to election under consideration - [TABLE A10 IN APPENDIX] *** 
**********************************************************************************************************************

**9.1 Estimate Cox Model no TVCs**
stcox lgpretNRel60 smpretNRel60 lgprentNRel60 smprentNRel60 qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**9.2 Run Grambsch & Therneau Test**
estat phtest, detail

**9.3 Estimate final Cox Model **
//Do not include as TVC: lgpretNRel60 smpretNRel60 qmv
stcox lgpretNRel60 smpretNRel60 lgprentNRel60 smprentNRel60 qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(lgprentNRel60 smprentNRel60 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

**9.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen coef_largen100_NR = el(bb,1,3) + (el(bb,1,12)*log(100))
gen coef_largen100_se_NR = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,12,12)) + (2*log(100)*el(vv,12,3)))
gen W_largen100_NR = (coef_largen100_NR / coef_largen100_se_NR)^2
gen pvalln1_NR = chi2tail(1, W_largen100_NR)

gen coef_largen300_NR = el(bb,1,3) + (el(bb,1,12)*log(300))
gen coef_largen300_se_NR = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,12,12)) + (2*log(300)*el(vv,12,3)))
gen W_largen300_NR = (coef_largen300_NR / coef_largen300_se_NR)^2
gen pvalln3_NR = chi2tail(1, W_largen300_NR)

gen coef_largen500_NR = el(bb,1,3) + (el(bb,1,12)*log(500))
gen coef_largen500_se_NR = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,12,12)) + (2*log(500)*el(vv,12,3)))
gen W_largen500_NR = (coef_largen500_NR / coef_largen500_se_NR)^2
gen pvalln5_NR = chi2tail(1, W_largen500_NR)

**Test significance of coefficient for small states non-close elections at 100 and 300 days**
gen coef_smalln100_NR = el(bb,1,4) + (el(bb,1,13)*log(100))
gen coef_smalln100_se_NR = sqrt( el(vv,4,4) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,4)))
gen W_smalln100_NR = (coef_smalln100_NR / coef_smalln100_se_NR)^2
gen pvalsn1_NR = chi2tail(1, W_smalln100_NR)

gen coef_smalln300_NR = el(bb,1,4) + (el(bb,1,13)*log(300))
gen coef_smalln300_se_NR = sqrt( el(vv,4,4) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,4)))
gen W_smalln300_NR = (coef_smalln300_NR / coef_smalln300_se_NR)^2
gen pvalsn3_NR = chi2tail(1, W_smalln300_NR)

gen coef_smalln500_NR = el(bb,1,4) + (el(bb,1,13)*log(500))
gen coef_smalln500_se_NR = sqrt( el(vv,4,4) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,4)))
gen W_smalln500_NR = (coef_smalln500_NR / coef_smalln500_se_NR)^2
gen pvalsn5_NR = chi2tail(1, W_smalln500_NR)

*Large states non-close elections time-varying*
disp coef_largen100_NR coef_largen100_se_NR 
disp coef_largen300_NR coef_largen300_se_NR 
disp coef_largen500_NR coef_largen500_se_NR 
*Small states non-close elections time-varying*
disp coef_smalln100_NR coef_smalln100_se_NR 
disp coef_smalln300_NR coef_smalln300_se_NR 
disp coef_smalln500_NR coef_smalln500_se_NR 



***10. *** Normalised closeness, based on all elections - [TABLE A11 IN APPENDIX] ***
*************************************************************************************

**10.1 Estimate Cox Model no TVCs**
stcox lgpretNTel60 smpretNTel60 lgprentNTel60 smprentNTel60 qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**10.2 Run Grambsch & Therneau Test**
estat phtest, detail
*/
**10.3 Estimate final Cox Model **
//Do not include as TVC: lgpretNTel60 smpretNTel60 qmv
stcox lgpretNTel60 smpretNTel60 lgprentNTel60 smprentNTel60 qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(lgprentNTel60 smprentNTel60 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

**10.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen coef_largen100_NT = el(bb,1,3) + (el(bb,1,12)*log(100))
gen coef_largen100_se_NT = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,12,12)) + (2*log(100)*el(vv,12,3)))
gen W_largen100_NT = (coef_largen100_NT / coef_largen100_se_NT)^2
gen pvalln1_NT = chi2tail(1, W_largen100_NT)

gen coef_largen300_NT = el(bb,1,3) + (el(bb,1,12)*log(300))
gen coef_largen300_se_NT = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,12,12)) + (2*log(300)*el(vv,12,3)))
gen W_largen300_NT = (coef_largen300_NT / coef_largen300_se_NT)^2
gen pvalln3_NT = chi2tail(1, W_largen300_NT)

gen coef_largen500_NT = el(bb,1,3) + (el(bb,1,12)*log(500))
gen coef_largen500_se_NT = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,12,12)) + (2*log(500)*el(vv,12,3)))
gen W_largen500_NT = (coef_largen500_NT / coef_largen500_se_NT)^2
gen pvalln5_NT = chi2tail(1, W_largen500_NT)

**Test significance of coefficient for small states non-close elections at 100 and 300 days**
gen coef_smalln100_NT = el(bb,1,4) + (el(bb,1,13)*log(100))
gen coef_smalln100_se_NT = sqrt( el(vv,4,4) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,4)))
gen W_smalln100_NT = (coef_smalln100_NT / coef_smalln100_se_NT)^2
gen pvalsn1_NT = chi2tail(1, W_smalln100_NT)

gen coef_smalln300_NT = el(bb,1,4) + (el(bb,1,13)*log(300))
gen coef_smalln300_se_NT = sqrt( el(vv,4,4) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,4)))
gen W_smalln300_NT = (coef_smalln300_NT / coef_smalln300_se_NT)^2
gen pvalsn3_NT = chi2tail(1, W_smalln300_NT)

gen coef_smalln500_NT = el(bb,1,4) + (el(bb,1,13)*log(500))
gen coef_smalln500_se_NT = sqrt( el(vv,4,4) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,4)))
gen W_smalln500_NT = (coef_smalln500_NT / coef_smalln500_se_NT)^2
gen pvalsn5_NT = chi2tail(1, W_smalln500_NT)

*Large states non-close elections time-varying*
disp coef_largen100_NT coef_largen100_se_NT 
disp coef_largen300_NT coef_largen300_se_NT 
disp coef_largen500_NT coef_largen500_se_NT 
*Small states non-close elections time-varying*
disp coef_smalln100_NT coef_smalln100_se_NT 
disp coef_smalln300_NT coef_smalln300_se_NT 
disp coef_smalln500_NT coef_smalln500_se_NT 



***11. *** Regression using 3% criterion for closeness instead of 5% - [TABLE A12 IN APPENDIX] ***
**************************************************************************************************

**11.1 Estimate Cox Model no TVCs**
stcox lgpret3el60 smpret3el60 lgprent3el60 smprent3el60 qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**11.2 Run Grambsch & Therneau Test**
estat phtest, detail

**11.3 Estimate final Cox Model **
//Do not include as TVC: qmv
stcox lgpret3el60 smpret3el60 lgprent3el60 smprent3el60 qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(lgpret3el60 smpret3el60 lgprent3el60 smprent3el60 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

// Test of difference between large and small countries //
lincom lgpret3el60-smpret3el60
lincom lgprent3el60-smprent3el60

**11.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for large states close elections at 100 and 300 days**
gen P3coef_largec100 = el(bb,1,1) + (el(bb,1,12)*log(100))
gen P3coef_largec100_se = sqrt(el(vv,1,1) + ((log(100)^2)*el(vv,12,12)) + (2*log(100)*el(vv,12,1)))
gen P3W_largec100 = (P3coef_largec100 / P3coef_largec100_se)^2
gen P3pvallc1 = chi2tail(1, P3W_largec100)

gen P3coef_largec300 = el(bb,1,1) + (el(bb,1,12)*log(300))
gen P3coef_largec300_se = sqrt( el(vv,1,1) + ((log(300)^2)*el(vv,12,12)) + (2*log(300)*el(vv,12,1)))
gen P3W_largec300 = (P3coef_largec300 / P3coef_largec300_se)^2
gen P3pvallc3 = chi2tail(1, P3W_largec300)

gen P3coef_largec500 = el(bb,1,1) + (el(bb,1,12)*log(500))
gen P3coef_largec500_se = sqrt( el(vv,1,1) + ((log(500)^2)*el(vv,12,12)) + (2*log(500)*el(vv,12,1)))
gen P3W_largec500 = (P3coef_largec500 / P3coef_largec500_se)^2
gen P3pvallc5 = chi2tail(1,P3W_largec500)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen P3coef_smallc100 = el(bb,1,2) + (el(bb,1,13)*log(100))
gen P3coef_smallc100_se = sqrt( el(vv,2,2) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,2)))
gen P3W_smallc100 = (P3coef_smallc100 / P3coef_smallc100_se)^2
gen P3pvalsc1 = chi2tail(1, P3W_smallc100)

gen P3coef_smallc300 = el(bb,1,2) + (el(bb,1,13)*log(300))
gen P3coef_smallc300_se = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,2)))
gen P3W_smallc300 = (P3coef_smallc300 / P3coef_smallc300_se)^2
gen P3pvalsc3 = chi2tail(1, P3W_smallc300)

gen P3coef_smallc500 = el(bb,1,2) + (el(bb,1,13)*log(500))
gen P3coef_smallc500_se = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,2)))
gen P3W_smallc500 = (P3coef_smallc500 / P3coef_smallc500_se)^2
gen P3pvalsc5 = chi2tail(1, P3W_smallc500)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen P3coef_largen100 = el(bb,1,3) + (el(bb,1,14)*log(100))
gen P3coef_largen100_se = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,14,14)) + (2*log(100)*el(vv,14,3)))
gen P3W_largen100 = (P3coef_largen100 / P3coef_largen100_se)^2
gen P3pvalln1 = chi2tail(1, P3W_largen100)

gen P3coef_largen300 = el(bb,1,3) + (el(bb,1,14)*log(300))
gen P3coef_largen300_se = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,14,14)) + (2*log(300)*el(vv,14,3)))
gen P3W_largen300 = (P3coef_largen300 / P3coef_largen300_se)^2
gen P3pvalln3 = chi2tail(1, P3W_largen300)

gen P3coef_largen500 = el(bb,1,3) + (el(bb,1,14)*log(500))
gen P3coef_largen500_se = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,14,14)) + (2*log(500)*el(vv,14,3)))
gen P3W_largen500 = (P3coef_largen500 / P3coef_largen500_se)^2
gen P3pvalln5 = chi2tail(1, P3W_largen500)

**Test significance of coefficient for small states non-close elections at 100 and 300 days**
gen P3coef_smalln100 = el(bb,1,4) + (el(bb,1,15)*log(100))
gen P3coef_smalln100_se = sqrt( el(vv,4,4) + ((log(100)^2)*el(vv,15,15)) + (2*log(100)*el(vv,15,4)))
gen P3W_smalln100 = (P3coef_smalln100 / P3coef_smalln100_se)^2
gen P3pvalsn1 = chi2tail(1, P3W_smalln100)

gen P3coef_smalln300 = el(bb,1,4) + (el(bb,1,15)*log(300))
gen P3coef_smalln300_se = sqrt( el(vv,4,4) + ((log(300)^2)*el(vv,15,15)) + (2*log(300)*el(vv,15,4)))
gen P3W_smalln300 = (P3coef_smalln300 / P3coef_smalln300_se)^2
gen P3pvalsn3 = chi2tail(1, P3W_smalln300)

gen P3coef_smalln500 = el(bb,1,4) + (el(bb,1,15)*log(500))
gen P3coef_smalln500_se = sqrt( el(vv,4,4) + ((log(500)^2)*el(vv,15,15)) + (2*log(500)*el(vv,15,4)))
gen P3W_smalln500 = (P3coef_smalln500 / P3coef_smalln500_se)^2
gen P3pvalsn5 = chi2tail(1, P3W_smalln500)


*Large states close elections time-varying*
disp P3coef_largec100 P3coef_largec100_se 
disp P3coef_largec300 P3coef_largec300_se
disp P3coef_largec500 P3coef_largec500_se 
*Small states close elections time-varying*
disp P3coef_smallc100 P3coef_smallc100_se
disp P3coef_smallc300 P3coef_smallc300_se 
disp P3coef_smallc500 P3coef_smallc500_se 
*Large states non-close elections time-varying*
disp P3coef_largen100 P3coef_largen100_se
disp P3coef_largen300 P3coef_largen300_se 
disp P3coef_largen500 P3coef_largen500_se 
*Small states non-close elections time-varying*
disp P3coef_smalln100 P3coef_smalln100_se
disp P3coef_smalln300 P3coef_smalln300_se
disp P3coef_smalln500 P3coef_smalln500_se




***12. *** Regression excluding early elections - [TABLE A13 IN APPENDIX] *** 
*****************************************************************************

**12.1 Estimate Cox Model no TVCs**
stcox lgpret5el60NS smpret5el60NS lgprent5el60NS smprent5el60NS qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**12.2 Run Grambsch & Therneau Test**
estat phtest, detail

**12.3 Estimate final Cox Model **
//Do not include as TVC: lgprent5el60NS qmv
stcox lgpret5el60NS smpret5el60NS lgprent5el60NS smprent5el60NS qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(lgpret5el60NS smpret5el60NS smprent5el60NS members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

**12.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for large states close elections at 100 and 300 days**
gen coef_largec100_NS = el(bb,1,1) + (el(bb,1,12)*log(100))
gen coef_largec100_se_NS = sqrt(el(vv,1,1) + ((log(100)^2)*el(vv,12,12)) + (2*log(100)*el(vv,12,1)))
gen W_largec100_NS = (coef_largec100_NS / coef_largec100_se_NS)^2
gen pvallc1_NS = chi2tail(1, W_largec100_NS)

gen coef_largec300_NS = el(bb,1,1) + (el(bb,1,12)*log(300))
gen coef_largec300_se_NS = sqrt( el(vv,1,1) + ((log(300)^2)*el(vv,12,12)) + (2*log(300)*el(vv,12,1)))
gen W_largec300_NS = (coef_largec300_NS / coef_largec300_se_NS)^2
gen pvallc3_NS = chi2tail(1, W_largec300_NS)

gen coef_largec500_NS = el(bb,1,1) + (el(bb,1,12)*log(500))
gen coef_largec500_se_NS = sqrt( el(vv,1,1) + ((log(500)^2)*el(vv,12,12)) + (2*log(500)*el(vv,12,1)))
gen W_largec500_NS = (coef_largec500_NS / coef_largec500_se_NS)^2
gen pvallc5_NS = chi2tail(1, W_largec500_NS)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen coef_smallc100_NS = el(bb,1,2) + (el(bb,1,13)*log(100))
gen coef_smallc100_se_NS = sqrt( el(vv,2,2) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,2)))
gen W_smallc100_NS = (coef_smallc100_NS / coef_smallc100_se_NS)^2
gen pvalsc1_NS = chi2tail(1, W_smallc100_NS)

gen coef_smallc300_NS = el(bb,1,2) + (el(bb,1,13)*log(300))
gen coef_smallc300_se_NS = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,2)))
gen W_smallc300_NS = (coef_smallc300_NS / coef_smallc300_se_NS)^2
gen pvalsc3_NS = chi2tail(1, W_smallc300_NS)

gen coef_smallc500_NS = el(bb,1,2) + (el(bb,1,13)*log(500))
gen coef_smallc500_se_NS = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,2)))
gen W_smallc500_NS = (coef_smallc500_NS / coef_smallc500_se_NS)^2
gen pvalsc5_NS = chi2tail(1, W_smallc500_NS)

**Test significance of coefficient for small states non-close elections at 100 and 300 days**
gen coef_smalln100_NS = el(bb,1,4) + (el(bb,1,14)*log(100))
gen coef_smalln100_se_NS = sqrt( el(vv,4,4) + ((log(100)^2)*el(vv,14,14)) + (2*log(100)*el(vv,14,4)))
gen W_smalln100_NS = (coef_smalln100_NS / coef_smalln100_se_NS)^2
gen pvalsn1_NS = chi2tail(1, W_smalln100_NS)

gen coef_smalln300_NS = el(bb,1,4) + (el(bb,1,14)*log(300))
gen coef_smalln300_se_NS = sqrt( el(vv,4,4) + ((log(300)^2)*el(vv,14,14)) + (2*log(300)*el(vv,14,4)))
gen W_smalln300_NS = (coef_smalln300_NS / coef_smalln300_se_NS)^2
gen pvalsn3_NS = chi2tail(1, W_smalln300_NS)

gen coef_smalln500_NS = el(bb,1,4) + (el(bb,1,14)*log(500))
gen coef_smalln500_se_NS = sqrt( el(vv,4,4) + ((log(500)^2)*el(vv,14,14)) + (2*log(500)*el(vv,14,4)))
gen W_smalln500_NS = (coef_smalln500_NS / coef_smalln500_se_NS)^2
gen pvalsn5_NS = chi2tail(1, W_smalln500_NS)

*Large states close elections time-varying*
disp coef_largec100_NS coef_largec100_se_NS
disp coef_largec300_NS coef_largec300_se_NS
disp coef_largec500_NS coef_largec500_se_NS
*Small states close elections time-varying*
disp coef_smallc100_NS coef_smallc100_se_NS
disp coef_smallc300_NS coef_smallc300_se_NS 
disp coef_smallc500_NS coef_smallc500_se_NS 
*Small states non-close elections time-varying*
disp coef_smalln100_NS coef_smalln100_se_NS
disp coef_smalln300_NS coef_smalln300_se_NS
disp coef_smalln500_NS coef_smalln500_se_NS





***13. *** Regression controlling for recessions - [TABLE A14 IN APPENDIX] *** 
******************************************************************************

**13.1 Estimate Cox Model no TVCs**
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 recess Aug if year1976_06==1, robust

**13.2 Run Grambsch & Therneau Test**
estat phtest, detail
*/
**13.3 Estimate final Cox Model **
//Do not include as TVC: lgpret5el60 smprent5el60 qmv
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 recess Aug if year1976_06==1, ///
tvc(smpret5el60 lgprent5el60 members cooperation codecision directive backlog100 recess Aug) texp(ln(_t)) nohr robust

**13.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen coef_smallc100_REC = el(bb,1,2) + (el(bb,1,13)*log(100))
gen coef_smallc100_se_REC = sqrt( el(vv,2,2) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,2)))
gen W_smallc100_REC = (coef_smallc100_REC / coef_smallc100_se_REC)^2
gen pvalsc1_REC = chi2tail(1, W_smallc100_REC)

gen coef_smallc300_REC = el(bb,1,2) + (el(bb,1,13)*log(300))
gen coef_smallc300_se_REC = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,2)))
gen W_smallc300_REC = (coef_smallc300_REC / coef_smallc300_se_REC)^2
gen pvalsc3_REC = chi2tail(1, W_smallc300_REC)

gen coef_smallc500_REC = el(bb,1,2) + (el(bb,1,13)*log(500))
gen coef_smallc500_se_REC = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,2)))
gen W_smallc500_REC = (coef_smallc500_REC / coef_smallc500_se_REC)^2
gen pvalsc5_REC = chi2tail(1, W_smallc500_REC)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen coef_largen100_REC = el(bb,1,3) + (el(bb,1,14)*log(100))
gen coef_largen100_se_REC = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,14,14)) + (2*log(100)*el(vv,14,3)))
gen W_largen100_REC = (coef_largen100_REC / coef_largen100_se_REC)^2
gen pvalln1_REC = chi2tail(1, W_largen100_REC)

gen coef_largen300_REC = el(bb,1,3) + (el(bb,1,14)*log(300))
gen coef_largen300_se_REC = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,14,14)) + (2*log(300)*el(vv,14,3)))
gen W_largen300_REC = (coef_largen300_REC / coef_largen300_se_REC)^2
gen pvalln3_REC = chi2tail(1, W_largen300_REC)

gen coef_largen500_REC = el(bb,1,3) + (el(bb,1,14)*log(500))
gen coef_largen500_se_REC = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,14,14)) + (2*log(500)*el(vv,14,3)))
gen W_largen500_REC = (coef_largen500_REC / coef_largen500_se_REC)^2
gen pvalln5_REC = chi2tail(1, W_largen500_REC)

**Test significance of coefficient for recession at 100 and 300 days**
gen coef_rec100 = el(bb,1,11) + (el(bb,1,20)*log(100))
gen coef_rec100_se = sqrt(el(vv,11,11) + ((log(100)^2)*el(vv,20,20)) + (2*log(100)*el(vv,20,11)))
gen W_rec100 = (coef_rec100 / coef_rec100_se)^2
gen pvalrec1 = chi2tail(1, W_rec100)

gen coef_rec300 = el(bb,1,11) + (el(bb,1,20)*log(300))
gen coef_rec300_se = sqrt( el(vv,11,11) + ((log(300)^2)*el(vv,20,20)) + (2*log(300)*el(vv,20,11)))
gen W_rec300 = (coef_rec300 / coef_rec300_se)^2
gen pvalrec3 = chi2tail(1, W_rec300)

gen coef_rec500 = el(bb,1,11) + (el(bb,1,20)*log(500))
gen coef_rec500_se = sqrt( el(vv,11,11) + ((log(500)^2)*el(vv,20,20)) + (2*log(500)*el(vv,20,11)))
gen W_rec500 = (coef_rec500 / coef_rec500_se)^2
gen pvalrec5 = chi2tail(1, W_rec500)

*Small states close elections time-varying*
disp coef_smallc100_REC coef_smallc100_se_REC
disp coef_smallc300_REC coef_smallc300_se_REC
disp coef_smallc500_REC coef_smallc500_se_REC
*Large states non-close elections time-varying*
disp coef_largen100_REC coef_largen100_se_REC
disp coef_largen300_REC coef_largen300_se_REC 
disp coef_largen500_REC coef_largen500_se_REC 
*Recession time-varying*
disp coef_rec100 coef_rec100_se
disp coef_rec300 coef_rec300_se
disp coef_rec500 coef_rec500_se


***14. *** Regression controlling for GDP growth - [TABLE A15 IN APPENDIX] *** 
******************************************************************************

**14.1 Estimate Cox Model no TVCs**
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 gdp_growth Aug ///
if year1981_06==1, robust

**14.2 Run Grambsch & Therneau Test**
estat phtest, detail

**14.3 Estimate final Cox Model **
//Do not include as TVC: lgpret5el60 smprent5el60 qmv backlog100 gdp_growth 
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 gdp_growth Aug ///
if year1981_06==1, tvc(smpret5el60 lgprent5el60 members cooperation codecision directive gdp_growth Aug) texp(ln(_t)) nohr robust

**14.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen coef_smallc100_GDP = el(bb,1,2) + (el(bb,1,13)*log(100))
gen coef_smallc100_se_GDP = sqrt( el(vv,2,2) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,2)))
gen W_smallc100_GDP = (coef_smallc100_GDP / coef_smallc100_se_GDP)^2
gen pvalsc1_GDP = chi2tail(1, W_smallc100_GDP)

gen coef_smallc300_GDP = el(bb,1,2) + (el(bb,1,13)*log(300))
gen coef_smallc300_se_GDP = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,2)))
gen W_smallc300_GDP = (coef_smallc300_GDP / coef_smallc300_se_GDP)^2
gen pvalsc3_GDP = chi2tail(1, W_smallc300_GDP)

gen coef_smallc500_GDP = el(bb,1,2) + (el(bb,1,13)*log(500))
gen coef_smallc500_se_GDP = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,2)))
gen W_smallc500_GDP = (coef_smallc500_GDP / coef_smallc500_se_GDP)^2
gen pvalsc5_GDP = chi2tail(1, W_smallc500_GDP)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen coef_largen100_GDP = el(bb,1,3) + (el(bb,1,14)*log(100))
gen coef_largen100_se_GDP = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,14,14)) + (2*log(100)*el(vv,14,3)))
gen W_largen100_GDP = (coef_largen100_GDP / coef_largen100_se_GDP)^2
gen pvalln1_GDP = chi2tail(1, W_largen100_GDP)

gen coef_largen300_GDP = el(bb,1,3) + (el(bb,1,14)*log(300))
gen coef_largen300_se_GDP = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,14,14)) + (2*log(300)*el(vv,14,3)))
gen W_largen300_GDP = (coef_largen300_GDP / coef_largen300_se_GDP)^2
gen pvalln3_GDP = chi2tail(1, W_largen300_GDP)

gen coef_largen500_GDP = el(bb,1,3) + (el(bb,1,14)*log(500))
gen coef_largen500_se_GDP = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,14,14)) + (2*log(500)*el(vv,14,3)))
gen W_largen500_GDP = (coef_largen500_GDP / coef_largen500_se_GDP)^2
gen pvalln5_GDP = chi2tail(1, W_largen500_GDP)

**Test significance of coefficient for GDP growth at 100 and 300 days**
gen coef_GDP100 = el(bb,1,11) + (el(bb,1,19)*log(100))
gen coef_GDP100_se = sqrt(el(vv,11,11) + ((log(100)^2)*el(vv,19,19)) + (2*log(100)*el(vv,19,11)))
gen W_GDP100 = (coef_GDP100 / coef_GDP100_se)^2
gen pvalgdp1 = chi2tail(1, W_GDP100)

gen coef_GDP300 = el(bb,1,11) + (el(bb,1,19)*log(300))
gen coef_GDP300_se = sqrt( el(vv,11,11) + ((log(300)^2)*el(vv,19,19)) + (2*log(300)*el(vv,19,11)))
gen W_GDP300 = (coef_GDP300 / coef_GDP300_se)^2
gen pvalgdp3 = chi2tail(1, W_GDP300)

gen coef_GDP500 = el(bb,1,11) + (el(bb,1,19)*log(500))
gen coef_GDP500_se = sqrt( el(vv,11,11) + ((log(500)^2)*el(vv,19,19)) + (2*log(500)*el(vv,19,11)))
gen W_GDP500 = (coef_GDP500 / coef_GDP500_se)^2
gen pvalgdp5 = chi2tail(1, W_GDP500)


*Small states close elections time-varying*
disp coef_smallc100_GDP coef_smallc100_se_GDP
disp coef_smallc300_GDP coef_smallc300_se_GDP
disp coef_smallc500_GDP coef_smallc500_se_GDP
*Large states non-close elections time-varying*
disp coef_largen100_GDP coef_largen100_se_GDP
disp coef_largen300_GDP coef_largen300_se_GDP 
disp coef_largen500_GDP coef_largen500_se_GDP 
*GDP growth time-varying*
disp coef_GDP100 coef_GDP100_se
disp coef_GDP300 coef_GDP300_se
disp coef_GDP500 coef_GDP500_se



***15. *** Regression controlling for preference range - [TABLE A16 IN APPENDIX] *** 
************************************************************************************

**15.1 Estimate Cox Model no TVCs**
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 preference_range Aug ///
if year1976_06==1, robust

**15.2 Run Grambsch & Therneau Test**
estat phtest, detail

**15.3 Estimate final Cox Model **
//Do not include as TVC: lgpret5el60 qmv
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 preference_range Aug if year1976_06==1, ///
tvc(smpret5el60 lgprent5el60 smprent5el60 members cooperation codecision directive backlog100 preference_range Aug) texp(ln(_t)) nohr robust

**15.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen coef_smallc100_PREF = el(bb,1,2) + (el(bb,1,13)*log(100))
gen coef_smallc100_se_PREF = sqrt( el(vv,2,2) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,2)))
gen W_smallc100_PREF = (coef_smallc100_PREF / coef_smallc100_se_PREF)^2
gen pvalsc1_PREF = chi2tail(1, W_smallc100_PREF)

gen coef_smallc300_PREF = el(bb,1,2) + (el(bb,1,13)*log(300))
gen coef_smallc300_se_PREF = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,2)))
gen W_smallc300_PREF = (coef_smallc300_PREF / coef_smallc300_se_PREF)^2
gen pvalsc3_PREF = chi2tail(1, W_smallc300_PREF)

gen coef_smallc500_PREF = el(bb,1,2) + (el(bb,1,13)*log(500))
gen coef_smallc500_se_PREF = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,2)))
gen W_smallc500_PREF = (coef_smallc500_PREF / coef_smallc500_se_PREF)^2
gen pvalsc5_PREF = chi2tail(1, W_smallc500_PREF)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen coef_largen100_PREF = el(bb,1,3) + (el(bb,1,14)*log(100))
gen coef_largen100_se_PREF = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,14,14)) + (2*log(100)*el(vv,14,3)))
gen W_largen100_PREF = (coef_largen100_PREF / coef_largen100_se_PREF)^2
gen pvalln1_PREF = chi2tail(1, W_largen100_PREF)

gen coef_largen300_PREF = el(bb,1,3) + (el(bb,1,14)*log(300))
gen coef_largen300_se_PREF = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,14,14)) + (2*log(300)*el(vv,14,3)))
gen W_largen300_PREF = (coef_largen300_PREF / coef_largen300_se_PREF)^2
gen pvalln3_PREF = chi2tail(1, W_largen300_PREF)

gen coef_largen500_PREF = el(bb,1,3) + (el(bb,1,14)*log(500))
gen coef_largen500_se_PREF = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,14,14)) + (2*log(500)*el(vv,14,3)))
gen W_largen500_PREF = (coef_largen500_PREF / coef_largen500_se_PREF)^2
gen pvalln5_PREF = chi2tail(1, W_largen500_PREF)

**Test significance of coefficient for small states non-close elections at 100 and 300 days**
gen coef_smalln100_PREF = el(bb,1,4) + (el(bb,1,15)*log(100))
gen coef_smalln100_se_PREF = sqrt(el(vv,4,4) + ((log(100)^2)*el(vv,15,15)) + (2*log(100)*el(vv,15,4)))
gen W_smalln100_PREF = (coef_smalln100_PREF / coef_smalln100_se_PREF)^2
gen pvalsn1_PREF = chi2tail(1, W_smalln100_PREF)

gen coef_smalln300_PREF = el(bb,1,4) + (el(bb,1,15)*log(300))
gen coef_smalln300_se_PREF = sqrt( el(vv,4,4) + ((log(300)^2)*el(vv,15,15)) + (2*log(300)*el(vv,15,4)))
gen W_smalln300_PREF = (coef_smalln300_PREF / coef_smalln300_se_PREF)^2
gen pvalsn3_PREF = chi2tail(1, W_smalln300_PREF)

gen coef_smalln500_PREF = el(bb,1,4) + (el(bb,1,15)*log(500))
gen coef_smalln500_se_PREF = sqrt( el(vv,4,4) + ((log(500)^2)*el(vv,15,15)) + (2*log(500)*el(vv,15,4)))
gen W_smalln500_PREF = (coef_smalln500_PREF / coef_smalln500_se_PREF)^2
gen pvalsn5_PREF = chi2tail(1, W_smalln500_PREF)

**Test significance of coefficient for preference range at 100 and 300 days**
gen coef_PREF100 = el(bb,1,11) + (el(bb,1,21)*log(100))
gen coef_PREF100_se = sqrt(el(vv,11,11) + ((log(100)^2)*el(vv,21,21)) + (2*log(100)*el(vv,21,11)))
gen W_PREF100 = (coef_PREF100 / coef_PREF100_se)^2
gen pvalpref1 = chi2tail(1, W_PREF100)

gen coef_PREF300 = el(bb,1,11) + (el(bb,1,21)*log(300))
gen coef_PREF300_se = sqrt( el(vv,11,11) + ((log(300)^2)*el(vv,21,21)) + (2*log(300)*el(vv,21,11)))
gen W_PREF300 = (coef_PREF300 / coef_PREF300_se)^2
gen pvalpref3 = chi2tail(1, W_PREF300)

gen coef_PREF500 = el(bb,1,11) + (el(bb,1,21)*log(500))
gen coef_PREF500_se = sqrt( el(vv,11,11) + ((log(500)^2)*el(vv,21,21)) + (2*log(500)*el(vv,21,11)))
gen W_PREF500 = (coef_PREF500 / coef_PREF500_se)^2
gen pvalpref5 = chi2tail(1, W_PREF500)


*Small states close elections time-varying*
disp coef_smallc100_PREF coef_smallc100_se_PREF
disp coef_smallc300_PREF coef_smallc300_se_PREF
disp coef_smallc500_PREF coef_smallc500_se_PREF
*Large states non-close elections time-varying*
disp coef_largen100_PREF coef_largen100_se_PREF
disp coef_largen300_PREF coef_largen300_se_PREF 
disp coef_largen500_PREF coef_largen500_se_PREF 
*Small states non-close elections time-varying*
disp coef_smalln100_PREF coef_smalln100_se_PREF
disp coef_smalln300_PREF coef_smalln300_se_PREF 
disp coef_smalln500_PREF coef_smalln500_se_PREF 
*Preference range time-varying*
disp coef_PREF100 coef_PREF100_se
disp coef_PREF300 coef_PREF300_se
disp coef_PREF500 coef_PREF500_se




***16. *** Regression controlling for commission final term in office - [TABLE A17 IN APPENDIX] *** 
***************************************************************************************************

**16.1 Estimate Cox Model no TVCs**
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 comfin Aug ///
if year1976_06==1, robust

**16.2 Run Grambsch & Therneau Test**
estat phtest, detail

**16.3 Estimate final Cox Model **
//Do not include as TVC: qmv comfin 
stcox lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 qmv members cooperation codecision directive backlog100 comfin Aug if year1976_06==1, ///
tvc(lgpret5el60 smpret5el60 lgprent5el60 smprent5el60 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust

**16.4 Estimate Time Varying Coefficients and standard errors**
matrix bb = get(_b)
matrix vv = get(VCE)

**Test significance of coefficient for close elections in large countries at 100 and 300 days**
gen coef_largec100_COM = el(bb,1,1) + (el(bb,1,13)*log(100))
gen coef_largec100_se_COM = sqrt(el(vv,1,1) + ((log(100)^2)*el(vv,13,13)) + (2*log(100)*el(vv,13,1)))
gen W_largec100_COM = (coef_largec100_COM / coef_largec100_se_COM)^2
gen pvallc1_COM = chi2tail(1, W_largec100_COM)

gen coef_largec300_COM = el(bb,1,1) + (el(bb,1,13)*log(300))
gen coef_largec300_se_COM = sqrt( el(vv,1,1) + ((log(300)^2)*el(vv,13,13)) + (2*log(300)*el(vv,13,1)))
gen W_largec300_COM = (coef_largec300_COM / coef_largec300_se_COM)^2
gen pvallc3_COM = chi2tail(1, W_largec300_COM)

gen coef_largec500_COM = el(bb,1,1) + (el(bb,1,13)*log(500))
gen coef_largec500_se_COM = sqrt( el(vv,1,1) + ((log(500)^2)*el(vv,13,13)) + (2*log(500)*el(vv,13,1)))
gen W_largec500_COM = (coef_largec500_COM / coef_largec500_se_COM)^2
gen pvallc5_COM = chi2tail(1, W_largec500_COM)

**Test significance of coefficient for small states close elections at 100 and 300 days**
gen coef_smallc100_COM = el(bb,1,2) + (el(bb,1,14)*log(100))
gen coef_smallc100_se_COM = sqrt( el(vv,2,2) + ((log(100)^2)*el(vv,14,14)) + (2*log(100)*el(vv,14,2)))
gen W_smallc100_COM = (coef_smallc100_COM / coef_smallc100_se_COM)^2
gen pvalsc1_COM = chi2tail(1, W_smallc100_COM)

gen coef_smallc300_COM = el(bb,1,2) + (el(bb,1,14)*log(300))
gen coef_smallc300_se_COM = sqrt(el(vv,2,2) + ((log(300)^2)*el(vv,14,14)) + (2*log(300)*el(vv,14,2)))
gen W_smallc300_COM = (coef_smallc300_COM / coef_smallc300_se_COM)^2
gen pvalsc3_COM = chi2tail(1, W_smallc300_COM)

gen coef_smallc500_COM = el(bb,1,2) + (el(bb,1,14)*log(500))
gen coef_smallc500_se_COM = sqrt(el(vv,2,2) + ((log(500)^2)*el(vv,14,14)) + (2*log(500)*el(vv,14,2)))
gen W_smallc500_COM = (coef_smallc500_COM / coef_smallc500_se_COM)^2
gen pvalsc5_COM = chi2tail(1, W_smallc500_COM)

**Test significance of coefficient for large states non-close elections at 100 and 300 days**
gen coef_largen100_COM = el(bb,1,3) + (el(bb,1,15)*log(100))
gen coef_largen100_se_COM = sqrt(el(vv,3,3) + ((log(100)^2)*el(vv,15,15)) + (2*log(100)*el(vv,15,3)))
gen W_largen100_COM = (coef_largen100_COM / coef_largen100_se_COM)^2
gen pvalln1_COM = chi2tail(1, W_largen100_COM)

gen coef_largen300_COM = el(bb,1,3) + (el(bb,1,15)*log(300))
gen coef_largen300_se_COM = sqrt( el(vv,3,3) + ((log(300)^2)*el(vv,15,15)) + (2*log(300)*el(vv,15,3)))
gen W_largen300_COM = (coef_largen300_COM / coef_largen300_se_COM)^2
gen pvalln3_COM = chi2tail(1, W_largen300_COM)

gen coef_largen500_COM = el(bb,1,3) + (el(bb,1,15)*log(500))
gen coef_largen500_se_COM = sqrt( el(vv,3,3) + ((log(500)^2)*el(vv,15,15)) + (2*log(500)*el(vv,15,3)))
gen W_largen500_COM = (coef_largen500_COM / coef_largen500_se_COM)^2
gen pvalln5_COM = chi2tail(1, W_largen500_COM)

**Test significance of coefficient for small states non-close elections at 100 and 300 days**
gen coef_smalln100_COM = el(bb,1,4) + (el(bb,1,16)*log(100))
gen coef_smalln100_se_COM = sqrt( el(vv,4,4) + ((log(100)^2)*el(vv,16,16)) + (2*log(100)*el(vv,16,4)))
gen W_smalln100_COM = (coef_smalln100_COM / coef_smalln100_se_COM)^2
gen pvalsn1_COM = chi2tail(1, W_smalln100_COM)

gen coef_smalln300_COM = el(bb,1,4) + (el(bb,1,16)*log(300))
gen coef_smalln300_se_COM = sqrt( el(vv,4,4) + ((log(300)^2)*el(vv,16,16)) + (2*log(300)*el(vv,16,4)))
gen W_smalln300_COM = (coef_smalln300_COM / coef_smalln300_se_COM)^2
gen pvalsn3_COM = chi2tail(1, W_smalln300_COM)

gen coef_smalln500_COM = el(bb,1,4) + (el(bb,1,16)*log(500))
gen coef_smalln500_se_COM = sqrt( el(vv,4,4) + ((log(500)^2)*el(vv,16,16)) + (2*log(500)*el(vv,16,4)))
gen W_smalln500_COM = (coef_smalln500_COM / coef_smalln500_se_COM)^2
gen pvalsn5_COM = chi2tail(1, W_smalln500_COM)


*Large states close elections time-varying*
disp coef_largec100_COM coef_largec100_se_COM
disp coef_largec300_COM coef_largec300_se_COM 
disp coef_largec500_COM coef_largec500_se_COM 
*Small states close elections time-varying*
disp coef_smallc100_COM coef_smallc100_se_COM
disp coef_smallc300_COM coef_smallc300_se_COM
disp coef_smallc500_COM coef_smallc500_se_COM
*Large states non-close elections time-varying*
disp coef_largen100_COM coef_largen100_se_COM
disp coef_largen300_COM coef_largen300_se_COM 
disp coef_largen500_COM coef_largen500_se_COM 
*Small states non-close elections time-varying*
disp coef_smalln100_COM coef_smalln100_se_COM
disp coef_smalln300_COM coef_smalln300_se_COM 
disp coef_smalln500_COM coef_smalln500_se_COM 



***17. *** Regression with 90 days prior to elections instead of 60 days*** 
**************************************************************************

**17.1 Estimate Cox Model no TVCs**
stcox lgpret5el90 smpret5el90 lgprent5el90 smprent5el90 qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**17.2 Run Grambsch & Therneau Test**
estat phtest, detail

**17.3 Estimate final Cox Model **
//Do not include as TVC: lgpret5el90, smpret5el90, qmv
stcox lgpret5el90 smpret5el90 lgprent5el90 smprent5el90 qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(lgprent5el90 smprent5el90 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust


***18. *** Regression with 7% criterion instead of 5%***
*******************************************************

**18.1 Estimate Cox Model no TVCs**
// Sweden excluded as no close-elections at 7% in the time period considered.
stcox lgpret7el60 smpret7el60 lgprent7el60 smprent7el60 qmv members cooperation codecision directive backlog100 Aug ///
if year1976_06==1, robust

**18.2 Run Grambsch & Therneau Test**
estat phtest, detail

**18.3 Estimate final Cox Model **
//Do not include as TVC: smpret7el60, qmv
stcox lgpret7el60 smpret7el60 lgprent7el60 smprent7el60 qmv members cooperation codecision directive backlog100 Aug if year1976_06==1, ///
tvc(lgpret7el60 lgprent7el60 smprent7el60 members cooperation codecision directive backlog100 Aug) texp(ln(_t)) nohr robust


drop case_id - _t0
drop duration
drop if [_n]>1

save "Output\NatEl_output_robust.dta", replace

