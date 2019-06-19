
local indata LAD\Data
local infile LAD\Data_Cleaning

use "`indata'\LAD_Crowdout.dta", clear

*Generate the indicators of past contribution behaviour across individuals
by id: gen temp=[_n]
gen rspcont_flag=(rspcont>0)
by id: gen rspcont_lastyr=rspcont_flag[_n-1]
by id: gen rspcont_past=sum(rspcont_flag)-rspcont_flag
drop if temp==1
drop temp rspcont_flag

do "`infile'\LAD_Commands_filtering.do"

*Focus on savers within the relevant bandwidth
keep if empinc>=-6000 & empinc<6000

*Non-Unionized RPP Non-Members do not satisfy the Test of Running Variable and are excluded
keep if dues>0
*Focus on RPP members with strictly positive RRSP contributions
keep if penadj>0 & rspcont>0
keep if rspcont<rspdlc & (penadjl+rspcont)<contlimit

local covars age agesq female married province_* selfempinc_flag eiinc_flag othinc disab medexp

*--------------------------------------------
*1) Whether a contribution was made last year
*--------------------------------------------

qui reg penadj empinc empinc_kink `covars' if rspcont_lastyr==1
est store rppreg
qui reg rspcont empinc empinc_kink `covars' if rspcont_lastyr==1
est store savreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

qui reg penadj empinc empinc_kink `covars' if rspcont_lastyr==0
est store rppreg
qui reg rspcont empinc empinc_kink `covars' if rspcont_lastyr==0
est store savreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

*------------------------------------------------------------
*2) Whether a contribution was ever made in the observed past
*------------------------------------------------------------

qui reg penadj empinc empinc_kink `covars' if rspcont_past>0
est store rppreg
qui reg rspcont empinc empinc_kink `covars' if rspcont_past>0
est store savreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

qui reg penadj empinc empinc_kink `covars' if rspcont_past==0
est store rppreg
qui reg rspcont empinc empinc_kink `covars' if rspcont_past==0
est store savreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

exit
