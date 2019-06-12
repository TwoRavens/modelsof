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

use $prepdata/PC_analysis_dataset, clear
global covariates "rural_women_literacy rural_women_midsch_rate rural_SCST rural_sexratio female_share_candidates_1991 m_rural_women_literacy m_rural_women_midsch_rate m_rural_sexratio m_rural_SCST m_female_share_candidates_1991"

//for summary table --- Table 2 Panel B
g male_cand= count - female_candidate
count
sutex count female_candidate male_cand any_female_cand female_winner female_votes cum_distres, min labels
sutex count female_candidate male_cand  any_female_cand female_winner female_votes cum_distres if constituency_pop_weight>=75, min labels
sum female_winner if any_female_cand == 1
//end for summary table


egen constituencycluster = group(state constituency)
egen districtcluster=group(state district)

replace female_votes = female_votes/100
encode state, g(state_enc)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

***predict outcome
foreach i in female_candidate male_cand {
xi: reg `i'  $covariates i.state [w=constituency_pop_weight]
predict `i'_pred if e(sample), xb
}



*** on predicted
eststo clear
la var cum_distres "Cum. years exposure"
foreach i in female_candidate male_cand {
qui eststo: xi: reghdfe `i'_pred cum_distres_2007 [w=constituency_pop_weight], cluster(districtcluster constituencycluster) absorb(state_enc)
}

esttab _all, scalar(ymean ysd) keep(cum_distres_2007)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
sum cum_distres_2007, d

sum female_candidate_pred male_cand_pred

esttab using ../7tex/analysisoutput/T3Cols34.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )



***
eststo clear
la var cum_distres "Cum. years exposure"
foreach i in female_candidate male_cand {
qui eststo: xi: reghdfe `i' cum_distres_2007 [w=constituency_pop_weight], cluster(districtcluster constituencycluster) absorb(state_enc)
}


foreach i in female_candidate male_cand {
qui eststo: xi: reghdfe `i' cum_distres_2007 [w=constituency_pop_weight] if constituency_pop_weight>=75 , cluster(districtcluster constituencycluster) absorb(state_enc)
}

esttab _all, scalar(ymean ysd) keep(cum_distres_2007)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
sum cum_distres_2007, d

esttab using  ../7tex/analysisoutput/T5PanelA.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $*$ $<.1$, ** $<.05$ ,  *** $<.01$.   \end{minipage}" )



***
eststo clear
la var cum_distres_2007 "Cum. years exposure"
foreach i in female_candidate  male_cand {
qui eststo: xi: reghdfe `i' cum_distres_2007 $covariates  [w=constituency_pop_weight], cluster(districtcluster constituencycluster) absorb(state_enc)
}

