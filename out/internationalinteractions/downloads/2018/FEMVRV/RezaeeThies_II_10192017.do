***Replication files for "Secrecy and Self-Interest: When Mediators Act Deceitfully" RezaeeDaryakenari and Thies.
***Questions regarding the replication of this paper can be directed to Babak RezaeeDaryakenari via email srezaeed@ASU.edu

****STATA SE 13.0***

**Please install following packages:
ssc install outreg2
**See the following link for more information: 
*http://repec.org/bocode/o/outreg2.html
ssc install regsave
**See the following link for more information: 
*http://fmwww.bc.edu/repec/bocode/r/regsave.html

**Set your working directory
*Example cd "c:\~"
cd "~"


use "bercovitch-cm2004-CodedMediatorCCode.dta", clear

**World Trade Flow covers after 1962
drop if DYearL1<1962

*** Join the Trade Similarity based on World Trade Flow. 
joinby d1 cm1 DYearL1 ccodeA ccodeB MYear ccodeMa  using "wtfTradeSimilarity.dta", unmatched(master)
drop _merge

***Join PolityIV***
rename ccodeA ccode
rename MYear year
joinby ccode year using "p4v2013.dta", unmatched(master)
drop  _merge cyear scode country flag fragment democ autoc polity durable xrreg xrcomp xropen xconst parreg parcomp exrec exconst polcomp prior emonth eday eyear eprec interim bmonth bday byear bprec post change sf regtrans
rename ccode ccodeA 
rename year MYear 

rename polity2 Polity2A
*
rename ccodeB ccode
rename MYear year
joinby ccode year using "p4v2013.dta", unmatched(master)
drop  _merge cyear scode country flag fragment democ autoc polity durable xrreg xrcomp xropen xconst parreg parcomp exrec exconst polcomp prior emonth eday eyear eprec interim bmonth bday byear bprec post change sf regtrans
rename ccode ccodeB 
rename year MYear 

rename polity2 Polity2B
*
rename ccodeMa ccode
rename MYear year
joinby ccode year using "p4v2013.dta", unmatched(master)
drop  _merge cyear scode country flag fragment democ autoc polity durable xrreg xrcomp xropen xconst parreg parcomp exrec exconst polcomp prior emonth eday eyear eprec interim bmonth bday byear bprec post change sf regtrans
rename ccode ccodeMa
rename year MYear 

rename polity2 Polity2M


*Rename cm14 as Mediation outcome
rename cm14 MedOutcome
rename cm14a MedOutcomeDum
replace MedOutcomeDum=0 if MedOutcomeDum==2

label variable MedOutcomeDum "Positive Mediation"

gen MedOutcomeDumCons=.
replace MedOutcomeDumCons=1 if MedOutcome>=4
replace MedOutcomeDumCons=0 if MedOutcome<4 & MedOutcome>=2
label variable MedOutcomeDumCons "Successful Mediation"

gen MedOutcomeDumFull=.
replace MedOutcomeDumFull=1 if MedOutcome==5
replace MedOutcomeDumFull=0 if MedOutcome<5 & MedOutcome>=2
label variable MedOutcomeDumFull "Mediation outcome(Full)"

gen MedAccepted=.
replace MedAccepted=1 if MedOutcome>1
replace MedAccepted=0 if MedOutcome==1

**HOSTILITIES REPORTED AT TIME OF INTERVENTION
rename cm15 Hostility
label variable Hostility "Hostilities at time of intervention"

**Average RANK OF NEGOTIATORS FOR PARTIES
gen Rank=(cm17a+cm17b)/2

**Number of NUMBER OF MEDIATORS ACTING IN THE MEDIATION EVENT
rename cm18 NumberMediators

**MEDIATOR EXPERIENCE
rename cm21 MediatorExperience

**CONFLICT MANAGEMENT DURATION
rename cm23 MediationDuration

**GEOGRAPHICAL PROXIMITY OF MEDIATOR	
rename cm27 Proximity

label variable Proximity "Geographic proximity of mediator"

***Sum of Polity measure for parties
gen Polity2=Polity2A+Polity2B
label variable Polity2 "Sum of polityIV"

gen Polity2Avg=(Polity2A+Polity2B)/2
gen MediatorDemocracy=0
replace MediatorDemocracy=1 if Polity2M>=6 & Polity2M!=.
label variable MediatorDemocracy "Democratic mediator"


gen Polity2Ber=p15a+p15b
replace Polity2Ber=. if Polity2Ber>20



