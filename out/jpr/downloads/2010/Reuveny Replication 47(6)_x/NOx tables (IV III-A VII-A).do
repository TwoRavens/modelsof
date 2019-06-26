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

use NOx_master.dta, clear
sort cow year
tsset cow year, yearly

*----------------*
*   Table IV     *
*----------------*

* model N1: any prio, all countries
reg noxpcloglead dem anyPRIO rgdpl rgdplsq openc popdense   , robust 

* model N2: any home any away, all countries
reg noxpcloglead dem  any_home any_away rgdpl rgdplsq openc popdense , robust 

* model N3: any prio, LDCs only
reg noxpcloglead dem  anyPRIO rgdpl rgdplsq openc popdense   if oecd==0, robust 

* model N4: any home any away, LCDs only
reg noxpcloglead dem  any_home any_away rgdpl rgdplsq openc popdense   if oecd==0, robust 

* model N5: any prio, DCs only
reg noxpcloglead dem  anyPRIO rgdpl rgdplsq openc popdense   if oecd==1, robust 

* model N6: any home any away, DCs only
reg noxpcloglead dem  any_home any_away rgdpl rgdplsq openc popdense   if oecd==1, robust 


*----------------*
*   Table III-A  *
*----------------*

* model N1A: any prio, all countries
reg noxpcloglead dem war rgdpl rgdplsq openc popdense   , robust 

* model N2A: any home any away, all countries
reg noxpcloglead dem  war_home war_away rgdpl rgdplsq openc popdense  , robust 

* model N3A: any prio, LDCs only
reg noxpcloglead dem  war rgdpl rgdplsq openc popdense   if oecd==0, robust 

* model N4A: any home any away, LCDs only
reg noxpcloglead dem  war_home war_away rgdpl rgdplsq openc popdense   if oecd==0, robust 

* model N5A: any prio, DCs only
reg noxpcloglead dem  war rgdpl rgdplsq openc popdense   if oecd==1, robust 

* model N6A: any home any away, DCs only
reg noxpcloglead dem  war_home war_away rgdpl rgdplsq openc popdense   if oecd==1, robust 


*----------------*
*   Table VII-A  *
*----------------*

* model 1: any prio, all countries
reg noxpcloglead dem anyPRIO rgdpl rgdplsq rgdplcb openc popdense   , robust 

* model 2: any home any away, all countries
reg noxpcloglead dem  any_home any_away rgdpl rgdplsq rgdplcb openc popdense , robust 

* model 3: any prio, LDCs only
reg noxpcloglead dem  anyPRIO rgdpl rgdplsq rgdplcb openc popdense   if oecd==0, robust 

* model 4: any home any away, LCDs only
reg noxpcloglead dem  any_home any_away rgdpl rgdplsq rgdplcb openc popdense   if oecd==0, robust 

* model 5: any prio, DCs only
reg noxpcloglead dem  anyPRIO rgdpl rgdplsq rgdplcb openc popdense   if oecd==1, robust 

* model 6: any home any away, DCs only
reg noxpcloglead dem  any_home any_away rgdpl rgdplsq rgdplcb openc popdense   if oecd==1, robust 
