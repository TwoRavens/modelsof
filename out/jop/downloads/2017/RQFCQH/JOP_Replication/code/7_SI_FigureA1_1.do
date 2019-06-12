

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure A.1.1: Sources 
	**					of Colonial Revenue (1759-1790)
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
use "`datadir'YearFiscalAggregates.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure A.1.1: Sources of Colonial Revenue (1759-1790)
*-------------------------------------------------------------------------------


tset year
#delimit;
twoway
	(area prconfiscation year, color(gs13)) 
	(area prothertax year, color(gs11))
	(area prmonopolies year, color(gs9)) (area prtributo year, color(gs6)) 
	(area prtrade year, color(gs3)) (area prmineria year, color(gs0)), 
	graphregion(fcolor(white) lcolor(white) margin(zero)) legend(col(3)) 	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) xtitle("Year", size(2.5)) 
	ytitle("Proportion of Total Revenue", size(2.5))  
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) aspect(0.5)
	ylabel(0(.2)1, labsize(2) nogrid) xlabel(1760(5)1790, labsize(2))
	legend(order(1 2 3 4 5 6) size(2)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(3) ring(1));
local figuresdir $figures;
graph export "`figuresdir'FigureA1_1.pdf", replace;
#delimit cr


		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



