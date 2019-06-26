***
*** All Dyad Analysis
clear
clear matrix
set mem 100m

set more off
use "C:\My Dropbox\Sync Folders\Synchronization Files\Research\Midwest05\jpr submission\replication-rost greig jpr2011.dta", clear
relogit peacekeeping lag_igo_peacekeepers ethnoreligious2 ethnoreligious1 sum_accept colonial cwtime contiguous ln_force_ratio lag_lnrefugees contig_refugees lag_lncumdead totalfact lagged_genocide defensepact ethnicwar majpow_thrd lntotal_gled

*** Marginal Effects
**** Marginal effects for contiguity*refugees interaction term
** Hold refugees constant at p75, moving from non-contiguous to contiguous
setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1 majpow_thrd 0 lag_lnrefugees p75
relogitq, fd(pr) changex(contiguous 0 1 contig_refugees 0 10.07496)
relogitq, rr(contiguous 0 1 contig_refugees 0 10.07496)

** Movement from 0 refugees to p75 refugees for a contiguous country 
setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1 majpow_thrd 0 contiguous 1
relogitq, fd(pr) changex(lag_lnrefugees 0 10.07496 contig_refugees 0 10.07496)
relogitq, rr(lag_lnrefugees 0 10.07496 contig_refugees 0 10.07496)

** Movement from 0 refugees to p75 refugees for a non-contiguous country 
setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1 majpow_thrd 0 contiguous 0
relogitq, fd(pr) changex(lag_lnrefugees 0 10.07496)
relogitq, rr(lag_lnrefugees 0 10.07496)

** Movement from contiguous to non-contiguous, no refugees
setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1 majpow_thrd 0 lag_lnrefugees 0
relogitq, fd(pr) changex(contiguous 0 1)
relogitq, rr(contiguous 0 1)

setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1 majpow_thrd 0 contiguous 0 contig_refugees 0

relogitq, fd(pr) changex(lag_igo_peacekeepers 0 1)
relogitq, fd(pr) changex(ethnoreligious2 0 1)
relogitq, fd(pr) changex(sum_accept 0 1)
relogitq, fd(pr) changex(sum_accept 1 4)
relogitq, fd(pr) changex(colonial 0 1)
relogitq, fd(pr) changex(cwtime p25 p75) 
relogitq, fd(pr) changex(majpow_thrd 0 1) 
relogitq, fd(pr) changex(lag_lncumdead p25 p75) 
relogitq, fd(pr) changex(totalfact p25 p75) 
relogitq, fd(pr) changex(lagged_genocide 0 1)
relogitq, fd(pr) changex(ethnicwar 0 1)
relogitq, fd(pr) changex(ln_force_ratio p25 p75)
relogitq, fd(pr) changex(defensepact 0 1)
relogitq, fd(pr) changex(lntotal_gled p25 p75)


setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1 majpow_thrd 0 contiguous 0 contig_refugees 0

relogitq, rr(lag_igo_peacekeepers 0 1)
relogitq, rr(ethnoreligious2 0 1) 
relogitq, rr(sum_accept 0 1)
relogitq, rr(sum_accept 1 4)
relogitq, rr(colonial 0 1) 
relogitq, rr(cwtime p25 p75) 
relogitq, rr(majpow_thrd 0 1) 
relogitq, rr(lag_lncumdead p25 p75) 
relogitq, rr(totalfact p25 p75) 
relogitq, rr(lagged_genocide 0 1)
relogitq, rr(ethnicwar 0 1)
relogitq, rr(ln_force_ratio p25 p75)
relogitq, rr(defensepact 0 1)
relogitq, rr(lntotal_gled p25 p75)


******
*** Major Power Dyad Analysis
******
use "C:\My Dropbox\Sync Folders\Synchronization Files\Research\Midwest05\jpr submission\replication-rost greig jpr2011.dta", clear
keep if majpow_thrd==1
drop if contiguous==1
relogit peacekeeping lag_igo_peacekeepers ethnoreligious2 ethnoreligious1 sum_accept colonial cwtime ln_force_ratio lag_lnrefugees lag_lncumdead totalfact lagged_genocide defensepact ethnicwar lntotal_gled


