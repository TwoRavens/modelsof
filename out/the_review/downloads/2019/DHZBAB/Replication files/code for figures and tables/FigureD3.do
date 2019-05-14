use FNIdataset, clear

* capitalize nationalities for display in graph
foreach x in german italian irish belgian french swiss portuguese english scottish welsh ///
	danish norwegian swedish finnish austrian russian {
	ren `x', proper
}
tempfile FNI
save `FNI'

foreach x in German Italian Irish Belgian French Swiss Portuguese English Scottish Welsh ///
	Danish Norwegian Swedish Finnish Austrian Russian {
	
	use `FNI', clear
	collapse (mean) FNI if `x'==1, by(birthyear)
	
	twoway line FNI birthyear, yscale(range(45 75)) ylabel(45(10)75) xline(1917, lcolor(cranberry)) lcolor(black) subtitle(`x') ///
	plotregion(style(none)) xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small))	///
	xsca(titlegap(2)) legend(size(small)) xtitle("Year of birth", size(small)) ytitle("Mean FNI", size(small))
	graph save FigD3_`x'.gph, replace
}

graph combine FigD3_German.gph FigD3_Italian.gph FigD3_Irish.gph FigD3_Belgian.gph ///
	FigD3_French.gph FigD3_Swiss.gph FigD3_Portuguese.gph ///
	FigD3_English.gph FigD3_Scottish.gph FigD3_Welsh.gph ///
	FigD3_Danish.gph FigD3_Norwegian.gph FigD3_Swedish.gph ///
	FigD3_Finnish.gph FigD3_Austrian.gph FigD3_Russian.gph, altshrink
