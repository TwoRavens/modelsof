* This article replicates XXXXXX

* Set directory 
cd "..."

* Read data
use "MB_2018.dta"


* * * * * * * * * * Main Article* * * * * * * * 

* Table I

* Onset of terrorist campaigns in civil war

preserve
drop if prim_method==1
collapse (max) DT_max=DT, by (campaign )
tab DT_max
restore

* Onset terrorist campaigns in civil resistance

preserve
drop if prim_method==0
collapse (max) DT_max=DT, by (campaign)
tab DT_max
restore

* Figure 1) Distribution of duration of mass dissent 

histogram duration, discrete frequency fcolor(black) lcolor(black) xtitle(Mass dissent duration)

* Figure 2) Distribution of additional organizations

histogram camp_org, discrete frequency fcolor(black) lcolor(black) xtitle(Additional organizations)


* Table II

* Model 1)

logit DT  duration camp_org camp_size repression prim_method ///
    pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)	
	
outreg2 using Table2.doc,replace
	
* Model 2)

logit DT duration camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table2.doc,append

* Model 3)

logit DT duration camp_org camp_size repression prim_method ///
	log_popKSG log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table2.doc,append

* Marginal effects and predicted probabilities 

* Model 3)  

logit DT duration camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
* Marginal chance in probability
* For each additonal year the probability of terrorist campaign onset is  .005 higher on average.

margins, dydx(duration) predict(pr)

* Marginal change in propbability
* For a one unit increase in organizations the probability of terrorist campaign onset in Model 1 is  .062 higher on average.

margins, dydx(camp_org) predict(pr)

* Figure 1) predicted probability for duration
* Predicted probabilies of terrorist campaigns onset from 3 years to 15 years of struggle change from ... to ...

margins, predict(pr) at(duration=(1(5)40))
marginsplot,  recast(line) plot1opts(lc(black)) recastci(rline) ciopts(lpat(dash) lc(black)) graphr(c(white)) title("") xtitle("Mass dissent duration") ytitle("Probability of terrorism onset")

* Figure 2) predicted probability for repression levels
* Predicted probabilies of terrorist campaigns onset with different repression levels 

margins, predict(pr) at(camp_org=(0(1)5)) //from level 0 to level 3 of repression the probability on terrorist campaign onset change from .00 to .09
marginsplot, recast(line) plot1opts(lc(black)) recastci(rline) ciopts(lpat(dash) lc(black)) graphr(c(white)) title("") xtitle("New dissident organizations") ytitle("Probability of terrorism onset") 

* * * * * * * * * * Appendix* * * * * * * * 

* Table II) Descriptive statistics

sum DT duration camp_org  camp_size repression prim_method  log_popKSG log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy

* Table III) Collinearity diagnostics 

collin DT duration camp_org  camp_size repression prim_method Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy

* Table IV) Determinants of terrorist campaigns onset with standard errors clustered on campaign

* Model 1)

logit DT  duration camp_org camp_size repression prim_method ///
    pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (campaign_id)	
	
outreg2 using Table4.doc,replace
	
* Model 2)

logit DT duration camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (campaign_id)
	
outreg2 using Table4.doc,append

* Model 3)

logit DT  duration camp_org camp_size repression prim_method ///
log_popKSG log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (campaign_id)

outreg2 using Table4.doc,append

* Table V. Full Models for individual independent variables

* Model 1)

logit DT duration camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table5.doc,replace

* Model 2)

logit DT camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table5.doc,append

* Alternative mass dissent participation measures

* Table VI) Tabulation Dissident Campaign Participation
tab camp_size

* Table VII) The determinants of terrorist campaigns onset with dissident campaign participation variable grouping together the three highest values 

* Model 1)

logit DT  duration camp_org camp_size2 repression prim_method ///
    pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)	
	
outreg2 using Table7.doc,replace
	
* Model 2)

logit DT duration camp_org  camp_size2 repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table7.doc,append

* Model 3)

logit DT duration camp_org  camp_size2 repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia  Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table7.doc,append

* Table VIII) The determinants of terrorist campaigns onset with dissident campaign participation variable grouping together the two highest values variable with 2 highest values grouped

* Model 1) 

logit DT  duration camp_org camp_size3 repression prim_method ///
    pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)	
	
outreg2 using Table8.doc,replace
	
* Model 2) 

logit DT duration camp_org  camp_size3 repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table8.doc,append

* Model 3) 

logit DT duration camp_org  camp_size3 repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia  Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table8.doc,append

* Table IX) The determinants of terrorist campaigns onset using estimated campaign size using estimated campaign size as different ordinal variable

* Model 1) 

logit DT  duration camp_org camp_size_est repression prim_method ///
    pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)	
	
outreg2 using Table9.doc,replace
	
* Model 2) 

logit DT duration camp_org  camp_size_est repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table9.doc,append

* Model 3)

logit DT duration camp_org  camp_size_est repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia  Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table9.doc,append


* Table X) The Determinants of terrorist campaigns onset using number participants normalized by population

* Model 1) 

logit DT duration camp_org Nor_size repression prim_method ///
     pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table10.doc,replace

* Model 2) 

logit DT duration camp_org Nor_size repression prim_method log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table10.doc,append

* Model 3) 

logit DT duration camp_org  Nor_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia  Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table10.doc,append

* Test for curvilinear relationship duration terrorism onset, repression omission and dummies for repression 

* Table XI) Robustness checks for nonlinear duration-terrorism onset relation and on weather repression is driving the findings.	
* Model: transition model with splines and controls

* Model 1

logit DT duration durS camp_org camp_size repression prim_method log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table11.doc,replace

* Model2

logit DT  duration durS  camp_org camp_size prim_method log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table11.doc,append

* Model3

