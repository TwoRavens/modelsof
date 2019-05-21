*******************************
** 02_AnalyzeFieldExperiment.do
**
**
** Estimate secret ballot treatment effects.
** All analysis is performed by strata (s_r_v) due to imbalance in strata weighting.
**
**********************************

clear
set more off

*Data created by MergeData.do, which merges treatment assignment to voter file and removes personally identifying information
use SecretBallotFieldExperiment-public.dta, clear

*These are population figures among sampled individuals prior to kicking out those who fail address matching.
*We include these #'s because we want to know relative contribution of each strata to overall electorate even
*though we undersampled strata 3
*Summarize sampled persons by strata and whether or not passed NCOA Address Check 1 (October 2010)
 tab s_r_v badaddress, mis
 tab s_r_v badaddress, row
 table s_r_v if badaddress==0, c(mean voted_10g)

/******************************************************
*
* Sample Restrictions
*
******************************************************/

*Limit to cases that only passed ncoa check 1 in October 2010 (all strata 1, all strata 2, and a 
*sample of strata 3 were checked).
  keep if badaddress == 0

/******************************************************
*
* Mean deviate age/etc.
*
******************************************************/
  
*Mean deviate and unit change age and age squared.
qui summ age
gen age_md = age -`r(mean)'
label variable age_md "Age (mean-deviated)"
gen age_sq_md = age_sq/100
qui summ age_sq_md
replace age_sq_md = age_sq_md - `r(mean)'
label variable age_sq_md "Age-Squared (in hundreds, mean-deviated)"

/******************************************************
*
* Labels
*
******************************************************/

*Label some things.
label variable sampled_strata_1 "Strata 1: Af 04G NV"
label variable sampled_strata_2 "Strata 2: Bf 04G NV"
forvalues j = 1/8 {
  gen treat_`j' = (treatment == `j')
}
label variable treat_1 "Treatment: SOS Short (Placebo)"
label variable treat_2 "Treatment: SOS Control (Placebo)"
label variable treat_3 "Treatment: Generic Civic Duty"
label variable treat_4 "Treatment: SOS Civic Duty"
label variable treat_5 "Treatment: SOS Secrecy 1 (Anonymity)"
label variable treat_6 "Treatment: SOS Secrecy 2 (No Intimidation)"
label variable treat_7 "Treatment: SOS Secrecy Combined"
label variable treat_8 "Control Group"
order treat_8 treat_5 treat_6 treat_7 treat_1 treat_2 treat_4 treat_3

*Excluded category is address match control: the set of addresses we ran through the
*US Postal Service National Change of Address database and returned the same valid
*address flags as we used to filter our treatment letter cases.
label variable i_grp_addr_1 "Number in Household: 1"
label variable i_grp_addr_2 "Number in Household: 2"
label variable i_grp_addr_3 "Number in Household: 3"
label variable i_grp_addr_4 "Number in Household: 4"

drop sex_1
label variable sex_2 "Sex: Male"
label variable sex_3 "Sex: Unlisted"

label variable v_pres_general_04 "Voted 2004" 
label variable v_cong_general_06 "Voted 2006" 
label variable v_pres_general_08 "Voted 2008" 
label variable voted_10g "Voted 2010"

label variable age "Age"

label define longstratalabel 1 "Recently Registered Non-Voters" 2 "Longstanding Registered Non-Voters" 3 "Ever Voters"
label values s_r_v longstratalabel

/******************************************************
*
* Additional Variables
*
******************************************************/

*For pooled Secrecy versus Placebo
gen anysecrecytreatment = treatment > 4 & treatment < 8
label variable anysecrecytreatment "Any Secrecy Treatment"
tab treatment anysecrecytreatment

gen sosplacebotreatments=(treatment==1) | (treatment==2)
label variable sosplacebotreatments "SOS Placebo Treatments"
tab treatment sosplacebotreatments

**Unreturned mail definition: returnedmail == 0 and passed ncoa check 2.
gen unreturnedmail = (returnedmail == 0 & badaddress_v2 == 0)

/******************************************************
*
* Table A2, Summary Stats by Strata, Geocoded/Precinct Variables.
*
******************************************************/

local sumstatsvars v_cong_general_06 v_pres_general_04 v_pres_general_08 age sex_2 sex_3 dem rep i_grp_addr_1-i_grp_addr_4 town*_block

