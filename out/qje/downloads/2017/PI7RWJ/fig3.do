set more off
	/*
	Figure 3 (Panels) 
	A - all male
	B - all black 
	C - all female
	D - all white
	E - placebo male 
	F - placebo black 
	*/
	
/*define programs*/
cap program drop cr_fig3_data
program define cr_fig3_data

/*gen weights*/
	gen mw = pop1970_older  if yr == 0  /*gen maleweight*/
	replace mw = . if race_sex == 2  | race_sex  == 4 /*women*/
	bys sea: egen total_male = total(mw) 
	
	gen bw = pop1970_older  if yr == 0 /*gen blackweight*/
	replace bw = . if race_sex== 1  | race_sex== 2 /*whites*/
	bys sea: egen total_black = total(bw) 
	
	gen ww = pop1970_older if yr == 0  /*gen whiteweight*/
	replace ww = . if race_sex== 3  | race_sex== 4 /*blacks*/
	bys sea: egen total_white = total(ww) 
	
	gen fw = pop1970_older if yr == 0  /*gen femaleweight*/
	replace fw = . if race_sex== 1  | race_sex == 3 /*males*/
	bys sea: egen total_female = total(fw) 
	
	gen tp = pop1970_older if yr == 0 
	bys sea: egen total_pop = total(tp) 
	
/*gen distance from macon county bins at cuts of 150km */
	egen float distance_bins= cut(_macon_km ), at(0(150)3750)
	replace bmale_adult_pop = . if yrs != 0 | race_sex ! = 3 /*this value is from black men in 1970 but is filled in for each racesex category and each yr*/
	bys distance_bins : egen sumblackmen = total(bmale_adult_pop)
	sum sumblackmen, detail 
	replace distance_bins = 1950 if distance_bins == 1800 /*consolidating bins with small numbers of black men*/
	replace distance_bins = 2100 if distance_bins == 2250 | distance_bins == 2400  | distance_bins == 2550 
	replace distance_bins = 3000 if distance_bins == 2850 
	replace distance_bins = 3600 if distance_bins == 3450
	drop sumblackmen 
	
	gen wmale_adult_pop =pop1970_older  if race_sex == 1  & yr == 0 /*this value is from 1970 only*/
	gen bfemale_adult_pop =pop1970_older  if race_sex == 4 & yr == 0  /*this value is from 1970 only*/

	bys distance_bins : egen sumblackmen = total(bmale_adult_pop) 
	bys distance_bins : egen sumwhitemen = total(wmale_adult_pop) 
	bys distance_bins : egen sumblackwomen = total(bfemale_adult_pop) 
	
	
	bys distance_bins: egen grandtotal_female = total(total_female) 
	bys distance_bins: egen grandtotal_white = total(total_white) 
	bys distance_bins: egen grandtotal_black = total(total_black) 
	bys distance_bins: egen grandtotal_male = total(total_male) 

	
end

cap program drop average_coefficients
program define  average_coefficients

/*creates and stores average coefficients*/
	preserve
	keep if male == 1
	
 
	reg $outcome  black_male_post i.black_male i.post [aw=total_pop]
	global coef_male = _b[black_male_post]
	global se_male = _se[black_male_post]
	global constant_male  = _b[_cons]
	restore 
	
	preserve 
	keep if black == 1 
	 
	reg $outcome  black_male_post i.black_male i.post [aw=total_pop]
	global coef_black = _b[black_male_post]
	global se_black = _se[black_male_post]
	global constant_black = _b[_cons]
	restore
	
	preserve
	keep if white == 1 

 	reg $outcome  white_male_post i.white_male i.post [aw=total_pop ]
	global  coef_white = _b[white_male_post]
	global  se_white = _se[white_male_post]
	global constant_white = _b[_cons]
	restore
	
	preserve
	keep if female == 1

	reg $outcome  black_female_post i.black_female i.post  [aw=total_pop ]
	global  coef_female = _b[black_female_post]
	global  se_female = _se[black_female_post]
	global  constant_female = _b[_cons]
 	restore
	
end
	
/*load data*/
	use fig3data, clear
	set more off
/*run program*/
	cr_fig3_data
	
/*counts distance bins after re-group*/
	egen tag_db = tag(distance_bins) 
	count if tag_db == 1
	local upper = `r(N)'
	dis `upper'
	quietly tabulate distance_bins, generate(bin_)
	
/*gen variables*/
	gen black_female = (race_sex ==4 ) 
	gen white_male = (race_sex == 1) 
	gen black_male_post = black_male*post
	gen white_male_post = white_male* post
	gen black_female_post = black_female*post 
	gen female = (race_sex == 2 | race_sex == 4) 
	gen white = (race_sex == 1 | race_sex == 2) 

