
*** Analysis: Smidt (2015, November) From a perpetrator’s perspective: International election observers and post-electoral violence
*** Replication do-file 
*** Please note that replication code occurs in the order of the analysis in the article;
*** Code to replicate Figure 3 and the predictions for Kenya can be found at the end of this do-file
*** Code to replicate Figure 1 and for predictions in Table 2 are in separate do-files ("Figure 1.do" and "Table 2 - Predictions.do")

set more off
clear
version 13.0


use "AnalysisData_JPR.dta", clear


* p.10: "The theoretical argument is evaluated in an analysis of 230 state-wide elections held in 43 African states between 1990 and 2009."
codebook country
codebook electiondate

* p.11: "Of the 230 elections in the sample, more than four violent 
* 	events occurred in six post-electoral periods and between one and four violent events occurred in 42 post-electoral periods."
tab PostElectionViolence
display 4+2
display 27+7+7+1

* p. 13: Of 169 non-monitored elections 9 suffer from both post-electoral repression and opposition-sponsored violence, 
* 14 only experience repression and 6 only violence by opposition groups. 
* Of 61 monitored elections, 7 suffer from one or more events of repression 
* and opposition-sponsored violence, 6 only see repression and another 6 only opposition-sponsored violence after election day
tab PostElectionViolenceD largemonitored
tab PostElectionViolenceD largemonitored if RepressionPost>0 & OppViolPost>0
tab PostElectionViolenceD largemonitored if RepressionPost>0 & OppViolPost==0
tab PostElectionViolenceD largemonitored if RepressionPost==0 & OppViolPost>0

* p. 13: 37 percent of the elections in the sample are highly fraudulent. 
* Monitors are present in more than one fifth of the highly fraudulent elections (20 of 86). 
* 13 of these elections experience one or more events of post-electoral violence, 
* thereof 6 from both sides, 5 only from the government and 2 only from opposition groups
tab fraud
tab fraud largemonitored, row
tab PostElectionViolenceD largemonitored if fraud==1
tab PostElectionViolenceD largemonitored if RepressionPost>0 & OppViolPost>0 & fraud==1
tab PostElectionViolenceD largemonitored if fraud==1 & RepressionPost>0 & OppViolPost==0
tab PostElectionViolenceD largemonitored if fraud==1 & RepressionPost==0 & OppViolPost>0


** Table VII in appendix: Summary statistics
#delimit ;
estpost summarize RepressionPost RepressionPostDays OppViolPost OppViolPostDays
OppViolPostD RepressionPostD OppViolPre RepressionPre PostElectionViolence
largemonitored 
fraud polity2lag NELDA24 netoda_ln ln_gdpcaplag ln_pop media_bias eneop
monitored lowqual_nomix ;
#delimit cr
esttab, cells("mean sd min max count") noobs

* Not in paper: Table with summary statistics for robustness test DVs for intra-opposition violence
#delimit ;
estpost summarize OppViolBetwPost OppViolBetwPre OppViolBetwIssuesPost OppViolBetwIssuesPre
OppViolAllPost OppViolAllPre  OppViolAllIssuesPost OppViolAllIssuesPre ;
#delimit cr
esttab, cells("mean sd min max count") noobs



** Figure 2: Evidence against endogneity concerns

capture drop y1
gen y1 = .
sum RepressionPost if largemonitored==1 // monitored
replace y1 = r(mean) in 1
sum RepressionPost if  largemonitored==0 &  NELDA48!=1 & NELDA49!=1 // not monitored
replace y1 = r(mean) in 2
sum RepressionPost if  NELDA48==1 | NELDA49==1 // monitoring refused
replace y1 = r(mean) in 3

capture drop y2
gen y2 = .
replace y2 = 0 in 4
sum OppViolPost if  largemonitored==1 // monitored
replace y2 = r(mean) in 5
sum OppViolPost if   largemonitored==0 &  NELDA48!=1 & NELDA49!=1 // not monitored
replace y2 = r(mean) in 6
sum OppViolPost if  NELDA48==1 | NELDA49==1 // monitoring refused
replace y2 = r(mean) in 7

