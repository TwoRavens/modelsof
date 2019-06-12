set scheme s1color

*------------------------------------------------------------------------------
* Load 1920 1% IPUMS dataset
*------------------------------------------------------------------------------

keep if yrnatur>=1900
replace yrnatur=. if yrnatur>9000

gen naturalized=(citizen==2)
replace naturalized=. if citizen==.|citizen==5|citizen==0

// Code nationalities
gen german=(bpl==453)
gen italian=(bpl==434)
gen irish=(bpl==414) 
gen belgian=(bpl==420) 
gen french=(bpl==421) 
gen swiss=(bpl==426) 
gen portuguese=(bpl==436) 
gen english=(bpl==410) 
gen scottish=(bpl==411) 
gen welsh=(bpl==412) 
gen danish=(bpl==400) 
gen norwegian=(bpl==404) 
gen swedish=(bpl==405) 
gen finnish=(bpl==401) 
gen austrian=(bpl==450) 
gen russian=(bpl==465)

gen ethnicgroup=1 if german==1
replace ethnicgroup=2 if italian==1
replace ethnicgroup=3 if irish==1
replace ethnicgroup=4 if belgian==1
replace ethnicgroup=5 if french==1
replace ethnicgroup=6 if swiss==1
replace ethnicgroup=7 if portuguese==1
replace ethnicgroup=8 if english==1
replace ethnicgroup=9 if scottish==1
replace ethnicgroup=10 if welsh==1
replace ethnicgroup=11 if danish==1
replace ethnicgroup=12 if norwegian==1
replace ethnicgroup=13 if swedish==1
replace ethnicgroup=14 if finnish==1
replace ethnicgroup=15 if austrian==1
replace ethnicgroup=16 if russian==1	

drop if yrnatur==.|ethnicgroup==.

* count number of German and non-German naturalized immigrants by year of naturalization
collapse (count) naturalized, by(yrnatur german)

* compute share of Germans among all naturalized immigrants by year 
reshape wide naturalized, i(yrnatur) j(german)
gen sharegerman=naturalized1/(naturalized1+naturalized0)


twoway line share yr, xline(1917, lcolor(gs10)) lcolor(black) ///
plotregion(style(none)) xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small))	///
xsca(titlegap(2)) legend(size(small)) xtitle("Year of naturalization", size(small)) ytitle("Share Germans among naturalized", size(small))
