

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure B.5: Copper 
	**					Prices, 1845-1864
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
use "`datadir'CopperChile.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure B.5: Prices, 1845-1864
*-------------------------------------------------------------------------------


tset mdate
#delimit;
twoway line Real_Close mdate, 
	xline(-1305, lp(shortdash)) xline(-1212, lp(shortdash)) 
	graphregion(fcolor(white) lcolor(white) margin(vsmall))  	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) xtitle("Year", size(3.5)) caption("") note("") 
	ytitle("High Grade Copper (Constant Dollars/Pound)", size(3.5)) aspect(.55)
	xsca(titlegap(2) lcolor(white)) ysca(titlegap(2) lcolor(white))
	ylabel(, labsize(2.5) angle(horizontal) nogrid) 
	xlabel(, labsize(2.5) angle(horizontal) nogrid)
	legend(off) xsize(8);
	local figuresdir $figures;
	graph export "`figuresdir'18_FigureB5.pdf", replace;
#delimit cr

