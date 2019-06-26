* ***************************************************************** *
* ***************************************************************** *
*   File-Name:      Replication.File.Steinert.do         			*
*   Author:         Christoph Steinert                              *
*   Title:          Spoilers of Peace: PGMs as risk factors of      *
*                   conflict recurrence                             *
* ***************************************************************** *
* ***************************************************************** *

clear
version 14.1
capture log close
set more off

cd ""
/// set to respective working directory
use "Dataset_1.dta"
log using ./log, replace

* Renaming of variables
rename PGMActivityduringconflicta pgma
rename T5PGMPresenceandActivity pgma5
rename Conflictactivitybutnotcounte noci
rename Peacekeepingoperationwithin5 peacekeep
rename DemocracywithPolityIVatt polityt
rename GDPpercapitaatt gdpcap
rename Postconflictrelapse prelapse
rename Yearsuntilpostconflictresu yearsuntilrelapse
rename EthnicFractionalization ethnic
rename Averagemilitaryexpenditure milexp
rename PGMactivityinyearofrelapse relapseactive

* Label Variables
lab var pgma "PGM activitiy"
lab define pgma ///
                0  "no previous PGM activity" ///
                1  "previous PGM activitiy" 
				
lab var peacekeep "Peacekeeping"				
lab define peacekeep ///
                0  "no Peacekeeping" ///
                1  "Peacekeeping" 

lab var noci "Not counterinsurgent"
lab define noci ///
                0  "active as counterinsurgent" ///
                1  "not active as counterinsurgent" 

lab var pcj_dummy "Post-conflict justice"
lab define pcj_dummy ///
				0  "no post-conflict justice" ///
				1  "post-conflict justice"
				
lab var prelapse "Post-conflict relapse"
lab define prelapse ///
				0  "no post-conflict relapse" ///
				1  "post-conflict relapse"
				
* Drop cases without PGM information before PGMD was existent
drop if epend < 1981

* Generate duration of conflict & logged GDP per capita & logged battle deaths
gen duration = epend - epbegin +1
hist gdpcap, freq
*highly skewed distribution --> logarithmic transformation
gen gdpcap_log = log(gdpcap)
hist gdpcap_log, freq
hist btldeath, freq
sum btldeath, detail
*highly skewed distribution --> logarithmic tansformation
gen battledeath_log = log(btldeath)
hist battledeath_log, freq

* Exclude PGM Activities during conflict where PGM is not coded with one of the following targets:
* (rebels, insurgents, government critics, or unarmed political opposition)
recode pgma (1=0) if noci==1

* Encode termination variable
codebook termination
encode termination, gen(termin) label(conflict-termination)
codebook termin
label define termin 1 "bargained solution" 2 "other" 3 "victory"
codebook termin

* Generate bargained solution-dummy
gen bargainedsol = .
replace bargainedsol = 1 if termin == 1
replace bargainedsol = 0 if termin == 2 & 3

* Gererate an interaction term for democracy variable:
gen deminter = polityt*polityt
label var deminter "Interaction Term Democracy"

* Robustness tests: 1. Multicollinearity
*findit collin
collin prelapse duration pgma battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy

* Robustness test: 2. Specification error
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy
linktest
/// linktest uses the linear predicted value and the squared linear predicted value as explanatory variables to rebuild the model. 
/// _hat is expected to be significant since it is the predicted value from the model -> that is the case
/// when _hatsq is significant, then indication that there are relevant omitted variables -> that is not the case
/// ==> no cause of concern

* Robustness test: 3. Influential observations
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy, cluster(location) 
predict p
predict stdres, rstand
scatter stdres p, yline(0)
gen id=_n
graph set window fontface "Times New Roman"
scatter stdres id, yline(0) mlab(pperid) scheme(s1mono) 
gen LabVa= location if pperid=="174_1990"
scatter stdres id, yline(0) mlab(LabVa) scheme(s1mono)
*graph export imageH.tif, width(3900)
/// 174_1990 (Papua New Guinea) might be problematic
predict dv, dev
scatter dv p, mlab(pperid) scheme(s1mono) 
/// Check influence on regression coefficients
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp IrregularDummy deminter, cluster(location)
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp IrregularDummy deminter pcj_dummy, cluster(location)
gen outlier = .
replace outlier = 0 if pperid != "174_1990"
drop if missing(outlier)

