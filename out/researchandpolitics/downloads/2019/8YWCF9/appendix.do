********************************************************************************
***Figure A: Coefplot ABS
set scheme s1mono
use Zhubajie.dta, clear
append using abs.dta

lab var female "Female"
lab var age "Age"
lab var married "Married"
lab var yearsedu "Years of Educ"
lab var employed "Employed"
lab var familyinc2 "Household Inc"
lab var educ2 "College"

gen internet=internet_abs2 if dataset==1
replace internet=1 if dataset==0


foreach z of varlist S2 {
foreach x of varlist ptrust trust_ngovt trust_lgovt pride {
quiet reg `x' female age2 married educ2 employed familyinc2 if dataset==0&internet==1&age<=55&`z'==1
eststo `x'_witmart

quiet reg `x' female age2 married educ2 employed familyinc2 if dataset==0&internet==1&age<=55&`z'==1 [pw=wt_internet]
eststo `x'_witmart2

quiet reg `x' female age2 married educ2 employed familyinc2 if dataset==1&internet==1&age<=55
eststo `x'_abs

 }
 *
 
 coefplot (trust_ngovt_witmart,msymbol(T) label("Zhubajie")  offset(0.2)) ///
(trust_ngovt_witmart2,msymbol(O) label("Zhubajie (Weighted)")  offset(0)) ///
 (trust_ngovt_abs,msymbol(S) label("ABS (Internet Users)") offset(-0.2)), bylabel(Trust Central Govt)|| ///
 (trust_lgovt_witmart,msymbol(T) label("Zhubajie") offset(0.2)) ///
(trust_lgovt_witmart2,msymbol(O) label("Zhubajie (Weighted)") offset(0)) ///
 (trust_lgovt_abs,msymbol(S) label("ABS (Internet Users)") offset(-0.2)), bylabel(Trust Local Govt)|| ///
 (ptrust_witmart,msymbol(T) label("Zhubajie") offset(0.2)) ///
(ptrust_witmart2,msymbol(O) label("Zhubajie (Weighted)") offset(0)) ///
 (ptrust_abs,msymbol(S) label("ABS (Internet Users)") offset(-0.2)), bylabel(Interpersonal Trust) || ///
  (pride_witmart,msymbol(T) label("Zhubajie") offset(0.2)) ///
(pride_witmart2,msymbol(O) label("Zhubajie (Weighted)") offset(0)) ///
 (pride_abs,msymbol(S) label("ABS (Internet Users, Weighted)")  offset(-0.2)), bylabel(National Pride ) || ///
 , xline(0, lpattern(dash)) ci(95) ciopts(lcol(black)) mfcolor(black) mcolor(black) ///
drop(_cons) graphregion(color(white)) bgcolor(white) ///
legend(pos(7) region(style(none)) row(1) size(small)) byopts(xrescale cols(4)) ///
 xsize(6.5) ysize(3.5) 
}
*/ 
 
********************************************************************************
***Figure B: Coefplot WVS

use Zhubajie.dta, clear
append using wvs.dta

lab var female "Female"
lab var age2 "Age"
lab var married "Married"
lab var educ2 "College"
lab var employed "Employed"
lab var ccp "CCP"

replace internet=1 if dataset==0


foreach z of varlist S2 {
foreach x of varlist trust_ngovt ptrust pride {
quiet reg `x' female age2 married educ2 employed ccp if dataset==0&internet==1&age<=55&`z'==1
eststo `x'_witmart

quiet reg `x' female age2 married educ2 employed ccp if dataset==0&internet==1&age<=55&`z'==1 [pw=wt_internet]
eststo `x'_witmart2

quiet reg `x' female age2 married educ2 employed ccp if dataset==1&internet==1&age<=55 [pw=V258_wvs]
eststo `x'_wvs
 }
 *
coefplot (trust_ngovt_witmart,msymbol(T) label("Zhubajie")  offset(0.2)) ///
 (trust_ngovt_witmart2,msymbol(O) label("Zhubajie (Weighted)")  offset(0)) ///
 (trust_ngovt_wvs,msymbol(S) label("WVS (Internet Users)") offset(-0.2)), bylabel(Trust National Govt)|| ///
 (ptrust_witmart,msymbol(T) label("Zhubajie") offset(0.2)) ///
 (ptrust_witmart2,msymbol(O) label("Zhubajie (Weighted)") offset(0)) ///
 (ptrust_wvs,msymbol(S) label("WVS (Internet Users)") offset(-0.2)), bylabel(Interpersonal Trust) || ///
 (pride_witmart,msymbol(T) label("Zhubajie") offset(0.2)) ///
 (pride_witmart2,msymbol(O) label("Zhubajie (Weighted)") offset(0)) ///
 (pride_wvs,msymbol(S) label("WVS (Internet Users, Weighted)")  offset(-0.2)), bylabel(National Pride ) || ///
 , xline(0, lpattern(dash)) ci(95) ciopts(lcol(black)) mfcolor(black) mcolor(black) ///
 drop(_cons) graphregion(color(white)) bgcolor(white) ///
 legend(pos(7) region(style(none)) row(1) size(small)) byopts(xrescale cols(3)) ///
 xsize(4.8) ysize(3.5) 
}
*
 
********************************************************************************
***Figure C: Coefplot: China Survey
 
use Zhubajie.dta, clear
append using cs.dta

lab var female "Female"
lab var age2 "Age"
lab var married "Married"
lab var yearsedu "Years of Edu"
lab var employed "Employed"
lab var familyinc "Household Inc"
lab var urban "Urban"
lab var ccp "CCP"
lab var minority "Minority"

replace internet=1 if dataset==0

foreach z of varlist S2 {
foreach x of varlist ptrust pride equality {

quiet reg `x' female age2  married yearsedu employed familyinc urban ccp minority if dataset==0&internet==1&age<=55&`z'==1 
eststo `x'_witmart

quiet reg `x' female age2  married yearsedu employed familyinc urban ccp minority if dataset==0&internet==1&age<=55&`z'==1 [pw=wt_internet]
eststo `x'_witmart2

quiet reg `x' female age2  married yearsedu employed familyinc urban ccp minority if dataset==1&internet==1&age<=55 [pw=wt_psbfc_cs]
eststo `x'_cs
 }
 *
coefplot (ptrust_witmart,msymbol(T) label("Zhubajie") offset(0.2)) ///
 (ptrust_witmart2,msymbol(O) label("Zhubajie (Weighted)") offset(0)) ///
 (ptrust_cs,msymbol(S) label("CS (Internet Users)") offset(-0.2)), bylabel(Interpersonal Trust) || ///
 (pride_witmart,msymbol(T) label("Zhubajie") offset(0.2)) ///
 (pride_witmart2,msymbol(O) label("Zhubajie (Weighted)") offset(0)) ///
 (pride_cs,msymbol(S) label("CS (Internet Users)")  offset(-0.2)), bylabel(National Pride ) || ///
 (equality_witmart,msymbol(T) label("Zhubajie")  offset(0.2)) ///
 (equality_witmart2,msymbol(O) label("Zhubajie (Weighted)")  offset(0)) ///
 (equality_cs,msymbol(S) label("CS (Internet Users, Weighted)") offset(-0.2)), bylabel(Equality)|| ///
 , xline(0, lpattern(dash)) ci(95) ciopts(lcol(black)) mfcolor(black) mcolor(black) ///
 drop(_cons) graphregion(color(white)) bgcolor(white) ///
 legend(pos(7) region(style(none)) row(1) size(small)) byopts(xrescale cols(3)) ///
 xsize(4.8) ysize(3.5) 
 }

* 
********************************************************************************
***Figure D: Coefplot CGSS

use Zhubajie.dta, clear
append using cgss.dta

lab var female "Female"
lab var age2 "Age"
lab var married "Married"
lab var yearsedu "Years of Edu"
lab var employed "Employed"
lab var familyinc "Household Inc"
lab var urban "Urban"
lab var ccp "CCP"
lab var minority "Minority"

replace internet=1 if dataset==0

foreach z of varlist S2 {
quiet reg ptrust female age2 married educ employed familyinc urban ccp minority if dataset==0&internet==1&age<=55&`z'==1  
eststo ptrust_witmart

quiet reg ptrust female age2 married educ employed familyinc urban ccp minority if dataset==0&internet==1&age<=55&`z'==1 [pw=wt_internet]
eststo ptrust_witmart2

quiet reg ptrust female age2 married educ employed familyinc urban ccp minority if dataset==1&internet==1&age<=55
eststo ptrust_cgss

coefplot (ptrust_witmart,msymbol(T) label("Zhubajie") offset(0.2)) ///
 (ptrust_witmart2,msymbol(O) label("Zhubajie (Weighted)") offset(0)) ///
 (ptrust_cgss,msymbol(S) label("CGSS (Internet Users)") offset(-0.2)) ///
 , xline(0, lpattern(dash)) ci(95) ciopts(lcol(black)) mfcolor(black) mcolor(black) ///
 drop(_cons) graphregion(color(white)) bgcolor(white) ///
 legend(pos(7) region(style(none)) row(2) size(small))  ///
 xsize(2.25) ysize(3.5)  title("Interpersonal Trust") 
 }
 */
 
 
 
********************************************************************************
*****Inattentive Respondents
use Zhubajie.dta, clear

xtile familyinc4=familyinc if dataset==0, nq(4)
replace familyinc4=5 if familyinc==.

xtile perincdum=personalinc if dataset==0, nq(4)
replace perincdum=5 if personalinc==.

lab var female "Female"
lab var age "Age"
lab var minority "Minority"
lab var married "Married"
lab var yearsedu "Years of Educ"
lab var employed "Employed"
lab var familyinc4 "Household Inc"
lab var perincdum "Personal Inc"
lab var urban "Urban"
lab var ccp "CCP Member"

gen inattentive=1-S2

***Table C in Appendix: Inattentiveness (Logit)
*Model 1
logit inattentive female age  married yearsedu employed  urban ccp minority

*Model 2
logit inattentive female age  married yearsedu employed  urban ccp minority i.perincdum

*Model 3
logit inattentive female age  married yearsedu employed  urban ccp minority i.familyinc4


*** Figure E
foreach x of varlist trust_ngovt trust_lgovt ptrust pride equality{ 
quiet reg `x' female age  married yearsedu employed familyinc urban ccp minority if S2==1
eststo `x'_witmart1
quiet reg `x' female age  married yearsedu employed familyinc urban ccp minority 
eststo `x'_witmart2
quiet reg `x' female age  married yearsedu employed familyinc urban ccp minority if S2==0
eststo `x'_witmart3
}
*/

coefplot (trust_ngovt_witmart1,msymbol(T) label("Attentive") offset(0.2)) ///
 (trust_ngovt_witmart2,msymbol(O) label("Fuall Sample") offset(0)) ///
 (trust_ngovt_witmart3,msymbol(O) label("Inattentive") offset(-0.2)),bylabel(Trust Central Govt)|| ///
 (trust_lgovt_witmart1,msymbol(T) label("Attentive") offset(0.2)) ///
 (trust_lgovt_witmart2,msymbol(O) label("Fuall Sample") offset(0)) ///
 (trust_lgovt_witmart3,msymbol(O) label("Inattentive") offset(-0.2)),bylabel(Trust Local Govt) || ///
 (ptrust_witmart1,msymbol(T) label("Attentive") offset(0.2)) ///
 (ptrust_witmart2,msymbol(O) label("Full Sample") offset(0)) ///
 (ptrust_witmart3,msymbol(O) label("Inattentive") offset(-0.2)),bylabel(Interpersonal Trust) || ///
 (pride_witmart1,msymbol(T) label("Attentive") offset(0.2)) ///
 (pride_witmart2,msymbol(O) label("Full Sample") offset(0)) ///
 (pride_witmart3,msymbol(O) label("Inattentive") offset(-0.2)),bylabel(National Pride) || ///
 (equality_witmart1,msymbol(T) label("Attentive") offset(0.2)) ///
 (equality_witmart2,msymbol(O) label("Full Sample") offset(0)) ///
 (equality_witmart3,msymbol(O) label("Inattentive") offset(-0.2)),bylabel(Equality) || ///
 , xline(0, lpattern(dash)) ci(95) ciopts(lcol(black)) mfcolor(black) mcolor(black) ///
 drop(_cons) graphregion(color(white)) bgcolor(white) ///
 legend(pos(7) region(style(none)) row(1) size(small)) byopts(xrescale cols(5))  ///
 xsize(8.5) ysize(4)  

 
********************************************************************************
*****Table F: Zhubajie vs Witmart
use Zhubajie.dta, clear
*dichotomize attitudinal measures
recode trust_ngovt (1/2=1)(3/4=0)
recode trust_lgovt (1/2=1)(3/4=0)
recode pride (1/2=1)(3/4=0)
recode equality (1/2=1)(3/5=0)

append using witmart

foreach var of varlist age female yearsedu urban ccp employed ptrust trust_ngovt trust_lgovt pride equality {
ttest `var', by(dataset)
}
*/

********************************************************************************
***Table G: Correlation of the Five Attitudinal Measures
use Zhubajie.dta, clear
pwcorr trust_ngovt trust_lgovt ptrust pride equality
 
********************************************************************************
***** Sample Balance Checks: List Experiments
use Zhubajie.dta, clear
drop if S2==0

* Table H: Sample Balance Check: List Experiment 1 
local counter=1
foreach var of varlist agedum* female college IndInc* pubemp privemp ccp managers urban {
if `counter'==1{
 ttest `var', by(ListRandom1)
 matrix ttest= ( r(mu_2), r(sd_2)/sqrt(r(N_2)),r(N_2), r(mu_1), r(sd_1)/sqrt(r(N_1)),r(N_1), r(mu_1) - r(mu_2), r(se), r(p))
 matrix rownames ttest= `var'
 matrix colnames ttest= mean1 se1 N1 mean2 se2 N2 mean_differences se pvalue
 mat2txt, matrix(ttest) sav(samplebalance_list1.xls) replace
 }
 else{
 ttest `var', by(ListRandom1)
 matrix ttest= ( r(mu_2), r(sd_2)/sqrt(r(N_2)),r(N_2), r(mu_1), r(sd_1)/sqrt(r(N_1)),r(N_1), r(mu_1) - r(mu_2), r(se), r(p))
 matrix rownames ttest= `var'
 matrix colnames ttest= mean1 se1 N1 mean2 se2 N2 mean_differences se pvalue
 mat2txt, matrix(ttest) sav(samplebalance_list1.xls) append
 }
 local counter=0
 }
 *
 
 * Table I: Sample Balance Check: List Experiment 2 
 local counter=1
foreach var of varlist agedum* female college IndInc* pubemp privemp ccp managers urban {
if `counter'==1{
 ttest `var', by(ListRandom2)
 matrix ttest= (r(mu_2), r(sd_2)/sqrt(r(N_2)),r(N_2), r(mu_1), r(sd_1)/sqrt(r(N_1)),r(N_1), r(mu_1) - r(mu_2), r(se), r(p))
 matrix rownames ttest= `var'
 matrix colnames ttest= mean1 se1 N1 mean2 se2 N2 mean_differences se pvalue
 mat2txt, matrix(ttest) sav(samplebalance_list2.xls) replace
 }
 else{
  ttest `var', by(ListRandom2)
 matrix ttest= (r(mu_2), r(sd_2)/sqrt(r(N_2)),r(N_2), r(mu_1), r(sd_1)/sqrt(r(N_1)),r(N_1), r(mu_1) - r(mu_2), r(se), r(p))
 matrix rownames ttest= `var'
 matrix colnames ttest= mean1 se1 N1 mean2 se2 N2 mean_differences se pvalue
 mat2txt, matrix(ttest) sav(samplebalance_list2.xls) append
 }
 local counter=0
 }
