// re-estimate underrerpoting under the Pissarides and Weber (1989)
// identification strategy.

// they differ in 2 important ways: 
//  (i)   underrerpoting is allowed to vary in the self employed population w/ std dev 
//        sig_v
//  (ii)  assume volatility of transient self employment income > transient wage 
//        employment income, and is a mean preserving spread so E[y|y^p] is the 
//        same, implies that average _log_ income of self employed is lower than 
//        employed, b/c of a Jensen's inequality correction.


// use psid sample
clear
clear matrix
set mem 500m

local sample_ver = 2

cap log close
log using psid_pw_robust_res`sample_ver', text replace

if `sample_ver' == 2 {
	use psid1year // sample 2
	}
if `sample_ver' == 3 {
	use psid3year // sample 3
	}

set more off

// estimate the first stage to get residual variance
// total family income
reg logfaminc highschool somecollege college graduate ///
    black married age???? year1981-year1996 fam2-fam11 ///
	[pw=weight]
predict logfaminchat
predict logfamincres, resid

sum logfamincres [aw=weight] if entre == 1
local sefamincvar = r(Var)
sum logfamincres [aw=weight] if entre == 0
local wefamincvar = r(Var)

disp "var fam inc diff"
disp `sefamincvar'-`wefamincvar'

// labor + business income
reg loglaborbus highschool somecollege college graduate ///
    black married age???? year1981-year1996 fam2-fam11
predict loglaborbushat	
predict loglaborbusres, resid

sum loglaborbusres [aw=weight] if entre == 1
local selabincvar = r(Var)
sum loglaborbusres [aw=weight] if entre == 0
local welabincvar = r(Var)

disp "var lab inc diff"
disp `selabincvar'-`welabincvar'

// run consumption on the instruments to get perm income var
reg logfood highschool somecollege college graduate ///
        black married age???? year1981-year1996 fam2-fam11 [pw=weight]
predict logfoodres1, resid

sum logfoodres1 [aw=weight] if entre == 1
local sepermincvar = r(Var)
sum logfoodres1 [aw=weight] if entre == 0
local wepermincvar = r(Var)

disp "var perm inc diff"
disp `sepermincvar'-`wepermincvar'

// now estimate the second stage to get the betas and gamms
if `sample_ver' == 2 {
ivreg2 logfood (logfaminc = highschool somecollege college graduate) entre ///
        black married age???? year1981-year1996 fam2-fam11 [pw=weight]
	}
if `sample_ver' == 3 {
reg logfood logfaminc entre ///
        black married age???? year1981-year1996 fam2-fam11 [pw=weight]
	}	

// compute original and corrected versions of kappa
disp "logfood on logfaminc"
disp "uncorrected"
disp 1-exp(-_b[entre]/_b[logfaminc])
disp "corrected PW"
disp 1-exp(-_b[entre]/_b[logfaminc] + 0.5*(`sefamincvar'-`wefamincvar'))
disp "corrected PW w/ perm"
disp 1-exp(-_b[entre]/_b[logfaminc] + 0.5*(`sefamincvar'-`wefamincvar' -(`sepermincvar'-`wepermincvar')/_b[logfaminc]^2))

// now estimate the second stage to get the betas and gamms
if `sample_ver' == 2 {
ivreg2 logfood (loglaborbus = highschool somecollege college graduate) entre ///
        black married age???? year1981-year1996 fam2-fam11 [pw=weight]
	}
if `sample_ver' == 3 {
reg logfood loglaborbus entre ///
        black married age???? year1981-year1996 fam2-fam11 [pw=weight]
	}	
// compute original and corrected versions of kappa
disp "logfood on loglaborbus"
disp "uncorrected"
disp 1-exp(-_b[entre]/_b[loglaborbus])
disp "corrected PW"
disp 1-exp(-_b[entre]/_b[loglaborbus] + 0.5*(`sefamincvar'-`wefamincvar'))
disp "corrected PW w/ perm"
disp 1-exp(-_b[entre]/_b[loglaborbus] + 0.5*(`sefamincvar'-`wefamincvar' -(`sepermincvar'-`wepermincvar')/_b[loglaborbus]^2))

// kick to matlab to double check
outsheet /*pid*/ wave entre weight ///
    logfaminc logfaminchat logfamincres ///
    loglaborbus loglaborbushat loglaborbusres ///
    using psid_pw_incvar.txt, replace

outsheet /*pid*/ wave entre weight ///
    logfoodres1 ///
    using psid_pw_consvar.txt, replace

cap log close
