set scheme s1color

*-----------------------------
* Left panel - Mean FNI
*-----------------------------

use FNIdataset if german==1, clear

collapse FNI, by(birthyear)
twoway line FNI birthyear, yscale(range(49 60)) ylabel(50(5)60) xline(1917, lcolor(gs10)) lcolor(black) ///
plotregion(style(none)) xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small))	///
xsca(titlegap(2)) legend(size(small)) xtitle("Year of birth", size(small)) ytitle("Mean FNI", size(small))
graph save "Fig2left.gph", replace


*-----------------------------
* Right panel - Median FNI
*-----------------------------

use FNIdataset if german==1, clear

collapse (p50) FNI, by(birthyear)
twoway line FNI birthyear, yscale(range(54 58)) ylabel(54(1)58) xline(1917, lcolor(gs10)) lcolor(black) ///
plotregion(style(none)) xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small))	///
xsca(titlegap(2)) legend(size(small)) xtitle("Year of birth", size(small)) ytitle("Median FNI", size(small))
graph save "Fig2right.gph", replace


*-----------------------------
* Combine panels
*-----------------------------

graph combine "Fig2left.gph" "Fig2right.gph"
