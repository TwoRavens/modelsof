set more off

use "reassessments", clear

merge m:m swis_code year using "switchers"

replace reass = reass*100

keep if _m == 3

drop _m

keep if year > 1986

keep if mi(Dyr_ub)

gen D_5 = year - Dyr == -5
gen D_4 = year - Dyr == -4
gen D_3 = year - Dyr == -3
gen D_2 = year - Dyr == -2
gen D_1 = year - Dyr == -1
gen D0 = year - Dyr == 0
gen D1 = year - Dyr == 1
gen D2 = year - Dyr == 2
gen D3 = year - Dyr == 3
gen D4 = year - Dyr == 4
gen D5 = year - Dyr >= 5
replace D5 = 0 if mi(Dyr) // important

parmby "xi: areg reass D_5 D_4 D_3 D_2 D_1 D0 D1 D2 D3 D4 D5 i.year, a(swis) cl(swis)", fast

keep if parmseq <= 11
replace parmseq = parmseq - 6


#delimit;

gr tw

	(line min max parmseq if parmseq <= 0,  lcol(black black) lpat(shortdash shortdash))
	(line est parmseq if parmseq <=0, lpat(solid) lcol(black) lwid(thick))
	(line min max parmseq if parmseq >= 0,  lcol(black black) lpat(shortdash shortdash))
	(line est parmseq if parmseq >=0, lpat(solid) lcol(black) lwid(thick))
	(scatteri 0 -5 0 5, c(l) m(i) col(black) lpat(solid) lwid(thin))
	(scatteri -10.5 0 30 0, c(l) m(i) col(black) lpat(solid) lwid(thin))

	,

		xlab(-5(1)5)
		plotregion(style(none))
		legend(off)
		ylab(, angle(horizontal) format(%10.0f))
		l2title("Difference in reassessments")
		xtitle("Years since switch to appointed assessor")
		text(31.5 -.1 "Before appointed", placement(left) col(black))
		text(31.5 .1 "After appointed", placement(right))

		ytitle("")
		;
		
#delimit cr


gr export "figure 3.eps", replace
