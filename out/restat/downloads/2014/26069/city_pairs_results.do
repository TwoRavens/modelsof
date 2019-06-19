clear 
* Replicates results for city pairs
use city_pair_rep.dta
set more off
xtset rcid date
* Main Specification
* Table 3
xi:xtivreg2 fgini lass* cash op_ non_  bankr i.date (hhi hhi2 = lgmean* lamean* genp* ltot_route*),fe cluster (rid)
outreg2 using Table3_rep_city,ctitle(1) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word replace
xi:xtivreg2 fgini lass* cash op_ non_  bankr i.date (hhi hhi2 = lgmean* lamean* genp* ltot_route*),fe cluster (rid)
outreg2 using Table3_rep_city,ctitle(2) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word append
xi:xtivreg2 fgini lass* cash op_ non_  bankr i.date (mono comp = lgmean* lamean* genp* ltot_route*),fe cluster (rid)
outreg2 using Table3_rep_city,ctitle(3) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word append
xi:xtivreg2 fgini lass* cash op_ non_ bankr i.date (nc = lgmean* lamean* genp* ltot*),fe cluster (rid)
outreg2 using Table3_rep_city,ctitle(4) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word append
* Table 4
xi:xtivreg2 lp90 lass* cash op_ non_ bankr i.date (duo comp = lgmean* lamean* genp* ltot*),fe cluster (rid)
outreg2 using Table4_rep_city,ctitle(log(P90)) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word replace
xi:xtivreg2 lp10 lass* cash op_ non_ bankr i.date (duo comp = lgmean* lamean* genp* ltot*),fe cluster (rid)
outreg2 using Table4_rep_city,ctitle(log(P90)) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word append
* Table 6
xi:xtivreg2 fgini lass* cash op_ non_ bankr i.date (lhhi = lgmean* lamean* genp* ltot*) if tot_route<=19265,fe cluster (rid)
outreg2 using Table6_rep_city,ctitle(low) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word replace
xi:xtivreg2 fgini lass* cash op_ non_ bankr i.date (lhhi = lgmean* lamean* genp* ltot*) if tot_route<94634&tot_route>19265,fe cluster (rid)
outreg2 using Table6_rep_city,ctitle(medium) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word append
xi:xtivreg2 fgini lass* cash op_ non_ bankr i.date (lhhi = lgmean* lamean* genp* ltot*) if tot_route>=94634,fe cluster (rid)
outreg2 using Table6_rep_city,ctitle(high) bdec(3) tdec(3) rdec(3) adec(3) alpha(.01, .05, .1) addstat(Adj. R-squared, e(r2_a)) addnote(*** 1%, ** 5%, *10%.) word append

