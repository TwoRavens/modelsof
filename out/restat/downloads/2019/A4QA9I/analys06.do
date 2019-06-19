set seed 241044
** Loading data - generated in dofile: data05
use "$data\minwage_data5_estimation_2012_2015.dta", clear
keep if inrange(tline,-24,24) & apprentice == 0 & inrange(cohort, 1995, 1996) // 49 event-month oberservation window for cohorts 1995 and 1996 & excluding apprentices

replace emplyd = emplyd * 100
replace felt_200_trim = 0 if felt_200_trim == . // if no reported earnings, earnings set to zero

* Dummy for employment at event time -1
ge emplyd1711 = 0 if tline == -1
replace emplyd1711 = 1 if tline == -1 & emplyd == 100 
bysort pnr: egen sample1711 = max(emplyd1711)
	
* Dummy for emplyoment at event time +1
ge emplyd1801 = 0 if tline == 1
replace emplyd1801 = 1 if tline == 1 & emplyd == 100 
bysort pnr: egen sample1801 = max(emplyd1801)

** Figure 6: Effect of Job Separations at Age 18 on Future Employment and Earnings
preserve
	keep if sample1711 == 1 & sample1801 != . // keeping individuals who were employed at event time -1 (age 17.11)

	collapse (count) observations = pnr  (mean) felt_200_trim (mean) emplyd (mean) ///
		calc_hrly_wage, by(sample1801 tline)

	** (a) Employment			
	two connected emplyd tline if inrange(tline, -24, 24) & sample1801==1, mcolor(gs8) lcolor(gs8) msize(large) msymbol(T) || ///
		connected emplyd tline if inrange(tline, -24, 24) & sample1801==0, mcolor(black) lcolor(black) msize(large)  ///
		graphregion(color(white)) ///
		yti("Employment rate (%)") ylabel(0(10)100) xline(-12, lcolor(grey)) xline(0, lcolor(grey)) xline(12, lcolor(grey)) ///
		xti("Month relative to 18th birthday") xlabel(-24(2)24) ///
		legend(label(1 "Employed at 18.1") label(2 "Unemployed at 18.1") region(lcolor(white))) scale(0.85) 
		graph export "$out\Figure6A_jobsep_emplyd_dofile_analys06.png", width(800) height(600) replace
		
	** (b) Earnings			
	two connected felt_200_trim tline if inrange(tline, -24, 24) & sample1801==1, mcolor(gs8) lcolor(gs8) msize(large) msymbol(T) || ///
		connected felt_200_trim tline if inrange(tline, -24, 24) & sample1801==0, mcolor(black) lcolor(black) msize(large)  ///
		graphregion(color(white)) ///
		yti("Earnings (DKK)") ylabel(0(1000)8000) xline(-12, lcolor(grey)) xline(0, lcolor(grey)) xline(12, lcolor(grey)) ///
		xti("Month relative to 18th birthday") xlabel(-24(2)24) ///
		legend(label(1 "Employed at 18.1") label(2 "Unemployed at 18.1") region(lcolor(white))) scale(0.85) 
		graph export "$out\Figure6B_jobsep_earnings_dofile_analys06.png", width(800) height(600) replace
restore


** Effect of Job Separations at Age 18 on Future Employment: Accounting for Selection
keep if inrange(tline,-24,12) &  cohort == 1996 //Balanced Panel Cohort 1996
bysort pnr (tline): gen pnr_obs = _N
keep if pnr_obs == 37 // Keeping 61,640 individuals from cohort 1996 who are observed every month

