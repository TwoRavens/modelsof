

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure 4: Parallel Trends 
	**					in Bureaucrats and Land Redistribution
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
* Prepare data: Panel a - Bureaucrats
*-------------------------------------------------------------------------------


local datadir $data
use "`datadir'DPanel_Mun1900.dta", clear

collapse (mean) apper1000 (sd) sd_apper1000=apper1000 						///
	(count) n_apper1000=apper1000, by(affected year)
drop if year==.




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 4 Panel a: Bureaucrats
*-------------------------------------------------------------------------------


gen se = sd_apper1000 / sqrt(n_apper1000)
gen ul = apper1000 + 1.95*se 
gen ll = apper1000 - 1.95*se 

#delimit;
twoway (connected apper1000 year if affected==1, 
	lpattern(solid) clcolor(black) msym(0) mc(black) msize(small)) 
	(rcap ll ul year if affected==1, 
		lpattern(solid) lcolor(black))
	(connected apper1000 year if affected==0, 
	lpattern(dash) clcolor(black) msym(S) mc(black) msize(small))  
	(rcap ll ul year if affected==0, lpattern(dash) lcolor(black)), 
	xline(1929.7, lp(shortdash))
	graphregion(fcolor(white) lcolor(white) margin(vsmall))  	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) xtitle("Year", size(3.5)) caption("") note("") 
	ytitle("Bureaucrats per 1000 people", size(3.5)) aspect(.55)
	xsca(titlegap(2) lcolor(white)) ysca(titlegap(2) lcolor(white))
	ylabel(0(1)6, labsize(2.5) angle(horizontal) nogrid) 
	xlabel(, labsize(2.5) angle(horizontal) nogrid)
	legend(order(1 "Most Shocked" 3 "Least shocked") region(lcolor(white)) 
	size(3) symxsize(*.5) col(1) pos(11) ring(0)) xsize(8);
	local figuresdir $figures;
	graph export "`figuresdir'6_Figure4_a.pdf", replace;
#delimit cr




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Prepare data: Panel b - Land Redistribution
*-------------------------------------------------------------------------------


local datadir $data
use "`datadir'DYPanel_SuitPrices.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 4 Panel b: Land Redistribution
*-------------------------------------------------------------------------------


qui su Shock1940
lpoly repartoriego year if  												///
	Shock1940<`r(mean)' & year<=1940 & year>=1920 & hac1930==1, 			///
	gen(x0 s0) ci se(se0)
* Get the 95% CIs *
gen ul0 = s0 + 1.95*se0
gen ll0 = s0 - 1.95*se0
label var s0 "Most Shocked"

qui su Shock1940
lpoly repartoriego year if 													///
	Shock1940>=`r(mean)' & year<=1940 & year>=1920 & hac1930==1, 			///
	gen(x1 s1) ci se(se1)
* Get the 95% CIs *
gen ul1 = s1 + 1.95*se1
gen ll1 = s1 - 1.95*se1
label var s1 "Least Shocked"

#delimit;
twoway (line ul0 ll0 s0 x0, lcolor(black black black) 
	lpattern(dot dot solid) clcolor(black black black))
	(line ul1 ll1 s1 x1, lcolor(black black black) 
	lpattern(dot dot dash) clcolor(black black black)), 
	xline(1929.7, lp(shortdash))
	graphregion(fcolor(white) lcolor(white) margin(vsmall))  	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) xtitle("Year", size(3.5)) caption("") note("") 
	ytitle("Land Grants", size(3.5)) aspect(.55)
	xsca(titlegap(2) lcolor(white)) ysca(titlegap(2) lcolor(white))
	ylabel(, labsize(2.5) angle(horizontal) nogrid) 
	xlabel(, labsize(2.5) angle(horizontal) nogrid)
	legend(order(3 "Most Shocked" 6 "Least Shocked") region(lcolor(white)) 
	size(3) symxsize(*.5) col(1) pos(11) ring(0)) xsize(8);
	local figuresdir $figures;
	graph export "`figuresdir'6_Figure4_b.pdf", replace;
#delimit cr
