

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure B.2: Share of 
	**					Planted Area (2013) and Crop 
	**					Suitability (1961-1990) 
	**					(Barley, Cacao, Coffee, Cotton)
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
use "`datadir'Suit_Planted2013.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure B.2: Share of Planted Area (2013) & Crop Suitability (1961-1990)
*			  (Barley, Cacao, Coffee, Cotton)
*-------------------------------------------------------------------------------


local crops "barley cacao coffee cotton" 
foreach crop of local crops {
qui corr suit_`crop' sharesemb_sample_`crop'
local corr: display %6.2f `r(rho)'
qui reg sharesemb_sample_`crop' suit_`crop', r
local num `e(N)'
local beta: display %6.2f _b[suit_`crop']
local se: display %6.2f _se[suit_`crop']
local t = _b[suit_`crop']/_se[suit_`crop']
local pval: display %6.2f 2*ttail(e(df_r),abs(`t'))
local Crop=proper("`crop'")

#delimit;
qui su suit_`crop' if sharesemb_sample_`crop'!=.;
twoway (scatter sharesemb_sample_`crop' suit_`crop', 
		msymbol(O) mcolor(gs3) msize(tiny))
	(lfit sharesemb_sample_`crop' suit_`crop', 
		lcolor(black) lpattern(dash) lwidth(thick)) 
		if suit_`crop'<=`r(max)' & suit_`crop'>=`r(min)',
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) margin(vsmall))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
	title( "`Crop'")
	subtitle("Planted Area (%) = {&alpha} + {&beta}*Suitability + {&epsilon}"
	"{&beta} =`beta'; std. error =`se'; p-value =`pval'; N = `num'")
	ylabel(, labsize(3) nogrid) xlabel(,labsize(3) nogrid)
	xtitle("Average low input level rain-fed `crop' suitability (ton/ha, 1960-1990)", size(3.5))
	ytitle("Rain-fed `crop' surface area planted (%, 2013) ", size(4)) 
	xsca(noline titlegap(2) lcolor(white)) 
	ysca(noline titlegap(2) lcolor(white)) note("") legend(off);
	local figuresdir $figures;
	graph export "`figuresdir'13_FigureB2_`crop'.pdf", replace;
#delimit cr	
}
