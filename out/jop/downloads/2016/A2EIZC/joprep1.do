*********************************************
** Replication File **
** Title: Personal Experience and Public Opinion: A Theory and Test of Conditional Policy Feedback
** Authors: Amy E. Lerman and Katherine T. McCabe
** Journal: The Journal of Politics
** Analysis Data File name: joprep1.dta, Data derive from CCES 2012 Common Content
** **********************************************

** Load Data
clear
cd ""
use "joprep1.dta"


***************************************************************
** Balance Statistics Used to Construct Figure 2
****************************************************************

ttest polknsum, by(byr4647) unpaired unequal /* diff = .12; p =.0065 */
ttest badhealthindex, by(byr4647) unpaired unequal /* diff = -.10; p =0.0084 */
ttest educ, by(byr4647) unpaired unequal /* diff = .28; p =0.0000  */
ttest fincome, by(byr4647) unpaired unequal /* diff = .15; p =0.0990  */
ttest employed, by(byr4647) unpaired unequal /* diff = .09; p =0.0000 */
ttest hcsocial, by(byr4647) unpaired unequal /* diff = .01; p =0.2749  */
ttest finins, by(byr4647) unpaired unequal /* diff = -.01; p =0.2479 */
ttest healthcaresupport, by(byr4647) unpaired unequal /* diff = .00; p =0.8050  */
ttest genhealthd, by(byr4647) unpaired unequal /* diff = .06; p =0.0130 */
ttest healthcostyes, by(byr4647) unpaired unequal /* diff = .05; p =0.0000 */
ttest black, by(byr4647) unpaired unequal /* diff = .02; p = 0.0193 */
ttest hispanic2, by(byr4647) unpaired unequal /* diff = .01; p =0.3606  */
ttest married, by(byr4647) unpaired unequal /* diff = -.01; p = 0.2848 */
ttest rep, by(byr4647) unpaired unequal /* diff = .01; p = 0.6600  */
ttest dem, by(byr4647) unpaired unequal /* diff = -.01; p =0.4105 */
ttest ideology, by(byr4647) unpaired unequal /* diff = -.00; p =0.9479  */
ttest con, by(byr4647) unpaired unequal /* diff = .00; p =0.7852 */
ttest religimp, by(byr4647) unpaired unequal /* diff = .01; p =0.6785  */
ttest bornagain, by(byr4647) unpaired unequal /* diff = .02; p =0.0845 */
ttest newsint, by(byr4647) unpaired unequal /* diff = -.05; p =0.0038  */
ttest votereg, by(byr4647)unpaired unequal /* diff = .00; p = 0.4579 */
ttest vote08, by(byr4647)unpaired unequal /* diff = .01; p =0.1406 */
ttest labor, by(byr4647)unpaired unequal /* diff = .02; p =0.1273  */
ttest mobility, by(byr4647)unpaired unequal /* diff = .02; p =0.3290  */
ttest child18, by(byr4647)unpaired unequal /* diff = .02; p = 0.0001  */
ttest homeowner, by(byr4647)unpaired unequal /* diff = -.02; p = 0.0410  */
ttest publicemp, by(byr4647)unpaired unequal /* diff = .01; p = 0.5376  */
ttest famincmissing, by(byr4647)unpaired unequal /* diff = -.00; p = 0.9704 */


***************************************************************
** Main regressions 
****************************************************************

** Controls
local probcontrol ideostrength hcsocial finins healthcaresupport child18 male married labor mobility homeowner religimp employed votereg vote08 black hispanic2 military educ fincome newsint publicemp bornagain
local noempcontrol ideostrength hcsocial finins healthcaresupport child18 male married labor mobility homeowner religimp votereg vote08 black hispanic2 military educ fincome newsint publicemp bornagain


*******************************
** Table 1: First Stage Results
********************************

ivregress 2sls suppafford rep ind con mod `probcontrol' (privpubins3r = byr4647), first robust
estat first
ivregress 2sls dontcutmedicare rep ind con mod `probcontrol' (privpubins3r = byr4647), first robust
estat first

****************************************************************************
** Table 1: Second Stage Results (Repeated in full in Online Appendix)
****************************************************************************
ivregress 2sls suppafford rep ind con mod `probcontrol' (privpubins3r = byr4647), robust
ivregress 2sls dontcutmedicare rep ind con mod `probcontrol' (privpubins3r = byr4647), robust


