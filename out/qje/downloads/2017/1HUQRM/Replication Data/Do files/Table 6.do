
use T6_C1, clear
gen post_strikeswitch = post*strikeswitch
areg ln_ post post_strikeswitch, r a(id)

use T6_C2, clear
gen post_strike = post*strike
areg ln_ post post_strike, r a(id)

use T6_C3, clear
gen post_str_12 = post*str_12
areg ln_ post post_str_12, r a(id)

use T6_C4, clear
gen post_str_15 = post*str_15
areg ln_ post post_str_15, r a(id)

use T6_C5, clear
gen post_str_2 = post*str_2
areg ln_ post post_str_2, r a(id)
