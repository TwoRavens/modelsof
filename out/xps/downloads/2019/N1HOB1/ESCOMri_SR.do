* ANALYSIS REPLICATION FILE
	* Paper: Coethnicity and Corruption: Field Experimental Evidence from Public Officials in Malawi
	* Authors: Brigitte Seim and Amanda Lea Robinson
	* Journal: Journal of Experimental Political Science

* FILE INFO
	* This .do file calculates exact p-values for the multinomial logit.
	* This .do file is called by the main analysis file, ESCOManalyses_SR.do
	
****************************************************************


*  Model 1 (no controls)

clear
set more off
use "ESCOMdata_SR.dta"
quiet mlogit outcome ses power coreg , base(1) robust

/* set seed as today's date */
set seed 08092018


/* number of reps */
local r=10000
/* store betas */
    global bhat_bcoreg = _b[Bribe:coreg]
	global bhat_ecoreg = _b[Expedited:coreg]
    global bhat_bses = _b[Bribe:ses]
	global bhat_eses = _b[Expedited:ses]
    global bhat_bpower = _b[Bribe:power]
	global bhat_epower = _b[Expedited:power]
/* set up matrix for betas */
mata:bstats1=J(`r',1,.)
mata:bstats2=J(`r',1,.)
mata:bstats3=J(`r',1,.)
mata:bstats4=J(`r',1,.)
mata:bstats5=J(`r',1,.)
mata:bstats6=J(`r',1,.)
/* set up a variable to use for sorting */
quiet gen u1 = .
quiet gen u2 = .
quiet gen u3 = .
quiet gen fcoreg=.
quiet gen fses=.
quiet gen fpower=.
/* loop over the R randomizations */
forvalues r = 1/`r'{
    /*assign treatments randomly */
    quiet replace u1 = runiform()
    sort u1
    quiet replace fcoreg = inrange(_n,1,16)
    quiet replace u2 = runiform()
    sort u2
    quiet replace fses = inrange(_n,1,21)
    quiet replace u3 = runiform()
    sort u3
    quiet replace fpower = inrange(_n,1,26)
    /* run the regression */
    quiet mlogit outcome fses fpower fcoreg, base(1) robust
    /* store betas */
    local bstat1 = _b[Bribe:fcoreg]
    mata: bstats1[`r',1]=`bstat1'
	local bstat2 = _b[Expedited:fcoreg]
    mata: bstats2[`r',1]=`bstat2'
    local bstat3 = _b[Bribe:fses]
    mata: bstats3[`r',1]=`bstat1'
	local bstat4 = _b[Expedited:fses]
    mata: bstats4[`r',1]=`bstat2'
    local bstat5 = _b[Bribe:fpower]
    mata: bstats5[`r',1]=`bstat1'
	local bstat6 = _b[Expedited:fpower]
    mata: bstats6[`r',1]=`bstat2'
}

/* get betas */
foreach n of numlist 1 2 3 4 5 6 {
getmata bstats`n', force
}

/* calculate p-values */
gen rej1 = abs(bstats1)>=abs(${bhat_bcoreg})
quiet summ rej1
display ${bhat_bcoreg} "RI p-value for Coreg:Bribe is " r(mean)

gen rej2 = abs(bstats2)>=abs(${bhat_ecoreg})
quiet summ rej2
display ${bhat_ecoreg} "RI p-value for Coreg:Expedited is " r(mean)

gen rej3 = abs(bstats3)>=abs(${bhat_bses})
quiet summ rej3
display ${bhat_bses} "RI p-value for SES:Bribe is " r(mean)

gen rej4 = abs(bstats4)>=abs(${bhat_eses})
quiet summ rej4
display ${bhat_eses} "RI p-value for SES:Expedited is " r(mean)

gen rej5 = abs(bstats5)>=abs(${bhat_bpower})
quiet summ rej5
display ${bhat_bpower} "RI p-value for Power:Bribe is " r(mean)

gen rej6 = abs(bstats6)>=abs(${bhat_epower})
quiet summ rej6
display  ${bhat_epower} "RI p-value for Power:Expedited is" r(mean)



*  Model 2 (with controls)


clear
set more off
use "ESCOMdata_SR.dta"

quiet mlogit outcome ses power coreg $cov , base(1) robust

/* set seed as today's date */
set seed 08092018


/* number of reps */
local r=10000
/* store betas */
    global bhat_bcoreg = _b[Bribe:coreg]
	global bhat_ecoreg = _b[Expedited:coreg]
    global bhat_bses = _b[Bribe:ses]
	global bhat_eses = _b[Expedited:ses]
    global bhat_bpower = _b[Bribe:power]
	global bhat_epower = _b[Expedited:power]
/* set up matrix for betas */
mata:bstats1=J(`r',1,.)
mata:bstats2=J(`r',1,.)
mata:bstats3=J(`r',1,.)
mata:bstats4=J(`r',1,.)
mata:bstats5=J(`r',1,.)
mata:bstats6=J(`r',1,.)
/* set up a variable to use for sorting */
quiet gen u1 = .
quiet gen u2 = .
quiet gen u3 = .
quiet gen fcoreg=.
quiet gen fses=.
quiet gen fpower=.
/* loop over the R randomizations */
forvalues r = 1/`r'{
    /*assign treatments randomly */
    quiet replace u1 = runiform()
    sort u1
    quiet replace fcoreg = inrange(_n,1,16)
    quiet replace u2 = runiform()
    sort u2
    quiet replace fses = inrange(_n,1,21)
    quiet replace u3 = runiform()
    sort u3
    quiet replace fpower = inrange(_n,1,26)
    /* run the regression */
    quiet mlogit outcome fses fpower fcoreg $cov, base(1) robust
    /* store betas */
    local bstat1 = _b[Bribe:fcoreg]
    mata: bstats1[`r',1]=`bstat1'
	local bstat2 = _b[Expedited:fcoreg]
    mata: bstats2[`r',1]=`bstat2'
    local bstat3 = _b[Bribe:fses]
    mata: bstats3[`r',1]=`bstat1'
	local bstat4 = _b[Expedited:fses]
    mata: bstats4[`r',1]=`bstat2'
    local bstat5 = _b[Bribe:fpower]
    mata: bstats5[`r',1]=`bstat1'
	local bstat6 = _b[Expedited:fpower]
    mata: bstats6[`r',1]=`bstat2'
}

/* get betas */
foreach n of numlist 1 2 3 4 5 6  {
getmata bstats`n', force
}

/* calculate p-values */
gen rej1 = abs(bstats1)>=abs(${bhat_bcoreg})
quiet summ rej1
display ${bhat_bcoreg} "RI p-value for Coreg:Bribe is " r(mean)

gen rej2 = abs(bstats2)>=abs(${bhat_ecoreg})
quiet summ rej2
display ${bhat_ecoreg} "RI p-value for Coreg:Expedited is " r(mean)

gen rej3 = abs(bstats3)>=abs(${bhat_bses})
quiet summ rej3
display ${bhat_bses} "RI p-value for SES:Bribe is " r(mean)

gen rej4 = abs(bstats4)>=abs(${bhat_eses})
quiet summ rej4
display ${bhat_eses} "RI p-value for SES:Expedited is " r(mean)

gen rej5 = abs(bstats5)>=abs(${bhat_bpower})
quiet summ rej5
display ${bhat_bpower} "RI p-value for Power:Bribe is " r(mean)

gen rej6 = abs(bstats6)>=abs(${bhat_epower})
quiet summ rej6
display  ${bhat_epower} "RI p-value for Power:Expedited is" r(mean)

