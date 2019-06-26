* Do-file to replicate results presented in:
* Katherine Glassmyer and Nicholas Sambanis, "Rebel-Military Integration and Civil War Termination"



log using C:\MyDocuments\Military_Integration\MI_resultslog, t replace

use "C:\MyDocuments\Military_Integration\milint_repl.dta", clear




label var cnumb "code number for each conflict"
label var ccode "letter code for each conflict"
label var clust2 "cluster code for each conflict"
label var countryname  
label var yrst "Year the war started"                       
label var most "Month the war started"                       
label var yrend " Year the war ended"                       
label var moend "Month the war ended"                       
label var conflict 
label var peacend "Did the peafe end by December 1999? Code 1 if yes, 0 otherise"                    
label var duration "Duration of the peace in months until December 1999"                   
label var dur_v2 "Second version of the peace duration variable; different assumptions about which wars are new and which recurrent, and other differences; see comments"                     
label var pend_2 "Second version of peacend variable; corresponds to dur_v2"                     
label var warend2 "code 1 if there was no war recurence two years after the war; code 0 if there was a new war"
label var warend2_v2  "same as warend2; but code up to 2005"                
label var warend2_v2b "second version of no war recurrence, with different assumptions about which conflicts are new and which are recurring"   
label var warend2to5 "coded 1 if there was no war recurrence two to five years after the end of the war; code 0 otherwise"
label var wartype  "Binary indicator for ethno-religious wars"                   
label var factnum  "Number of factions"                   
label var unmandate  "Mandate of the UN mission, if any"
label var wardur  "civil war duration in months"                    
label var gdpend  "real per capita income at the end of the war"                    
label var outcome2 "outcome of the war"
label var treaty   "Binary indicator for signed peace treaty"                   
label var peace40 "peace started in the 1940's"                    
label var peace50 "peace started in the 1950's"                    
label var peace60 "peace started in the 1960's"                    
label var peace70 "peace started in the 1970's"                    
label var peace80 "peace started in the 1980's"                    
label var peace90 "peace started in the 1990's"                    
label var decade "decade the war started"                     
label var ninety 
label var oil "Binary indicator for countries with oil export dependence"                        
label var part "Binary indicator for cases of partition"                       
label var geo  "geographic region indicator"        
label var coup "Binary indicator for coups"                      
label var elfo "ethno-linguistic fractionalization; based on 1964 Soviet Atlas"                        
label var ef "Fearon's (2003) ethnic fractionalization index"                         
label var gdpgrofl "Annual rate of change in per capita income"                   
label var logcost "Natural log of deaths & displacements"
label var transpop "Net trasfers per capita to the balance of payments"
label var coldwar "Binary indicator for Cold War conflicts"
label var lngdp "Natural Log of Per Capita Real Income"
label var lnwardur "Natural Log of war duration"
label var lnarmy "Natural Log of size of the military"
label var geo4 "Binary indicator for Asia"
label var geo5 "Binary indicator for Sub-Saharan Africa"
label var MultiPKO "Binary indicator for UN missions with multidimensional mandate"                   
label var unintrvn "Binary indicators for cases with a UN peace mission -- all mandates"
label var negset "Binary indicator for wars that ended in a negotiated settlement" 
label var milout "Binary indicator for wars that ended in a military victory"
label var truce "Binary indicator for wars that ended in a truce or cease-fire"                      
label var nonUN "Binary indicator for any type of non-UN peace mission"
label var ch6 "consent-based peacekeeping -- all Chapter VI UN operations"
label var isxp2 "primary commodity exports as a percent of GDP with imputed missing values (see DS2006 for notes)"
label var idev1 "ebergy consumption with imputed missing values (see DS2006 for notes)"
label var milint_l "Lenient definition of MI. 1 if any parts of rebel army integrated, 0 otherwise"
label var milint_s "Strict definition of MI.  1 if explicit MI agreement; 0 otherwise"
label var mi_inc  "Incomplete integration. 1 if MI_Len = 1 but MI_Strict = 0 OR MI_Strict = 1 but only some factions agreed. Not the same as failure to implement MI agreement"
label var milapp "implemented MI agreement"                      
label var milint "military integration (MI) agreement; all cases"                      
label var pps "political power-sharing" 