foreach i in female_candidate  male_cand {
qui eststo: xi: reghdfe `i' cum_distres_2007 $covariates  [w=constituency_pop_weight] if constituency_pop_weight>=75, cluster(districtcluster constituencycluster) absorb(state_enc)
}


esttab _all, scalar(ymean ysd) keep(cum_distres_2007)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
sum cum_distres_2007, d

esttab using ../7tex/analysisoutput/T5PanelB.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes, also controlling for pre-policy district covariates. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )

sum female_candidate male_cand [w=constituency_pop_weight]



**run poisson
preserve
eststo clear
replace constituency_pop_weight= 1 if constituency_pop_weight<1
foreach i in female_candidate male_cand {
eststo: qui xi: poisson `i' cum_distres_2007 i.state [w=constituency_pop_weight], cluster(districtcluster) // inflate( rural_women_midsch_rate rural_sexratio m_rural_women_midsch_rate m_rural_sexratio )
}
foreach i in female_candidate male_cand {
eststo: qui xi: poisson `i' cum_distres_2007 $covariates i.state [w=constituency_pop_weight], cluster(districtcluster) // inflate( rural_women_midsch_rate rural_sexratio m_rural_women_midsch_rate m_rural_sexratio )
}

restore
esttab _all, scalar(ymean ysd) keep(cum_distres_2007)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
sum cum_distres_2007, d



esttab using ../7tex/analysisoutput/AT5PanelACols34.tex, style(tex)  keep(cum_distres_2007)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $*$ $<.1$, ** $<.05$ ,  *** $<.01$.   \end{minipage}" )




***robustness: squared terms/nonlinear effects & heterogeneous effects
***
eststo clear
qui eststo: xi:  reghdfe female_candidate  cum_distres_2007 [w=constituency_pop_weight], absorb(state)  cluster(districtcluster constituencycluster)
foreach i in  cum_distres_2007 rural_women_literacy rural_women_midsch_rate rural_sexratio rural_SCST {
if ("`i'" != "cum_distres_2007") egen `i'_std = std(`i')
else g `i'_std = `i'
g interaction =  cum_distres_2007 * `i'_std /10
if ("`i'" != "cum_distres_2007") qui eststo: xi:  reghdfe female_candidate  cum_distres_2007 interaction `i'  [w=constituency_pop_weight], absorb(state)  cluster(districtcluster constituencycluster)
else qui eststo: xi:  reghdfe female_candidate cum_distres_2007 interaction  [w=constituency_pop_weight], absorb(state)  cluster(districtcluster constituencycluster)
drop `i'_std  interaction
}


esttab _all, scalar(ymean ysd) keep( cum_distres_2007 interaction)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
sum cum_distres, d


esttab _all using ../7tex/analysisoutput/T6PanelB.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )




****PARLIAMENT ONLY STUFF
***career histories
eststo clear
foreach i in  prior_local any_female_cand_prev_run  any_female_cand_prev_assly_run political_family {
qui eststo: xi: reghdfe `i' cum_distres_2007  [w=constituency_pop_weight], absorb(state) cluster(districtcluster constituencycluster)
sum `i' [w=constituency_pop_weight]
}
esttab _all, scalar(ymean ysd) keep(cum_distres_2007)   se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
esttab using ../7tex/analysisoutput/T7PanelA.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("F. Prev. LS candidacy" "F. Prev. MP" "F. Prev. assembly candidacy" "F. Prev. assembly memb.") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of within-level and cross-level repeat candidacies. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )

eststo clear
foreach i in  prior_local any_female_cand_prev_run  any_female_cand_prev_assly_run political_family {
qui eststo: xi: reghdfe `i' cum_distres_2007  [w=constituency_pop_weight] if constituency_pop_weight>=75, absorb(state) cluster(districtcluster constituencycluster)
sum `i' [w=constituency_pop_weight]
}
esttab _all, scalar(ymean ysd)  keep(cum_distres_2007)   se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
esttab using ../7tex/analysisoutput/T7PanelB.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("F. Prev. LS candidacy" "F. Prev. MP" "F. Prev. assembly candidacy" "F. Prev. assembly memb.") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of within-level and cross-level repeat candidacies. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )


eststo clear
la var early_exposure "Years reserved, 10-15 years prior "
la var mid_exposure "Years reserved, 5-10 years prior"
la var recent_exposure "Years reserved, 0-4 years prior"
foreach i in female_candidate   male_cand {
qui eststo: xi: reghdfe `i' early_exposure mid_exposure recent_exposure   [w=constituency_pop_weight], absorb(state) cluster(districtcluster constituencycluster)
sum `i' [w=constituency_pop_weight]
}

foreach i in female_candidate   male_cand {
qui eststo: xi: reghdfe `i' early_exposure mid_exposure recent_exposure [w=constituency_pop_weight] if constituency_pop_weight>=75,  absorb(state) cluster(districtcluster constituencycluster)
sum `i' [w=constituency_pop_weight]
}
esttab _all, scalar(ymean ysd)  keep( early_exposure mid_exposure recent_exposure)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label

esttab using ../7tex/analysisoutput/T8Cols34.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f)  ///
mtitles("")  ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders in different periods of recency on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )




***group
tab cum_distres_2007
g cat0 =  cum_distres_2007 == 0
g cat12 =  cum_distres_2007 >0 &   cum_distres_2007<=2
g cat35 =  cum_distres_2007 >2 &   cum_distres_2007<=5
g cat67 =  cum_distres_2007 >5 &   cum_distres_2007<=7
g cat811 =  cum_distres_2007 >7 &   cum_distres_2007<=11
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
sum cum_distres_2007, d

esttab using ../7tex/analysisoutput/T9Cols34.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of candidacy and election outcomes. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $*$ $<.1$, ** $<.05$ ,  *** $<.01$.   \end{minipage}" )




***different moments
***
eststo clear
qui eststo: xi: reghdfe female_share_candidates  cum_distres_2007   [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
qui eststo: xi: reghdfe female_votes  cum_distres_2007  [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
qui eststo: xi: reghdfe female_winner  cum_distres_2007   [w=constituency_pop_weight],  cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
foreach i in 5 30th {
replace female_finish_top`i'=female_finish_top`i'>0 if !mi(female_finish_top`i')
qui eststo: reghdfe female_finish_top`i'  cum_distres_2007   [w=constituency_pop_weight],  cluster(districtcluster constituencycluster)  absorb(state_enc)
estadd ysumm
}
esttab _all, scalar(ymean ysd)  keep( cum_distres_2007)  se ar2 star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f)	label

sum female_share_candidates female_votes female_winner female_finish_top5  female_finish_top30th [w=constituency_pop_weight]

esttab using ../7tex/analysisoutput/T10PanelC.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f)  ///
mtitles("")  ///
nonotes addnotes("\begin{minipage}{13cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders in different segments of the elections outcome distribution. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )

eststo clear
qui eststo: xi: reghdfe female_share_candidates  cum_distres_2007  [w=constituency_pop_weight] if constituency_pop_weight>=75,  cluster(districtcluster constituencycluster)  absorb(state_enc)
estadd ysumm
qui eststo: xi:  reghdfe female_votes  cum_distres_2007  [w=constituency_pop_weight] if constituency_pop_weight>=75,  cluster(districtcluster constituencycluster)  absorb(state_enc)
estadd ysumm
qui eststo: xi:  reghdfe female_winner  cum_distres_2007  [w=constituency_pop_weight] if constituency_pop_weight>=75,  cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
foreach i in 5 30th {
replace female_finish_top`i'=female_finish_top`i'>0 if !mi(female_finish_top`i')
qui eststo: xi: reghdfe female_finish_top`i'  cum_distres_2007   [w=constituency_pop_weight] if constituency_pop_weight>=75, cluster(districtcluster constituencycluster) absorb(state_enc)
estadd ysumm
}
esttab _all, scalar(ymean ysd)  keep( cum_distres_2007)  se ar2 star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f)	label

sum female_share_candidates female_votes female_winner female_finish_top5  female_finish_top30th [w=constituency_pop_weight]

esttab using  ../7tex/analysisoutput/T10PanelD.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f)  ///
mtitles("")  ///
nonotes addnotes("\begin{minipage}{13cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders in different segments of the elections outcome distribution. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )




***party information
g mean_vote_share = 1/(male_cand+female_candidate)
replace winmargin = winmargin/100
eststo clear
foreach i in    female_candidate_majorparty  female_candidate_minorparty female_candidate_independent   majorparty_votes  {
qui eststo: xi: reghdfe `i' cum_distres_2007  [w=constituency_pop_weight], cluster(districtcluster constituencycluster)  absorb(state_enc)
sum `i' 
}

foreach i in    female_candidate_majorparty  female_candidate_minorparty female_candidate_independent    majorparty_votes  {
qui eststo: xi: reghdfe `i' cum_distres_2007  [w=constituency_pop_weight] if constituency_pop_weight>=75, cluster(districtcluster constituencycluster) absorb(state_enc)
sum `i' 
}

esttab _all, scalar(ymean ysd) keep(cum_distres_2007)  se ar2 star( * .1 ** .05 *** .01) b(%9.5f) se(%9.5f)	label
esttab using ../7tex/analysisoutput/T11.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
mtitles("F. candidates, major party" "F. candidates, minor party" "F. candidates, independent"  "Vote share to major party cand.") ///
nonotes addnotes("\begin{minipage}{22cm} \footnotesize \smallskip \textbf{Note:}  This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on constituency-level metrics of female candidates by party type. Coefficients are from the estimation of equation (1) in the text. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $+$ $<.1$, ++ $<.05$ ,  +++ $<.01$.   \end{minipage}" )






//test if finishes as major party better
foreach i in female_candidate female_candidate_majorparty female_candidate_minorparty female_candidate_independent {
eststo clear
qui eststo: xi: reghdfe female_winner  cum_distres_2007 [w=constituency_pop_weight] if `i'>0,  absorb(state) cluster(districtcluster constituencycluster)
foreach j in 5 30th {
replace female_finish_top`j'=female_finish_top`j'>0 if !mi(female_finish_top`j')
qui eststo: xi: reghdfe female_finish_top`j'  cum_distres_2007  [w=constituency_pop_weight] if `i'>0, absorb(state)  cluster(districtcluster constituencycluster)
}
esttab using ../7tex/analysisoutput/T12.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps append  ///
mtitles("") nonotes posthead("\midrule \textbf{Panel `i'}\\")
}




