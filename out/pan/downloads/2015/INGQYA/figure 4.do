set more off

use "ssi october 2012", clear

replace predict_winner = predict_winner * 100

su predict_obama, det
keep if predict_obama > 0 & predict_obama < 100
su predict_obama, det



#delimit;

collapse 
	y1=obama_vote y2=predict_winner y3=predict_obama
	(semean)
	se1=obama_vote se2=predict_winner se3=predict_obama
	,
	by(pid3 info_scale)
	;

#delimit cr

gen index = _n
reshape i index
reshape j measure
reshape xij y se
reshape long


gen ub = y + 1.96*se
gen lb = y - 1.96*se

keep if !mi(y) & !mi(pid3) & !mi(info_scale)

foreach i in 2 {

	if `i' == 2 local mytitle "Winner prediction"
	if `i' == 3 local mytitle "Voteshare prediction"

	if `i' == 2 local myscale 0(20)100
	if `i' == 3 local myscale 45(5)65
	
	local mytext2 " "
	local mytext3 " "
	local mytext4 " "
	
	if `i' == 2 local mytext2 "85.9 0.3 " Democrats""
	if `i' == 2 local mytext3 "33.9 0.3 " Republicans""	
	if `i' == 2 local mytext4 "60.0 0.6 " Independents", col(gs10)"	

	#delimit;

	gr tw 
		(rcap ub lb info_scale if measure == `i' & pid3 == 2, col(gs10) lpat(solid))
		(con y info_scale if measure == `i' & pid3 == 2, msym(t)  lpat(solid) col(gs10) msize(vlarge))
		
		(con y info_scale if measure == `i' & pid3 == 1, msym(O) col(black) msize(vlarge) lpat(solid))
		(rcap ub lb info_scale if measure == `i' & pid3 == 1, col(black))
		
		(con y info_scale if measure == `i' & pid3 == 3, msym(s) col(black) msize(vlarge) lpat(shortdash))
		(rcap ub lb info_scale if measure == `i' & pid3 == 3, col(black))	
		,
			plotregion(style(none))
			xlab(0(0.25)1)
			ytitle("Winner prediction")
			ylab(`myscale', angle(horiz))
			legend(off)
			text(`mytext2')
			text(`mytext3')
			text(`mytext4')
			;

	#delimit cr
	
	local j = `i' - 1
	
	gr export "figure4.eps", replace

}
