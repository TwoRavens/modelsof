

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure B.3: Commodity 
	**					Potential, 1910-1950
	**					
	**					
	** 
	**
	**				
	**		Version: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Prepare data
*-------------------------------------------------------------------------------


local datadir $data
use "`datadir'DYPanel_SuitPrices.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure B.3: Commodity Potential, 1910-1950
*-------------------------------------------------------------------------------


#delimit;
twoway (lpoly logwmean_shockrp_tr year if year<1930, lc(black) lp(solid))
	(lpoly logwmean_shockrp_tr year if year>=1930, lc(black) lp(solid))
	(lpoly logwmean_shockrp_ct year if year<1930, lc(black) lp(dash))
	(lpoly logwmean_shockrp_ct year if year>=1930, lc(black) lp(dash))
		if year>=1910 & year<=1950, xline(1929.8, lp(shortdash))
	graphregion(fcolor(white) lcolor(white) margin(vsmall))  	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) xtitle("Year", size(3.5)) caption("") note("") 
	ytitle("Commodity Potential (log)", size(3.5))
	xsca(titlegap(2) lcolor(white)) ysca(titlegap(2) lcolor(white))
	ylabel(, labsize(2.5) angle(horizontal) nogrid) 
	xlabel(, labsize(2.5) angle(horizontal) nogrid)
	legend(order(3 "Least Shocked" 1 "Most Shocked") 
	region(lcolor(white)) size(3) symxsize(*.5) col(1)pos(2)ring(0)) xsize(8);
	local figuresdir $figures;
	graph export "`figuresdir'16_FigureB3.pdf", replace;
#delimit cr