capture drop x
gen x = .
forvalues i = 1(1)7{
replace x = `i' in `i'
}


#delimit ;
twoway bar y1 x, vertical fcolor(gs4) lcolor(gs0) barwidth(0.9)
|| bar y2 x, vertical fcolor(gs10) lcolor(gs0) barwidth(0.9)
xscale(off)
ysca(r(0 .4))
ylabel(0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4)
xtitle("") xticks("")
b2title("Mean number of violent events")
legend(ring(0) pos(2) label(1 "Government") label(2 "Opposition"))
text(.16 1 "Monitored", placement(s) orientation(rvertical) color(white))
text(.16 2 "Non-monitored", placement(s) orientation(rvertical) color(white))
text(.16 3 "Monitoring refused", placement(s) orientation(rvertical) color(white))
text(.16 5 "Monitored", placement(s) orientation(rvertical))
text(.12 6 "Non-monitored", placement(s) orientation(rvertical))
text(.16 7 "Monitoring refused", placement(s) orientation(rvertical))
scheme(p2bar) graphregion(fcolor(white) lstyle(none));
#delimit cr

drop x y1 y2

* p. 16: This concern is aggravated by the fact that observers eschew democracies and autocracies, 
* as they may not require monitoring or merit monitoring efforts, respectively. 
* Observers most frequently go to hybrid regimes that exhibit a mixture of democratic and autocratic characteristics. 
* For testing whether observers cause opposition-sponsored violence, 
* this is problematic since hybrid regimes also exhibit the highest levels of opposition-sponsored violence and repression
capture drop regime
gen regime=1 if polity2lag>6
replace regime = 2 if  polity2lag<=6 &  polity2lag>=-6
replace regime = 3 if polity2lag<-6

tab largemonitored regime, row chi2


* Distribution of repression and opp-sponsored violence conditional on regime type
tabstat RepressionPost, by(regime)
ttest RepressionPost if regime>=2, by(regime) // significant on 10%, e.g. autocracies more violence
ttest RepressionPost if regime<=2, by(regime) // not significant

tabstat OppViolPost, by(regime)
ttest OppViolPost if regime>=2, by(regime) // not significant
ttest OppViolPost if regime<=2, by(regime) // significant on 10%, e.g. democracies less viol.

* Only non-monitored elections
tabstat RepressionPost if largemonitored==0, by(regime)
ttest RepressionPost if regime>=2 & largemonitored==0, by(regime) // not significant
ttest RepressionPost if regime<=2 & largemonitored==0, by(regime) // not significant

tabstat OppViolPost if largemonitored==0, by(regime)
ttest OppViolPost if regime>=2 & largemonitored==0, by(regime) // not significant
ttest OppViolPost if regime<=2 & largemonitored==0, by(regime) // not significant

* Only monitored elections
tabstat RepressionPost if largemonitored==1, by(regime)
ttest RepressionPost if regime>=2 & largemonitored==1, by(regime) // not significant
ttest RepressionPost if regime<=2 & largemonitored==1, by(regime) // not significant

tabstat OppViolPost if largemonitored==1, by(regime)
ttest OppViolPost if regime>=2 & largemonitored==1, by(regime) // not significant
ttest OppViolPost if regime<=2 & largemonitored==1, by(regime) /// not significant



****************
*** ANALYSIS ***

**** Table II:

* Model 1: Government-sponsored post-electoral violence
set seed 1234

#delimit ;
nbreg RepressionPost largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;

outreg2 using "Table1.doc", replace ctitle(Model 1) dec(3) eqdrop(lnalpha) ;

#delimit cr


* Model 2: Opposition-sponsored post-electoral violence
#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud RepressionPostD 
OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;

outreg2 using "Table1.doc", append ctitle(Model 2) dec(3) eqdrop(lnalpha);
#delimit cr


* Marginal effects, predicted probabilities and first differences below




