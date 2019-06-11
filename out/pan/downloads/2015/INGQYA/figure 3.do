set more off

use "ssi october 2012", clear

replace predict_winner = predict_winner * 100

su predict_obama, det
local x predict_obama
keep if `x' > 0 & `x' < 100

drop if mi(obama_vote)


#delimit;

collapse 
	y1=obama_vote y2=predict_winner y3=predict_obama
	(semean)
	se1=obama_vote se2=predict_winner se3=predict_obama
	,
	by(pid3)
	;

#delimit cr

gen index = _n
reshape i index
reshape j measure
reshape xij y se
reshape long


gen ub = y + 1.96*se
gen lb = y - 1.96*se

#delimit;

gr tw
	(con y measure if pid3 == 1, col(black) msize(vlarge))
	(rcap ub lb measure if pid3 == 1, col(black) lwid(thick))
	(con y measure if pid3 == 3, col(black) msize(vlarge))
	(rcap ub lb measure if pid3 == 3, col(black) lwid(thick))
	(con y measure if pid3 == 2, col(black) msize(vlarge))
	(rcap ub lb measure if pid3 == 2, col(black) lwid(thick))


	,
		legend(off)
		ytitle("Prediction")
		ylab(, angle(horiz))
		xtitle("")
		xlab(1 `""Voter" "intentions""' 2 `" "Winner" "prediction"' 3 `" "Voteshare" "prediction""')
		xscale(range(0.5 3.5))
		plotregion(style(none))
		text(92.9 1.5 "Democrats", col(black))
		text(70.9 1.35 "Independents", col(black))
		text(18 1.15 "Republicans", col(black))	
		;
		
#delimit cr

gr export "figure3.eps", replace
