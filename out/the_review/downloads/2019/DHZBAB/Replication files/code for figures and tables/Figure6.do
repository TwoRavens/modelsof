set scheme s1color
use FNIdataset if german==1, clear

* merge with voting data
tempfile mainfile
save `mainfile'
collapse pernum, by(stateicp statefip)
drop pernum

merge 1:1 stateicp using wilson.dta
drop _merge

* make dummy for above median votes for Wilson
sum wilson, det
gen wilsonabmed=(wilson>=r(p50))
replace wilsonabmed=. if wilson==.

* merge with main dataset based on birthplace
ren statefip bpl
drop if bpl==.
merge 1:m bpl using `mainfile'
drop _merge

collapse (p50) FNI, by(wilsonabmed birthyear)
twoway line FNI birthyear if wilsonabmed==1, lcolor(black) || line FNI birthyear if wilsonabmed==0, lcolor(gs10) xline(1917) ///
		legend(rows(2) size(small) label(1 "Above median") label(2 "Below median")) ///
		plotregion(style(none)) ysca(titlegap(2)) ///
		xtitle("Year of birth", size(small)) ytitle("Median FNI", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
