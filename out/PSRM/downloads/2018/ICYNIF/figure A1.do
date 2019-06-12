/*******************************************************************************
This file replicates Figure A1. 
*******************************************************************************/

use dataset, clear

keep if studynumber == 6

collapse zip pctfb (count) n=zip, by(zipcode)

su pctfb

#delimit;

gr tw
	(lfitci zip pctfb, clcol(black))
	(sc zip pctfb, mcol(black) msym(Oh))
	,
		legend(off)
		plotregion(style(none))
		xtitle("Proportion With Facebook Access")
		ytitle("Proportion With Matching Zip Code")
		ylab(0(.2)1, angle(horiz))
		;

#delimit cr

gr export "figure A1.png", replace width(1000)

su pctfb
replace pctfb= (pctfb- r(mean))/r(sd)
reg zip pctfb, cl(zipcode)
