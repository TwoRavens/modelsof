*** Additional Analyses Complementing R Code ***

* Preliminary 
clear
cd "/Users/KristinGarrett/Desktop/Submission Material/Data"

** SSI Primary Analyses

// load imputed SSI data
use "The Moral Roots of Partisan Division_Imputed SSI Data.dta"

/// 2016 party gap

mi estimate: reg ssi_party_feel_dif ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

mibeta ssi_party_feel_dif ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

/// 2016 candidate gap

mi estimate: reg ssi_leader_feel_dif ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

mibeta ssi_leader_feel_dif ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

/// 2016 relationship distance

mi estimate: reg ssi_ap_dateI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

mibeta ssi_ap_dateI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

/// 2016 social media distance

mi estimate: reg ssi_ap_blockI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

mibeta ssi_ap_blockI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

/// 2016 anger

mi estimate: reg ssi_ap_angryI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

mibeta ssi_ap_angryI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

/// 2016 incivility

mi estimate: reg ssi_ap_funI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

mibeta ssi_ap_funI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

/// 2016 antagonism

mi estimate: reg ssi_ap_upsetI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

mibeta ssi_ap_upsetI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know

** SSI Secondary Analyses

* Interaction Term Between Partisan Strength and Propensity to Moralize

/// 2016 party gap

mi estimate: reg ssi_party_feel_dif ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

* Marginal Effects
mimrgns, dydx(ssi_avg_prop_mor) at(ssi_party_extrem=(0 .33333333334 .66666666667 1))
mimrgns, dydx(ssi_party_extrem) at(ssi_avg_prop_mor=(0 .25 .5 .75 1))

mibeta ssi_party_feel_dif ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

/// 2016 candidate gap

mi estimate: reg ssi_leader_feel_dif ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

* Marginal Effects
mimrgns, dydx(ssi_avg_prop_mor) at(ssi_party_extrem=(0 .33333333334 .66666666667 1))
mimrgns, dydx(ssi_party_extrem) at(ssi_avg_prop_mor=(0 .25 .5 .75 1))

mibeta ssi_leader_feel_dif ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

/// 2016 relationship distance

mi estimate: reg ssi_ap_dateI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

* Marginal Effects
mimrgns, dydx(ssi_avg_prop_mor) at(ssi_party_extrem=(0 .33333333334 .66666666667 1))
mimrgns, dydx(ssi_party_extrem) at(ssi_avg_prop_mor=(0 .25 .5 .75 1))

mibeta ssi_ap_dateI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

/// 2016 social media distance

mi estimate: reg ssi_ap_blockI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

* Marginal Effects
mimrgns, dydx(ssi_avg_prop_mor) at(ssi_party_extrem=(0 .33333333334 .66666666667 1))
mimrgns, dydx(ssi_party_extrem) at(ssi_avg_prop_mor=(0 .25 .5 .75 1))

mibeta ssi_ap_blockI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

/// 2016 anger

mi estimate: reg ssi_ap_angryI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

* Marginal Effects
mimrgns, dydx(ssi_avg_prop_mor) at(ssi_party_extrem=(0 .33333333334 .66666666667 1))
mimrgns, dydx(ssi_party_extrem) at(ssi_avg_prop_mor=(0 .25 .5 .75 1))

mibeta ssi_ap_angryI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

/// 2016 incivility

mi estimate: reg ssi_ap_funI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

* Marginal Effects
mimrgns, dydx(ssi_avg_prop_mor) at(ssi_party_extrem=(0 .33333333334 .66666666667 1))
mimrgns, dydx(ssi_party_extrem) at(ssi_avg_prop_mor=(0 .25 .5 .75 1))

mibeta ssi_ap_funI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

/// 2016 antagonism

mi estimate: reg ssi_ap_upsetI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

* Marginal Effects 
mimrgns, dydx(ssi_avg_prop_mor) at(ssi_party_extrem=(0 .33333333334 .66666666667 1))
mimrgns, dydx(ssi_party_extrem) at(ssi_avg_prop_mor=(0 .25 .5 .75 1))

mibeta ssi_ap_upsetI ssi_avg_prop_mor ssi_party_extrem ///
 ssi_ideol_extrem ssi_white ssi_female ssi_age_cor ///
ssi_educ1 ssi_b_a ssi_rel_attend ssi_pol_know c.ssi_avg_prop_mor#c.ssi_party_extrem

** ANES EGSS Primary Analyses for Candidate Gap

// load imputed ANES data
use "The Moral Roots of Partisan Division_Imputed ANES EGSS Data.dta"

/// 2012 candidate gap

mi estimate: reg anes_rating_dif2 anes_prop_moralize anes_party_extrem ///
anes_ideol_extrem anes_white anes_female anes_age ///
anes_education anes_evangel anes_rel_attend1 anes_pol_know [pw=anes_wght]
 
