
use T8.dta, clear
gen post_speed = post*speed
foreach var of varlist strikeswitch strike str_12 str_15 str_2 {
gen post_`var' = post * `var'
gen post_speed_`var' = post*speed*`var'
gen speed_`var' = speed* `var'
areg nonmode post post_`var' speed post_speed post_speed_`var', r a(prestige)
drop post_`var'
}
