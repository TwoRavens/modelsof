clear
capture log close
set mem 200m
set matsize 800
set more off 

cd "C:\Users\Andreea\Documents\RESEARCH\PROJECTS\CLIMATE CHANGE (WAR)\data"


* ******************************************************************** *
*   Date:           2009/09/23                                                                    *
*   Purpose:        replicate tables in "The Effect of War on 
*			   the Environment" by Reuveny, Mihalache-O'Keef, and Li
* ******************************************************************** *

use FOREST_master.dta, clear
sort cow year
tsset cow year, yearly

*----------------*
*   Table III    *
*----------------*

* Model D1: any PRIO, all countries
reg deforest forestlog dem  anyPRIO rgdpl rgdplsq openc popdense, robust 

* Model D2: any_home any_away, all countries
reg deforest forestlog dem  any_home any_away  rgdpl rgdplsq openc popdense, robust 

* Model D3: any PRIO, LDCs only
reg deforest forestlog dem anyPRIO rgdpl rgdplsq openc popdense if oecd==0, robust 

* Model D4: any_home any_away, LDCs only
reg deforest forestlog dem  any_home any_away  rgdpl rgdplsq openc popdense if oecd==0, robust 

* Model D5: any PRIO, DCs only
reg deforest forestlog dem anyPRIO rgdpl rgdplsq openc popdense if oecd==1, robust 

* Model D6: any_home any_away, DCs only
reg deforest forestlog dem  any_home any_away  rgdpl rgdplsq openc popdense if oecd==1, robust 


*----------------*
*   Table II-A   *
*----------------*

* Model D1A: war PRIO, all countries
reg deforest forestlog dem warPRIO rgdpl rgdplsq openc popdense, robust 

* Model D2A: any_home3 any_away3, all countries
reg deforest forestlog dem  any_home3 any_away3  rgdpl rgdplsq openc popdense, robust 

* Model D3A: war PRIO, LDCs only
reg deforest forestlog dem warPRIO rgdpl rgdplsq openc popdense if oecd==0, robust 

* Model D4A: any_home3 any_away3, LDCs only
reg deforest forestlog dem  any_home3 any_away3  rgdpl rgdplsq openc popdense if oecd==0, robust 


*----------------*
*   Table VI-A   *
*----------------*

* Model D1K: any PRIO, all countries
reg deforest forestlog dem  anyPRIO rgdpl rgdplsq rgdplcb openc popdense, robust 

* Model D2K: any_home any_away, all countries
reg deforest forestlog dem  any_home any_away  rgdpl rgdplsq rgdplcb openc popdense, robust 

* Model D3K: any PRIO, LDCs only
reg deforest forestlog dem anyPRIO rgdpl rgdplsq rgdplcb openc popdense if oecd==0, robust 

* Model D4K: any_home any_away, LDCs only
reg deforest forestlog dem  any_home any_away  rgdpl rgdplsq rgdplcb openc popdense if oecd==0, robust 


*----------------*
*   Table X-A    *
*----------------*

* Model D1I: any PRIO, all countries
reg deforest forestlog dem  anyPRIO rgdpl rgdplsq gdpforest openc popdense, robust 

* Model D2I: any_home any_away, all countries
reg deforest forestlog dem  any_home any_away  rgdpl rgdplsq gdpforest openc popdense, robust 

* Model D3I: any PRIO, LDCs only
reg deforest forestlog dem anyPRIO rgdpl rgdplsq gdpforest openc popdense if oecd==0, robust 

* Model D4I: any_home any_away, LDCs only
reg deforest forestlog dem  any_home any_away  rgdpl rgdplsq gdpforest openc popdense if oecd==0, robust 


*----------------*
*   Table XI-A   *
*----------------*

* ALL CONFLICTS
ivprobit anyPRIO logrgdpl logpoptot popgrow lmtnest openc ncontig instab dem ethfrac relfrac fossilfuelcons   fertilizercons  electrcons (deforest = rgdpl popdense openc forestlog rgdplsq dem ), first twostep

* CONFLICTS AT HOME
ivprobit any_home logrgdpl logpoptot popgrow lmtnest openc ncontig instab dem ethfrac relfrac fossilfuelcons   fertilizercons  electrcons (deforest = rgdpl popdense openc forestlog rgdplsq dem ), first twostep

* CONFLICTS ABROAD
ivprobit any_away logrgdpl logpoptot popgrow lmtnest openc ncontig instab dem ethfrac relfrac fossilfuelcons   fertilizercons  electrcons (deforest = rgdpl popdense openc forestlog rgdplsq dem ), first twostep



