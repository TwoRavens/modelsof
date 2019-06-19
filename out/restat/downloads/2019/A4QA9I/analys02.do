
** Loading data - generated in dofile: data05
use "$data\minwage_data5_estimation_2012_2015.dta", clear
keep if inrange(tline,-24,24) & apprentice == 0 // 49 event-month oberservation window & excluding apprentices

** Creating dummy indicator for hourly wage observations in every month from -2 to + 2
sort pnr tline
ge s = 1 	  if calc_hrly_wage !=. & tline == -2
replace s = 1 if calc_hrly_wage !=. & tline == -1
replace s = 1 if calc_hrly_wage !=. & tline == 0
replace s = 1 if calc_hrly_wage !=. & tline == 1
replace s = 1 if calc_hrly_wage !=. & tline == 2
bysort pnr: egen S=sum(s)
tab S
keep if S == 5 // Sample includes individuals who are observed from with an hourly wage in every month from -2 to + 2 

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

** Figure A.3: Selection in to Employment: Employed Continously from Two months before to Two Months After Age 18
	** Saving means of variable by tline: used in plots ('yellow dots')
	qui: reg calc_hrly_wage Dtime1-Dtime49, nocons vce(cl cohmxmonth)
		forval x = 1/49{	
			qui: replace Dtline = _b[Dtime`x'] if tline_pos == `x'
		}
	
	** Baseline regression 5 degree age polynomial including dummy at event time 0
	qui: reg calc_hrly_wage tline_pos tline_pos_sq tline_pos_cu tline_pos_4th tline_pos_5th Dtime0 DtimeZ, vce(cl cohmxmonth)
	
	local x = 9
	putexcel set "$out\Fig1_Fig2_reg_delta_dofile_analys01.xls", sheet(estimation) modify // Note I write results into document from Analys01.do
		#d; 
		putexcel E3=("Obs."); putexcel E`x' =(e(N));
		matrix b=[_b[Dtime0], _b[Dtime0] - 1.96*_se[Dtime0], _b[Dtime0] + 1.96*_se[Dtime0]];
		putexcel B`x' =matrix(b);
		putexcel A`x' =("calc_hrly_wage_selection_emplyd_m2p2"); putexcel B3=("Beta"); putexcel C3=("[95% Conf. Interval]"); 
		#d cr
		
	nlcom delta: _b[Dtime0] / (_b[_cons]+_b[tline_pos]*25+_b[tline_pos_sq]*25^2+_b[tline_pos_cu]*25^3+_b[tline_pos_4th]*25^4+_b[tline_pos_5th]*25^5+_b[Dtime0]*0.5), post 
	putexcel set "$out\Fig1_Fig2_reg_delta_dofile_analys01.xls", sheet(estimation) modify // Note I write results into document from Analys01.do
		#d; 
		matrix b=[_b[delta], _b[delta] - 1.96*_se[delta], _b[delta] + 1.96*_se[delta]];
		putexcel G`x'=matrix(b);
		putexcel G3=("Delta"); putexcel H3=("[95% Conf. Interval]"); 
		#d cr
	
	** Saving estimates in globals to use for predictions below
	qui: reg calc_hrly_wage tline_pos tline_pos_sq tline_pos_cu tline_pos_4th tline_pos_5th Dtime0 DtimeZ, vce(cl cohmxmonth)
	#d;
	global obs =(e(N)); global b _b[tline_pos]; global b1 _b[tline_pos_sq];
	global b2 _b[tline_pos_cu]; global b3 _b[tline_pos_4th]; 
	global b4 _b[tline_pos_5th]; global c _b[_cons]; global D18 _b[Dtime0];
	#d cr
	
	** Collapsing to calc. average by tline
	collapse (count) observations = pnr  (mean) calc_hrly_wage (mean) Dtline, by(tline)

	** Age polynomial
	ge tline_pos = tline+ 25
	ge tline_pos_sq=tline_pos*tline_pos
	ge tline_pos_cu=tline_pos*tline_pos*tline_pos
	ge tline_pos_4th=tline_pos*tline_pos*tline_pos*tline_pos
	ge tline_pos_5th=tline_pos*tline_pos*tline_pos*tline_pos*tline_pos
			
	** Prediction wages, employment, hours and earnings at event times with youth/adult minimum wage
	ge yhat1 = $c + $b * (tline_pos)  + $b1 * (tline_pos_sq)  + $b2 * (tline_pos_cu)  + $b3 * (tline_pos_4th) + $b4 * (tline_pos_5th) // youth min wage 
	ge yhat2 = $c + $b * (tline_pos) + $b1 * (tline_pos_sq)  + $b2 * (tline_pos_cu)  + $b3 * (tline_pos_4th) + $b4 * (tline_pos_5th) + $D18 // adult min wage
	
** Figure A.3: Selection into Employment: Employed Continuously from Two Months Before to Two Months after Age 18
two line yhat1 tline if inrange(tline, -24, 0), color(black) || ///
	line yhat2 tline if inrange(tline, 0, 24), color(black) || ///
	scatter Dtline tline, color(black) msize(large) ///
	graphregion(color(white)) ///
	yti("$label") ylabel(0(25)175) xline(-12, lcolor(grey)) xline(0, lcolor(grey)) xline(12, lcolor(grey)) ///
	xti("Month relative to 18th birthday") xlabel(-24(2)24) legend(off) scale(.85)	
graph export "$out\Apndx_Figure3_selection_employment_hrly_wage_dofile_analys02.png", width(800) height(600) replace

