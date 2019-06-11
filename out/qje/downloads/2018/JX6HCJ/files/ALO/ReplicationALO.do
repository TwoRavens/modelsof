

***************************


use STAR_public_use, clear	
*keep if noshow==0
*Will impose as a condition, need to keep as these were included in randomization of treatment
gen id = _n
local basic  i.sex i.mtongue i.hsgroup i.numcourses_nov1
local all i.sex i.mtongue i.hsgroup i.numcourses_nov1 i.lastmin i.mom_edn i.dad_edn

tab sex if noshow == 0, gen(SEX)
tab mtongue if noshow == 0, gen(MTONGUE)
tab hsgroup if noshow == 0, gen(HSGROUP)
tab numcourses_nov1 if noshow == 0, gen(NUMCOURSES)
tab lastmin if noshow == 0, gen(LASTMIN)
tab mom_edn if noshow == 0, gen(MOM_EDN)
tab dad_edn if noshow == 0, gen(DAD_EDN)

*Will get rid of xi expansion so runs faster when do 10,000 iterations

local basic1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
local basic2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
local all1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9
local all2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9

*Table 2 outcomes they treat as selection effects, so don't include

*Table 3 - Doesn't report sfp in columns (3)-(6) [reported in columns (1)&(2)], when they are insignificant in those columns
*Uses separate loop and results extraction protocol for those columns (introduces the error) - see their code for this (below is simplified & compressed)

local j = 1
local i = 1
foreach X in signup used_ssp used_adv used_fsg {

	xi: reg `X' ssp sfp sfsp `basic' if noshow == 0, r
		reg `X' ssp sfp sfsp `basic1' if noshow == 0, r
	xi: reg `X' ssp sfp sfsp `all' if noshow == 0, r
		reg `X' ssp sfp sfsp `all1' if noshow == 0, r
	xi: reg `X' ssp sfp sfsp `basic' if noshow == 0 & sex=="M", r
		reg `X' ssp sfp sfsp `basic2' if noshow == 0 & sex=="M", r
	xi: reg `X' ssp sfp sfsp `all' if noshow == 0 & sex=="M", r
		reg `X' ssp sfp sfsp `all2' if noshow == 0 & sex=="M", r
	xi: reg `X' ssp sfp sfsp `basic' if noshow == 0 & sex=="F", r
		reg `X' ssp sfp sfsp `basic2' if noshow == 0 & sex=="F", r
	xi: reg `X' ssp sfp sfsp `all' if noshow == 0 & sex=="F", r
		reg `X' ssp sfp sfsp `all2' if noshow == 0 & sex=="F", r
	}
	

*Table 5 - Okay, except reported control mean is unconditional (not including all of the non-treatment regressors in the table)

g byte group1= 1
g byte group2= sex=="M"
g byte group3= sex=="F"
g byte sspany= ssp | sfsp
generate GPA_YEAR1 = GPA_year1
*Here they set = . , later in Table 6 do not - so generate duplicate (their do file reloads data for each table)
replace GPA_year1=. if grade_20059_fall==. 
replace grade_20059_fall=. if GPA_year1==. 

*Reorder their regressions a bit so can use controls that don't drop variables (i.e. all2 vs all1)

foreach X in grade_20059_fall GPA_year1 {
	xi: reg `X' ssp sfp sfsp `all' if noshow == 0, r
		reg `X' ssp sfp sfsp `all1' if noshow == 0, r
	xi: reg `X' ssp sfpany `all' if noshow == 0, r
		reg `X' ssp sfpany `all1' if noshow == 0, r
	}

foreach X in grade_20059_fall GPA_year1 {
	foreach group in 2 3 {
		xi: reg `X' ssp sfp sfsp `all' if noshow == 0 & group`group', r
			reg `X' ssp sfp sfsp `all2' if noshow == 0 & group`group', r
		xi: reg `X' ssp sfpany `all' if noshow == 0 & group`group', r
			reg `X' ssp sfpany `all2' if noshow == 0 & group`group', r
		}	
	}


*Table 6 - All okay, control means as in Table 5 above

foreach var in prob_year goodstanding_year credits_earned {
	foreach num in 1 2 {
	replace `var'`num'=. if prob_year1==.
	}
	}

