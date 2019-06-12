* Table 7
* Appendix Table 1
* Appendix Table 2
* Appendix Table 3
* Note:  The code produces a number of extra Tables not reported in the paper

use T7_C1, clear
foreach var of varlist entstrike {
gen post_`var' = post * `var'
gen post_maxdist_`var' = post*maxdist*`var'
gen post_maxdist_ent_`var' = post*maxdist_ent*`var'
gen post_maxdist_exit_`var' = post*maxdist_exit*`var'
gen maxdist_`var' = maxdist* `var'
gen maxdist_ent_`var' = maxdist_ent* `var'
gen maxdist_exit_`var' = maxdist_exit* `var'
areg entmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg exitmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg entmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg exitmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg entmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
areg exitmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
drop post_`var'
}

use T7_C2, clear
foreach var of varlist exitstrike {
gen post_`var' = post * `var'
gen post_maxdist_`var' = post*maxdist*`var'
gen post_maxdist_ent_`var' = post*maxdist_ent*`var'
gen post_maxdist_exit_`var' = post*maxdist_exit*`var'
gen maxdist_`var' = maxdist* `var'
gen maxdist_ent_`var' = maxdist_ent* `var'
gen maxdist_exit_`var' = maxdist_exit* `var'
areg entmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg exitmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg entmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg exitmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg entmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
areg exitmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
drop post_`var'
}
use T7_C3, clear
foreach var of varlist strike {
gen post_`var' = post * `var'
gen post_maxdist_`var' = post*maxdist*`var'
gen post_maxdist_ent_`var' = post*maxdist_ent*`var'
gen post_maxdist_exit_`var' = post*maxdist_exit*`var'
gen maxdist_`var' = maxdist* `var'
gen maxdist_ent_`var' = maxdist_ent* `var'
gen maxdist_exit_`var' = maxdist_exit* `var'
areg entmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg exitmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg entmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg exitmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg entmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
areg exitmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
drop post_`var'
}
use T7_C4, clear
foreach var of varlist str_12 {
gen post_`var' = post * `var'
gen post_maxdist_`var' = post*maxdist*`var'
gen post_maxdist_ent_`var' = post*maxdist_ent*`var'
gen post_maxdist_exit_`var' = post*maxdist_exit*`var'
gen maxdist_`var' = maxdist* `var'
gen maxdist_ent_`var' = maxdist_ent* `var'
gen maxdist_exit_`var' = maxdist_exit* `var'
areg entmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg exitmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg entmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg exitmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg entmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
areg exitmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
drop post_`var'
}
use T7_C5, clear
foreach var of varlist str_15 {
gen post_`var' = post * `var'
gen post_maxdist_`var' = post*maxdist*`var'
gen post_maxdist_ent_`var' = post*maxdist_ent*`var'
gen post_maxdist_exit_`var' = post*maxdist_exit*`var'
gen maxdist_`var' = maxdist* `var'
gen maxdist_ent_`var' = maxdist_ent* `var'
gen maxdist_exit_`var' = maxdist_exit* `var'
areg entmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg exitmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg entmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg exitmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg entmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
areg exitmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
drop post_`var'
}
use T7_C6, clear
foreach var of varlist str_2 {
gen post_`var' = post * `var'
gen post_maxdist_`var' = post*maxdist*`var'
gen post_maxdist_ent_`var' = post*maxdist_ent*`var'
gen post_maxdist_exit_`var' = post*maxdist_exit*`var'
gen maxdist_`var' = maxdist* `var'
gen maxdist_ent_`var' = maxdist_ent* `var'
gen maxdist_exit_`var' = maxdist_exit* `var'
areg entmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg exitmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg entmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg exitmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg entmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
areg exitmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
drop post_`var'
}
use T7_C7, clear
foreach var of varlist strikeswitch {
gen post_`var' = post * `var'
gen post_maxdist_`var' = post*maxdist*`var'
gen post_maxdist_ent_`var' = post*maxdist_ent*`var'
gen post_maxdist_exit_`var' = post*maxdist_exit*`var'
gen maxdist_`var' = maxdist* `var'
gen maxdist_ent_`var' = maxdist_ent* `var'
gen maxdist_exit_`var' = maxdist_exit* `var'
areg entmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg exitmax post post_`var' maxdist post_maxdist post_maxdist_`var', r a(id)
areg entmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg exitmax post post_`var' maxdist_ent post_maxdist_ent post_maxdist_ent_`var', r a(id)
areg entmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
areg exitmax post post_`var' maxdist_exit post_maxdist_exit post_maxdist_exit_`var', r a(id)
drop post_`var'
}
