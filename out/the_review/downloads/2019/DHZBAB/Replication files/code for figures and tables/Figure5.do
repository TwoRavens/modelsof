use ILPAdataset, clear

* declarations filed 1911-1923
keep if year_dec>1910&year_dec<1924

gen bin=1
replace bin=2 if year_decl>=1913&year_decl<=1914
replace bin=3 if year_decl>=1915&year_decl<=1916
replace bin=4 if year_decl>=1917&year_decl<=1918
replace bin=5 if year_decl>=1919&year_decl<=1920
replace bin=6 if year_decl>=1921&year_decl<=1923

tab bin, gen(bin_)
forval x=1/6 {
	gen interb_`x'=german*bin_`x'
}

estimates clear
reg diffAMIdc lAMIc  i.bin i.ethnicity interb_2-interb_6, cl(ethnicity)
eststo m1


coefplot (m1, ciopts(lcolor(black) recast(rcap))), ci(90) vertical yline(0) keep(interb_*) ///
coeflabels(interb_2="1913-1914" interb_3="1915-1916" interb_4="1917-1918" interb_5="1919-1920" ///
		interb_6="1921-1922") ///
		plotregion(style(none)) ysca(titlegap(2)) msize(small) mcolor(black) ///
		xtitle("Year of declaration", size(small)) ytitle("Interaction with German", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