***************************************
** Results Used to Construct Figure 3
** See R code for figure generation
******************************************

regress dontcutmedicare rep ind con mod `probcontrol' c.genhealthd##privpubins3r if byr4647 != .
margins, at(genhealthd = (1 2 3 4 5) privpubins3r = (0 1))


***************************************
** Results Used to Construct Figure 4
** See R code for figure generation
****************************************

* Coefficient on privpubins3r used in figure *
ivregress 2sls suppafford rep ind con mod `probcontrol' (privpubins3r = byr4647), robust
eststo: ivregress 2sls  suppafford con mod `probcontrol' (privpubins3r = byr4647) if rep == 1, robust
eststo: ivregress 2sls  suppafford con mod `probcontrol' (privpubins3r = byr4647) if dem == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if ind == 1, robust

* Coefficient on privpubins3r used in figure *
ivregress 2sls dontcutmedicare rep ind con mod `probcontrol' (privpubins3r = byr4647), robust
eststo: ivregress 2sls dontcutmedicare con mod `probcontrol' (privpubins3r = byr4647) if rep == 1, robust
eststo: ivregress 2sls dontcutmedicare con mod `probcontrol' (privpubins3r = byr4647) if dem == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if ind == 1, robust


*********************************************************
** Results Used to Construct Figure 5, and Online Appendix 
** See R code for figure generation
**********************************************************

* Coefficient on privpubins3r used in figure *
eststo: ivregress 2sls  suppafford rep ind con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 4 & polknsum != ., robust
eststo: ivregress 2sls suppafford  rep ind con mod `probcontrol' (privpubins3r = byr4647) if polknsum < 5, robust

* Coefficient on privpubins3r used in figure *
eststo: ivregress 2sls dontcutmedicare rep ind con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 4 & polknsum != ., robust
eststo: ivregress 2sls dontcutmedicare  rep ind con mod `probcontrol' (privpubins3r = byr4647) if polknsum < 5, robust




***************************************
** Results Used to Construct Figure 7
** See R code for figure generation
****************************************

* Coefficient on privpubins3r used in figure *
eststo: ivregress 2sls keystone rep ind con mod `probcontrol' (privpubins3r = byr4647), robust
eststo: ivregress 2sls samesex rep ind con mod `probcontrol' (privpubins3r = byr4647), robust
eststo: ivregress 2sls birthconexemp rep ind con mod `probcontrol' (privpubins3r = byr4647), robust
eststo: ivregress 2sls bordersec rep ind con mod `probcontrol' (privpubins3r = byr4647), robust




*******************************************
** Additional Results from Online Appendix
*******************************************

** Descriptive Statistics

* Public insurance *
mean suppafford if privpubins3 == 0 [pweight = V103]
mean dontcutmedicare if privpubins3 == 0 [pweight = V103]
* Private Insurance *
mean suppafford if privpubins3 == 1 [pweight = V103]
mean dontcutmedicare if privpubins3 == 1 [pweight = V103]
* No health insurance *
mean suppafford if nohealthins2 == 1 [pweight = V103]
mean dontcutmedicare if nohealthins2 == 1 [pweight = V103]
* Republicans *
mean suppafford if rep == 1 [pweight = V103]
mean dontcutmedicare if rep == 1 [pweight = V103]
* Democrats * 
mean suppafford  if dem == 1 [pweight = V103]
mean dontcutmedicare  if dem == 1 [pweight = V103]
* Independent *
mean suppafford  if ind == 1 [pweight = V103]
mean dontcutmedicare  if ind== 1 [pweight = V103]
* Liberal *
mean suppafford  if lib == 1 [pweight = V103]
mean dontcutmedicare  if lib== 1 [pweight = V103]
* Conservative *
mean suppafford  if con == 1 [pweight = V103]
mean dontcutmedicare  if con == 1 [pweight = V103]


* all respondents *
mean privhealthins2one [pweight = V103]
mean privhealthins2only [pweight = V103]
mean pubhealthins2one [pweight = V103]
mean nohealthins2 [pweight = V103]

* older *
mean privhealthins2one if byr4647 == 1 [pweight = V103]
mean privhealthins2only if byr4647 == 1 [pweight = V103]
mean pubhealthins2one if byr4647 == 1 [pweight = V103]
mean nohealthins2 if byr4647 == 1 [pweight = V103]

* younger *
mean privhealthins2one if byr4647 == 0 [pweight = V103]
mean privhealthins2only if byr4647 == 0 [pweight = V103]
mean pubhealthins2one if byr4647 == 0 [pweight = V103]
mean nohealthins2 if byr4647 == 0 [pweight = V103]



** Alternative Specifications of public and private
eststo: ivregress 2sls suppafford  rep ind con mod `probcontrol' (pubvother = byr4647), robust
eststo: ivregress 2sls dontcutmedicare  rep ind con mod `probcontrol' (pubvother = byr4647), robust



** Alternative ways to incorporate employment/retirement, See R code for figure generation
eststo: ivregress 2sls suppafford rep ind con mod `noempcontrol' (privpubins3r = byr4647) if employed == 1, robust
eststo: ivregress 2sls suppafford rep ind con mod `noempcontrol' (privpubins3r = byr4647) if retired == 1, robust
eststo: ivregress 2sls suppafford rep ind con mod `noempcontrol' (retired = byr4647), robust
eststo: ivregress 2sls suppafford rep ind con mod `noempcontrol' (socat = byr4647), robust

eststo: ivregress 2sls dontcutmedicare rep ind con mod `noempcontrol' (privpubins3r = byr4647) if employed == 1, robust
eststo: ivregress 2sls dontcutmedicare rep ind con mod `noempcontrol' (privpubins3r = byr4647) if retired == 1, robust
eststo: ivregress 2sls dontcutmedicare rep ind con mod `noempcontrol' (retired = byr4647), robust
eststo: ivregress 2sls dontcutmedicare rep ind con mod `noempcontrol' (socat = byr4647), robust


* Alternative Specifications By Party and Ideology *
foreach yvar in suppafford dontcutmedicare {

eststo: ivregress 2sls `yvar'  con mod `probcontrol' (privpubins3r = byr4647) if rep == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (privpubins3r = byr4647) if employed == 1 & rep == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (privpubins3r = byr4647) if retired == 1 & rep == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (retired = byr4647)if rep == 1, robust
eststo: ivregress 2sls `yvar' con mod `noempcontrol' (socat = byr4647) if rep == 1, robust
eststo: ivregress 2sls `yvar'  con mod `probcontrol' (pubvother = byr4647) if rep == 1, robust

