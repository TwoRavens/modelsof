************************************************************************
************************************************************************
clear
clear matrix
clear mata
cap log close

global root ~/dropbox/Reservations_Candidacy_ReplicationBackup
include "$root/2progs/00_Set_paths.do"
************************************************************************
************************************************************************
***districthead reservations summary stats
use "$work/districthead_orig", clear
preserve
replace state = proper(trim(state))
estpost tabstat cum_distres, by(state) stat(mean sd min max count)
tabstat cum_distres, stat(mean sd min max count)
estout using "$work/sumstats.txt", style(tex) replace cells("mean sd min max count")
estimates clear
eststo clear
restore

***now use enrollment data
use "$prepdata/NSSHH_19872007.dta", clear 
***drop districts for which there is no IMMT data
drop if cum_distres==.

***set flags
g nonSCST = SCST==0
g f_nonSCST = f==1 & SCST==0
g m_nonSCST = f==0 & SCST==0
g f_SCST = f==1 & SCST==1
g m_SCST = f==0 & SCST==1


**merge in indicators
replace FinalState=upper(FinalState)
g STATE = FinalState
g Final_1 = districtname
merge m:1 STATE Final_1 using "$prepdata/popcensus1991indicators.dta", nogen
drop STATE Final_1


***set cluster by district
egen clustergroup=group(FinalState districtname)

***prep sumstats & ttests output
foreach j in f_nonSCST f_SCST m_nonSCST m_SCST {
g enrollment_`j'=inschool if `j'
}

**added 23 sept 2014: do F test instead, no cutoff but use continuous amount.
winsor mpce , generate(w_mpce) p(0.01) 
tab year
keep if year==1987
keep if urban==0
collapse (mean) rural_sexratio rural_women_literacy inschool cum_distres enrollment_* w_mpce hhsize f SCST [pw=weight], by(clustergroup FinalState districtname)
replace districtname = upper(trim(districtname))

preserve
import excel using "$do/merge/clean_districthead_for_mapdistricts.xlsx", sheet("Sheet1") firstrow clear
keep if _merge =="master only (1)"
assert !mi(district_replace)
drop _m
tempfile temp
save `temp'
restore

merge 1:1 FinalState districtname using `temp', assert(1 3) nogen
replace districtname = district_replace if !mi(district_replace)
drop district_replace
**bring in PC into
merge m:1 FinalState districtname using "$prepdata/1991_PC_election_summary_district_frommapfile", assert(2 3) keep(3) nogen
g m_female_share_candidates_1991 = mi(female_share_candidates_1991 )
replace female_share_candidates_1991  = 0 if mi(female_share_candidates_1991 )

**bring in AC info
merge m:1 FinalState districtname using "$prepdata/prepolicy_AC_election_summary_district_frommapfile", assert(2 3) keep(3) nogen
g m_AC_female_share_cand_prepolicy = mi(AC_female_share_cand_prepolicy )
replace AC_female_share_cand_prepolicy  = 0 if mi(AC_female_share_cand_prepolicy )


la var inschool "School enrollment rate, 1987"
la var rural_women_literacy "Women's literacy rate, 1991"
la var w_mpce "Mean household cons. per cap., 1987"
la var hhsize "Average household size, 1987"
la var f "Sex ratio, 1987"
la var SCST "Share SC/ST, 1991"
la var female_share_candidates_1991 "Female fraction parl. cand., 1991"
la var cum_distres "Cum. years exposure, 2007"

la var AC_female_share_cand_prepolicy "Female fraction AC cand., pre-policy"

