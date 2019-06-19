/* Run first step regression of college enrollment on state and year interaction dummies.  
Estimate the difference in difference effect of hope from the second stage,  
regressing obtained stateXyear coefficients on state and year dummies.  
Use simulations to obtain 95% CI: randomly drawing 10 states out of 51 without repetition 3000 times*/
 
 
clear 
set mem 300m 
set more off 
set matsize 800 
log using meritew, replace 
infile coll merit male black asian year state chst using regm.raw 
 
 
/* Create variables for state ids where program changed and not changed*/ 
quietly { 
g stch=state*chst 
tab stch 
g stchid=. 
g ind=1 
foreach k in 34 57 58 59 61 64 71 72 85 88 { 
replace stchid=ind if state==`k'  
replace ind=ind+1 
} 
g stnchid=. 
replace ind=1 
foreach k of numlist 11/16 21/23 31/33 35 41/47 51/56 62 63 73 74 81/84 86 87 91/95{ 
replace stnchid=ind if state==`k'  
replace ind=ind+1 
} 
g stid=. 
replace ind=1 
foreach k of numlist 11/16 21/23 31/35 41/47 51/59 61/64  71/74 81/88 91/95 { 
replace stid=ind if state==`k'  
replace ind=ind+1 
} 
} 
 
/* Create iteraction terms for years and states*/ 
gen styr=1000*state+year 
sum state  
g stmin=r(min) 
g stmax=r(max) 
sum year  
g yrmin=r(min) 
g yrmax=r(max) 
 
/* Create dummies for state+year interactions*/ 
g yr=yrmin 
quietly { 
foreach st of numlist 11/16 21/23 31/35 41/47 51/59 61/64  71/74 81/88 91/95 { 
	while yr<=yrmax { 
		local ind=`st'*1000+yr 
		g byte Dstyr_`ind'=styr==`ind'  
		replace yr=yr+1 
		}		 
	replace yr=yrmin 
}  
} 
 
reg coll male black asian Dstyr*, noc r clust(styr) 
predict colhat, xb 
gen beta=colhat-male*_b[male]-black*_b[black]-asian*_b[asian]
collapse (mean) merit beta yrmin yrmax year state stch stchid stid, by (styr) 

xi: reg beta merit i.year i.state, robust
xi: reg beta merit i.year i.state, r cluster(state)
 
/* Create state and year dummies*/ 
g yr=yrmin 
quietly { 
	while yr<=yrmax { 
	local k=yr 
		g byte Dyear_`k'=year==`k'  
		replace yr=yr+1 
		}		 
} 
 
quietly { 
foreach st of numlist 12/16 21/23 31/35 41/47 51/59 61/64  71/74 81/88 91/95 { 
		g byte Dstate_`st'=state==`st'  
	} 
} 
 
/* Now regress the coefficients (beta) obtained from the previous regression on state and year dummies and hope variable*/ 
reg beta merit Dstat* Dyear*, noc 
gen alpha=_b[merit] 
 
/* Predict residuals from regression */ 
predict eta, res  
replace eta=eta+_b[merit]*merit 
drop D* 
 
/* Obtain difference in differences coefficient*/ 
/* Test that alpha formed this way is the same as in regression*/ 
bysort year stch: egen djt=mean(merit) if stch~=0 
bysort stch: egen meandjt=mean(merit) if stch~=0 
g dtil=djt-meandjt 
reg eta dtil if stch~=0,noc 
 
/* Create d tilde variable for each state*/ 
foreach k of numlist 1/10 { 
bysort year: egen djt`k'=mean(merit) if stchid==`k' 
bysort year: egen djtt=sum(djt`k')  
bysort state: egen meandjtt=mean(djtt) 
g dtil`k'=djtt-meandjtt 
drop djtt meandjtt 
} 
save alpha2.dta, replace 
 
/* randomly draw 10 states out of 51 -> 3000 times, without repetition 
create a new file with draws only */ 
clear 
set obs 3000 
gen check=0 
/* set seed 339487731 */ 
 
gen sst1=ceil(uniform()*51) 
foreach k of numlist 2/10 { 
	gen sst`k'=ceil(uniform()*51) 
	local z=`k'-1 
	foreach m of numlist 1/`z' { 
		/* check whether this state was chosen before */ 
		replace check=sst`k'==sst`m'  
		quietly sum check 
		local ii=r(sum) 
		while `ii'>0 { 
			replace sst`k'=ceil(uniform()*51) if sst`k'==sst`m' 
			replace check=sst`k'==sst`m' 
			quietly sum check 
			local ii=r(sum) 
		}      
	} 
} 
 
drop check 
gen int n=_n 
sort n 
outfile sst* using states2, wide replace 
save states2.dta, replace 
 
