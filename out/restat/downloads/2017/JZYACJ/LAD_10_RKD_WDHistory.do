
local indata LAD\Data
local infile LAD\Data_Cleaning

use "`indata'\LAD_Crowdout.dta", clear

*Identify those who are ever observed withdrawing from an RRSP
gen rspwdused_temp=(rspwd>0)
by id: egen rspwdused=max(rspwdused_temp)
drop rspwdused_temp

do "`infile'\LAD_Commands_filtering.do"

*Focus on savers within the relevant bandwidth
keep if empinc>=-6000 & empinc<6000

*Non-Unionized RPP Non-Members do not satisfy the Test of Running Variable and are excluded
keep if dues>0
*Focus on RPP members with strictly positive RRSP contributions
keep if penadj>0 & rspcont>0
keep if rspcont<rspdlc & (penadjl+rspcont)<contlimit

local covars age agesq female married province_* selfempinc_flag eiinc_flag othinc disab medexp

*-----------------
*1) Never withdrew
*-----------------

qui reg penadj empinc empinc_kink `covars' if rspwdused==0
est store rppreg
qui reg rspcont empinc empinc_kink `covars' if rspwdused==0
est store savreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

*----------------
*2) Has withdrawn
*----------------

qui reg penadj empinc empinc_kink `covars' if rspwdused==1
est store rppreg
qui reg rspcont empinc empinc_kink `covars' if rspwdused==1
est store savreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

exit
