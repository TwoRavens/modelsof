	clear all
	do "E:/Dropbox/CleanWaterAct/codeSTATA/keiserShapiro_replication/1_header.do"

		
	capture program drop main
	program define main
		mapWwtf
		mapMonitors
		graphTrends	
		graphImpact
		graphHousing
		tableTrends
		tableImpact
		tableCosteff
		tablePassthru
		tableHousing
		tableCB

	end

		
	cap pr drop mapWwtf
	pr de mapWwtf
		u "cwns/cwns_formap.dta", clear
		ren id_facility id_fac
		export dbase using "results/maps/latlon_wwtf.dbf", replace
	end

	cap pr drop mapMonitors
	pr de mapMonitors
		u "combined/stations_formap.dta", clear
		export dbase using "results/maps/latlon_stations.dbf", replace
	end

	cap pr drop graphTrends
	pr de graphTrends
		foreach p in "fishable" "do_perc_plusmgl" {

			if "`p'" == "fishable"        u "water_quality/trendsReg_fishableswimmable.dta", clear 
			if "`p'" == "do_perc_plusmgl" u "water_quality/trendsReg_do_perc_plusmgl.dta", clear 

			forv y = 1963/2001 {
				g byte year_`y' = year == `y'
				}

			if "`p'" == "fishable"        areg not`p'      year_* $Xtrends, absorb(id_station) cluster(id_watershed) 
			if "`p'" == "do_perc_plusmgl" areg resultvalue year_* $Xtrends, absorb(id_station) cluster(id_watershed) 
			

			g xb = _b[_cons] in 1
			g ci_hi = _b[_cons] + 1.96*_se[_cons] in 1
			g ci_lo = _b[_cons] - 1.96*_se[_cons] in 1
			forv y = 1963/2001 {
				loc n = `y'-1961
				lincom _cons + year_`y'
				replace xb    = r(estimate) in `n'
				replace ci_hi = r(estimate) + 1.96 * r(se) in `n'
				replace ci_lo = r(estimate) - 1.96 * r(se) in `n'
				}
			g x = _n + 1961 in 1/40

			if "`p'" == "fishable"        loc ytit "Share Not Fishable"
			if "`p'" == "do_perc_plusmgl" loc ytit "Saturation Deficit (Percent)"

			tw (connected xb x in 1/40) ///
				(line ci_hi x in 1/40, lpattern(dash) lcolor(maroon)) ///
				(line ci_lo x in 1/40, lpattern(dash) lcolor(maroon)), ///
				graphr(color(white)) ///
				yscale(noline) ///
				legend(off) ///
				xtit("Year") ///
				ytit("`ytit'") ///
				subtit("") ///
				yline(0, lcolor(black)) ///
				xline(1972) ///
				xlab(1962 1972 1982 1992 2001)
			graph save "results/figures/f2_`p'.gph", replace
			graph export "results/figures/f2_`p'.wmf", replace

		}
	end

	cap pr drop graphImpact
	pr de graphImpact
		foreach p in "do_perc_plusmgl" "fishable" {


			if "`p'" != "fishable" u "water_quality/ddd_`p'.dta", clear
			if "`p'" == "fishable" u "water_quality/ddd_fishableswimmable.dta", clear

			if "`p'" != "fishable" loc resultvalue resultvalue
			if "`p'" == "fishable" loc resultvalue notfishable
			
			reghdfe `resultvalue' downstreamXtau_* [aw=Nobs], ///
				absorb(id_facilityXdownstream id_facilityXyear downstreamXid_basinXyear) ///
				vce(cluster id_watershed) fast

			cap drop xb ci_hi ci_lo x
			g       xb = _b[downstreamXtau_m1099]  in 1
			replace xb = _b[downstreamXtau_m0907]  in 2
			replace xb = _b[downstreamXtau_m0604]  in 3
			replace xb = _b[downstreamXtau_m0301]  in 4
			replace xb = _b[downstreamXtau_0002]   in 5
			replace xb = _b[downstreamXtau_0305]   in 6
			replace xb = _b[downstreamXtau_0608]   in 7
			replace xb = _b[downstreamXtau_0911]   in 8
			replace xb = _b[downstreamXtau_1214]   in 9
			replace xb = _b[downstreamXtau_1517]   in 10
			replace xb = _b[downstreamXtau_1820]   in 11
			replace xb = _b[downstreamXtau_2123]   in 12
			replace xb = _b[downstreamXtau_2426]   in 13
			replace xb = _b[downstreamXtau_2729]   in 14
			replace xb = _b[downstreamXtau_3099]   in 15
			g       ci_hi = _b[downstreamXtau_m1099] + 1.96 * _se[downstreamXtau_m1099] in 1
			replace ci_hi = _b[downstreamXtau_m0907] + 1.96 * _se[downstreamXtau_m0907] in 2
			replace ci_hi = _b[downstreamXtau_m0604] + 1.96 * _se[downstreamXtau_m0604] in 3
			replace ci_hi = _b[downstreamXtau_m0301] + 1.96 * _se[downstreamXtau_m0301] in 4
			replace ci_hi = _b[downstreamXtau_0002]  + 1.96 * _se[downstreamXtau_0002]  in 5
			replace ci_hi = _b[downstreamXtau_0305]  + 1.96 * _se[downstreamXtau_0305]  in 6
			replace ci_hi = _b[downstreamXtau_0608]  + 1.96 * _se[downstreamXtau_0608]  in 7
			replace ci_hi = _b[downstreamXtau_0911]  + 1.96 * _se[downstreamXtau_0911]  in 8
			replace ci_hi = _b[downstreamXtau_1214]  + 1.96 * _se[downstreamXtau_1214]  in 9
			replace ci_hi = _b[downstreamXtau_1517]  + 1.96 * _se[downstreamXtau_1517]  in 10
			replace ci_hi = _b[downstreamXtau_1820]  + 1.96 * _se[downstreamXtau_1820]  in 11
			replace ci_hi = _b[downstreamXtau_2123]  + 1.96 * _se[downstreamXtau_2123]  in 12
			replace ci_hi = _b[downstreamXtau_2426]  + 1.96 * _se[downstreamXtau_2426]  in 13
			replace ci_hi = _b[downstreamXtau_2729]  + 1.96 * _se[downstreamXtau_2729]  in 14
			replace ci_hi = _b[downstreamXtau_3099]  + 1.96 * _se[downstreamXtau_3099]  in 15
			g       ci_lo = _b[downstreamXtau_m1099] - 1.96 * _se[downstreamXtau_m1099] in 1
			replace ci_lo = _b[downstreamXtau_m0907] - 1.96 * _se[downstreamXtau_m0907] in 2
			replace ci_lo = _b[downstreamXtau_m0604] - 1.96 * _se[downstreamXtau_m0604] in 3
			replace ci_lo = _b[downstreamXtau_m0301] - 1.96 * _se[downstreamXtau_m0301] in 4
			replace ci_lo = _b[downstreamXtau_0002]  - 1.96 * _se[downstreamXtau_0002]  in 5
			replace ci_lo = _b[downstreamXtau_0305]  - 1.96 * _se[downstreamXtau_0305]  in 6
			replace ci_lo = _b[downstreamXtau_0608]  - 1.96 * _se[downstreamXtau_0608]  in 7
			replace ci_lo = _b[downstreamXtau_0911]  - 1.96 * _se[downstreamXtau_0911]  in 8
			replace ci_lo = _b[downstreamXtau_1214]  - 1.96 * _se[downstreamXtau_1214]  in 9
			replace ci_lo = _b[downstreamXtau_1517]  - 1.96 * _se[downstreamXtau_1517]  in 10
			replace ci_lo = _b[downstreamXtau_1820]  - 1.96 * _se[downstreamXtau_1820]  in 11
			replace ci_lo = _b[downstreamXtau_2123]  - 1.96 * _se[downstreamXtau_2123]  in 12
			replace ci_lo = _b[downstreamXtau_2426]  - 1.96 * _se[downstreamXtau_2426]  in 13
			replace ci_lo = _b[downstreamXtau_2729]  - 1.96 * _se[downstreamXtau_2729]  in 14
			replace ci_lo = _b[downstreamXtau_3099]  - 1.96 * _se[downstreamXtau_3099]  in 15

			g x = _n in 1/15
			cap la drop x
			la de x 1 "<=-10" 2 "-9 to -7" 3 "-6 to -4" ///
				4 "-3 to -1" 5 "0 to 2" 6 "3 to 5" 7 "6 to 8" 8 "9 to 11" ///
				9 "12 to 14" 10 "15 to 17" 11 "18 to 20" 12 "21 to 23" 13 "24 to 26" ///
				14 "27 to 29" 15 ">=30" 
			la val x x

			replace xb    = xb    - _b[downstreamXtau_m0301]
			replace ci_hi = ci_hi - _b[downstreamXtau_m0301]
			replace ci_lo = ci_lo - _b[downstreamXtau_m0301]

			if "`p'" != "fishable" loc ylab "-4 -2 0 2 4"
			if "`p'" == "fishable" loc ylab "-0.06 -0.04 -0.02 0 0.02"

			if "`p'" != "fishable" loc units "Saturation Deficit (Percent)"
			if "`p'" == "fishable" loc units "Share Not Fishable"

			tw (connected xb x in 1/15, lcolor(navy) msymbol(S)) ///
				(line ci_hi x in 1/15, lpattern(dash) lcolor(cranberry)) ///
				(line ci_lo x in 1/15, lpattern(dash) lcolor(cranberry) ), ///
				graphr(color(white)) ///
				yscale(noline) ///
				xlab(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15, valuelabel angle(90)) ///
				ylab(`ylab') ///
				xtit("Years Since Treatment Plant Received a Grant") ///
				subtit("") ///
				ytit("`units'") ///
				legend(off) ///
				yline(0, lcolor(black)) ///
				xline(4.5)
			graph save "results/figures/f3_`p'.gph", replace
			graph export "results/figures/f3_`p'.wmf", replace


			}
	end

	cap pr drop graphHousing
	pr de graphHousing
		foreach panel in A B {
			u "foia_grants/tausFull_panel`panel'.dta", clear

			reghdfe lnmeanval tau_* housex_* [aw=weight], absorb(id_facility id_basinXyear) vce(cluster id_watershed) 

			cap drop xb ci_hi ci_lo x
			g       xb = _b[tau_m1099] in 1
			replace xb = _b[tau_m0907] in 2
			replace xb = _b[tau_m0604] in 3
			replace xb = _b[tau_m0301] in 4
			replace xb = _b[tau_0002]  in 5
			replace xb = _b[tau_0305]  in 6
			replace xb = _b[tau_0608]  in 7
			replace xb = _b[tau_0911]  in 8
			replace xb = _b[tau_1214]  in 9
			replace xb = _b[tau_1517]  in 10
			replace xb = _b[tau_1820]  in 11
			replace xb = _b[tau_2123]  in 12
			replace xb = _b[tau_2426]  in 13
			replace xb = _b[tau_2729]  in 14
			replace xb = _b[tau_3099]  in 15
			g       ci_hi = _b[tau_m1099] + 1.96 * _se[tau_m1099] in 1
			replace ci_hi = _b[tau_m0907] + 1.96 * _se[tau_m0907] in 2
			replace ci_hi = _b[tau_m0604] + 1.96 * _se[tau_m0604] in 3
			replace ci_hi = _b[tau_m0301] + 1.96 * _se[tau_m0301] in 4
			replace ci_hi = _b[tau_0002]  + 1.96 * _se[tau_0002]  in 5
			replace ci_hi = _b[tau_0305]  + 1.96 * _se[tau_0305]  in 6
			replace ci_hi = _b[tau_0608]  + 1.96 * _se[tau_0608]  in 7
			replace ci_hi = _b[tau_0911]  + 1.96 * _se[tau_0911]  in 8
			replace ci_hi = _b[tau_1214]  + 1.96 * _se[tau_1214]  in 9
			replace ci_hi = _b[tau_1517]  + 1.96 * _se[tau_1517]  in 10
			replace ci_hi = _b[tau_1820]  + 1.96 * _se[tau_1820]  in 11
			replace ci_hi = _b[tau_2123]  + 1.96 * _se[tau_2123]  in 12
			replace ci_hi = _b[tau_2426]  + 1.96 * _se[tau_2426]  in 13
			replace ci_hi = _b[tau_2729]  + 1.96 * _se[tau_2729]  in 14
			replace ci_hi = _b[tau_3099]  + 1.96 * _se[tau_3099]  in 15
			g       ci_lo = _b[tau_m1099] - 1.96 * _se[tau_m1099] in 1
			replace ci_lo = _b[tau_m0907] - 1.96 * _se[tau_m0907] in 2
			replace ci_lo = _b[tau_m0604] - 1.96 * _se[tau_m0604] in 3
			replace ci_lo = _b[tau_m0301] - 1.96 * _se[tau_m0301] in 4
			replace ci_lo = _b[tau_0002]  - 1.96 * _se[tau_0002]  in 5
			replace ci_lo = _b[tau_0305]  - 1.96 * _se[tau_0305]  in 6
			replace ci_lo = _b[tau_0608]  - 1.96 * _se[tau_0608]  in 7
			replace ci_lo = _b[tau_0911]  - 1.96 * _se[tau_0911]  in 8
			replace ci_lo = _b[tau_1214]  - 1.96 * _se[tau_1214]  in 9
			replace ci_lo = _b[tau_1517]  - 1.96 * _se[tau_1517]  in 10
			replace ci_lo = _b[tau_1820]  - 1.96 * _se[tau_1820]  in 11
			replace ci_lo = _b[tau_2123]  - 1.96 * _se[tau_2123]  in 12
			replace ci_lo = _b[tau_2426]  - 1.96 * _se[tau_2426]  in 13
			replace ci_lo = _b[tau_2729]  - 1.96 * _se[tau_2729]  in 14
			replace ci_lo = _b[tau_3099]  - 1.96 * _se[tau_3099]  in 15
			g x = _n in 1/15
			cap la drop x
			la de x 1 "<=-10" 2 "-9 to -7" 3 "-6 to -4" ///
				4 "-3 to -1" 5 "0 to 2" 6 "3 to 5" 7 "6 to 8" 8 "9 to 11" ///
				9 "12 to 14" 10 "15 to 17" 11 "18 to 20" 12 "21 to 23" 13 "24 to 26" ///
				14 "27 to 29" 15 ">=30" 
			la val x x

			replace xb    = xb    - _b[tau_m0301]
			replace ci_hi = ci_hi - _b[tau_m0301]
			replace ci_lo = ci_lo - _b[tau_m0301]
			
			if "`panel'" == "A" loc ylab "-0.02 0 0.02 0.04"
			if "`panel'" == "B" loc ylab "-0.005 0 0.005 0.01"


			tw (connected xb x in 1/15, lcolor(navy) msymbol(S)) ///
				(line ci_hi x in 1/15, lpattern(dash) lcolor(cranberry)) ///
				(line ci_lo x in 1/15, lpattern(dash) lcolor(cranberry) ), ///
				graphr(color(white)) ///
				yscale(noline) ///
				xlab(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15, valuelabel angle(90)) ///
				xtit("Years Since Treatment Plant Received a Grant") ///
				subtit("") ///
				ytit("Log Mean Home Values") ///
				ylab(`ylab') ///
				legend(off) ///
				yline(0, lcolor(black)) ///
				xline(4.5)
			graph save "results/figures/f4`panel'.gph", replace
			graph export "results/figures/f4`panel'.wmf", replace
			di "`subtit'"

		}
	end

	cap pr drop tableTrends
	pr de tableTrends
		foreach p in "do_perc_plusmgl" "fishable" "bod" "fecalcoliform" "swimmable" "tss" {
			if "`p'" == "fishable" | "`p'" == "swimmable" u "water_quality/trendsReg_fishableswimmable.dta", clear
			if "`p'" != "fishable" & "`p'" != "swimmable" u "water_quality/trendsReg_`p'.dta", clear

			g post_1972       = year >= 1972
			g cyear           = year - 1971
			g cyearXpost_1972 = cyear * post_1972
			
			
			if "`p'" == "fishable" | "`p'" == "swimmable" g resultvalue = not`p'

			reghdfe resultvalue year $Xtrends, absorb(id_station) vce(cluster id_watershed) 
				est store m1
			qui su resultvalue if year >= 1962 & year <= 1971
				estadd scalar ymean19621971 = r(mean)

			reghdfe resultvalue cyear cyearXpost_1972 $Xtrends, ///
				absorb(id_station) vce(cluster id_watershed) 
				est store m2
			lincom cyear*29 + cyearXpost_1972*29
				loc r_estimate = r(estimate)
				estadd scalar r_estimate = `r_estimate'
				loc r_se = r(se)
				estadd scalar r_se = `r_se'



			if "`p'" == "do_perc_plusmgl" loc replaceappend replace
			if "`p'" != "do_perc_plusmgl" loc replaceappend append

			estout m1 m2 ///
			using "results/tables/t1.txt", ///
				cells( b(star fmt(%9.3f)) se(par(`"="("'`")""'))) ///
				title("table 1") style(tab) keep(year cyear*) ///
				stats(r_estimate r_se N N_clust ymean19621971, fmt(3 3 0 0 3)) label collabels(, none) ///
				starlevels(* .10 ** .05 *** .01) `replaceappend'
			estout m1 m2 ///
			using "results/tables/t1_4decs.txt", ///
				cells( b(star fmt(%9.4f)) se(par(`"="("'`")""'))) ///
				title("table 1: 4 decimals") style(tab) keep(year cyear*) ///
				stats(r_estimate r_se N N_clust ymean19621971, fmt(3 3 0 0 3)) label collabels(, none) ///
				starlevels(* .10 ** .05 *** .01) `replaceappend'
			estimates clear	

			}
	end

	cap pr drop tableImpact
	pr de tableImpact
		foreach p in "fishable" "swimmable" "bod" "do_perc_plusmgl" "fecalcoliform" "tss" {

			if "`p'" == "fishable" | "`p'" == "swimmable" u "water_quality/ddd_fishableswimmable.dta", clear
			if "`p'" != "fishable" & "`p'" != "swimmable" u "water_quality/ddd_`p'.dta", clear

			if "`p'" == "fishable" | "`p'" == "swimmable" g resultvalue = not`p'	
			
			reghdfe resultvalue downstreamXcumulgrants tmean prcp [aw=Nobs], ///
				absorb(id_facilityXdownstream id_facilityXyear downstreamXid_basinXyear) ///
				vce(cluster id_watershed) 
				est store m1_`p'
			su resultvalue if e(sample) & baseline == 1
				estadd scalar ymean = r(mean)
			}

		estout m1_* ///
		using "results/tables/t2.txt", ///
			cells( b(star fmt(%9.3f)) se(par(`"="("'`")""'))) ///
			title("table 2: `p'") style(tab) keep(downstreamXcumulgrants) ///
			stats(N N_clust ymean, fmt(0 0 3) labels(N "Clusters")) label collabels(, none) ///
			starlevels(* .10 ** .05 *** .01) replace
		estimates clear	
	end

	cap pr drop tableCosteff
	pr de tableCosteff
		mat M = J(25,25,.)


		foreach col in 1 3 5 {
			
			u "combined/cost_effectiveness.dta", clear
			
			if `col' == 1 keep if plantswPollData == 1
			if `col' == 3 keep if plantswLatLon == 1
			if `col' == 5 replace lengthmiles = 25

			replace lengthmiles = 25 if lengthmiles > 25 & lengthmiles < .
				
			loc b  = .024
			loc se = .005
			
			g miles_made_fishable     = lengthmiles * Ngrants * `b'
			g miles_made_fishable_lo  = lengthmiles * Ngrants * (`b' - (1.96*`se'))
			g miles_made_fishable_hi  = lengthmiles * Ngrants * (`b' + (1.96*`se'))

			loc b  = 0.681
			loc se = 0.206
			
			g miles_made_doPct     = lengthmiles * Ngrants * `b' / 10 
			g miles_made_doPct_lo  = lengthmiles * Ngrants * (`b' - (1.96*`se')) / 10
			g miles_made_doPct_hi  = lengthmiles * Ngrants * (`b' + (1.96*`se')) / 10

			collapse (sum) *_real miles_made_*

			g muni_copay_real = foia_localfed_dollars_real - foia_dollars_real
			egen cost = rowtotal(foia_localfed_dollars_real om_real)

			foreach v in cost foia_dollars_real muni_copay_real om_real {
				replace `v' = `v' * 1000
				}
			
			mat M[1,`col']   = cost[1]/(30*miles_made_fishable[1])
			mat M[2,`col']   = cost[1]/(30*miles_made_fishable_hi[1])
			mat M[2,`col'+1] = cost[1]/(30*miles_made_fishable_lo[1])

			mat M[4,`col']   = cost[1]/(30*miles_made_doPct[1])
			mat M[5,`col']   = cost[1]/(30*miles_made_doPct_hi[1])
			mat M[5,`col'+1] = cost[1]/(30*miles_made_doPct_lo[1])

			mat M[7,`col']  = cost[1]
			mat M[8,`col']  = foia_dollars_real[1]
			mat M[9,`col']  = muni_copay_real[1]
			mat M[10,`col'] = om_real[1]

			mat M[12,`col']   = miles_made_fishable[1]

			mat M[15,`col']   = miles_made_doPct[1] 
		 
			}

		set linesize 255
		svmat M
		format M* %25.2f
		log using "results/tables/t3.txt", replace t
		l M*, clean
		log c

	end

	cap pr drop resHousing
	pr de resHousing
		if `2' == 1 reghdfe `1' hasgrant_cumul          [aw = weight_`1'], absorb(id_facility id_basinXyear) vce(cluster id_watershed) 
		if `2' >= 2 reghdfe `1' hasgrant_cumul housex_* [aw = weight_`1'], absorb(id_facility id_basinXyear) vce(cluster id_watershed) 
	end

	cap pr drop tablePassthru
	pr de tablePassthru
		u "local_gvt_finance/local_gvt_finance_combined.dta", clear

		xi: areg seweragecapoutlay_cumul foia_dollars_cumul i.year ///
			, absorb(id_city) cluster(id_city)
			est store m1
		xi: areg seweragecapoutlay_real_cumul foia_dollars_real_cumul i.year ///
			, absorb(id_city) cluster(id_city)
			est store m2
		xi: areg seweragecapoutlay_real_cumul foia_dollars_real_cumul i.id_city ///
			, absorb(id_basinXyear) cluster(id_city)
			est store m3
		xi: areg seweragecapoutlay_real_cumul foia_dollars_real_cumul i.id_city ///
			[pw=1/propensityScore], absorb(id_basinXyear) cluster(id_city)
			est store m4

			
		xi: areg seweragecapoutlay_cumul foia_localfed_dollars_cumul i.year ///
			, absorb(id_city) cluster(id_city)
			est store m5
		xi: areg seweragecapoutlay_real_cumul foia_localfed_dollars_real_cumul i.year ///
			, absorb(id_city) cluster(id_city)
			est store m6
		xi: areg seweragecapoutlay_real_cumul foia_localfed_dollars_real_cumul i.id_city ///
			, absorb(id_basinXyear) cluster(id_city)
			est store m7
		xi: areg seweragecapoutlay_real_cumul foia_localfed_dollars_real_cumul i.id_city ///
			[pw=1/propensityScore], absorb(id_basinXyear) cluster(id_city)
			est store m8
			
		estout m* ///
		using "results/tables/t4.txt", ///
			cells( b(star fmt(%9.2f)) se(par(`"="("'`")""'))) ///
			title("table 4") style(tab) keep(foia_*) ///
			stats(N N_clust ymean, fmt(0 0 3) labels(N "Clusters")) label collabels(, none) ///
			starlevels(* .10 ** .05 *** .01) replace
	end


	cap pr drop tableHousing
	pr de tableHousing

		loc i = 1
		foreach depVar in lnmeanval lnmeanrent lntothsun lntotval {
		forv column = 1/4 {
			u "combined/homevalues.dta", clear
			keep if column == `column'
			resHousing `depVar' `column'
				est store m`i'
				loc i = `i' + 1
		}
		}

		estout m* ///
		 using "results/tables/t5.txt", ///
				 cells( b(star fmt(%9.6f)) se(par(`"="("'`")""'))) ///
				 title("table 5: `p'") style(tab) keep(hasgrant_cumul) ///
				 stats(N N_clust, fmt(0 0 3 3 3) labels(N "Clusters")) label collabels(, none) ///
				 starlevels(* .10 ** .05 *** .01) replace

	end

	cap pr drop tableCB
	pr de tableCB
		mat M = J(100,100,.)

		forv col = 1/4 {

			if `col' == 1 loc b  = 0.002486
			if `col' == 1 loc se = 0.001271
			if `col' >= 2 loc b = 0.00024
			if `col' >= 2 loc se = 0.000328
			if `col' >= 3 loc b_rental = -0.00012
			if `col' >= 3 loc se_rental = 0.000158

			u "combined/costbenefit.dta", clear

			keep if column == `col'
			
			g benefit    = homevalues *  `b'  * hasgrant / 1000000000
			g benefit_se = homevalues *  `se' * hasgrant / 1000000000 

			replace benefit    = 0 if benefit >= .
			replace benefit_se = 0 if benefit_se >= .

			if `col' >= 3 {
				g rental_payout = (rents * hasgrant / 1000000000)  
				g rental_pdv    = rental_payout * ((1-(1.0785^(-30)))/0.0785) * `b_rental' 
				g rental_pdv_se = rental_payout * ((1-(1.0785^(-30)))/0.0785) * `se_rental'

				replace benefit    = benefit + rental_pdv 
				replace benefit_se = sqrt(benefit_se^2 + rental_pdv_se^2)
				}

			g df = 1
			collapse (sum) benefit benefit_se cost_fed cost_loc cost_om cost df

			g ratio    = benefit    / cost
			g ratio_se = benefit_se / cost
			
			su df
			loc df = r(mean)

			mat M[1,`col']  = ratio[1]
			mat M[2,`col']  = ratio_se[1]
			loc tstat0 =  ratio[1]   /ratio_se[1]
			loc tstat1 = (ratio[1]-1)/ratio_se[1]
			mat M[3,`col']  = 2 * ttail(`df'-1,abs(`tstat0'))
			mat M[4,`col']  = 2 * ttail(`df'-1,abs(`tstat1'))

			mat M[6, `col']  = benefit[1]

			mat M[8,  `col']  = cost_fed[1] 
			mat M[9,  `col']  = cost_loc[1]
			mat M[10, `col']  = cost_om[1] 
			mat M[11, `col']  = cost[1]

			loc col = `col' + 1
		}


		svmat M
		keep M*
		format * %25.2fc
		keep in 1/12
		outsheet using "results/tables/t6.txt", replace

	end


	main
	exit
