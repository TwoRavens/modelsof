
** Loading data - generated in dofile: data05
use "$data\minwage_data5_estimation_2012_2015.dta", clear
keep if inrange(tline,-24,24) & apprentice == 0 // 49 event-month oberservation window & excluding apprentices

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

** Figure A.4 Employment Around Worker' 18th Bday by (Annual) Birth Cohort
** Running a loop over included cohorts
forval j = 1992/1999{
preserve
	keep if cohort == `j'
	
	** Saving means of variable by tline: used in plots ('yellow dots')
	qui: reg emplyd Dtime1-Dtime49, nocons vce(cl cohmxmonth)
		forval x = 1/49{	
			qui: replace Dtline = _b[Dtime`x'] if tline_pos == `x'
		}
	** Baseline regression 5 degree age polynomial including dummy at event time 0
	qui: reg emplyd tline_pos tline_pos_sq tline_pos_cu tline_pos_4th tline_pos_5th Dtime0 DtimeZ, vce(cl cohmxmonth)
	local x = `j' - 1988
	di `x'
	putexcel set "$out\Apndx_Fig4_reg_delta_dofile_analys03.xls", sheet(estimation) modify
		#d; 
		putexcel E3=("Obs."); putexcel E`x' =(e(N));
		matrix b=[_b[Dtime0], _b[Dtime0] - 1.96*_se[Dtime0], _b[Dtime0] + 1.96*_se[Dtime0]];
		putexcel B`x' =matrix(b);
		putexcel A`x' =("`j'"); putexcel B3=("Beta"); putexcel C3=("[95% Conf. Interval]"); 
		#d cr
		
	nlcom delta: _b[Dtime0] / (_b[_cons]+_b[tline_pos]*25+_b[tline_pos_sq]*25^2+_b[tline_pos_cu]*25^3+_b[tline_pos_4th]*25^4+_b[tline_pos_5th]*25^5+_b[Dtime0]*0.5), post 
	putexcel set "$out\Apndx_Fig4_reg_delta_dofile_analys03.xls", sheet(estimation) modify
		#d; 
		matrix b=[_b[delta], _b[delta] - 1.96*_se[delta], _b[delta] + 1.96*_se[delta]];
		putexcel G`x'=matrix(b);
		putexcel G3=("Delta"); putexcel H3=("[95% Conf. Interval]"); 
		#d cr
		
	** Saving estimates in globals to use for predictions below
	qui: reg emplyd tline_pos tline_pos_sq tline_pos_cu tline_pos_4th tline_pos_5th Dtime0 DtimeZ, vce(cl cohmxmonth)
	#d;
	global obs =(e(N)); global b _b[tline_pos]; global b1 _b[tline_pos_sq];
	global b2 _b[tline_pos_cu]; global b3 _b[tline_pos_4th]; 
	global b4 _b[tline_pos_5th]; global c _b[_cons]; global D18 _b[Dtime0];
	#d cr
	
	** Collapsing to calc. average by tline
	collapse (count) observations = pnr  (mean) emplyd (mean) Dtline, by(tline)

	** Age polynomial
	ge tline_pos = tline+ 25
	ge tline_pos_sq=tline_pos*tline_pos
	ge tline_pos_cu=tline_pos*tline_pos*tline_pos
	ge tline_pos_4th=tline_pos*tline_pos*tline_pos*tline_pos
	ge tline_pos_5th=tline_pos*tline_pos*tline_pos*tline_pos*tline_pos
			
	** Prediction wages, employment, hours and earnings at event times with youth/adult minimum wage
	ge yhat1 = $c + $b * (tline_pos)  + $b1 * (tline_pos_sq)  + $b2 * (tline_pos_cu)  + $b3 * (tline_pos_4th) + $b4 * (tline_pos_5th) // youth min wage 
	ge yhat2 = $c + $b * (tline_pos) + $b1 * (tline_pos_sq)  + $b2 * (tline_pos_cu)  + $b3 * (tline_pos_4th) + $b4 * (tline_pos_5th) + $D18 // adult min wage
	
	** Making a dataset with results for cohort `j'
	ge yhat_`j' = yhat1 if tline < 0 // youth min wage 
	replace yhat_`j' = yhat2 if tline >= 0 // adult min wage
	rename Dtline Dtline_`j'
	keep tline yhat_`j' Dtline_`j' // Variables needed for Figure below
	save "$data\minwage_analys03_cohort`j'.dta", replace

restore
}

** Collecting the cohort specific dataset to plot results in one figure
use "$data\minwage_analys03_cohort1992.dta", clear
forval j = 1993/1999{
	append using "$data\minwage_analys03_cohort`j'.dta"
}
** Collapsing to plot average by tline
collapse  (mean) yhat_1992 (mean) yhat_1993 (mean) yhat_1994 (mean) yhat_1995 ///
		  (mean) yhat_1996 (mean) yhat_1997 (mean) yhat_1998 (mean) yhat_1999 ///	
		  (mean) Dtline_1992 (mean) Dtline_1993 (mean) Dtline_1994 (mean) Dtline_1995 ///
		  (mean) Dtline_1996 (mean) Dtline_1997 (mean) Dtline_1998 (mean) Dtline_1999, by(tline)

 ** Figure A.4: Employment Around Workers' 18th Birthday by (Annual) Birth Cohort
two scatter Dtline_1992-Dtline_1999 tline, ///
	color(black gs2 gs3 gs5 gs6 gs8 gs9 gs11 gs12) msymbol(O D T S + X Oh Dh Th) || ///
	line yhat_1992- yhat_1999 tline if inrange(tline, -24, -1), ///
	color(black gs2 gs3 gs5 gs6 gs8 gs9 gs11 gs12) msymbol(O D T S + X Oh Dh Th) || ///
	line yhat_1992- yhat_1999 tline if inrange(tline, 1,24), ///
	color(black gs2 gs3 gs5 gs6 gs8 gs9 gs11 gs12) msymbol(O D T S + X Oh Dh Th) ///
	graphregion(color(white)) ///
	yti("Employment rate (%)") ylabel(20(10)60) xline(-12, lcolor(grey)) xline(0, lcolor(grey)) xline(12, lcolor(grey)) /// ///
		xti("Month relative to 18th birthday") xlabel(-24(2)24) ///
	legend(on order(1 2 3 4 5 6 7 8) label(1 "Cohort '92") label(2 "Cohort '93") label(3 "Cohort '94") ///
		label(4 "Cohort '95") label(5 "Cohort '96") label(6 "Cohort '97") ///
		label(7 "Cohort '98") label(8 "Cohort '99") cols(4) region(lcolor(white))) scale(0.80)  
graph export "$out\Apndx_Figure4_employ_cohort_dofile_analys03.png", width(800) height(600) replace
