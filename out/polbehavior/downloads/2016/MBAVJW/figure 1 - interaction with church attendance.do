set more off

foreach dataset in sccbs gss ssi {

	use `dataset', clear

	local mytext1
	local mytext2
	local mylegend legend(off)
	local mytitle = upper("`dataset'")

	if "`dataset'" == "sccbs" {
		gen republican = conservative
		gen democrat = liberal
		gen independent = moderate
		local mytext1 text(6.8 .77 "Republicans")
		local mytext2 text(6.2 .82 "Democrats")
		local mylegend legend(order(3 "Libs/Dems" 4 "Cons/Reps") ring(0) pos(7) region(lwid(none)) rows(2))
	}

	local control income male married family_size age hs coll grad white black i.region

	gen republicanXattend = republican*attend
	gen independentXattend = independent*attend

	su attend
	replace attend = (attend - r(min)) / (r(max) - r(min))
	su attend

	xi: reg ln_totgiv republican##c.attend independent##c.attend `control' 

	local mymin = r(min)
	local mymax = r(max)

	*** recode log scale ***

	forvalues i = 1(1)1000 {
		local log`i' = log(`i'+1)
	}
	local loghalf = log(.5 + 1)

	*** plot ***

	xi: reg ln_totgiv republican##c.attend independent##c.attend `control'

	margins republican, at(attend = (0 1) independent = 0)

	#delimit;

	marginsplot
		,
			plotopts(
				plotregion(style(none))
				ylab(, angle(horiz))
				ytitle("")
				
			)
			ylab(
				`log10' "10"
				`log20' "20"
				`log35' "35"
				`log100' "100"
				`log500' "500"
			)
			xlab(0 "Low" 1 "High")
			title("`mytitle'")
			xtitle("")
			recastci(rline)
			recast(line)
			plot1opts(lcol(black) lpat(solid) lwid(thick))
			ci1opts(lcol(black) lpat(solid) lwid(vthin))
			plot2opts(lcol(gray) lpat(solid) lwid(thick))
			ci2opts(lcol(gray) lpat(shortdash) lwid(vthin))
			`mylegend'
			name(g`dataset', replace)
			;
			
	#delimit cr
		
}

#delimit;

gr 
	combine 
		gsccbs ggss gssi
		,
			rows(1)
			ycommon
			b1title("Religious attendance")
			l1title("Total giving ($)")
			;
			
#delimit cr

local myfilename "figure1.eps"
gr export "`myfilename'", replace
shell epspdf "`myfilename'"
