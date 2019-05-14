use FNIdataset, clear

gen livesathome=(relate==3)
collapse livesathome if german, by(age)

twoway bar livesathome age, plotregion(style(none)) ysca(titlegap(2)) ///
		 ylabel(, nogrid labsize(small)) ytitle("Share living with parents", size(small)) ///
		 xtitle("Age", size(small)) xlabel(, nogrid labsize(small)) color(dknavy)
