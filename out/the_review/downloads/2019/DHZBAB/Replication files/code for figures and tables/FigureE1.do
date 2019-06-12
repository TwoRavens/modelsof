*--------------------------------------
* Upper left 
*--------------------------------------

use FNIdataset if german==1, clear 

gen yrsmed=.
forval bb=1880/1930 {
	qui sum yrsusa1_pop if fbpl==453&birthyear==`bb', det
	replace yrsmed=r(p50) if birthyear==`bb'
}
gen yrspop=(yrsusa1_pop>r(p50))
replace yrspop=. if yrsusa1_pop==.

collapse (p50) FNI if fbpl==453, by(birthyear yrspop)
twoway  line FNI birthyear if yrspop==1, lcolor(black) xline(1917, lcolor(cranberry)) || ///
		line FNI birthyear if yrspop==0, ///
		legend(size(small) rows(2) label(1 "Father above median years in US") label(2 "Father below median years in US")) ///
		plotregion(style(none)) ysca(titlegap(2)) lcolor(gs7) ///
		xtitle("Year of birth", size(small)) ytitle("Median FNI", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
graph save "FigE1a.gph", replace


*--------------------------------------
* Upper right  
*--------------------------------------

use FNIdataset if german==1, clear 

gen popcit=.
replace popcit=1 if citizen_pop==2
replace popcit=0 if citizen_pop==3

collapse (p50) FNI if fbpl==453, by(birthyear popcit)
twoway line FNI birthyear if popcit==1, lcolor(black) xline(1917, lcolor(cranberry)) || ///
		line FNI birthyear if popcit==0, legend(rows(2) size(small) label(1 "Father naturalized citizen") label(2 "Father non-naturalized")) ///
		plotregion(style(none)) ysca(titlegap(2)) lcolor(gs7) ///
		xtitle("Year of birth", size(small)) ytitle("Median FNI", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
graph save "FigE1b.gph", replace						
		
*--------------------------------------
* Lower left  
*--------------------------------------

use FNIdataset if german==1, clear

gen pbpl=1 if fbpl==453&mbpl==453
replace pbpl=0 if ((fbpl==453&mbpl<100)|(fbpl<100&mbpl==453))

collapse (p50) FNI, by(birthyear pbpl)
twoway line FNI birthyear if pbpl==0, lcolor(black) xline(1917, lcolor(cranberry)) || ///
		line FNI birthyear if pbpl==1, legend(rows(2) size(small) label(1 "Only father German") label(2 "Both parents German")) ///
		plotregion(style(none)) ysca(titlegap(2)) lcolor(gs7) ///
		xtitle("Year of birth", size(small)) ytitle("Median FNI", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
graph save "FigE1c.gph", replace	


*--------------------------------------
* Lower right  
*--------------------------------------

use FNIdataset if german==1, clear 	

gen self=(classwkr_pop==1)
replace self=. if classwkr_pop==.|classwkr_pop==0

collapse (p50) FNI if fbpl==453, by(birthyear self)
twoway  line FNI birthyear if self==1, lcolor(black) xline(1917, lcolor(cranberry)) || ///
		line FNI birthyear if self==0, ///
		legend(size(small) rows(2) label(1 "Father self-employed") label(2 "Father works for wages")) ///
		plotregion(style(none)) ysca(titlegap(2)) lcolor(gs7) ///
		xtitle("Year of birth", size(small)) ytitle("Median FNI", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
graph save "FigE1d.gph", replace
				
		
graph combine "FigE1a.gph" "FigE1b.gph" "FigE1c.gph" "FigE1d.gph", altshrink
