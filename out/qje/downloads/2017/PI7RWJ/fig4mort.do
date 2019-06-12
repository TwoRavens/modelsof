/*

figure 4 event study mort (Panels)
D - quad (black male close year) 
E - black close year 
F - male close year 
*/


*leave out interaction for year 1972 = YR 3 
	use "fig4data", clear 
	reghdfe $outcome  ///
	YR1_black_male_proximity YR2_black_male_proximity YR4_black_male_proximity YR5_black_male_proximity ///
	YR6_black_male_proximity YR7_black_male_proximity YR8_black_male_proximity YR9_black_male_proximity ///
	YR10_black_male_proximity black_proximity_YR1  black_proximity_YR2 black_proximity_YR4 black_proximity_YR5 ///
	black_proximity_YR6 black_proximity_YR7  black_proximity_YR8 black_proximity_YR9 black_proximity_YR10  ///
	male_proximity_YR1 male_proximity_YR2 male_proximity_YR4 male_proximity_YR5 male_proximity_YR6 male_proximity_YR7 ///
	male_proximity_YR8 male_proximity_YR9 male_proximity_YR10 $controls  ,  ///
	absorb( i.black#i.male#i.sea  i.sea#i.yrs i.yrs#i.black#i.male) dofadjustments(clusters) vce(cluster sea) 
	
	regsave
	preserve
	keep if strpos(var, "black_male_proximity") >= 1
	replace var = subinstr(var, "", "", 1)
	gen index=_n-3
	
	replace index=index+1 if index>=0
	gen hi=coef+ 1.96*stder
	gen lo=coef-1.96*stder
	set obs 10
	replace index=0 if index==.
	replace coef=0 if index==0
	replace hi=0 if index==0 
	replace lo=0 if index==0
	sort index
	gen t= coef/stder

gen s="**"  if abs(t)>=(1.96) & t!=.

		twoway (connected coef index, msymbol(Oh) xline(0,lpattern(--)) ytitle(Coefficient) xtitle(Year)     ///
	xlabel(-2 "1968/9" -1 "1970/1"  0 "1972/3"  1 "1974/5" 2 "1976/7" 3 "1978/9" 4 "1980/1" 5 "1982/3"  6 "1984/5" 7 "1986/7" ) ///
		ylabel(-.25(.05).25) yscale(range(-.25 .25))) ///
		(rspike hi lo index, msymbol(i) lcolor(gs10) legend(off))  ///
		(connected coef index, msymbol(Oh) msize(large) mlabel(s) )
	graph export "fig4_panelD.tif", replace 
	
/*next graph male_prox_YR*/
	restore
	preserve
	keep if strpos(var, "male_proximity_YR") >= 1
	replace var = subinstr(var, "", "", 1)
	gen index=_n-3
	
	replace index=index+1 if index>=0
	gen hi=coef+ 1.96*stder
	gen lo=coef-1.96*stder
	set obs 10
	replace index=0 if index==.
	replace coef=0 if index==0
	replace hi=0 if index==0 
	replace lo=0 if index==0
	sort index
	gen t= coef/stder

gen s="**"  if abs(t)>=(1.96) & t!=.

		twoway (connected coef index, msymbol(Oh) xline(0,lpattern(--)) ytitle(Coefficient) xtitle(Year)    ///
	xlabel(-2 "1968/9" -1 "1970/1"  0 "1972/3"  1 "1974/5" 2 "1976/7" 3 "1978/9" 4 "1980/1" 5 "1982/3"  6 "1984/5" 7 "1986/7" ) ///
	ylabel(-.25(.05).25) ) ///
		(rspike hi lo index, msymbol(i) lcolor(gs10) legend(off))  ///
		(connected coef index, msymbol(Oh) msize(large) mlabel(s))
	graph export "fig4_panelE.tif", replace 

/*next graph black_prox_YR*/
restore
	keep if strpos(var, "black_proximity") >= 1
	replace var = subinstr(var, "", "", 1)
	gen index=_n-3
	
	replace index=index+1 if index>=0
	gen hi=coef+ 1.96*stder
	gen lo=coef-1.96*stder
	set obs 10
	replace index=0 if index==.
	replace coef=0 if index==0
	replace hi=0 if index==0 
	replace lo=0 if index==0
	sort index
	gen t= coef/stder

gen s="**"  if abs(t)>=(1.96) & t!=.

		twoway (connected coef index, msymbol(Oh) xline(0,lpattern(--)) ytitle(Coefficient) xtitle(Year)    ///
	xlabel(-2 "1968/9" -1 "1970/1"  0 "1972/3"  1 "1974/5" 2 "1976/7" 3 "1978/9" 4 "1980/1" 5 "1982/3"  6 "1984/5" 7 "1986/7" ) ///
	ylabel(-.25(.05).25)  yscale(range(-.25 .25))) ///
		(rspike hi lo index, msymbol(i) lcolor(gs10) legend(off))  ///
		(connected coef index, msymbol(Oh) msize(large) mlabel(s) )
	graph export "fig4_panelF.tif", replace 

