************************************************************************
***************SETUP CODE HEADER FOR ALL PROGRAMS***********************
***************									 ***********************
************************************************************************
clear
clear matrix
clear mata
cap log close
set more off, perm

global root ~/dropbox/Reservations_Candidacy_ReplicationBackup
include "$root/2progs/00_Set_paths.do"
************************************************************************
************************************************************************
use $prepdata/AC_analysis_dataset, clear
global covariates "rural_women_literacy rural_women_midsch_rate rural_SCST rural_sexratio female_share_cand_prepolicy m_rural_women_literacy m_rural_women_midsch_rate m_rural_sexratio m_rural_SCST m_female_share_cand_prepolicy"

***T2 Panel A and means in tables
sutex count female_candidate male_cand any_female_candidate female_winner female_votes cum_distres, min labels

sutex count female_candidate male_cand any_female_candidate female_winner female_votes cum_distres if constituency_pop_weight>=75, min labels

egen constituencycluster = group(state AC)

encode state, gen(state_enc)


***run on predicted
eststo clear
la var cum_distres "Cum. years exposure"
foreach i in female_candidate male_cand  {
qui eststo: xi:  reghdfe `i'_pred cum_distres  [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
sum `i'_pred
}
esttab _all, scalar(ymean ysd) keep(cum_distres)  se ar2 star( + .1 ++ .05 +++ .01) b(%9.4f) se(%9.4f)	label
sum cum_distres, d

sum female_candidate_pred male_cand_pred
esttab _all using ../7tex/analysisoutput/T3Cols12.tex, style(tex) stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( + .1 ++ .05 +++ .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )


***run regs
eststo clear
la var cum_distres "Cum. years exposure"
foreach i in female_candidate male_cand {
qui eststo: xi:    reghdfe `i' cum_distres  [w=constituency_pop_weight] ,  cluster(districtcluster constituencycluster)  absorb(state_enc)
}


foreach i in female_candidate male_cand {
qui eststo: xi:    reghdfe `i' cum_distres  [w=constituency_pop_weight] if constituency_pop_weight>=75,  cluster(districtcluster constituencycluster)  absorb(state_enc)
sum `i' if e(sample)
}

esttab _all, scalar(ymean ysd) keep(cum_distres)  se ar2 star( + .1 ++ .05 +++ .01) b(%9.4f) se(%9.4f)	label
sum cum_distres, d

esttab _all using ../7tex/analysisoutput/T4PanelA.tex, style(tex) stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( + .1 ++ .05 +++ .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )





***run regs
preserve
eststo clear
la var cum_distres "Cum. years exposure"
foreach i in female_candidate male_cand {
qui eststo: xi:  reghdfe `i' cum_distres  $covariates [w=constituency_pop_weight],  cluster(districtcluster constituencycluster)   absorb(state_enc)
*estadd ysumm
}
foreach i in female_candidate male_cand {
qui eststo: xi:    reghdfe `i' cum_distres $covariates [w=constituency_pop_weight] if constituency_pop_weight>=75,  cluster(districtcluster constituencycluster)  absorb(state_enc)
sum `i' if e(sample)
}


esttab _all, scalar(ymean ysd) keep(cum_distres)  se ar2 star( + .1 ++ .05 +++ .01) b(%9.4f) se(%9.4f)	label
sum cum_distres, d

esttab _all using ../7tex/analysisoutput/T4PanelB.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( + .1 ++ .05 +++ .01) b(%9.3f) se(%9.3f) nogaps ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )
restore

sum female_candidate male_cand [w=constituency_pop_weight]




***run poisson
eststo clear
la var cum_distres "Cum. years exposure"