* Matching model
set seed 1234
drop if ccode==.
imb polity2lag netoda_ln violpastelec prevfraud NELDA2, treatment(largemonitored)
cem polity2lag(#4) netoda_ln(#4) violpastelec prevfraud NELDA2, treatment(largemonitored)

* Model 3: Matched sample
capture drop b*
#delimit ; 
estsimp nbreg RepressionPost largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias [iweight=cem_weights], cluster(ccode);
outreg2 using "Table1.doc", append ctitle(Model 3: CEM) dec(3) eqdrop(lnalpha) ;
#delimit cr

capture drop ev00
capture drop ev10
capture drop ev01
capture drop ev11
capture drop fd 
capture drop fd1 
capture drop fd0

setx mean 
setx largemonitored 0 fraud 0 largemonitored_fraud 0
simqi, ev genev(ev00)

setx largemonitored 1*1
simqi, ev genev(ev10)

setx largemonitored 0*0 fraud 1*1 
simqi, ev genev(ev01)

setx largemonitored 1*1 fraud 1*1 largemonitored_fraud 1*1
simqi, ev genev(ev11)

gen fd0=ev10-ev00
gen fd1=ev11-ev01
sum fd0, d
sum fd1, d


capture drop b*
#delimit ;
estsimp nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias [iweight=cem_weights], cluster(ccode) ;

outreg2 using "Table1.doc", append ctitle(Model 4: CEM) dec(3) eqdrop(lnalpha) ;
#delimit cr


capture drop ev00
capture drop ev10
capture drop ev01
capture drop ev11
capture drop fd 
capture drop fd1 
capture drop fd0

setx mean 
setx largemonitored 0 fraud 0 largemonitored_fraud 0
simqi, ev genev(ev00)

setx largemonitored 1*1
simqi, ev genev(ev10)

setx largemonitored 0*0 fraud 1*1 
simqi, ev genev(ev01)

setx largemonitored 1*1 fraud 1*1 largemonitored_fraud 1*1
simqi, ev genev(ev11)

gen fd0=ev10-ev00
gen fd1=ev11-ev01
sum fd0, d
sum fd1, d



*** Table II in do_file Table2_predictions

*** For Figure 3 see end of this do-file

*** Table III: 

** Table III, model 5 and 6: Event days
* of repression
set seed 1234
#delimit ;
nbreg RepressionPostDays largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;

outreg2 using "Table3.doc", replace ctitle(Model 5) eqdrop(lnalpha) dec(3);
#delimit cr

* of opposition violence
#delimit ;
nbreg OppViolPostDays largemonitored 
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;

outreg2 using "Table3.doc", append ctitle(Model 6) eqdrop(lnalpha) dec(3);
#delimit cr


*** tabel III, model 7 abd 8: Without Outliers

* Outliers in data for DV event count
tab RepressionPost
list electionid country if RepressionPost>3 & country!=""
// 475-1999-0227-P1 Nigeria (1999), 475-1999-0220-L1 Nigeria (1999) and 437-2000-1022-P1 Cote d'Ivoire (2000)
tab OppViolPost
list electionid country if OppViolPost>3 & country!=""
//501-1997-1229-LP1     Kenya

set seed 1234
#delimit ;
nbreg RepressionPost largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias
if electionid!="475-1999-0227-P1" & electionid!="475-1999-0220-L1" & electionid!="437-2000-1022-P1" 
& electionid!="501-1997-1229-LP1",  cluster(ccode) ;

outreg2 using "Table3.doc", append ctitle(Model 7) eqdrop(lnalpha) dec(3);
#delimit cr


#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias
if electionid!="475-1999-0227-P1" & electionid!="475-1999-0220-L1" & electionid!="437-2000-1022-P1" 
& electionid!="501-1997-1229-LP1",  cluster(ccode) ;

outreg2 using "Table3.doc", append ctitle(Model 8) eqdrop(lnalpha) dec(3);
#delimit cr


** Table III, model 9 and 10: With control for opposition fragmentation
#delimit ;
nbreg RepressionPost largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias eneop,  cluster(ccode) ;
outreg2 using "Table3.doc", append ctitle(Model 9) eqdrop(lnalpha) dec(3);
#delimit cr


#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias eneop,  cluster(ccode) ;

outreg2 using "Table3.doc", append ctitle(Model 10) eqdrop(lnalpha) dec(3);
#delimit cr






**** Robustness tests for online appendix


*** Table IV: Negative binomial model on election-related (E) 
***			  and non-issue-specific (¬E) intra-opposition groups violence and 
***			  total opposition group violence after election day

* tabel IV, model 11: In between opposition violence/election-related
set seed 1234
#delimit ;
nbreg OppViolBetwPost largemonitored 
fraud largemonitored_fraud
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24 eneop
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode);

