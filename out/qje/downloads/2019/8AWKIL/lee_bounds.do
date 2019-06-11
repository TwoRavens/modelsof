version 14
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
	lee_effect
	fill_tables, mat(Appendix_lee) save_excel(../output_excel/lee_bounds.xlsx)
	fill_tables, mat(lee_stats) save_excel(../output_excel/lee_bounds.xlsx)
end

program lee_effect
    set seed 1234
	use ../temp/exhibit_analysis, clear
	foreach v in Imin_benefit_9m I194_benefit_9m I357_benefit_9m {
		replace `v' = . if Imiss_benefit_9m == 1
	}
	foreach v in snap_benefits_9m Imin_benefit_9m I194_benefit_9m I357_benefit_9m {
		sum `v' if control == 1 & enrollee_9m == 1
		local `v'_c = r(mean)
		mat `v' = ``v'_c' \ . \.
		foreach t in lowtouch_s hightouch {
			leebounds `v' `t' [pw=pweight] if (`t' == 1 | control == 1) & enrollee_9m == 1, vce(boot)
			mat results_b = r(table)
			local `t'_control = e(trim)
			mat `v'_`t' = (``v'_c'+results_b[1,1] , ``v'_c'+results_b[1,2]) \ (results_b[4,1] , results_b[4,2])
            leebounds `v' `t' [pw=pweight] if (`t' == 1 | control == 1) & enrollee_9m == 1, vce(ana)
			mat results_a = r(table)
			mat `v'_`t' = `v'_`t' \ (results_a[4,1] , results_a[4,2])
		}
		mat `v' = `v' ,`v'_lowtouch_s , `v'_hightouch
		leebounds `v' hightouch [pw=pweight] if (hightouch == 1 | lowtouch_s == 1) & enrollee_9m == 1, vce(boot)
		mat results_b = r(table)
		local high_low = e(trim)
        leebounds `v' hightouch [pw=pweight] if (hightouch == 1 | lowtouch_s == 1) & enrollee_9m == 1, vce(ana)
		mat results_a = r(table)
		mat `v' = `v' , ((.,.) \ (results_b[4,1] , results_b[4,2]) \ (results_a[4,1] , results_a[4,2]) )
		mat Appendix_lee = nullmat(Appendix_lee) \ `v'
	}
	foreach a in control lowtouch_s hightouch {
		sum Imiss_benefit_9m if `a' == 1 & enrollee_9m == 1 [aw=aweight]
		mat `a' = r(mean)
		sum snap_benefits_9m if `a' == 1 & enrollee_9m == 1 [aw=aweight]
		mat `a' = `a' \ r(max) \ r(min)
	}
	foreach a in lowtouch_s hightouch {
		preserve
		keep if `a' == 1 & enrollee_9m == 1 & Imiss_benefit_9m != 1
		count
		local `a'_trim = round(r(N)*``a'_control')
		gsort -snap_benefits_9m
		gen ID = _n
		drop if ID <= ``a'_trim'
		sum snap_benefits_9m if `a' == 1 & enrollee_9m == 1 [aw=aweight]
		mat `a' = `a' \ ``a'_control' \ r(max)
		restore
		
		preserve
		keep if `a' == 1 & enrollee_9m == 1 & Imiss_benefit_9m != 1
		count
		local `a'_trim = round(r(N)*``a'_control')
		sort snap_benefits_9m
		gen ID = _n
		drop if ID <= ``a'_trim'
		sum snap_benefits_9m if `a' == 1 & enrollee_9m == 1 [aw=aweight]
		mat `a' = `a' \ r(min)
		restore
	}
	preserve
	keep if hightouch == 1 & enrollee_9m == 1 & Imiss_benefit_9m != 1
	count
	local h_trim = round(r(N)*`high_low')
	gsort -snap_benefits_9m
	gen ID = _n
	drop if ID <= `h_trim'
	sum snap_benefits_9m if hightouch == 1 & enrollee_9m == 1 [aw=aweight]
	mat hightouch = hightouch \ `high_low' \ r(max)
	restore
	
	preserve
	keep if hightouch == 1 & enrollee_9m == 1 & Imiss_benefit_9m != 1
	count
	local h_trim = round(r(N)*`high_low')
	sort snap_benefits_9m
	gen ID = _n
	drop if ID <= `h_trim'
	sum snap_benefits_9m if hightouch == 1 & enrollee_9m == 1 [aw=aweight]
	mat hightouch = hightouch \ r(min)
	restore
	mat control = control \ J(6,1,.)
	mat lowtouch_s = lowtouch_s \ J(3,1,.)
	mat lee_stats = control , lowtouch_s , hightouch
end

main
