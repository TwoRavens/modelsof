use ${dir_rawdata}\\usa_all.dta, clear
levelsof category, clean
global list `r(levels)'

foreach pscode3 in $list {
preserve
keep if category==`pscode3'
save ${dir_rawdata}\\usa_all_cat`pscode3'.dta, replace
restore
}


***create at the sector L1 levels

use ${dir_rawdata}\\usa_all.dta, clear
gen pscode=int(category/100)
destring pscode, replace force
replace pscode= pscode * 100

levelsof pscode, clean
global list `r(levels)'

foreach pscode in $list {
preserve
keep if pscode==`pscode'
save ${dir_rawdata}\\usa_all_sec`pscode'.dta, replace
restore
}