*** Marginal Effects

setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1

relogitq, fd(pr) changex(ethnoreligious2 0 1)
relogitq, fd(pr) changex(sum_accept 0 1)
relogitq, fd(pr) changex(sum_accept 1 4)
relogitq, fd(pr) changex(colonial 0 1)
relogitq, fd(pr) changex(cwtime p25 p75) 
relogitq, fd(pr) changex(lag_lncumdead p25 p75) 
relogitq, fd(pr) changex(totalfact p25 p75) 
relogitq, fd(pr) changex(lagged_genocide 0 1)
relogitq, fd(pr) changex(ethnicwar 0 1)
relogitq, fd(pr) changex(ln_force_ratio p25 p75)
relogitq, fd(pr) changex(defensepact 0 1)
relogitq, fd(pr) changex(lntotal_gled p25 p75)


setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1

relogitq, rr(lag_igo_peacekeepers 0 1)
relogitq, rr(ethnoreligious2 0 1) 
relogitq, rr(sum_accept 0 1)
relogitq, rr(sum_accept 1 4)
relogitq, rr(colonial 0 1) 
relogitq, rr(cwtime p25 p75) 
relogitq, rr(lag_lncumdead p25 p75) 
relogitq, rr(totalfact p25 p75) 
relogitq, rr(lagged_genocide 0 1)
relogitq, rr(ethnicwar 0 1)
relogitq, rr(ln_force_ratio p25 p75)
relogitq, rr(defensepact 0 1)
relogitq, rr(lntotal_gled p25 p75)



******
*** Non-Major Power Dyads
******

use "C:\My Dropbox\Sync Folders\Synchronization Files\Research\Midwest05\jpr submission\replication-rost greig jpr2011.dta", clear
keep if majpow_thrd==0
relogit peacekeeping lag_igo_peacekeepers ethnoreligious2 ethnoreligious1 sum_accept colonial cwtime contiguous ln_force_ratio lag_lnrefugees contig_refugees lag_lncumdead totalfact lagged_genocide defensepact ethnicwar lntotal_gled

*** Marginal Effects
setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1 contiguous 0 contig_refugees 0

relogitq, fd(pr) changex(ethnoreligious2 0 1)
relogitq, fd(pr) changex(sum_accept 0 1)
relogitq, fd(pr) changex(sum_accept 1 4)
relogitq, fd(pr) changex(colonial 0 1)
relogitq, fd(pr) changex(cwtime p25 p75) 
relogitq, fd(pr) changex(lag_lncumdead p25 p75) 
relogitq, fd(pr) changex(totalfact p25 p75) 
relogitq, fd(pr) changex(lagged_genocide 0 1)
relogitq, fd(pr) changex(ethnicwar 0 1)
relogitq, fd(pr) changex(ln_force_ratio p25 p75)
relogitq, fd(pr) changex(defensepact 0 1)
relogitq, fd(pr) changex(lntotal_gled p25 p75)

setx mean
setx lag_igo_peacekeepers 0 ethnoreligious2 0 ethnoreligious1 0 colonial 0 lagged_genocide 0 defensepact 0 ethnicwar 1 contiguous 0 contig_refugees 0

relogitq, rr(lag_igo_peacekeepers 0 1)
relogitq, rr(ethnoreligious2 0 1) 
relogitq, rr(sum_accept 0 1)
relogitq, rr(sum_accept 1 4)
relogitq, rr(colonial 0 1) 
relogitq, rr(cwtime p25 p75) 
relogitq, rr(lag_lncumdead p25 p75) 
relogitq, rr(totalfact p25 p75) 
relogitq, rr(lagged_genocide 0 1)
relogitq, rr(ethnicwar 0 1)
relogitq, rr(ln_force_ratio p25 p75)
relogitq, rr(defensepact 0 1)
relogitq, rr(lntotal_gled p25 p75)