generate C = 1 if sex~="" & mtongue~="" & hsgroup~=. & numcourses_nov1~=. & lastmin~=. & mom_edn~=. & dad_edn~=.

foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	xi: reg `X' ssp sfp sfsp `all' if noshow == 0 & C, r
		reg `X' ssp sfp sfsp `all1' if noshow == 0 & C, r
	}	

foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	foreach group in 2 3 {
		xi: reg `X' ssp sfp sfsp `all' if noshow == 0 & group`group' & C, r
			reg `X' ssp sfp sfsp `all2' if noshow == 0 & group`group' & C, r
		}	
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	xi: reg `X' ssp sfp sfsp `all' if noshow == 0 & C, r
		reg `X' ssp sfp sfsp `all1' if noshow == 0 & C, r
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	foreach group in 2 3 {
		xi: reg `X' ssp sfp sfsp `all' if noshow == 0 & group`group' & C, r
			reg `X' ssp sfp sfsp `all2' if noshow == 0 & group`group' & C, r
		}	
	}

save DatALO1, replace

**************************************


*Table 7 - Number of observations slightly off (this is their code), se all off (seed for bootstrap issue?) 

use STAR_public_use, clear	
keep if sex~="" & mtongue~="" & hsgroup~=. & numcourses_nov1~=. & lastmin~=. & mom_edn~=. & dad_edn~=.
local all i.sex i.mtongue i.hsgroup i.numcourses_nov1 i.lastmin i.mom_edn i.dad_edn i.year
keep if noshow==0
keep   sex mtongue hsgroup numcourses_nov1 lastmin mom_edn dad_edn GPA_year1 GPA_year2 ssp sfp sfsp control
gen id=_n

reshape long GPA_year, i(id) j(year)

g byte group1= 1
g byte group2= sex=="M"
g byte group3= sex=="F"

foreach group in 2 3 {
	xi: reg GPA_year ssp sfp sfsp `all'  if group`group', clu(id)
		foreach quantile in .1 .25 .5 .75 .9 {
			xi: bootstrap _b[ssp] _b[sfp] _b[sfsp],  reps(500) cluster(id): qreg GPA_year ssp sfp sfsp `all' if group`group', q(`quantile')
		}	
	}

xi: reg GPA_year ssp sfp sfsp i.year i.hsgroup if group3, clu(id)
xi: reg GPA_year ssp sfp sfsp i.year   if group3, clu(id)

foreach quantile in .1 .25 .5 .75 .9 {
	xi: bootstrap _b[ssp] _b[sfp] _b[sfsp],  reps(500) cluster(id): qreg GPA_year ssp sfp sfsp i.year i.hsgroup if group3, q(`quantile')
	xi: bootstrap _b[ssp] _b[sfp] _b[sfsp],  reps(500) cluster(id): qreg GPA_year ssp sfp sfsp i.year if group3, q(`quantile')
	}	


*Now, my code (need to keep all observations for randomization distribution, use dummies rather than repeating xi in each iteration

use STAR_public_use, clear
generate S = 1 if sex~="" & mtongue~="" & hsgroup~=. & numcourses_nov1~=. & lastmin~=. & mom_edn~=. & dad_edn~=.
replace S = . if noshow ~= 0
local all i.sex i.mtongue i.hsgroup i.numcourses_nov1 i.lastmin i.mom_edn i.dad_edn i.year
keep sex mtongue hsgroup numcourses_nov1 lastmin mom_edn dad_edn GPA_year1 GPA_year2 ssp sfp sfsp control S
gen id=_n
reshape long GPA_year, i(id) j(year)

tab mtongue if S == 1, gen(MTONGUE)
tab hsgroup if S == 1, gen(HSGROUP)
tab numcourses_nov1 if S == 1, gen(NUMCOURSES)
tab lastmin if S == 1, gen(LASTMIN)
tab mom_edn if S == 1, gen(MOM_EDN)
tab dad_edn if S == 1, gen(DAD_EDN)
tab year if S == 1, gen(YEAR)

local all1 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

g byte group2= sex=="M"
g byte group3= sex=="F"

*I add seed to bootstrap, as se don't match anyway without seed information
foreach group in 2 3 {
		reg GPA_year ssp sfp sfsp `all1'  if S == 1 & group`group', clu(id)
			testparm ssp sfp sfsp
		foreach quantile in .1 .25 .5 .75 .9 {
			qreg GPA_year ssp sfp sfsp `all1' if S == 1 & group`group', q(`quantile')
			bootstrap _b[ssp] _b[sfp] _b[sfsp], reps(500) cluster(id) seed(1): qreg GPA_year ssp sfp sfsp `all1' if S == 1 & group`group', q(`quantile')
		}	
	}

	reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, clu(id)
	reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, clu(id)