outreg2 using "Table4.doc", replace ctitle(Model 11) eqdrop(lnalpha) dec(3);
#delimit cr


* tabel IV, model 12: Between-opposition violence/ all issues
#delimit ;
nbreg OppViolBetwIssuesPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24 eneop
netoda_ln ln_gdpcaplag ln_pop media_bias ,  cluster(ccode) ;

outreg2 using "Table4.doc", append ctitle(Model 12) eqdrop(lnalpha) dec(3);
#delimit cr

* tabel IV, model 13: Anti-government and between-opposition violence/ election-related
#delimit ;
nbreg OppViolAllPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24 eneop
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table4.doc", append ctitle(Model 13) eqdrop(lnalpha) dec(3);
#delimit cr

* tabel IV, model 14: Anti-government and between-opposition violence/ all issues
#delimit ;
nbreg OppViolAllIssuesPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24 eneop
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;

outreg2 using "Table4.doc", append ctitle(Model 14) eqdrop(lnalpha) dec(3);
#delimit cr



* tabel IV, model 15: In between opposition violence/election-related
* With interaction effect
capture gen largemonitored_eneop = largemonitored*eneop
set seed 1234
#delimit ;
nbreg OppViolBetwPost largemonitored largemonitored_eneop
fraud largemonitored_fraud
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24 eneop
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode);

outreg2 using "Table4cont.doc", replace ctitle(Model 15) eqdrop(lnalpha) dec(3);
#delimit cr

* tabel IV, model 16: Between-opposition violence/ all issues
#delimit ;
nbreg OppViolBetwIssuesPost largemonitored largemonitored_eneop
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24 eneop
netoda_ln ln_gdpcaplag ln_pop media_bias ,  cluster(ccode) ;

outreg2 using "Table4cont.doc", append ctitle(Model 16) eqdrop(lnalpha) dec(3);
#delimit cr

* tabel IV, model 17: Anti-government and between-opposition violence/ election-related
#delimit ;
nbreg OppViolAllPost largemonitored largemonitored_eneop
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24 eneop
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table4cont.doc", append ctitle(Model 17) eqdrop(lnalpha) dec(3);
#delimit cr

* tabel IV, model 18: Anti-government and between-opposition violence/ all issues
#delimit ;
nbreg OppViolAllIssuesPost largemonitored largemonitored_eneop
fraud largemonitored_fraud 
RepressionPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24 eneop
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;

outreg2 using "Table4cont.doc", append ctitle(Model 18) eqdrop(lnalpha) dec(3);
#delimit cr



*** Table V and VI: Models with different combinations of control variables:

** Table V: Government-sponsored repression:

set seed 1234
#delimit ;
nbreg RepressionPost largemonitored
fraud largemonitored_fraud 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table5.doc", replace ctitle(Model 19) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg RepressionPost largemonitored
fraud largemonitored_fraud 
OppViolPostD
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table5.doc", append ctitle(Model 20) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg RepressionPost largemonitored
fraud largemonitored_fraud 
OppViolPostD
RepressionPre 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table5.doc", append ctitle(Model 21) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg RepressionPost largemonitored
fraud largemonitored_fraud 
OppViolPostD
RepressionPre OppViolPre
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table5.doc", append ctitle(Model 22) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg RepressionPost largemonitored
fraud largemonitored_fraud 
OppViolPostD
RepressionPre OppViolPre
polity2lag polity2lag2
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table5.doc", append ctitle(Model 23) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg RepressionPost largemonitored
fraud largemonitored_fraud 
OppViolPostD
RepressionPre OppViolPre
polity2lag polity2lag2
NELDA24
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table5.doc", append ctitle(Model 24) eqdrop(lnalpha) dec(3);
#delimit cr


