version 14
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
	figure_A8
	figure_trend
end

program figure_A8
	use ../temp/exhibit_analysis, clear
	count if enrollee_9m == 1 & control == 1
	local N_enrollee = r(N)
	
	gen SNAP_Benefits = snap_benefits_9m
	replace SNAP_Benefits = 501 if SNAP_Benefits > 500 & SNAP_Benefits != .
	
	gen benefit_temp = SNAP_Benefits if inlist(SNAP_Benefits, 16, 194, 357) == 1
	gen Itemp = inlist(SNAP_Benefits, 16, 194, 357) == 1
	replace SNAP_Benefits = . if inlist(SNAP_Benefits, 16, 194, 357) == 1
	
	replace SNAP_Benefits = 0 if SNAP_Benefits >= 0 & SNAP_Benefits < 8
	replace SNAP_Benefits = 8 if SNAP_Benefits >= 8 & SNAP_Benefits < 16
	gen n = .
	local i = 17
	forval x = 3/24 {
		replace SNAP_Benefits = `i' if SNAP_Benefits >= `i' & SNAP_Benefits < `i'+8 & SNAP_Benefits != .
		replace n = `x' if SNAP_Benefits == `i'
		local i = `x'*8 + 1
		di "i is `i'"
	}
	replace SNAP_Benefits = 185 if SNAP_Benefits == 193
	local i = 195
	forval x = 25/44 {
		replace SNAP_Benefits = `i' if SNAP_Benefits >= `i' & SNAP_Benefits < `i'+8 & SNAP_Benefits != .
		replace n = `x' if SNAP_Benefits == `i'
		local i = `x'*8 + 3
		di "i is `i'"
	}
	replace SNAP_Benefits = 347 if SNAP_Benefits == 356 | SNAP_Benefits == 355
	local i = 358
	forval x = 45/61 {
		replace SNAP_Benefits = `i' if SNAP_Benefits >= `i' & SNAP_Benefits < `i'+8 & SNAP_Benefits != .
		replace n = `x' if SNAP_Benefits == `i'
		local i = `x'*8 + 6
		di "i is `i'"
	}
	replace SNAP_Benefits = 494 if SNAP_Benefits >= 494 & SNAP_Benefits <= 500
	
	replace SNAP_Benefits = benefit_temp if Itemp == 1
	drop Itemp benefit_temp
	keep if control == 1 & !mi(SNAP_Benefits)
	
	gen number = 1
	collapse (sum) number (mean) n, by(SNAP_Benefits)
	set obs 66
	tsset n
	tsfill
	replace SNAP_Benefits = n*8-7 if number == . & n>= 3 & n <= 24
	replace SNAP_Benefits = n*8-5 if number == . & n>= 25 & n <= 44
	replace SNAP_Benefits = n*8-2 if number == . & n>= 45 & n <= 60
	sort SNAP_Benefits
	gen id= _n
	
	***************************Manual Start
	replace SNAP_Benefits = 494 if id == 65
	replace SNAP_Benefits = 501 if id == 66
	replace SNAP_Benefits = 508 if id == 67
	drop id
	sort SNAP_Benefits
	gen id= _n
	***************************Manual End
	assert SNAP_Benefits == 501 if id == 66
	replace number = 0 if number == .
	drop n
	sum number
	local N = r(N)*r(mean)
	drop id
	
	di "`N' people have benefit"
	gen percent = number/`N'*100
	sort SNAP_Benefits
	
	twoway (bar percent SNAP_Benefits if SNAP_Benefits < 510, bartype(spanning) bstyle(histogram) bcolor(sand)) ///
		   (bar percent SNAP_Benefits if inlist(SNAP_Benefits, 16, 194, 357) == 1, 		///
		   bstyle(histogram) bcolor(edkblue) graphregion(fcolor(white))  ///
		   legend(off) xtitle("Monthly SNAP Benefit") ///
		   xlabel(0 `" " " "0" "' 100 `" " " "100" "' 200 `" " " "200" "' 300 `" " " "300" "' 400 `" " " "400" "' 503 `" " " ">= 500" "', ///
		   labcolor(black) labsize(small)) 			///
		   xmlabel(16 194 357, labcolor(gs5) labsize(small)))
		   
	graph_export_convert, graph("../output/figure_A8")
end

program figure_trend
	foreach v in applicant enrollee caller caller_adj {
		use ../temp/exhibit_analysis, clear
		keep *weight hightouch lowtouch_s treat_group control applicant_*m enrollee_*m Icaller_*_adj Icaller_*m
		foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 {
			rename Icaller_`i'm caller_`i'm										
            rename Icaller_`i'm_adj caller_adj_`i'm
			reg `v'_`i'm hightouch [pw=pweight] if hightouch == 1 | control == 1, robust
			matrix results = r(table)
			matrix `v'_`i' = `i', results[1,1], results[5,1], results[6,1]
			reg `v'_`i'm lowtouch_s [pw=pweight] if lowtouch_s == 1 | control == 1, robust
			matrix results = r(table)
			matrix `v'_`i' = `v'_`i', results[1,1], results[5,1], results[6,1]
			matrix `v' = nullmat(`v') \ `v'_`i'
		}
		matrix colnames `v' = period `v'_ht_mean `v'_ht_lb `v'_ht_ub `v'_lt_mean `v'_lt_lb `v'_lt_ub
		clear
		svmat `v', names(col)
		save ../temp/figure_`v', replace
	}
	merge 1:1 period using ../temp/figure_applicant, assert(3) nogen
	merge 1:1 period using ../temp/figure_enrollee, assert(3) nogen
    merge 1:1 period using ../temp/figure_caller, assert(3) nogen
	save ../temp/figure_app_6, replace
	
	use ../temp/figure_app_6, clear
	local applicant_ytitle "Treatment Effect"
	local enrollee_ytitle "Treatment Effect"
	local caller_ytitle "Mean"
    local caller_adj_ytitle "Mean"
	foreach v in applicant enrollee {
		twoway (scatter `v'_ht_mean period, msymbol(circle) msize(small) mcolor(gs1) c(L) lc(gs2))		///
			   (scatter `v'_ht_lb period, msymbol(circle) mcolor(gs10) msize(tiny) c(L) lp(dash) lc(gs15))		///
			   (scatter `v'_ht_ub period, msymbol(circle) mcolor(gs10) msize(tiny) c(L) lp(dash) lc(gs15))		///
			   (scatter `v'_lt_mean period, msymbol(triangle) msize(small) mcolor(gs7) c(L) lc(gs7) xlabel(1(1)23) 						///
			   xtitle("Number of Months after Initial Mailing")	ylabel(0 .05 .1 .15 .2 .25 .3)	///
			   ytitle("``v'_ytitle'") graphregion(fcolor(white)) legend(order(4 "Information Only" 1 "Information plus Assistance")))		///
			   (scatter `v'_lt_lb period, msymbol(triangle) mcolor(gs10) msize(tiny) c(L) lp(dash) lc(gs15))		///
			   (scatter `v'_lt_ub period, msymbol(triangle) mcolor(gs10) msize(tiny) c(L) lp(dash) lc(gs15))
		graph_export_convert, graph("../output/figure_trend_`v'_23m")
	}

	drop if period > 7
    foreach v in caller caller_adj {
        twoway (scatter `v'_ht_mean period, msymbol(circle) msize(small) mcolor(gs1) c(L) lc(gs2))		///
                (scatter `v'_lt_mean period, msymbol(triangle) msize(small) mcolor(gs7) c(L) lc(gs7) xlabel(1(1)7) 						///
                xtitle("Number of Months after Initial Mailing") ylabel(0 .05 .1 .15 .2 .25 .3)	///
                ytitle("``v'_ytitle'") graphregion(fcolor(white)) legend(order(2 "Information Only" 1 "Information plus Assistance")))
        graph_export_convert, graph("../output/figure_app_trend_7m")			
    }
end

	program graph_export_convert
		syntax, graph(str)
		graph export `graph'.eps, replace
		shell convert -density 500 `graph'.eps -quality 100 `graph'.png
		shell rm ../output/`graph'.eps
	end

main
