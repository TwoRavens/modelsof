***************************************************************************************
***************************************************************************************
*** 																				***
***  Replication File (2)															***
*** 																				***
***  Source: Emmenegger, Patrick, Marx, Paul, and Schraff, Dominik. 2016. Off to 	***
***  a bad start: unemployment and political interest during early adulthood.       ***
***	                                    											***
*** 																				***
***************************************************************************************
***************************************************************************************

set more off

**Install packages
ssc install radiusmatch
ssc install psmatch2

*Set working directory to file where replication data is located (if not already loaded)
cd "Your Directory"

*Load data (if not already loaded)
use "~\off_bad_start.dta" 

***Sort by random variable u and set seed
sort u
set seed 14795

***Replication Table 1
***results for t2
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=35, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=30, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=25, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & entrant==1, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)

***Replication Table 2
***results for t2 using bootstrap
***NOTE: The large N models take very long!
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy) boot(100)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=35, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy) boot(100)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=30, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy) boot(100)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=25, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy) boot(100)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & entrant==1, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy) boot(100)


***Replication Figure 3
***We calculate ATTs for t2 to t5, copy ATTs to Excel and graph it
***Results for t2 are already provided in Table 1

**t3
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 3, out(polint_ch_t3) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 3 & age<=35, out(polint_ch_t3) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 3 & age<=30, out(polint_ch_t3) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 3 & age<=25, out(polint_ch_t3) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 3 & entrant==1, out(polint_ch_t3) boost mahalanobis(polint_t0 hh_inc_t0 eduy)

**t4
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 4, out(polint_ch_t4) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 4 & age<=35, out(polint_ch_t4) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 4 & age<=30, out(polint_ch_t4) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 4 & age<=25, out(polint_ch_t4) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 4 & entrant==1, out(polint_ch_t4) boost mahalanobis(polint_t0 hh_inc_t0 eduy)

**t5
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 5, out(polint_ch_t5) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 5 & age<=35, out(polint_ch_t5) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 5 & age<=30, out(polint_ch_t5) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 5 & age<=25, out(polint_ch_t5) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 5 & entrant==1, out(polint_ch_t5) boost mahalanobis(polint_t0 hh_inc_t0 eduy)


***Replication Figure 2
*results are plotted in R, using ggplot2
tab age if age>16, sum(polint)


**Replicate Table 3
**Scar effects
radiusmatch ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2013 & age>=40 & working== 1 & pglfs==11, out(polint) mahalanobis(eduy ue_30o east) boost 
radiusmatch ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2013 & age>=40 & working== 1 & pglfs==11, out(polint) mahalanobis(eduy ue_30o east) boost boot(100) 

**Replicate Table 4
**Turnout 2009 - retrospective
radiusmatch ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2009 & age>=40 & working== 1 & pglfs==11, out(voted_09) mahalanobis(eduy ue_30o east) boost bc(2)
radiusmatch ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2009 & age>=40 & working== 1 & pglfs==11, out(voted_09) mahalanobis(eduy ue_30o east) boost bc(2) boot(100)



**************
***Appendix***

**Replicate Figure A1
hist syear if t==0, discrete

**Replication Figure A2
*means are copied into Excel and graphed over t
tab ue123 if t== 4 & entrant== 1, sum(polint)
tab ue123 if t== 5 & entrant== 1, sum(polint)
tab ue123 if t== 6 & entrant== 1, sum(polint)
tab ue123 if t== 7 & entrant== 1, sum(polint)
tab ue123 if t== 8 & entrant== 1, sum(polint)
tab ue123 if t== 9 & entrant== 1, sum(polint)

**Replication Table 1A
*Propensity score estimation for entrant model (t2)
probit ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & polint_ch_t2 !=.
probit ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=35 & polint_ch_t2 !=.
probit ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=30 & polint_ch_t2 !=.
probit ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=25 & polint_ch_t2 !=.
probit ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & entrant==1 & polint_ch_t2 !=.

