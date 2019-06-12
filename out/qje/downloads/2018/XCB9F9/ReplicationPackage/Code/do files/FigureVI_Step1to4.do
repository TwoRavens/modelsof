#delimit cr 

preserve

*** STEP 1: Merge vector of weather data ***
	
	// KEEP required CROP ASSESSMENT DATA
	keep plot_id season Y superstrata tt_r treat1 treat2 treat3 treat3a treat3b plnt1 plnt2 plnt3 plnt4 plnt5
	keep if Y != . 

	sort plot_id season
	tempfile Temp_CA
	save `Temp_CA', replace

	// PREPARE WEATHER DATA

	use "Input/MonthlyRainfall_PlotLevel", clear

	* Aggregate monthly rainfall data by Section of Season: Planting/Growing/Harvesting
	foreach y of numlist 106/114 {

		local year   = `y' + 1900
		local y_plus = `y' + 1
						   
		gen rain_p1_s1_`y' = rain_`y'_2 + rain_`y'_3            
		gen rain_p2_s1_`y' = rain_`y'_4 + rain_`y'_5 + rain_`y'_6
		gen rain_p3_s1_`y' = rain_`y'_7 

		gen rain_p1_s2_`y' = rain_`y'_8 + rain_`y'_9             
		gen rain_p2_s2_`y' = rain_`y'_10 + rain_`y'_11 + rain_`y'_12
		gen rain_p3_s2_`y' = rain_`y_plus'_1 
		
		
		foreach s of numlist 1/2 {
			label var rain_p1_s`s'_`y' "Rainfall Planting   (Season `s', `year')"
			label var rain_p2_s`s'_`y' "Rainfall Growing    (Season `s', `year')"
			label var rain_p3_s`s'_`y' "Rainfall Harvesting (Season `s', `year')"
			
			foreach p of numlist 1/3 {
				gen rain_p`p'_s`s'_`y'_sq = (rain_p`p'_s`s'_`y')^2
			}			
		}

	}

	// MERGE

	sort plot_id season 
	merge 1:n plot_id season using "`Temp_CA'"
	drop if _merge != 3

	//// POOL weather data (without season identifier)

	foreach p of numlist 1/3 {
		gen     rain_p`p' = rain_p`p'_s1_114 if season == 2
		replace rain_p`p' = rain_p`p'_s2_114 if season == 3
		gen     rain_p`p'_sq = rain_p`p'_s1_114_sq if season == 2
		replace rain_p`p'_sq = rain_p`p'_s2_114_sq if season == 3
	}
	label var rain_p1 "Rainfall: Planting"
	label var rain_p2 "Rainfall: Growing"
	label var rain_p3 "Rainfall: Harvesting"	
	label var rain_p1_sq "Rainfall$^2$: Planting"
	label var rain_p2_sq "Rainfall$^2$: Growing"
	label var rain_p3_sq "Rainfall$^2$: Harvesting"		

	
	*** Supplementary Table XX.A
	if `SupTableXXA' == 1 {
		foreach x in plnt1 plnt2 plnt3 plnt4 plnt5 {
			xi: areg `x' rain_p1 rain_p2 rain_p3 rain_p1_sq rain_p2_sq rain_p3_sq if treat1==1, a(superstrata) cl(club_id)
			estimates store `x', title (" ")
			test rain_p1=rain_p2=rain_p3=rain_p1_sq= rain_p2_sq =rain_p3_sq=0
			estadd scalar pvalue = r(p)
		}
		estout plnt1 plnt2 plnt3 plnt4 plnt5 using "Output/SupTableXXA.tex", ///
		replace style (tex) collabels(, none) label cells(b(star fmt(%9.3f)) se(par)) keep( rain_p1 rain_p2 rain_p3 rain_p1_sq rain_p2_sq rain_p3_sq)  ///
		mlabels(, none) starlevels(* 0.10 ** 0.05 *** 0.01) stats(pvalue N, fmt(%9.3f %9.0g) layout(@ @)  labels("Joint significance" "Observations") )
	}		

*** STEP 2: Estimate predictive model of theta *** 
 
	* Choose sample on which to estimate predictive model: T2
	local t = 3

	reg Y rain_p? rain_p?_sq if tt_r == `t', cl(club_id)	

	local b_rain_p1 = _b[rain_p1]
	local b_rain_p2 = _b[rain_p2]
	local b_rain_p3 = _b[rain_p3]
	local b_rain_p1_sq = _b[rain_p1_sq]
	local b_rain_p2_sq = _b[rain_p2_sq]
	local b_rain_p3_sq = _b[rain_p3_sq]
	local b_rain_cons  = _b[_cons]
	
	local se_rain_p1 = _se[rain_p1]
	local se_rain_p2 = _se[rain_p2]
	local se_rain_p3 = _se[rain_p3]
	local se_rain_p1_sq = _se[rain_p1_sq]
	local se_rain_p2_sq = _se[rain_p2_sq]
	local se_rain_p3_sq = _se[rain_p3_sq]
	local se_rain_cons  = _se[_cons]
	
	local observations = e(N)

	sum rain_p1 rain_p2 rain_p3 if e(sample)
	
	* Predict theta
	gen theta_`t'   = rain_p1 * `b_rain_p1' ///
					+ rain_p2 * `b_rain_p2' ///
					+ rain_p3 * `b_rain_p3' ///
					+ rain_p1_sq * `b_rain_p1_sq' ///
					+ rain_p2_sq * `b_rain_p2_sq' ///
					+ rain_p3_sq * `b_rain_p3_sq' ///
					+ `b_rain_cons' 
	
	* Check everything went correctly: coefficient equal 1
	reg Y theta_`t' if tt_r == `t', cl(club_id)	
	
	* Write table to .tex file 
	if `SupTableIX' == 1 {
		local filename = "Output/SupTableIX.tex"
		capture file close output_file	
		
		file open output_file using "`filename'", write replace

			file write output_file "Rainfall: Planting & " %5.3f (`b_rain_p1')  "   \\[-3pt]" _n
			file write output_file     " & {\scriptsize(" %5.3f (`se_rain_p1') " )} \\[5pt]" _n
			
			file write output_file "Rainfall: Growing & " %5.3f (`b_rain_p2')  "   \\[-3pt]" _n
			file write output_file     " & {\scriptsize(" %5.3f (`se_rain_p2') " )} \\[5pt]" _n

			file write output_file "Rainfall: Harvesting & " %5.3f (`b_rain_p3')  "   \\[-3pt]" _n
			file write output_file     " & {\scriptsize(" %5.3f (`se_rain_p3') " )} \\[5pt]" _n
			
			file write output_file "Rainfall$^2$: Planting & " %6.4f (`b_rain_p1_sq')  "   \\[-3pt]" _n
			file write output_file     " & {\scriptsize(" %6.4f (`se_rain_p1_sq') " )} \\[5pt]" _n
			
			file write output_file "Rainfall$^2$: Growing & " %6.4f (`b_rain_p2_sq')  "   \\[-3pt]" _n
			file write output_file     " & {\scriptsize(" %6.4f (`se_rain_p2_sq') " )} \\[5pt]" _n
			
			file write output_file "Rainfall$^2$: Harvesting & " %6.4f (`b_rain_p3_sq')  "   \\[-3pt]" _n
			file write output_file     " & {\scriptsize(" %6.4f (`se_rain_p3_sq') " )} \\" _n		
		
			file write output_file " \midrule" _n
			file write output_file "Observations & " %3.0f (`observations') " \\ " _n
		
		file close output_file	
	}

*** STEP 3: Estimate yield response to theta by treatment group *** 
				
	gen theta_t1_`t' = theta_`t'  * treat1
	gen theta_t2_`t' = theta_`t'  * treat2
	gen theta_t3_`t' = theta_`t'  * treat3	
	gen theta_t3a_`t' = theta_`t'  * treat3a	
	gen theta_t3b_`t' = theta_`t'  * treat3b	
			
	reg Y theta_t1_`t' theta_t2_`t' theta_t3a_`t' theta_t3b_`t' treat2 treat3a treat3b, cluster(club_id) 
			
	reg Y theta_t?_`t' treat2 treat3, cluster(club_id) 

	display "Result: Ratio of Weather Response T1/C: " _b[theta_t2_`t']/_b[theta_t1_`t']

	local b_t1  = _b[theta_t1_`t']
	local b_t2  = _b[theta_t2_`t']
	local b_t3  = _b[theta_t3_`t']
	
	local se_t1 = _se[theta_t1_`t']
	local se_t2 = _se[theta_t2_`t']
	local se_t3 = _se[theta_t3_`t']
	
	local observations = e(N)

	if `SupTableX' == 1 {
		* Write table to .tex file 
		local filename = "Output/SupTableX.tex"
		capture file close output_file	
		
		file open output_file using "`filename'", write replace

			file write output_file "$\hat{\theta}_{i,t} \times \text{C}_i$ & " %5.3f (`b_t1')  "   \\[-3pt]" _n
			file write output_file                         "  & {\scriptsize(" %5.3f (`se_t1') " )} \\[5pt]" _n
			
			file write output_file "$\hat{\theta}_{i,t} \times \text{T1}_i$ & " %5.3f (`b_t2')  "   \\[-3pt]" _n
			file write output_file                         "  & {\scriptsize(" %5.3f (`se_t2') " )} \\[5pt]" _n
			
			file write output_file "$\hat{\theta}_{i,t} \times \text{T2}_i$ & " %5.3f (`b_t3')  "   \\[-3pt]" _n
			file write output_file                         "  & {\scriptsize(" %5.3f (`se_t3') " )} \\[5pt]" _n

			file write output_file " \midrule" _n
			file write output_file "Observations & " %3.0f (`observations') " \\ " _n
			
		file close output_file	
	}
		
	
*** STEP 4: Estimate yield in past seasons *** 

	bys tt_r: sum Y

	sort plot_id season
	drop if plot_id == plot_id[_n-1]

	local i = 0
	foreach y of numlist 106/114 {
		foreach s of numlist 1/2 {
			local i = `i' + 1
			gen theta_season_`i'                = rain_p1_s`s'_`y' * `b_rain_p1' ///
												+ rain_p2_s`s'_`y' * `b_rain_p2' ///
												+ rain_p3_s`s'_`y' * `b_rain_p3' ///
												+ rain_p1_s`s'_`y'_sq * `b_rain_p1_sq' ///
												+ rain_p2_s`s'_`y'_sq * `b_rain_p2_sq' ///
												+ rain_p3_s`s'_`y'_sq * `b_rain_p3_sq' ///
												+ `b_rain_cons' 
			gen     Yield_predict_`i' = theta_season_`i'*_b[theta_t1_`t'] + _b[_cons]               if tt_r == 1		
			replace Yield_predict_`i' = theta_season_`i'*_b[theta_t2_`t'] + _b[treat2] + _b[_cons]  if tt_r == 2										
		}
	}

	display `i'
	local pre_i = `i' - 1
	local prepre_i = `i' - 2

	// Assess fit of prediction for experimental season

	bys tt_r: sum Yield_predict_`i'
	bys tt_r: sum Yield_predict_`pre_i'

	// Assess estimated impact on yields for prior seasons

	rename Yield_predict_`i' Yield_predict_exp_`i'
	rename Yield_predict_`pre_i' Yield_predict_exp_`pre_i'

	egen E_Yield_predict  = rowmean(Yield_predict_*) 
	egen SD_Yield_predict = rowsd(Yield_predict_*) 

	bys tt_r: sum E_Yield_predict
	bys tt_r: sum SD_Yield_predict

	// Estimate impact on consumption
	
	* Subtract average costs and add average other income
	local w_t1 = -41.45 + 38.11 
	local w_t2 = -56.82 + 41.92 

	foreach j of numlist 1/`prepre_i' {
		gen     C_predict_`j' = 0.5  * Yield_predict_`j' + `w_t1' if tt_r == 1		
		replace C_predict_`j' = 0.75 * Yield_predict_`j' + `w_t2' if tt_r == 2		
		display `j'
		count if C_predict_`j' == 0
	}

	egen E_C_predict  = rowmean(C_predict_*) 
	egen SD_C_predict = rowsd(C_predict_*) 

	bys tt_r: sum E_C_predict
	bys tt_r: sum SD_C_predict

	// Export for MATLAB where we calculate the compensating differential
	keep C_predict_* tt_r
	order tt_r C_predict_*
	sort tt_r
	label list
	label drop tt_r_label
	if `FigureVI' == 1 {
		export delimited using "Temp/PredictedConsumptionStream.txt", replace
	}	

restore

#delimit ;
