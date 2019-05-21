

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure A.2.1: Sales Tax 
	**					Revenue: Alcabalas and Pulques
	**					
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
use "`datadir'NuevaEspana_cajas_BourbonA2_1.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure A.2.1: Sales Tax Revenue: Alcabalas and Pulques
*-------------------------------------------------------------------------------


* Panel A
*--------
#delimit;
twoway (lpoly prSales year if year>=1777, bw(2) rec lc(black) lp(solid))
	(lpoly prSales year if year<1777, bw(2) rec lc(black) lp(solid))
	if year>=1714 & year<=1805, xline(1777)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1720(10)1805,labsize(2.5) nogrid) 
	ylabel(0(.05).2,labsize(2.5) nogrid) 
	title("") xtitle("Year", size(3.5))
	ytitle("Sales Revenue (% of Total Income)", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(off);
local figuresdir $figures;
graph export "`figuresdir'FigureA2_1_a.pdf", replace;
#delimit cr


* Panel B
*--------
#delimit;
twoway (lpoly logp_Sales year if year>=1777, bw(2) rec lc(black) lp(solid))
	(lpoly logp_Sales year if year<1777, bw(2) rec lc(black) lp(solid)),
	xline(1777) graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1720(10)1805,labsize(2.5) nogrid) 
	ylabel(,labsize(2.5) nogrid) 
	title("") xtitle("Year", size(3.5))
	ytitle("Sales Revenue (log pesos)", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(off);
graph export "`figuresdir'FigureA2_1_b.pdf", replace;
#delimit cr


		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		