**Replication Table A4 - isco1 instead of industry code
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.isco_t0 i.syear if t== 2 & entrant==1, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)

***Tables A2 & A3
**Replicate results with NN matching and longitudinal weights
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2, out(polint_ch_t2) n(5)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=35, out(polint_ch_t2) n(5)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=30, out(polint_ch_t2) n(5)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=25, out(polint_ch_t2) n(5)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & entrant==1, out(polint_ch_t2) n(5)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]

**Replicate results with radius matching and longitudinal weights
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2, out(polint_ch_t2) radius cal(0.05)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=35, out(polint_ch_t2) radius cal(0.05)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=30, out(polint_ch_t2) radius cal(0.05)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=25, out(polint_ch_t2) radius cal(0.05)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]
psmatch2 ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & entrant==1, out(polint_ch_t2) radius cal(0.05)
sum polint_ch_t2 if _treated==1 [aw=weight_p]
sum _polint_ch_t2 if _treated==1 [aw=weight_p]

***Figures A3 & A4
**Common support and covariate imbalance graphs
*Entrants Model t2
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & entrant==1, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
psgraph
pstest polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear ///
if t== 2 & entrant==1, t(ue) mw(_pscore) both scatter 

***Figures A5 to A8
***Scar Effects Model
*Checking balance
radiusmatch ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2013 & age>=40 & working== 1 & pglfs==11, out(polint) mahalanobis(eduy ue_30o east) boost 
psgraph
pstest i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2013 & age>=40 & working== 1 & pglfs==11,  t(ue_u30_03) mw(_pscore) scatter both

radiusmatch ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2009 & age>=40 & working== 1 & pglfs==11, out(voted_09) mahalanobis(eduy ue_30o east) boost bc(2)
psgraph
pstest i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2009 & age>=40 & working== 1 & pglfs==11,  t(ue_u30_03) mw(_pscore) scatter both

**Estimation of propensity score for scar-effects models
probit ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2013 & age>=40 & polint!=. & working== 1 & pglfs==11
probit ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2009 & age>=40 & voted_09!=. & working== 1 & pglfs==11

**Scar effects models with psmatch2 and weights
psmatch2 ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2013 & age>=40 & working== 1 & pglfs==11, out(polint) n(5)
sum polint if _treated==1 [aw=phrf]
sum _polint if _treated==1 [aw=phrf]
psmatch2 ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2013 & age>=40 & working== 1 & pglfs==11, out(polint) radius cal(0.05)
sum polint if _treated==1 [aw=phrf]
sum _polint if _treated==1 [aw=phrf]

psmatch2 ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2009 & age>=40 & working== 1 & pglfs==11, out(voted_09) n(5)
sum voted_09 if _treated==1 [aw=phrf]
sum _voted_09 if _treated==1 [aw=phrf]
psmatch2 ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc i.ue_30o no_kids curch_attend if syear== 2009 & age>=40 & working== 1 & pglfs==11, out(voted_09) radius cal(0.05)
sum voted_09 if _treated==1 [aw=phrf]
sum _voted_09 if _treated==1 [aw=phrf]

*Scar effects regressions
ologit polint ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc ///
i.ue_30o no_kids curch_attend if syear== 2013 & age>=40 & working== 1 & pglfs==11 [pw=phrf], r 

logit voted_09 ue_u30_03 i.east i.sex eduy i.gold i.mart_stat i.mback hh_inc ///
i.ue_30o no_kids curch_attend if syear== 2009 & age>=40 & working== 1 & pglfs==11 [pw=phrf], r 


**Exclude people moving back into education
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & pglfs!=3, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=35 & pglfs!=3, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=30 & pglfs!=3, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & age<=25 & pglfs!=3, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)
radiusmatch ue polint_t0 hh_inc_t0 i.mback age i.sex eduy i.east i.industry_t0 i.syear if t== 2 & entrant==1 & pglfs!=3, out(polint_ch_t2) boost mahalanobis(polint_t0 hh_inc_t0 eduy)

