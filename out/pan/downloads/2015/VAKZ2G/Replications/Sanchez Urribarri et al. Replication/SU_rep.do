*** Grant Lebo Replication -- Sanchez Urribarri et al. JOP

* From Supplement *

***********
* Table E.1 *
***********
cd "dir:"
use "dir/SU_Canada_rep.dta"

tsset year
reg d.rights_agenda l.rights_agenda d.support_structure l.support_str d.ideology l.ideology d.docket l.docket d.charter l.charter

use "dir/SU_UK_rep.dta"

tsset year
reg d.rights_ag l.rights_ag d.support l.support d.ideology l.ideology d.human l.human

use "dir/SU_US_rep.dta"
tsset year
reg d.rights l.rights d.support l.support d.ideology l.ideology d.brown l.brown d.mapp l.mapp d.civil l.civil


************
* Table E.2 *
************
use "dir/SU_Canada_rep.dta"
tsset year
dfuller d.rights, reg
arfima d.rights

use "dir/SU_UK_rep.dta"
tsset year
dfuller rights, reg
arfima d.rights

use "dir/SU_US_rep.dta"
tsset year
dfuller rights, reg
arfima d.rights

************
* Table E.3 *
************

* see SU_MC_TBLE3_canada.do
* see SU_MC_TBLE3_UK.do
* see SU_MC_TBLE3_US.do

************
* Table E.4 *
************

* see SU_MC_TBLE4_canada.do
* see SU_MC_TBLE4_UK.do
* see SU_MC_TBLE4_US.do

************
* Table E.5 *
************

* see SU_MC_TBLE5_canada.do
* see SU_MC_TBLE5_UK.do
* see SU_MC_TBLE5_US.do

************
* Table E.6 *
************
use "dir/SU_Canada_rep.dta"
tsset year
arfima d.rights
predict drightsf, fdiff
arfima ideology
predict ideof, fdiff

reg drightsf ideof d.support d.docket d.charter

use "dir/SU_UK_rep.dta"
tsset year
arfima d.rights
predict drightsf, fdiff
arfima ideology
predict ideof, fdiff

reg drightsf ideof d.support d.human

use "dir/SU_US_rep.dta"
tsset year
arfima d.rights
predict drightsf, fdiff
arfima ideology
predict ideof, fdiff

reg drightsf ideof d.support d.brown d.mapp d.civil