preserve
replace constituency_pop_weight = 1 if constituency_pop_weight<1
cap drop cum_distres_2007
g cum_distres_2007= cum_distres
foreach i in female_candidate male_cand {
eststo: qui xi:  poisson `i' cum_distres_2007 i.state [w=constituency_pop_weight], cluster(districtcluster) //inflate( rural_women_midsch_rate rural_sexratio m_rural_women_midsch_rate m_rural_sexratio ) //note that using the weight here turn this nonconcave; noting this explicitly for transparency. count models only a validation in any case

}
foreach i in female_candidate male_cand {
eststo: qui xi:  poisson `i' cum_distres_2007 $covariates i.state [w=constituency_pop_weight], cluster(districtcluster) //inflate( rural_women_midsch_rate rural_sexratio m_rural_women_midsch_rate m_rural_sexratio ) //note that using the weight here turn this nonconcave; noting this explicitly for transparency. count models only a validation in any case

}
restore

esttab _all using ../7tex/analysisoutput/AT5Cols12.tex, style(tex) keep(cum_distres_2007) stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )






***robustness: squared terms/nonlinear effects & heterogeneous effects
***run regs
eststo clear
qui eststo: xi:  reghdfe female_candidate cum_distres  [w=constituency_pop_weight],  absorb(state) cluster(districtcluster constituencycluster)
foreach i in cum_distres rural_women_literacy rural_women_midsch_rate rural_sexratio rural_SCST   {
if ("`i'" != "cum_distres") egen `i'_std = std(`i')
else g `i'_std = `i'
g interaction = cum_distres * `i'_std /10
if ("`i'" != "cum_distres") qui eststo: xi:  reghdfe female_candidate cum_distres interaction `i'  [w=constituency_pop_weight],  absorb(state) cluster(districtcluster constituencycluster)
else qui eststo: xi:  reghdfe female_candidate cum_distres interaction   [w=constituency_pop_weight], absorb(state)  cluster(districtcluster constituencycluster)
drop `i'_std  interaction
}


esttab _all, scalar(ymean ysd) keep(cum_distres interaction)  se ar2 star( + .1 ++ .05 +++ .01) b(%9.4f) se(%9.4f)	label
sum cum_distres, d


esttab _all using ../7tex/analysisoutput/T6PanelA.tex, style(tex) stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( + .1 ++ .05 +++ .01) b(%9.3f) se(%9.3f) nogaps drop(_cons) ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )






***INTERACTIONS WITH EARLY VERSUS LATE EXPOSURE
eststo clear
estimates clear
la var early_exposure "Years reserved, 10-15 years prior"
la var mid_exposure "Years reserved, 5-10 years prior"
la var recent_exposure "Years reserved, 0-4 years prior"
foreach i in female_candidate male_cand {
qui eststo: xi: reghdfe `i' early_exposure mid_exposure recent_exposure   [w=constituency_pop_weight], absorb(state)  cluster(districtcluster constituencycluster)
}
esttab _all, scalar(ymean ysd) keep(recent_exposure mid_exposure early_exposure)  se ar2 star( + .1 ++ .05 +++ .01) b(%9.4f) se(%9.4f)	label
sum cum_distres, d

esttab _all using ../7tex/analysisoutput/T8Cols12.tex, style(tex) stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( + .1 ++ .05 +++ .01) b(%9.3f) se(%9.3f) drop(_cons) ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders in different periods of recency on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )



***run regs
tab cum_distres
g cat0 =  cum_distres == 0
g cat12 =  cum_distres >0 &   cum_distres<=2
g cat35 =  cum_distres >2 &   cum_distres<=5
g cat67 =  cum_distres >5 &   cum_distres<=7
g cat811 =  cum_distres >7 &   cum_distres<=11
la var cum_distres "Cum. years exposure"

eststo clear

foreach i in female_candidate  {
qui eststo: xi: reghdfe `i' cat12 cat35 cat67 cat811 [w=constituency_pop_weight], cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
}


foreach i in female_candidate  {
qui eststo: xi: reghdfe `i'  cat12 cat35 cat67 cat811 [w=constituency_pop_weight] if constituency_pop_weight>=75 , cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
}

esttab _all, scalar(ymean ysd) keep(  cat12 cat35 cat67 cat811)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label

esttab using  ../7tex/analysisoutput/T9Cols12.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $*$ $<.1$, ** $<.05$ ,  *** $<.01$.   \end{minipage}" )