******

tab milint
tab milint_s
tab milint_l

tab negset
tab outcome2

tab geo milint

tab unintrvn milint, chi2

tab nonUN milint, chi2

tab nonUN milint if unintrvn!=1, chi2

tab unmandate milint, chi2

sort milint

by milint: sum duration if peace90==1




** Table 1 -- Effects of MI on war recurrence

* Regression 1 - Table 1
logit warend2 milint, cluster(clust2) nolog

* Supplement (use updated version of warend2)
logit warend2_v2 milint,  cluster(clust2) nolog

* Supplement (use second version of "no war recurrence" with some cases re-coded; see comments for explanation of recoding)
logit warend2_v2b milint,  cluster(clust2) nolog

* Supplement: drop coups and partitions
logit warend2 milint if coup!=1 & part!=1, cluster(clust2) nolog

* Supplement: exclude incomplete MI
logit warend2 milint if  mi_inc!=1, cluster(clust2) nolog

* Supplement (use updated version of warend2)
logit warend2_v2 milint if  mi_inc!=1, cluster(clust2) nolog

* Supplement (use second version of "no war recurrence" with some cases re-coded; see comments for explanation of recoding)
logit warend2_v2b milint if  mi_inc!=1, cluster(clust2) nolog

* Regression 2 - Table 1 - control for lenient MI alone 
logit warend2 milint_l,  cluster(clust2) nolog

* Regression 3 - Table 1 - control for strict MI alone 
logit warend2 milint_s,  cluster(clust2) nolog

* Regression 4 - Table 1 - control for both strict and lenient MI
logit warend2 milint_s milint_l,  cluster(clust2) nolog

* Supplement (use updated version of warend2)
logit warend2_v2 milint_l milint_s, cluster(clust2) nolog

* Supplement (use second version of "no war recurrence" with some cases re-coded; see comments for explanation of recoding)
logit warend2_v2b milint_l milint_s if  mi_inc!=1, cluster(clust2) nolog

* Supplement (use version of no war recurrence covering period 2-5 years after the end of the war)
logit warend2to5 milint_l milint_s, cluster(clust2) nolog

* Regression 5 - Table 1
logit warend2 milapp,  cluster(clust2) nolog

* Supplement: drop coups and partitions
logit warend2 milapp if coup!=1 & part!=1, cluster(clust2) nolog

* Supplement (use updated version of warend2)
logit warend2_v2 milapp, cluster(clust2) nolog

* Supplement (use second version of "no war recurrence" with some cases re-coded; see comments for explanation of recoding)
logit warend2_v2b milapp, cluster(clust2) nolog

* Supplement (use version of "no war recurrence" from 2 to 5 years after the end of the war)
logit  warend2to5 milapp, cluster(clust2) nolog

* Supplement (use version of "no war recurrence" from 2 to 5 years after the end of the war)
logit  warend2to5 milapp if coup!=1 & part!=1, cluster(clust2) nolog

* Supplement (use second version of "no war recurrence" as above; drop coups and partitions)
logit warend2_v2b milapp if coup!=1 & part!=1, cluster(clust2) nolog

* Regression 6 - Table 1
logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint, cluster(clust2) nolog

* Supplement -- use updated version of warend2

logit warend2_v2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint, cluster(clust2) nolog

* Supplement (use second version of warend2_v2 with some cases re-coded; see comments for explanation of recoding)

logit warend2_v2b wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint, cluster(clust2) nolog

* Supplement -- use energy consumption instead of GDP
logit warend2 wartype logcost factnum transpop unintrvn treaty idev1 isxp2 milint, cluster(clust2) nolog