#delimit ;
nbreg RepressionPost largemonitored
fraud largemonitored_fraud 
OppViolPostD
RepressionPre OppViolPre
polity2lag polity2lag2
NELDA24 eneop
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table5.doc", append ctitle(Model 25) eqdrop(lnalpha) dec(3);
#delimit cr


#delimit ;
nbreg RepressionPost largemonitored
fraud largemonitored_fraud 
OppViolPostD
RepressionPre OppViolPre
polity2lag polity2lag2
NELDA24 eneop netoda_ln
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table5.doc", append ctitle(Model 26) eqdrop(lnalpha) dec(3);
#delimit cr

* Why is the coefficient for observers insignificant when not controlling for post-electoral opposition violence
tab largemonitored OppViolPost, col chi2
tab RepressionPost OppViolPost, col chi2
spearman RepressionPost OppViolPost 
// Both pearson chi squared test and spearman's rank correlation
// coefficient indicate that there is a statistically significant, positive relationship 
// between monitoring and levels of opposition-sponsored violence on the one hand
// and levels of repression and levels of opposition-sponsored violence on the other hand.
// Hence, observers' violence reducing effect are under-estimated when not controlling for
// repression, since the government likely react with repression to opposition violence and 
// monitors increase opposition violence.



** Table V: Opposition-sponsored violence

set seed 1234
#delimit ;
nbreg OppViolPost largemonitored
fraud largemonitored_fraud 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table6.doc", replace ctitle(Model 27) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg OppViolPost largemonitored
fraud largemonitored_fraud 
RepressionPostD 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table6.doc", append ctitle(Model 28) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD 
OppViolPre 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table6.doc", append ctitle(Model 29) eqdrop(lnalpha) dec(3);
#delimit cr


#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD 
OppViolPre 
RepressionPre 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table6.doc", append ctitle(Model 30) eqdrop(lnalpha) dec(3);
#delimit cr


#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD 
OppViolPre 
RepressionPre 
polity2lag polity2lag2 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table6.doc", append ctitle(Model 31) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD 
OppViolPre 
RepressionPre 
polity2lag polity2lag2 
NELDA24
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table6.doc", append ctitle(Model 32) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD 
OppViolPre 
RepressionPre 
polity2lag polity2lag2 
NELDA24 
eneop
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table6.doc", append ctitle(Model 33) eqdrop(lnalpha) dec(3);
#delimit cr

#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD 
OppViolPre 
RepressionPre 
polity2lag polity2lag2 
NELDA24 
eneop
netoda_ln 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
outreg2 using "Table6.doc", append ctitle(Model 34) eqdrop(lnalpha) dec(3);
#delimit cr


* Why is observers' effect not statistically significant when not controlling for
* post-electoral repression, pre-electoral opposition violence and pre-electoral repression and
* polity IV score and its squared terms

* Test of my assumption is that the effect hinges on the fact that observers go to more violence-prone regimes
#delimit ;
nbreg OppViolPost largemonitored 
fraud largemonitored_fraud 
RepressionPostD 
RepressionPre 
polity2lag polity2lag2 
ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
#delimit cr

spearman RepressionPre polity2lag polity2lag2

*1)
tab largemonitored RepressionPre, col chi2 // significant positive association between monitoring and repression before elections

*2)
spearman RepressionPre polity2lag // less pre-electoral repression in more democratic regimes.
spearman RepressionPre polity2lag2 // less pre-electoral repression in more 'hybrid' regimes.

*3)
tab largemonitored polity2lag, col chi2 // significant association between monitoring and regime type
tab largemonitored polity2lag2, col chi2 // significant association between monitoring and regime type


