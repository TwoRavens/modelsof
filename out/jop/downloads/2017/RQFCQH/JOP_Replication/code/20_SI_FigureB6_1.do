

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure B.6.1: Revenue 
	**					from the Indian Poll Tax Before and After 
	**					the Mining Tribunal
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
use "`datadir'NuevaEspana_cajas_BourbonB6_1.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure B.6.1: Revenue from Indian Poll Tax Before/After the Mining Tribunal
*-------------------------------------------------------------------------------

set more off
qui areg prRec i.year trib, a(cajacode) cl(cajacode)
#delimit;
twoway (lpoly logtributo year if evertrib==1 & year<=1777, bw(2) 
		rec lc(black) lp(solid))
	(lpoly logtributo year if evertrib==1 & year>1777, bw(2) 
		rec lc(black) lp(solid))
	(lpoly logtributo year if evertribunal==0 & year<=1777, bw(2) 
		rec lc(red) lp(dash))
	(lpoly logtributo year if evertribunal==0 & year>1777, bw(2) 
		rec lc(red) lp(dash))
	(scatter logtributo year if evertribunal==1 & logtributo>=5, 
		mc(gray) msize(tiny))
	(scatter logtributo year if evertribunal==0 & logtributo>=5, 
		mc(red) msize(tiny)), xline(1777)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1730(10)1805,labsize(2.5) nogrid) ylabel(5(2)14,labsize(2.5) nogrid) 
	title("") xtitle("Year", size(3.5))
	ytitle("Indian Poll Tax (log pesos)", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(order(1 "Mining Treasuries" 
	3 "Non-Mining Treasuries") size(3.5)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
local figuresdir $figures;
graph export "`figuresdir'FigureB6_1.pdf", replace;
#delimit cr



		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



