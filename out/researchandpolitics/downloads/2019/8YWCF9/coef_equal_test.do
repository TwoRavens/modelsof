*** Set Working Directory ******************************************************
********************* Coefficient Equality Test ********************************
use Zhubajie.dta, clear

*One loop: lines 6-512
foreach i of varlist S S2{

*********Zhubajie vs ABS *************
use Zhubajie.dta, clear
drop if `i'==0
append using abs.dta

foreach x of varlist wt_census wt_internet {
replace `x'=CNweight if dataset==1
}
*/
gen internet=internet_abs2 if dataset==1
replace internet=1 if dataset==0

*test with interactions and constant

 foreach var of varlist female age2 married educ2 employed familyinc2 {
 gen `var'_d=`var'*dataset
 }
 */
 
foreach dv of varlist ptrust trust_ngovt trust_lgovt pride {
 * internet users<55, unweighted
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset if internet==1&age<=55 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs.csv) replace
 
 * internet users, unweighted
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset if internet==1
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs.csv) append
 
 * all pop <55, unweighted
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset if age<=55 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_all_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs.csv) append
 
foreach x of varlist wt_census wt_internet {
 gen weights=`x' if dataset==0
 replace weights=CNweight if dataset==1
 if strpos("`x'","internet")!=0{
 * internet users<55, weighted
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset [pw=weights] if internet==1&age<=55
 }
 else {
 * all pop<55, weighted
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset [pw=weights] if age<=55
 }
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs.csv) append
 
 * internet users, weighted
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset [pw=weights] if internet==1
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs.csv) append
 }
 drop weights
 }
 }
 */

 *test with interactions only
foreach dv of varlist ptrust trust_ngovt trust_lgovt pride {
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset if internet==1&age<=55 
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d]  
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs2.csv) replace
 
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset if internet==1
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d]  
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs2.csv) append
 
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset if age<=55 
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d]  
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_all_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs2.csv) append
 
foreach x of varlist wt_census wt_internet {
 gen weights=`x' if dataset==0
 replace weights=CNweight if dataset==1
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset [pw=weights] if internet==1&age<=55
 }
 else {
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset [pw=weights] if age<=55
 }
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d] 
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs2.csv) append
 
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 married educ2 employed familyinc2 *_d dataset [pw=weights] if internet==1
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[familyinc2_d] 
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_abs2.csv) append
 }
 drop weights
 }
 }
*/

***************************** Zhubajie vs CGSS *******************************
use Zhubajie.dta, clear
drop if `i'==0
append using cgss.dta

foreach x of varlist wt_census wt_internet {
replace `x'=1 if dataset==1
}
*/

replace internet=1 if dataset==0

 foreach var of varlist female age2 minority married educ employed familyinc urban ccp {
 gen `var'_d=`var'*dataset
 }
 */
*test with interactions and constant

 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if internet==1&age<=55 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss.csv) replace
 
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if internet==1 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss.csv) append
 
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if age<=55 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_all_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss.csv) append
 
foreach x of varlist wt_census wt_internet {
 gen weights=`x' if dataset==0
 replace weights=1 if dataset==1
 if strpos("`x'","internet")!=0{
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if internet==1&age<=55 [pw=weights]
 }
 else{
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if age<=55 [pw=weights]
 }
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss.csv) append
 
 if strpos("`x'","internet")!=0{
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if internet==1 [pw=weights]
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d], accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss.csv) append
 }
 drop weights
 }
 */

 // test interaction terms only
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if internet==1&age<=55 

 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d] 
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss2.csv) replace
 
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if internet==1 
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d] 
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss2.csv) append
 
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if age<=55 
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d] 
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_all_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss2.csv) append
 