* Supplement -- lenient form of MI
logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint_l, cluster(clust2) nolog

* Supplement -- strict form of MI
logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint_s, cluster(clust2) nolog

** Create interactions with MI

gen trmi=treaty*milint
gen costmi=logcost*milint
gen durmi=wardur*milint
gen facmi=factnum*milint
gen gdpmi=lngdp*milint
gen sxpmi=isxp2*milint
gen unmi=unintrvn*milint
gen typemi=wartype*milint
gen trami=transpop*milint

* Supplement -- model with interaction terms 

logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint  trmi costmi durmi facmi gdpmi sxpmi unmi  typemi trami, cluster(clust2) nolog

test  milint trmi costmi durmi facmi gdpmi sxpmi unmi typemi trami


logit warend2_v2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint  trmi costmi durmi facmi gdpmi sxpmi unmi  typemi trami, cluster(clust2) nolog

test  milint trmi costmi durmi facmi gdpmi sxpmi unmi typemi trami


* Regression 7 - Table 1
* interaction with treaty

logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 trmi, cluster(clust2) nolog


* Supplement -- regress warend2 on MI in cases where there was a treaty:
logit warend2 milint if treaty==1, cluster(clust2) nolog

* Supplement -- regress warend2 on MI in cases where there was no treaty:
logit warend2 milint if treaty==0, cluster(clust2) nolog


** These are the results we report in the paper; we use the updated version of warend

* Supplement -- regress warend2 on MI in cases where there was a treaty:
logit warend2 milint if treaty==1, cluster(clust2) nolog

* Supplement -- regress warend2 on MI in cases where there was no treaty:
logit warend2 milint if treaty==0, cluster(clust2) nolog


* Regression 8 - Table 1
* interaction with UN

logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 unmi, cluster(clust2) nolog


* Supplement -- regress warend on MI in cases where there was no UN mission:
logit warend2 milint if unintrvn==0, cluster(clust2) nolog

* Supplement -- regress warend on MI in cases where there was a UN mission:
logit warend2 milint if unintrvn==1, cluster(clust2) nolog

* Supplement -- regress warend on MI in cases where there was no UN mission:
logit warend2_v2 milint if unintrvn==0, cluster(clust2) nolog

* Supplement -- regress warend on MI in cases where there was a UN mission:
logit warend2_v2 milint if unintrvn==1, cluster(clust2) nolog


* Regression 9 - Table 1

gen mipps=milint*pps
* interaction of MI with political power-sharing agreement

logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 mipps, cluster(clust2) nolog

* Supplement -- add pps control to regression 9

logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 mipps pps, cluster(clust2) nolog

* Supplement -- control only for pps

logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 pps, cluster(clust2) nolog


* Regression 10 - Table 1
logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint pps, cluster(clust2) nolog

* Supplement -- Regression 10 with updated version of war end
logit warend2_v2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 milint pps, cluster(clust2) nolog


** Robustness

** Endogeneity 

* Instruments for MI? (poor choices; only ones plausible in our dataset)

logit milint decade, cluster(clust2) nolog
logit milint ninety, cluster(clust2) nolog
logit milint coldwar, cluster(clust2) nolog
logit milint geo, cluster(clust2) nolog
logit milint geo5, cluster(clust2) nolog

* exogeneity tests; using the variables above as instruments (even if not significant in regressions)
* UN intervention may also be endogenous - see Doyle and Sambanis for a discussion)

* run exogeneity tests on MI both with and without UN variable and then do the same for UN variable
* Smith-Bludnell tests

probexog warend2 wartype logcost factnum transpop treaty lngdp isxp2 (milint = ninety)
probexog warend2 wartype logcost factnum transpop treaty lngdp isxp2 unintrvn (milint = ninety)
probexog warend2 wartype logcost factnum transpop treaty idev1 isxp2 (milint = geo5)
probexog warend2 wartype logcost factnum transpop treaty idev1 isxp2 unintrvn (milint = geo5)

