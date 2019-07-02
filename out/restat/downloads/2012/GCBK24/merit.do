/*This Do-file analyses the effect of all of the merit programs together*/
 
set mem 200m
set more off
clear
 
log using meritm, replace 
infile coll merit male black asian year state chst using regm.raw 

set matsize 800 
xi:reg coll merit male black asian i.year i.state,r cluster(state) 
gen styr=1000*state+year
xi:reg coll merit male black asian i.year i.state,r cluster(styr) 
predict eta, res  
replace eta=eta+_b[merit]*merit 
drop _I* 
gen alpha=_b[merit] 
 
/* Create variables for state ids where program changed and not changed*/ 
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
 
/* Test that alpha formed this way is the same as in regression*/ 
bysort year stch: egen djt=mean(merit) if stch~=0 
bysort stch: egen meandjt=mean(merit) if stch~=0 
g dtil=djt-meandjt 
reg eta dtil if stch~=0,noc 
 
/* Create weights and d tilde variable for each state*/ 
foreach k of numlist 1/10 { 
bysort state year: egen Nt`k'=sum(1) if stchid==`k' 
bysort year: egen N`k'=mean(Nt`k') 
bysort state year: egen w`k'=sum(1) 
replace w`k'=N`k'/w`k' 
bysort state: egen djt`k'=mean(merit) if stchid==`k' 
replace djt`k'=merit-djt`k' 
bysort year: egen dtil`k'=mean(djt`k') 
g wdtil`k'=w`k'*dtil`k' 
drop Nt`k' N`k' w`k' djt`k' 
} 
 
keep eta wdtil* dtil* merit stid alpha year 
save alpha.dta, replace 
 
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
save states.dta, replace 
 
/* add simulated states to the main file */ 
use alpha.dta, clear 
 
gen int n=_n 
gen ci=. 
gen asim=. 
 
g snum=0 
g sden=0 
 
sort n 
merge n, using states.dta 
 
local numsim=3000 
local i025=floor(0.025*(`numsim'-1)) 
local i975=ceil(0.975*(`numsim'-1)) 
local i05=floor(0.050*(`numsim'-1)) 
local i95=ceil(0.950*(`numsim'-1)) 
 
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
		g xy`k'=etahat*wdtil`k' 
		g xx`k'=wdtil`k'*dtil`k' 
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
scalar lb95=alpha1 
 
/*  start iterations for the upper bound of 95%CI 
    hypothesize alpha=0 in the first step */ 
scalar alpha0=0 
scalar count=0 
scalar dif=1 
quietly { 
/* do this loop until the upper bound and alpha0 converge */ 
while dif > 10^-3 & count<= 10^6 { /* do this loop until converges */ 
      scalar count = count + 1 
      gen etahat=eta-alpha0*merit 
	foreach k of numlist 1/10 { 
		g xy`k'=etahat*wdtil`k' 
		g xx`k'=wdtil`k'*dtil`k' 
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
 
scalar ub95=alpha1 
/*  start iterations for the lower bound of 90% CI 
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
		g xy`k'=etahat*wdtil`k' 
		g xx`k'=wdtil`k'*dtil`k' 
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
	sum ci if _n==`i05'|_n==`i95' 
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
scalar lb90=alpha1 
 
/*  start iterations for the upper bound of 90%CI 
    hypothesize alpha=0 in the first step */ 
scalar alpha0=0 
scalar count=0 
scalar dif=1 
quietly { 
/* do this loop until the upper bound and alpha0 converge */ 
while dif > 10^-3 & count<= 10^6 { /* do this loop until converges */ 
      scalar count = count + 1 
      gen etahat=eta-alpha0*merit 
	foreach k of numlist 1/10 { 
		g xy`k'=etahat*wdtil`k' 
		g xx`k'=wdtil`k'*dtil`k' 
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
	 
	quietly sum ci if _n==`i05'|_n==`i95' 
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
 
scalar ub90=alpha1 
display as text "90% Confidence interval=" as result _newline(2) lb90 _col(15) ub90 
display as text "95% Confidence interval=" as result _newline(2) lb95 _col(15) ub95 
 
 
log close 
i95' 
	scalar alpha1=r(max) 
	scalar dif = abs((alpha0-alpha1)/(alpha0+0.01)) 
      scalar alpha0 = 0.3*alpha0+0.7*alpha1 
      drop xy* xx* etahat 
} 
} 
    if count >= 10^6 { 
        display "maximum number of iterations reached" 
        display "results displayed are from last it