eststo clear
foreach i in inschool  rural_women_literacy w_mpce hhsize f SCST "female_share_candidates_1991  m_female_share_candidates_1991 " "AC_female_share_cand_prepolicy m_AC_female_share_cand_prepolicy" {
xi: reg cum_distres `i' i.FinalState, cluster(clustergroup) robust
}
eststo: xi: reg cum_distres inschool  rural_women_literacy w_mpce hhsize f SCST female_share_candidates_1991  m_female_share_candidates_1991 AC_female_share_cand_prepolicy m_AC_female_share_cand_prepolicy i.FinalState, cluster(clustergroup) robust
test w_mpce hhsize f SCST inschool  rural_women_literacy female_share_candidates_1991 AC_female_share_cand_prepolicy 
estadd scalar F_stat = `r(F)'
esttab using "../7tex/analysisoutput/baseline_via_Ftest.tex", style(tex) stats(N F_stat, fmt( %9.0g  %9.3g) labels("N" "F-statistic on test of joint significance")) label replace star( + .1 ++ .05 +++ .01) b(%9.3f) se(%9.3f) nogaps drop(m_female_share_candidates_1991 _I* _cons m_AC_female_share_cand_prepolicy) ///
nomtitles ///
nonotes addnotes("\begin{minipage}{10cm} \smallskip \textbf{Note:}  This table reports the test of joint significance of measures of pre-policy area conditions on eventual policy exposure as of 2007. Estimated with OLS. Heteroskedasticity-consistent standard errors in parentheses. Significance levels are indicated by $*$ $<.1$, ** $<.05$ ,  *** $<.01$.   \end{minipage}" )
 
 
preserve
count
collapse (count) count=f , by(cum_distres female_share_candidates_1991 m_female_share_candidates_1991)
count
qui reg   female_share_candidates_1991 cum_distres if !m_female_share_candidates_1991 [w=count]
local b = round(_b[ cum_distres],.001)
local se = round(_se[ cum_distres], .001)
twoway lfitci  female_share_candidates_1991 cum_distres if !m_female_share_candidates_1991 [w=count] || ///
scatter  female_share_candidates_1991 cum_distres if !m_female_share_candidates_1991 [w=count], msymbol(O) mcolor(gray) ///
, graphregion(color(white)) ytitle("Female fraction parl. cand., 1991") xtitle("Cum. years exposure to chairperson reservations, 2007", size(small)) legend(off)  ///
title("As observed", size(medsmall)) ///
text(.075 8 "Slope= `b'  (`se')", placement(e) size(small))
graph save _1.gph, replace
restore 

preserve
count
collapse (count) count=f , by(cum_distres female_share_candidates_1991 m_female_share_candidates_1991 FinalState)
count
xi: reg cum_distres i.FinalState if !m_female_share_candidates_1991
predict PC_res_resid if e(sample), resid
xi: reg female_share_candidates_1991 i.FinalState if !m_female_share_candidates_1991
predict PC_femshare_resid if e(sample), resid
la var PC_res_resid "Residual, Cum. years exposure, 2007"
la var PC_femshare_resid "Residual, female fraction parl. cand., 1991"
qui reg  female_share_candidates_1991 PC_res_resid if !m_female_share_candidates_1991 [w=count]
qui reg  PC_femshare_resid PC_res_resid if !m_female_share_candidates_1991 [w=count]
local b = round(_b[ PC_res_resid],.001)
local se = round(_se[ PC_res_resid], .001)
twoway lfitci  female_share_candidates_1991 PC_res_resid if !m_female_share_candidates_1991 [w=count] || ///
scatter  female_share_candidates_1991 PC_res_resid if !m_female_share_candidates_1991 [w=count], msymbol(O) mcolor(gray) ///
, graphregion(color(white)) ytitle("") legend(off) ///
title("Residuals after removing state fixed effects", size(medsmall)) ///
text(0.055 3 "Slope= `b'  (`se')", placement(e) size(small))
graph save _2.gph, replace



//main
graph combine _1.gph _2.gph, rows(1) col(2) xsize(10)  graphregion(color(white)) title("Parliamentary elections, 1991", size(medium))
graph export ../7tex/analysisoutput/f_particp_and_cum_exposure.pdf, replace
restore

preserve
count
collapse (count) count=f , by(cum_distres AC_female_share_cand_prepolicy m_AC_female_share_cand_prepolicy)
count
qui reg     AC_female_share_cand_prepolicy cum_distres if !m_AC_female_share_cand_prepolicy [w=count]
local b = round(_b[ cum_distres],.001)
local se = round(_se[ cum_distres], .001)
twoway lfitci  AC_female_share_cand_prepolicy cum_distres if !m_AC_female_share_cand_prepolicy [w=count]|| ///
scatter  AC_female_share_cand_prepolicy cum_distres if !m_AC_female_share_cand_prepolicy [w=count], msymbol(O) mcolor(gray) ///
, graphregion(color(white)) ytitle("Female fraction AC cand., pre-policy") xtitle("Cum. years exposure to chairperson reservations, 2007", size(small)) legend(off)  ///
title("As observed", size(medsmall)) ///
text(.065  8 "Slope= `b'  (`se')", placement(e) size(small))
graph save _1.gph, replace
restore

preserve
count
collapse (count) count=f , by(cum_distres AC_female_share_cand_prepolicy m_AC_female_share_cand_prepolicy FinalState)
count

xi: reg cum_distres i.FinalState if !m_AC_female_share_cand_prepolicy
predict AC_res_resid if e(sample), resid
xi: reg AC_female_share_cand_prepolicy i.FinalState if !m_AC_female_share_cand_prepolicy
predict AC_femshare_resid if e(sample), resid
la var AC_res_resid "Residual, Cum. years exposure"
la var AC_femshare_resid "Residual, female fraction AC cand., pre-policy"


reg     AC_female_share_cand_prepolicy AC_res_resid if !m_AC_female_share_cand_prepolicy [w=count]
reg     AC_femshare_resid AC_res_resid if !m_AC_female_share_cand_prepolicy [w=count]

local b = round(_b[ AC_res_resid],.001)
local se = round(_se[ AC_res_resid], .001)
twoway lfitci AC_female_share_cand_prepolicy AC_res_resid  if !m_AC_female_share_cand_prepolicy [w=count]|| ///
scatter AC_female_share_cand_prepolicy AC_res_resid  if !m_AC_female_share_cand_prepolicy [w=count], msymbol(O) mcolor(gray) ///
, graphregion(color(white)) ytitle("") legend(off) ///
title("Residuals after removing state fixed effects", size(medsmall)) ///
text(.065 4.5 "Slope= `b' (`se')", placement(e) size(small))
graph save _2.gph, replace



//main
graph combine   _1.gph _2.gph, rows(1) col(2) xsize(10) graphregion(color(white)) title("Assembly elections, pre-policy", size(medium))
graph export ../7tex/analysisoutput/f_particp_and_cum_exposure_AC.pdf, replace
restore