// Observers are more likely to go to violence-prone elections in hyrbid regimes
// The insignificant effect of observers on post-electoral violence is likely due to correlations among 
// the three independent varables. First, pre-electoral repression is positively and significantly associated with 
// election monitoring (Pearson chi2(7) =  13.4765   Pr = 0.061)
// Second, pre-electoral repression, however, is negatively associated with more democratic regimes (rho=-0.13, p=0.045)
// In other words, there is less pre-electoral repression in full democracies and regimes with some democratic characteristics. 
// Third, regimes with more democratic characteristics are associated with more frequent international election monitoring.
// (Pearson chi2(20) =  35.8891   Pr = 0.016).
// Therefore, the effect of observers is under-estimated when not controlling for regime type
// and pre-electoral repression since observers are often present in hybrid regimes 
// where less pre-electoral repression is associated with less post-electoral violent protest by opposition groups.




*** Table IX: Contolling for existence of pro-government militias)
* (For Review round 2: Additional robustness tests)

set seed 1234
#delimit ;
nbreg RepressionPost largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias PGMs,  cluster(ccode) ;

outreg2 using "Table9.doc", replace ctitle(Model 35) eqdrop(lnalpha) dec(3); // appendix 9
#delimit cr





** Figure 3 


* Hypothesis 1, Table 1 Model 1
capture drop b*
#delimit ;
estsimp nbreg RepressionPost largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
#delimit cr

capture drop ev_*
#delimit ;
setx largemonitored 0 OppViolPostD mean 
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_00) //no monitors, no fraud

#delimit ;
setx largemonitored 1 OppViolPostD mean 
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean  media_bias mean ;
#delimit cr
simqi, ev genev(ev_10) // monitors, no fraud

#delimit ;
setx largemonitored 0 OppViolPostD mean 
fraud 1 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_01) // no monitors, fraud

#delimit ;
setx largemonitored 1 OppViolPostD mean 
fraud 1 largemonitored_fraud 1 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_11) // monitors and fraud

* Effect of observers conditional on fraud
capture drop fd_obs_*
gen fd_obs_nofraud=ev_10-ev_00 // observers, no fraud
gen fd_obs_fraud=ev_11-ev_01 // observers, fraud
sum fd_obs_nofraud, d
sum fd_obs_fraud, d


* Prepare graph by saving predicted probabilities
capture drop PrObs 
capture drop CIlowPrObs 
capture drop CIhighPrObs

gen PrObs =.
gen CIlowPrObs95 = .
gen CIhighPrObs95 = .

* 95% CI
centile fd_obs_nofraud, centile(2 3 5 50 95 97 98) // effect of observers
replace PrObs = r(c_4) in 1
replace CIlowPrObs95 = (r(c_1)+r(c_2))/2 in 1
replace  CIhighPrObs95 = (r(c_6)+r(c_7))/2 in 1

centile fd_obs_fraud, centile(2 3 5 50 95 97 98) // effect of observers
replace PrObs = r(c_4) in 2
replace CIlowPrObs95 = (r(c_1)+r(c_2))/2 in 2
replace  CIhighPrObs95 = (r(c_6)+r(c_7))/2 in 2


* Hypothesis 2, Table 1 Model 1
capture drop b* 
#delimit ;
estsimp nbreg OppViolPost largemonitored 
fraud largemonitored_fraud RepressionPostD 
OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
#delimit cr

capture drop ev_opp00
capture drop ev_opp10
capture drop ev_opp01
capture drop ev_opp11
#delimit ;
setx largemonitored 0 RepressionPostD mean 
fraud 0 largemonitored_fraud 0 
OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_opp00) // no monitors, no fraud

#delimit ;
setx largemonitored 1 RepressionPostD mean 
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_opp10) // monitors, no fraud

#delimit ;
setx largemonitored 0 RepressionPostD mean 
fraud 1 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_opp01) // no monitors, fraud

#delimit ;
setx largemonitored 1 RepressionPostD mean 
fraud 1 largemonitored_fraud 1 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_opp11) // monitors, fraud


* Effect of observers conditional on fraud
capture drop  fd_obs_opp_nofraud  fd_obs_opp_fraud
gen fd_obs_opp_nofraud=ev_opp10-ev_opp00 // observers, no fraud
gen fd_obs_opp_fraud=ev_opp11-ev_opp01 // observers, fraud
sum fd_obs_opp_nofraud, d
sum fd_obs_opp_fraud, d