*Summary statistics, all treatments by strata and then by treatment.
forvalues strat = 1/3 {

  *for strata 1, replace, for all others, append
  if (`strat' == 1) {
    local repl "replace"
  } 
  else {
    local repl "append"
  }

  *generate appropriate test string for mlogit
  if (`strat' == 1 | `strat' ==2) {
    local teststring age sex_2 sex_3 dem rep i_grp_addr_1 i_grp_addr_2 i_grp_addr_3 i_grp_addr_4 town1_block town2_block town3_block town4_block town5_block town6_block 
  } 
  else {
    local teststring v_cong_general_06 v_pres_general_04 v_pres_general_08 age sex_2 sex_3 dem rep i_grp_addr_1 i_grp_addr_2 i_grp_addr_3 i_grp_addr_4 town1_block town2_block town3_block town4_block town5_block town6_block 
  }

  preserve
  qui keep if s_r_v == `strat'

  *(Quietly) Run multinomial logit to perform block test of whether coviariates explain assignment  
  *qui mlogit treatment `teststring'
  mlogit treatment `teststring'
  test `teststring'

  qui gen chi2=e(chi2)
  qui gen df=e(df_m)
  qui gen pvaluechi2=chi2(e(chi2),e(df_m))
  di chi2(e(chi2),e(df_m))
  
  local collabel : label (s_r_v) `strat'
  
  outsum `sumstatsvars' chi2 df pvaluechi2 using logs\TableA2_StrataOverallMeans, bracket ctitle("`collabel'") `repl'
  restore
}
stop
/******************************************************
*
* Table A3, Detailed Summary Stats by Strata and Treatment
*
******************************************************/

*Exclude Census and precinct variables.
local sumstatsvars v_cong_general_06 v_pres_general_04 v_pres_general_08 age sex_2 sex_3 dem rep i_grp_addr_1-i_grp_addr_4 town*_block

forvalues strat = 1/3 {
 foreach trt in 8 5 6 7 1 2 4 3 { 

  *for treatment 8, replace, for all others, append
  if (`trt' == 8) {
      local repl "replace"
    } 
    else {
      local repl "append"
    }
  
  local collabel : variable label treat_`trt'
  
  preserve
  qui keep if s_r_v == `strat' & treatment == `trt'
  outsum `sumstatsvars' using logs\TableA3_BalanceStats_Strata`strat', bracket ctitle("`collabel'") `repl'
  restore
  
  }
}

* Add in p-value on F-test from regressions predicting each covariate with treatment indicators.
preserve
forvalues strat = 1/3 {
  di "Strata `strat'."
  foreach var of varlist `sumstatsvars' {
    if (`strat' == 1) gen `var'_true = `var'
    qui replace `var' = `var'_true
    qui summ `var' if treatment != . & s_r_v == `strat'
    if (`r(Var)' == 0) {
      qui replace `var' = -99
    }
    else {
      qui reg `var' treat_* if treatment != . & s_r_v == `strat'
      local fp = 1 - F(`e(df_m)',`e(df_r)',`e(F)')
      di " F-test p-value for covariate `var': " `fp'
      qui replace `var' = `fp'
    }
  }
  outsum `sumstatsvars' using logs\TableA3_BalanceStats_Strata`strat', bracket ctitle("F-test p-value") nonobs append
}
restore

/******************************************************
*
* Table 1, Counts and Turnout by Strata and Treatment
*
******************************************************/

file open myfile using "logs\Table1_CountsAndTurnoutByTreatmentByStrata.csv", write replace
file write myfile "Treatment,Recently Registered Non-Voters,Longstanding Registered Non-Voters,Ever Voters" _n

file write myfile _n
file write myfile "Original Sample" _n

