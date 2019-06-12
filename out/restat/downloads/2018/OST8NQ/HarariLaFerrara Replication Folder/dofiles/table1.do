*===============================================================================
* set up
*===============================================================================
cap log close

global name = "table1"
local cdate : di %tdCCYY.NN.DD date(c(current_date),"DMY")
log using "${logs}/${name}_`cdate'.log", text replace

*===============================================================================
* Define Globals
*===============================================================================
global x "shared border area_cell elevation_cell rough_cell dis_river_cell use_primary any_mineral ELF"
global weather "SPEI4pg GSmain_ext_SPEI4pg"

*===============================================================================
* summary stats panel
*===============================================================================
use "${data}/geoconflict_main.dta", clear

* sample
drop if l.ANY_EVENT_ACLED  == .

* summary stats
tabstat ANY_EVENT_ACLED BATTLE_ACLED CIVILIAN_ACLED RIOT_ACLED OTHER_REBEL_ACT_ACLED ${weather}, stat(n mean sd) col(stat) 

cap log close