* add growth to the regression
probexog warend2 wartype logcost factnum transpop treaty lngdp gdpgrofl isxp2 (milint = ninety)
probexog warend2 wartype logcost factnum transpop treaty lngdp gdpgrofl isxp2 unintrvn (milint = ninety)
probexog warend2 wartype logcost factnum transpop treaty idev1 gdpgrofl isxp2 (milint = geo5)
probexog warend2 wartype logcost factnum transpop treaty idev1 gdpgrofl isxp2 unintrvn (milint = geo5)

** only in a few specifications can we reject null hypothesis of exogeneity

** Estimate as a 2sls linear probability model (see Angrist and Krueger for justification of estimation method)
** for justification on use of this model with a binary dependent variable, see Angrist and Krueger (1999; 2001).

** assume UN exogenous (we control for growth in the regression and we cannot reject exogeneity of UN with S-B test when we do so)
ivreg warend2 wartype logcost factnum transpop treaty lngdp gdpgrofl isxp2 unintrvn (milint = ninety geo5), cluster(clust2)

** drop UN
ivreg warend2 wartype logcost factnum transpop treaty lngdp gdpgrofl isxp2 (milint = ninety geo5), cluster(clust2)

** control for level of ethnic fractionalization in the war recurrence regression
ivreg warend2 wartype logcost factnum transpop treaty lngdp gdpgrofl isxp2 ef (milint = ninety geo4 geo5 lnarmy), cluster(clust2)


* estimated with bivariate probit as SUR; milint is potentially endogenous RHS variable
* bivariate probit with potentially endogenous RHS variable added as dependent variable regression in second equation is FIML simultaneous equation probit model
* correlation coefficient functions as test of exogeneity

* but model cannot be identified if we include all the covariates from the structural equation; we must drop  a few variables

biprobit (warend2 wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2 milint) (milint = lnarmy ninety geo5 ef logcost factnum), cluster(clust2)
biprobit (warend2 wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2 milint) (milint = logcost factnum unintrvn lngdp gdpgrofl ef lnarmy ninety geo5), cluster(clust2)

* updated version of warend2
biprobit (warend2_v2 wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2 milint) (milint = lnarmy ninety geo5 ef logcost factnum), cluster(clust2)
biprobit (warend2_v2 wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2 milint) (milint = logcost factnum unintrvn lngdp gdpgrofl ef lnarmy ninety geo5), cluster(clust2)


** Heckman selection models

*** selection on treaty; bivariate probit model

biprobit (warend2 = wartype logcost factnum transpop unintrvn lngdp gdpgrofl ef isxp2 milint) (treaty = wartype logcost factnum isxp2 lnarmy lnwardur), cluster(clust2) nolog

*** selection on war outcome (military victory); bivariate probit model

biprobit (warend2 = wartype logcost factnum transpop MultiPKO lngdp gdpgrofl ef isxp2 milint) (milout = wartype logcost factnum isxp2 lnarmy lnwardur treaty), cluster(clust2) nolog





use "C:\MyDocuments\Military_Integration\milint_repl.dta", clear

*** MATCHING 


** For a discussion of matching (including problems that may arise when it applied to our data), see the discussion in Sambanis and Doyle (2006)
** The propensity score may not be computed properly since we would need more variables associated with the treatment (milint)
** Such variables need not have a direct effect on the outcome (war recurrence), hence we do not control for them in the war recurrence model 



* 4 matching methods; nearest neighbor, kernel, radius, stratification

* drop observations with missing data

drop if warend2==.
drop if transpop==.

* exclude growth from the model because it has too many missing values

*** estimate propensity score for MI 

* set the seed if you want to replicate results exactly

