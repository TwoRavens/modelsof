
use T3_C1, clear
gen post_strikeswitch = post*strikeswitch
areg entmax post post_strikeswitch, r a(id)
use T3_C2, clear
gen post_strike = post*strike
areg entmax post post_strike, r a(id)
use T3_C3, clear
gen post_entstrike = post*entstrike
areg entmax post post_entstrike, r a(id)
use T3_C4, clear
gen post_exitstrike = post*exitstrike
areg entmax post post_exitstrike, r a(id)
use T3_C5, clear
gen post_str_12 = post*str_12
areg entmax post post_str_12, r a(id)
use T3_C6, clear
gen post_str_15 = post*str_15
areg entmax post post_str_15, r a(id)
use T3_C7, clear
gen post_str_2 = post*str_2
areg entmax post post_str_2, r a(id)

use T3_C1, clear
gen post_strikeswitch = post*strikeswitch
areg exitmax post post_strikeswitch, r a(id)
use T3_C2, clear
gen post_strike = post*strike
areg exitmax post post_strike, r a(id)
use T3_C3, clear
gen post_entstrike = post*entstrike
areg exitmax post post_entstrike, r a(id)
use T3_C4, clear
gen post_exitstrike = post*exitstrike
areg exitmax post post_exitstrike, r a(id)
use T3_C5, clear
gen post_str_12 = post*str_12
areg exitmax post post_str_12, r a(id)
use T3_C6, clear
gen post_str_15 = post*str_15
areg exitmax post post_str_15, r a(id)
use T3_C7, clear
gen post_str_2 = post*str_2
areg exitmax post post_str_2, r a(id)