**Cold war
gen ColdWar=.
replace ColdWar=1 if MYear>=1950 & MYear<=1990
replace ColdWar=0 if ColdWar==.
label variable ColdWar "Cold War"

****CM31	PREVIOUS CONFLICT MANAGEMENT TYPE	

rename cm31 PrevMediation
label variable PrevMediation "Previous third party intervention"

***CM34	PREVIOUS CONFLICT MANAGEMENT OUTCOME
rename cm34 PrevOutcome
label variable PrevOutcome "Previous intervention outcome"
gen PrevOutcomeDum=0
replace PrevOutcomeDum=1 if PrevOutcome==3 | PrevOutcome==4
label variable PrevOutcomeDum "Previous intervention outcome"

***CM28 UNSC PERMANENT MEMBERS AS STATE MEDIATORS

gen UNSC=.
replace UNSC=1 if cm28>0 & cm28!=.
replace UNSC=0 if UNSC==.

***label UN security council member
label variable UNSC "UNSC member" 

****D4a	DURATION (RAW)	

rename d4a ConflictDuration
label variable ConflictDuration "Conflict duration"
***D5a	FATLAITIES (RAW)
rename d5a Fatlaties

gen FatlMonth=Fatlaties/ConflictDuration
replace FatlMonth=FatlMonth/1000
label variable FatlMonth "Fatalities per month"
***D8	HOSTILITY LEVEL
rename d8 HostilityLevel
label variable HostilityLevel "The highest level of hostility"

****D12	GEOGRAPHIC REGION
rename d12 Region
label variable Region "Region"

***D13	GEOGRAPHICAL PROXIMITY OF PARTIES
rename d13 ProximityParties
label variable ProximityParties "Geographic proximity of adversaries"

***D14	CORE ISSUE
rename d14 Issue
label variable Issue "Issue"

***P3	BALANCE OF POWER INITIATOR	
rename p3 Balance
label variable Balance "Initiator's power"

*****P7	ALIGNMENT
rename p7 Alignment
label variable Alignment "Alignment"

**POWER PARTY A & B(RAW)
rename p10a PowerA
label variable PowerA "PowerA"
rename p10b PowerB
label variable PowerB "PowerB"

gen PowerDif=abs(PowerA-PowerB)
gen PowerRatio=PowerB/PowerA

***IO
gen IO=.
replace IO=1 if ccodeMa==999
replace IO=0 if ccodeMa!=999 & ccodeMa!=.
label variable IO "International organizations"


****PREVIOUS PRELATIONSHIP OF THE PARTIES WITH THE MEDIATOR 

gen Biased=0
replace Biased=1 if cm7==3
label variable Biased "Biased mediator"
**********************************************************

***
label variable TradeSim "Trade Similarity"

save "bercovitch-cm2004-CodedMediatorCCode_withIF.dta", replace

*Summary table

set matsize 11000
outreg2 using TableA1.doc if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, replace sum(log)  label ///
 keep(MedOutcomeDum MedOutcomeDumCons TradeSim  ///
 Polity2 ProximityParties ConflictDuration Issue FatlMonth Balance ///
 MediatorDemocracy Proximity Hostility PrevMediation PrevOutcomeDum UNSC Biased ///
ColdWar) 

****Regression analysis

****
reg MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

outreg2 using TableA2.doc, replace ctitle(Positive mediation-OLS)   symbol(**,*,+) addtext(Clustered error, Dispute) addstat(pseudo Log Likelihood, e(ll)) label 
  
  
reg MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility  i.PrevOutcomeDum i.UNSC i.Biased ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

outreg2 using TableA2.doc, append ctitle(Positive mediation-OLS)   symbol(**,*,+) addtext(Clustered error, Dispute) addstat(pseudo Log Likelihood, e(ll)) label 
  
probit MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

outreg2 using TableA2.doc, append ctitle(Positive mediation-Probit)   symbol(**,*,+) addtext(Clustered error, Dispute) addstat(pseudo Log Likelihood, e(ll)) label 
  
  
 probit MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility i.PrevOutcomeDum i.UNSC i.Biased ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

outreg2 using TableA2.doc, append ctitle(Positive mediation-Probit)   symbol(**,*,+) addtext(Clustered error, Dispute) addstat(pseudo Log Likelihood, e(ll)) label 
   
***********
 reg MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

outreg2 using TableA3.doc, replace ctitle(Successful mediation-OLS)   symbol(**,*,+) addtext(Clustered error, Dispute) addstat(pseudo Log Likelihood, e(ll)) label 
 
  
reg MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy i.Hostility  i.PrevOutcomeDum i.UNSC i.Biased ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