* Percentage of conflicts with PGM activity as counterinsurgents
tab pgma
tab prelapse
tab prelapse pgma, freq
tab prelapse pgma, column
tab prelapse pgma, row
tab prelapse pgma, row column 

* With N=123
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
* Drop two cases without PGM activity in recurred conflict
drop if pperid == "214_1999"
drop if pperid == "195_1993"
* With N=121
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy pcj_dummy, cluster(location)
gen sample=e(sample)
recode sample(0=.)
drop if missing(sample)

* Summary statistics of variables
*ssc install outreg2
outreg2 using x.doc, replace sum(log)

* Percentage of conflicts with PGM activity as counterinsurgents
tab pgma
tab prelapse
tab prelapse pgma, freq
tab prelapse pgma, column
tab prelapse pgma, row
tab prelapse pgma, row column 

* Graph row percentages
gen rowactive = .
replace rowactive = 75.0
label var rowactive "conflicts with PGM activities"
gen rownotactive = .
replace rownotactive = 25.0
label var rownotactive "conflicts without PGM activities"

#delimit ;
graph bar rowactive rownotactive, 
scheme(s1mono) 
blabel(bar, position(outside)) 
bargap(100) nofill
legend(off) 
ylabel(0 10 20 30 40 50 60 70 80)
ytitle("Percentage of relapses (to total of relapses)")
name(graphZ, replace);
#delimit cr	
*graph export imageA.tif, width(3900)

* Graph column percentages
gen columnactive = .
replace columnactive = 46.15
label var columnactive "conflicts with PGM activities"
gen columnnotactive = .
replace columnnotactive = 27.91
label var columnnotactive "conflicts without PGM activities"

#delimit ;
graph bar columnactive columnnotactive, 
scheme(s1mono) 
blabel(bar, position(outside)) 
bargap(100) nofill
legend(off) 
ytitle("Percentage of relapses" "(to total of conflicts for each group)")
ylabel(0 10 20 30 40 50 60)
name(graphY, replace);
#delimit cr	
*graph export imageB.tif, width(3900)

* Check correlation between IV and controls as a test for inclusion
corr pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic pcj_dummy bargainedsol milexp deminter IrregularDummy

* Test effect of PGM activity on conflict resurgence
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter, cluster(location)
logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy, cluster(location)

* Test whether PGMs became rebel groups
tab pperid if prelapse == 1 & pgma == 1

* Representation of results in regression tables
*findit esttab
eststo clear
quietly logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
eststo Model1
quietly logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
eststo Model2
estout
esttab using Models12.rtf, ar2 append

* Check the mode of dummy variables
codebook peacekeep
codebook bargainedsol
codebook IrregularDummy
*0 as mode for both dummy variables

* Simulation to improve interpretations of results
*findit clarify
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12

* generate fd by hand, because fd() wrapper does not allow to genetare variable
setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 /* 97.5% simulations >0 if sims(1000)  */
                        /* 97.8% simulations >0 if sims(10000) */

simqi, fd(prval(1)) changex(pgma 0 1)

* Create variable for simulated probability of conflict recurrence after PGM activity
setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1
setx
simqi, genpr(t0 t1) level(95)
sum t0 t1
_pctile t1, p(2.5,97.5)
scalar    lo100 = r(r1)
scalar    up100 = r(r2)

* Create variable for simulated probability of conflict recurrence after no PGM activity
setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1
setx
simqi, genpr(t2 t3) level(95)
sum t2 t3
simqi
_pctile t3, p(2.5,97.5)
scalar    lo101 = r(r1)
scalar    up101 = r(r2)

* Graph of statistical simulation results
dis lo100
* .52112103
dis up100
* .74754319
sum t1
* .639558 

dis lo101
* .12015083
dis up101
* .61539567
sum t3
* .3361021 