logit DT  duration camp_org camp_size prim_method log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table11.doc,append

* Table XII) Robustness checks for curvilinear repression-terrorism onset relation

* Model 1)

logit DT duration camp_org camp_size RL RM RH prim_method pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table12.doc,replace 

* Model 2)

logit DT duration camp_org camp_size RL RM RH prim_method log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table12.doc,append 

* Model 3)

logit DT duration camp_org camp_size RL RM RH prim_method log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table12.doc,append 

* Table XIII) Robustness checks for curvilinear additioanl oragizations-terrorism onset relation

* Model 1
logit DT duration camp_org org2 camp_size repression prim_method pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
outreg2 using Table13.doc,replace 

* Model 2
logit DT duration camp_org org2 camp_size repression prim_method log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
outreg2 using Table13.doc,append 

* Model 3
logit DT duration camp_org org2 camp_size repression prim_method log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
outreg2 using Table13.doc,append 

* Table XIV) Robustness checks lagged additional organizations on terrorism onset 

* Model 1) 

logit DT  duration l.camp_org  camp_size repression prim_method  pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table14.doc,replace

* Model 2)

logit DT  duration l.camp_org  camp_size repression prim_method ///
	log_popKSG log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table14.doc,append

* Model 3)

logit DT  duration l.camp_org camp_size repression prim_method ///
	log_popKSG log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

outreg2 using Table14.doc,append

* Alternative regime measures and nested models with alternative regime measure

* Table XV. The determinants of terrorist campaigns onset using polity2 score lagged one year.

* Model 1)

logit DT duration camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.polity pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table15.doc,replace

* Model 2)

logit DT duration camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.polity Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (campaign_id)
	
outreg2 using Table15.doc,append

* Do the effects of the core explanatory variables differ across different primary tactics of mass dissent?

* Table XVI) Nested Models with interaction terms between method of dissent and duration for group comparison 

* Model 1)

logit DT  duration camp_orgs camp_size repression prim_method nvdur pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id) 

outreg2 using Table16.doc,replace

* Test1

test prim_method-nvdur=0

* Model 2)

logit DT  duration camp_orgs camp_size repression prim_method nvdur log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id) 

outreg2 using Table16.doc,append

* Test2

test prim_method-nvdur=0

* Model 3) 

logit DT  duration camp_orgs camp_size repression prim_method nvdur log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id) 

outreg2 using Table16.doc,append

* Test3

test prim_method-nvdur=0

* Predicted Probabilities groups (violent/nonviolent) comparison.

* Figure 1. Predicted probabilities of terrorist campaigns onsets by mass dissident campaigns’ duration for different primary method of mass dissent (Appendix, Table XVI, Model 1)

logit DT camp_size repression camp_orgs duration i.prim_method#c.duration pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
testparm i.prim_method#c.duration
margins prim_method, at (duration = (1(10)40)) atmeans
marginsplot, scheme(sj) recast(line) plot1opts(lc(black)) plot2opts(lc(gs9)) recastci(rline) ci1opts(lpat(dash) lc(black)) ci2opts(lpat(dash) lc(gs9)) graphr(c(white)) title("") xtitle("Mass dissent duration") ytitle("Probability of terrorism onset") legend(label(3 "Large-scale civil war") label(4 "Mass civil resistance") order(3 4))

* Figure 2. Predicted probabilities of terrorist campaigns onsets by mass dissident campaigns’ duration for different primary method of mass dissent (Appendix, Table XVI, Model 2)

logit DT camp_size repression camp_orgs duration i.prim_method#c.duration log_popKSG log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
testparm i.prim_method#c.duration
margins prim_method, at (duration = (1(10)40)) atmeans
marginsplot, scheme(sj) recast(line) plot1opts(lc(black)) plot2opts(lc(gs9)) recastci(rline) ci1opts(lpat(dash) lc(black)) ci2opts(lpat(dash) lc(gs9)) graphr(c(white)) title("") xtitle("Mass dissent duration") ytitle("Probability of terrorism onset") legend(label(3 "Large-scale civil war") label(4 "Mass civil resistance") order(3 4))

* Figure 3. Predicted probabilities of terrorist campaigns onsets by mass dissident campaigns’ duration for different primary method of mass dissent (Appendix, Table XVI, Model 3)

logit DT camp_size repression camp_orgs duration i.prim_method#c.duration log_popKSG log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
testparm i.prim_method#c.duration
margins prim_method, at (duration = (1(10)40)) atmeans
marginsplot, scheme(sj) recast(line) plot1opts(lc(black)) plot2opts(lc(gs9)) recastci(rline) ci1opts(lpat(dash) lc(black)) ci2opts(lpat(dash) lc(gs9)) graphr(c(white)) title("") xtitle("Mass dissent duration") ytitle("Probability of terrorism onset") legend(label(3 "Large-scale civil war") label(4 "Mass civil resistance") order(3 4))

* Table XVII. Nested Models with interaction terms between method of dissent and additional organizations for group comparison

* Model 1) 

logit DT  duration camp_orgs camp_size repression prim_method nvorg pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id) 

outreg2 using Table17.doc,replace

* Test4

test prim_method-nvorg=0

* Model 2)

logit DT  duration camp_orgs camp_size repression prim_method nvorg log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id) 

outreg2 using Table17.doc,append

* Test5

test prim_method-nvorg=0

* Model 3)

logit DT  duration camp_orgs camp_size repression prim_method nvorg log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id) 

outreg2 using Table17.doc,append

* Test6

test prim_method-nvorg=0

* Predicted Probabilities groups (violent/nonviolent) comparison.

* Figure 4. Predicted probabilities of terrorist campaigns onsets by additional organiations for different primary method of mass dissent (Appendix, Table XVII, Model 1)

