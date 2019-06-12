
graph box ma_otri otri, over(oil100, relabel(1 "No Oil" 2 "Oil Rich")) ///
	legend(order(1 "Restrictions faced by exports" 2 "Import restrictiveness")) scheme(s1color)




twoway (scatter ma_otri otri if oil100==0) ///
(scatter ma_otri otri if oil100==1, mlabel(wdicode)), ///
ytitle(restrictions faced by exports) ///
xtitle(import restrictions) legend(off) scheme(s1color)

twoway (lfitci gap logoil) (scatter gap logoil, mlabel(wdicode)), ///
ytitle(import minus export restrictions) xlabel(3.91202 "50" 4.60517 "100" 6.21461 "500" 6.90776 "1000" 8.51719 "5000", valuelabel) ///
xtitle(log of oil income) legend(off) scheme(s1color)