foreach x of varlist wt_census wt_internet {
 gen weights=`x' if dataset==0
 replace weights=1 if dataset==1
 if strpos("`x'","internet")!=0{
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if internet==1&age<=55 [pw=weights]
 }
 else{
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if age<=55 [pw=weights]
 }
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss2.csv) append
 
 if strpos("`x'","internet")!=0{
 reg ptrust female age2 minority married educ employed familyinc urban ccp *_d dataset if internet==1 [pw=weights]
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[educ_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(ptrust_`i'_cgss2.csv) append
 }
 drop weights
 }
 */


*********************** Zhubajie vs CS ************************************

use Zhubajie.dta, clear
drop if `i'==0
append using cs.dta

replace internet=1 if dataset==0

recode familyinc (17/19=16) if dataset==0

foreach x of varlist wt_census wt_internet {
replace `x'=wt_psbfc_cs if dataset==1
}
*/

 foreach var of varlist female age2 minority married yearsedu employed familyinc urban ccp {
 gen `var'_d=`var'*dataset
 }
 */
foreach dv of varlist ptrust pride equality {
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset if internet==1&age<=55 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs.csv) replace
 
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset if internet==1
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs.csv) append
 
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset if age<=55 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_all_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs.csv) append
 
foreach x of varlist wt_census wt_internet {
 gen weights=`x' if dataset==0
 replace weights=wt_psbfc_cs if dataset==1
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset [pw=weights] if internet==1&age<=55 
 }
 else{
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset [pw=weights] if age<=55 
 }
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs.csv) append
 
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset [pw=weights] if internet==1
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs.csv) append
 }
 drop weights
 }
 }
 */
 
//test interaction terms only

foreach dv of varlist ptrust pride equality {
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset if internet==1&age<=55 
 *test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs2.csv) replace
 
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset if internet==1 
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs2.csv) append
 
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset if age<=55 
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_all_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs2.csv) append
 
foreach x of varlist wt_census wt_internet {
 gen weights=`x' if dataset==0
 replace weights=wt_psbfc_cs if dataset==1
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset [pw=weights] if internet==1&age<=55 
 }
 else{
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset [pw=weights] if age<=55 
 }
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs2.csv) append
 
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 minority married yearsedu employed familyinc urban ccp *_d dataset [pw=weights] if internet==1
 test _b[female_d]=_b[age2_d]=_b[minority_d]=_b[married_d]=_b[yearsedu_d]=_b[employed_d]=_b[familyinc_d]=_b[urban_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_cs2.csv) append
 }
 drop weights
 }
 }
 */

************************* Zhubajie vs WVS *********************************
use Zhubajie.dta, clear
drop if `i'==0
append using wvs.dta

foreach x of varlist wt_census wt_internet {
replace `x'=V258_wvs if dataset==1
}
*/

replace internet=1 if dataset==0


 foreach var of varlist female age2 married educ2 employed ccp {
 gen `var'_d=`var'*dataset
 }
 */
* Test Interactions and Constant 
foreach dv of varlist ptrust trust_ngovt pride {
 reg `dv' female age2 married educ2 employed ccp *_d dataset if internet==1&age<=55 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs.csv) replace
 
 reg `dv' female age2 married educ2 employed ccp *_d dataset if internet==1
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs.csv) append
 
 reg `dv' female age2 married educ2 employed ccp *_d dataset if age<=55 
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_all_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs.csv) append
 
foreach x of varlist wt_census wt_internet {
 gen weights=`x' if dataset==0
 replace weights=V258_wvs if dataset==1
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 married educ2 employed ccp *_d dataset [pw=weights] if internet==1&age<=55 
 }
 else{
 reg `dv' female age2 married educ2 employed ccp *_d dataset [pw=weights] if age<=55 
 }
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs.csv) append
 
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 married educ2 employed ccp *_d dataset [pw=weights] if internet==1
 test _b[dataset] =0, notest
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d],accum
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs.csv) append
 }
 drop weights
 }
 }
 */

 //test interaction terms only
foreach dv of varlist ptrust trust_ngovt pride {
 reg `dv' female age2 married educ2 employed ccp *_d dataset if internet==1&age<=55 
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d] 
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs2.csv) replace
 
 reg `dv' female age2 married educ2 employed ccp *_d dataset if internet==1
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d] 
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_int
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs2.csv) append
 
 reg `dv' female age2 married educ2 employed ccp *_d dataset if age<=55 
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= unweighted_all_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs2.csv) append
 
foreach x of varlist wt_census wt_internet {
 gen weights=`x' if dataset==0
 replace weights=V258_wvs if dataset==1
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 married educ2 employed ccp *_d dataset [pw=weights] if internet==1&age<=55 
 }
 else{
 reg `dv' female age2 married educ2 employed ccp *_d dataset [pw=weights] if age<=55 
 }
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d] 
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'_55
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs2.csv) append
 
 if strpos("`x'","internet")!=0{
 reg `dv' female age2 married educ2 employed ccp *_d dataset [pw=weights] if internet==1
 test _b[female_d]=_b[age2_d]=_b[married_d]=_b[educ2_d]=_b[employed_d]=_b[ccp_d]
 matrix ttest= ( r(F), r(p))
 matrix rownames ttest= `x'
 matrix colnames ttest= F-stat P-value
 mat2txt, matrix(ttest) sav(`dv'_`i'_wvs2.csv) append
 }
 drop weights
 }
 }
 */
}
*/

******* Combine Test Results ***************************************************
// combine test results
clear

local files : dir . files "*_S*_*.csv"

local counter = 1
foreach x in `files' {

import delimited `x', varnames(1) clear 

