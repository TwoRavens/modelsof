
use T2_C1, clear
gen post_strikeswitch = post*strikeswitch
areg nonmode post post_strikeswitch, r a(id)

use T2_C2, clear
gen post_strike = post*strike
areg nonmode post post_strike, r a(id)

use T2_C3, clear
gen post_str_12 = post*str_12
areg nonmode post post_str_12, r a(id)

use T2_C4, clear
gen post_str_15 = post*str_15
areg nonmode post post_str_15, r a(id)

use T2_C5, clear
gen post_str_2 = post*str_2
areg nonmode post post_str_2, r a(id)