pscore milint wartype logcost factnum transpop treaty unintrvn lngdp ef isxp2, pscore(p_mi) blockid(blockid) comsup numblo(5) logit
 
* Nearest neighbor estimation, common support

set seed 123456789

attnd warend2 milint wartype logcost factnum transpop treaty unintrvn lngdp ef isxp2, comsup boot reps(100) dots logit

* Radius estimation, common support

set seed 123456789

attr warend2 milint wartype logcost factnum transpop treaty unintrvn lngdp ef isxp2, comsup boot reps(100) dots logit radius(0.2)

* Kernel estimation, common support

set seed 123456789
 
attk warend2 milint wartype logcost factnum transpop treaty unintrvn lngdp ef isxp2, comsup boot reps(100) dots logit

* stratification estimation, common support

set seed 123456789

atts warend2 milint wartype logcost factnum transpop treaty unintrvn lngdp ef isxp2, pscore(p_mi) blockid(blockid) comsup boot reps(100) dots


clear

use "C:\MyDocuments\Military_Integration\milint_repl.dta", clear

drop if warend2==.
drop if transpop==.
drop if gdpgrofl==.

* drop cases of partition and coups (not "eligible" for MI)

drop if part==1
drop if coup==1


*** estimate propensity score for MI 

pscore milint wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2, pscore(p_mi) blockid(blockid) comsup numblo(5) logit
 
* Nearest neighbor estimation, common support

attnd warend2 milint wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2, comsup boot reps(100) dots logit

* Radius estimation (radius=1), on common support

attr warend2 milint wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2, comsup boot reps(100) dots logit radius(0.2)

* Kernel estimation, common support
 
attk warend2 milint wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2, comsup boot reps(100) dots logit

* stratification estimation, common support

atts warend2 milint wartype logcost factnum transpop treaty unintrvn lngdp gdpgrofl ef isxp2, pscore(p_mi) blockid(blockid) comsup boot reps(100) dots



********************************************************************


use "C:\MyDocuments\Military_Integration\milint_repl.dta", clear


** Long-run analysis (Table 2)

** Survival Models

drop if duration==.

stset duration, failure(peacend)

* 1

stcox wartype logcost factnum transpop ef gdpgrofl lngdp ch6 treaty isxp2 milint, cluster(clust2) nolog

* 2

stcox wartype logcost factnum transpop gdpgrofl lngdp ch6 treaty isxp2 milapp, cluster(clust2) nolog



** supplement -- test PH assumption for model 1

stcox wartype logcost factnum transpop ef gdpgrofl lngdp ch6 treaty isxp2 milint , nolog sch(sc*) scaledsch(ssc*) bases(baseline) cluster(clust2)

stphtest, rank detail

drop baseline sc* ssc*


* Re-estimate model with Cox PH, adding decade controls and re-testing the PH assumption

stcox wartype logcost factnum transpop ef gdpgrofl lngdp ch6 treaty isxp2 milint peace40 peace50 peace60 peace70 peace80, nolog sch(sc*) scaledsch(ssc*) bases(baseline) cluster(clust2)

stphtest, rank detail

drop baseline sc* ssc*


* PH assumption is rejected if we do not control for decade; and for specific variables even if we control for decade

* re-estimate model 2 - TVCs

stcox lngdp ch6 ef treaty isxp2 ,  tvc(wartype logcost factnum transpop gdpgrofl milint ) texp(ln(_t)) nolog cluster(clust2)

* implemented MI

stcox lngdp ch6 ef treaty isxp2 ,  tvc(wartype logcost factnum transpop gdpgrofl milapp)  texp(ln(_t)) nolog cluster(clust2)



** re-estimate as weibull regression

** Diagnostics

sts gen S = S

gen logS=ln(S)

graph7 logS duration, ylabel xlabel

streg duration, dist(exponential) nolog noshow

gen loglogS=ln(-ln(S))

gen logtime=ln(duration)

graph7 loglogS logtime, ylabel xlabel(0,1 to 5)


