set more off

foreach dataset in gss ssi {

use `dataset', clear

local mytext1
local mytext2
local mylegend legend(off)
local mytitle = upper("`dataset'")

if "`dataset'" == "gss" {
	local mytext1 text(6.8 .77 "Republicans")
	local mytext2 text(6.2 .82 "Democrats")
	local mylegend legend(order(3 "Democrats" 4 "Republicans") ring(0) pos(7) region(lwid(none)) rows(2))
}

local control attend income male married family_size age hs coll grad white black i.region

gen republicanXoperational = republican*operational
gen independentXoperational = independent*operational

reg ln_totgiv republican##c.operational independent##c.operational `control' 

su operat if e(sample) == 1
local mymin = r(min)
local mymax = r(max)

*** recode log scale ***

forvalues i = 1(1)1000 {
	local log`i' = log(`i'+1)
}
local loghalf = log(.5 + 1)

*** plot ***

margins republican, at(operational = (`mymin' `mymax')) noestimcheck

#delimit;

marginsplot
	,
		plotopts(
			plotregion(style(none))
			ylab(, angle(horiz))
			ytitle("")
		)
		xlab(`mymin' "Low" `mymax' "High")
		ylab(
			`log50' "50"
			`log75' "75"
			`log100' "100"
			`log200' "200"
			`log300' "300"
			`log500' "500"
		)		
		xtitle("")
		title("`mytitle'")
		//noci
		recastci(rline)
		recast(line)
		`mylegend'
		plot1opts(lcol(black) lpat(solid) lwid(thick))
		ci1opts(lcol(black) lpat(solid) lwid(thin))
		plot2opts(lcol(gray) lpat(solid) lwid(thick))
		ci2opts(lcol(gray) lpat(shortdash) lwid(thin))
		name(g`dataset', replace)
		;
		
#delimit cr
		
}

gr combine ggss gssi, ycommon b1title("Operational conservatism") l1title("Total giving ($)")

local myfilename "figure2.eps"
gr export "`myfilename'", replace
shell epspdf "`myfilename'"
