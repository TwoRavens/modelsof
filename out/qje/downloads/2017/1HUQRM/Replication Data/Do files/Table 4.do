
use T4.dta, clear
foreach var of varlist strikeswitch strike str_12 str_15 str_2 {
reg lastdaymode `var', r
}
