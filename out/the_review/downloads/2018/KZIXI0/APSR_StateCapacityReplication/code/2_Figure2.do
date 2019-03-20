

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure 2: Price 
	**					Differential Before and After the 
	**					Great Depression
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
* Prepare price data
*-------------------------------------------------------------------------------


local datadir $data
use "`datadir'GFD_yearly.dta", clear

* Generate index where 1920-1928 Price Average = 100
local crops "rp_banana rp_coffeerio"
foreach lname of varlist `crops' {
	qui su `lname' if year>=1920 & year<1929
	gen i`lname'=(`lname'/`r(mean)')*100
}

* Label commodities
label var irp_banana "Banana"
label var irp_coffeerio "Coffee"







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 2: Price Differential Before and After the Great Depression
*-------------------------------------------------------------------------------


#delimit;
tsline irp_banana irp_coffeerio
	if year>=1920 & year<1941, xline(1929, lp(shortdash))
	graphregion(fcolor(white) lcolor(white) margin(vsmall))  	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) xtitle("Year", size(2.5)) caption("") note("") 
	ytitle("Yearly average spot prices (1920-1928 Avg.= 100)", size(2.5))
	xsca(titlegap(2) lcolor(white)) ysca(titlegap(2) lcolor(white))
	ylabel(, labsize(2.5) angle(horizontal) nogrid) 
	xlabel(, labsize(2.5) angle(horizontal) nogrid)
	legend(order(2 1 3) region(lcolor(white))
	size(3) symxsize(*.5) col(1) pos(2) ring(0)) xsize(8)
note("Source: Global Financial Data, from various primary sources.", size(2.5));
local figuresdir $figures;
graph export "`figuresdir'2_Figure2.pdf", replace;


