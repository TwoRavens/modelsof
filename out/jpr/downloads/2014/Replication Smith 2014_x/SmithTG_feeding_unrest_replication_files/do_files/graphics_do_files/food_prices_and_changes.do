*** created 19 February 2013

clear all

local user "`c(username)'"

cd "/Users/`user'/Documents/Projects & Papers/Mother Nature and Markets/analysis/"

use "data/mother_nature_markets_final.dta", clear

format time %tmCCYY

drop if time < 360
replace food_price = . if food_chg == .

lab var food_price "Domestic consumer food price index"
lab var FAO_food "FAO Food Index"
lab var food_chg "% change in food prices"

replace food_price = . if food_chg == .

twoway (tsline food_price, lcolor(dkgreen) cmissing(n) ylabel(#5, labsize(vsmall) angle(horizontal))) ///
	(tsline food_chg, lcolor(none) cmissing(n) yaxis(2)) ///
	if time >= 480 & ///
	(iso_num == 710 | iso_num == 231 | iso_num == 686 | iso_num == 566), ///
	by(iso_num, rows(2) yrescale noiytick title("Domestic Consumer Food Price Changes", size(medium)) ///
	note("Sources: ILO", size(vsmall))) ///
	subtitle(, size(small)) ///
	xlabel(480(24)612) ///
	xtitle(, size(zero)) ///
	ytitle("% change in food prices", size(small) axis(2)) ///
	ytitle(, size(small)) ///
	ylabel(, labcolor(white) axis(2)) ///
	tlabel(, labsize(small)) ///
	legend(cols(2) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4.5) ///
	scale(1) ///
	scheme(s1color) name(food_chg_1, replace)
graph export "graphs/food_price_changes_1.pdf", replace

twoway (tsline food_price, lcolor(dkgreen) cmissing(n) ylabel(#5, labsize(vsmall) angle(horizontal))) ///
	(tsline food_chg, lcolor(dkorange) cmissing(n) yaxis(2)) ///
	if time >= 480 & ///
	(iso_num == 710 | iso_num == 231 | iso_num == 686 | iso_num == 566), ///
	by(iso_num, rows(2) yrescale noiytick title("Domestic Consumer Food Price Changes", size(medium)) ///
	note("Sources: ILO", size(vsmall))) ///
	subtitle(, size(small)) ///
	xlabel(480(24)612) ///
	xtitle(, size(zero)) ///
	ytitle("% change in food prices", size(small) axis(2)) ///
	ytitle(, size(small)) ///
	tlabel(, labsize(small)) ///
	legend(cols(2) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4.5) ///
	scale(1) ///
	scheme(s1color) name(food_chg_2, replace)
graph export "graphs/food_price_changes_2.pdf", replace

histogram food_chg, by(iso3, rows(5)) scheme(s1color) name(hist_ctry, replace)

exit

twoway (tsline food_price, lwidth(medthick) lcolor(dkgreen) cmissing(n) ylabel(#5, labsize(vsmall) angle(horizontal))) ///
	(tsline FAO_food, lcolor(dkorange) yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 12 | iso_num == 818 | iso_num == 504 | iso_num == 788 | iso_num == 120 | iso_num == 508 | iso_num == 478 | iso_num == 800 | iso_num == 384), ///
	by(iso_num, rows(3) yrescale noiytick title("International Commodity & Domestic Consumer Prices", size(medium)) ///
	note("Sources: FAO, ILO; C™te d'Ivoire series changed in January 2010; Morocco series changed in January 2010", size(vsmall))) ///
	subtitle(, size(small)) ///
	ylabel(none, labsize(zero) noticks axis(2)) ///
	xtitle(, size(zero)) ///
	ytitle(, size(small)) ///
	tlabel(, labsize(small)) ///
	legend(cols(2) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4.5) ///
	scale(1) ///
	scheme(s1color) name(lagi_color, replace)
*graph export "graphs/natl_v_intl/lagi_color.pdf", replace

twoway (tsline food_price, lwidth(medthick) lcolor(black) cmissing(n) ylabel(#5, labsize(vsmall) angle(horizontal))) ///
	(tsline FAO_food, lcolor(gs9) lpattern(solid) yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 12 | iso_num == 818 | iso_num == 504 | iso_num == 788 | iso_num == 120 | iso_num == 508 | iso_num == 478 | iso_num == 800 | iso_num == 384), ///
	by(iso_num, rows(3) yrescale noiytick title(, size(zero)) ///
	note("Sources: FAO, ILO; C™te d'Ivoire series changed in January 2010; Morocco series changed in January 2010", size(vsmall))) ///
	subtitle(, size(small)) ///
	ylabel(none, labsize(zero) noticks axis(2)) ///
	xtitle(, size(zero)) ///
	ytitle(, size(small)) ///
	tlabel(, labsize(small)) ///
	legend(cols(2) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4.5) ///
	scale(1) ///
	scheme(s1mono) name(lagi_mono, replace)
*graph export "graphs/natl_v_intl/lagi_mono.pdf", replace

twoway (tsline food_price, lwidth(medthick) lcolor(black) cmissing(n) ylabel(#5, labsize(vsmall) angle(horizontal))) ///
	(tsline FAO_food, lcolor(gs9) lpattern(solid) yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 204 | iso_num == 72 | iso_num == 854 | iso_num == 140 | iso_num == 148 | iso_num == 178 | iso_num == 231 | iso_num == 270 | ///
	iso_num == 266 | iso_num == 288 | iso_num == 324 | iso_num == 624 | iso_num == 404 | iso_num == 426 | iso_num == 108), ///
	by(iso_num, rows(5) yrescale noiytick title(, size(zero)) ///
	note("", size(vsmall))) ///
	subtitle(, size(small)) ///
	ylabel(none, labsize(zero) noticks axis(2)) ///
	xtitle(, size(zero)) ///
	ytitle(, size(vsmall)) ///
	tlabel(, labsize(small)) ///
	legend(cols(2) rowgap(tiny) size(vsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(7.5) ///
	scale(1) ///
	scheme(s1mono) name(ben_lso_mono, replace)
*graph export "graphs/natl_v_intl/ben_lso_mono.pdf", replace

twoway (tsline food_price, lwidth(medthick) lcolor(black) cmissing(n) ylabel(#5, labsize(vsmall) angle(horizontal))) ///
	(tsline FAO_food, lcolor(gs9) lpattern(solid) yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 450 | iso_num == 454 | iso_num == 516 | iso_num == 466 | iso_num == 562 | iso_num == 566 | iso_num == 646 | iso_num == 686 | ///
	iso_num == 694 | iso_num == 710 | iso_num == 834 | iso_num == 768 | iso_num == 894 | iso_num == 748 | iso_num == 716), ///
	by(iso_num, rows(5) yrescale noiytick title(, size(zero)) ///
	note("", size(vsmall))) ///
	subtitle(, size(small)) ///
	ylabel(none, labsize(zero) noticks axis(2)) ///
	xtitle(, size(zero)) ///
	ytitle(, size(vsmall)) ///
	tlabel(, labsize(small)) ///
	legend(cols(2) rowgap(tiny) size(vsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(7.5) ///
	scale(1) ///
	scheme(s1mono) name(mdg_zwe_mono, replace)
*graph export "graphs/natl_v_intl/mdg_zwe_mono.pdf", replace


foreach iso of numlist 12 818 504 788 120 508 478 800 384 {
	twoway (tsline food_price, lwidth(medthick) lcolor(dkgreen) cmissing(n) ylabel(#5, labsize(small) angle(horizontal))) ///
		(tsline FAO_food, lcolor(dkorange) yaxis(2)) ///
		if time >= 528 & iso_num == `iso', ///
		by(iso_num, rows(3) yrescale noiytick note(, size(zero))) ///
		subtitle(, size(medsmall)) ///
		ylabel(none, labsize(zero) noticks axis(2)) ///
		xtitle(, size(zero)) ///
		ytitle(, size(medsmall)) ///
		tlabel(, labsize(small)) ///
		legend(cols(2) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
		xsize(6) ysize(4.5) ///
		scale(1) ///
		scheme(s1color) name(color_`iso', replace)
	*graph export "graphs/natl_v_intl/color_`iso'.pdf", replace
	}

exit

/*
*** North Africa
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 12 | iso_num == 818 | iso_num == 504 | iso_num == 788), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4) ///
	scheme(s1color)

*** West Africa 1
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 270 | iso_num == 694 | iso_num == 288 | iso_num == 566), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4) ///
	scheme(s1color)
	
*** West Africa 2
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 686 | iso_num == 478 | iso_num == 266 | iso_num == 624), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4) ///
	scheme(s1color)

*** Sahel
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 148 | iso_num == 854 | iso_num == 562 | iso_num == 466), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4) ///
	scheme(s1color)

*** Southern Africa 1
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 894 | iso_num == 454 | iso_num == 508 | iso_num == 450), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4) ///
	scheme(s1color)

*** Southern Africa 2
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 72 | iso_num == 426 | iso_num == 516 | iso_num == 710), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4) ///
	scheme(s1color)

*** East Africa
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 800 | iso_num == 646 | iso_num == 404 | iso_num == 834), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4) ///
	scheme(s1color)

*** Central Africa
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 108 | iso_num == 178 | iso_num == 120 | iso_num == 140), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(4) ///
	scheme(s1color)

*** outliers
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 324 | iso_num == 231), ///
	by(iso_num) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(2) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(2.5) ///
	scheme(s1color)

*** Lagi et al
twoway (tsline food_price) (tsline FAO_food, yaxis(2)) ///
	if time >= 528 & ///
	(iso_num == 12 | iso_num == 818 | iso_num == 504 | iso_num == 788 | iso_num == 120 | iso_num == 508 | iso_num == 478 | iso_num == 800), ///
	by(iso_num, rows(4)) ///
	xtitle(, size(zero)) ///
	ytitle(, size(medsmall)) ///
	ytitle("FAO Food Price Index", size(medsmall) axis(2)) ///
	legend(cols(1) rowgap(tiny) size(medsmall) nobox linegap(small) region(fcolor(none) lcolor(none))) ///
	xsize(6) ysize(8) ///
	scheme(s1color)
*/


lab var food_price12 "Algeria"
lab var food_price72 "Botswana"
lab var food_price108 "Burundi"
lab var food_price120 "Cameroon"
lab var food_price384 "C™te d'Ivoire"
lab var food_price231 "Ethiopia"
lab var food_price404 "Kenya"
lab var food_price450 "Madagascar"
lab var food_price478 "Mauritania"
lab var food_price504 "Morocco"
lab var food_price508 "Mozambique"
lab var food_price516 "Namibia"
lab var food_price710 "South Africa"
lab var food_price834 "Tanzania"
lab var food_price788 "Tunisia"
lab var food_price800 "Uganda"
lab var food_price818 "Egypt"
lab var food_price854 "Burkina Faso"
lab var food_price894 "Zambia"

twoway (line food_price time if year >= 2004, lwidth(thick) lcolor(gs12)) ///
	(connected food_price12 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(circle) mcolor(dkorange) lcolor(dkorange)) ///
	(connected food_price818 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(square) mcolor(dkgreen) lcolor(dkgreen)) ///
	(connected food_price504 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(triangle) mcolor(red) lcolor(red)) ///
	(connected food_price788 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(diamond) mcolor(dknavy) lcolor(dknavy)), ///
	ytitle(, size(medium)) ///
	ytitle("Domestic consumer food prices", size(medium) axis(2)) ///
	ytitle(, size(medium)) ///
	xtitle(, size(zero)) ///
	legend(cols(1) rowgap(tiny) size(medium) nobox linegap(small) region(fcolor(none) lcolor(none)) ///
	position(11) ring(0)) scheme(s1color) xsize(3) ysize(1.5)


*twoway (line IMF_food time if year >= 1990) (line food_price12 time if year >= 1990) (line food_price108 time if year >= 1990) (line food_price120 time if year >= 1990) (line food_price478 time if year >= 1990) (line food_price504 time if year >= 1990) (line food_price508 time if year >= 1990) (line food_price788 time if year >= 1990) (line food_price800 time if year >= 1990) (line food_price818 time if year >= 1990)

/*
twoway (line FAO_food time if year >= 2004, lwidth(medthick) lcolor(black)) ///
	(line food_price12 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_price818 time if year >= 2004, yaxis(2) lpattern(longdash_shortdash)) ///
	(line food_price504 time if year >= 2004, yaxis(2) lpattern(longdash)) ///
	(line food_price788 time if year >= 2004, yaxis(2) lpattern(vshortdash)), ///
	ytitle(national consumer food prices, axis(2)) xtitle(, size(zero)) legend(cols(1) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none)) position(11) ring(0)) scheme(sj) xsize(6) ysize(4)

twoway (line FAO_food time if year >= 2004, lwidth(medthick) lcolor(black)) ///
	(scatter food_price12 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(circle)) ///
	(scatter food_price818 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(square)) ///
	(scatter food_price504 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(triangle)) ///
	(scatter food_price788 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(diamond)), ///
	ytitle(national consumer food prices, axis(2)) xtitle(, size(zero)) legend(cols(1) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none)) position(11) ring(0)) scheme(sj) xsize(6) ysize(4)
*/
/*
twoway (line FAO_food time if year >= 2004, lwidth(medthick) lcolor(black)) ///
	(connected food_price12 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(circle)) ///
	(connected food_price818 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(square)) ///
	(connected food_price504 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(triangle)) ///
	(connected food_price788 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(diamond)), ///
	ytitle(national consumer food prices, axis(2)) xtitle(, size(zero)) legend(cols(1) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none)) position(11) ring(0)) scheme(sj) xsize(6) ysize(4)
*/

*** North Africa ***
twoway (line FAO_food time if year >= 2004, lwidth(thick) lcolor(gs12)) ///
	(connected food_price12 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(circle) mcolor(dkorange) lcolor(dkorange)) ///
	(connected food_price818 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(square) mcolor(dkgreen) lcolor(dkgreen)) ///
	(connected food_price504 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(triangle) mcolor(red) lcolor(red)) ///
	(connected food_price788 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(diamond) mcolor(dknavy) lcolor(dknavy)), ///
	ytitle(, size(medium)) ///
	ytitle("Domestic consumer food prices", size(medium) axis(2)) ///
	ytitle(, size(medium)) ///
	xtitle(, size(zero)) ///
	legend(cols(1) rowgap(tiny) size(medium) nobox linegap(small) region(fcolor(none) lcolor(none)) ///
	position(11) ring(0)) scheme(s1color) xsize(3) ysize(1.5)
graph export "graphs/intl_v_natl/north_color.eps", replace
graph export "graphs/intl_v_natl/north_color.pdf", replace

*** West Africa ***
twoway (line IMF_food time if year >= 2004, lwidth(thick) lcolor(gs12)) ///
	(connected food_price854 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(circle) mcolor(dkorange) lcolor(dkorange)) ///
	(connected food_price120 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(square) mcolor(dkgreen) lcolor(dkgreen)) ///
	(connected food_price384 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(triangle) mcolor(red) lcolor(red)) ///
	(connected food_price478 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(diamond) mcolor(dknavy) lcolor(dknavy)), ///
	ytitle(, size(medium)) ///
	ytitle("Domestic consumer food prices", size(medium) axis(2)) ///
	ytitle(, size(medium)) ///
	xtitle(, size(zero)) ///
	legend(cols(1) rowgap(tiny) size(medium) nobox linegap(small) region(fcolor(none) lcolor(none)) ///
	position(11) ring(0)) scheme(s1color) xsize(3) ysize(1.5)
graph export "graphs/intl_v_natl/west_color.eps", replace
graph export "graphs/intl_v_natl/west_color.pdf", replace

*** East Africa ***
twoway (line IMF_food time if year >= 2004, lwidth(thick) lcolor(gs12)) ///
	(connected food_price404 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(circle) mcolor(dkorange) lcolor(dkorange)) ///
	(connected food_price231 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(square) mcolor(dkgreen) lcolor(dkgreen)) ///
	(connected food_price834 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(triangle) mcolor(red) lcolor(red)) ///
	(connected food_price800 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(diamond) mcolor(dknavy) lcolor(dknavy)), ///
	ytitle(, size(medium)) ///
	ytitle("Domestic consumer food prices", size(medium) axis(2)) ///
	ytitle(, size(medium)) ///
	xtitle(, size(zero)) ///
	legend(cols(1) rowgap(tiny) size(medium) nobox linegap(small) region(fcolor(none) lcolor(none)) ///
	position(11) ring(0)) scheme(s1color) xsize(3) ysize(1.5)
graph export "graphs/intl_v_natl/east_color.eps", replace
graph export "graphs/intl_v_natl/east_color.pdf", replace

*** Southern Africa ***
twoway (line IMF_food time if year >= 2004, lwidth(thick) lcolor(gs12)) ///
	(connected food_price516 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(circle) mcolor(dkorange) lcolor(dkorange)) ///
	(connected food_price508 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(square) mcolor(dkgreen) lcolor(dkgreen)) ///
	(connected food_price710 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(triangle) mcolor(red) lcolor(red)) ///
	(connected food_price894 time if year >= 2004, yaxis(2) msize(vsmall) msymbol(diamond) mcolor(dknavy) lcolor(dknavy)), ///
	ytitle(, size(medium)) ///
	ytitle("Domestic consumer food prices", size(medium) axis(2)) ///
	ytitle(, size(medium)) ///
	xtitle(, size(zero)) ///
	legend(cols(1) rowgap(tiny) size(medium) nobox linegap(small) region(fcolor(none) lcolor(none)) ///
	position(11) ring(0)) scheme(s1color) xsize(3) ysize(1.5)
graph export "graphs/intl_v_natl/southern_color.eps", replace
graph export "graphs/intl_v_natl/southern_color.pdf", replace

exit

twoway (line IMF_food time if year >= 2004, lwidth(medium) lcolor(black)), ///
	xtitle(, size(zero)) ytitle(, size(zero)) legend(cols(1) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none)) position(11) ring(0)) title(IMF Food Price Index) scheme(sj) xsize(6) ysize(1.5)
graph save "graphs/IMF_since2004.gph", replace

twoway (line food_price854 time if year >= 2004, lwidth(medium) lcolor(black)), ///
	xtitle(, size(zero)) ytitle(, size(zero)) legend(cols(1) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none)) position(11) ring(0)) title(Burkina Faso) scheme(sj) xsize(6) ysize(1.5)
graph save "graphs/bfa_since2004.gph", replace

twoway (line food_price120 time if year >= 2004, lwidth(medium) lcolor(black)), ///
	xtitle(, size(zero)) ytitle(, size(zero)) legend(cols(1) rowgap(tiny) size(small) nobox linegap(small) region(fcolor(none) lcolor(none)) position(11) ring(0)) title(Cameroon) scheme(sj) xsize(6) ysize(1.5)
graph save "graphs/cmr_since2004.gph", replace

exit

* title(National Consumer Food Prices and International Commodity Prices)

/*
twoway (line food_chg12 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_chg108 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_chg120 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_chg478 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_chg504 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_chg508 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_chg788 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_chg800 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line food_chg818 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line IMF_food_chg time if year >= 2004, lwidth(medthick) lcolor(black))
*/

lab var FAO_cons_food12 "Algeria"
lab var FAO_cons_food108 "Burundi"
lab var FAO_cons_food120 "Cameroon"
lab var FAO_cons_food478 "Mauritania"
lab var FAO_cons_food504 "Morocco"
lab var FAO_cons_food508 "Mozambique"
lab var FAO_cons_food788 "Tunisia"
lab var FAO_cons_food800 "Uganda"
lab var FAO_cons_food818 "Egypt"

twoway (line FAO_cons_food12 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food108 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food120 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food478 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food504 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food508 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food788 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food800 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food818 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line IMF_food time if year >= 2004, lwidth(medthick) lcolor(black))

twoway (line FAO_cons_food12 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food108 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food120 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food478 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food504 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food508 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food788 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food800 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_cons_food818 time if year >= 2004, yaxis(2) lpattern(dash)) ///
	(line FAO_food time if year >= 2004, lwidth(medthick) lcolor(black))

