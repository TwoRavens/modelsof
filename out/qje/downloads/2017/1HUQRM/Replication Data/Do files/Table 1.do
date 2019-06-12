
use T1_C1, clear
gen post_strikeswitch = post*strikeswitch
areg sit post post_strikeswitch, r a(id)

use T1_C2, clear
gen post_strike = post*strike
areg sit post post_strike, r a(id)

use T1_C3, clear
gen post_str_12 = post*str_12
areg sit post post_str_12, r a(id)

use T1_C4, clear
gen post_str_15 = post*str_15
areg sit post post_str_15, r a(id)

use T1_C5, clear
gen post_str_2 = post*str_2
areg sit post post_str_2, r a(id)
