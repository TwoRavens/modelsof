***Code to Reproduce Table 1***
clear

use stata_exogen.dta

local controls ev_reb_any ra_agro2 ra_occupation_duration ra_oblast 

forvalues i = 50(50)150 {

dtest margin ev_deport `controls' if ev_deport > 0, xbar(0) h(`i') p(1) kernel(epan2)

}
