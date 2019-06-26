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

use CO2_master.dta, clear
sort cow year
tsset cow year, yearly

*----------------*
*   Table II     *
*----------------*

* model C1: any prio, all countries
areg co2lead dem anyPRIO rgdpl rgdplsq openc popdense  co2  year , robust absorb(cow)

* model C2: any home any away, all countries
areg co2lead dem  any_home any_away rgdpl rgdplsq openc popdense  co2 year , robust absorb(cow)

* model C3: any prio, LDCs only
areg co2lead dem  anyPRIO rgdpl rgdplsq openc popdense  co2  year if oecd==0, robust absorb(cow)

* model C4: any home any away, LCDs only
areg co2lead dem  any_home any_away rgdpl rgdplsq openc popdense  co2 year if oecd==0, robust absorb(cow)

* model C5: any prio, DCs only
areg co2lead dem  anyPRIO rgdpl rgdplsq openc popdense  co2  year if oecd==1, robust absorb(cow)

* model C6: any home any away, DCs only
areg co2lead dem  any_home any_away rgdpl rgdplsq openc popdense  co2 year if oecd==1, robust absorb(cow)

*----------------*
*   Table I-A    *
*----------------*
* model C1A: war, all countries
areg co2lead dem war rgdpl rgdplsq openc popdense  co2  year , robust absorb(cow)

* model C2A: war home war away, all countries
areg co2lead dem  war_home war_away rgdpl rgdplsq openc popdense  co2 year , robust absorb(cow)

* model C3A: war prio, LDCs only
areg co2lead dem  war rgdpl rgdplsq openc popdense  co2  year if oecd==0, robust absorb(cow)

* model C4A: war home war away, LCDs only
areg co2lead dem  war_home war_away rgdpl rgdplsq openc popdense  co2 year if oecd==0, robust absorb(cow)

* model C5A: war prio, DCs only
areg co2lead dem  war rgdpl rgdplsq openc popdense  co2  year if oecd==1, robust absorb(cow)

* model C6A: war home war away, DCs only
areg co2lead dem  war_home war_away rgdpl rgdplsq openc popdense  co2 year if oecd==1, robust absorb(cow)


*----------------*
*   Table V-A    *
*----------------*
* model C1K: any prio, all countries
areg co2lead dem anyPRIO rgdpl rgdplsq rgdplcb openc popdense  co2  year , robust absorb(cow)

* model C2K: any home any away, all countries
areg co2lead dem  any_home any_away rgdpl rgdplsq rgdplcb openc popdense  co2 year , robust absorb(cow)

* model C3K: any prio, LDCs only
areg co2lead dem  anyPRIO rgdpl rgdplsq rgdplcb openc popdense  co2  year if oecd==0, robust absorb(cow)

* model C4K: any home any away, LCDs only
areg co2lead dem  any_home any_away rgdpl rgdplsq rgdplcb openc popdense  co2 year if oecd==0, robust absorb(cow)

* model C5K: any prio, DCs only
areg co2lead dem  anyPRIO rgdpl rgdplsq rgdplcb openc popdense  co2  year if oecd==1, robust absorb(cow)

* model C6K: any home any away, DCs only
areg co2lead dem  any_home any_away rgdpl rgdplsq rgdplcb openc popdense  co2 year if oecd==1, robust absorb(cow)


*----------------*
*   Table IX-A   *
*----------------*
* model C1N: any prio, all countries
areg co2lead dem anyPRIO rgdpl rgdplsq openc popdense  year , robust absorb(cow)

* model C2N: any home any away, all countries
areg co2lead dem  any_home any_away rgdpl rgdplsq openc popdense  year , robust absorb(cow)

* model C3N: any prio, LDCs only
areg co2lead dem  anyPRIO rgdpl rgdplsq openc popdense  year if oecd==0, robust absorb(cow)

* model C4N: any home any away, LCDs only
areg co2lead dem  any_home any_away rgdpl rgdplsq openc popdense  year if oecd==0, robust absorb(cow)

* model C5N: any prio, DCs only
areg co2lead dem  anyPRIO rgdpl rgdplsq openc popdense  year if oecd==1, robust absorb(cow)

* model C6N: any home any away, DCs only
areg co2lead dem  any_home any_away rgdpl rgdplsq openc popdense  year if oecd==1, robust absorb(cow)

