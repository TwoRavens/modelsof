set more off

use "ssi october 2012", clear


foreach x in predict_obama {
	su `x', det
	keep if `x' > 0 & `x' < 100
	su `x'
}


local h 5

forvalues i = 1(1)4 {

	preserve
	
		if `i' == 1 local mytitle "Democrats"
		if `i' == 2 local mytitle "Independents"
		if `i' == 3 local mytitle "Republicans"
		if `i' == 4 local mytitle "Full sample"
	
		if `i' < 4 keep if pid3 == `i'
			
		su predict_obama
		local vhat = r(mean)
		local bias = string(r(mean) - 51.9, "%20.02fc")
		local myN = r(N)
		ci predict_obama
		reg predict_obama
		test _cons = 50

		twoway__histogram_gen predict_obama, width(`h') gen(x y)
		su x
		local ub = r(max)
		local lb = r(min)
		
		di `ub' `lb'

		#delimit;

		gr tw 
			(hist predict_obama, fcol(white) lcol(black) width(`h'))
			(pci 0 51.9 `ub' 51.9, lwid(thick) lcol(black) lpat(dash))

			,
				ylab(, angle(horiz))
				xlab(0(10)100)
				ytitle("Density")
				xtitle("Predicted Democratic voteshare")
				title(`mytitle', size(huge))
				
				legend(off)
				scheme(s1manual)
				plotregion(style(none))
				yscale(off)
				subtitle(Bias = `bias', size(large))
				;
				
		#delimit cr

	gr export "figure1-`i'.eps", replace
	
	restore

}

