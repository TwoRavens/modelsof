insheet using ".\data\simulation_country_list.csv", clear
ren v1 cnum
ren v2 ccode
gen matnum=_n
sort matnum
local new = _N + 1
set obs `new'
replace ccode="ROW" if ccode==""
replace matnum=matnum[_n-1]+1 if ccode=="ROW"
sort matnum
save ".\data\templist", replace

insheet using ".\simulation_output\frictions_openness.dat", clear
ren v1 wedges
ren v2 openness
drop v3
gen matnum=_n

merge 1:1 matnum using ".\data\templist", keep(3) nogenerate

**Figure C1: Changes in Openness and Trade Frictions
scatter openness wedges, mlabel(ccode) mlabposition(0) msymbol(none) xtitle("Log Ratio of Trade Frictions") ytitle("Log Ratio of Openness") plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin())
graph export ".\figures_and_tables\openness_frictions.pdf", replace