* Regression 1, Table 2

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milint, dist(weibull) cluster(clust2) nolog

* supplement

streg wartype logcost factnum elfo transpop gdpgrofl lngdp ch6 treaty isxp2 milint, dist(weibull) cluster(clust2) nolog


* Regression 2, Table 2

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milint_s, dist(weibull) cluster(clust2) nolog

* supplement -- lenient version of MI

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milint_l, dist(weibull) cluster(clust2) nolog


* Regression 3, Table 2

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milapp, dist(weibull) cluster(clust2) nolog


* Regression 4, Table 2
* add milout

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milint milout, dist(weibull) cluster(clust2) nolog


* Interactions with treaty and negotiated settlement and military integration

gen milintr=milint*treaty
gen milintns=milint*negset
gen milintr_s=milint_s*treaty
gen milintr_l=milint_l*treaty


* Regression 5, Table 2

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milintr, dist(weibull) cluster(clust2) nolog

test ch6 milintr


* Supplement - regression 5, adding decade controls

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milintr peace40 peace50 peace60 peace70 peace80, dist(weibull) cluster(clust2) nolog

test ch6 milintr

* Supplement - control for oil instead of primary commodity exports

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty oil milintr, dist(weibull) cluster(clust2) nolog


* Supplement

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milintns, dist(weibull) cluster(clust2) nolog
streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milintr_s, dist(weibull) cluster(clust2) nolog
streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milintr_l, dist(weibull) cluster(clust2) nolog



* Regression 6, Table 2
* add interaction between chapter 6 UN missions and MI; joint singnificance test

gen ch6mi=ch6*milint
streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milint ch6mi, dist(weibull) cluster(clust2) nolog
test ch6 ch6mi
test milint ch6mi



* Regression 7, Table 2
* add interaction between PPS and MI;

gen mipps=milint*pps

streg wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milint mipps, dist(weibull) cluster(clust2) nolog




******************************************************************

** Determinants of MI agreements

use "C:\MyDocuments\Military_Integration\milint_repl.dta", clear



* Regression 1, Table 3

logit milint wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milout lnwardur, cluster(clust2) nolog


* Supplement -- use GDP levels at the end of the war

gen lngdpe=ln(gdpend)

logit milint wartype logcost factnum ef transpop gdpgrofl lngdpe ch6 treaty isxp2 milout lnwardur, cluster(clust2) nolog


* Supplement
* Re-run Regression 1 dropping coups and partitions

logit milint wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milout lnwardur if coup!=1 & part!=1, cluster(clust2) nolog


* Re-run Regression 1 adding controls for non-UN peacekeeping

logit milint wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milout lnwardur nonUN, cluster(clust2) nolog

logit milint wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milout lnwardur nonUN if coup!=1 & part!=1, cluster(clust2) nolog


* Regression 2, Table 3 -- add control for africa

logit milint wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 milout lnwardur geo5, cluster(clust2) nolog



* implementation of MILINT

* Regression 3

logit milapp wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 lnwardur geo5, cluster(clust2) nolog

* Supplement: re-run the same regression, dropping coups and partitions

logit milapp wartype logcost factnum ef transpop gdpgrofl lngdp ch6 treaty isxp2 lnwardur geo5 if coup!=1 & part!=1, cluster(clust2) nolog


* supplement: check if MI implementation more likely in "harder" peacebuilding ecologies:

logit warend2 wartype logcost factnum transpop unintrvn treaty lngdp isxp2 , cluster(clust2) nolog

predict p

* drop UN

logit warend2 wartype logcost factnum transpop treaty lngdp isxp2 , cluster(clust2) nolog

predict p1


ttest p, by(milapp)

ttest p1, by(milapp)


* supplement: check if MI signing more likely in "harder" peacebuilding ecologies:


ttest p, by(milint)

ttest p1, by(milint)




log close
