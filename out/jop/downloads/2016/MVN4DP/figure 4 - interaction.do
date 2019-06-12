set more off

use dataset, clear

*** rescale change in tax bill ***

replace dtaxbill = dtaxbill/l.medianincome*100

*** covariates ***

local controls dfederalaidpcp dstateaidpcp lpopulation pct_white pct_senior pct_renter lmedianincome 
local economy davgannualwage demployment dunemployment propvaluechange
tabulate year if !mi(demvoteshare), gen(year_)

*** make interactions ***

foreach x in `economy' dfederalaidpcp dstateaidpcp {
	su `x'
	gen demincumbentX`x' = demincumbent*`x'
	replace `x' = demincumbentX`x'
}

gen demincumbentXoverridep = demincumbent*overridep

label variable demincumbentXoverridep "Tax increase*Democrat incumbent"

gen demincumbentXdtaxbill = demincumbent*dtaxbill

label variable demincumbentXdtaxbill "(2) $\Delta$ Tax bill*Democrat incumbent"

su demincumbentXdtaxbill, det
replace demincumbentXdtaxbill = . if demincumbentXdtaxbill > r(p99) | demincumbentXdtaxbill < r(p1)

gen demincumbentXdtaxbillXoverridep = demincumbentXdtaxbill*overridep 

label variable demincumbentXdtaxbillXoverridep "(3) $\Delta$ Tax bill*Democrat incumbent*Voter-imposed tax increase"

label variable overridep "(1) Voter-imposed tax increase"

*** make sample consistent across specifications ***

keep if !mi(dtaxbill) & !mi(demvoteshare)

*** residualize ***

local X0 lpopulation pct_white pct_senior pct_renter lmedianincome dstateaidpcp dfederalaidpcp

gen y = demvoteshare
reg y i.year lagdemvoteshare `economy' `controls' year_*  [aw=totalvotes]
predict e, res
drop y
rename e y

gen x = demincumbentXdtaxbill  

*** fix labels ***

replace overridep = -overridep
label define overridepl -1 "Voter-imposed tax increase" 0 "No voter-imposed tax increase", replace
label values overridep overridepl
label variable overridep "Voter-approved tax increase"

*** graph ***

keep if overridep == -1

keep if !mi(x) & !mi(y)

su x

#delimit;

gr tw    
	(lfitci y x, col(black) acol(gray) fintens(20) alcol(white) alwidth(none))
	(sc y x, col(black) msym(O) msize(tiny))
	,
		subtitle(, fcol(none) lcol(none))		
		plotregion(style(none))
		ytitle("Change in Democratic voteshare")
		xtitle("{&Delta} Tax bill*Democratic incumbent")
		legend(off)
		;
		
#delimit cr

gr export "figure 4.eps", replace

su x
replace x = (x-r(min))/(r(max)-r(min))
bys overridep: reg y x