* Graph of effect observers on opposition-sponsored violence
capture drop Obs_Observers 
gen Obs_Observers = .
replace Obs_Observers=0.2 in 1 
replace Obs_Observers=0.3 in 2
replace Obs_Observers=0.6 in 3
replace Obs_Observers=0.7 in 4


* Prepare graph by saving predicted probabilities
centile fd_obs_opp_nofraud, centile(2 3 5 50 95 97 98) // FD
replace PrObs = r(c_4) in 3
replace CIlowPrObs95 = (r(c_1)+r(c_2))/2 in 3
replace  CIhighPrObs95 = (r(c_6)+r(c_7))/2 in 3

centile fd_obs_opp_fraud, centile(2 3 5 50 95 97 98) // FD
replace PrObs = r(c_4) in 4
replace CIlowPrObs95 = (r(c_1)+r(c_2))/2 in 4
replace  CIhighPrObs95 = (r(c_6)+r(c_7))/2 in 4


#delimit ;
graph twoway rcapsym CIlowPrObs95 CIhighPrObs95 Obs_Observers,  msymbol(i) lcolor(gs8) lwidth(medthick) vertical
|| scatter PrObs Obs_Observers ,  msymbol(D) mcolor(black) msize(large)
yline(0, lpattern(dash) lcolor(black))
ysca(r(0 0.45))
xsca(r(0.1 0.8))
ylabel(-0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4)
xlabel(0.2 "No fraud" 0.3 "Fraud"  0.6 "No fraud" 0.7 "Fraud", angle(0) ) 
l1title("")  l2title("Difference in predicted count of violence", size(3.8)) 
xtitle("")
text(-0.25 0.15 "Government violence", placement(e))
text(-0.25 0.55 "Opposition violence", placement(e) )
legend(off)
scheme(p1bar) graphregion(fcolor(white));
#delimit cr





** Predictions for Kenya (p. 19)
* Hypothesis 1, Table 1 Model 1
capture drop b*
set seed 1234
#delimit ;
estsimp nbreg RepressionPost largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
#delimit cr

** Effect of IEO for a country in the sample: Kenya 2007
list OppViolPostD fraud largemonitored_fraud OppViolPre RepressionPre if electionid=="501-2007-1227-LP1"
//|        1       1          1         		 0          1 |
list polity2lag polity2lag2 NELDA24 netoda_ln ln_gdpcaplag ln_pop media_bias if electionid=="501-2007-1227-LP1"
// 8         64        no   6.900741   7.141925     1.63446        2.079442

capture drop ev_kenya01 
#delimit ;
setx largemonitored 0 OppViolPostD 1
fraud 1 largemonitored_fraud 0 OppViolPre 0 RepressionPre 1
polity2lag 8 polity2lag2 64 NELDA24 0 
netoda_ln 6.9 ln_gdpcaplag 7.14 ln_pop   1.63446 media_bias 2.079442 ;
#delimit cr
simqi, ev genev(ev_kenya01) // no monitors, fraud

capture drop ev_kenya11 
#delimit ;
setx largemonitored 1 OppViolPostD 1
fraud 1 largemonitored_fraud 1 OppViolPre 0 RepressionPre 1
polity2lag 8 polity2lag2 64 NELDA24 0 
netoda_ln 6.9 ln_gdpcaplag 7.14 ln_pop   1.63446 media_bias 2.079442 ;
#delimit cr
simqi, ev genev(ev_kenya11) // monitors, fraud


capture drop ev_kenya00
#delimit ;
setx largemonitored 0 OppViolPostD 1
fraud 0 largemonitored_fraud 0 OppViolPre 0 RepressionPre 1
polity2lag 8 polity2lag2 64 NELDA24 0 
netoda_ln 6.9 ln_gdpcaplag 7.14 ln_pop   1.63446 media_bias 2.079442 ;
#delimit cr
simqi, ev genev(ev_kenya00) // no monitors, no fraud

