*version 8.0 

clear
capture log close
set mem 200m
set matsize 800
set more off 

cd "C:\Users\Andreea\Documents\RESEARCH\PROJECTS\CLIMATE CHANGE (WAR)\data"

* ******************************************************************** *
*   Date:           2009/09/23                                                                    *
*   Purpose:        replicate tables in "The Effect of War on the Environment" by Reuveny, Mihalache-O'Keef, and Li
* ******************************************************************** *

use STRESS_master.dta, clear
sort cow year
tsset cow year, yearly


*--------------*
*   Table V    *
*--------------*

* model E1: any prio, all countries
reg stresslead polity2 anyPRIO rgdpl rgdplsq openc popdense  , robust 

* model E2: any home any away, all countries
reg stresslead polity2  any_home any_away rgdpl rgdplsq openc popdense  , robust 

* model E3: any prio, LDCs only
reg stresslead polity2  anyPRIO rgdpl rgdplsq openc popdense  if oecd==0, robust 

* model E4: any home any away, LCDs only
reg stresslead polity2  any_home any_away rgdpl rgdplsq openc popdense  if oecd==0, robust 

* model E5: any prio, DCs only
reg stresslead polity2  anyPRIO rgdpl rgdplsq openc popdense  if oecd==1, robust 

* model E6: any home any away, DCs only
reg stresslead polity2  any_home any_away rgdpl rgdplsq openc popdense  if oecd==1, robust 


*--------------*
*   Table IV-A *
*--------------*

* model E1A: any prio, all countries
reg stresslead polity2 war rgdpl rgdplsq openc popdense  , robust 

* model E2A: any home any away, all countries
reg stresslead polity2  war_home war_away rgdpl rgdplsq openc popdense  , robust 

* model E3A: any prio, LDCs only
reg stresslead polity2  war rgdpl rgdplsq openc popdense  if oecd==0, robust 

* model E4A: any home any away, LCDs only
reg stresslead polity2  war_home war_away rgdpl rgdplsq openc popdense  if oecd==0, robust 

* model E5A: any prio, DCs only
reg stresslead polity2  war rgdpl rgdplsq openc popdense  if oecd==1, robust 

* model E6A: any home any away, DCs only
reg stresslead polity2  war_home war_away rgdpl rgdplsq openc popdense  if oecd==1, robust 


*----------------*
*   Table VIII-A *
*----------------*

* model E1K: any prio, all countries
reg stresslead polity2 anyPRIO rgdpl rgdplsq rgdplcb openc popdense  , robust 

* model E2K: any home any away, all countries
reg stresslead polity2  any_home any_away rgdpl rgdplsq rgdplcb openc popdense  , robust 

* model E3K: any prio, LDCs only
reg stresslead polity2  anyPRIO rgdpl rgdplsq rgdplcb openc popdense  if oecd==0, robust 

* model E4K: any home any away, LCDs only
reg stresslead polity2  any_home any_away rgdpl rgdplsq rgdplcb openc popdense  if oecd==0, robust 

* model E5K: any prio, DCs only
reg stresslead polity2  anyPRIO rgdpl rgdplsq rgdplcb openc popdense  if oecd==1, robust 

* model E6K: any home any away, DCs only
reg stresslead polity2  any_home any_away rgdpl rgdplsq rgdplcb openc popdense  if oecd==1, robust 


*----------------*
*   Table XI-A *
*----------------*

* ALL CONFLICTS
ivprobit f.anyPRIO anyPRIO logrgdpl logpoptotal popgrowth lmtnest openc ncontig instab polity2 ethfrac relfrac fossilfuelcons   fertilizercons  electrcons (stress = popdense rgdpl rgdplsq openc polity2 ) if year<2005, first twostep

* CONFLICTS AT HOME
ivprobit f.any_home any_home logrgdpl logpoptotal popgrowth lmtnest openc ncontig instab polity2 ethfrac relfrac fossilfuelcons   fertilizercons  electrcons (stress = popdense rgdpl rgdplsq openc polity2 ) if year<2005, first twostep

* CONFLICTS ABROAD
ivprobit f.any_away any_away logrgdpl logpoptotal popgrowth lmtnest openc ncontig instab polity2 ethfrac relfrac fossilfuelcons   fertilizercons  electrcons (stress = popdense rgdpl rgdplsq openc polity2 ) if year<2005, first twostep


