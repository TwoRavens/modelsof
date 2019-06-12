*------------------------------------------------------------------------------
* Load 1920 1% IPUMS dataset
*------------------------------------------------------------------------------

keep if yrnatur>=1900
replace yrnatur=. if yrnatur>9000

* Create variables
gen naturalized=(citizen==2)
replace naturalized=. if citizen==.|citizen==5|citizen==0

* Code nationalities
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

drop if yrnatur==.&ethnicgroup==.

collapse (count) naturalized, by(statefip yrnatur ethnicgroup)

* Interactions of German by year of naturalization (after 1911)
keep if yrnatur>=1911
tab yrnatur, gen(yr_)
gen german=(ethnicgroup==1)
forval x=1/10 {
	gen inter_`x'=german*yr_`x'
}

estimates clear
reg naturalized i.ethnicgroup i.yrnatur inter_2-inter_10 i.statefip, cl(ethnicgroup)
eststo m1
coefplot (m1, ciopts(lcolor(black) recast(rcap))), ci(90) vertical yline(0) keep(inter_*) ///
coeflabels(inter_2="1912" inter_3=" " inter_4="1914" inter_5=" " inter_6="1916" inter_7=" " inter_8="1918" ///
		inter_9=" " inter_10="1920" inter_11=" " inter_12="1922" inter_13=" " inter_14="1924" inter_15=" ") ///
		plotregion(style(none)) ysca(titlegap(2)) msize(small) mcolor(black) ///
		xtitle("Year of naturalization", size(small)) ytitle("Interaction with German", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
