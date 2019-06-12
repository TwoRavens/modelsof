

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure A.2.2: Civil 
	**					Administration and Tax Revenue from Trade in 
	**					Royal Treasuries, Before and After the 
	**					Mining Tribunal
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
* Figure A.2.2:	Civil Administration and Tax Revenue from Trade in Royal 
*				Treasuries, Before and After the Mining Tribunal
*-------------------------------------------------------------------------------


* Panel A: Civil Administration in Royal Treasuries
*--------------------------------------------------
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
graph export "`figuresdir'FigureA2_2_a.pdf", replace;
#delimit cr


* Panel B: Tax Revenue from Trade in Royal Treasuries
*----------------------------------------------------
qui areg prRec i.year trib if year>=1714 & year<=1810,a(cajacode) cl(cajacode)
#delimit;
twoway (lpoly logComTax year if evertrib==1 & year<=1777, bw(2) rec 
		lc(black) lp(solid))
	(lpoly logComTax year if evertribunal==1 & year>1777, bw(2) rec 
		lc(black) lp(solid))
	(lpoly logComTax year if evertribunal==0 & year<=1777, bw(2) rec 
		lc(red) lp(dash))
	(lpoly logComTax year if evertribunal==0 & year>1777, bw(2) rec 
		lc(red) lp(dash))
	(scatter logComTax year if evertribunal==1, mc(gray) msize(tiny))
	(scatter logComTax year if evertribunal==0, mc(red) msize(tiny)) 
	if e(sample)==1, xline(1777)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1720(10)1805,labsize(2.5) nogrid) ylabel(,labsize(2.5) nogrid) 
	title("") xtitle("Year", size(3.5))
	ytitle("Taxes on Trade (log pesos)", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(order(1 "Mining Treasuries" 
	3 "Non-Mining Treasuries") size(3.5)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
graph export "`figuresdir'FigureA2_2_b.pdf", replace;
#delimit cr


		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		