***different moments
***run regs
eststo clear
qui eststo: xi: reghdfe female_share_candidates  cum_distres   [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
qui eststo: xi: reghdfe female_votes  cum_distres   [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
qui eststo: xi: reghdfe female_winner  cum_distres   [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
foreach i in 5 30th {
qui eststo: xi: reghdfe female_finish_top`i'  cum_distres   [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
}
esttab _all, scalar(ymean ysd)  keep( cum_distres)  se ar2 star( + .1 ++ .05 +++ .01) b(%9.4f) se(%9.4f)	label

sum female_share_candidates female_votes female_winner female_finish_top5  female_finish_top30th

esttab using  ../7tex/analysisoutput/T10PanelA.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( + .1 ++ .05 +++ .01) b(%9.5f) se(%9.5f)  ///
mtitles("Top 3" "Top 5" "Top 10\%" "Top 30\%" "Top 50\%")  ///
nonotes addnotes("\begin{minipage}{13cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders in different segments of the elections outcome distribution. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )


eststo clear
qui eststo: xi: reghdfe female_share_candidates  cum_distres  [w=constituency_pop_weight] if constituency_pop_weight>=75,  cluster(districtcluster constituencycluster)  absorb(state_enc)
estadd ysumm
qui eststo: xi:  reghdfe female_votes  cum_distres  [w=constituency_pop_weight] if constituency_pop_weight>=75,  cluster(districtcluster constituencycluster)  absorb(state_enc)
estadd ysumm
qui eststo: xi:  reghdfe female_winner  cum_distres  [w=constituency_pop_weight] if constituency_pop_weight>=75,  cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
foreach i in 5 30th {
replace female_finish_top`i'=female_finish_top`i'>0 if !mi(female_finish_top`i')
qui eststo: xi: reghdfe female_finish_top`i'  cum_distres   [w=constituency_pop_weight] if constituency_pop_weight>=75, cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
}
esttab _all, scalar(ymean ysd)  keep( cum_distres)  se ar2 star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f)	label

sum female_share_candidates female_votes female_winner female_finish_top5  female_finish_top30th [w=constituency_pop_weight]

esttab using ../7tex/analysisoutput/T10PanelB.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f)  ///
mtitles("")  ///
nonotes addnotes("\begin{minipage}{13cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders in different segments of the elections outcome distribution. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )





***VOTER TURNOUT
eststo clear
estimates clear
estimates use voter_turnout.ster
estimates store voter_turnout
estimates use female_share_voters.ster
estimates store female_share_voters
estimates use female_voter_turnout.ster
estimates store female_voter_turnout


g turnout = Turnout/100
assert turnout>=0 & turnout<=1 if !mi(turnout)

g female_share_voters_AC = fturnout/(fturnout+mturnout)

foreach i in turnout female_share_voters_AC fturnout {
xi: reghdfe `i' cum_distres  [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
estimates store `i'
sum `i' if e(sample)
}


esttab _all, scalar(ymean ysd) keep(cum_distres) se ar2 star( + .1 ++ .05 +++ .01) b(%9.4f) se(%9.4f)	label

esttab _all using ../7tex/analysisoutput/T14.tex, keep(cum_distres) style(tex) stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f)  nogaps ///
mtitles("Voter turnout" "Female share voters" "Female voter turnout" "Voter turnout, AC" "Female share voters, AC" "Female voter turnout, AC") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of voter turnout outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )
eststo clear
estimates clear

***robustness: aggregated dataset
preserve
collapse (mean) cum_distres [w=constituency_pop_weight], by(state ac_name ac_no female_candidate  male_cand )
saveold "$work/constituency_exposure_summary_ACs", replace 

eststo clear
la var cum_distres "Cum. years exposure"
foreach i in female_candidate  male_cand {
sum `i'
qui eststo: xi: reghdfe `i' cum_distres i.state  , noabsorb vce(robust)
}

foreach i in female_candidate  male_cand {
sum `i'
qui eststo: xi: poisson `i' cum_distres i.state  ,  robust
}

esttab _all, scalar(ymean ysd) keep(cum_distres)  se ar2 star( + .1 ++ .05 +++ .01) b(%9.4f) se(%9.4f)	label
sum cum_distres, d

esttab using ../7tex/analysisoutput/AT6PanelA.tex, style(tex) stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( + .1 ++ .05 +++ .01) b(%9.3f) se(%9.3f) nogaps drop(_cons) ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes, also controlling for pre-policy district covariates. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )
restore



***robustness: effect sizes based on sample trimming
preserve
clear
set obs 80
g index =_n
g estimate = .
g se = .
g dist_clust = .
g const_clust = .
tempfile container
save `container'
restore
eststo clear
forval i = 1/80 {
preserve
qui eststo: xi:  reghdfe female_candidate cum_distres   [w=constituency_pop_weight] if constituency_pop_weight>=`i' ,  absorb(state) cluster(districtcluster constituencycluster)
distinct  constituencycluster if e(sample)==1
local const_clust =  `r(ndistinct)'
use `container', clear
replace estimate = _b[cum_distres] if index==`i'
replace se = _se[cum_distres] if index==`i'
replace dist_clust = e(N_clus_districtcluster)  if index==`i'
replace const_clust = `const_clust' if index==`i'
save `container', replace
restore
}
preserve
use `container', clear
g t =abs(estimate)/se
scatter estimate t
scatter estimate index
g size = 1
replace size = 2 if t>=1.96
replace size = 3 if t>=2.30

tostring const_clust, replace
sum estimate, d
g toprow = 1.02*`r(max)'
g const_clust_index = index
replace const_clust_index =. if strpos(string(index),"1")!=2
replace const_clust_index =index if index==1 |index==30 | index==11
replace const_clust="Unique constituencies:" if index==30
replace toprow = 1.03*`r(max)' if  index==30

sum t, d
local axis2min = `r(min)'
local axis2max = 1.02*`r(max)'

scatter estimate index,yaxis(1)  || scatter  t index , m(triangle) yaxis(2) yscale(range(`axis2min' `axis2max') axis(2)) || ///
scatter toprow const_clust_index, m(none) mlab(const_clust) yaxis(1) ///
ytitle("Point estimate") xtitle("Constituency area share cutoff") graphregion(color(white)) ///
legend(order(1 3)) yline(1.64, axis(2))
graph export "../7tex/analysisoutput/AF2PanelA.pdf", replace
restore


preserve
clear
set obs 80
g index =_n
g estimate = .
g se = .
g dist_clust = .
g const_clust = .
tempfile container
save `container'
restore
eststo clear
forval i = 1/80{
preserve
qui eststo: xi:  reghdfe female_finish_top30th cum_distres   [w=constituency_pop_weight] if constituency_pop_weight>=`i' ,   absorb(state)  cluster(districtcluster constituencycluster)
distinct  constituencycluster if e(sample)==1
local const_clust =  `r(ndistinct)'
use `container', clear
replace estimate = _b[cum_distres] if index==`i'
replace se = _se[cum_distres] if index==`i'
replace dist_clust = e(N_clus_districtcluster)  if index==`i'
replace const_clust = `const_clust' if index==`i'
save `container', replace
restore
}
preserve
use `container', clear
g t =abs(estimate)/se
scatter estimate t
scatter estimate index
g size = 1
replace size = 2 if t>=1.96
replace size = 3 if t>=2.30

tostring const_clust, replace
sum estimate, d
g toprow = 1.1*`r(max)'
g const_clust_index = index
replace const_clust_index =. if strpos(string(index),"1")!=2
replace const_clust_index =index if index==1 |index==30 | index==11
replace const_clust="Unique constituencies:" if index==30
replace toprow = 1.15*`r(max)' if  index==30

sum t, d
local axis2min = `r(min)'
local axis2max = 1.1*`r(max)'

scatter estimate index,yaxis(1)  || scatter  t index , m(triangle) yaxis(2) yscale(range(`axis2min' `axis2max') axis(2)) || ///
scatter toprow const_clust_index, m(none) mlab(const_clust) yaxis(1) ///
ytitle("Point estimate") xtitle("Constituency area share cutoff") graphregion(color(white)) ///
legend(order(1 3))
graph export "$work/../7tex/analysisoutput/AF3PanelA.pdf", replace
restore