logit DT camp_size repression camp_orgs duration i.prim_method#c.camp_orgs pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
testparm i.prim_method#c.camp_orgs
quietly margins prim_method, at (camp_orgs = (0(1)4)) atmeans
marginsplot, scheme(sj) recast(line) plot1opts(lc(black)) plot2opts(lc(gs9)) recastci(rline) ci1opts(lpat(dash) lc(black)) ci2opts(lpat(dash) lc(gs9)) graphr(c(white)) title("") xtitle("Additional organizations") ytitle("Probability of terrorism onset") legend(label(3 "Large-scale civil war") label(4 "Mass civil resistance") order(3 4))

* Figure 5. Predicted probabilities of terrorist campaigns onsets by additional organizations for different primary method of mass dissent (Appendix, Table XVII, Model 2)

logit DT camp_size repression camp_orgs duration i.prim_method#c.camp_orgs log_popKSG log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
testparm i.prim_method#c.camp_orgs
quietly margins prim_method, at (camp_orgs = (0(1)4)) atmeans
marginsplot, scheme(sj) recast(line) plot1opts(lc(black)) plot2opts(lc(gs9)) recastci(rline) ci1opts(lpat(dash) lc(black)) ci2opts(lpat(dash) lc(gs9)) graphr(c(white)) title("") xtitle("Additional organizations") ytitle("Probability of terrorism onset") legend(label(3 "Large-scale civil war") label(4 "Mass civil resistance") order(3 4))

* Figure 6. Predicted probabilities of terrorist campaigns onsets by additional organizations for different primary method of mass dissent (Appendix, Table XVII, Model 3)

logit DT camp_size repression camp_orgs duration i.prim_method#c.camp_orgs log_popKSG log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
testparm i.prim_method#c.camp_orgs
quietly margins prim_method, at (camp_orgs = (0(1)4)) atmeans
marginsplot, scheme(sj) recast(line) plot1opts(lc(black)) plot2opts(lc(gs9)) recastci(rline) ci1opts(lpat(dash) lc(black)) ci2opts(lpat(dash) lc(gs9)) graphr(c(white)) title("") xtitle("Additional organizations") ytitle("Probability of terrorism onset") legend(label(3 "Large-scale civil war") label(4 "Mass civil resistance") order(3 4))

* Table XVIII. Full Nested Models with interaction terms between terrorist campaigns on-sets and main explanatory variables for group comparison (polity lag)

* Model 1) 

logit DT  duration camp_orgs camp_size repression prim_method nvdur log_popKSG ///
    log_realgdpKSG l.polity Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id) 

outreg2 using Table18.doc,replace

* Test 7
test prim_method-nvdur=0

* Model 2)

logit DT  duration camp_orgs camp_size repression prim_method nvorg log_popKSG ///
    log_realgdpKSG l.polity Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id) 

outreg2 using Table18.doc,append

* Test 8
test prim_method-nvorg=0

* Montecarlo Simulation: Do the effects of the core explanatory variables differ across different primary tactics of mass dissent?

* * Figure 7. Motecarlo simulation
clear all
clear matrix
set mem 700m
set more off


* * * load data * * * ;

* cd "/Users/margheritabelgioioso/Dropbox/Replication DATA Paper1"
use "MB_2018.dta"

cd ""
# delimit;

 drop if lDT==1;
 
 * * * estimate model * * * ;

logit DT duration prim_method nvdur camp_orgs camp_size repression pureyrs _spline1 _spline2 _spline3, cluster (country_id);

preserve;
sum duration prim_method nvdur camp_orgs camp_size repression pureyrs _spline1 _spline2 _spline3;

 
drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;

* * * create new data set to store results * * * ;
* * * change name as appropriate, of course * * * ;

postfile mypost predlo lo1 hi1 predhigh lo2 hi2 using "POSTR1.dta", replace;

* * * begin loop * * * ;
* * * where a is the value for x1 * * * ;
* * * which you'll want to vary from the minimum to maximim observed values* * * ;
* * * or from 1 sd below mean to 1 above or some other other substantively * * * ;
* * * interesting range * * * ;

