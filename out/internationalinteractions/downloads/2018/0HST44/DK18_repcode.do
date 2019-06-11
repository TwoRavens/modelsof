// Replication data for "Economics, Security, and Individual-level Preferences for Trade Agreements"


use DK18_rep, clear




// Figure 2

// 1: the plots with both economic and securtiy but only from the non-control arms

eststo a2: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2, robust cl(responseid)
eststo a3: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3, robust cl(responseid)


 global drops 0.regime 1.regime 2.regime 3.regime 4.regime 5.regime 0.jobs 1.jobs 2.jobs 3.jobs 4.jobs 0.USgrowth 1.USgrowth 2.USgrowth 0.TPgrowth 1.TPgrowth 2.TPgrowth
 #delimit ;  
 coefplot (a2,  ) , bylabel(Global Influence)  ///
 ||       (a3,  ), bylabel(Political Relations)  || , xline(0)  baselevels drop(_cons )
 headings(0.jobs ="{bf:Jobs}" 0.USgrowth ="{bf:US Growth}" 0.regime ="{bf:Regime & Wealth}" 0.TPgrowth ="{bf:Partner Growth}"  0.geopolC ="{bf:Global Influence}" 0.partner ="{bf:Potential Trade Partner}", labcolor(navy) )
 scheme(s1mono) omit name(Arm23, replace) coeflabels( , labsize(vsmall) ) 
 msymbol(circle) msize(small) mcolor(red) ciopts(lwidth(*2) lcolor(navy)) 
 xscale(range(-.2 .2))  xlabel(-.2(.1).2) legend(off)
xtitle("       Average Change in the Probability a Profile is Chosen", size(small)); 
 #delimit cr  
 
 
// Table 2: 
 
use DK18_rep, clear 
 
global jobs manyjob somejob  costsomejob costmanyjob
global grow siggrowsUS somgrowsUS 
global tpgrow siggrowOther somgrowOther 
global regime pdem mdem wdem pudem mudem 
global mediator1 increaseGeo diminishGeo maintainGeo 
global mediator2 ally rival noallyrival ourside rivalside

foreach m of varlist $mediator1{
regress binary `m' $jobs $grow $tpgrow $regime `m'#c.($jobs $grow $tpgrow $regime) if Group==1 | `m' ==1 , robust cl(responseid)
est sto _`m'
}
foreach m of varlist $mediator2{
regress binary `m' $jobs $grow $tpgrow $regime `m'#c.($jobs $grow $tpgrow $regime) if Group==1 | `m' ==1 , robust cl(responseid)
}
	

	
////////////////	
//   Appendix	
////////////////	
	

 use DK18_rep, clear 


// Table C.1 Summary Stats
#delimit ; 
bys Group: outreg2 using Repsumstat.doc, replace sum(log) eqkeep(N mean) label
keep(male somecollege black hisp republican independent democrat
liberal conservative protrade Unemployed LowIncome Hawk PassCheck age);
#delimit cr 
 
 
// Figure D.1 
 use DK18_rep, clear 


gen groupL = "A" if Group==1
replace groupL = "B" if Group==2
replace groupL = "C" if Group==3

