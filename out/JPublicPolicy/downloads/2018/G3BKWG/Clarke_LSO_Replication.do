*Figure 1
*See R Code ("lsofunds_descriptive.R")

*Figure 2
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
graph twoway (lfit les_rank cong if tri==2&cong<=104, lcolor(black) lpattern(solid))  (lfit les_rank cong if tri==0&cong<=104, lcolor(black) lpattern(dash)) (lfit les_rank cong if tri==2&cong>=104, lcolor(black) lpattern(solid)) (lfit les_rank cong if tri==0&cong>=104, lcolor(black) lpattern(dash)), xline(104) yscale(range(0 450)) legend(off)

*Figure 3
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
cem chair sub_chair power maj, treatment(treat)
reg les_rank i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store fig3
test placebo==treat
coefplot fig3, keep(treat placebo) xline(0)levels(95 90) citype(norm) nolabels

*Figure 4
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
cem chair sub_chair power maj, treatment(treat)
reg law_all i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store law
reg pass_all i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store pass
reg abc_all i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store abc
reg aic_all i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store aic
reg bills_all i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store bills
test placebo==treat
coefplot law pass abc aic bills, keep(treat placebo) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels

*Figure 5
use  "/Users/clarkeaj/Desktop/Replication/altdvs.dta", clear
cem chair sub_chair power maj, treatment(treat)
reg pa i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store pa
coefplot pa, keep(treat placebo) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels

*Figure 6
use  "/Users/clarkeaj/Desktop/Replication/altdvs.dta", clear
cem chair sub_chair power maj, treatment(treat)
destring closeness, force replace
reg closeness i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store closeness
coefplot closeness, keep(treat placebo) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels
graph save closeness, replace
reg between i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store between
coefplot between, keep(treat placebo) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels
graph save between, replace
reg evcent i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store evcent
coefplot evcent, keep(treat placebo) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels
graph save evcent, replace
destring connectedness, force replace
reg connectedness i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store connect
coefplot connect, keep(treat placebo) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels
graph save connect, replace
graph combine closeness.gph between.gph connect.gph evcent.gph

*Figure 7
use "/Users/clarkeaj/Desktop/Replication/dsgrsc.dta", clear
twoway (lpoly abc_all_perc cong if dsg1994_ever==1&cong<=104, lpattern(dash))(lpoly abc_all_perc cong if dsg1994_ever==1&cong>=104, lpattern(dash)) (lpoly abc_all_perc cong if dsg1994_ever==0&dem==1&chair==0&power==0&sub_chair==0&cong<=104)(lpoly abc_all_perc cong if dsg1994_ever==0&dem==1&chair==0&power==0&sub_chair==0&cong>=104), legend(off) xline(104)

*Figure 8
use "/Users/clarkeaj/Desktop/Replication/dsgrsc.dta", clear
twoway (lpoly les_rank_gop cong if rsc_founder==1), legend(off) xline(104)

*Figure 9
use "/Users/clarkeaj/Desktop/Replication/caucustrends.dta", clear
 twoway (connected count congress if caucus==1, legend(off) xline(104))(connected count congress if caucus==2, legend(off))

***** APPENDIX *****

*Figure A1
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
cem chair sub_chair power maj, treatment(treat)
reg les i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store les3
reg les_log i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store log3
coefplot les3 log3, keep(placebo treat) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels

*Figure A2
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
cem chair sub_chair power maj, treatment(treat)
reg law_all_perc i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store law_perc
reg pass_all_perc i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store pass_perc
reg abc_all_perc i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store abc_perc
reg aic_all_perc i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store aic_perc
coefplot law_perc pass_perc abc_perc aic_perc, keep(treat placebo) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels

*Figure A3
 import excel "/Users/clarkeaj/Desktop/Replication/bluedogpac.xlsx", sheet("Sheet2") firstrow clear
drop if year==.
twoway (scatter usd year, lpattern(solid) legend(off) yline(1723906))

*Figure A4
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
cem chair sub_chair power maj, treatment(treat)
reg les_rank i.cong i.icpsr placebo treat if leader_dsg_ever==0 [iweight=cem_weights], cluster(icpsr)
estimates store robustness1
reg les_rank i.cong i.icpsr placebo treat if leader_rsc_ever==0 [iweight=cem_weights], cluster(icpsr)
estimates store robustness2
reg les_rank i.cong i.icpsr placebo treat if leader_rsc_ever==0&leader_dsg_ever==0 [iweight=cem_weights], cluster(icpsr)
estimates store robustness3
coefplot robustness1 robustness2 robustness3, keep(treat placebo) xline(0) mcolor(black) levels(95 90) citype(norm) nolabels

*Figure A5
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
twoway (kdensity dist_maj if cong<104&leader_lso==1)(kdensity dist_maj if cong<104&chair==1)(kdensity dist_maj if cong<104&chair!=1&leader_lso!=1)

*Figure A6
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
twoway  (lpoly les_rank cong if leader_maj==1, lpattern(dash)) (lpoly les_rank cong if treatment_group==1, lpattern(solid)), xline(104) legend(off)

*Table A2
*Alternative Specifications for Figure 3
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
cem chair sub_chair power maj, treatment(treat)
reg les_rank i.icpsr i.cong treat, cluster(icpsr)
estimates store rank1
reg les_rank i.icpsr i.cong chair sub_chair power maj placebo treat, cluster(icpsr) 
estimates store rank2
reg les_rank i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store rank3
test placebo==treat

*Table A3
use "/Users/clarkeaj/Desktop/Replication/clarke_lso1.dta", clear
cem chair sub_chair power maj, treatment(treat)
reg les i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store les3
reg les_log i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store log3
reg les_rank_party i.cong i.icpsr placebo treat [iweight=cem_weights], cluster(icpsr)
estimates store partyrank3