noisily display "start";
local a= 0. ;
while `a' <=65.00{;

{;  

* * * generate XB values using observed X's for two cases * * * ;
* * * first, any control variables set at means/modes & X2 taking on a low value* * * ;
* * * second, second, control vars set at means/modes & X2 taking on a high value * * * ;
* * * where the two values for X2 may be 0 and 1, or 1SD below/above mean, or min/max, as appropriate * * * ;

generate x_betahatlo = b1* (`a')
					+ b2* 0
					+ b3* (`a')* 0
					+ b4* .7639925
					+ b5* 1.620903
					+ b6* 2.678689
					+ b7* 5.855072 
					+ b8* -2226.13 
					+ b9* -383.1372
					+ b10* -936.3456
					+ b11* 1;
					
					
					
					
generate x_betahathi = b1* (`a')
					+ b2* 1
					+ b3* (`a')* 1
					+ b4* .7639925
					+ b5* 1.620903
					+ b6* 2.678689
					+ b7* 5.855072 
					+ b8* -2226.13 
					+ b9* -383.1372
					+ b10* -936.3456
					+ b11* 1;
					

* * * generate predicted values * * * ;
* * * and scalars for averages across the simulations * * * ;

gen prlo = exp(x_betahatlo)/(1 + exp(x_betahatlo));
gen prhi = exp(x_betahathi)/(1 + exp(x_betahathi));

egen predictedlo=mean(prlo);
tempname predlo lo1 hi1;

egen predictedhi=mean(prhi);
tempname predhi lo2 hi2;

* * * generate scalars for confidence intervals * * * ;

_pctile prlo, p(2.5, 97.5);
scalar `lo1' = r(r1);
scalar `hi1' = r(r2); 
scalar `predlo' = predictedlo;

_pctile prhi, p(2.5, 97.5);
scalar `lo2' = r(r1);
scalar `hi2' = r(r2); 
scalar `predhi' = predictedhi;

* * * read the quantities of interest out into new data set * * * ;

 post mypost (`predlo') (`lo1') (`hi1') (`predhi') (`lo2') (`hi2');
};
* * * clear everything to make way for next step of simulation * * * ;

drop x_betahatlo prlo predictedlo x_betahathi prhi predictedhi;

* * * bring X1 up by some meaningful unit to start next step of sim* * * ;

local a=`a'+1.00;
};


postclose mypost;

clear all

use "POSTR1.dta"
 gen year=_n
drop if year > 31
tw line predlo year, lpattern(solid) lc(gs9) || line lo1 year, lpattern(dash) lc(gs9) || line hi1 year, lpattern(dash) lc(gs9) || line predhigh year, lpattern(solid) lc(black) || line lo2 year, lpattern(dash) lc(black) || line hi2 year, lpattern(dash) lc(black) leg(lab(1 "Large-scale civil war") lab(4 "Mass civil resistance") order(1 4))title("") graphr(c(white)) xtitle("Mass dissent duration") ytitle("Probability of terrorism onset")
 
clear all


* * Figure 8. Motecarlo simulation
clear
clear matrix
set mem 700m
set more off

* * * load data * * * ;

* cd "/Users/margheritabelgioioso/Dropbox/Replication DATA Paper1"
use "MB_2018.dta"
cd ""

# delimit;

 drop if lDT==1;
 
 * * * estimate model * * * ;

logit DT duration prim_method nvdur camp_orgs camp_size repression log_popKSG log_realgdpKSG lag1 pureyrs _spline1 _spline2 _spline3, cluster (country_id);

preserve;

sum duration prim_method nvdur camp_orgs camp_size repression log_popKSG log_realgdpKSG lag1 pureyrs _spline1 _spline2 _spline3;


* * * simulate coefficient estimates * * * ;
* * * draw 10,000 random values for each * * * ;
* * * draw from normal distribution * * * ;
* * * where normal dist has means, st errors * * * ;
* * * equal to estimate betas and st errors of those estimates * * * ;
* * * if # of coefficients not equal to 4 (with constant), * * * * ;
* * * adjust first line of following block of code accordingly;
 
drawnorm b1-b14, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;

* * * create new data set to store results * * * ;
* * * change name as appropriate, of course * * * ;

postfile mypost predlo lo1 hi1 predhigh lo2 hi2 using "POSTR.dta", replace;

* * * begin loop * * * ;
* * * where a is the value for x1 * * * ;
* * * which you'll want to vary from the minimum to maximim observed values* * * ;
* * * or from 1 sd below mean to 1 above or some other other substantively * * * ;
* * * interesting range * * * ;

noisily display "start";
local a= 0. ;
while `a' <=65.00{;

{;  

* * * generate XB values using observed X's for two cases * * * ;
* * * first, any control variables set at means/modes & X2 taking on a low value* * * ;
* * * second, second, control vars set at means/modes & X2 taking on a high value * * * ;
* * * where the two values for X2 may be 0 and 1, or 1SD below/above mean, or min/max, as appropriate * * * ;

generate x_betahatlo = b1* (`a')
					+ b2* 0
					+ b3* (`a')* 0
					+ b4* .7639925
					+ b5* 1.620903
					+ b6* 2.678689
					+ b7* 10.027 
					+ b8* 10.71326
					+ b9* .2800852
					+ b10* 5.855072 
					+ b11* -2226.13 
					+ b12* -383.1372
					+ b13* -936.3456
					+ b14* 1;
					
					
					
					
generate x_betahathi = b1* (`a')
					+ b2* 1
					+ b3* (`a')* 1
					+ b4* .7639925
					+ b5* 1.620903
					+ b6* 2.678689
					+ b7* 10.027 
					+ b8* 10.71326
					+ b9* .2800852
					+ b10* 5.855072 
					+ b11* -2226.13 
					+ b12* -383.1372
					+ b13* -936.3456
					+ b14* 1;
					  

* * * generate predicted values * * * ;
* * * and scalars for averages across the simulations * * * ;

gen prlo = exp(x_betahatlo)/(1 + exp(x_betahatlo));
gen prhi = exp(x_betahathi)/(1 + exp(x_betahathi));

egen predictedlo=mean(prlo);
tempname predlo lo1 hi1;

egen predictedhi=mean(prhi);
tempname predhi lo2 hi2;

* * * generate scalars for confidence intervals * * * ;

_pctile prlo, p(2.5, 97.5);
scalar `lo1' = r(r1);
scalar `hi1' = r(r2); 
scalar `predlo' = predictedlo;

_pctile prhi, p(2.5, 97.5);
scalar `lo2' = r(r1);
scalar `hi2' = r(r2); 
scalar `predhi' = predictedhi;

* * * read the quantities of interest out into new data set * * * ;

 post mypost (`predlo') (`lo1') (`hi1') (`predhi') (`lo2') (`hi2');
};
* * * clear everything to make way for next step of simulation * * * ;

drop x_betahatlo prlo predictedlo x_betahathi prhi predictedhi;

* * * bring X1 up by some meaningful unit to start next step of sim* * * ;

local a=`a'+1.00;
};


postclose mypost;

clear all

use "POSTR.dta"
gen year=_n
drop if year > 31
tw line predlo year, lpattern(solid) lc(gs9) || line lo1 year, lpattern(dash) lc(gs9) || line hi1 year, lpattern(dash) lc(gs9) || line predhigh year, lpattern(solid) lc(black) || line lo2 year, lpattern(dash) lc(black) || line hi2 year, lpattern(dash) lc(black) leg(lab(1 "Large-scale civil war") lab(4 "Mass civil resistance") order(1 4))title("") graphr(c(white)) xtitle("Mass dissent duration") ytitle("Probability of terrorism onset")

clear all


* * Figure 9. Motecarlo simulation
clear
clear matrix
set mem 700m
set more off


* * * load data * * * ;

* cd "/Users/margheritabelgioioso/Dropbox/Replication DATA Paper1"
use "MB_2018.dta"
cd " "

# delimit;

 drop if lDT==1;
 
 * * * estimate model * * * ;

logit DT duration prim_method nvdur camp_orgs camp_size repression log_popKSG log_realgdpKSG lag1 Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3, cluster (country_id);

preserve;

sum duration prim_method nvdur camp_orgs camp_size repression log_popKSG log_realgdpKSG lag1 Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3;


* * * simulate coefficient estimates * * * ;
* * * draw 10,000 random values for each * * * ;
* * * draw from normal distribution * * * ;
* * * where normal dist has means, st errors * * * ;
* * * equal to estimate betas and st errors of those estimates * * * ;
* * * if # of coefficients not equal to 4 (with constant), * * * * ;
* * * adjust first line of following block of code accordingly;
 
drawnorm b1-b19, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;

* * * create new data set to store results * * * ;
* * * change name as appropriate, of course * * * ;

postfile mypost predlo lo1 hi1 predhigh lo2 hi2 using "PLUS.dta", replace;

* * * begin loop * * * ;
* * * where a is the value for x1 * * * ;
* * * which you'll want to vary from the minimum to maximim observed values* * * ;
* * * or from 1 sd below mean to 1 above or some other other substantively * * * ;
* * * interesting range * * * ;

noisily display "start";
local a= 0. ;
while `a' <=65.00{;

{;  

* * * generate XB values using observed X's for two cases * * * ;
* * * first, any control variables set at means/modes & X2 taking on a low value* * * ;
* * * second, second, control vars set at means/modes & X2 taking on a high value * * * ;
* * * where the two values for X2 may be 0 and 1, or 1SD below/above mean, or min/max, as appropriate * * * ;

generate x_betahatlo = b1* (`a')
					+ b2* 0
					+ b3* (`a')* 0
					+ b4* .7639925
					+ b5* 1.620903
					+ b6* 2.678689
					+ b7* 10.027 
					+ b8* 10.71326
					+ b9* .2800852
					+ b10* .4450773
					+ b11* .0138324
					+ b12* .1578519
					+ b13* .2205045
					+ b14* .1074044
					+ b15* 5.850362
					+ b16* -2226.13 
					+ b17* -383.1372
					+ b18* -936.3456
					+ b19* 1;
					
					
					
					
generate x_betahathi = b1* (`a')
					+ b2* 1
					+ b3* (`a')* 1
					+ b4* .7639925
					+ b5* 1.620903
					+ b6* 2.678689
					+ b7* 10.027 
					+ b8* 10.71326
					+ b9* .2800852
					+ b10* .4450773
					+ b11* .0138324
					+ b12* .1578519
					+ b13* .2205045
					+ b14* .1074044
					+ b15* 5.850362
					+ b16* -2226.13 
					+ b17* -383.1372
					+ b18* -936.3456
					+ b19* 1;
					  

* * * generate predicted values * * * ;
* * * and scalars for averages across the simulations * * * ;

gen prlo = exp(x_betahatlo)/(1 + exp(x_betahatlo));
gen prhi = exp(x_betahathi)/(1 + exp(x_betahathi));

egen predictedlo=mean(prlo);
tempname predlo lo1 hi1;

egen predictedhi=mean(prhi);
tempname predhi lo2 hi2;

* * * generate scalars for confidence intervals * * * ;

_pctile prlo, p(2.5, 97.5);
scalar `lo1' = r(r1);
scalar `hi1' = r(r2); 
scalar `predlo' = predictedlo;

_pctile prhi, p(2.5, 97.5);
scalar `lo2' = r(r1);
scalar `hi2' = r(r2); 
scalar `predhi' = predictedhi;

* * * read the quantities of interest out into new data set * * * ;

 post mypost (`predlo') (`lo1') (`hi1') (`predhi') (`lo2') (`hi2');
};
* * * clear everything to make way for next step of simulation * * * ;

drop x_betahatlo prlo predictedlo x_betahathi prhi predictedhi;

* * * bring X1 up by some meaningful unit to start next step of sim* * * ;

local a=`a'+1.00;
};


postclose mypost;

clear all

use "PLUS.dta"
gen year=_n
drop if year > 31
tw line predlo year, lpattern(solid) lc(gs9) || line lo1 year, lpattern(dash) lc(gs9) || line hi1 year, lpattern(dash) lc(gs9) || line predhigh year, lpattern(solid) lc(black) || line lo2 year, lpattern(dash) lc(black) || line hi2 year, lpattern(dash) lc(black) leg(lab(1 "Large-scale civil war") lab(4 "Mass civil resistance") order(1 4))title("") graphr(c(white)) xtitle("Mass dissent duration") ytitle("Probability of terrorism onset")

clear all

* * Figure 10. Motecarlo simulation
clear
clear matrix
set mem 700m
set more off

clear all

* * * load data * * * ;

* cd "/Users/margheritabelgioioso/Dropbox/Replication DATA Paper1"
use "MB_2018.dta"
# delimit;

drop if lDT==1;
 
 * * * estimate model * * * ;

logit  DT  camp_orgs prim_method nvorg repression camp_size duration pureyrs _spline1 _spline2 _spline3, cluster (country_id);

preserve;
sum   camp_orgs prim_method nvorg repression camp_size duration pureyrs _spline1 _spline2 _spline3;


* * * simulate coefficient estimates * * * ;
* * * draw 10,000 random values for each * * * ;
* * * draw from normal distribution * * * ;
* * * where normal dist has means, st errors * * * ;
* * * equal to estimate betas and st errors of those estimates * * * ;
* * * if # of coefficients not equal to 4 (with constant), * * * * ;
* * * adjust first line of following block of code accordingly;
 
drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;

* * * create new data set to store results * * * ;
* * * change name as appropriate, of course * * * ;

postfile mypost predlo lo1 hi1 predhigh lo2 hi2 using "POSTR11.dta", replace;

* * * begin loop * * * ;
* * * where a is the value for x1 * * * ;
* * * which you'll want to vary from the minimum to maximim observed values* * * ;
* * * or from 1 sd below mean to 1 above or some other other substantively * * * ;
* * * interesting range * * * ;

noisily display "start";
local a= 0. ;
while `a' <=04.00{;

{;  

* * * generate XB values using observed X's for two cases * * * ;
* * * first, any control variables set at means/modes & X2 taking on a low value* * * ;
* * * second, second, control vars set at means/modes & X2 taking on a high value * * * ;
* * * where the two values for X2 may be 0 and 1, or 1SD below/above mean, or min/max, as appropriate * * * ;

generate x_betahatlo = b1* (`a')
					+ b2* 0
					+ b3* (`a')* 0
					+ b4* 2.678952
					+ b5* 1.620903
					+ b6* 8.955717
					+ b7* 5.855072 
					+ b8* -2226.13 
					+ b9* -383.1372
					+ b10* -936.3456
					+ b11* 1;
					
					
					
					
generate x_betahathi = b1* (`a')
					+ b2* 1
					+ b3* (`a')* 1
					+ b4* 2.678952
					+ b5* 1.620903
					+ b6* 8.955717
					+ b7* 5.855072 
					+ b8* -2226.13 
					+ b9* -383.1372
					+ b10* -936.3456
					+ b11* 1;
					

* * * generate predicted values * * * ;
* * * and scalars for averages across the simulations * * * ;

gen prlo = exp(x_betahatlo)/(1 + exp(x_betahatlo));
gen prhi = exp(x_betahathi)/(1 + exp(x_betahathi));

egen predictedlo=mean(prlo);
tempname predlo lo1 hi1;

egen predictedhi=mean(prhi);
tempname predhi lo2 hi2;

* * * generate scalars for confidence intervals * * * ;

_pctile prlo, p(2.5, 97.5);
scalar `lo1' = r(r1);
scalar `hi1' = r(r2); 
scalar `predlo' = predictedlo;

_pctile prhi, p(2.5, 97.5);
scalar `lo2' = r(r1);
scalar `hi2' = r(r2); 
scalar `predhi' = predictedhi;

* * * read the quantities of interest out into new data set * * * ;

 post mypost (`predlo') (`lo1') (`hi1') (`predhi') (`lo2') (`hi2');
};
* * * clear everything to make way for next step of simulation * * * ;

drop x_betahatlo prlo predictedlo x_betahathi prhi predictedhi;

* * * bring X1 up by some meaningful unit to start next step of sim* * * ;

local a=`a'+1.00;
};


postclose mypost;

clear all

use "POSTR11.dta"
gen org=.
replace org = 0 in 1
replace org = 1 in 2
replace org = 2 in 3
replace org = 3 in 4
replace org = 4 in 5
drop if org>4
tw line predlo org, lpattern(solid) lc(gs9) || line lo1 org, lpattern(dash) lc(gs9) || line hi1 org, lpattern(dash) lc(gs9) || line predhigh org, lpattern(solid) lc(black) || line lo2 org, lpattern(dash) lc(black) || line hi2 org, lpattern(dash) lc(black) leg(lab(1 "Large-scale civil war") lab(4 "Mass civil resistance") order(1 4))title("") graphr(c(white)) xtitle("Additional organizations") ytitle("Probability of terrorism onset")
 
clear all
 
 * * Figure 11. Motecarlo simulation
clear all
clear matrix
set mem 700m
set more off


* * * load data * * * ;

* cd "/Users/margheritabelgioioso/Dropbox/Replication DATA Paper1"
use "MB_2018.dta"
# delimit;

 drop if lDT==1;
 
 * * * estimate model * * * ;

logit DT camp_orgs prim_method nvorg repression camp_size duration log_popKSG log_realgdpKSG lag1 pureyrs _spline1 _spline2 _spline3, cluster (country_id);

preserve;
sum  camp_orgs prim_method nvorg repression camp_size duration log_popKSG log_realgdpKSG lag1 pureyrs _spline1 _spline2 _spline3;


* * * simulate coefficient estimates * * * ;
* * * draw 10,000 random values for each * * * ;
* * * draw from normal distribution * * * ;
* * * where normal dist has means, st errors * * * ;
* * * equal to estimate betas and st errors of those estimates * * * ;
* * * if # of coefficients not equal to 4 (with constant), * * * * ;
* * * adjust first line of following block of code accordingly;
 
drawnorm b1-b14, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;

* * * create new data set to store results * * * ;
* * * change name as appropriate, of course * * * ;

postfile mypost predlo lo1 hi1 predhigh lo2 hi2 using "POS.dta", replace;

* * * begin loop * * * ;
* * * where a is the value for x1 * * * ;
* * * which you'll want to vary from the minimum to maximim observed values* * * ;
* * * or from 1 sd below mean to 1 above or some other other substantively * * * ;
* * * interesting range * * * ;

noisily display "start";
local a= 0. ;
while `a' <=04.00{;

{;  

* * * generate XB values using observed X's for two cases * * * ;
* * * first, any control variables set at means/modes & X2 taking on a low value* * * ;
* * * second, second, control vars set at means/modes & X2 taking on a high value * * * ;
* * * where the two values for X2 may be 0 and 1, or 1SD below/above mean, or min/max, as appropriate * * * ;

generate x_betahatlo = b1* (`a')
					+ b2* 0
					+ b3* (`a')* 0
					+ b4* 2.678952
					+ b5* 1.620903
					+ b6* 8.955717 
					+ b7* 10.027 
					+ b8* 10.71326
					+ b9* .2800852
					+ b10* 5.855072 
					+ b11* -2226.13 
					+ b12* -383.1372
					+ b13* -936.3456
					+ b14* 1;
					
					
					
					
generate x_betahathi = b1* (`a')
					+ b2* 1
					+ b3* (`a')* 1
					+ b4* 2.678952
					+ b5* 1.620903
					+ b6* 8.955717 
					+ b7* 10.027 
					+ b8* 10.71326
					+ b9* .2800852
					+ b10* 5.855072 
					+ b11* -2226.13 
					+ b12* -383.1372
					+ b13* -936.3456
					+ b14* 1;
					  

* * * generate predicted values * * * ;
* * * and scalars for averages across the simulations * * * ;

gen prlo = exp(x_betahatlo)/(1 + exp(x_betahatlo));
gen prhi = exp(x_betahathi)/(1 + exp(x_betahathi));

egen predictedlo=mean(prlo);
tempname predlo lo1 hi1;

egen predictedhi=mean(prhi);
tempname predhi lo2 hi2;

* * * generate scalars for confidence intervals * * * ;

_pctile prlo, p(2.5, 97.5);
scalar `lo1' = r(r1);
scalar `hi1' = r(r2); 
scalar `predlo' = predictedlo;

_pctile prhi, p(2.5, 97.5);
scalar `lo2' = r(r1);
scalar `hi2' = r(r2); 
scalar `predhi' = predictedhi;

* * * read the quantities of interest out into new data set * * * ;

 post mypost (`predlo') (`lo1') (`hi1') (`predhi') (`lo2') (`hi2');
};
* * * clear everything to make way for next step of simulation * * * ;

drop x_betahatlo prlo predictedlo x_betahathi prhi predictedhi;

* * * bring X1 up by some meaningful unit to start next step of sim* * * ;

local a=`a'+1.00;
};


postclose mypost;

clear all

use "POS.dta"

gen org=.
replace org = 0 in 1
replace org = 1 in 2
replace org = 2 in 3
replace org = 3 in 4
replace org = 4 in 5
drop if org>4

tw line predlo org, lpattern(solid) lc(gs9) || line lo1 org, lpattern(dash) lc(gs9) || line hi1 org, lpattern(dash) lc(gs9) || line predhigh org, lpattern(solid) lc(black) || line lo2 org, lpattern(dash) lc(black) || line hi2 org, lpattern(dash) lc(black) leg(lab(1 "Large-scale civil war") lab(4 "Mass civil resistance") order(1 4))title("") graphr(c(white)) xtitle("Additional organizations") ytitle("Probability of terrorism onset")
 
clear all 

 * * Figure 12. Motecarlo simulation
clear all
clear matrix
set mem 700m
set more off


* * * load data * * * ;

* cd "/Users/margheritabelgioioso/Dropbox/Replication DATA Paper1"
use "MB_2018.dta"
# delimit;

 drop if lDT==1;
 
 * * * estimate model * * * ;

logit DT camp_orgs prim_method nvorg repression camp_size duration log_popKSG log_realgdpKSG lag1 Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3, cluster (country_id);

preserve;
sum  camp_orgs prim_method nvorg repression camp_size duration log_popKSG log_realgdpKSG lag1 Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3;


* * * simulate coefficient estimates * * * ;
* * * draw 10,000 random values for each * * * ;
* * * draw from normal distribution * * * ;
* * * where normal dist has means, st errors * * * ;
* * * equal to estimate betas and st errors of those estimates * * * ;
* * * if # of coefficients not equal to 4 (with constant), * * * * ;
* * * adjust first line of following block of code accordingly;
 
drawnorm b1-b19, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;

* * * create new data set to store results * * * ;
* * * change name as appropriate, of course * * * ;

postfile mypost predlo lo1 hi1 predhigh lo2 hi2 using "PLUS1.dta", replace;

* * * begin loop * * * ;
* * * where a is the value for x1 * * * ;
* * * which you'll want to vary from the minimum to maximim observed values* * * ;
* * * or from 1 sd below mean to 1 above or some other other substantively * * * ;
* * * interesting range * * * ;

noisily display "start";
local a= 0. ;
while `a' <=04.00{;

{;  

* * * generate XB values using observed X's for two cases * * * ;
* * * first, any control variables set at means/modes & X2 taking on a low value* * * ;
* * * second, second, control vars set at means/modes & X2 taking on a high value * * * ;
* * * where the two values for X2 may be 0 and 1, or 1SD below/above mean, or min/max, as appropriate * * * ;

generate x_betahatlo = b1* (`a')
					+ b2* 0
					+ b3* (`a')* 0
					+ b4* 2.678952
					+ b5* 1.620903
					+ b6* 8.955717 
					+ b7* 10.027 
					+ b8* 10.71326
					+ b9* .2800852
					+ b10* .4450773
					+ b11* .0138324
					+ b12* .1578519
					+ b13* .2205045
					+ b14* .1074044
					+ b15* 5.850362
					+ b16* -2226.13 
					+ b17* -383.1372
					+ b18* -936.3456
					+ b19* 1;
					
					
					
					
generate x_betahathi = b1* (`a')
					+ b2* 1
					+ b3* (`a')* 1
					+ b4* 2.678952
					+ b5* 1.620903
					+ b6* 8.955717 
					+ b7* 10.027 
					+ b8* 10.71326
					+ b9* .2800852
					+ b10* .4450773
					+ b11* .0138324
					+ b12* .1578519
					+ b13* .2205045
					+ b14* .1074044
					+ b15* 5.850362
					+ b16* -2226.13 
					+ b17* -383.1372
					+ b18* -936.3456
					+ b19* 1;
					  

* * * generate predicted values * * * ;
* * * and scalars for averages across the simulations * * * ;

gen prlo = exp(x_betahatlo)/(1 + exp(x_betahatlo));
gen prhi = exp(x_betahathi)/(1 + exp(x_betahathi));

egen predictedlo=mean(prlo);
tempname predlo lo1 hi1;

egen predictedhi=mean(prhi);
tempname predhi lo2 hi2;

* * * generate scalars for confidence intervals * * * ;

_pctile prlo, p(2.5, 97.5);
scalar `lo1' = r(r1);
scalar `hi1' = r(r2); 
scalar `predlo' = predictedlo;

_pctile prhi, p(2.5, 97.5);
scalar `lo2' = r(r1);
scalar `hi2' = r(r2); 
scalar `predhi' = predictedhi;

* * * read the quantities of interest out into new data set * * * ;

 post mypost (`predlo') (`lo1') (`hi1') (`predhi') (`lo2') (`hi2');
};
* * * clear everything to make way for next step of simulation * * * ;

drop x_betahatlo prlo predictedlo x_betahathi prhi predictedhi;

* * * bring X1 up by some meaningful unit to start next step of sim* * * ;

local a=`a'+1.00;
};


postclose mypost;

clear all

use "PLUS1.dta"

gen org=.
replace org = 0 in 1
replace org = 1 in 2
replace org = 2 in 3
replace org = 3 in 4
replace org = 4 in 5
drop if org>4

tw line predlo org, lpattern(solid) lc(gs9) || line lo1 org, lpattern(dash) lc(gs9) || line hi1 org, lpattern(dash) lc(gs9) || line predhigh org, lpattern(solid) lc(black) || line lo2 org, lpattern(dash) lc(black) || line hi2 org, lpattern(dash) lc(black) leg(lab(1 "Large-scale civil war") lab(4 "Mass civil resistance") order(1 4))title("") graphr(c(white)) xtitle("Additional organizations") ytitle("Probability of terrorism onset")
 
clear all

* Tests for non-difference of the effects of main explanatory variables splitting samples 
use "MB_2018.dta"

* Model 1 Table II main text

preserve
drop if lDT==1
logit DT  duration camp_org repression camp_size  pureyrs _spline1 _spline2 _spline3 if prim_method==1
est store d1
logit DT  duration camp_org repression camp_size pureyrs _spline1 _spline2 _spline3 if prim_method==0
est store d0
suest d1 d0

* Tests 9

test [d1_DT]duration-[d0_DT]duration =0

* Tests 10

test [d1_DT]camp_org-[d0_DT]camp_org =0

* Model 2 Table II main text

preserve
drop if lDT==1
logit DT  duration camp_org repression camp_size log_popKSG log_realgdpKSG democrazia pureyrs _spline1 _spline2 _spline3 if prim_method==1
est store d1
logit DT  duration camp_org repression camp_size log_popKSG log_realgdpKSG democrazia pureyrs _spline1 _spline2 _spline3 if prim_method==0
est store d0
suest d1 d0

* Tests 11

test [d1_DT]duration-[d0_DT]duration =0

* Tests 12

test [d1_DT]camp_org-[d0_DT]camp_org =0

restore

* Model 3 Table II main text

preserve
drop if lDT==1
logit DT  duration camp_org repression camp_size log_popKSG log_realgdpKSG democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if prim_method==1
est store d1
logit DT  duration camp_org repression camp_size log_popKSG log_realgdpKSG democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if prim_method==0
est store d0
suest d1 d0

* Tests 13

test [d1_DT]duration-[d0_DT]duration =0

* Tests 14

test [d1_DT]camp_org-[d0_DT]camp_org =0

restore

* Table XIX. The determinants of terrorist campaigns onset excluding self-coded terrorist data
* Drop campaigns contaninig 1970 to exclude self-coded data driven results
preserve

drop if year< 170

* crete new qubic splines

xtset campaign_id year 

* Table19

* Model 1)
logit DT  duration camp_org camp_size repression prim_method ///
    pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)	
	
outreg2 using Table19.doc,replace
	
* Model 2)

logit DT duration camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table19.doc,append


* Model 3)

logit DT duration camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
outreg2 using Table19.doc,append

* Marginal effects anf predicted probabilities 

* Model 3°

logit DT duration camp_org  camp_size repression prim_method  log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)
	
* Figure 14

margins, predict(pr) at(duration=(1(5)40))
marginsplot,  recast(line) plot1opts(lc(black)) recastci(rline) ciopts(lpat(dash) lc(black)) graphr(c(white)) title("") xtitle("Mass dissent duration") ytitle("Probability of terrorism onset")

* restore 

* Figure 14

margins, predict(pr) at(camp_org=(0(1)3)) 
marginsplot, recast(line) plot1opts(lc(black)) recastci(rline) ciopts(lpat(dash) lc(black)) graphr(c(white)) title("") xtitle("Additional organizations") ytitle("Probability of terrorism onset") 

* restore

** Joint Significance Model 3, Table II (main text)

* Model 3

logit DT camp_size repression camp_orgs duration prim_method log_popKSG ///
    log_realgdpKSG l.democrazia Regime_change Significant_institutional_reform Anti_occupation Territorial_secession Greater_autonomy pureyrs _spline1 _spline2 _spline3 if lDT==0, cluster (country_id)

* Test 15

test (duration=0) (camp_orgs=0)



