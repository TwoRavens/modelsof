set scheme s1color

use FNIdataset if german==1, clear
keep if birthyear>=1900

collapse (mean) FNI, by(birthyear)

* Compute p-values for linear trend break
tsset birthyear
reg FNI birthyear, ro
estat sbsingle
gen pval=.
forval x=1905/1925 {
	estat sbknown, break(`x') 
	replace pval=r(p) if birthyear==`x'
}

twoway bar pval birthyear, plotregion(style(none)) ysca(titlegap(2)) lcolor(dknavy) ///
		xtitle("Year of birth", size(small)) ytitle("P-value from trend break test", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2)) ///
		color(dknavy) xline(1917, lcolor(gs10)) 
