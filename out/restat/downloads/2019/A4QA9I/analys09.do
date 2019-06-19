
** Loading data - generated in dofile: data05
use "$data\minwage_data5_estimation_2012_2015.dta", clear
keep if inrange(tline,-24,24) & apprentice == 1 // 49 event-month oberservation window & only apprentices (placebo)

replace emplyd = emplyd * 100
replace felt_200_trim = 0 if felt_200_trim == . // if no reported earnings, earnings set to zero
replace timeantF12_trim = 0 if timeantF12_trim ==. // if no reported hours, hours set to zero

 qui: tab tline, gen(Dtime) // 49 event months
 qui: tab month, gen(Dmnth) // 48 Calendar months
 ge tline_pos = tline+ 25
 ge Dtline = . // placeholder to drop results in from first regression below
 
 egen cohmxmonth = group(tline month) // month cohorts 2352 

** Time dummies   
ge Dtime0 = tline>=0
ge DtimeZ = tline == 0

** Age polynomial
ge tline_pos_sq=tline_pos*tline_pos
ge tline_pos_cu=tline_pos*tline_pos*tline_pos
ge tline_pos_4th=tline_pos*tline_pos*tline_pos*tline_pos
ge tline_pos_5th=tline_pos*tline_pos*tline_pos*tline_pos*tline_pos

** Figure A.5. Wages around Workers' 18th Bday
** Running a loop over the 1 variables: calc_hrly_wage, emplyd (not included in paper: equal to 1 and no change over event time).
forval j = 1/2{
preserve
	if `j' == 1{
		local var calc_hrly_wage
		global filnam E:\Data\workdata\703788\minwage\out\Apndx_Figure5_emplyd_placebo_apprentices_dofile_analys09
		global range (0(25)175, nogrid)
		global label Hourly wage (DKK)
	}
	if `j' == 2{
		local var emplyd
		global filnam E:\Data\workdata\703788\minwage\out\Figure_not_used_dofile_analys09
		global range (20(10)100, nogrid)
		global label Employment rate (%)
	}
	
	** Saving means of variable by tline: used in plots ('yellow dots')
	qui: reg `var' Dtime1-Dtime49, nocons vce(cl cohmxmonth)
		forval x = 1/49{	
			qui: replace Dtline = _b[Dtime`x'] if tline_pos == `x'
		}
		
	** Baseline regression 5 degree age polynomial including dummy at event time 0
	qui: reg `var' tline_pos tline_pos_sq tline_pos_cu tline_pos_4th tline_pos_5th Dtime0 DtimeZ, vce(cl cohmxmonth)
	local x = 3 + `j'
	di `x'
	putexcel set "$out\Apndx_Fig5_placebo_reg_delta_dofile_analys09.xls", sheet(estimation) modify
		#d; 
		putexcel E3=("Obs."); putexcel E`x' =(e(N));
		matrix b=[_b[Dtime0], _b[Dtime0] - 1.96*_se[Dtime0], _b[Dtime0] + 1.96*_se[Dtime0]];
		putexcel B`x' =matrix(b);
		putexcel A`x' =("`var'"); putexcel B3=("Beta"); putexcel C3=("[95% Conf. Interval]"); 
		#d cr
		
	nlcom delta: _b[Dtime0] / (_b[_cons]+_b[tline_pos]*25+_b[tline_pos_sq]*25^2+_b[tline_pos_cu]*25^3+_b[tline_pos_4th]*25^4+_b[tline_pos_5th]*25^5+_b[Dtime0]*0.5), post 
	putexcel set "$out\Apndx_Fig5_placebo_reg_delta_dofile_analys09.xls", sheet(estimation) modify
		#d; 
		matrix b=[_b[delta], _b[delta] - 1.96*_se[delta], _b[delta] + 1.96*_se[delta]];
		putexcel G`x'=matrix(b);
		putexcel G3=("Delta"); putexcel H3=("[95% Conf. Interval]"); 
		#d cr
	
	** Saving estimates in globals to use for predictions below
	qui: reg `var' tline_pos tline_pos_sq tline_pos_cu tline_pos_4th tline_pos_5th Dtime0 DtimeZ, vce(cl cohmxmonth)
	#d;
	global obs =(e(N)); global b _b[tline_pos]; global b1 _b[tline_pos_sq];
	global b2 _b[tline_pos_cu]; global b3 _b[tline_pos_4th]; 
	global b4 _b[tline_pos_5th];
	global c _b[_cons]; global D18 _b[Dtime0];
	#d cr
		
	** Collapsing to calc. average by tline
	collapse (count) observations = pnr (mean) `var' (mean) Dtline, by(tline)

	** Age polynomial
	ge tline_pos = tline+ 25
	ge tline_pos_sq=tline_pos*tline_pos
	ge tline_pos_cu=tline_pos*tline_pos*tline_pos
	ge tline_pos_4th=tline_pos*tline_pos*tline_pos*tline_pos	
	ge tline_pos_5th=tline_pos*tline_pos*tline_pos*tline_pos*tline_pos	
			
	** Prediction wages, employment, hours and earnings at event times with youth/adult minimum wage
	ge yhat1 = $c + $b * (tline_pos)  + $b1 * (tline_pos_sq)  + $b2 * (tline_pos_cu)  + $b3 * (tline_pos_4th) + $b4 * (tline_pos_5th) // youth min wage 
	ge yhat2 = $c + $b * (tline_pos) + $b1 * (tline_pos_sq)  + $b2 * (tline_pos_cu)  + $b3 * (tline_pos_4th) + $b4 * (tline_pos_5th) + $D18 // adult min wage
			
	** Figure A.5: Average Hourly Wages for Apprentices around Workers' 18th Birthday		
	two line yhat1 tline if inrange(tline, -24, 0), color(black) || ///
		line yhat2 tline if inrange(tline, 0, 24), color(black) || ///
		scatter Dtline tline, color(black) msize(large) ///
		graphregion(color(white) margin(small)) ///
		yti("$label") ylabel$range  xline(-12, lcolor(grey)) xline(0, lcolor(grey)) xline(12, lcolor(grey)) ///
		xti("Month relative to 18th birthday") xlabel(-24(2)24) legend(off) scale(.85)	
	graph export "$filnam.png", width(800) height(600) replace

restore
}
