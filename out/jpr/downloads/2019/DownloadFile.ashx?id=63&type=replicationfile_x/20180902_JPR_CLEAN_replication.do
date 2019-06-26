
cd "\\Client\C$\Users\jscho\Google Drive\JPR Special Issue on Refugees, Forced Migration, & Conflict\Submission\Replication\Replication_R&R"
use "201809_JPR_replication.dta", clear


ssc install estout

****************************************************************************
*** Descriptive Stats
****************************************************************************

***Figure 3
histogram t, freq

*plot conscription (for appendix)
histogram t, freq width(5) discrete by(conscription)


corr viol_exp viol_family witness_personal
corr gunheard_proplost_bullets viol_family witness_personal


*Categorical or Count or Continuous
sum c.armed_ties_2 c.viol_exp i.viol_family /// 
neighborhood_trust neighborhood_alert ///
income_total age obstacles facilitators

*Dichotomous
sum i.wasta2 male i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 witness_personal high_high low_high high_low low_low


*** Clarify Violence Received variable

tab viol_exp beating
tab viol_exp knife_blunt_attack
tab viol_exp kidnapped_detained
tab viol_exp injury_battle
tab viol_exp betrayal
tab viol_exp property_lost
tab viol_exp gunfire_heard
tab viol_exp bullets_shot

* Hearing gun fire comes first. Check for what comes next.
gen viol_exp_nogunfire= viol_exp- gunfire_heard

tab viol_exp_nogunfire beating
tab viol_exp_nogunfire knife_blunt_attack
tab viol_exp_nogunfire kidnapped_detained
tab viol_exp_nogunfire injury_battle
tab viol_exp_nogunfire betrayal
tab viol_exp_nogunfire property_lost
tab viol_exp_nogunfire bullets_shot

* Losing property comes second. Check for what comes next.
gen viol_exp_noguns_noproplost= viol_exp_nogunfire - property_lost

tab viol_exp_noguns_noproplost beating
tab viol_exp_noguns_noproplost knife_blunt_attack
tab viol_exp_noguns_noproplost kidnapped_detained
tab viol_exp_noguns_noproplost injury_battle
tab viol_exp_noguns_noproplost betrayal
tab viol_exp_noguns_noproplost bullets_shot

/* Bullets shot comes third. Now create variables to help see
how much of the sample is accounted for with these three variables
*/

gen gunheard_proplost = gunfire_heard + property_lost
gen gunheard_proplost_bullets = gunfire_heard + property_lost + bullets_shot

tab viol_exp gunheard_proplost_bullets


***************************************************************************
**** Analysis
***************************************************************************


*************************************************
*Survival Models
*************************************************
stset t

sts graph

*** MODELS without controls
stcox c.armed_ties_2 i.wasta2 i.motivation c.viol_exp ///
c.viol_family high_low low_high high_high, tvc(male) nohr

est sto mig_reduced_1

*Use motivation and not witness_personal
*because it makes the interaction term make sense

stcox c.armed_ties_2 i.wasta2#i.motivation c.viol_exp ///
c.viol_family high_low low_high high_high, tvc(male) nohr

est sto mig_reduced_2

*** MODELS with controls
stcox c.armed_ties_2 i.wasta2 i.motivation c.viol_exp ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high, tvc(male) nohr

est sto mig_3

stcox c.armed_ties_2 i.wasta2#i.motivation c.viol_exp ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high, tvc(male) nohr

est sto mig_4

*** Check correlation matrix (Shown in Appendix)
stcox c.armed_ties_2 i.wasta2 i.motivation c.viol_exp ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high male

estat vce, corr

*** Appendix table for iterations of Model 4 interaction
stcox c.armed_ties_2 i.wasta2#i.motivation c.viol_exp ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high, tvc(male) nohr

est sto mig_4a

stcox c.armed_ties_2 i.wasta2#i.witness_personal c.viol_exp ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high, tvc(male) nohr

est sto mig_4b

gen nowas=1 if wasta2==0
replace nowas=0 if wasta2==1

stcox c.armed_ties_2 i.nowas#i.motivation c.viol_exp ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high, tvc(male) nohr

est sto mig_4c

stcox c.armed_ties_2 i.nowas#i.witness_personal c.viol_exp ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high, tvc(male) nohr

est sto mig_4d

esttab mig_4a mig_4b mig_4c mig_4d using robustness_witness_interactions.csv, ///
se star(* 0.05 ** 0.01 *** 0.001)


*** Appendix Table for interaction with wasta and violence received
stcox c.armed_ties_2 i.wasta2#c.viol_exp i.witness_personal ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high, tvc(male) nohr

est sto mig_5a

stcox c.armed_ties_2 i.wasta2#c.viol_exp i.witness_personal ///
c.viol_family high_low low_high high_high, tvc(male) nohr

est sto mig_5b

esttab mig_5a mig_5b using robustness_receive_interactions.csv, ///
se star(* 0.05 ** 0.01 *** 0.001)

*** Create Survival Curves to display
stcox c.armed_ties_2 i.wasta2 i.witness_personal c.viol_exp ///
c.viol_family neighborhood_trust neighborhood_alert income_total ///
age i.college_educ betrayal computer tie_intlcompany2 ///
tie_police2 high_low low_high high_high male, nohr

est sto mig_notvc

*** Figure 5
est res mig_notvc
stcurve, survival at1(wasta2=0) at2(wasta2=1)

*** Figure 4
est res mig_notvc
stcurve, survival at1(witness_personal=0) at2(witness_personal=1)

*** Key Descriptive Stats for the analysis
tab wasta2, sum(t)
tab witness_personal, sum(t)