mibeta anes_rating_dif2 anes_prop_moralize anes_party_extrem ///
anes_ideol_extrem anes_white anes_female anes_age ///
anes_education anes_evangel anes_rel_attend1 anes_pol_know [pw=anes_wght]
 
** ANES Secondary Analyses for Candidate Gap

* Interaction Term Between Partisan Strength and Propensity to Moralize
 
/// 2012 candidate gap
 
mi estimate: reg anes_rating_dif2 anes_prop_moralize anes_party_extrem ///
anes_ideol_extrem anes_white anes_female anes_age ///
anes_education anes_evangel anes_rel_attend1 anes_pol_know ///
c.anes_prop_moralize#c.anes_party_extrem  [pw=anes_wght]
 
* Marginal Effects 
mimrgns, dydx(anes_prop_moralize) at(anes_party_extrem=(0 .33333333334 .66666666667 1))
 
mibeta anes_rating_dif2 anes_prop_moralize anes_party_extrem ///
anes_ideol_extrem anes_white anes_female anes_age ///
anes_education anes_evangel anes_rel_attend1 anes_pol_know ///
c.anes_prop_moralize#c.anes_party_extrem  [pw=anes_wght]
 
** ANES EGSS Primary Analyses for Presidential Approval

// load imputed ANES data with dichotomous party id for presidential approval analyses 
use "The Moral Roots of Partisan Division_Imputed ANES EGSS Data_for PA.dta"

/// 2012 partisan divide in presidential approval

mi estimate: reg anes_job_approve anes_repub_d_no anes_prop_moralize  ///
anes_party_extrem1 ///
anes_ideol_extrem anes_rel_attend1 anes_evangel anes_pol_know ///
anes_white anes_female anes_age anes_education rep_moral [pw=anes_wght]
  
mibeta anes_job_approve anes_repub_d_no anes_prop_moralize  ///
anes_party_extrem1 ///
anes_ideol_extrem anes_rel_attend1 anes_evangel anes_pol_know ///
anes_white anes_female anes_age anes_education rep_moral [pw=anes_wght]

** ANES Secondary Analyses for Presidential Approval

* Interaction Term Between Partisan Strength and Propensity to Moralize

/// 2012 partisan divide in presidential approval

mi estimate: reg anes_job_approve anes_repub_d_no anes_prop_moralize  ///
anes_party_extrem1 ///
anes_ideol_extrem anes_rel_attend1 anes_evangel anes_pol_know ///
anes_white anes_female anes_age anes_education  ///
c.anes_prop_moralize#i.anes_repub_d_no ///
c.anes_prop_moralize#c.anes_party_extrem1 [pw=anes_wght]
   
* Marginal Effects for Democrats  
mimrgns if anes_repub_d_no==0, dydx(anes_prop_moralize) at(anes_party_extrem1=(0 .5 1))
* Marginal Effects for Republicans  
mimrgns if anes_repub_d_no==1, dydx(anes_prop_moralize) at(anes_party_extrem1=(0 .5 1))

mibeta anes_job_approve anes_repub_d_no anes_prop_moralize  ///
anes_party_extrem1 ///
anes_ideol_extrem anes_rel_attend1 anes_evangel anes_pol_know ///
anes_white anes_female anes_age anes_education ///
c.anes_prop_moralize#i.anes_repub_d_no ///
c.anes_prop_moralize#c.anes_party_extrem [pw=anes_wght]  

** Scale Properties for Affective Polarization in Everyday Life

// load SSI data
use "The Moral Roots of Partisan Division_SSI Data.dta"

* Overall scale properties
// Don't know responses coded as 0, rather than missing, for the following analyses

tabulate ap_datei11 
tabulate ap_blocki11 
tabulate ap_angryi11 
tabulate ap_funi11
tabulate ap_upseti11 

/// Cronbach's alpha

alpha ap_datei11 ap_blocki11 ap_funi11 ap_angryi11 ap_upseti11

* Scale properties for Democrats

tabulate ap_datei11 if ssi_partyid_3 == 1
tabulate ap_blocki11 if ssi_partyid_3 == 1
tabulate ap_angryi11 if ssi_partyid_3 == 1
tabulate ap_funi11 if ssi_partyid_3 == 1
tabulate ap_upseti11 if ssi_partyid_3 == 1

/// Cronbach's alpha

alpha ap_datei11 ap_blocki11 ap_funi11 ap_angryi11 ap_upseti11 if ssi_partyid_3 == 1

* Scale properties for Republicans

tabulate ap_datei11 if ssi_partyid_3 == 3
tabulate ap_blocki11 if ssi_partyid_3 == 3
tabulate ap_angryi11 if ssi_partyid_3 == 3
tabulate ap_funi11 if ssi_partyid_3 == 3
tabulate ap_upseti11 if ssi_partyid_3 == 3

/// Cronbach's alpha

alpha ap_datei11 ap_blocki11 ap_funi11 ap_angryi11 ap_upseti11 if ssi_partyid_3 == 3