outreg2 using TableA3.doc, append ctitle(Successful mediation-OLS)   symbol(**,*,+) addtext(Clustered error, Dispute) addstat(pseudo Log Likelihood, e(ll)) label 
  
  
probit MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

outreg2 using TableA3.doc, append ctitle(Successful mediation-Probit)   symbol(**,*,+) addtext(Clustered error, Dispute) addstat(pseudo Log Likelihood, e(ll)) label 
 
  
probit MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy i.Hostility  i.PrevOutcomeDum i.UNSC i.Biased ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

outreg2 using TableA3.doc, append ctitle(Successful mediation-Probit)   symbol(**,*,+) addtext(Clustered error, Dispute) addstat(pseudo Log Likelihood, e(ll)) label 
  
 
****Selection models*****
  
heckprob MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
  if  NumberMediators==1 & ccodeMa!=999, difficult r cluster(d1) ///
  select(MedAccepted= TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 
outreg2 using Table2.doc, replace ctitle(Positive mediation) symbol(**,*,+) addtext(Clustered error, Dispute, Heckman selection, Yes) addstat(pseudo Log Likelihood, e(ll)) label 

estimates store MedOutcomeDumSelect
eststo MedOutcomeDumSelect: margins,  at(TradeSim=(0(.01)1)) post  level(95) 
 
 coefplot MedOutcomeDumSelect , at ytitle(The probability of positive mediation) xtitle(Trade interdependence) ///
 recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash)) xlabel(0(.2)1) xmtick(0(.1)1) yline(0, lp(solid))  saving(MedOutcomeDumSelect, replace) ///
 graphregion(color(white)) bgcolor(white) lcolor(black) level(95) scheme(burd3) xscale(off) 
 
****
  
histogram TradeSim  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, kdensity fraction  ysca(reverse)  ylabel(,nogrid) xtitle(Trade interdependence) ///
       xlabel(,grid gmax) saving(TradeSim, replace)  graphregion(color(white)) bgcolor(white) color(white) lcolor(black) yline(0,lcolor(black) lp(solid)) scheme(burd3)
****
 
 graph combine MedOutcomeDumSelect.gph TradeSim.gph, col(1) hole(3) imargin(0) graphregion(margin(l=22 r=22)) graphregion(color(white)) saving(Figure3a_MedOutcomeDumSelect_Margins ,replace)
 
 **
 
 heckprob MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy i.Proximity Hostility i.PrevOutcomeDum UNSC i.Biased ///
i.ColdWar ///
  if  NumberMediators==1 & ccodeMa!=999, r cluster(d1) ///
  select(MedAccepted= TradeSim i.Proximity MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 
 outreg2 using TableA4.doc, replace ctitle(Positive mediation) symbol(**,*,+) addtext(Clustered error, Dispute, Heckman selection, Yes) addstat(pseudo Log Likelihood, e(ll)) label 
 
 **************
 *************
  
heckprob MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
  if  NumberMediators==1 & ccodeMa!=999,  r cluster(d1) ///
  select(MedAccepted= TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 
outreg2 using Table2.doc, append ctitle(Successful mediation) symbol(**,*,+) addtext(Clustered error, Dispute, Heckman selection, Yes) addstat(pseudo Log Likelihood, e(ll)) label 
  

estimates store MedOutcomeDumConsSelect
eststo MedOutcomeDumConsSelect: margins,  at(TradeSim=(0(.01)1)) post  level(95) 
 
 coefplot MedOutcomeDumConsSelect , at ytitle(The probability of successful mediation) xtitle(Trade interdependence) ///
 recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash)) xlabel(0(.2)1) xmtick(0(.1)1) yline(0, lp(solid))  saving(MedOutcomeDumConsSelect, replace) ///
 graphregion(color(white)) bgcolor(white) lcolor(black) level(95) scheme(burd3) xscale(off) 
 
 graph combine MedOutcomeDumConsSelect.gph TradeSim.gph, col(1) hole(3) imargin(0) graphregion(margin(l=22 r=22)) graphregion(color(white)) saving(Figure3b_MedOutcomeDumConsSelect_Margins ,replace)
 
 **
 heckprob MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy i.Proximity Hostility i.PrevOutcomeDum UNSC i.Biased ///