*
 * Table J: Sample Balance Check: List Experiment 3 
 local counter=1
foreach var of varlist agedum* female college IndInc* pubemp privemp ccp managers urban {
if `counter'==1{
 ttest `var', by(ListRandom3)
 matrix ttest= (r(mu_2), r(sd_2)/sqrt(r(N_2)),r(N_2), r(mu_1), r(sd_1)/sqrt(r(N_1)),r(N_1), r(mu_1) - r(mu_2), r(se), r(p))
 matrix rownames ttest= `var'
 matrix colnames ttest= mean1 se1 N1 mean2 se2 N2 mean_differences se pvalue
 mat2txt, matrix(ttest) sav(samplebalance_list3.xls) replace
 }
 else{
  ttest `var', by(ListRandom3)
 matrix ttest= (r(mu_2), r(sd_2)/sqrt(r(N_2)),r(N_2), r(mu_1), r(sd_1)/sqrt(r(N_1)),r(N_1), r(mu_1) - r(mu_2), r(se), r(p))
 matrix rownames ttest= `var'
 matrix colnames ttest= mean1 se1 N1 mean2 se2 N2 mean_differences se pvalue
 mat2txt, matrix(ttest) sav(samplebalance_list3.xls) append
 }
 local counter=0
 }
*

 * Table K: Sample Balance Check: List Experiment 4 
local counter=1
foreach var of varlist agedum* female college IndInc* pubemp privemp ccp managers urban {
if `counter'==1{
 ttest `var', by(ListRandom4)
 matrix ttest= (r(mu_2), r(sd_2)/sqrt(r(N_2)),r(N_2), r(mu_1), r(sd_1)/sqrt(r(N_1)),r(N_1), r(mu_1) - r(mu_2), r(se), r(p))
 matrix rownames ttest= `var'
 matrix colnames ttest= mean1 se1 N1 mean2 se2 N2 mean_differences se pvalue
 mat2txt, matrix(ttest) sav(samplebalance_list4.xls) replace
 }
 else{
 ttest `var', by(ListRandom4)
 matrix ttest= (r(mu_2), r(sd_2)/sqrt(r(N_2)),r(N_2), r(mu_1), r(sd_1)/sqrt(r(N_1)),r(N_1), r(mu_1) - r(mu_2), r(se), r(p))
 matrix rownames ttest= `var'
 matrix colnames ttest= mean1 se1 N1 mean2 se2 N2 mean_differences se pvalue
 mat2txt, matrix(ttest) sav(samplebalance_list4.xls) append
 }
 local counter=0
 }
*/
 