foreach treat in 8 5 6 7 1 2 4 3  {
  local rowlabel : variable label treat_`treat'
  local row "`rowlabel'"
  local sdrow ""
  local countrow ""
  forvalues strat = 1/3 {
    qui proportion voted_10g if treatment == `treat' & s_r_v == `strat'
    local mn = [voted_10g]_b[1]
    local se = sqrt([voted_10g]_b[1]*(1-[voted_10g]_b[1])/(e(N)-1))
    local row = "`row'" + "," + "`mn'"
    local sdrow = "`sdrow'" + "," + "`se'"
    qui count if s_r_v == `strat' & treatment == `treat'
    local countrow = "`countrow',`r(N)'"
  }
  di "`row'"
  di "`sdrow'"
  di "`countrow'"
  file write myfile "`row'" _n
  file write myfile "`sdrow'" _n
  file write myfile "`countrow'" _n
}
di "Proportion voting in anysecrecy treatment."
proportion voted_10g if anysecrecytreatment == 1
forvalues strat = 1/3 {
  proportion voted_10g if anysecrecytreatment == 1 & s_r_v == `strat'
}


*Difference of means tests by strata: each secrecy treatment compared to control, and
*anysecrecy versus sosplacebo.
qui gen tmp_anycompare = .
qui replace tmp_anycompare = 1 if anysecrecytreatment == 1
qui replace tmp_anycompare = 2 if sosplacebotreatments == 1
qui gen tmp_secrcompare = .
forvalues strat = 1/3 {
  local labl : variable label sampled_strata_`strat'
  di _n "`labl'"
  *Secrecy interventions relative to control.
  foreach treat in 5 6 7 {
    local treatlabel : variable label treat_`treat'
    qui replace tmp_secrcompare = .
    qui replace tmp_secrcompare = 1 if treatment == `treat'
    qui replace tmp_secrcompare = 2 if treatment == 8
    qui prtest voted_10g if s_r_v == `strat', by(tmp_secrcompare)
    di " P-value on diff of means `treatlabel' v control " 2*(1-normal(abs(`r(z)'))) "."
  }
  *Secrecy interventions relative to sos placebo.
  qui prtest voted_10g if s_r_v == `strat', by(tmp_anycompare)
  di " P-value on diff of means anysecrecy v sos placebo " 2*(1-normal(abs(`r(z)'))) "."
}
qui drop tmp_*

file write myfile _n
file write myfile "Mail Not Returned and Good Address Post-Treatment" _n

foreach treat in 5 6 7 1 2 4 3 {
  local rowlabel : variable label treat_`treat'
  local row "`rowlabel'"
  local sdrow ""
  local countrow ""
  forvalues strat = 1/3 {
    qui proportion voted_10g if treatment == `treat' & s_r_v == `strat' & returnedmail == 0 & badaddress_v2 == 0
    local mn = [voted_10g]_b[1]
    local se = sqrt([voted_10g]_b[1]*(1-[voted_10g]_b[1])/(e(N)-1))
    local row = "`row'" + "," + "`mn'"
    local sdrow = "`sdrow'" + "," + "`se'"
    qui count if s_r_v == `strat' & treatment == `treat' & returnedmail == 0 & badaddress_v2 == 0
    local countrow = "`countrow',`r(N)'"
  }
  di "`row'"
  di "`sdrow'"
  di "`countrow'"
  file write myfile "`row'" _n
  file write myfile "`sdrow'" _n
  file write myfile "`countrow'" _n
}
file close myfile

/******************************************************
*
* Table 2, OLS Turnout by Strata and Treatment
* Table A4, Full results of OLS Turnout by Strata and Treatment
*
******************************************************/

