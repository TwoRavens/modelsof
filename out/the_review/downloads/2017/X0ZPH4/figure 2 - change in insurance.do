set more off

use dataset_dataverse_with_leip, clear

local Z pcteligible2013

keep if abs(x) < 100

su `Z', det
gen Z = `Z' >=r(p50)
replace Z = . if mi(`Z')

label define zl 1 "High eligibility" 0 "Low eligibility", replace
label values Z zl

#delimit

gr tw 
	(sc dpctui20142013 x if Z == 0, msize(tiny) col(gs13))
	(lpolyci dpctui20142013 x if x < 0 & Z == 0, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	(lpolyci dpctui20142013 x if x > 0 & Z == 0, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	,
		ylab(-40(10)10, angle(horiz) nogrid)
		plotregion(style(none))
		subtitle(, fcol(none) lwid(none))
		xline(0)
		ylab(, angle(horiz))
		xtitle("Distance from nearest state border")
		legend(off)
		ytitle("Change in pct. uninsured")
		title("Low eligibility")
		legend(off)
		nodraw
		name(g1, replace)
		;		
	
#delimit cr

#delimit

gr tw 
	(sc dpctui20142013 x if Z == 1, msize(tiny) col(gs13))
	(lpolyci dpctui20142013 x if x < 0 & Z == 1, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	(lpolyci dpctui20142013 x if x > 0 & Z == 1, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	,
		ylab(-40(10)10, angle(horiz) nogrid)
		plotregion(style(none))
		subtitle(, fcol(none) lwid(none))
		xline(0)
		ylab(, angle(horiz))
		xtitle("Distance from nearest state border")
		legend(off)
		ytitle("Change in pct. uninsured")
		title("High eligibility")
		legend(off)
		nodraw
		name(g2, replace)
		;
	
#delimit cr


#delimit

gr tw 
	(sc dpctui20152013 x if Z == 0, msize(tiny) col(gs13))
	(lpolyci dpctui20152013 x if x < 0 & Z == 0, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	(lpolyci dpctui20152013 x if x > 0 & Z == 0, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	,
		ylab(-40(10)10, angle(horiz) nogrid)
		plotregion(style(none))
		subtitle(, fcol(none) lwid(none))
		xline(0)
		ylab(, angle(horiz))
		xtitle("Distance from nearest state border")
		legend(off)
		ytitle("Change in pct. uninsured")
		title("Low eligibility")
		legend(off)
		nodraw
		name(g3, replace)
		;
	
#delimit cr

#delimit

gr tw 
	(sc dpctui20152013 x if Z == 1, msize(tiny) col(gs13))
	(lpolyci dpctui20152013 x if x < 0 & Z == 1, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	(lpolyci dpctui20152013 x if x > 0 & Z == 1, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	,
		ylab(-40(10)10, angle(horiz) nogrid)
		plotregion(style(none))
		subtitle(, fcol(none) lwid(none))
		xline(0)
		ylab(, angle(horiz))
		xtitle("Distance from nearest state border")
		legend(off)
		ytitle("Change in pct. uninsured")
		title("High eligibility")
		legend(off)
		nodraw
		name(g4, replace)
		;
	
#delimit cr

gr combine g1 g2, rows(1) title("Change in uninsured 2014-2013") name(G1, replace) 
gr combine g3 g4, rows(1) title("Change in uninsured 2015-2013") name(G2, replace) 
gr combine G1 G2, rows(2) 

gr export "figure2.eps", replace
shell epspdf "figure2.eps"