clear
input int x float(high low mean)
1 .74754319 .52112103 .639558
2 .61539567 .12015083 .3361021
end

#delimit ;
twoway rcap high low x  || scatter mean x, mcolor(black) msize(small) legend(off) 
xlabel(1 `" "PGM activity" "in previous conflict" "' 2 `" "no PGM activity" "in previous conflict" "', labsize(small)) 
xscale(range(0 3))
ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%") 
xtitle("")
scheme(s1mono)  
ytitle("Expected likelihood of conflict resurgence") 
name(graphx, replace);
#delimit cr	
*graph export imageC.tif, width(3900)

* Graph second model statistical simulation
use "Dataset_1.dta", clear

rename PGMActivityduringconflicta pgma
rename T5PGMPresenceandActivity pgma5
rename Conflictactivitybutnotcounte noci
rename Peacekeepingoperationwithin5 peacekeep
rename DemocracywithPolityIVatt polityt
rename GDPpercapitaatt gdpcap
rename Postconflictrelapse prelapse
rename Yearsuntilpostconflictresu yearsuntilrelapse
rename EthnicFractionalization ethnic
rename Averagemilitaryexpenditure milexp

lab var pgma "PGM activitiy"
lab define pgma ///
                0  "no PGM activity" ///
                1  "PGM activitiy" 
				
lab var peacekeep "Peacekeeping"				
lab define peacekeep ///
                0  "no Peacekeeping" ///
                1  "Peacekeeping" 

lab var noci "Not counterinsurgent"
lab define noci ///
                0  "active as counterinsurgent" ///
                1  "not active as counterinsurgent" 

lab var pcj_dummy "Post-conflict justice"
lab define pcj_dummy ///
				0  "no post-conflict justice" ///
				1  "post-conflict justice"
				
drop if epend < 1981

gen duration = epend - epbegin +1
gen gdpcap_log = log(gdpcap)
gen battledeath_log = log(btldeath)

recode pgma (1=0) if noci==1

codebook termination
encode termination, gen(termin) label(conflict-termination)
label define termin 1 "bargained solution" 2 "other" 3 "victory"
codebook termin

gen bargainedsol = .
replace bargainedsol = 1 if termin == 1
replace bargainedsol = 0 if termin == 2 & 3

gen deminter = polityt*polityt
label var deminter "Interaction Term Democracy"

*Mode of PCJ-dummy
codebook pcj_dummy
* mode is 0

************************

* Test if results hold when two cases are excluded, where PGMs not active in recurred conflict
drop if pperid == "214_1999"
drop if pperid == "195_1993"
drop if pperid == "174_1990"

* Simulation to improve interpretations of results
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

* Create variable for simulated probability of conflict recurrence after PGM activity
setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1 pcj_dummy 0
setx
simqi, genpr(t0 t1) level(95)
sum t0 t1
_pctile t1, p(2.5,97.5)
scalar    lo100 = r(r1)
scalar    up100 = r(r2)

* Create variable for simulated probability of conflict recurrence after no PGM activity
setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1 pcj_dummy 0
setx
simqi, genpr(t2 t3) level(95)
sum t2 t3
simqi
_pctile t3, p(2.5,97.5)
scalar    lo101 = r(r1)
scalar    up101 = r(r2)


dis lo100
* .58885461
dis up100
* .84825197
sum t1
* .7317176   
dis lo101
* .22449312 
dis up101
* .78321913
sum t3
* .5053508    

clear
input int x float(high low mean)
1 .84825197 .58885461 .7317176 
2 .78321913 .22449312 .5053508  
end

#delimit ;
twoway rcap high low x  || scatter mean x, mcolor(black) msize(small) legend(off) 
xlabel(1 `" "PGM activity" "in previous conflict" "' 2 `" "no PGM activity" "in previous conflict" "', labsize(small)) 
xscale(range(0 3))
ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%") 
xtitle("")
scheme(s1mono)  
ytitle("Expected likelihood of conflict resurgence") 
name(graphB, replace);
#delimit cr
*graph export imageC.tif, width(3900)

* Matching as robustnest check
use "Dataset_2.dta", clear

* Test if results hold when two cases are excluded, where PGMs not active in recurred conflict
drop if pperid == "174_1990"
drop if pperid == "214_1999"
drop if pperid == "195_1993"

*Create IrregularDummy
replace IrregularDummy=1 if Irregular==1
replace IrregularDummy=0 if Conventional==1
replace IrregularDummy=0 if SNC==1
replace IrregularDummy=0 if Coup==1
replace IrregularDummy=. if Irregular==.
replace IrregularDummy=0 if AlternativeConventional==1
replace IrregularDummy=1 if Alternativeirregular==1
replace IrregularDummy=1 if Irregular==. & AlternativeConventional==. & Alternativeirregular==.

*Kernel Propensity Score Matching
drop pscore
logit pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy, cluster(location)
predict pscore
sum pscore
psmatch2 pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy, out(prelapse) kernel kerneltype(normal) ate
pstest, both graph scheme(s1mono) 
bootstrap r(att) : psmatch2 pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy, out(prelapse) kernel kerneltype(tricube) 
teffects psmatch (prelapse) (pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy, probit), atet
drop pscore

*Caliper Propensity Score Matching
logit pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy, cluster(location)
predict pscore
sum pscore
psmatch2 pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy, out(prelapse) radius caliper(.3)
pstest, both graph scheme(s1mono) 
bootstrap r(att) : psmatch2 pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy, out(prelapse) radius caliper(.3)
teffects psmatch (prelapse) (pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy, probit), atet 
drop pscore

*Kernel Propensity Score Matching with PCJ
logit pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy pcj_dummy, cluster(location)
predict pscore
sum pscore
psmatch2 pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy pcj_dummy, out(prelapse)  kernel kerneltype(normal) ate
pstest, both graph scheme(s1mono) 
*graph export image5.tif, width(3900)
bootstrap r(att) : psmatch2 pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy pcj_dummy, out(prelapse) kernel kerneltype(tricube) 
teffects psmatch (prelapse) (pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy pcj_dummy, probit), atet
drop pscore

*Caliper Propensity Score Matching with PCJ
logit pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy pcj_dummy, cluster(location)
predict pscore
sum pscore
psmatch2 pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy pcj_dummy, out(prelapse) radius caliper(.3)
pstest, both graph scheme(s1mono) 
*graph export image6.tif, width(3900)
bootstrap r(att) : psmatch2 pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy pcj_dummy, out(prelapse) radius caliper(.3)
teffects psmatch (prelapse) (pgma duration battledeath_log polityt gdpcap_log ethnic bargainedsol deminter IrregularDummy pcj_dummy, probit), atet 
drop pscore

*Model with PCJ-Dummy
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse pgma IrregularDummy duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

*Model without PCJ-Dummy
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse pgma IrregularDummy duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)


* Robustness check: Retesting the model with different year of conflict relapse
clear 
use "Dataset_1.dta", clear

rename PGMActivityduringconflicta pgma
rename T5PGMPresenceandActivity pgma5
rename Conflictactivitybutnotcounte noci
rename Peacekeepingoperationwithin5 peacekeep
rename DemocracywithPolityIVatt polityt
rename GDPpercapitaatt gdpcap
rename Postconflictrelapse prelapse
rename Yearsuntilpostconflictresu yearsuntilrelapse
rename EthnicFractionalization ethnic
rename Averagemilitaryexpenditure milexp

lab var pgma "PGM activitiy"
lab define pgma ///
                0  "no PGM activity" ///
                1  "PGM activitiy" 
				
lab var peacekeep "Peacekeeping"				
lab define peacekeep ///
                0  "no Peacekeeping" ///
                1  "Peacekeeping" 

lab var noci "Not counterinsurgent"
lab define noci ///
                0  "active as counterinsurgent" ///
                1  "not active as counterinsurgent" 

lab var pcj_dummy "Post-conflict justice"
lab define pcj_dummy ///
				0  "no post-conflict justice" ///
				1  "post-conflict justice"
				
drop if epend < 1981

gen duration = epend - epbegin +1
gen gdpcap_log = log(gdpcap)
gen battledeath_log = log(btldeath)

recode pgma (1=0) if noci==1

codebook termination
encode termination, gen(termin) label(conflict-termination)
label define termin 1 "bargained solution" 2 "other" 3 "victory"
codebook termin

gen bargainedsol = .
replace bargainedsol = 1 if termin == 1
replace bargainedsol = 0 if termin == 2 & 3

gen deminter = polityt*polityt
label var deminter "Interaction Term Democracy"

* Test if results hold when two cases are excluded, where PGMs not active in recurred conflict
drop if pperid == "214_1999"
drop if pperid == "195_1993"
drop if pperid == "195_1993"

* Different years of conflict relapse	
gen prelapse6=.
replace prelapse6 = 1 if yearsuntilrelapse < 7
replace prelapse6 = 0 if yearsuntilrelapse > 6
gen prelapse7=.
replace prelapse7 = 1 if yearsuntilrelapse < 8
replace prelapse7 = 0 if yearsuntilrelapse > 7
gen prelapse8=.
replace prelapse8 = 1 if yearsuntilrelapse < 9
replace prelapse8 = 0 if yearsuntilrelapse > 8
gen prelapse9=.
replace prelapse9 = 1 if yearsuntilrelapse < 10
replace prelapse9 = 0 if yearsuntilrelapse > 9
gen prelapse10=.
replace prelapse10 = 1 if yearsuntilrelapse < 11
replace prelapse10 = 0 if yearsuntilrelapse > 10
gen prelapse4=.
replace prelapse4 = 1 if yearsuntilrelapse < 5
replace prelapse4 = 0 if yearsuntilrelapse > 4
gen prelapse3=.
replace prelapse3 = 1 if yearsuntilrelapse < 4
replace prelapse3 = 0 if yearsuntilrelapse > 3
gen prelapse2=.
replace prelapse2 = 1 if yearsuntilrelapse < 3
replace prelapse2 = 0 if yearsuntilrelapse > 2

logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
logit prelapse6 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
logit prelapse7 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
logit prelapse8 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
logit prelapse9 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
logit prelapse10 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
logit prelapse4 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
logit prelapse3 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
logit prelapse2 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)

