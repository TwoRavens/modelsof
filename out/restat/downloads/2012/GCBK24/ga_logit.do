/* Estimate the diff-in-diff effect of hope in Georgia
Run logit regression in the first step on stateXyear interactions.
In the second stage estimate the effect of hope with state and year dummies */

clear
set more off
set matsize 800
set mem 200m
infile coll hope male black asian year state using reg.raw

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
foreach st of numlist 11/16 21/23 31/33 35 41/47 51/56 58 62 63 73 74 81/84 86 87 91/95 {
	while yr<=yrmax {
		local ind=`st'*1000+yr
		g byte Dstyr_`ind'=styr==`ind' 
		replace yr=yr+1
		}		
	replace yr=yrmin
} 
}

logit coll male black asian Dstyr*, r clust(styr)
predict colhat, xb
gen beta=colhat-male*_b[male]-black*_b[black]-asian*_b[asian]

/* Keep only beta coefficients for state*year terms */
collapse (mean) beta state year yrmin yrmax hope, by(styr)

xi: reg beta hope i.year i.state, robust
xi: reg beta hope i.year i.state, r cluster(state)
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
	foreach st of numlist 12/16 21/23 31/33 35 41/47 51/56 58 62 63 73 74 81/84 86 87 91/95 {
		g byte Dstate_`st'=state==`st' 
	}
}

/* Now regress the coefficients (beta) obtained from the previous regression 
on state and year dummies and hope variable*/
reg beta hope Dstat* Dyear*, noc

/* Create an indicator for the state where policy changed (Georgia==1)*/
g byte ga=state==58

/* Predict residuals from regression */
predict eta, res 
replace eta=eta+_b[hope]*hope
drop D*

/* Create d tilde variable*/
bysort year: egen djtga=mean(hope) if ga==1
bysort year: egen djt=sum(djtga) 
bysort state: egen meandjt=mean(djt)
g dtil=djt-meandjt

/* Obtain difference in differences coefficient*/
reg eta dtil if ga==1,noc
matrix alpha=e(b)
	
/* Simulations*/
quietly {
	foreach st of numlist 11/16 21/23 31/33 35 41/47 51/56 58 62 63 73 74 81/84 86 87 91/95 {
		capture {
		reg eta dtil if state==`st'&ga!=1, noc
		matrix alpha=alpha\e(b)
	}
	}
} 
matrix asim=alpha[2...,1]
matrix alpha=alpha[1,1]

/* Confidence intervals */
svmat alpha 
svmat asim

sum alpha
gen alpha=r(mean)
g ci=alpha-asim

/* form confidence intervals */
local numst=42
local i025=floor(0.025*(`numst'-1))
local i975=ceil(0.975*(`numst'-1))
local i05=floor(0.050*(`numst'-1))
local i95=ceil(0.950*(`numst'-1))

quietly sum alpha
display as text "Difference in Differences coefficient=" as result _newline(2) r(mean)

sort asim
quietly sum ci if _n==`i025'|_n==`i975'
display as text "95% Confidence interval=" as result _newline(2) r(min) _col(15) r(max)
quietly sum ci if _n==`i05'|_n==`i95' 
display as text "90% Confidence interval=" as result _newline(2) r(min) _col(15) r(max)
local i025=floor(0.025*(`numst'-1))
local i975=ceil(0.975*(`numst'-1))
local i05=floor(0.050*(`numst'-1))
local i95=ceil(0.950*(`numst'-1))

quietly sum alpha
display as text