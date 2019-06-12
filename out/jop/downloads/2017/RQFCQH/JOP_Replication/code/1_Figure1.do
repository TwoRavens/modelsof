

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure 1: Total Mining 
	**					and Mercury Revenue Before and After the 
	**					Mining Tribunal
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
* Figure 1: Total Mining and Mercury Revenue Before/After the Mining Tribunal
*-------------------------------------------------------------------------------



tset year
#delimit;
twoway 	(lpoly logmineria year if year<1777, bw(2) rec lp(solid))
		(lpoly logmineria year if year>=1777, bw(2) rec lp(solid))
		(lpoly logazogues year if year<1777, bw(2) rec lp(dash))
		(lpoly logazogues year if year>=1777, bw(2) rec lp(dash)),
	xline(1777) 
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1760(5)1790,labsize(2.5) nogrid) ylabel(,labsize(2.5) nogrid) 
	title("") xtitle("Year", size(3.5))
	ytitle("Revenue (log pesos)", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("") aspect(0.5)
	legend(order(1 "Mining-Production Tax Revenue" 
	3 "Mercury Tax Revenue") size(3)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
local figuresdir $figures;
graph export "`figuresdir'Figure1.pdf", replace;




		
		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		