logit prelapse pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter, cluster(location)
logit prelapse6 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
logit prelapse7 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
logit prelapse8 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
logit prelapse9 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
logit prelapse10 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
logit prelapse4 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
logit prelapse3 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
logit prelapse2 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)

* Report results of robustness test
quietly logit prelapse6 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
eststo model12
quietly logit prelapse8 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
eststo model13
quietly logit prelapse10 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location)
eststo model14
estout
esttab using model4.rtf, ar2 append

quietly logit prelapse6 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
eststo model12
quietly logit prelapse8 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
eststo model13
quietly logit prelapse10 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location)
eststo model14
estout
esttab using model5.rtf, ar2 append


* Simulations of re-estimated models
* 6 years
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse6 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

* 7 years
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse7 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

* 8 years
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse8 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

* 9 years
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse9 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

* 10 years
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse10 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

* 4 years
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse4 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

* 3 years
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse3 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter pcj_dummy IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean pcj_dummy 0 IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

* 2 years
capture drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
capture drop fdiff pgma0 pgma1
set seed 1234   
estsimp logit prelapse2 pgma duration battledeath_log peacekeep polityt gdpcap_log ethnic bargainedsol milexp deminter IrregularDummy, cluster(location) sims(10000)
sum b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11

setx pgma 1 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1 
setx
simqi, prval(1) genpr(pgma1)

setx pgma 0 duration mean battledeath_log mean peacekeep 0 polityt mean gdpcap_log mean ethnic mean bargainedsol 0 milexp mean deminter mean IrregularDummy 1
setx
simqi, prval(1) genpr(pgma0)

gen fdiff = pgma1-pgma0
sumqi fdiff
sum fdiff if fdiff >= 0 

simqi, fd(prval(1)) changex(pgma 0 1)

*****************************************************************************************************************************************************
log close
exit
