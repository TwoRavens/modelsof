

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure 3: Colonial Civil 
	**					Administration and Total Tax Revenue from 
	**					Trade, Before and After the Mining Tribunal
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
set mat 11000
local datadir $data
use "`datadir'NuevaEspana_cajas_Bourbon_agg.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 3:	Colonial Civil Administration and Total Tax Revenue from Trade
*			Before and After the Mining Tribunal
*-------------------------------------------------------------------------------



* Panel A
*--------
#delimit;
twoway (lpoly prRec year if year<1777 & evert==1, 
			bw(2) rec lc(black) lp(solid))
		(lpoly prRec year if year>=1777 & evert==1, 
			bw(2) rec lc(black) lp(solid))
		(lpoly prRec year if year<1777 & evert==0, 
			bw(2) rec lc(red) lp(dash))
		(lpoly prRec year if year>=1777 & evert==0, 
			bw(2) rec lc(red) lp(dash)), xline(1777) 
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(0(.2)1, labsize(2.75) nogrid) 
	xlabel(1720(10)1805,labsize(2.5) nogrid) title("") xtitle("Year", size(3.5))
	ytitle("% Expenditure in Civil Administration & Tax Collection", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(order(1 "Mining Treasuries" 
	3 "Non-Mining Treasuries") size(3.5)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
local figuresdir $figures;
graph export "`figuresdir'Figure3_a.pdf", replace;
#delimit cr



* Panel B
*--------
#delimit;
twoway	(lpoly logComTax year if  year<1777 & evertr==1, 
			bw(2) rec lc(black) lp(solid))
		(lpoly logComTax year if year>=1777 & evertr==1, 
			bw(2) rec lc(black) lp(solid))
		(lpoly logComTax year if year<1777 & evertr==0, 
			bw(2) rec lc(red) lp(dash))
		(lpoly logComTax year if year>=1777 & evertr==0, 
			bw(2) rec lc(red) lp(dash)),
	xline(1777) graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1720(10)1805,labsize(2.5) nogrid) ylabel(,labsize(2.5) nogrid) 
	title("") xtitle("Year", size(3.5))
	ytitle("Revenue (log pesos)", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("") 
	legend(order(1 "Mining Treasuries" 
	3 "Non-Mining Treasuries") size(3.5)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
graph export "`figuresdir'Figure3_b.pdf", replace;
#delimit cr


		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