foreach quantile in .1 .25 .5 .75 .9 {
		qreg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, q(`quantile')
		bootstrap _b[ssp] _b[sfp] _b[sfsp], reps(500) cluster(id) seed(1): qreg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, q(`quantile')
		qreg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, q(`quantile')
		bootstrap _b[ssp] _b[sfp] _b[sfsp], reps(500) cluster(id) seed(1): qreg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, q(`quantile')
	}	

save DatALO2, replace

************************************************************


*Table 8 

use STAR_public_use, clear	
keep if noshow==0
keep if sex=="F" 
keep if sex~="" & mtongue~="" & hsgroup~=. & numcourses_nov1~=. & lastmin~=. & mom_edn~=. & dad_edn~=.
local all i.sex i.mtongue i.hsgroup i.numcourses_nov1 i.lastmin i.mom_edn i.dad_edn i.year
foreach var in prob_year goodstanding_year credits_earned {
	foreach num in 1 2 {
	replace `var'`num'=. if prob_year1==.
	}
	}
keep sex mtongue hsgroup numcourses_nov1 lastmin mom_edn dad_edn GPA_year1 GPA_year2 ssp sfp sfsp control prob_year1 prob_year2 credits_earned* ssp_p sfp_p sfsp_p sfpany_p
gen id=_n
reshape long GPA_year goodstanding_year prob_year credits_earned, i(id) j(year)

foreach X in GPA_year prob_year credits_earned {
	xi: ivreg `X' (ssp_p sfp_p sfsp_p = ssp sfsp sfp) `all' , r clu(id)
	xi: ivreg2 `X' (ssp_p sfpany_p= ssp sfsp sfp) `all'  , r clu(id) partial(`all')
	}	
*GPA_year, itt version reproduces earlier regressions
*itt/Anderson-Rubin version of overidentified regression is same as previous regression


*Now, my code (need to keep all observations for randomization distribution, use dummies rather than repeating xi in each iteration

use STAR_public_use, clear
generate S = 1 if sex~="" & mtongue~="" & hsgroup~=. & numcourses_nov1~=. & lastmin~=. & mom_edn~=. & dad_edn~=.
replace S = . if noshow ~= 0 | sex~="F"
foreach var in prob_year goodstanding_year credits_earned {
	foreach num in 1 2 {
	replace `var'`num'=. if prob_year1==.
	}
	}
keep sex mtongue hsgroup numcourses_nov1 lastmin mom_edn dad_edn GPA_year1 GPA_year2 ssp sfp sfsp control prob_year1 prob_year2 credits_earned* ssp_p sfp_p sfsp_p sfpany_p S
gen id=_n
reshape long GPA_year goodstanding_year prob_year credits_earned, i(id) j(year)

*Will get rid of xi expansion so runs faster when do 10,000 iterations

tab mtongue if S == 1, gen(MTONGUE)
tab hsgroup if S == 1, gen(HSGROUP)
tab numcourses_nov1 if S == 1, gen(NUMCOURSES)
tab lastmin if S == 1, gen(LASTMIN)
tab mom_edn if S == 1, gen(MOM_EDN)
tab dad_edn if S == 1, gen(DAD_EDN)
tab year if S == 1, gen(YEAR)

global all3 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

foreach X in prob_year credits_earned {
	ivreg `X' (ssp_p sfp_p sfsp_p = ssp sfsp sfp) $all3 if S == 1, r clu(id)
	reg `X' ssp sfp sfsp $all3 if S == 1, r clu(id)
	}	
	
save DatALO3, replace