local list A B C
//forval i = 1/3{
foreach i of local list {
regress binary i.regime i.jobs i.USgrowth i.TPgrowth i.geopolB i.partnerB if groupL=="`i'" , robust cl(responseid)

#delimit ;  
 coefplot, xline(0) drop(_cons) 
 headings(0.regime = "{bf: Regime and Wealth}"  0.jobs = "{bf:Effect on Jobs}" 
 0.USgrowth ="{bf:Effect on Economy}" 0.TPgrowth ="{bf:Effect on Partner Economy}"
  1.geopolB ="{bf:Non-Economic Effect}" 1.partnerB ="{bf:Potential Trade Partner}" , labcolor(navy) )
 scheme(s1mono) omit title("Arm `i'", size(small)) name(`i', replace) coeflabels( , labsize(vsmall) ) 
 msymbol(p) mcolor(red) ciopts(lwidth(*2) lcolor(blue)) 
 xscale(range(-.3 .3))  xlabel(-.3(.1).3)
 xtitle("Average Change in the Probability a Profile is Chosen", size(small)); 

 #delimit cr 
//graph export "figures_tables/group`i'.pdf", replace
}

foreach i of local list {
qui regress binary i.regime i.jobs i.USgrowth i.TPgrowth i.geopolB i.partnerB if groupL=="`i'" , robust cl(responseid)
est sto a`i'
}


// Figure D.6 & Table D.2
// Results exlcuding respondents that failed the attention checks.


use DK18_rep, clear 
keep if attck2==1 

gen groupL = "A" if Group==1
replace groupL = "B" if Group==2
replace groupL = "C" if Group==3

local list A B C
//forval i = 1/3{
foreach i of local list {
regress binary i.regime i.jobs i.USgrowth i.TPgrowth i.geopolB i.partnerB if groupL=="`i'" , robust cl(responseid)

#delimit ;  
 coefplot, xline(0) drop(_cons) 
 headings(0.regime = "{bf: Regime and Wealth}"  0.jobs = "{bf:Effect on Jobs}" 
 0.USgrowth ="{bf:Effect on Economy}" 0.TPgrowth ="{bf:Effect on Partner Economy}"
  1.geopolB ="{bf:Non-Economic Effect}" 1.partnerB ="{bf:Potential Trade Partner}" , labcolor(navy) )
 scheme(s1mono) omit title(Arm `i', size(small)) name(`i', replace) coeflabels( , labsize(vsmall) ) 
 msymbol(p) mcolor(red) ciopts(lwidth(*2) lcolor(blue)) 
 xscale(range(-.3 .3))  xlabel(-.3(.1).3)
  xtitle("Average Change in the Probability a Profile is Chosen", size(small)); 
 #delimit cr 

//graph export "figures_tables/group`i' passcheck.pdf", replace
}



gen g2 = (Group==2)
gen g3 = (Group==3)

lab var g2 "Security Arm 1"
lab var g2 "Security Arm 2"


global jobs manyjob somejob  costsomejob costmanyjob
global grow siggrowsUS somgrowsUS 
global tpgrow siggrowOther somgrowOther 
global regime pdem mdem wdem pudem mudem 
global mediator1 increaseGeo diminishGeo maintainGeo 
global mediator2 ally rival noallyrival ourside rivalside
global mediator2B ally_siggrowOther ally_somgrowOther  rival_siggrowOther rival_somgrowOther  noallyrival_siggrowOther  ourside_siggrowOther ourside_somgrowOther  rivalside_siggrowOther rivalside_somgrowOther 




est clear 
foreach m of varlist $mediator1 $mediator2{
foreach z of varlist $jobs $grow $tpgrow $regime{
gen __`z'= `m'*`z'
}

regress binary `m' $jobs $grow $tpgrow $regime __* if Group==1 | `m' ==1 , robust cl(responseid)
est sto _`m'
drop __*

}

 
 
 
// Figure D.4: Alignment and trade partner growth
use DK18_rep, clear 

label var ally "Ally"
label var rival "Rival"
 
foreach var of varlist ally rival noallyrival ourside rivalside  {
cap gen `var'_siggrowOther  = (`var'==1 &  siggrowOther==1)
local lab: variable label `var' 

label var `var'_siggrowOther "`lab' * Sig. growth"

cap gen `var'_somgrowOther = (`var'==1 &  somgrowOther==1)
label var `var'_somgrowOther "`lab' * Some growth"

cap gen `var'_nogrowOther = (`var'==1 &  nogrowOther==1)
label var `var'_nogrowOther "`lab' *  No growth"
}


global interact ally_siggrowOther ally_somgrowOther rival_siggrowOther rival_somgrowOther   ourside_siggrowOther ourside_somgrowOther rivalside_siggrowOther rivalside_somgrowOther

	
	regress binary i.regime i.jobs i.USgrowth i.TPgrowth i.partner $interact if Group==3, robust cl(responseid)
  
 #delimit ;  
 coefplot, xline(0) drop(_cons) keep(0.TPgrowth 1.TPgrowth 2.TPgrowth 0.partner 1.partner 2.partner  $interactB) 
 headings(
0.TPgrowth = "{bf:AMCE-Effect on Partner}"
 0.partner = "{bf:AMCE-Partner}"
 ally_siggrowOther ="{bf:Interaction Term}" 
 , labcolor(navy) ) baselevels
  scheme(s1mono) omit title()  coeflabels( , labsize(small) ) 
msymbol(circle) msize(small) mcolor(red) ciopts(lwidth(*2) lcolor(navy))
 name(g3b, replace); 
  #delimit cr  

 
 
/// Figures D.8 through D.12 (Heterogenous Treatment Effects)
use DK18_rep, clear 


// Figure D.8

eststo a2liberal0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & liberal==0, robust cl(responseid)
eststo a2liberal1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & liberal==1, robust cl(responseid)

eststo a3liberal0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & liberal==0, robust cl(responseid)
eststo a3liberal1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & liberal==1, robust cl(responseid)


 global drops 0.regime 1.regime 2.regime 3.regime 4.regime 5.regime 0.jobs 1.jobs 2.jobs 3.jobs 4.jobs 0.USgrowth 1.USgrowth 2.USgrowth 0.TPgrowth 1.TPgrowth 2.TPgrowth
 #delimit ;  
 coefplot (a2liberal0, label(Not Liberal) ) (a2liberal1, label(Liberal)) , bylabel(Global Influence)  ///
 ||       (a3liberal0, label(Not Liberal) ) (a3liberal1, label(Liberal)), bylabel(Political Relations)  || , xline(0)  baselevels drop(_cons )
 headings(0.jobs ="{bf:Jobs}" 0.USgrowth ="{bf:US Growth}" 0.regime ="{bf:Regime & Wealth}" 0.TPgrowth ="{bf:Partner Growth}"  0.geopolC ="{bf:Global Influence}" 0.partner ="{bf:Potential Trade Partner}", labcolor(navy) )
 scheme(s1mono) omit name(Arm23, replace) coeflabels( , labsize(vsmall) ) 
 msymbol(circle) msize(small) ciopts(lwidth(*1) ) 
 xscale(range(-.2 .2))  xlabel(-.2(.1).2) legend(off)
xtitle("       Average Change in the Probability a Profile is Chosen", size(small)); 
 #delimit cr  


// Figure D.9


eststo a2somecollege0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & somecollege==0, robust cl(responseid)
eststo a2somecollege1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & somecollege==1, robust cl(responseid)

eststo a3somecollege0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & somecollege==0, robust cl(responseid)
eststo a3somecollege1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & somecollege==1, robust cl(responseid)


 global drops 0.regime 1.regime 2.regime 3.regime 4.regime 5.regime 0.jobs 1.jobs 2.jobs 3.jobs 4.jobs 0.USgrowth 1.USgrowth 2.USgrowth 0.TPgrowth 1.TPgrowth 2.TPgrowth
 #delimit ;  
 coefplot (a2somecollege0, label(No college) ) (a2somecollege1, label(Some college)) , bylabel(Global Influence)  ///
 ||       (a3somecollege0, label(No college) ) (a3somecollege1, label(Some college)), bylabel(Political Relations)  || , xline(0)  baselevels drop(_cons )
 headings(0.jobs ="{bf:Jobs}" 0.USgrowth ="{bf:US Growth}" 0.regime ="{bf:Regime & Wealth}" 0.TPgrowth ="{bf:Partner Growth}"  0.geopolC ="{bf:Global Influence}" 0.partner ="{bf:Potential Trade Partner}", labcolor(navy) )
 scheme(s1mono) omit name(Arm23, replace) coeflabels( , labsize(vsmall) ) 
 msymbol(circle) msize(small) ciopts(lwidth(*1) ) 
 xscale(range(-.2 .2))  xlabel(-.2(.1).2) legend(off)
xtitle("       Average Change in the Probability a Profile is Chosen", size(small)); 
 #delimit cr  



// Figure D.10
 
 eststo a2LowIncome0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & LowIncome==0, robust cl(responseid)
eststo a2LowIncome1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & LowIncome==1, robust cl(responseid)

eststo a3LowIncome0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & LowIncome==0, robust cl(responseid)
eststo a3LowIncome1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & LowIncome==1, robust cl(responseid)


 global drops 0.regime 1.regime 2.regime 3.regime 4.regime 5.regime 0.jobs 1.jobs 2.jobs 3.jobs 4.jobs 0.USgrowth 1.USgrowth 2.USgrowth 0.TPgrowth 1.TPgrowth 2.TPgrowth
 #delimit ;  
 coefplot (a2LowIncome0, label(High income) ) (a2LowIncome1, label(Low income)) , bylabel(Global Influence)  ///
 ||       (a3LowIncome0, label(High income) ) (a3LowIncome1, label(Low income)), bylabel(Political Relations)  || , xline(0)  baselevels drop(_cons )
 headings(0.jobs ="{bf:Jobs}" 0.USgrowth ="{bf:US Growth}" 0.regime ="{bf:Regime & Wealth}" 0.TPgrowth ="{bf:Partner Growth}"  0.geopolC ="{bf:Global Influence}" 0.partner ="{bf:Potential Trade Partner}", labcolor(navy) )
 scheme(s1mono) omit name(Arm23, replace) coeflabels( , labsize(vsmall) ) 
 msymbol(circle) msize(small) ciopts(lwidth(*1) ) 
 xscale(range(-.2 .2))  xlabel(-.2(.1).2) legend(off)
xtitle("       Average Change in the Probability a Profile is Chosen", size(small)); 
 #delimit cr  
 
 
 // Figure D.11
 
 eststo a2male0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & male==0, robust cl(responseid)
eststo a2male1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & male==1, robust cl(responseid)

eststo a3male0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & male==0, robust cl(responseid)
eststo a3male1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & male==1, robust cl(responseid)


 global drops 0.regime 1.regime 2.regime 3.regime 4.regime 5.regime 0.jobs 1.jobs 2.jobs 3.jobs 4.jobs 0.USgrowth 1.USgrowth 2.USgrowth 0.TPgrowth 1.TPgrowth 2.TPgrowth
 #delimit ;  
 coefplot (a2male0, label(female) ) (a2male1, label(male)) , bylabel(Global Influence)  ///
 ||       (a3male0, label(female) ) (a3male1, label(male)), bylabel(Political Relations)  || , xline(0)  baselevels drop(_cons )
 headings(0.jobs ="{bf:Jobs}" 0.USgrowth ="{bf:US Growth}" 0.regime ="{bf:Regime & Wealth}" 0.TPgrowth ="{bf:Partner Growth}"  0.geopolC ="{bf:Global Influence}" 0.partner ="{bf:Potential Trade Partner}", labcolor(navy) )
 scheme(s1mono) omit name(Arm23, replace) coeflabels( , labsize(vsmall) ) 
 msymbol(circle) msize(small) ciopts(lwidth(*1) ) 
 xscale(range(-.2 .2))  xlabel(-.2(.1).2) legend(off)
xtitle("       Average Change in the Probability a Profile is Chosen", size(small)); 
 #delimit cr  
 
 
//Figure D.12 
 
eststo a2protrade0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & protrade==0, robust cl(responseid)
eststo a2protrade1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.geopolC if Group==2 & protrade==1, robust cl(responseid)

eststo a3protrade0: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & protrade==0, robust cl(responseid)
eststo a3protrade1: regress binary i.jobs i.USgrowth i.regime  i.TPgrowth i.partner if Group==3 & protrade==1, robust cl(responseid)


 global drops 0.regime 1.regime 2.regime 3.regime 4.regime 5.regime 0.jobs 1.jobs 2.jobs 3.jobs 4.jobs 0.USgrowth 1.USgrowth 2.USgrowth 0.TPgrowth 1.TPgrowth 2.TPgrowth
 #delimit ;  
 coefplot (a2protrade0, label(Not Pro-Trade) ) (a2protrade1, label(Pro-Trade)) , bylabel(Global Influence)  ///
 ||       (a3protrade0, label(Not Pro-Trade) ) (a3protrade1, label(Pro-Trade)), bylabel(Political Relations)  || , xline(0)  baselevels drop(_cons )
 headings(0.jobs ="{bf:Jobs}" 0.USgrowth ="{bf:US Growth}" 0.regime ="{bf:Regime & Wealth}" 0.TPgrowth ="{bf:Partner Growth}"  0.geopolC ="{bf:Global Influence}" 0.partner ="{bf:Potential Trade Partner}", labcolor(navy) )
 scheme(s1mono) omit name(Arm23, replace) coeflabels( , labsize(vsmall) ) 
 msymbol(circle) msize(small) ciopts(lwidth(*1) ) 
 xscale(range(-.2 .2))  xlabel(-.2(.1).2) legend(off)
xtitle("       Average Change in the Probability a Profile is Chosen", size(small)); 
 #delimit cr  
 
 
 
 
 // Conjoint Diagnostics:
 
 //Figure E.1 
 
 use DK18_rep, clear 

label var attck1 "Check #1"
label var attck2 "Check #2"

graph hbar (mean) attck1  attck2, scheme(s1mono)  legend(rows(1) lab(1 "Pass Rate Check 1") lab(2 "Pass Rate Check 2"))

// Figure E.2 
gen Groupstr = "Group 1" if Group==1
replace Groupstr = "Group 2" if Group==2
replace Groupstr = "Group 3" if Group==3

graph hbar  (mean) c1time c2time c3time c4time c5time, over(Groupstr) scheme(s1mono)  ///
 legend(rows(2) lab(1 "Time Task 1") lab(2 "Time Task 2") lab(3 "Time Task 3") lab(4 "Time Task 4") lab(5 "Time Task 5"))
 
// Figure E.3  

use DK18_rep, clear 

regress binary i.regime i.jobs i.USgrowth i.TPgrowth i.geopolB i.partnerB if task==1, robust cl(responseid)

#delimit ;  
 coefplot, xline(0) drop(_cons) 
 headings(0.regime = "{bf: Regime and Wealth}"  0.jobs = "{bf:Effect on Jobs}" 
 0.USgrowth ="{bf:Effect on Economy}" 0.TPgrowth ="{bf:Effect on Partner Economy}"
  1.geopolB ="{bf:Non-Economic Effect}" 1.partnerB ="{bf:Potential Trade Partner}" , labcolor(navy) labsize(vsmall) )
 scheme(s1mono) omit title(Task 1, size(small)) name(t1, replace) coeflabels( , labsize(tiny) ) 
 msymbol(p) mcolor(red) ciopts(lwidth(*2) lcolor(blue)) ; 
 #delimit cr 
 
forval i = 2/5{
regress binary i.regime i.jobs i.USgrowth i.TPgrowth i.geopolB i.partnerB if task==`i' , robust cl(responseid)
#delimit ;  
 coefplot, xline(0) drop(_cons) 
 headings(0.regime = "{bf: Regime and Wealth}"  0.jobs = "{bf:Effect on Jobs}" 
 0.USgrowth ="{bf:Effect on Economy}" 0.TPgrowth ="{bf:Effect on Partner Economy}"
  1.geopolB ="{bf:Non-Economic Effect}" 1.partnerB ="{bf:Potential Trade Partner}" , labcolor(navy) )
 scheme(s1mono) omit title(Task `i', size(small)) name(t`i', replace) coeflabels( , labsize(zero) ) 
 fxsize(18)
 msymbol(p) mcolor(red) ciopts(lwidth(*2) lcolor(blue)) ; 
 #delimit cr 
 }
 

