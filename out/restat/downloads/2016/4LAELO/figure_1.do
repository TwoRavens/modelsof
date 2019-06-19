*****************************************************************************
* figure_1.do
* Byrne, Kovak, and Michaels - REStat
* Quality-Adjusted Price Measurement
*
* Shows paths of average prices by quarter for 4 important technologies for
* Taiwan and China.
*
*****************************************************************************

set more off
capture log close
clear
clear matrix

log using figure_1.txt, text replace

use wafer, clear

rename priceperwafer pw 
generate w=waferspurchased/1000
generate lnw=ln(w)

* keep china, singapore, and taiwan
keep if inlist(loc,1,6,8) 

* merge in weights
sort loc wafer line quarter
merge m:1 loc wafer line quarter using isuppli_shipments
keep if _merge == 3 // only dropping weight for bins that don't show up in GSA data
drop _merge

* apportion each bin's weight to the observations in that bin
bysort loc wafer line quarter: egen totalwafersbin = sum(waferspurchased)
gen obsfracofbin = waferspurchased / totalwafersbin // transaction's fraction of bin total
bysort loc wafer line quarter: gen binship_oneperbin = shipments if _n == 1
bysort loc wafer line quarter: egen binship = mean(binship_oneperbin)
bysort quarter: egen totalwafersqtr = sum(binship_oneperbin) // avoids multiple counts per bin
gen binfracofqtr = binship / totalwafersqtr // bin's fraction of quarterly total
gen weight = obsfracofbin * binfracofqtr

* collapse to the technology, quarter, location level
collapse (mean) pw metallayers polylayers masklayers epitax lnw (rawsum) weight ///
         [aw=waferspurchased], by(wafer line quarter loc)
reshape wide pw metallayers polylayers masklayers epitax lnw weight, ///
        i(wafer line quarter) j(loc)

gen date = quarter + 176 - 1
format date %tq
save price_paths, replace

		
* 200mm 250nm
twoway (connected pw1 date if wafer==200 & line==250, lpattern(shortdash) lcolor(black) msymb(Oh) mcolor(black)) ///
	   (connected pw8 date if wafer==200 & line==250, lpattern(solid) lcolor(black) msymb(O) mcolor(black)  msize(small)) ///
	   , ///
	     xtitle("Calendar Quarter", size(small)) ///
		 xlabel(176(2)203, angle(90) labsize(small)) ///
	     ytitle("Average Wafer Pice", size(small)) ///
		 ylabel(,labsize(small)) ///
		 subtitle("200mm 250nm Wafers") ///
		 graphregion(color(white)) ///
		 legend(cols(2) order(2 1) label(2 Taiwan) label(1 China) size(small)) ///
		 saving(price_paths_200mm_250nm, replace)

* 200mm 180nm
twoway (connected pw1 date if wafer==200 & line==180, lpattern(shortdash) lcolor(black) msymb(Oh) mcolor(black)) ///
	   (connected pw8 date if wafer==200 & line==180, lpattern(solid) lcolor(black) msymb(O) mcolor(black)  msize(small)) ///
	   , legend(off) ///
	     xtitle("Calendar Quarter", size(small)) ///
		 xlabel(176(2)203, angle(90) labsize(small)) ///
	     ytitle("Average Wafer Pice", size(small)) ///
		 ylabel(,labsize(small)) ///
		 subtitle("200mm 180nm Wafers") ///
		 graphregion(color(white)) ///
		 saving(price_paths_200mm_180nm, replace)

* 200mm 150nm
twoway (connected pw1 date if wafer==200 & line==150, lpattern(shortdash) lcolor(black) msymb(Oh) mcolor(black)) ///
	   (connected pw8 date if wafer==200 & line==150, lpattern(solid) lcolor(black) msymb(O) mcolor(black)  msize(small)) ///
	   , legend(off) ///
	     xtitle("Calendar Quarter", size(small)) ///
		 xlabel(176(2)203, angle(90) labsize(small)) ///
	     ytitle("Average Wafer Pice", size(small)) ///
		 ylabel(,labsize(small)) ///
		 subtitle("200mm 150nm Wafers") ///
		 ylabel(1000(1000)2000) ///
		 graphregion(color(white)) ///
		 saving(price_paths_200mm_150nm, replace)

* 200mm 130nm
twoway (connected pw1 date if wafer==200 & line==130, lpattern(shortdash) lcolor(black) msymb(Oh) mcolor(black)) ///
	   (connected pw8 date if wafer==200 & line==130, lpattern(solid) lcolor(black) msymb(O) mcolor(black)  msize(small)) ///
	   , legend(off) ///
	     xtitle("Calendar Quarter", size(small)) ///
		 xlabel(176(2)203, angle(90) labsize(small)) ///
	     ytitle("Average Wafer Pice", size(small)) ///
		 ylabel(,labsize(small)) ///
		 subtitle("200mm 130nm Wafers") ///
		 ylabel(1000(1000)3000) ///
		 graphregion(color(white)) ///
		 saving(price_paths_200mm_130nm, replace)

grc1leg price_paths_200mm_250nm.gph price_paths_200mm_180nm.gph ///
        price_paths_200mm_150nm.gph price_paths_200mm_130nm.gph ///
      , row(2) ///
	    graphregion(color(white)) ///
		legendfrom(price_paths_200mm_250nm.gph) position(6)
graph export figure_1.pdf, replace

	  
log close

