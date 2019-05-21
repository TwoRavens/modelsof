 
* ***************************************************************** *
* ***************************************************************** *
*   File-Name:      debate.do                                       *  
*   Date:           January 18, 2019                                *
*   Author:         TG                                              *
*   Purpose:      	Appendix D (German Case Study):                 *
*                   It’s Not Only What you Say, It’s Also How You   *
*                   Say It: The Strategic Use of Campaign Sentiment *
*                   Charles Crabtree, Matt Golder, Thomas Gschwend, *
*                   Indridi Indridason                              *
*                   Forthcoming, Journal of Politics                *
*                                                                   *
*   Input File:     debate.dta                                      *
*                   Subset of ZA5709_v3-0-0.dta (debate panel 2013) *              
*   Output File:                                                    *
*   Data Output:    none                                            *             
* ****************************************************************  *
* ****************************************************************  *



clear
set more off



* ********************************************************************* * 
*       Data from 2013 - TV debate panel study             
* 	    Input File:     ZA5709_v3-0-0                                    
*       Data Output:    none                                       
* ********************************************************************  * 

* We dropped 11 observations that did not participate in 
* pre- and posttest (Wave 1 & 2) using the following code:
* keep if teil12 == 1  

* Load subset of TV Debate panel data
use debate, clear



mvdecode a6 a8 a9 a10 a12 a13 b6 b8 b9 b10 b12 b13, mv(-99=. \ -95=.) /* get rid of missing values */


*** EVALUTATION variables and labels for Wave I (pre-debate)

* We recode the relevant EVALUATION variables of the original data (ZA5709 Data file Version 3.0.0)
* such that higher values indicate more positive evaluations


* Thus, recoding 1->5, 2->4 yields the new EVALUATION variables
gen a6new  = - a6  + 6
gen a8new  = - a8  + 6
gen a9new  = - a9  + 6
gen a10new = - a10 + 6
gen a12new = - a12 + 6
gen a13new = - a13 + 6

* How has your own economic situation developed in the last one to two years? 
label define improve 5 "improved a lot"  4 "improved a bit"  3 "stayed the same" 2 "got a bit worse" 1 "got a lot worse"
label values a6new improve 
label variable a6new  "Own economic situation, retrospective"

* How do you currently rate your own economic situation?
label define good 5 "very good"  4 "good"  3 "partly good, partly bad" 2 "bad" 1 "very bad"
label values a8new good 
label variable a8new  "Own economic situation, current"

* What do you think? How will your own economic situation be like in a year's time?
label values a9new improve 
label variable a9new  "Own economic situation, prospective"

* How has the economic situation in Germany developed in the last one to two years? 
label values a10new improve 
label variable a10new  "General economic situation, retrospective"

* How do you currently rate the economic situation in Germany?
label values a12new good 
label variable a12new  "General economic situation, current"

* How will the economic situation in Germany be in a year's time? 
label values a13new improve 
label variable a13new  "General economic situation, prospective"


*** EVALUTATION variables and abels for Wave II (post-debate)

* Thus, recoding 1->5, 2->4 yields the new EVALUATION variables
gen b6new  = - b6  + 6
gen b8new  = - b8  + 6
gen b9new  = - b9  + 6
gen b10new = - b10 + 6
gen b12new = - b12 + 6
gen b13new = - b13 + 6


* How has your own economic situation developed in the last one to two years? 
label values b6new improve 
label variable b6new  "Own economic situation, retrospective"

* How do you currently rate your own economic situation?
label values b8new good 
label variable b8new  "Own economic situation, current"

* What do you think? How will your own economic situation be like in a year's time?
label values b9new improve 
label variable b9new  "Own economic situation, prospective"

* How has the economic situation in Germany developed in the last one to two years? 
label values b10new improve 
label variable b10new  "General economic situation, retrospective"

* How do you currently rate the economic situation in Germany?
label values b12new good 
label variable b12new  "General economic situation, current"

* How will the economic situation in Germany be in a year's time? 
label values b13new improve 
label variable b13new  "General economic situation, prospective"




*************************
** Dependent Variables **
*************************

* Calculate each DV as FD, i.e., difference EVALUATION_{t_2} - EVALUATION_{t_1} 
* to leverage pre-post design with TV debate as "treatment"
* Thus, we have six DVs

gen dif6  = b6new  -a6new
gen dif8  = b8new  -a8new
gen dif9  = b9new  -a9new
gen dif10 = b10new -a10new
gen dif12 = b12new -a12new
gen dif13 = b13new -a13new

label variable dif6  "FD own economic situation, retrospective"
label variable dif8  "FD own economic situation, current"
label variable dif9  "FD own economic situation, prospective" 
label variable dif10 "FD general economic situation, retrospective"
label variable dif12 "FD general economic situation, current"
label variable dif13 "FD general economic situation, prospective"    


**************************
** Independent Variable **
**************************


* Operationalize PM  supporters using the direct measurement prior to debate
* "Who do you prefer as chanellor?" (direct measurement: Merkel or Steinbrück)


mvdecode a38, mv(-99=. \ -95=.) /* get rid of missing values */

gen merkel =   (a38==1)               // Merkel supporter = 1, undecided = ., Steinbrueck supporter = 0
replace merkel = . if a38==3
replace merkel = . if a38==.
label define yesno 1 "yes"  0 "no"  
label values merkel yesno  
label variable merkel  "PM supporter (Merkel)"




******************
** OLS Analysis **
******************


* We know from the debate that PM Angela Merkel (CDU) employed more positive emotive language 
* than her opponent, Peer Steinbrück (SPD). We expect to see the prime minister’s supporters 
* increase their evaluation of the economy and the government over the course of the debate more 
* than supporters of Steinbrück, i.e. a positive coefficient in the following regressions.



reg dif6  merkel // Regression on FD own economic situation, retrospective
reg dif8  merkel // Regression on FD own economic situation, current
reg dif9  merkel // Regression on FD own economic situation, prospective
reg dif10 merkel // Regression on FD general economic situation, retrospective
reg dif12 merkel // Regression on FD general economic situation, current
reg dif13 merkel // Regression on FD general economic situation, prospective   

* No matter how respondnets evaluate their own  economic situation (currently, retrospectively or prospectively)
* or the general economic situation (currently, retrospectively or prospectively) the respective coefficients 
* are positive. It is statistically significant when evaluating the state of the current economy.


exit