gen id="`x'"
drop v4
drop if strpos(fstat,"F-stat")!=0
destring fstat pvalue, replace

*gen ind=v1=="unweighted"

*gsort ind -pvalue
*replace ind=_n if ind==0
*keep if ind<=3

if `counter'==1{ 
save results.dta, replace
}
else {
append using results.dta
save results.dta, replace
}
local counter=0
}
*/

gen dataset="abs" if strpos(id, "_abs")!=0
replace dataset="cgss" if strpos(id, "_cgss")!=0
replace dataset="cs" if strpos(id, "_cs")!=0
replace dataset="wvs" if strpos(id, "_wvs")!=0

gen sample="s" if strpos(id, "_s_")!=0
replace sample="s2" if strpos(id, "_s2_")!=0

gen test_cons=strpos(id, "2.csv")==0

gen model="ptrust" if strpos(id, "ptrust")!=0
replace model="trust_ngovt" if strpos(id, "trust_ngovt")!=0
replace model="trust_lgovt" if strpos(id, "trust_lgovt")!=0
replace model="pride" if strpos(id, "pride")!=0
replace model="equality" if strpos(id, "equality")!=0

gen dataID=1 if dataset=="abs"
replace dataID=2 if dataset=="wvs"
replace dataID=3 if dataset=="cs"
replace dataID=4 if dataset=="cgss"

gen modelID=1 if model=="trust_ngovt"
replace modelID=2 if model=="trust_lgovt"
replace modelID=3 if model=="ptrust"
replace modelID=4 if model=="pride"
replace modelID=5 if model=="equality"

sort sample test_cons dataID modelID


*************************************
**Table 3: Equality of Estimated Coefficients between Zhubajie and Benchmark Samples

** Zhubajie vs. Internet Users (Unweighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==1&v1=="unweighted_int"

** Zhubajie vs. Internet Users (Weighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==1&v1=="wt_internet"

** Zhubajie vs. Internet Users (Age<=55, Unweighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==1&v1=="unweighted_int_55"

** Zhubajie vs. Internet Users (Age<=55, Weighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==1&v1=="wt_internet_55"

*************************************
**Table A in Appendix
** Zhubajie vs. Internet Users (Unweighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==0&v1=="unweighted_int"

** Zhubajie vs. Internet Users (Weighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==0&v1=="wt_internet"

** Zhubajie vs. Internet Users (Age<=55, Unweighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==0&v1=="unweighted_int_55"

** Zhubajie vs. Internet Users (Age<=55, Weighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==0&v1=="wt_internet_55"

*************************************
* Tabe B in Appendix
** Zhubajie vs Benchmark Samples (Age<=55, Unweighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==1&v1=="unweighted_all_55"

** Zhubajie vs Benchmark Samples (Age<=55, Weighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==1&v1=="wt_census_55"

** Zhubajie vs Benchmark Samples Excluding Constants (Age<=55, Unweighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==0&v1=="unweighted_all_55"

** Zhubajie vs Benchmark Samples Excluding Constants (Age<=55, Weighted)
list dataset v1 id fstat pvalue if sample=="s2"&test_cons==0&v1=="wt_census_55"

*************************************
*Table D in Appendix: Zhubajie Sampe with Inattentive Respondents
** Zhubajie vs. Internet Users (Unweighted)
list dataset v1 id fstat pvalue if sample=="s"&test_cons==1&v1=="unweighted_int"

** Zhubajie vs. Internet Users (Weighted)
list dataset v1 id fstat pvalue if sample=="s"&test_cons==1&v1=="wt_internet"

** Zhubajie vs. Internet Users (Age<=55, Unweighted)
list dataset v1 id fstat pvalue if sample=="s"&test_cons==1&v1=="unweighted_int_55"

** Zhubajie vs. Internet Users (Age<=55, Weighted)
list dataset v1 id fstat pvalue if sample=="s"&test_cons==1&v1=="wt_internet_55"

*************************************
*Table E in Appendix: Zhubajie Sampe with Inattentive Respondents (Excluding Constsnts in Tests)
** Zhubajie vs. Internet Users (Unweighted)
list dataset v1 id fstat pvalue if sample=="s"&test_cons==0&v1=="unweighted_int"

** Zhubajie vs. Internet Users (Weighted)
list dataset v1 id fstat pvalue if sample=="s"&test_cons==0&v1=="wt_internet"

** Zhubajie vs. Internet Users (Age<=55, Unweighted)
list dataset v1 id fstat pvalue if sample=="s"&test_cons==0&v1=="unweighted_int_55"

** Zhubajie vs. Internet Users (Age<=55, Weighted)
list dataset v1 id fstat pvalue if sample=="s"&test_cons==0&v1=="wt_internet_55"
