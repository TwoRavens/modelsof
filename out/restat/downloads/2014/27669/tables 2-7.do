set more off
set matsize 1000

log using "replication_hla_base_tables.log", replace

use "\hla_country_web.dta", clear

local cont "europe africa asia americas"
local base "ln_le60!=. & ln_hla_het!=. & ln_frac!=. & ln_abslat!=. & ln_arable!=. & ln_suitavg!=. & aa_ln_atd!=."
local bc "ln_frac aa_ln_atd ln_arable ln_suitavg ln_abslat"


***************************************************************
***  Table 2:  Historic Determinants of HLA Heterozygosity  ***
***************************************************************

*Col. 1
reg ln_hla_het aa_ln_atd if aa_mdist!=. & `base' & ln_le60!=., rob

*Col. 2
reg ln_hla_het aa_ln_atd aa_mdist if aa_mdist!=. & ln_le60!=. & `base', rob

*Col. 3
reg ln_hla_het aa_lanim if aa_mdist!=. & `base' & ln_le60!=., rob

*Col. 4
reg ln_hla_het aa_lanim aa_mdist if aa_mdist!=. & `base' & ln_le60!=., rob

*Col. 5
reg ln_hla_het aa_lpd1 if aa_mdist!=. & `base' & ln_le60!=., rob

*Col. 6
reg ln_hla_het aa_lpd1 aa_mdist if aa_mdist!=. & `base' & ln_le60!=., rob


***************************************
***  Table 3:  Premedicinal Health  ***
***************************************

** Mortality from infectious disease in 1940
*Col. 1
reg ln_mort40 ln_hla_het if `base', rob

*Col. 2
reg ln_mort40 ln_hla_het `bc' `cont' if `base', rob

** Life Expectancy in 1940
*Col. 3
reg ln_le40 ln_hla_het if `base', rob

*Col. 4
reg ln_le40 ln_hla_het `bc' `cont' if `base', rob

** Life Expectancy in 1960
*Col. 5
reg ln_le60 ln_hla_het if `base', rob

*Col. 6
reg ln_le60 ln_hla_het `bc' `cont' if `base', rob


*************************************************************
***  Table 4:  Additional Years:  The effect of medicine  ***
*************************************************************
local le "ln_le60!=. & ln_le70!=. & ln_le80!=. & ln_le90!=. & ln_le00!=. & ln_le10!=."

*Col. 1, 1960
reg ln_le60 ln_hla_het `bc' `cont' if `le', rob

*Col. 2, 1970
reg ln_le70 ln_hla_het `bc' `cont' if `le', rob

*Col. 3, 1980
reg ln_le80 ln_hla_het `bc' `cont' if `le', rob

*Col. 4, 1990
reg ln_le90 ln_hla_het `bc' `cont' if `le', rob

*Col. 5, 2000
reg ln_le00 ln_hla_het `bc' `cont' if `le', rob

*Col. 6, 2010
reg ln_le10 ln_hla_het `bc' `cont' if `le', rob


*******************************************
***  Table 5:  Pop. Composition Trunc.  ***
*******************************************
local pop "frac_eur frac_me frac_easia frac_africa frac_am"

*Col. 1, countries with no fraction of population derived from Europe
reg ln_le60 ln_hla_het `bc' `cont' if `base' & frac_eur==0, rob

*Col. 2, countries with part of the population derived from Europe
reg ln_le60 ln_hla_het `bc' `cont' if `base' & frac_eur>0 & frac_eur<1, rob

*Col. 3, countries entirely composed of European populations
reg ln_le60 ln_hla_het `bc' `cont' if `base' & frac_eur==1, rob

*Col. 4, ethnic fixed effects
reg ln_le60 ln_hla_het `pop' `bc' `cont'  if `base', rob


***********************************************
***  Table 6:  Exogenous Omitted Variables  ***
***********************************************
local ov1 "aa_pdiv!=. & malfal!=.  & tropical!=. & pnativ_60!=. & distcr100!=. "

*Col. 1, genetic capital
reg ln_le60 ln_hla_het aa_pdiv `bc' `cont' if `ov1', rob

*Col. 2, environment
reg ln_le60 ln_hla_het malfal tropical desert distcr100 `bc' `cont' if `ov1', rob

*Col. 3, population
reg ln_le60 ln_hla_het frac_migrant `bc' `cont' if `ov1', rob

*Col. 4, all
reg ln_le60 ln_hla_het aa_pdiv malfal tropical desert distcr100 frac_migrant `bc' `cont' if `ov1', rob



************************************************
***  Table 7:  Endogenous Omitted Variables  ***
************************************************
local ov2 "ln_ypc60!=. & ln_yr_sch1960!=. & ln_pd60!=. & ln_urb60!=. & ln_young!=."

*Col. 1, sample adjustment
reg ln_le60 ln_hla_het `bc' `cont' if `ov2', rob

*Col. 2, income
reg ln_le60 ln_hla_het ln_ypc60 `bc' `cont' if `ov2', rob

*Col. 3, education
reg ln_le60 ln_hla_het ln_yr_sch1960 `bc' `cont' if `ov2', rob

*Col. 4, demographics
reg ln_le60 ln_hla_het ln_pd60 ln_urb60 ln_young `bc' `cont' if `ov2', rob

*Col. 5, all
reg ln_le60 ln_hla_het ln_ypc60 ln_yr_sch1960 ln_pd60 ln_urb60 ln_young `bc' `cont' if `ov2', rob


log close
