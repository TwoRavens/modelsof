

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure 2: Civil 
	**					Administration and Tax Revenue from Trade 
	**					in Two Treasuries
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
use "`datadir'Caja_comparison_ZacAca.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 2: Civil Administration and Tax Revenue from Trade in Two Treasuries
*-------------------------------------------------------------------------------



* Panel A
*--------
#delimit;
twoway 
	(lpoly prRec year 
		if caja=="acapulco" & year<1777, bw(2.5) lc(red) lp(dash)) 
	(lpoly prRec year 
		if caja=="acapulco" & year>=1777, bw(2.5) lc(red) lp(dash)) 
	(lpoly prRec year 
		if caja=="zacatecas" & year<1777, bw(2.5) lc(black) lp(solid)) 
	(lpoly prRec year 
		if caja=="zacatecas" & year>=1777, bw(2.5) lc(black) lp(solid)) 
	(scatter prRec year if caja=="acapulco", mc(red) msize(tiny))
	(scatter prRec year if caja=="zacatecas", mc(gray) msize(tiny)), xline(1777)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1730(10)1810,labsize(2.5) nogrid) ylabel(0(.2)1,labsize(2.5) nogrid) 
	title("") xtitle("Year", size(3.5))
	ytitle("% Expenditure in Civil Administration & Tax Collection", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(order(1 "Acapulco (Non-Mining)" 
	3 "Zacatecas (Mining)") size(3.5)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
local figuresdir $figures;
graph export "`figuresdir'Figure2_a.pdf", replace;
#delimit cr




* Panel B
*--------
#delimit;
twoway 
	(lpoly logComTax year 
		if caja=="acapulco" & year<1777, bw(2.5) lc(red) lp(dash)) 
	(lpoly logComTax year 
		if caja=="acapulco" & year>=1777, bw(2.5) lc(red) lp(dash)) 
	(lpoly logComTax year 
		if caja=="zacatecas" & year<1777, bw(2.5) lc(black) lp(solid)) 
	(lpoly logComTax year 
		if caja=="zacatecas" & year>=1777, bw(2.5) lc(black) lp(solid))
	(scatter logComTax year if caja=="acapulco", mc(red) msize(tiny))
	(scatter logComTax year if caja=="zacatecas", mc(gray) msize(tiny))
	if logComTax!=0, xline(1777)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(1730(10)1810,labsize(2.5) nogrid) ylabel(2(2)15,labsize(2.5) nogrid) 
	title("") xtitle("Year", size(3.5))
	ytitle("Taxes on Trade (log pesos)", size(3.5)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("")
	legend(order(1 "Acapulco (Non-Mining)" 
	3 "Zacatecas (Mining)") size(3.5)
	cols(1) region(lcolor(white))  symxsize(*.5) pos(11) ring(0));
graph export "`figuresdir'Figure2_b.pdf", replace;
#delimit cr




		
		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		




