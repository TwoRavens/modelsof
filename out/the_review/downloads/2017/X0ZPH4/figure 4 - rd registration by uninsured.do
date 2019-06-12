set more off

use dataset_dataverse_with_leip, clear

keep if abs(x) < 100

local Z pcteligible2013

su `Z', det
gen Z = `Z' >=r(p50)
replace Z = . if mi(`Z')

#delimit

gr tw 
	(sc dregistration20142010 x if Z == 0, msize(tiny) col(gs13))
	(lpolyci dregistration20142010 x if x < 0 & Z == 0, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	(lpolyci dregistration20142010 x if x > 0 & Z == 0, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	,
		ylab( , angle(horiz) nogrid)
		plotregion(style(none))
		subtitle(, fcol(none) lwid(none))
		xline(0)
		ylab(, angle(horiz))
		xtitle("Distance from nearest state border")
		legend(off)
		ytitle("Change in voter registration")
		title("Low eligibility")
		legend(off)
		nodraw
		name(g1, replace)
		;		
	
#delimit cr

#delimit

gr tw 
	(sc dregistration20142010 x if Z == 1, msize(tiny) col(gs13))
	(lpolyci dregistration20142010 x if x < 0 & Z == 1, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	(lpolyci dregistration20142010 x if x > 0 & Z == 1, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	,
		ylab( , angle(horiz) nogrid)
		plotregion(style(none))
		subtitle(, fcol(none) lwid(none))
		xline(0)
		ylab(, angle(horiz))
		xtitle("Distance from nearest state border")
		legend(off)
		ytitle("Change in voter registration")
		title("High eligibility")
		legend(off)
		nodraw
		name(g2, replace)
		;
	
#delimit cr


#delimit

gr tw 
	(sc dregistration20162012 x if Z == 0, msize(tiny) col(gs13))
	(lpolyci dregistration20162012 x if x < 0 & Z == 0, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	(lpolyci dregistration20162012 x if x > 0 & Z == 0, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	,
		ylab( , angle(horiz) nogrid)
		plotregion(style(none))
		subtitle(, fcol(none) lwid(none))
		xline(0)
		ylab(, angle(horiz))
		xtitle("Distance from nearest state border")
		legend(off)
		ytitle("Change in voter registration")
		title("Low eligibility")
		legend(off)
		nodraw
		name(g3, replace)
		;
	
#delimit cr

#delimit

gr tw 
	(sc dregistration20162012 x if Z == 1, msize(tiny) col(gs13))
	(lpolyci dregistration20162012 x if x < 0 & Z == 1, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	(lpolyci dregistration20162012 x if x > 0 & Z == 1, clcol(black) lwid(medthick) ciplot(rline) alpat(solid) alcol(black) alwid(thin))
	,
		ylab( , angle(horiz) nogrid)
		plotregion(style(none))
		subtitle(, fcol(none) lwid(none))
		xline(0)
		ylab(, angle(horiz))
		xtitle("Distance from nearest state border")
		legend(off)
		ytitle("Change in voter registration")
		title("High eligibility")
		legend(off)
		nodraw
		name(g4, replace)
		;
	
#delimit cr

gr combine g1 g2, rows(1) title("Change in registration 2014-2010") name(G1, replace) ycommon
gr combine g3 g4, rows(1) title("Change in registration 2016-2012") name(G2, replace) ycommon
gr combine G1 G2, rows(2) 

gr export "figure4.eps", replace
shell epspdf "figure4.eps"
