 * french-surveys.do --- 
 * 
 * Filename: french-surveys.do
 * Description: Demonstrate use of B, B_w etc.
 * w French pre-election surveys
 * Author: Arzheimer & Evans
 * 
 *

 * Commentary: 
 * 
 * 
 * 
 */

 * Change log:
 * 
 * 
 *

* Load data
use frenchsurveys.dta, replace
format dateref %d
* Only look at polls between March 22 and April 20 
keep if dateref >19073 & dateref != . 

* Keep only Bs that are signficant
preserve
keep if chi2_p<= 0.05 | chi2lr_p <=0.05
keep dateref pollster b_w id noofcand
* Averages
tabstat b_w,by(noofcand)
* Go from long to wide for table
reshape wide b_w,i(id) j(noofcand)

format b_w* %9.3f
list dateref pollster b_w*

* restore full DS
restore

* generate root of N 
gen rootn = sqrt(n)

* generate days-to-election var
gen daystoelec = 19105 - dateref

* Create pollsterdummies
capture drop pollsterdummy*
qui tab pollster,gen(pollsterdummy)

* Multivariable fractional polynomial model
mfp: reg b_w noofcand n daystoelec pollsterdummy1-pollsterdummy6 pollsterdummy8

* Plot marginal effects

* Effect of days to election

graph twoway function y= (((x/10)^2-2.021728516) * .0201321) +  (((x/10)^3-2.874645233) * -.0059554) , range(2 31) xtitle("Days to election") ytitle("Marginal Effect")
graph export margdays.eps, replace

* Effect for number of candidates
* Add dots
local x = 2
local two = (`x'^-2 -.049382716) * -0.32 * `x'
local x = 3
local three = (`x'^-2 -.049382716) * -0.32 * `x'
local x = 5
local five = (`x'^-2 -.049382716) * -0.32 * `x'
local x = 8
local eight = (`x'^-2 -.049382716) * -0.32 * `x'

graph twoway (function y= (x^-2 -.049382716) * -0.32 *x, range(2 8)) (scatteri `two' 2 `three' 3 `five' 5 `eight' 8) , xtitle("Number of candidates") ytitle("Marginal Effect") legend(off)
graph export margcandidates.eps, replace

* french-surveys.do ends here 