graph combine t1 t2 t3 t4 t5, col(5) scheme(s1mono) xcommon 


 
 // Figure E.4
 
 use DK18_rep, clear 

regress binary i.regime i.jobs i.USgrowth i.TPgrowth i.geopolB i.partnerB if profile==1, robust cl(responseid)

#delimit ;  
 coefplot, xline(0) drop(_cons) 
 headings(0.regime = "{bf: Regime and Wealth}"  0.jobs = "{bf:Effect on Jobs}" 
 0.USgrowth ="{bf:Effect on Economy}" 0.TPgrowth ="{bf:Effect on Partner Economy}"
  1.geopolB ="{bf:Non-Economic Effect}" 1.partnerB ="{bf:Potential Trade Partner}" , labcolor(navy) labsize(vsmall) )
 scheme(s1mono) omit title(Profile 1, size(small)) name(t1, replace) coeflabels( , labsize(tiny) ) 
 msymbol(p) mcolor(red) ciopts(lwidth(*2) lcolor(blue)) ; 
 #delimit cr 
 
regress binary i.regime i.jobs i.USgrowth i.TPgrowth i.geopolB i.partnerB if profile==2, robust cl(responseid)
#delimit ;  
 coefplot, xline(0) drop(_cons) 
 headings(0.regime = "{bf: Regime and Wealth}"  0.jobs = "{bf:Effect on Jobs}" 
 0.USgrowth ="{bf:Effect on Economy}" 0.TPgrowth ="{bf:Effect on Partner Economy}"
  1.geopolB ="{bf:Non-Economic Effect}" 1.partnerB ="{bf:Potential Trade Partner}" , labcolor(navy) )
 scheme(s1mono) omit title(Profile 2, size(small)) name(t2, replace) coeflabels( , labsize(zero) ) 
 fxsize(50)
 msymbol(p) mcolor(red) ciopts(lwidth(*2) lcolor(blue)) ; 
 #delimit cr 
 

graph combine t1 t2 , col(2) scheme(s1mono) xcommon


	
	
	
	
	
	
	
