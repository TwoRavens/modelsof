use "basic_data_labelled" , clear

set scheme s1mono

global varlist "ec_future ue_future"

/* CALCULATING MEDIAN AND OTHER PERCENTILES*/

global start = "1994m1"
global end = "2001m12"

gen shading = 2 if tin($start, $end)
replace shading =9 if tin(1998m7, 1999m12)
label var shading "Uncertainty Period"

capture program drop percentile2
program define percentile2
	tempvar obs
	gen `obs'=_n
	args var num 
	gen `var'_`num' = 0
	bysort `obs': replace `var'_`num' = -2 if `var'_temp1>= `num' 
	bysort `obs': replace `var'_`num' = -1 if `var'_temp1<= `num'  & `var'_temp2>= `num'
	bysort `obs': replace `var'_`num' = 0 if `var'_temp2<= `num'  & `var'_temp3>= `num' 
	bysort `obs': replace `var'_`num' = 1 if `var'_temp3<= `num'  & `var'_temp4>= `num' 
	bysort `obs': replace `var'_`num' = 2 if `var'_temp4<= `num' 
	label var `var'_`num' "`num'th percentile"
end

capture program drop percentile
program define percentile
while "`1'"!="" {
	egen float `1'_temp1 = rowtotal(`1'_mm)
	egen float `1'_temp2 = rowtotal(`1'_mm `1'_m)
	egen float `1'_temp3 = rowtotal(`1'_mm `1'_m  `1'_n )
	egen float `1'_temp4 = rowtotal(`1'_mm `1'_m  `1'_n  `1'_p)
	egen float `1'_temp5 = rowtotal(`1'_mm `1'_m  `1'_n  `1'_p  `1'_pp)
	replace `1'_temp1 = `1'_temp1/`1'_temp5*100
	replace `1'_temp2 = `1'_temp2/`1'_temp5*100
	replace `1'_temp3 = `1'_temp3/`1'_temp5*100
	replace `1'_temp4 = `1'_temp4/`1'_temp5*100
	replace `1'_temp5 = `1'_temp5/`1'_temp5*100
	percentile2 `1' 10
	percentile2 `1' 25
	percentile2 `1' 50
	percentile2 `1' 75
	percentile2 `1' 90
	drop `1'_temp*
	macro shift
	}
end

percentile $varlist

* NOW TO CALCULATE THE STANDARD ERROR BANDS TOO

capture program drop bands
program define bands
while "`1'"!="" {
	egen temp_a = sd(wm_`1') 
	gen float `1'_neg = wm_`1' - temp_a
	gen float `1'_mean = wm_`1' 
	gen float `1'_pos = wm_`1' + temp_a
	lab var `1'_neg "Mean - 1SD"
	lab var `1'_mean "Mean"
	lab var `1'_pos "Mean + 1SD"
	drop temp_a
	macro shift
	}
end

bands $varlist

* ADD KOHL REFORM TO CHARTS AND LOOK AT....

capture program drop my_graphs
program define my_graphs
local election_line "tline(1998m9 , lwidth(thin) lpattern(dash) lcolor(red) noextend)"
local reform_line "tline(1997m8, lwidth(thin) lpattern(dash) lcolor(red) noextend)" 
while "`1'"!="" {
	local text1 = wm_`1'+wsd_`1'
	local text2 = wm_`1'-wsd_`1'
	#delimit ;
	twoway  (tsline `1'_pos if tin($start, $end), lcolor(blue) lwidth(thin) lpattern(dash) ttitle("Date")  
	`election_line'  )
      (tsline `1'_neg if tin($start, $end), lcolor(blue) lwidth(thin) lpattern(dash) )
      (tsline `1'_mean if tin($start, $end), lcolor(black) lwidth(medium) lpattern(solid))
      , nodraw legen(on) ytitle("Answer: Positive implies increase", size(small)) ttitle("Date", size(small)) title("Mean and standard deviation of the answers", size(medsmall)) 
     	fxsize(150)
	legend(pos(3)  order(1 3 2) textwidth(15) ring(1) size(vsmall) cols(1) symxsize(4) rowgap(1)  region(fcolor(none) lstyle(none)) );
	#delimit cr
	macro shift
	}
end

capture program drop my_graphs_ue
program define my_graphs_ue
local election_line "tline(1998m9 , lwidth(thin) lpattern(dash) lcolor(red) noextend)"
local reform_line "tline(1997m8, lwidth(thin) lpattern(dash) lcolor(red) noextend)" 
while "`1'"!="" {
	egen temp_a = mean(`1'_u)
	egen temp_b = sd(`1'_u) 
	local text1 = temp_a-temp_b
	local text2 = temp_a-1.5*temp_b
	tssmooth ma  `1'_smooth = `1'_u, window(1 1 1) replace
	label var `1'_smooth "3-month MA"
	egen temp_c = sd(`1'_smooth)
	gen `1'_smooth_plus = `1'_smooth + temp_c
	label var `1'_smooth_plus "+ 1 SD"
	gen `1'_smooth_minus = `1'_smooth - temp_c 
	label var `1'_smooth_minus "- 1 SD"
	#delimit ;
	twoway  (tsline `1'_smooth if tin($start, $end), lcolor(black) lwidth(medium) lpattern(solid) /*ytitle("TEST")*/ ttitle("Date") 
	`election_line' ttext( 2 1999m3 "Election", size(small) color(red))  )
	(tsline `1'_smooth_plus if tin($start, $end), lcolor(green) lwidth(thin) lpattern(dash))
	(tsline `1'_smooth_minus if tin($start, $end), lcolor(green) lwidth(thin) lpattern(dash))
      , nodraw legend(on) ytitle("% who are Uncertain" , size(small)) ttitle("Date", size(small)) title("Respondents who answer that they are Uncertain (%)", size(medsmall)) 
	fxsize(150) ysc(r(8))
	legend(pos(3)  order(2 1 3) textwidth(15) ring(1) size(vsmall) cols(1)  symxsize(4) rowgap(1) region(fcolor(none) lstyle(none)) );
	#delimit cr
	drop temp_* `1'_smooth_*
	macro shift
	}
end

capture program drop my_graphs_two
program define my_graphs_two
while "`1'"!="" {
	if "`1'" == "ue_future"  {  
		local title="Expectations for Unemployment"
	}
	else if "`1'" == "major_future"  {    
		local title="Expectations for Major Purchases"
	}
	else if "`1'" == "ec_future"  {  
		local title="Expectations for General Economic Situation"
	}
	else if "`1'" == "fin_future"  { 
		local title="Expectations for Household Finances"
	}
	else if "`1'" == "save_future"  { 
		local title="Expectations for Household Saving"
	}
	else {
		local title="ADD TITLE"
	}
	my_graphs `1'
	graph save "`1'_main" , replace
	my_graphs_ue `1'
	graph save "`1'_uncertain" , replace
	#delimit ;
	graph combine "`1'_main" "`1'_uncertain"
	, colfirst xcommon cols(1) 
	graphregion(margin(l=10 r=10))
	scale(1);
	#delimit cr
	graph export "C:\Users\Michael McMahon\Dropbox\GSOEP21\GiavazziMcMahonReStat\graph_`1'.eps", replace as(eps)
	erase "`1'_main.gph"
	erase "`1'_uncertain.gph"
	macro shift
	}
end

my_graphs_two  $varlist
