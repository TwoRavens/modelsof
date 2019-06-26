**************************************************************************************************
*** This do file reproduces the results for 
*** The Rise of Capitalism and the Roots of Anti-American Terrorism
*** Journal of Peace Research Volume 52 Issue 1, January 2015
*** Daniel Meierrieks (University of Freiburg)
*** Tim Krieger (University of Freiburg)
**************************************************************************************************
*** November 2014
**************************************************************************************************

version 11.0
drop _all
clear matrix
set mem 800m
set mat 10000

*******************************************************************************************************************
************* PART 1: Panel Analysis
*******************************************************************************************************************

*** IMPORTANT NOTE: You may have to change the command below to match it to the location where you stored the data
use "C:\Users\Dekanat-1\Desktop\Panel Data.dta", replace
*** Reproduction of Table II
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log l.gov time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log l.statefailure time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log l.gov time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log l.statefailure time*, nolog cluster(id)

*** Reproduction of Table III
*** Cold War Era
keep if year<1990
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
*** Post-Cold War Era
*** IMPORTANT NOTE: You may have to change the command below to match it to the location where you stored the data
use "C:\Users\Dekanat-1\Desktop\Panel Data.dta", replace
keep if year>1989
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)


*******************************************************************************************************************
************* PART 2: Time-Series Analysis
*******************************************************************************************************************

*** IMPORTANT NOTE: You may have to change the command below to match it to the location where you stored the data
use "C:\Users\Dekanat-1\Desktop\Time-Series Data.dta", replace
*** Reproduction of Table IV
arima antiUSincidents_iterate cie_global cie_global_diff dominance power pref_congruence, arima(1,0,0) vce(robust) nolog
arima antiUSincidents_iterate cie_global cie_global_diff dominance power pref_congruence coldwar, arima(1,0,1) vce(robust) nolog
arima antiUSincidents_iterate kof_global kof_diff_global dominance power pref_congruence, arima(1,0,0) vce(robust) nolog
arima antiUSincidents_iterate kof_global kof_diff_global  dominance power pref_congruence coldwar, arima(1,0,1) vce(robust) nolog
arima antiUSincidents_iterate kof_global kof_diff_global dominance power pref_congruence, arima(1,0,0) vce(robust) nolog
arima antiUSincidents_iterate cie_global cie_global_diff kof_global kof_diff_global  dominance power pref_congruence coldwar, arima(1,0,1) vce(robust) nolog

*******************************************************************************************************************
************* PART 3: Online Appendix
*******************************************************************************************************************

*** IMPORTANT NOTE: You may have to change the command below to match it to the location where you stored the data
use "C:\Users\Dekanat-1\Desktop\Panel Data.dta", replace
*** Reproduction of Supplementary Table 1
summ

*** Reproduction of Supplementary Table 2
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.democracy l.dom_milex_pc_log l.energy_cons_pop l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.democracy l.dom_milex_pc_log l.energy_cons_pop l.assis_milexp_log time*, nolog cluster(id)

*** Reproduction of Supplementary Table 3
nbreg antiUSincidents_iterate lag_cie difflag_cie lag_kof difflag_kof l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_cie difflag_cie lag_kof difflag_kof l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id) irr

*** Reproduction of Supplementary Table 4
*** Cold War Era
keep if year<1990
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id) irr
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id) irr
*** Post-Cold War Era
*** IMPORTANT NOTE: You may have to change the command below to match it to the location where you stored the data
use "C:\Users\Dekanat-1\Desktop\Panel Data.dta", replace
keep if year>1989
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id)
nbreg antiUSincidents_iterate lag_cie difflag_cie l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id) irr
nbreg antiUSincidents_iterate lag_kof difflag_kof  l.pop_log distance_log l.gdppc_log l.democracy l.assis_milexp_log time*, nolog cluster(id) irr

*** IMPORTANT NOTE: You may have to change the command below to match it to the location where you stored the data
use "C:\Users\Dekanat-1\Desktop\Time-Series Data.dta", replace
*** Reproduction of Supplementary Table 5
summ

*******************************************************************************************************************
************* End of Do-File
*******************************************************************************************************************