/*set up postfile*/
	postfile myfile2 bin dist coef_black_male_post se_black_male_post CIupper CIlower pop pop2 using dd_male.dta, replace 
	postfile myfile3 bin dist coef_black_male_post se_black_male_post CIupper CIlower pop pop2 using dd_black.dta, replace 
	postfile myfile4 bin dist coef_white_male_post se_white_male_post CIupper CIlower pop pop2 using dd_white.dta, replace 
	postfile myfile5 bin dist coef_black_female_post se_black_female_post CIupper CIlower pop pop2 using dd_female.dta, replace 

/*loop for reg results- black men vs. white men */
	forvalues i = 1(1)`upper' { 
	qui sum _macon_km if bin_`i' == 1 [aw=total_male], detail 
	local dist = r(p50)
	reg $outcome  black_male_post i.sea#i.black_male i.post if bin_`i' == 1 & male == 1 [aw=total_male]
	local coef_black_male_post = _b[black_male_post]
	local  se_black_male_post  = _se[black_male_post]
	sum sumblackmen if e(sample) == 1 
	local pop = `r(mean)'
	sum grandtotal_male if e(sample) == 1
	local pop2 = `r(mean)'
	local CIupper = `coef_black_male_post' + 1.96*`se_black_male_post'
	local CIlower = `coef_black_male_post' - 1.96*`se_black_male_post'
	post myfile2 (`i') (`dist') (`coef_black_male_post') (`se_black_male_post') (`CIupper') (`CIlower') (`pop') (`pop2') 
	}
	postclose myfile2
	
	
/*loop for reg results- black men vs. black women*/
	forvalues i = 1(1)`upper' { 
	qui sum _macon_km if bin_`i' == 1 [aw=total_black], detail 
	local dist = r(p50)
	reg $outcome black_male_post i.sea#i.black_male  i.post  if bin_`i' == 1 & black == 1 [aw=total_black]
	local coef_black_male_post = _b[black_male_post]
	local se_black_male_post  = _se[black_male_post]
	sum sumblackmen if e(sample) == 1 
	local pop = `r(mean)'
	sum grandtotal_black if e(sample) == 1
	local pop2 = `r(mean)'
	local CIupper = `coef_black_male_post' + 1.96*`se_black_male_post'
	local CIlower = `coef_black_male_post' - 1.96*`se_black_male_post'
	post myfile3 (`i') (`dist') (`coef_black_male_post') (`se_black_male_post') (`CIupper') (`CIlower') (`pop') (`pop2')
	}
	postclose myfile3 

	
/*loop for reg results- white men vs. white women*/
	forvalues i = 1(1)`upper' { 
	qui sum _macon_km if bin_`i' == 1 [aw=total_white], detail 
	local dist = r(p50)
	reg $outcome  white_male_post i.sea#i.white_male i.post if bin_`i' == 1 & black == 0 [aw=total_white]
	local coef_white_male_post = _b[white_male_post]
	local  se_white_male_post  = _se[white_male_post]
	sum sumwhitemen if e(sample) == 1 
	local pop = `r(mean)'
	sum grandtotal_white if e(sample) == 1
	local pop2 = `r(mean)'
	local CIupper = `coef_white_male_post' + 1.96*`se_white_male_post'
	local CIlower = `coef_white_male_post' - 1.96*`se_white_male_post'
	post myfile4 (`i') (`dist') (`coef_white_male_post') (`se_white_male_post') (`CIupper') (`CIlower') (`pop') (`pop2') 
	}
	postclose myfile4 
	
	
/*loop for reg results- black women vs. white women*/
	forvalues i = 1(1)`upper' { 
	qui sum _macon_km if bin_`i' == 1 [aw=total_female], detail 
	local dist = r(p50)
	reg $outcome black_female_post i.sea#i.black_female  i.post if bin_`i' == 1 & male== 0 [aw=total_female]
	local coef_black_female_post = _b[black_female_post]
	local  se_black_female_post  = _se[black_female_post]
	sum sumblackwomen if e(sample) == 1  
	local pop = `r(mean)'
	sum grandtotal_female if e(sample) == 1
	local pop2 = `r(mean)' 
	local CIupper = `coef_black_female_post' + 1.96*`se_black_female_post'
	local CIlower = `coef_black_female_post' - 1.96*`se_black_female_post'
	post myfile5 (`i') (`dist') (`coef_black_female_post') (`se_black_female_post') (`CIupper') (`CIlower') (`pop') (`pop2') 
	}
	postclose myfile5 
	
/*creates and stores average coefficients*/
	average_coefficients
	
