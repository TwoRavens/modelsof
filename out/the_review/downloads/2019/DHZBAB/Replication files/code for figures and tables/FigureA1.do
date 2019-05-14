use hatecrimes, clear
collapse (count) id, by(year)

twoway bar id year, ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small)) ///
		xtitle("Year", size(small)) ytitle("Number of incidents", size(small))  ///
		color(dknavy) plotregion(style(none)) ysca(titlegap(2)) xsca(titlegap(2)) barwidth(0.7)
