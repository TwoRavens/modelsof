set more off
set matsize 1000

log using "replication_hla_app_tables.log", replace

**************************************************************
*** Table A2: Explaining HLA Heterozygosity: Ethnic Sample ***
**************************************************************

use "\hla_ethnic_web.dta", clear

*Col. 1
reg ln_het ln_atd, rob

*Col. 2
reg ln_het ln_atd md, rob

*Col. 3
reg ln_het ln_anim, rob

*Col. 4
reg ln_het ln_anim md, rob



   /*********************/
  /*** Tables A3-A12 ***/
 /*********************/

use "\hla_country_web.dta", clear

local cont "europe africa asia americas"
local base "ln_le60!=. & ln_hla_het!=. & ln_frac!=. & ln_abslat!=. & ln_arable!=. & ln_suitavg!=. & aa_ln_atd!=."
local bc "ln_frac aa_ln_atd ln_arable ln_suitavg ln_abslat"

************************************
*** Table A3: Correlation Matrix ***
************************************

pwcorr ln_hla_het aa_ln_atd aa_lanim aa_lpd1 aa_mdist if `base', obs


****************************************************************************
*** Table A4: Interaction between Years since NR and Domesticate Animals ***
****************************************************************************
local es "aa_ln_atd!=. & aa_lanim!=."
gen ag_anim = aa_ln_atd*aa_lanim

*Col. 1, years of agriculture
reg ln_hla_het aa_ln_atd  if `es', rob

*Col. 2, domesticate animals
reg ln_hla_het aa_lanim  if `es', rob

*Col. 3, interaction
reg ln_hla_het aa_ln_atd aa_lanim ag_anim if `es', rob

*Col. 4, interaction controlling for migratory distance
reg ln_hla_het aa_ln_atd aa_lanim ag_anim aa_mdist if `es', rob


**************************************************************************************
*** Table A5: Interaction between Early Population Density and Domesticate Animals ***
**************************************************************************************
local es "aa_lpd1!=. & aa_lanim!=."
gen pd_anim = aa_lpd1*aa_lanim

*Col. 1, years of agriculture
reg ln_hla_het aa_lpd1  if `es', rob

*Col. 2, domesticate animals
reg ln_hla_het aa_lanim  if `es', rob

*Col. 3, interaction
reg ln_hla_het aa_lpd1 aa_lanim pd_anim if `es', rob

*Col. 4, interaction controlling for migratory distance
reg ln_hla_het aa_lpd1 aa_lanim pd_anim aa_mdist if `es', rob


************************************
*** Table A6: Summary Statistics ***
************************************
local lvl "frac arable suitavg abslat ypc60 yr_sch1960 pd60 urb60 young"

foreach i of local lvl {
gen `i' = exp(ln_`i')
}

local yr "40 50 60 70 80 90 00 10"
foreach i of local yr {
gen le`i' = exp(ln_le`i')
}

gen mort40 = exp(ln_mort40)



*Dependent variables
sum mort40 le40 le50 le60 le70 le80 le90 le00 le10 if `base'

*Baseline controls
sum frac aa_atd arable suitavg abslat if `base'

*Exogenous omitted variables
sum aa_pdiv malfal tropic desert frac_migrant distcr1000 if `base'

*Endogenous omitted variables
local ov2 "ln_ypc60!=. & ln_yr_sch1960!=. & ln_pd60!=. & ln_urb60!=. & ln_young!=."
sum ypc60 yr_sch1960 pd60 urb60 young if `base' & `ov2'


******************************************************************************
*** Table A7: The effect of HLA heterozygosity after the I.E.T., bivariate ***
******************************************************************************
local yr2 "60 70 80 90 00 10"

foreach i of local yr2 {
reg ln_le`i' ln_hla_het if `base', rob
}


******************************************************************************
*** Table A8: The effect of HLA heterozygosity after the I.E.T., 1940-2010 ***
******************************************************************************
local yr3 "40 50 60 70 80 90 00 10"
local le "ln_le40!=. & ln_le50!=. & ln_le60!=. & ln_le70!=. & ln_le80!=. & ln_le90!=. & ln_le00!=. & ln_le10!=."

foreach i of local yr {
reg ln_le`i' ln_hla_het `bc' `cont' if `base' & `le', rob
}


**************************************************************************************************************************
***  Table A9:  Replacing within-ethnicity HLA heterozygosity, with country-level, mixed-ethnicity HLA heterozygosity  ***
**************************************************************************************************************************

** Mortality from infectious disease in 1940
*Col. 1
reg ln_mort40 ln_mix_het if `base', rob

*Col. 2
reg ln_mort40 ln_mix_het `bc' `cont' if `base', rob

** Life Expectancy in 1940
*Col. 3
reg ln_le40 ln_mix_het if `base', rob

*Col. 4
reg ln_le40 ln_mix_het `bc' `cont' if `base', rob

** Life Expectancy in 1960
*Col. 5
reg ln_le60 ln_mix_het if `base', rob

*Col. 6
reg ln_le60 ln_mix_het `bc' `cont' if `base', rob



*****************************************************************************************************************
***  Table A10:  Replacing within-ethnicity HLA heterozygosity, with its ratio to genome-wide heterozygosity  ***
*****************************************************************************************************************
gen ratio = hla_het/aa_pdiv

** Mortality from infectious disease in 1940
*Col. 1
reg ln_mort40 ratio if `base', rob

*Col. 2
reg ln_mort40 ratio `bc' `cont' if `base', rob

** Life Expectancy in 1940
*Col. 3
reg ln_le40 ratio if `base', rob

*Col. 4
reg ln_le40 ratio `bc' `cont' if `base', rob

** Life Expectancy in 1960
*Col. 5
reg ln_le60 ratio if `base', rob

*Col. 6
reg ln_le60 ratio `bc' `cont' if `base', rob



************************************************************
*** Table A11: Controlling for the diffusion of medicine ***
************************************************************

*Col. 1, full sample, including genetic dist. to USA
reg ln_le60 ln_hla_het fstdistwtd_usa `bc' `cont' if `base', rob

*Col. 2, excluding OECD countries
reg ln_le60 ln_hla_het `bc' `cont' if `base' & oecd!=1, rob

*Col. 3, excluding OECD countries and including genetic dist.
reg ln_le60 ln_hla_het fstdistwtd_usa `bc' `cont' if `base' & oecd!=1, rob



******************************************************************************************************
*** Table A12: 2SLS, using migratory distance and its square as instruments for HLA heterozygosity ***
******************************************************************************************************


*Col. 1, base
ivreg2 ln_le60 (ln_hla_het = aa_mdist aa_mdist_sqr) `bc' `cont' if `base', small first rob

*Col. 2, controlling for income
ivreg2 ln_le60 (ln_hla_het = aa_mdist aa_mdist_sqr) ln_ypc60 `bc' `cont' if `base', small first rob


log close
