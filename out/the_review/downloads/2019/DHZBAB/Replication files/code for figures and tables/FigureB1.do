set scheme s1color
use petitionsdataset, clear
collapse (sum) petitions, by(country)

sort petitions
gen axis = _n
labmask axis, values(country)

graph hbar petitions, over(axis, label(angle(horizontal) labsize(small))) plotregion(style(none)) ysca(titlegap(2)) ///
		 ylabel(, nogrid labsize(small)) ytitle("Total petitions 1911-1925", size(small))  ///
		 bar(1, color(dknavy)) bar(2, color(dknavy)) bar(3, color(dknavy)) 
