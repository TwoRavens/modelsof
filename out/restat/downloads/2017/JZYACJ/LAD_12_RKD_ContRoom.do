
local indata LAD\Data
local infile LAD\Data_Cleaning

use "`indata'\LAD_Crowdout.dta", clear

do "`infile'\LAD_Commands_filtering.do"

*Focus on savers within the relevant bandwidth
keep if empinc>=-6000 & empinc<6000

*Non-Unionized RPP Non-Members do not satisfy the Test of Running Variable and are excluded
keep if dues>0
*Focus on RPP members with strictly positive RRSP contributions
keep if penadj>0 & rspcont>0

local covars age agesq female married province_* selfempinc_flag eiinc_flag othinc disab medexp

*---------------------
*1) Limit contributors
*---------------------

qui reg penadj empinc empinc_kink `covars' if (rspcont>=rspdlc | (penadjl+rspcont)>=contlimit)
est store rppreg
qui reg rspcont empinc empinc_kink `covars' if (rspcont>=rspdlc | (penadjl+rspcont)>=contlimit)
est store savreg

suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

*-------------------------
*2) Non-limit contributors
*-------------------------

qui reg penadj empinc empinc_kink `covars' if rspcont<rspdlc & (penadjl+rspcont)<contlimit
est store rppreg
qui reg rspcont empinc empinc_kink `covars' if rspcont<rspdlc & (penadjl+rspcont)<contlimit
est store savreg

suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

foreach i of numlist 1000(1000)15000 {
	qui reg penadj empinc empinc_kink `covars' if rspcont<rspdlc & (penadjl+rspcont)<contlimit & (rspdlc-rspcont)>`i'
	est store rppreg
	qui reg rspcont empinc empinc_kink `covars' if rspcont<rspdlc & (penadjl+rspcont)<contlimit & (rspdlc-rspcont)>`i'
	est store savreg
	
	suest savreg rppreg, cl(id)
	nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
	test _b[ratio]=-1
}

exit
