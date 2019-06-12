**stata code for Figure 4
**this could should be used after the data manipulation is completed
***use "pew.dta" data

gen rsecular=100*(secular-1)/4
gen rislaminlaw=100*(islaminlaw-1)/2
gen rreligious=100*(religiosity-2)/12


graph bar (mean) rsecular rislaminlaw rreligious , bar(1, fcolor(black)) bar(2, fcolor(gs4)) bar(3, fcolor(gs9)) bar(4, fcolor(gs13)) bargap(30) blabel(bar, format(%9.1g)) ylabel(none) legend(order(1 "Secular" 2 "Islam in Legislation" 3 "Religious" ) size(vsmall) cols(3)) by(COUNTRY)
 