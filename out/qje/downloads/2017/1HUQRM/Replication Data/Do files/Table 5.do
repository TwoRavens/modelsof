
use T5.dta, clear
foreach var of varlist s* {
gen post_`var' = post * `var'
}
areg nonmode post post_strikeswitch, r a(id)
areg nonmode post post_strike, r a(id)
areg nonmode post post_str_12, r a(id)
areg nonmode post post_str_15, r a(id)
areg nonmode post post_str_2, r a(id)