i.ColdWar ///
  if  NumberMediators==1 & ccodeMa!=999, difficult r cluster(d1) ///
  select(MedAccepted= TradeSim i.Proximity MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 
 outreg2 using TableA4.doc, append ctitle(Successful mediation) symbol(**,*,+) addtext(Clustered error, Dispute, Heckman selection, Yes) addstat(pseudo Log Likelihood, e(ll)) label 
 
 
 
 ****Graphing marginal effects of selection models
 
heckprob MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
  if  NumberMediators==1 & ccodeMa!=999, difficult r cluster(d1) ///
  select(MedAccepted= TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 
 margins, dydx(TradeSim) at(TradeSim=(0(.01)1)) post  level(95) 
 
 marginsplot , ytitle(Marginal effects) xtitle(Trade interdependence) ///
 recast(line)  ciopts(recast(rline) lpattern(dash)) xlabel(0(.2)1) xmtick(0(.1)1) yline(0, lp(solid))  saving(Figre5a_MedOutcomeDumSelectdydx, replace) ///
 graphregion(color(white)) bgcolor(white)  level(95) scheme(burd3) title("")
 
 
heckprob MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
  if  NumberMediators==1 & ccodeMa!=999,  r cluster(d1) ///
  select(MedAccepted= TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 

margins, dydx(TradeSim) at(TradeSim=(0(.01)1)) post  level(95) 
 
marginsplot, ytitle(Marginal effects) xtitle(Trade interdependence) ///
 recast(line) ciopts(recast(rline) lpattern(dash)) xlabel(0(.2)1) xmtick(0(.1)1) yline(0, lp(solid))  saving(Figre5b_MedOutcomeDumConsSelectdydx, replace) ///
 graphregion(color(white)) bgcolor(white) level(95) scheme(burd3) title("")
 
 
 
 
 ******************
 *** Including International organizations
 ******************

heckprob MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
  if  NumberMediators==1,  r cluster(d1) ///
  select(MedAccepted= TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 
outreg2 using TableA5.doc, replace ctitle(Positive mediation) symbol(**,*,+) addtext(Clustered error, Dispute, Heckman selection, Yes) addstat(pseudo Log Likelihood, e(ll)) label 
  

heckprob MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
  if  NumberMediators==1,  r cluster(d1) ///
  select(MedAccepted= TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 
outreg2 using TableA5.doc, append ctitle(Successful mediation) symbol(**,*,+) addtext(Clustered error, Dispute, Heckman selection, Yes) addstat(pseudo Log Likelihood, e(ll)) label 
  
*************


***Checking for multicollinearity

  reg MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility  i.PrevOutcomeDum i.UNSC i.Biased ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

  vif
  *The high level of VIF here is mbecuase of including TradeSim and its square, so the correlation between ///
  ** TradeSim and control variables does not cause multicollinearity problem:

  reg MedOutcomeDumCons TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility  i.PrevOutcomeDum i.UNSC i.Biased ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

vif

***Now, VIF is within acceptable range**

***Another approach can be just centering Trade similarity, then we can see VIF is small and our results do not change significantly.
*Here is a discussion of reading VIF in models with the interaction term: https://statisticalhorizons.com/multicollinearity 

  sum TradeSim, meanonly
  gen centered_TradeSim = TradeSim - r(mean)
  
  

  reg MedOutcomeDumCons centered_TradeSim c.centered_TradeSim#c.centered_TradeSim  ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility  i.PrevOutcomeDum i.UNSC i.Biased ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

  vif
  
   
probit MedOutcomeDumCons centered_TradeSim c.centered_TradeSim#c.centered_TradeSim   ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy i.Hostility  i.PrevOutcomeDum i.UNSC i.Biased ///
  if MedOutcome>=2 & NumberMediators==1 & ccodeMa!=999, r cluster(d1)

  
heckprob MedOutcomeDumCons centered_TradeSim c.centered_TradeSim#c.centered_TradeSim ///
 Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
 MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
  if  NumberMediators==1 & ccodeMa!=999, difficult r cluster(d1) ///
  select(MedAccepted= centered_TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
 
 
 
**********Checking for Over fit Problem*******
***Note: This section randomly draws samples, so the replicated results are not exactly identical to ///
*what are reported in the paper. However, the patterns of these simulated models and their interpretation ///
*should be similar to what are reported in the paper.


***Positive mediation
local replace "replace"

forval k=1/200 {
	use "bercovitch-cm2004-CodedMediatorCCode_withIF.dta", clear
	keep if NumberMediators==1 & ccodeMa!=999
	sample 160, count
		capture quietly heckprob MedOutcomeDum TradeSim c.TradeSim#c.TradeSim  ///
						Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
						MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
						if  NumberMediators==1 & ccodeMa!=999, r cluster(d1) iterate(1000) ///
		select(MedAccepted= TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
		capture noisily regsave TradeSim c.TradeSim#c.TradeSim using tmpfile, level(90) addlabel(SampleNo,`k') p ci  `replace' 
	local replace "append"
	display `k'
	}


use tmpfile, clear
drop if var=="MedAccepted:TradeSim"


twoway (scatter SampleNo coef,msymbol(O) mlcolor(black)) ///
 (rcap ci_upper ci_lower SampleNo, horizontal lwidth(.2) lcolor(black) ) ///
 if var=="MedOutcomeDum:TradeSim" , xtitle(Trade interdependence with 90% CI) ytitle(Sample number) ///
 legend(off) xline(0,lwidth(.5) lcolor(black)) scheme(burd) saving(FigureA3a_CoefCIPositiveTrade ,replace)

kdensity coef if var=="MedOutcomeDum:TradeSim", ///
 scheme(burd) note("") title("") legend(off) xtitle(Trade interdependence) saving(FigureA3c_KernelPositiveTrade ,replace)
 
twoway (scatter SampleNo coef,msymbol(O) mlcolor(black)) (rcap ci_upper ci_lower SampleNo, horizontal lwidth(.2) lcolor(black)) ///
 if var=="MedOutcomeDum:c.TradeSim#c.TradeSim", xtitle(Trade interdependence(square) with 90% CI) ytitle(Sample number) ///
 legend(off) xline(0,lwidth(.5) lcolor(black)) scheme(burd) saving(FigureA3b_CoefCIPositiveTrade2 ,replace)

kdensity coef if var=="MedOutcomeDum:c.TradeSim#c.TradeSim", ///
 scheme(burd) note("") title("") legend(off) xtitle(Trade interdependence(square)) saving(FigureA3d_KernelPositiveTrade2 ,replace)




 
***Successful mediation
local replace "replace"

forval k=1/200 {
	use "bercovitch-cm2004-CodedMediatorCCode_withIF.dta", clear
	keep if NumberMediators==1 & ccodeMa!=999
	sample 160, count
		capture quietly heckprob MedOutcomeDumCons TradeSim c.TradeSim#c.TradeSim  ///
						Polity2 i.ProximityParties ConflictDuration i.Issue FatlMonth i.Balance ///
						MediatorDemocracy Hostility i.PrevOutcomeDum UNSC i.Biased ///
						if  NumberMediators==1 & ccodeMa!=999, r cluster(d1) iterate(1000) ///
		select(MedAccepted= TradeSim MediatorDemocracy i.ProximityParties Hostility i.PrevOutcomeDum Polity2 i.Issue ConflictDuration FatlMonth i.Balance UNSC i.Biased ) 
		capture noisily regsave TradeSim c.TradeSim#c.TradeSim using tmpfile, level(90) addlabel(SampleNo,`k') p ci  `replace' 
	local replace "append"
	display `k'
	}


use tmpfile, clear
drop if var=="MedAccepted:TradeSim"


twoway (scatter SampleNo coef,msymbol(O) mlcolor(black)) ///
 (rcap ci_upper ci_lower SampleNo, horizontal lwidth(.2) lcolor(black) ) ///
 if var=="MedOutcomeDumCons:TradeSim" , xtitle(Trade interdependence with 90% CI) ytitle(Sample number) ///
 legend(off) xline(0,lwidth(.5) lcolor(black)) scheme(burd) saving(FigureA4a_CoefCISuccessfulTrade ,replace)

kdensity coef if var=="MedOutcomeDumCons:TradeSim", ///
 scheme(burd) note("") title("") legend(off) xtitle(Trade interdependence) saving(FigureA4c_KernelSuccessfulTrade ,replace)
 
twoway (scatter SampleNo coef,msymbol(O) mlcolor(black)) (rcap ci_upper ci_lower SampleNo, horizontal lwidth(.2) lcolor(black)) ///
 if var=="MedOutcomeDumCons:c.TradeSim#c.TradeSim", xtitle(Trade interdependence(square) with 90% CI) ytitle(Sample number) ///
 legend(off) xline(0,lwidth(.5) lcolor(black)) scheme(burd) saving(FigureA4b_CoefCISuccessfulTrade2 ,replace)

kdensity coef if var=="MedOutcomeDumCons:c.TradeSim#c.TradeSim", ///
 scheme(burd) note("") title("") legend(off) xtitle(Trade interdependence(square)) saving(FigureA4d_KernelSuccessfulTrade2 ,replace)

