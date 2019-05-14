use petitionsdataset_byarrivalyr, clear

collapse arrivalyr, by(country issueyear state)
gen german=(country=="Germany")
gen yearsinUS=issueyear-arrivalyr
collapse yearsinUS, by(german issueyear)

twoway line yearsinUS issueyear if german==1, lcolor(black) legend(label(1 "German") label(2 "Non-German")) || ///
	line yearsinUS issueyear if german==0, lcolor(gs7) ytitle("Average years in US at time of petition", size(small)) ///
				xtitle("Year", size(small)) xline(1917) legend(size(small) rows(2)) ///
				plotregion(style(none)) ysca(titlegap(2)) ///
				xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