*Summary treatment effect across interventions.
gen anyletter = (treatment > 0 & treatment < 8)
forvalues i=1/3 {
  qui reg voted_10g anyletter if s_r_v == `i'
  local collabel : label (s_r_v) `i'
  di "`collabel': " _b[anyletter] " (" _se[anyletter] ")"
}
*Test of proportions.
forvalues i=1/3 {
  local collabel : label (s_r_v) `i'
  di _n "`collabel': "
  prtest voted_10g if s_r_v == `i', by(anyletter)
}

*First three columns are base model, treatments versus control
forvalues i=1/3 {

  local collabel : label (s_r_v) `i'
  di _n "+++++ `collabel' +++++" _n
  
  local repl "append"
  if (`i' == 1) {
    local repl "replace"
  } 
  
  *No covariates.
  regress voted_10g treat_5-treat_3 if s_r_v == `i', robust
  testparm treat_5-treat_7
  local secr = `r(p)'
  testparm treat_1 treat_2
  local sos = `r(p)'
  lincom treat_5 + treat_6 - treat_7
  test treat_1=treat_2
  *Test average of secrecy interventions against SOS civic duty.
  lincom (treat_5 + treat_6 + treat_7)/3 - treat_4
  *First table does not include the covars.
  outreg treat_5-treat_3 using "logs\Table2_OLSTreatmentEffects.out", se ctitle("`collabel'") addstat("F-Test p-value on three Secrecy Treatments",`secr',"F-Test p-value on two SOS Placebos",`sos',"Covariates included?",0) addnote("Full results with covariates in Table A2") bracket adec(6) rdec(6) 3aster `repl'
  *Second table includes everything in model.
  outreg using "logs\TableA4_OLSTreatmentEffects.out", se ctitle("`collabel'") addstat("F-Test p-value on three Secrecy Treatments",`secr',"F-Test p-value on two SOS Placebos",`sos') bracket adec(6) rdec(6) 3aster `repl'
    
  *Individual covariates.
  regress voted_10g treat_5-treat_3 v_cong_general_06 v_pres_general_04 v_pres_general_08 age*md sex_* dem rep i_grp_addr_1 - i_grp_addr_4 town*_block if s_r_v == `i', robust

  *Effect of SOS Civic Duty relative to SOS placebo.
  lincom treat_1 - treat_4
  *Test that Secrecy 1, Secrecy 2, and Secrecy Combined all equal zero.
  testparm treat_5-treat_7
  local secr = `r(p)'
  *Test that SOS Placebo short and long equal zero.
  testparm treat_1 treat_2
  local sos = `r(p)'
  *Test dose response effect that Secrecy 1 plus Secrecy 2 = Secrecy Combined.
  lincom treat_5 + treat_6 - treat_7
  test treat_1=treat_2
  *First table does not include the covars.
  outreg treat_5-treat_3 using "logs\Table2_OLSTreatmentEffects.out", se ctitle("`collabel'") addstat("F-Test p-value on three Secrecy Treatments",`secr',"F-Test p-value on two SOS Placebos",`sos',"Covariates included?",1) bracket adec(6) rdec(6) 3aster append
  *Second table includes everything in model.
  outreg using "logs\TableA4_OLSTreatmentEffects.out", se ctitle("`collabel'") addstat("F-Test p-value on three Secrecy Treatments",`secr',"F-Test p-value on two SOS Placebos",`sos') bracket adec(6) rdec(6) 3aster append

}

*Next three columns are pooled any secrecy versus placebo, ignoring control and other treatments
forvalues i=1/3 {

  local collabel : label (s_r_v) `i'
  di _n "+++++ `collabel' +++++" _n

  *No covariates.
  regress voted_10g anysecrecytreatment if s_r_v == `i' & (anysecrecytreatment==1 | sosplacebotreatments==1), robust

    testparm anysecrecytreatment
    local secr = `r(p)'
  *First table does not include the covars.
  outreg anysecrecytreatment using "logs\Table2_OLSTreatmentEffects.out", se ctitle("`collabel', Pooled Secrecy vs. Placebo") addstat("F-Test p-value on three Secrecy Treatments",`secr',"Covariates included?",0) bracket adec(6) rdec(6) 3aster append
  *Second table includes everything in model.
  outreg using "logs\TableA4_OLSTreatmentEffects.out", se ctitle("`collabel', Pooled Secrecy vs. Placebo") addstat("F-Test p-value on three Secrecy Treatments",`secr') bracket adec(6) rdec(6) 3aster append

  *Individual covariates.
  regress voted_10g anysecrecytreatment v_cong_general_06 v_pres_general_04 v_pres_general_08 age*md sex_* dem rep i_grp_addr_1 - i_grp_addr_4 town*_block if s_r_v == `i' & (anysecrecytreatment==1 | sosplacebotreatments==1), robust

    testparm anysecrecytreatment
    local secr = `r(p)'
  *First table does not include the covars.
  outreg anysecrecytreatment using "logs\Table2_OLSTreatmentEffects.out", se ctitle("`collabel', Pooled Secrecy vs. Placebo") addstat("F-Test p-value on three Secrecy Treatments",`secr',"Covariates included?",1) bracket adec(6) rdec(6) 3aster append
  *Second table includes everything in model.
  outreg using "logs\TableA4_OLSTreatmentEffects.out", se ctitle("`collabel', Pooled Secrecy vs. Placebo") addstat("F-Test p-value on three Secrecy Treatments",`secr') bracket adec(6) rdec(6) 3aster append

}