capture drop ev_kenya10
#delimit ;
setx largemonitored 1 OppViolPostD 1
fraud 0 largemonitored_fraud 0 OppViolPre 0 RepressionPre 1
polity2lag 8 polity2lag2 64 NELDA24 0 
netoda_ln 6.9 ln_gdpcaplag 7.14 ln_pop   1.63446 media_bias 2.079442 ;
#delimit cr
simqi, ev genev(ev_kenya10) // monitors, no fraud

sum ev_kenya01, d
sum ev_kenya11, d
sum ev_kenya00, d
sum ev_kenya10, d
capture drop fd_kenya0 fd_kenya1
gen fd_kenya1=ev_kenya11-ev_kenya01
gen fd_kenya0=ev_kenya10-ev_kenya00
sum fd_kenya1, d // Predicted first difference in government violence in Kenya with fraud
sum fd_kenya0, d // Predicted first difference in government violence in Kenya without fraud


* Hypothesis 2, Table 1 Model 1
capture drop b* 
set seed 1234
#delimit ;
estsimp nbreg OppViolPost largemonitored 
fraud largemonitored_fraud RepressionPostD 
OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
#delimit cr


* Effect of IEO for a country in the sample: Kenya 2007
list RepressionPostD fraud largemonitored_fraud OppViolPre RepressionPre if electionid=="501-2007-1227-LP1"
//|        1       1          1          0          1 |
list polity2lag polity2lag2 NELDA24 netoda_ln ln_gdpcaplag ln_pop media_bias if electionid=="501-2007-1227-LP1"
// 8         64        no   6.900741   7.141925   1.63446   2.079442

capture drop ev_kenya00 ev_kenya10 ev_kenya01 ev_kenya11
capture drop fd_kenya0 fd_kenya1

#delimit ;
setx largemonitored 0 RepressionPostD 1
fraud 0 largemonitored_fraud 0 OppViolPre 0 RepressionPre 1
polity2lag 8 polity2lag2 64 NELDA24 0 
netoda_ln 6.9 ln_gdpcaplag 7.14 ln_pop  1.63446 media_bias 2.079442 ;
#delimit cr
simqi, ev genev(ev_kenya00) // no monitors, no fraud

#delimit ;
setx largemonitored 1 RepressionPostD 1
fraud 0 largemonitored_fraud 0 OppViolPre 0 RepressionPre 1
polity2lag 8 polity2lag2 64 NELDA24 0 
netoda_ln 6.9 ln_gdpcaplag 7.14 ln_pop  1.63446 media_bias 2.079442 ;
#delimit cr
simqi, ev genev(ev_kenya10) // monitors, no fraud

#delimit ;
setx largemonitored 0 RepressionPostD 1
fraud 0 largemonitored_fraud 0 OppViolPre 0 RepressionPre 1
polity2lag 8 polity2lag2 64 NELDA24 0 
netoda_ln 6.9 ln_gdpcaplag 7.14 ln_pop  1.63446 media_bias 2.079442 ;
#delimit cr
simqi, ev genev(ev_kenya01) // no monitors, fraud

#delimit ;
setx largemonitored 1 RepressionPostD 1
fraud 1 largemonitored_fraud 1 OppViolPre 0 RepressionPre 1
polity2lag 8 polity2lag2 64 NELDA24 0 
netoda_ln 6.9 ln_gdpcaplag 7.14 ln_pop  1.63446 media_bias 2.079442 ;
#delimit cr
simqi, ev genev(ev_kenya11) // monitors, fraud

sum ev_kenya00, d
sum ev_kenya10, d
sum ev_kenya01, d
sum ev_kenya11, d
gen fd_kenya0=ev_kenya10-ev_kenya00 // without fraud
gen fd_kenya1=ev_kenya11-ev_kenya01 // with fraud
sum fd_kenya0, d // Predicted first difference in opposition violence in Kenya withour fraud
sum fd_kenya1, d // Predicted first difference in opposition violence in Kenya withour fraud



** Drop estimated or generated vars
drop b1-b15
drop  ev_00-CIhighPrObs
drop if country==""