/*create graphs*/
	use dd_male.dta, clear 
	rename dist distance_bins
	reg coef_black_male_post distance_bins [aw=pop2]
	global slope = _b[distance_bins]
	local cons = _b[_cons]
	scatter coef_black_male_post distance_bins [aw=pop], msymbol(Oh) || ///
	rspike CIupper CIlower distance_bins, lcolor(gs13) lpattern(shortdash_dot) || ///
	function y=(($slope *(x) + `cons')),  range(distance_bins) n(2) legend(off) legend(off) ///
	ylabel(-0.6(.2).6) lpattern(--)  lcolor(red) lwidth(medthick)    xtitle(Distance from Tuskegee) aspectratio(1.003)  ///
	ytitle(Black*Post Coefficient) yline($coef_male, lcolor(ebblue) lwidth(thick)  )
	dis $coef_male
	dis $se_male 
	dis $coef_male  + 1.96*$se_male
	dis $coef_male - 1.96*$se_male
	graph export "fig3_panelA.tif", replace 

	use dd_black.dta, clear 
	rename dist distance_bins
	reg coef_black_male_post distance_bins [aw=pop2]
	global slope = _b[distance_bins]
	local cons = _b[_cons]
	scatter coef_black_male_post distance_bins [aw=pop], msymbol(Oh) || ///
	rspike CIupper CIlower distance_bins, lcolor(gs13)  lpattern(shortdash_dot) || /// 
	function y=(($slope *(x) + `cons')),  range(distance_bins) n(2) legend(off)   legend(off) ///
	ylabel(-0.6(.2).6) lpattern(--)  lcolor(red) lwidth(medthick)   xtitle(Distance from Tuskegee) aspectratio(1.003)  ///
	ytitle(Male*Post Coefficient) yline($coef_black, lcolor(ebblue) lwidth(thick)  )
	dis $coef_black
	dis $se_black
    dis $coef_black + 1.96*$se_black
	dis $coef_black  - 1.96*$se_black
	graph export "fig3_panelB.tif", replace 


	use dd_female.dta, clear 
	rename dist distance_bins
	reg coef_black_female_post distance_bins [aw=pop2]
	global slope = _b[distance_bins]
	local cons = _b[_cons]	
	scatter coef_black_female_post distance_bins [aw=pop], msymbol(Oh) || ///
	rspike CIupper CIlower distance_bins, lcolor(gs13) lpattern(shortdash_dot)  || ///
	function y=(($slope *(x) + `cons')),  range(distance_bins) n(2) legend(off)  legend(off) ///
	ylabel(-0.6(.2).6) lpattern(--)  lcolor(red) lwidth(medthick)  xtitle(Distance from Tuskegee) aspectratio(1.003)  ///
	ytitle(Black*Post Coefficient) yline($coef_female, lcolor(ebblue) lwidth(thick) )
	dis $coef_female
	dis $se_female
	dis $coef_female  + 1.96*$se_female
	dis $coef_female - 1.96*$se_female 
	graph export "fig3_panelC.tif", replace 
	
	use dd_white.dta, clear 
	rename dist distance_bins
	reg coef_white_male_post distance_bins [aw=pop2]
	global slope = _b[distance_bins]
	local cons = _b[_cons]		
	scatter coef_white_male_post distance_bins [aw=pop], msymbol(Oh) || ///
	rspike CIupper CIlower distance_bins, lcolor(gs13) lpattern(shortdash_dot) || ///
	function y=(($slope *(x) + `cons')),  range(distance_bins) n(2) legend(off)  legend(off) ///
	ylabel(-0.6(.2).6) lpattern(--)  lcolor(red) lwidth(medthick)   xtitle(Distance from Tuskegee) aspectratio(1.003)  ///
	ytitle(Male*Post Coefficient) yline($coef_white, lcolor(ebblue) lwidth(thick) )
	dis $coef_white
	dis $se_white 
    dis $coef_white  + 1.96*$se_white
	dis $coef_white - 1.96*$se_white 
	graph export "fig3_panelD.tif", replace 
/*re-load data for placebo analysis*/
scalar drop _all
	use fig3data, clear
	
/*drop real post , gen fake post*/
	drop if yrs>=3
	drop post male_post black_post
	gen post = (yrs>=1) 
	
	cr_fig3_data

/*counts distance bins after re-group*/
	egen tag_db = tag(distance_bins) 
	count if tag_db == 1
	local upper = `r(N)'
	dis `upper'
	quietly tabulate distance_bins, generate(bin_)

/*gen variables*/
	gen black_female = (race_sex ==4 ) 
	gen white_male = (race_sex == 1) 
	gen black_male_post = black_male*post
	gen white_male_post = white_male* post
	gen black_female_post = black_female*post 
	gen female = (race_sex == 2 | race_sex == 4) 
	gen white = (race_sex == 1 | race_sex == 2) 
	gen male_post = male*post 
	gen black_post = black*post 
	
/*set up postfile*/
	postfile myfile6 bin dist coef_black_male_post se_black_male_post CIupper CIlower pop pop2 using dd_fpmale.dta, replace 
	postfile myfile7 bin dist coef_black_male_post se_black_male_post CIupper CIlower pop pop2 using dd_fpblack.dta, replace 


/*loop for reg results- black men vs. white men */
	forvalues i = 1(1)`upper' { 
	qui sum _macon_km if bin_`i' == 1 [aw=total_male], detail 
	local dist = r(p50)
	reg $outcome  black_male_post i.sea#i.black_male i.post if bin_`i' == 1 & male == 1 [aw=total_male]
	local coef_black_male_post = _b[black_male_post]
	local  se_black_male_post  = _se[black_male_post]
	sum sumblackmen if e(sample) == 1 
	local pop = `r(mean)'
	sum grandtotal_male if e(sample) == 1
	local pop2 = `r(mean)'
	local CIupper = `coef_black_male_post' + 1.96*`se_black_male_post'
	local CIlower = `coef_black_male_post' - 1.96*`se_black_male_post'
	post myfile6 (`i') (`dist') (`coef_black_male_post') (`se_black_male_post') (`CIupper') (`CIlower') (`pop') (`pop2')
	}
	postclose myfile6
	
	
/*loop for reg results- black men vs. black women*/
	forvalues i = 1(1)`upper' { 
	qui sum _macon_km if bin_`i' == 1 [aw=total_black], detail 
	local dist = r(p50)
	reg $outcome black_male_post i.sea#i.black_male  i.post  if bin_`i' == 1 & black == 1 [aw=total_black]
	local coef_black_male_post = _b[black_male_post]
	local se_black_male_post  = _se[black_male_post]
	sum sumblackmen if e(sample) == 1 
	local pop = `r(mean)'
	sum grandtotal_black if e(sample) == 1
	local pop2 = `r(mean)'
	local CIupper = `coef_black_male_post' + 1.96*`se_black_male_post'
	local CIlower = `coef_black_male_post' - 1.96*`se_black_male_post'
	post myfile7 (`i') (`dist') (`coef_black_male_post') (`se_black_male_post') (`CIupper') (`CIlower') (`pop') (`pop2')
	}
	postclose myfile7 
	
/*creates and stores average coefficients*/
	average_coefficients
	
/*create graphs*/
	use dd_fpmale.dta, clear 	
	rename dist distance_bins
	reg coef_black_male_post distance_bins [aw=pop2]
	global slope = _b[distance_bins]
	local cons = _b[_cons]
	scatter coef_black_male_post distance_bins [aw=pop], msymbol(Oh) || ///
	rspike CIupper CIlower distance_bins, lcolor(gs13) lpattern(shortdash_dot)  || ///
	function y=(($slope *(x) + `cons')),  range(distance_bins) n(2) legend(off)  legend(off) ///
	ylabel(-0.6(.2).6) lpattern(--)  lcolor(red) lwidth(medthick)   xtitle(Distance from Tuskegee) aspectratio(1.003)  ///
	ytitle(Black*Post Coefficient) yline($coef_male, lcolor(ebblue) lwidth(thick))
	dis $coef_male
	dis $se_male 
	dis $coef_male  + 1.96*$se_male
	dis $coef_male - 1.96*$se_male
	graph export "fig3_panelE.tif", replace 

	use dd_fpblack.dta, clear 
	rename dist distance_bins
	replace CIlower = . if CIlower<-.6
	replace CIupper = . if CIupper >.6
	reg coef_black_male_post distance_bins [aw=pop2]
	global slope = _b[distance_bins]
	local cons = _b[_cons]
	scatter coef_black_male_post distance_bins [aw=pop], msymbol(Oh) || ///
	rspike CIupper CIlower distance_bins, lcolor(gs13)  lpattern(shortdash_dot) || /// 
	function y=(($slope *(x) + `cons')),  range(distance_bins) n(2) legend(off) legend(off) ///
	ylabel(-0.6(.2).6) lpattern(--)  lcolor(red) lwidth(medthick)   xtitle(Distance from Tuskegee) aspectratio(1.003)  ///
	ytitle(Male*Post Coefficient) yline($coef_black, lcolor(ebblue) lwidth(thick))
	dis $coef_black
	dis $se_black
    dis $coef_black + 1.96*$se_black
	dis $coef_black  - 1.96*$se_black
	graph export "fig3_panelF.tif", replace 
	

	
	
