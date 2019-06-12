// replicates Figure C.1: 
// Stability of Ideological Distributions Over Time (France, Italy, Spain, United Kingdom)

clear
capture log close
set more off

use  ebdata.dta
keep year cntry LR_* leftright 

* drop if ideology is missing
drop if leftright==.

* mark survey countries
gen     own_surveydata=0
replace own_surveydata=1 if cntry=="FR" | cntry=="IT" | cntry=="GB" | cntry=="ES"

// plot 1 pooled
graph bar (mean) LR_fleft_c5 LR_left_c5 LR_center_c5 LR_right_c5 LR_fright_c5 if own_surveydata==1 & leftright!=., over(year, label(angle(forty_five) labsize(medsmall))) stack bar(1, fcolor(navy)) bar(2, fcolor(black)) bar(3, fcolor(maroon)) yline(0.2 0.4 0.6 0.8, lwidth(vthin) lpattern(dot) lcolor(black)) ytitle(Share) ylabel(, labsize(medsmall)) legend(order(1 "Far Left" 2 "Left" 3 "Center" 4 "Right" 5 "Far Right") rows(1) size(small)) clegend(on) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white))
graph save LR_c_5_barchart.gph, replace
graph export LR_c_5_barchart.pdf, replace

// plot 2 survey countries
graph bar (mean) LR_fleft_c5 LR_left_c5 LR_center_c5 LR_right_c5 LR_fright_c5 if own_surveydata==1 & cntry!="GR" & leftright!=., subtitle(, color(black) fcolor(none) lcolor(white)) by(, graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) by(cntry) over(year, label(angle(forty_five) labsize(vsmall))) stack bar(1, fcolor(navy)) bar(2, fcolor(black)) bar(3, fcolor(maroon)) yline(0.2 0.4 0.6 0.8, lwidth(vthin) lpattern(dot) lcolor(black)) ytitle(Share) ylabel(, labsize(medsmall)) legend(order(1 "Far Left" 2 "Left" 3 "Center" 4 "Right" 5 "Far Right") rows(1) size(small)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white))
graph save LR_c_5_barchart_byowncountry.gph, replace
graph export LR_c_5_barchart_byowncountry.pdf, replace