///tests against incumbency
replace  incumbent_run = 1 if  incumbent_run==2
replace incumbent_majorparty = 1 if incumbent_majorparty==2
replace  incumbent_prev_win_margin =  incumbent_prev_win_margin/100


eststo clear //incumbent_majorparty
cap encode state, gen(state_enc)
foreach j in female_candidate female_winner { 
foreach i in incumbent_run  incumbent_majorparty  {
g maineffect = `i'
g interaction =  cum_distres_2007 *  maineffect
qui eststo: xi: reghdfe `j'  cum_distres_2007 interaction  maineffect   [w=constituency_pop_weight], absorb(state_enc)  cluster(districtcluster constituencycluster)
qui sum `j'
estadd scalar r(mean)
qui sum `j'
estadd scalar r(sd)
drop maineffect  interaction
}
}
g maineffect = .
g interaction =  .
label var interaction "Cum. years reserved * incumbent present"
label var maineffect "Incumbent present"
esttab _all, scalar(mean sd) keep(cum_distres_2007 interaction  maineffect)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
esttab _all using ../7tex/analysisoutput/T13.tex, style(tex) ///
keep(  cum_distres_2007 interaction  maineffect) stats(N mean sd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps ///
mgroups("Female candidates" "Female winner", pattern(1 0 1 0) span prefix(\multicolumn{@span}{c}{) suffix(}) ) ///
mtitles("\makecell{Any incumbent \\[0/1]\\ (1)}" "\makecell{Major party\\incumbent [0/1] \\(2)}" "\makecell{Any incumbent \\ [0/1] \\ (3)}" "\makecell{Major party\\incumbent [0/1] \\(4)}") ///
nonumbers nonotes ///
addnotes("\begin{minipage}{\linewidth} \footnotesize \smallskip \textbf{Note:} This table reports coefficient estimates of the effect of an additional year of exposure to women leaders on the number of female candidates and whether a female candidate wins the election. Coefficients are from the estimation of equation (1) in the text, including an additional interaction term with the incumbency indicator indicated in column headers. Estimated with OLS. Heteroskedasticity-consistent standard errors clustered by district and constituency in parentheses. Significance levels are indicated by $*$ $<.1$, ** $<.05$ ,  *** $<.01$.   \end{minipage}" )





***THESE ESTIMATES GET APPENDED WITH ASSEMBLY TURNOUT RESULTS

*repeat candidates and voter turnout hypotheses
g female_share_voters = f_vot_15/ tot_vot_15
sum female_share_voters , d

g female_voter_turnout = f_vot_15/ f_elct_15
sum female_voter_turnout , d

replace voter_turnout = voter_turnout/100
rename cum_distres_2007 cum_distres

eststo clear
estimates clear
foreach i in voter_turnout female_share_voters female_voter_turnout {
xi: reghdfe `i' cum_distres [w=constituency_pop_weight], absorb(state) cluster(districtcluster constituencycluster)
sum `i'
estimates save `i'.ster, replace
}
rename  cum_distres cum_distres_2007



***robustness: aggregated dataset
preserve
collapse (mean) cum_distres_2007 [w=constituency_pop_weight], by(state constituency female_candidate female_share_candidates male_cand female_winner female_votes)
saveold "$work/constituency_exposure_summary", replace 

eststo clear
la var cum_distres_2007 "Cum. years exposure"
foreach i in female_candidate  male_cand {
sum `i'
qui eststo: xi: reg `i' cum_distres_2007 i.state , robust
}

foreach i in female_candidate  male_cand {
sum `i'
qui eststo: xi: poisson `i' cum_distres_2007 i.state , robust
}

esttab _all, scalar(ymean ysd) keep(cum_distres_2007)  se ar2 star( * .1 ** .05 *** .01) b(%9.4f) se(%9.4f)	label
sum cum_distres_2007, d

esttab using ../7tex/analysisoutput/AT6PanelB.tex, style(tex)  stats(N ymean ysd, fmt( %9.0g  %9.2f %9.2f) labels("N" "Mean of outcome" "St. dev. of outcome")) label replace star( * .1 ** .05 *** .01) b(%9.3f) se(%9.3f) nogaps  ///
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
qui eststo: xi:  reghdfe female_candidate cum_distres_2007   [w=constituency_pop_weight] if constituency_pop_weight>=`i' ,  cluster(districtcluster constituencycluster) absorb(state_enc)
distinct  constituencycluster if e(sample)==1
local const_clust =  `r(ndistinct)'
use `container', clear
replace estimate = _b[cum_distres] if index==`i'
replace se = _se[cum_distres] if index==`i'
//replace dist_clust = e(N_clus_districtcluster)  if index==`i'
replace const_clust = `const_clust' if index==`i'
noi dis _b[cum_distres]
save `container', replace
restore
}
preserve
use `container', clear
g t =abs(estimate)/se

tostring const_clust, replace
sum estimate, d
g toprow = 1.02*`r(max)'
g const_clust_index = index
replace const_clust_index =. if strpos(string(index),"1")!=2
replace const_clust_index =index if index==1 |index==30 | index==11
replace const_clust="Unique constituencies:" if index==30
replace toprow = 1.04*`r(max)' if  index==30

sum t, d
local axis2min = `r(min)'
local axis2max = 1.02*`r(max)'
scatter estimate index,yaxis(1) || scatter  t index , m(triangle) yaxis(2) yscale(range(`axis2min' `axis2max') axis(2)) || ///
scatter toprow const_clust_index, m(none) mlab(const_clust) yaxis(1) ///
ytitle("Point estimate") xtitle("Constituency area share cutoff") graphregion(color(white)) ///
legend(order(1 3)) yline(1.64, axis(2))
graph export "../7tex/analysisoutput/AF2PanelB.pdf", replace
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
qui forval i = 1/80 {
preserve
qui eststo: xi:  reghdfe female_finish_top30th cum_distres_2007   [w=constituency_pop_weight] if constituency_pop_weight>=`i' ,  cluster(districtcluster constituencycluster) absorb(state_enc)
distinct  constituencycluster if e(sample)==1
local const_clust =  `r(ndistinct)'
use `container', clear
replace estimate = _b[cum_distres] if index==`i'
replace se = _se[cum_distres] if index==`i'
replace const_clust = `const_clust' if index==`i'
noi dis _b[cum_distres]
save `container', replace
restore
}
preserve
use `container', clear
g t =abs(estimate)/se

tostring const_clust, replace
sum estimate, d
g toprow = 1.02*`r(max)'
g const_clust_index = index
replace const_clust_index =. if strpos(string(index),"1")!=2
replace const_clust_index =index if index==1 |index==30 | index==11
replace const_clust="Unique constituencies:" if index==30
replace toprow = 1.04*`r(max)' if  index==30

sum t, d
local axis2min = `r(min)'
local axis2max = 1.02*`r(max)'
scatter estimate index,yaxis(1) || scatter  t index , m(triangle) yaxis(2) yscale(range(`axis2min' `axis2max') axis(2)) || ///
scatter toprow const_clust_index, m(none) mlab(const_clust) yaxis(1) ///
ytitle("Point estimate") xtitle("Constituency area share cutoff") graphregion(color(white)) ///
legend(order(1 3)) yline(1.64, axis(2))
graph export "../7tex/analysisoutput/AF3PanelB.pdf", replace
restore