/* add simulated states to the main file */ 
use alpha2.dta, clear 
 
gen int n=_n 
sort n 
merge n, using states2.dta 
 
gen ci=. 
gen asim=. 
sum alpha 
replace alpha=r(mean) 
 
g snum=0 
g sden=0 
 
save alpha2.dta, replace 
 
*********************************************************** 
/* Start simulations */ 
 
local numsim=3000 
local i025=floor(0.025*(`numsim'-1)) 
local i975=ceil(0.975*(`numsim'-1)) 
 
/*  start iterations for the lower bound of 95% CI 
    hypothesize alpha=0 in the first step */ 
scalar alpha0=0 
scalar count=0 
scalar dif=1 
quietly { 
/* do this loop until the lower bound and alpha0 converge */ 
while dif > 10^-3 & count<= 10^6 { 
      scalar count = count + 1 
      gen etahat=eta-alpha0*merit 
	foreach k of numlist 1/10 { 
		g xy`k'=etahat*dtil`k' 
		g xx`k'=dtil`k'*dtil`k' 
	} 
	/* simulations for 3000x10 draws of states */ 
	forvalues sim = 1/`numsim'   { 
      	replace snum=0  
		replace sden=0  
		foreach k of numlist 1/10 { 
			sum sst`k' if n==`sim' 
			local s=r(mean) 
			sum xy`k' if stid==`s' 
			local ssnum=r(sum) 
			sum xx`k' if stid==`s' 
			local ssden=r(sum) 
			replace snum=snum+`ssnum' 
			replace sden=sden+`ssden' 
		} 
		scalar ahat=snum/sden 
		replace asim=ahat if n==`sim'  
	} 
	replace ci=alpha-asim 
	sort asim 
	sum ci if _n==`i025'|_n==`i975' 
	scalar alpha1=r(min) 
	scalar dif = abs((alpha0-alpha1)/(alpha0+0.01)) 
      scalar alpha0 = 0.3*alpha0+0.7*alpha1 
      drop xy* xx* etahat 
} 
} 
if count >= 10^6 { 
      display "maximum number of iterations reached" 
      display "results displayed are from last iteration" 
} 
scalar lb=alpha1 
 
/*  start iterations for the upper bound of 95%CI 
    hypothesize alpha=0 in the first step */ 
scalar alpha0=0 
scalar count=0 
scalar dif=1 
quietly { 
/* do this loop until the upper bound and alpha0 converge */ 
while dif > 10^-3 & count<= 10^6 {  
      scalar count = count + 1 
      gen etahat=eta-alpha0*merit 
	foreach k of numlist 1/10 { 
		g xy`k'=etahat*dtil`k' 
		g xx`k'=dtil`k'*dtil`k' 
	} 
	/* simulations for 3000x10 draws of states */ 
	forvalues sim = 1/`numsim'   { 
      	replace snum=0 
		replace sden=0 
		foreach k of numlist 1/10 { 
			sum sst`k' if n==`sim' 
			local s=r(mean) 
			sum xy`k' if stid==`s' 
			local ssnum=r(sum) 
			sum xx`k' if stid==`s' 
			local ssden=r(sum) 
			replace snum=snum+`ssnum' 
			replace sden=sden+`ssden' 
		} 
		scalar ahat=snum/sden 
		replace asim=ahat if n==`sim'  
	} 
	replace ci=alpha-asim 
	sort asim 
	 
	quietly sum ci if _n==`i025'|_n==`i975' 
	scalar alpha1=r(max) 
	scalar dif = abs((alpha0-alpha1)/(alpha0+0.01)) 
      scalar alpha0 = 0.3*alpha0+0.7*alpha1 
      drop xy* xx* etahat 
} 
} 
    if count >= 10^6 { 
        display "maximum number of iterations reached" 
        display "results displayed are from last iteration" 
    } 
 
scalar ub=alpha1 
display as text "95% Confidence interval=" as result _newline(2) lb _col(15) ub 
 
save alpha2.dta, replace 
 
log close 
i=alpha-asim 
	sort asim 
	 
	quietly sum ci if _n==`i025'|_n==`i975' 
	scalar alpha1=r(max) 
	scalar dif = abs((alpha0-alpha1)/(alpha0+0.01)) 
      scalar alpha0 = 0.3*alpha0+0.7*alpha1 
      drop xy* xx* etahat 
} 
} 
    if count >= 10^6 { 
        display "maximum number of iterations reached" 
        display "results displayed are from last iteration" 
    } 
 
scalar ub=alpha1 
display as text "95% Confidence interval=" as result _newline(2) lb _col(15) ub 
 
save alpha2.dta, replace 
 
log clos