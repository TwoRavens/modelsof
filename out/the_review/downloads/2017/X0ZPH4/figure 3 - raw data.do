set more off

use dataset_dataverse_with_leip, clear

replace pcteligible2013 = pcteligible2013 * 100

label define zl 1 "Expanding" 0 "Not expanding", replace
label values z zl

local j = 1

foreach y in dregistration20142010 dregistration20162012 dturnout20142010 dturnout20162012 {

	local mytitle = subinstr("`y'", "2010", "-2010", 1)
	local mytitle = subinstr("`mytitle'", "2012", "-2012", 1)
	local mytitle = subinstr("`mytitle'", "dregistration", "Registration ", 1)
	local mytitle = subinstr("`mytitle'", "dturnout", "Turnout ", 1)
	
	#delimit;
	
	gr tw
		(sc `y' pcteligible2013, msize(tiny) col(gs10))
		(lfit `y' pcteligible2013, col(black) lwid(medthick))
		,
			ylab(-20(10)10, angle(horiz) nogrid)
			by(z, legend(off) title(`mytitle') note(""))
			nodraw 
			name(g`j', replace)
			legend(off)
			subtitle(, fcol(none) lcol(none))
			plotregion(style(none))
			xtitle("Potential eligibility")
			ytitle("Change in participation")
			;
			
	#delimit cr
	
	local j = `j' + 1

}

gr combine g1 g2 g3 g4

gr export "figure3.eps", replace
shell epstopdf "figure3.eps"