eststo: ivregress 2sls `yvar'  con mod `probcontrol' (privpubins3r = byr4647) if dem == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (privpubins3r = byr4647) if employed == 1 & dem == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (privpubins3r = byr4647) if retired == 1 & dem == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (retired = byr4647)if dem == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (socat = byr4647) if dem == 1, robust
eststo: ivregress 2sls `yvar'  con mod `probcontrol' (pubvother = byr4647) if dem == 1, robust

eststo: ivregress 2sls `yvar'  con mod `probcontrol' (privpubins3r = byr4647) if ind == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (privpubins3r = byr4647) if employed == 1 & ind == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (privpubins3r = byr4647) if retired == 1 & ind == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (retired = byr4647)if ind == 1, robust
eststo: ivregress 2sls `yvar'  con mod `noempcontrol' (socat = byr4647) if ind == 1, robust
eststo: ivregress 2sls `yvar' con mod `probcontrol' (pubvother = byr4647) if ind == 1, robust

eststo: ivregress 2sls `yvar'  rep ind `probcontrol' (privpubins3r = byr4647) if lib == 1, robust
eststo: ivregress 2sls `yvar'  rep ind `noempcontrol' (privpubins3r = byr4647) if employed == 1 & lib == 1, robust
eststo: ivregress 2sls `yvar'  rep ind `noempcontrol' (privpubins3r = byr4647) if retired == 1 & lib == 1, robust
eststo: ivregress 2sls `yvar' rep ind `noempcontrol' (retired = byr4647)if lib == 1, robust
eststo: ivregress 2sls `yvar'  rep ind `noempcontrol' (socat = byr4647) if lib == 1, robust
eststo: ivregress 2sls `yvar' rep ind `probcontrol' (pubvother = byr4647) if lib == 1, robust

