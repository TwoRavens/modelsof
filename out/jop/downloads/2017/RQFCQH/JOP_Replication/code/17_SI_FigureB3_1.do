

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure B.3.1: Expenditure 
	**					in Civil Administration Before and After 
	**					the Mining Tribunal, Entropy Balance Weights
	**					
	**
	** 
	**
	**				
	**		Versi—n: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Data
*-------------------------------------------------------------------------------



clear all
local datadir $data
use "`datadir'NuevaEspana_cajas_BourbonA2_2.dta", clear





		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure B.3.1:	Expenditure in Civil Administration Before and After the 
*				Mining Tribunal, Entropy Balance Weights
*-------------------------------------------------------------------------------



* Estimate weights
*-----------------
set more off
preserve
qui reg prRec evertribunal if year<1777
keep if e(sample)==1
keep prRec evertribunal logtotal_c cajacode year
reshape wide prRec logtotal_c, i(cajacode) j(year)
ebalance evertribunal prRec1756 prRec1764 prRec1772 prRec1775
keep cajacode _w
save "`datadir'ebal_weights.dta", replace
restore

merge m:1 cajacode using "`datadir'ebal_weights.dta"


* Panel A
*--------
set more off
qui areg prRec i.year trib,a(cajacode) cl(cajacode)
#delimit;
twoway (lpoly prRec year if evertribunal==1 & year<=1777, bw(2) rec 
		lc(black) lp(solid))
	(lpoly prRec year if evertribunal==1 & year>1777, bw(2) rec 
		lc(black) lp(solid))		
	(lpoly prRec year if evertribunal==0 & year<=1777, bw(2) rec 
		lc(red) lp(dash)) 
	(lpoly prRec year if evertribunal==0 & year>1777, bw(2) rec 
		lc(red) lp(dash))
	(scatter prRec year if evertribunal==1, mc(gray) msize(tiny))
	(scatter prRec year if evertribunal==0, mc(red) msize(tiny)) 
	if e(sample)==1, xline(1777) 
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	ylabel(, labsize(2.75) nogrid) xlabel(1720(10)1805,labsize(2.5) nogrid) 
	scheme(s2mono) title("") xtitle("Year", size(3.5))
	ytitle("% Expenditure in Civil Administration & Tax Collection", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(order(1 "Mining Treasuries" 3 "Non-Mining Treasuries") size(3.5)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
local figuresdir $figures;
graph export "`figuresdir'FigureB3_1_a.pdf", replace;
#delimit cr 


* Panel B
*--------

set more off
qui areg prRec i.year trib if year>=1714, a(cajacode) cl(cajacode)
#delimit;
twoway (lpoly prRec year if evertribunal==1 & year<=1777 [aw=_webal], 
			bw(2) rec lc(black) lp(solid))
	(lpoly prRec year if evertribunal==1 & year>1777 [aw=_webal], 
			bw(2) rec lc(black) lp(solid))		
	(lpoly prRec year if evertribunal==0 & year<=1777 [aw=_webal], 
			bw(2) rec lc(red) lp(dash)) 
	(lpoly prRec year if evertribunal==0 & year>1777 [aw=_webal], 
			bw(2) rec lc(red) lp(dash))
	(scatter prRec year if evertribunal==1, mc(gray) msize(tiny))
	(scatter prRec year if evertribunal==0, mc(red) msize(tiny)) 
	if e(sample)==1, xline(1777) 
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1720(10)1810,labsize(2.5) nogrid) title("") xtitle("Year", size(3.5))
	ytitle("% Expenditure in Civil Administration & Tax Collection", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(order(1 "Mining Treasuries" 
	3 "Non-Mining Treasuries") size(3.5)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
graph export "`figuresdir'FigureB3_1_b.pdf", replace;
#delimit cr



		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