preserve
	keep if sample1711 == 1 // keeping individuals who were employed at event time -1 (age 17.11)

	collapse (count) observations = pnr  (mean) felt_200_trim (mean) emplyd (mean) ///
		calc_hrly_wage, by(sample1801 tline)

	** (a) Restricting the Sample to a Balanced Panel for Cohort 1996			
	two connected emplyd tline if inrange(tline, -24, 12) & sample1801==1, mcolor(gs8) lcolor(gs8) msize(large) msymbol(T) || ///
		connected emplyd tline if inrange(tline, -24, 12) & sample1801==0, mcolor(black) lcolor(black) msize(large)  ///
		graphregion(color(white)) ///
		yti("Employment rate (%)") ylabel(0(10)100) xline(-12, lcolor(grey)) xline(0, lcolor(grey)) xline(12, lcolor(grey)) ///
		xti("Month relative to 18th birthday") xlabel(-24(2)12) ///
		legend(label(1 "Employed at 18.1") label(2 "Unemployed at 18.1") region(lcolor(white))) scale(0.85) 
		graph export "$out\Apndx_Figure10A_jobsep_emplyd_dofile_analys06.png", width(800) height(600) replace
restore

** Matching Employment History
preserve
keep if sample1711 == 1 // keeping individuals who were employed at event time -1 (age 17.11)

ge tline_pos = tline + 25
keep pnr cohort emplyd tline_pos sample1801 // reducing observations to perform reshape command

reshape wide emplyd, i(pnr) j(tline_pos) // Reshape to use matching command

psmatch2 sample1801 emplyd1-emplyd23, outcome(emplyd25-emplyd37) ties  // Matching command
pstest emplyd1-emplyd24 // Balancing test

** Collecting estimates for figure
forval i = 1/37{
matrix define cb`i' = .
matrix define tb`i' = .
	reg emplyd`i' [aweight = _weight] if sample1801==0
	matrix cb`i' = [_b[_cons]]
	reg emplyd`i' [aweight = _weight] if sample1801==1
	matrix tb`i' = [_b[_cons]]
}

matrix M = (1 , cb1, tb1 \ 2, cb2, tb2 \ 3, cb3, tb3 \ 4, cb4, tb4 \ 5, cb5, tb5 \ ///
			6, cb6, tb6 \ 7, cb7, tb7 \ 8, cb8, tb8 \ 9, cb9, tb9 \ 10, cb10, tb10  \ ///
			11 , cb11, tb11 \ 12, cb12, tb12 \ ///
			13 , cb13, tb13 \ 14, cb14, tb14 \ 15, cb15, tb15 \ 16, cb16, tb16 \  ///
			17, cb17, tb17 \ 18, cb18, tb18 \ ///
			19, cb19, tb19 \ 20, cb20, tb20 \ 21, cb21, tb21 \ 22, cb22, tb22 \ 23, cb23, tb23  \ ///
			24, cb24, tb24 \ ///
			25 , cb25, tb25 \ 26, cb26, tb26 \ 27, cb27, tb27 \ 28, cb28, tb28 \  ///
			29, cb29, tb29 \ 30, cb30, tb30 \ ///
			31, cb31, tb31 \ 32, cb32, tb32 \ 33, cb33, tb33 \ 34, cb34, tb34 \ 35, cb35, tb35  \ ///
			36, cb36, tb36 \ 37, cb37, tb37) 
svmat M
rename M1 event_time
rename M2 control
rename M3 treatment

replace event_time = event_time - 25

** (b) Matching on Employment history		
	two connected treatment event_time , mcolor(gs8) lcolor(gs8) msize(large) msymbol(T) || ///
		connected control event_time , mcolor(black) lcolor(black) msize(large)  ///
		graphregion(color(white)) ///
		yti("Employment rate (%)") ylabel(0(10)100) xline(-12, lcolor(grey)) xline(0, lcolor(grey)) xline(12, lcolor(grey)) ///
		xti("Month relative to 18th birthday") xlabel(-24(2)12) ///
		legend(label(1 "Employed at 18.1") label(2 "Unemployed at 18.1") region(lcolor(white))) scale(0.85) 
graph export "$out\Apndx_Figure10B_jobsep_emplyd_dofile_analys06.png", width(800) height(600) replace
restore