eststo: ivregress 2sls `yvar'  rep ind `probcontrol' (privpubins3r = byr4647) if con == 1, robust
eststo: ivregress 2sls `yvar'  rep ind `noempcontrol' (privpubins3r = byr4647) if employed == 1 & con == 1, robust
eststo: ivregress 2sls `yvar'  rep ind `noempcontrol' (privpubins3r = byr4647) if retired == 1 & con == 1, robust
eststo: ivregress 2sls `yvar' rep ind `noempcontrol' (retired = byr4647)if con == 1, robust
eststo: ivregress 2sls `yvar'  rep ind `noempcontrol' (socat = byr4647) if con == 1, robust
eststo: ivregress 2sls `yvar' rep ind `probcontrol' (pubvother = byr4647) if con == 1, robust

}



** By income
xtile inc3 = fincome, nq(3)
eststo: ivregress 2sls suppafford rep ind con mod `probcontrol' (privpubins3r = byr4647) if inc3 == 1, robust
eststo: ivregress 2sls suppafford rep ind con mod `probcontrol' (privpubins3r = byr4647) if inc3 == 2,  robust
eststo: ivregress 2sls suppafford rep ind con mod `probcontrol' (privpubins3r = byr4647) if inc3 == 3,  robust
eststo: ivregress 2sls dontcutmedicare  rep ind con mod `probcontrol' (privpubins3r = byr4647) if inc3 == 1, robust
eststo: ivregress 2sls dontcutmedicare  rep ind con mod `probcontrol' (privpubins3r = byr4647) if inc3 == 2, robust
eststo: ivregress 2sls dontcutmedicare  rep ind con mod `probcontrol' (privpubins3r = byr4647) if inc3 == 3, robust



** Results by party and ideology

** Republicans
eststo: ivregress 2sls  suppafford con mod `probcontrol' (privpubins3r = byr4647) if rep == 1, robust
eststo: ivregress 2sls dontcutmedicare con mod `probcontrol' (privpubins3r = byr4647) if rep == 1, robust
** Dems
eststo: ivregress 2sls  suppafford con mod `probcontrol' (privpubins3r = byr4647) if dem == 1, robust
eststo: ivregress 2sls dontcutmedicare con mod `probcontrol' (privpubins3r = byr4647) if dem == 1, robust
** Ind
eststo: ivregress 2sls  suppafford con mod `probcontrol' (privpubins3r = byr4647) if ind == 1, robust
eststo: ivregress 2sls dontcutmedicare con mod `probcontrol' (privpubins3r = byr4647) if ind == 1, robust
** Lib
eststo: ivregress 2sls  suppafford rep ind `probcontrol' (privpubins3r = byr4647) if lib == 1, robust
eststo: ivregress 2sls dontcutmedicare rep ind `probcontrol' (privpubins3r = byr4647) if lib == 1, robust
** Con
eststo: ivregress 2sls  suppafford rep ind `probcontrol' (privpubins3r = byr4647) if con == 1, robust
eststo: ivregress 2sls dontcutmedicare rep ind `probcontrol' (privpubins3r = byr4647) if con == 1, robust



* High vs. low knowledge by party *
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 4 & polknsum != . & rep == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum < 5 & rep == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 4 & polknsum != . & dem == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum < 5 & dem == 1, robust


eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 4 & polknsum != . & rep == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum < 5 & rep == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 4 & polknsum != . & dem == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum < 5 & dem == 1, robust


* High vs. medium vs. low knowledge by party *
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 5 & polknsum != . & rep == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 3 &  polknsum <= 5 & polknsum != .  & rep == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum <= 3 & polknsum != .  & rep == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 5 & polknsum != . & dem == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 3 &  polknsum <= 5 & polknsum != . & dem == 1, robust
eststo: ivregress 2sls suppafford  con mod `probcontrol' (privpubins3r = byr4647) if polknsum <= 3 & polknsum != . & dem == 1, robust


eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 5 & polknsum != . & rep == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 3 &  polknsum <= 5 & polknsum != . & rep == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum <= 3 & polknsum != . & rep == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 5 & polknsum != . & dem == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum > 3 &  polknsum <= 5 & polknsum != . & dem == 1, robust
eststo: ivregress 2sls dontcutmedicare  con mod `probcontrol' (privpubins3r = byr4647) if polknsum <= 3 & polknsum != . & dem == 1, robust

