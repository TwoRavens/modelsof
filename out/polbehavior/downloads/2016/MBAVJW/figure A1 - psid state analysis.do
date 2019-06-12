set more off

use "psid", clear

local j = 1

replace demvoteshare = demvoteshare * 100
replace donations_total_pct = donations_total_pct * 100
replace donations_religious_pct = donations_religious_pct * 100
replace donations_secular_pct = donations_secular_pct * 100

su demvoteshare
gen demvotesharetmp = (demvoteshare - r(min)) / (r(max) - r(min))

foreach y in donations_total_pct donations_religious_pct donations_secular_pct {
	
	if "`y'" == "donations_total_pct" local mytitle "Total"
	if "`y'" == "donations_religious_pct" local mytitle "Religious"
	if "`y'" == "donations_secular_pct" local mytitle "Secular"
	
	reg `y' demvotesharetmp [aw=N], robust
	local B = string(_b[demvoteshare], "%20.02fc")
	local SE = string(_se[demvoteshare], "%20.02fc")
	
	#delimit;
	
	gr tw
		(sc `y' demvoteshare [aw=N], mlab(statea) msym(none) mlabpos(0) mlabcol(gray))
		(lfit `y' demvoteshare [aw=N], col(black) lwid(thick))
		,
			name(g`j', replace) 
			legend(off)
			plotregion(style(none))
			ylab(, angle(horiz))
			xtitle("")
			subtitle("B=`B' (SE=`SE')")
			title("`mytitle'")
			;
	
	#delimit cr
	
	local j = `j' + 1
	
}

#delimit;

gr combine 
	g1 g2 g3
	,
		ycommon
		rows(1)
		b1title("Democratic presidential vote in 2004")
		l1title("Percent of income donated in 2003")
		;
		
#delimit cr 

local myfilename "figureA1.eps"
gr export "`myfilename'", replace
shell epspdf "`myfilename'"
